from rest_framework import serializers
from pets.models import Pets
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class PetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pets
        fields = ['id', 'name', 'age', 'description', 'local', 'image', 'created_by']  
        read_only_fields = ['created_by']