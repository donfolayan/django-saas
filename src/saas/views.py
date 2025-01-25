import pathlib

from django.http import HttpResponse
from django.shortcuts import render

from visits.models import PageVisits

this_dir = pathlib.Path(__file__).resolve().parent

def home_view(request, *args, **kwargs):
    return about_view(request, *args, **kwargs)

def about_view(request, *args, **kwargs):
    my_title = "SaaS"
    
    qs = PageVisits.objects.all()
    page_qs = PageVisits.objects.filter(path=request.path)
    total_qs = qs.count()
    total_page_qs = page_qs.count()
    try:
        percentage_visits = round(((total_page_qs/total_qs) * 100), 2)
    except ZeroDivisionError:
        percentage_visits = 0

    page_context = {
        "page_title": my_title,
        "total_visits": total_qs,
        "page_visits": total_page_qs,
        "percentage_page_visits": percentage_visits
    }
    PageVisits.objects.create(path=request.path)

    return render(request, "home.html", page_context)