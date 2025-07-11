FROM nginx:alpine

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create directories for certbot (if you plan to add SSL later)
RUN mkdir -p /var/www/certbot

# Create custom error page
RUN echo '<html><head><title>Service Unavailable</title></head><body><h1>Service Temporarily Unavailable</h1><p>Please try again in a few moments.</p></body></html>' > /usr/share/nginx/html/50x.html

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]