FROM python:3.9-alpine3.13
LABEL maintainer="poomipat.sr@gmail.com"

# Don't buffer output
ENV PYTHONUNBUFFERED 1

# Copy requirements to /tmp
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy our app to the image
COPY ./app /app

# Set app location path
WORKDIR /app

# Expose port 8000
EXPOSE 8000

# Argument to control dev or prod
ARG DEV=false

# Create virtual environment and install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt

# Install development dependencies if ARG DEV is true
RUN if [ "$DEV" = "true" ]; then \
    /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi

# Clean up /tmp directory and create a non-root user
RUN rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Set PATH
ENV PATH="/py/bin:$PATH"

# Switch to django user
USER django-user
