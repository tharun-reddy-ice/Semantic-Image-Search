---
title: Semantic Image Search
emoji: 🔍
colorFrom: blue
colorTo: purple
sdk: docker
pinned: false
license: other
app_port: 7860
---

# Semantic Image Search

A powerful semantic image search engine using CLIP embeddings, Qdrant vector database, and LLM-powered query translation.

## Features

- 🔍 **Text-to-Image Search**: Find images using natural language
- 🖼️ **Image-to-Image Search**: Find similar images by uploading an image
- 🤖 **AI-Powered Query Enhancement**: Automatic query translation using GPT
- ⚡ **Fast Vector Search**: Powered by Qdrant vector database
- 🎨 **Interactive UI**: Easy-to-use Streamlit interface

## How to Use

### Search by Text
1. Go to the "Search by Text" tab
2. Enter a natural language query (e.g., "sunset over mountains")
3. Adjust the number of results with the slider
4. Click "Search Images" to see results

### Search by Image
1. Go to the "Search by Image" tab
2. Upload an image file (JPG, PNG, or WEBP)
3. Adjust the number of results
4. Click "Find Similar Images"

## Configuration

To use this space, you need to configure the following secrets:

- `QDRANT_URL`: Your Qdrant instance URL
- `QDRANT_API_KEY`: Your Qdrant API key
- `OPENAI_API_KEY`: Your OpenAI API key

## Technologies

- OpenCLIP for embeddings
- Qdrant for vector search
- FastAPI backend
- Streamlit frontend
- OpenAI GPT for query enhancement

## Local Development

See the main [README.md](./README.md) for local setup instructions.
