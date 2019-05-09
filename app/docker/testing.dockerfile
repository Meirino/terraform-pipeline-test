FROM node:latest
ARG VERSION=0.0.1

# Copy the application files
WORKDIR /usr/src/app
COPY .. /usr/src/app/
LABEL version=$VERSION

# Download the required packages for production
RUN npm update

# Make the application run when running the container
CMD ["npm", "test"]