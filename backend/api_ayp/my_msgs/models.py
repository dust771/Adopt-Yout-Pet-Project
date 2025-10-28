from django.db import models
from users.models import CustomUser

class Message(models.Model):

    name = models.CharField(max_length=50, null=False, blank=False)
    email = models.EmailField(max_length=100, null=False, blank=False)
    subject = models.TextField(max_length=1000, null=False, blank=False)
    created_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE)

    def __str__(self):
        return self.name
