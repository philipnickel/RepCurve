from django.urls import path
from . import views

urlpatterns = [
    path('health/', views.api_health, name='api_health'),
    path('info/', views.api_info, name='api_info'),
]