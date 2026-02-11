"""apps/core/views.py"""

from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Item
from .serializers import ItemSerializer


class ItemViewSet(viewsets.ModelViewSet):
    """ViewSet for Item model."""

    queryset = Item.objects.all()
    serializer_class = ItemSerializer

    @action(detail=False, methods=["get"])
    def recent(self, request):
        """Get recently created items."""
        recent_items = self.get_queryset()[:10]
        serializer = self.get_serializer(recent_items, many=True)
        return Response(serializer.data)
