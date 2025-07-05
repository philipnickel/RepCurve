from django.db import models
from django.contrib.auth.models import User


class Exercise(models.Model):
    name = models.CharField(max_length=100)
    category = models.CharField(max_length=50, choices=[
        ('squat', 'Squat'),
        ('bench', 'Bench Press'),
        ('deadlift', 'Deadlift'),
        ('accessory', 'Accessory'),
    ])
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

    class Meta:
        ordering = ['name']


class WorkoutTemplate(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    exercises = models.ManyToManyField(Exercise, through='TemplateExercise')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.user.username} - {self.name}"

    class Meta:
        ordering = ['-created_at']


class TemplateExercise(models.Model):
    template = models.ForeignKey(WorkoutTemplate, on_delete=models.CASCADE)
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    target_sets = models.PositiveIntegerField()
    target_reps = models.PositiveIntegerField()
    target_weight = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)
    rest_seconds = models.PositiveIntegerField(default=180)
    notes = models.TextField(blank=True)
    order = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ['order']
        unique_together = ['template', 'exercise']


class ScheduledWorkout(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    template = models.ForeignKey(WorkoutTemplate, on_delete=models.CASCADE)
    scheduled_date = models.DateField()
    notes = models.TextField(blank=True)
    is_completed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.template.name} - {self.scheduled_date}"

    class Meta:
        ordering = ['-scheduled_date']
        unique_together = ['user', 'scheduled_date', 'template']


class WorkoutLog(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    scheduled_workout = models.ForeignKey(ScheduledWorkout, on_delete=models.CASCADE, null=True, blank=True)
    workout_name = models.CharField(max_length=100)
    date = models.DateTimeField()
    duration_minutes = models.PositiveIntegerField(null=True, blank=True)
    notes = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.workout_name} - {self.date.date()}"

    class Meta:
        ordering = ['-date']


class ExerciseLog(models.Model):
    workout_log = models.ForeignKey(WorkoutLog, on_delete=models.CASCADE, related_name='exercise_logs')
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    notes = models.TextField(blank=True)
    order = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ['order']


class SetLog(models.Model):
    exercise_log = models.ForeignKey(ExerciseLog, on_delete=models.CASCADE, related_name='set_logs')
    set_number = models.PositiveIntegerField()
    reps = models.PositiveIntegerField()
    weight = models.DecimalField(max_digits=6, decimal_places=2)
    rpe = models.PositiveIntegerField(null=True, blank=True, help_text="Rate of Perceived Exertion (1-10)")
    notes = models.TextField(blank=True)

    @property
    def estimated_1rm(self):
        """Calculate estimated 1RM using Epley formula"""
        return float(self.weight) * (1 + float(self.reps) / 30)

    def __str__(self):
        return f"Set {self.set_number}: {self.reps}x{self.weight}"

    class Meta:
        ordering = ['set_number']
        unique_together = ['exercise_log', 'set_number']
