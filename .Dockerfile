# Set the Python version as a build-time argument
ARG PYTHON_VERSION=3.12-slim-bullseye
FROM python:${PYTHON_VERSION}

# Create and activate a virtual environment
RUN python -m venv /opt/venv
ENV PATH=/opt/venv/bin:$PATH

# Upgrade pip
RUN /opt/venv/bin/pip install --upgrade pip

# Set Python-related environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install OS dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libjpeg-dev \
    libcairo2 \
    libcairo2-dev \
    libpango1.0-dev \
    libgif-dev \
    libopenjp2-7-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Create the application directory
RUN mkdir -p /code
WORKDIR /code

# Copy project source files first to improve caching
COPY ./src /code

# Copy requirements and install dependencies
COPY requirements.txt /tmp/requirements.txt
RUN /opt/venv/bin/pip install -r /tmp/requirements.txt

# Set the Django project name as an environment variable
ENV PROJ_NAME="django-saas"

# Create the startup script
RUN printf "#!/bin/bash\n" > ./paracord_runner.sh && \
    printf "RUN_PORT=\"\${PORT:-8000}\"\n\n" >> ./paracord_runner.sh && \
    printf "/opt/venv/bin/python manage.py migrate --no-input\n" >> ./paracord_runner.sh && \
    printf "/opt/venv/bin/gunicorn ${PROJ_NAME}.wsgi:application --bind \"0.0.0.0:\$RUN_PORT\"\n" >> ./paracord_runner.sh

# Make the startup script executable
RUN chmod +x paracord_runner.sh

# Run the Django project via the script
CMD ["sh", "-c", "./paracord_runner.sh"]
