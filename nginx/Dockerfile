FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/certbot

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]