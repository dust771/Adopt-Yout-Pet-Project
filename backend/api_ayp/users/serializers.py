from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import CustomUser

class UserSerializer(serializers.ModelSerializer):

    class Meta:

        model = CustomUser
        fields = ['id', 'username', 'email', 'password', 'first_name', 'last_name', 'avatar']
        extra_kwargs = {
            'password': {'write_only': True}
        }
    
    def create(self, validated_data):

        user = CustomUser(
            username=validated_data['username'],
            email=validated_data['email'],
        )
        user.set_password(validated_data['password'])
        user.save()
        return user

class MyTokenObtainPairSerializer(TokenObtainPairSerializer):

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token['user_id'] = user.id
        return token
    
    def validate(self, attrs):
        data = super().validate(attrs)
        data['user_id'] = self.user.id
        return data