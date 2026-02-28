# Deployment Guide

This guide covers deploying the Semantic Image Search application using Docker and Hugging Face Spaces.

## Table of Contents

1. [Docker Deployment](#docker-deployment)
2. [Hugging Face Spaces Deployment](#hugging-face-spaces-deployment)
3. [Environment Variables](#environment-variables)
4. [Troubleshooting](#troubleshooting)

---

## Docker Deployment

### Prerequisites

- Docker installed ([Get Docker](https://docs.docker.com/get-docker/))
- Docker Compose installed (usually comes with Docker Desktop)
- `.env` file configured with your API keys

### Option 1: Using Docker Compose (Recommended)

This will run both the FastAPI backend and Streamlit frontend as separate services.

1. **Clone the repository:**
```bash
git clone https://github.com/tharun-reddy-ice/Semantic-Image-Search.git
cd Semantic-Image-Search
```

2. **Create your `.env` file:**
```bash
cp .env.example .env  # If you have an example file
# Or create manually with required variables (see Environment Variables section)
```

3. **Build and start the services:**
```bash
docker-compose up --build
```

4. **Access the application:**
   - Backend API: http://localhost:8000
   - API Documentation: http://localhost:8000/docs
   - Frontend UI: http://localhost:8501

5. **Stop the services:**
```bash
docker-compose down
```

### Option 2: Using Docker Directly

Build and run a single container:

```bash
# Build the image
docker build -t semantic-image-search .

# Run the backend
docker run -p 8000:8000 --env-file .env semantic-image-search

# Or run the frontend (in a separate terminal)
docker run -p 8501:8501 --env-file .env semantic-image-search \
  streamlit run semantic_image_search/ui/app.py --server.address 0.0.0.0 --server.port 8501
```

### Adding Your Images

To index your own images in Docker:

1. **Place images in the `images/` folder before building**
2. **Or mount a volume:**
```bash
docker run -p 8000:8000 \
  -v /path/to/your/images:/app/images \
  --env-file .env \
  semantic-image-search
```

---

## Hugging Face Spaces Deployment

### Prerequisites

- Hugging Face account ([Sign up](https://huggingface.co/join))
- Qdrant Cloud instance ([Get started](https://qdrant.tech/))
- OpenAI API key ([Get one](https://platform.openai.com/))

### Step-by-Step Deployment

1. **Create a new Space:**
   - Go to https://huggingface.co/new-space
   - Choose a name: `semantic-image-search`
   - Select SDK: **Docker**
   - Choose visibility (Public or Private)
   - Click "Create Space"

2. **Configure Secrets:**

   In your Space settings, add these secrets:

   ```
   QDRANT_URL=https://your-instance.cloud.qdrant.io
   QDRANT_API_KEY=your-qdrant-api-key
   QDRANT_COLLECTION=semantic-image-search
   VECTOR_SIZE=512
   OPENAI_API_KEY=your-openai-api-key
   OPENAI_MODEL=gpt-4o-mini
   CLIP_MODEL_NAME=ViT-B-32
   CLIP_CHECKPOINT=laion2b_s34b_b79k
   DEVICE=cpu
   ```

3. **Push your code:**

   ```bash
   # Add Hugging Face as a remote
   git remote add space https://huggingface.co/spaces/YOUR_USERNAME/semantic-image-search

   # Rename Dockerfile.hf to Dockerfile for Spaces
   mv Dockerfile Dockerfile.local
   mv Dockerfile.hf Dockerfile

   # Copy the Spaces README
   cp README_SPACES.md README.md

   # Commit and push
   git add .
   git commit -m "Deploy to Hugging Face Spaces"
   git push space main
   ```

4. **Wait for build:**
   - Hugging Face will automatically build your Docker container
   - This may take 5-10 minutes
   - Monitor build logs in the Space interface

5. **Access your Space:**
   - Your app will be live at: `https://huggingface.co/spaces/YOUR_USERNAME/semantic-image-search`

### Uploading Images to Spaces

For Hugging Face Spaces, you have a few options:

**Option 1: Include in Git (Small datasets)**
```bash
# Add images before pushing
mkdir -p images
# Add your images to the images/ folder
git add images/
git commit -m "Add sample images"
git push space main
```

**Option 2: Use Git LFS (Larger datasets)**
```bash
# Install git-lfs
git lfs install

# Track image files
git lfs track "images/**/*.jpg"
git lfs track "images/**/*.png"

# Add and commit
git add .gitattributes images/
git commit -m "Add images with LFS"
git push space main
```

**Option 3: Load from URL or Dataset**
Modify the code to download images from Hugging Face datasets or URLs on startup.

---

## Environment Variables

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `QDRANT_URL` | Qdrant instance URL | `https://xxx.cloud.qdrant.io` |
| `QDRANT_API_KEY` | Qdrant API key | `your-api-key` |
| `OPENAI_API_KEY` | OpenAI API key | `sk-...` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `QDRANT_COLLECTION` | Collection name | `semantic-image-search` |
| `VECTOR_SIZE` | Embedding dimension | `512` |
| `OPENAI_MODEL` | GPT model to use | `gpt-4o-mini` |
| `CLIP_MODEL_NAME` | CLIP model variant | `ViT-B-32` |
| `CLIP_CHECKPOINT` | CLIP checkpoint | `laion2b_s34b_b79k` |
| `DEVICE` | Compute device | `cpu` |
| `IMAGES_ROOT` | Path to images | `./images` |

### Example `.env` File

```env
# Qdrant Configuration
QDRANT_URL=https://your-instance.cloud.qdrant.io
QDRANT_API_KEY=your-qdrant-api-key
QDRANT_COLLECTION=semantic-image-search
VECTOR_SIZE=512

# OpenAI Configuration
OPENAI_API_KEY=sk-your-openai-api-key
OPENAI_MODEL=gpt-4o-mini

# CLIP Model Configuration
CLIP_MODEL_NAME=ViT-B-32
CLIP_CHECKPOINT=laion2b_s34b_b79k
DEVICE=cpu

# Path Configuration
IMAGES_ROOT=./images
QUERY_IMAGE_ROOT=./data/query_images
RETRIEVED_ROOT=./data/retrieved
```

---

## Troubleshooting

### Docker Issues

**Problem: Container exits immediately**
```bash
# Check logs
docker-compose logs backend
docker-compose logs frontend
```

**Problem: Port already in use**
```bash
# Change ports in docker-compose.yml
ports:
  - "8001:8000"  # Use different host port
```

**Problem: Out of memory**
```bash
# Increase Docker memory limit in Docker Desktop settings
# Or use smaller CLIP model:
CLIP_MODEL_NAME=ViT-B-16
```

### Hugging Face Spaces Issues

**Problem: Build fails**
- Check that Dockerfile.hf is renamed to Dockerfile
- Verify all dependencies in requirements.txt
- Check build logs for specific errors

**Problem: App crashes on startup**
- Verify all secrets are configured correctly
- Check that Qdrant URL is accessible
- Ensure OpenAI API key is valid

**Problem: Out of memory**
- Spaces have memory limits (16GB for free tier)
- Consider upgrading to paid tier
- Use CPU-only mode with smaller models

### General Issues

**Problem: Qdrant connection fails**
```bash
# Test connection
curl -X GET "https://your-instance.cloud.qdrant.io/collections" \
  -H "api-key: your-api-key"
```

**Problem: OpenAI API errors**
- Check API key is valid
- Verify you have credits
- Check rate limits

**Problem: CLIP model download fails**
- Ensure internet connection is stable
- May need to pre-download models
- Check disk space

---

## Performance Optimization

### For Docker

1. **Use multi-stage builds** (already implemented)
2. **Enable BuildKit:**
```bash
DOCKER_BUILDKIT=1 docker-compose build
```

3. **Use volume mounts for development:**
```yaml
volumes:
  - .:/app  # Live code reload
```

### For Hugging Face Spaces

1. **Pre-download models** in Dockerfile
2. **Use caching** for embeddings
3. **Optimize image sizes** before indexing
4. **Consider CPU optimization flags**

---

## Monitoring and Logs

### Docker

```bash
# View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Check health status
docker-compose ps

# Execute commands in container
docker-compose exec backend bash
```

### Hugging Face Spaces

- View logs in the Space interface
- Use the "Logs" tab for real-time monitoring
- Check build logs for deployment issues

---

## Next Steps

- [ ] Set up monitoring (Prometheus, Grafana)
- [ ] Add authentication for production use
- [ ] Implement caching layer (Redis)
- [ ] Set up CI/CD pipeline
- [ ] Add automated tests
- [ ] Configure backup strategy for Qdrant

## Support

For issues and questions:
- GitHub Issues: https://github.com/tharun-reddy-ice/Semantic-Image-Search/issues
- Hugging Face Discussions: Enable in your Space settings
