# Use the laixintao/fortune-mod image as the base image
FROM laixintao/fortune-mod:latest

# Install prerequisites
RUN apt-get update && apt-get install -y \
    cowsay \
    netcat-openbsd \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory as /app
WORKDIR /app

# Copy the wisecow script into the container
COPY wisecow.sh /app/wisecow.sh

# Make the wisecow script executable
RUN chmod +x /app/wisecow.sh

# Expose the port 4499 that the app will run on
EXPOSE 4499

# Set the command to run wisecow
CMD ["/app/wisecow.sh"]
