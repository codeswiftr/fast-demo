# Use a specific version of the Python image as the build image
FROM python:3.9-slim-buster AS build

# Set the working directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


# install peetry and native dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install poetry \
    && poetry config virtualenvs.create false

# Copy the poetry lock file and the pyproject file
COPY poetry.lock pyproject.toml /app/

# Install the project dependencies using wheels
RUN poetry export -o ${BUILD_ENVIRONMENT}.txt --without-hashes --dev && \
    pip wheel --wheel-dir /wheels -r ${BUILD_ENVIRONMENT}.txt
    

# Copy the rest of the application files
COPY . /app

# Use a specific version of the Alpine Linux image as the final image
FROM alpine:3.14

# Add a non-root user to run the application
RUN adduser -D appuser

# Set the working directory
WORKDIR /app

# Copy the installed dependencies from the build stage
COPY --from=build /wheels  /wheels/   
COPY --from=build /app /app


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
CMD ["uvicorn", "main:app", "--host", "$HOST", "--port", "$PORT"]

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD ["curl", "-f", "http://localhost:8000/healthcheck"]

# Add metadata to the image
LABEL maintainer="Bogdan Veliscu" \
      version="1.0" \
      description="FastAPI Application with Poetry and Alpine image"
