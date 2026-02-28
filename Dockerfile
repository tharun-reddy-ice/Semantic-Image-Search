# Multi-stage Dockerfile for Semantic Image Search
FROM python:3.11-slim as base

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
COPY pyproject.toml .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Install the package
RUN pip install -e .

# Create necessary directories
RUN mkdir -p /app/images /app/data/query_images /app/data/retrieved

# Expose ports for FastAPI and Streamlit
EXPOSE 8000 8501

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV DEVICE=cpu

# Default command (can be overridden in docker-compose)
CMD ["uvicorn", "semantic_image_search.backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
