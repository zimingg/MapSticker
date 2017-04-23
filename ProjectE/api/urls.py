from django.conf.urls import include, url
from rest_framework import routers
from rest_framework.authtoken import views as tokenviews
from . import views

router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet)
router.register(r'messages', views.MessageViewSet)
router.register(r'groups', views.GroupViewSet)

urlpatterns = [
               
               
               #url((r'^register/$',views.CreateUserView.as_view(),name='user'),
    url(r'^', include(router.urls)),
    url(r'^auth/', tokenviews.obtain_auth_token)
    # url(r'^auth/', include('rest_framework.urls'))
]
