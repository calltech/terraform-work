FROM node:carbon as node
WORKDIR /usr/src/app
COPY . ./
COPY package*.json ./
RUN npm install
RUN npm run build
COPY . .

#-------------------------------------------------------------#
#----------------------Production-----------------------------#
#-------------------------------------------------------------#

# Stage 2
# copy artifact build from the 'build environment'
FROM nginx:1.13.12-alpine
COPY --from=node /usr/src/app/dist/Angular6SpringBoot /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose 80 port
EXPOSE 80
CMD [ "nginx", "-g" "daemon off;" ]