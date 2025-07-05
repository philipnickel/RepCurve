from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status


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
