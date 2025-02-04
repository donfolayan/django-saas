import helpers

from typing import Any
from django.core.management.base import BaseCommand

VENDOR_STATICFILES = {
    "flowbite.min.css": "https://cdn.jsdelivr.net/npm/flowbite@3.1.1/dist/flowbite.min.css",
    "flowbite.min.js": "https://cdn.jsdelivr.net/npm/flowbite@3.1.1/dist/flowbite.min.js",
}


class Command(BaseCommand):
    def handle(self, *args: Any, **options: Any):
        self.stdout.write("Downloading vendor static files")

        for name, url in VENDOR_STATICFILES.items():
            self.stdout.write(name, url)