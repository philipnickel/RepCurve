from django.urls import path, include
from rest_framework.routers import DefaultRouter
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView, SpectacularRedocView
from . import views

router = DefaultRouter()
router.register(r'exercises', views.ExerciseViewSet)
router.register(r'workout-templates', views.WorkoutTemplateViewSet, basename='workout-templates')
router.register(r'scheduled-workouts', views.ScheduledWorkoutViewSet, basename='scheduled-workouts')
router.register(r'workout-logs', views.WorkoutLogViewSet, basename='workout-logs')

urlpatterns = [
    # API Documentation
    path('schema/', SpectacularAPIView.as_view(), name='schema'),
    path('docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
    
    # Health and info endpoints
    path('health/', views.api_health, name='api_health'),
    path('info/', views.api_info, name='api_info'),
    
    # Authentication endpoints
    path('auth/register/', views.register, name='register'),
    path('auth/login/', views.login, name='login'),
    path('auth/logout/', views.logout, name='logout'),
    path('auth/profile/', views.profile, name='profile'),
    
    # Calendar view
    path('calendar/', views.calendar_workouts, name='calendar-workouts'),
    
    # Complete workout
    path('scheduled-workouts/<int:pk>/complete/', views.complete_scheduled_workout, name='complete-workout'),
    
    # Include router URLs
    path('', include(router.urls)),
]