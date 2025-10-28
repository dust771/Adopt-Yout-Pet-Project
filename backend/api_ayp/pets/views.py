from django.shortcuts import render
from rest_framework import viewsets, permissions, filters
from django_filters.rest_framework import DjangoFilterBackend
from .models import Pets
from .serializers import PetSerializer
from .permissions import IsOwnerOrReadOnly

class PetViewSet(viewsets.ModelViewSet):
    queryset = Pets.objects.all()
    serializer_class = PetSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrReadOnly]
    search_fields = ['name', 'age', 'local']
    ordering_fields = ['age', 'local']
    ordering = ['name']

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)