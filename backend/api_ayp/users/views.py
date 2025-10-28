from rest_framework import viewsets, permissions
from rest_framework_simplejwt.views import TokenObtainPairView
from .models import CustomUser
from .serializers import MyTokenObtainPairSerializer, UserSerializer


class UserViewSet(viewsets.ModelViewSet):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]  # precisa estar logado pra tudo, exceto create

    def get_queryset(self):
        user = self.request.user
        # ✅ se for admin (is_superuser ou is_staff), vê todos
        if user.is_superuser or user.is_staff:
            return CustomUser.objects.all()
        # ✅ se for user normal, vê apenas o próprio registro
        return CustomUser.objects.filter(id=user.id)

    def get_permissions(self):
        # ✅ permite criar sem autenticação (registro)
        if self.action == 'create':
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]


class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer
