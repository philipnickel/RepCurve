from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from .models import (
    Exercise, WorkoutTemplate, TemplateExercise, 
    ScheduledWorkout, WorkoutLog, ExerciseLog, SetLog
)


class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)
    password_confirm = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'password_confirm', 'first_name', 'last_name')

    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError("Passwords don't match")
        return attrs

    def create(self, validated_data):
        validated_data.pop('password_confirm')
        user = User.objects.create_user(**validated_data)
        return user


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name', 'last_name', 'date_joined')
        read_only_fields = ('id', 'date_joined')


class LoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()

    def validate(self, attrs):
        username = attrs.get('username')
        password = attrs.get('password')

        if username and password:
            user = authenticate(username=username, password=password)
            if not user:
                raise serializers.ValidationError('Invalid credentials')
            if not user.is_active:
                raise serializers.ValidationError('User account is disabled')
            attrs['user'] = user
            return attrs
        else:
            raise serializers.ValidationError('Must include username and password')


class ExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Exercise
        fields = '__all__'


class SetLogSerializer(serializers.ModelSerializer):
    estimated_1rm = serializers.ReadOnlyField()

    class Meta:
        model = SetLog
        fields = '__all__'


class ExerciseLogSerializer(serializers.ModelSerializer):
    set_logs = SetLogSerializer(many=True, read_only=True)
    exercise_name = serializers.CharField(source='exercise.name', read_only=True)

    class Meta:
        model = ExerciseLog
        fields = '__all__'


class WorkoutLogSerializer(serializers.ModelSerializer):
    exercise_logs = ExerciseLogSerializer(many=True, read_only=True)
    user_name = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = WorkoutLog
        fields = '__all__'
        read_only_fields = ('user',)


class TemplateExerciseSerializer(serializers.ModelSerializer):
    exercise_name = serializers.CharField(source='exercise.name', read_only=True)
    exercise_category = serializers.CharField(source='exercise.category', read_only=True)

    class Meta:
        model = TemplateExercise
        fields = '__all__'


class WorkoutTemplateSerializer(serializers.ModelSerializer):
    template_exercises = serializers.SerializerMethodField()
    user_name = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = WorkoutTemplate
        fields = '__all__'
        read_only_fields = ('user',)

    def get_template_exercises(self, obj):
        template_exercises = TemplateExercise.objects.filter(template=obj).order_by('order')
        return TemplateExerciseSerializer(template_exercises, many=True).data


class ScheduledWorkoutSerializer(serializers.ModelSerializer):
    template_name = serializers.CharField(source='template.name', read_only=True)
    user_name = serializers.CharField(source='user.username', read_only=True)
    template_details = WorkoutTemplateSerializer(source='template', read_only=True)

    class Meta:
        model = ScheduledWorkout
        fields = '__all__'
        read_only_fields = ('user',)


class WorkoutLogCreateSerializer(serializers.ModelSerializer):
    exercise_logs = ExerciseLogSerializer(many=True, required=False)

    class Meta:
        model = WorkoutLog
        fields = '__all__'
        read_only_fields = ('user',)

    def create(self, validated_data):
        exercise_logs_data = validated_data.pop('exercise_logs', [])
        workout_log = WorkoutLog.objects.create(**validated_data)
        
        for exercise_log_data in exercise_logs_data:
            set_logs_data = exercise_log_data.pop('set_logs', [])
            exercise_log = ExerciseLog.objects.create(workout_log=workout_log, **exercise_log_data)
            
            for set_log_data in set_logs_data:
                SetLog.objects.create(exercise_log=exercise_log, **set_log_data)
        
        return workout_log