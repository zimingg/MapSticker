from django.conf import settings
from django.db import models

class Message(models.Model):
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='messages', on_delete=models.CASCADE)
    content = models.CharField(max_length = 1000)

    
    
    image = models.CharField(max_length=500, blank = True) # Should be able to upload message without image at all.
    create_timestamp = models.DateTimeField(auto_now_add = True)
    modified_timestamp = models.DateTimeField(auto_now = True)


    name = models.CharField(max_length=200,blank = True)
    description = models.CharField(max_length = 1000, blank = True)
    latitude = models.FloatField()
    longitude = models.FloatField()
