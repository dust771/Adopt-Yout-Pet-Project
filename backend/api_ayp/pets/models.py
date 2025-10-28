from django.db import models
from users.models import CustomUser

class Pets(models.Model):

    name  = models.CharField(max_length=200, null=False, blank=False)
    age = models.IntegerField(max_length=30, null=False, blank=False)
    description = models.TextField(max_length=1000, null=False, blank=False)
    local = models.CharField(max_length=200, null=False, blank=False)
    image = models.ImageField(upload_to='pets/', blank=False)
    created_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE)

    def __str__(self):
        return self.name