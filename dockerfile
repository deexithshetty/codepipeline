# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Install NGINX
RUN apt-get update && apt-get install -y nginx

# Copy the index.html file to the default NGINX html location
COPY app/index.html /var/www/html/index.html

# Expose port 80 to the outside world
EXPOSE 80

# Start NGINX when the container launches
CMD ["nginx", "-g", "daemon off;"]
