from django.core.management.base import BaseCommand
from workouts.models import Exercise


class Command(BaseCommand):
    help = 'Populate the database with common powerlifting exercises'

    def handle(self, *args, **options):
        exercises = [
            # Squat variations
            ('Back Squat', 'squat', 'Standard barbell back squat'),
            ('Front Squat', 'squat', 'Barbell front squat'),
            ('Goblet Squat', 'squat', 'Dumbbell goblet squat'),
            ('Bulgarian Split Squat', 'squat', 'Single leg split squat'),
            
            # Bench Press variations
            ('Bench Press', 'bench', 'Standard barbell bench press'),
            ('Incline Bench Press', 'bench', 'Incline barbell bench press'),
            ('Dumbbell Bench Press', 'bench', 'Dumbbell bench press'),
            ('Close Grip Bench Press', 'bench', 'Close grip barbell bench press'),
            
            # Deadlift variations
            ('Deadlift', 'deadlift', 'Standard barbell deadlift'),
            ('Romanian Deadlift', 'deadlift', 'Romanian deadlift'),
            ('Sumo Deadlift', 'deadlift', 'Sumo stance deadlift'),
            ('Trap Bar Deadlift', 'deadlift', 'Hex/trap bar deadlift'),
            
            # Accessory exercises
            ('Overhead Press', 'accessory', 'Standing barbell overhead press'),
            ('Pull-ups', 'accessory', 'Bodyweight pull-ups'),
            ('Dips', 'accessory', 'Bodyweight or weighted dips'),
            ('Barbell Rows', 'accessory', 'Bent over barbell rows'),
            ('Lateral Raises', 'accessory', 'Dumbbell lateral raises'),
            ('Bicep Curls', 'accessory', 'Barbell or dumbbell bicep curls'),
            ('Tricep Extensions', 'accessory', 'Overhead tricep extensions'),
            ('Leg Press', 'accessory', 'Machine leg press'),
            ('Leg Curls', 'accessory', 'Hamstring leg curls'),
            ('Calf Raises', 'accessory', 'Standing or seated calf raises'),
        ]

        created_count = 0
        for name, category, description in exercises:
            exercise, created = Exercise.objects.get_or_create(
                name=name,
                defaults={
                    'category': category,
                    'description': description,
                }
            )
            if created:
                created_count += 1
                self.stdout.write(f'Created exercise: {name}')

        self.stdout.write(
            self.style.SUCCESS(f'Successfully created {created_count} exercises')
        )