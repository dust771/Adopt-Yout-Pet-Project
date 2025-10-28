from rest_framework import serializers
from .models import Message
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class MessageSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Message
        fields = ['id', 'name', 'email', 'subject', 'created_by']
        read_only_fields = ['created_by']