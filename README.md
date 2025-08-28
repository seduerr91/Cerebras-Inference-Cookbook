# LLM Real-Time News Analysis

![Real-Time News Analysis in Action](docs/images/cerebras_realtime_analysis.gif)

This project provides a real-time news analysis pipeline using Google News, FastAPI, Streamlit, and a large language model. It fetches the latest news articles, analyzes them to extract key insights, and presents them through a user-friendly web interface.

For a detailed explanation of the system design, purpose, and cost analysis, please see the [System Design Document](./docs/system_design.md).

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Installation](#1-installation)
  - [Environment Setup](#2-environment-setup)
  - [Running the Application](#3-running-the-application)
- [Docker Deployment](#4-docker-deployment-optional)

## Features

- **Real-Time News Fetching**: Gathers the latest news articles from Google News.
- **LLM-Powered Analysis**: Utilizes a large language model to analyze articles for sentiment, key topics, and summaries.
- **Web-Based UI**: An interactive Streamlit application to display the analysis results.
- **RESTful API**: A FastAPI backend provides endpoints for news data and analysis.
- **Containerized Deployment**: Docker support for easy and consistent deployment.

## Project Structure

```
.
├── backend/         # FastAPI backend source code
├── docs/            # Project documentation
├── .env             # Environment variables (API keys, etc.)
├── .gitignore       # Files to be ignored by Git
├── Dockerfile       # Docker configuration
├── README.md        # This file
└── pyproject.toml   # Project dependencies
```

## Quick Start

### Prerequisites

- Python 3.9+
- `uv` package manager (`pip install uv`)
- Docker (optional, for containerized deployment)

### 1. Installation

Clone the repository and install the dependencies using `uv`:

```bash
git clone https://github.com/seduerr91/inference-examples
cd llm-realtime-news-analysis
uv pip install -e .
```

### 2. Environment Setup

Copy the example `.env.example` file to `.env` and add your `CEREBRAS_API_KEY`. The `.env` file is included in `.gitignore` to prevent leaking sensitive information.

```bash
cp .env.example .env
# Now, edit .env with your key
```

### 3. Running the Application

**Start the Backend Service:**

```bash
just run-backend
```

**Run the Frontend UI:**

In a new terminal, launch the Streamlit app:

```bash
just run-frontend
```

Navigate to `http://localhost:8501` to view the application.

## 4. Docker Deployment (Optional)

Build and run the backend service using Docker:

```bash
just build-docker
just run-docker
```
