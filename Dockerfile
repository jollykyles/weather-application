# Use a lightweight Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file first (to leverage Docker layer caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code, including static and templates folders
COPY . .

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["python", "app.py"]
