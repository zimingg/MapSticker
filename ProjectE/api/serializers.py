from rest_framework import serializers
from django.contrib.auth.models import User, Group
from .models import Message
from django.contrib.auth import get_user_model

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only = True)
        
    def create(self, validated_data):
        user = get_user_model().objects.create(
        username = validated_data['username']
        )
        user.set_password(validated_data['password'])
        user.save()
        return user
        
    class Meta:
      model = get_user_model()
      fields = ('url', 'username', 'email', 'groups', 'password')
#write_only_fields = ('password',)





class GroupSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Group
        fields = ('url', 'name')

class MessageSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')

    class Meta:
        model = Message
        fields = ('id', 'owner', 'content', 'image', 'create_timestamp', 'modified_timestamp', 'latitude', 'longitude','name','description')
