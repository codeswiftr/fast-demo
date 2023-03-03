ARG PYTHON_VERSION=3.10
ARG VARIANT=buster

# Use a specific version of the Python image as the build image
FROM python:${PYTHON_VERSION}-${VARIANT} AS build

# Set the working directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1 \
    PYTHONUNBUFFERED 1

# Copy the poetry lock file and the pyproject file
COPY poetry.lock pyproject.toml /app/

# install peetry and native dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential \
    && pip install poetry \
    && poetry env info
RUN poetry export -o requirements.txt --without-hashes \
    && cat requirements.txt

RUN pip wheel --wheel-dir /app/wheels -r requirements.txt

# Copy the rest of the application files
COPY . /app

# Use a specific version of the Alpine Linux image as the final image
FROM python:${PYTHON_VERSION}-slim

# Add a non-root user to run the application
RUN useradd -ms /bin/bash appuser

# Copy the installed dependencies from the build stage
#COPY --from=build /app/.venv/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Set the working directory
WORKDIR /app

# Copy the installed dependencies from the build stage
#COPY --from=build /app/.venv/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=build /app/wheels /wheels/
COPY --from=build --chown=appuser:appuser /app /app

# Install the dependencies from wheels
RUN pip install --no-cache-dir --no-index --find-links=/wheels/* /wheels/* \
    && apt update && apt install -y netcat 

# Expose the port that the application will run on
EXPOSE 8000

# Set environment variable for the application
ENV DATABASE_URL postgresql://user:password@postgres:5432/db
ENV HOST 0.0.0.0
ENV PORT 8000
ENV GREETING Hello, World!

# Run the application as the non-root user
USER appuser

# Start the application
#CMD ["uvicorn", "app.main:app", "--host", "$HOST", "--port", "$PORT"]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]  

# Add healthcheck
# HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
#     CMD ["curl", "-f", "http://localhost:8000/health"]

# Add metadata to the image
LABEL maintainer="Bogdan Veliscu" \
    version="1.0" \
    description="FastAPI Application with Poetry and Alpine image"
