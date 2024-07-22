#Stage 1: Building build file from the given nodejs application code 
FROM node:18 AS build

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# Stage 2: Serving the frontend application using nginx server for production
FROM nginx:alpine AS production

RUN addgroup -S nginxgroup && adduser -S nginxuser -G nginxgroup

USER nginxuser

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /usr/src/app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]