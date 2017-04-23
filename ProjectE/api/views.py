from django.contrib.auth.models import User, Group
from .models import Message
from rest_framework.permissions import IsAuthenticated, AllowAny #add
from rest_framework import viewsets, generics
from .serializers import UserSerializer, GroupSerializer, MessageSerializer
from rest_framework import permissions
from .permissions import IsOwnerOrReadOnly
from django.contrib.auth import get_user_model #added
from rest_framework.generics import CreateAPIView #added

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer

class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer

class MessageViewSet(viewsets.ModelViewSet):
    permission_classes = (permissions.IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly)
    queryset = Message.objects.all()
    serializer_class = MessageSerializer

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

class CreateUserView(CreateAPIView):
    model = get_user_model()
    permissions_class = (AllowAny,)
    serializer_class = UserSerializer
