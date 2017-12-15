FROM centos:centos7

RUN \
  mkdir /data && \
  cd /data && \
  curl -o linux-amd64.tar.gz "https://storage.googleapis.com/kubernetes-helm/helm-v2.7.2-linux-amd64.tar.gz" && \
  curl -o darwin-amd64.tar.gz "https://storage.googleapis.com/kubernetes-helm/helm-v2.7.2-darwin-amd64.tar.gz" && \
  curl -o windows-amd64.tar.gz "https://storage.googleapis.com/kubernetes-helm/helm-v2.7.2-windows-amd64.tar.gz"

FROM nginx:alpine
COPY --from=0 /data /data
RUN echo "server {autoindex off; server_name localhost; location ~ ^/$ {return 200;} location ~ ^.*/$ {return 404;} location / { root /data; default_type application/octet-stream; add_header Content-Disposition 'attachment'; types {}}}" > /etc/nginx/conf.d/default.conf
