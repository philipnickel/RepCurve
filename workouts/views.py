from rest_framework import generics, status, viewsets
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User
from django.utils import timezone
from datetime import date, timedelta
from .models import (
    Exercise, WorkoutTemplate, TemplateExercise, 
    ScheduledWorkout, WorkoutLog, ExerciseLog, SetLog
)
from .serializers import (
    UserRegistrationSerializer, UserSerializer, LoginSerializer,
    ExerciseSerializer, WorkoutTemplateSerializer, ScheduledWorkoutSerializer,
    WorkoutLogSerializer, WorkoutLogCreateSerializer
)


# Health and Info endpoints
@api_view(['GET'])
@permission_classes([AllowAny])
def api_health(request):
    """Health check endpoint for API"""
    return Response({
        'status': 'healthy',
        'message': 'RepCurve API is running'
    })


@api_view(['GET'])
@permission_classes([AllowAny])
def api_info(request):
    """API information endpoint"""
    return Response({
        'name': 'RepCurve API',
        'version': '1.0.0',
        'description': 'API for tracking powerlifting training'
    })


@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    serializer = UserRegistrationSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'user': UserSerializer(user).data,
            'token': token.key
        }, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    serializer = LoginSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'user': UserSerializer(user).data,
            'token': token.key
        })
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout(request):
    try:
        request.user.auth_token.delete()
        return Response({'message': 'Successfully logged out'})
    except:
        return Response({'error': 'Error logging out'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def profile(request):
    serializer = UserSerializer(request.user)
    return Response(serializer.data)


class ExerciseViewSet(viewsets.ModelViewSet):
    queryset = Exercise.objects.all()
    serializer_class = ExerciseSerializer
    permission_classes = [IsAuthenticated]


class WorkoutTemplateViewSet(viewsets.ModelViewSet):
    serializer_class = WorkoutTemplateSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return WorkoutTemplate.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class ScheduledWorkoutViewSet(viewsets.ModelViewSet):
    serializer_class = ScheduledWorkoutSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = ScheduledWorkout.objects.filter(user=self.request.user)
        
        # Filter by date range if provided
        start_date = self.request.query_params.get('start_date', None)
        end_date = self.request.query_params.get('end_date', None)
        
        if start_date:
            queryset = queryset.filter(scheduled_date__gte=start_date)
        if end_date:
            queryset = queryset.filter(scheduled_date__lte=end_date)
            
        return queryset

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def calendar_workouts(request):
    """Get workouts for calendar view - current month by default"""
    year = request.query_params.get('year', timezone.now().year)
    month = request.query_params.get('month', timezone.now().month)
    
    try:
        year = int(year)
        month = int(month)
    except ValueError:
        return Response({'error': 'Invalid year or month'}, status=status.HTTP_400_BAD_REQUEST)
    
    # Get first and last day of the month
    first_day = date(year, month, 1)
    if month == 12:
        last_day = date(year + 1, 1, 1) - timedelta(days=1)
    else:
        last_day = date(year, month + 1, 1) - timedelta(days=1)
    
    scheduled_workouts = ScheduledWorkout.objects.filter(
        user=request.user,
        scheduled_date__gte=first_day,
        scheduled_date__lte=last_day
    )
    
    serializer = ScheduledWorkoutSerializer(scheduled_workouts, many=True)
    return Response(serializer.data)


class WorkoutLogViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return WorkoutLog.objects.filter(user=self.request.user)

    def get_serializer_class(self):
        if self.action == 'create':
            return WorkoutLogCreateSerializer
        return WorkoutLogSerializer

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def complete_scheduled_workout(request, pk):
    """Mark a scheduled workout as completed and optionally create a workout log"""
    try:
        scheduled_workout = ScheduledWorkout.objects.get(pk=pk, user=request.user)
    except ScheduledWorkout.DoesNotExist:
        return Response({'error': 'Scheduled workout not found'}, status=status.HTTP_404_NOT_FOUND)
    
    scheduled_workout.is_completed = True
    scheduled_workout.save()
    
    # Create workout log if provided
    if 'workout_log' in request.data:
        workout_log_data = request.data['workout_log']
        workout_log_data['scheduled_workout'] = scheduled_workout.id
        workout_log_data['workout_name'] = scheduled_workout.template.name
        workout_log_data['date'] = timezone.now()
        
        serializer = WorkoutLogCreateSerializer(data=workout_log_data)
        if serializer.is_valid():
            workout_log = serializer.save(user=request.user)
            return Response({
                'scheduled_workout': ScheduledWorkoutSerializer(scheduled_workout).data,
                'workout_log': WorkoutLogSerializer(workout_log).data
            })
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    return Response(ScheduledWorkoutSerializer(scheduled_workout).data)
