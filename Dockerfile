## Step 1: pull official base image from DockerHub
FROM node:13.12.0-alpine
 
## Step 2: set the working dir inside our Docker image
WORKDIR /app
 
## Step 3: Copies package.json and package-lock.json to our Docker image
COPY package*.json ./
 
## Step 4: Install all npm dependencies
RUN yarn install
 
## Step 5: Copies everything over to our Docker environment
COPY . ./

## Step 6: Expose port number
EXPOSE 3000

## Step 7: Sets the command to be run when running our Docker image.
CMD [ "yarn", "start" ]