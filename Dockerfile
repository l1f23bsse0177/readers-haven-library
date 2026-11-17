# Stage 1: Build the website
FROM node:22-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy website source code and styles
COPY src/ ./src/
COPY styles/ ./styles/

# Build the website using Parcel
RUN npm run build

# Stage 2: Serve the website using Nginx
FROM nginx:1.27-alpine

# Copy the production build from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose the Nginx web server port
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
