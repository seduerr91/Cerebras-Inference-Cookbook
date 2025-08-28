# --- Stage 1: Build Stage ---
# Use an official Python image as a parent image.
# The 'slim' variant is smaller than the default.
FROM python:3.11-slim as builder

# Set the working directory in the container.
WORKDIR /app

# Install uv, the fast package manager.
RUN pip install uv

# Copy the dependency definition file and source code.
COPY pyproject.toml ./
COPY backend/ ./backend/

# Install dependencies into a virtual environment using uv.
# This creates a self-contained environment within the image.
RUN uv venv /app/venv && \
    . /app/venv/bin/activate && \
    uv pip install --no-cache-dir .

# --- Stage 2: Final Stage ---
# Use a lean base image for the final production container.
FROM python:3.11-slim

# Set the working directory.
WORKDIR /app

# Copy the virtual environment from the builder stage.
# This is more efficient than reinstalling everything.
COPY --from=builder /app/venv ./venv

# Copy the application code.
COPY backend/ ./backend/

# Copy the environment file example.
# Note: In a real production scenario, secrets should be managed securely,
# for example, with Docker secrets or a cloud provider's secret manager.
COPY .env.example ./

# Activate the virtual environment by adding its bin to the PATH.
ENV PATH="/app/venv/bin:$PATH"

# Expose the port the app runs on.
EXPOSE 8000

# Define the command to run the application.
# The server is started with uvicorn, listening on all interfaces (0.0.0.0).
CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
