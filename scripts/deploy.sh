#!/bin/bash

# Define variables
REPOSITORY_NAME=demo-repo
AWS_REGION=ap-south-1
ACCOUNT_ID=992382382321

# Function to get the latest image tag
get_latest_image_tag() {
  aws ecr describe-images --repository-name $REPOSITORY_NAME --region $AWS_REGION \
  --query 'sort_by(imageDetails,&imagePushedAt)[-1].imageTags[0]' --output text
}

# Fetch the latest image tag
IMAGE_TAG=$(get_latest_image_tag)

# Log in to Amazon ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Pull the latest Docker image
docker pull $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG

# Stop the running container (if any)
docker stop codedeploy || true
docker rm codedeploy || true

# Start a new container with the pulled image
docker run -d --name codedeploy -p 8080:80 $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG

# Restart the web server (if needed)
sudo systemctl restart nginx
