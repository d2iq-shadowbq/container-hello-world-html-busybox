docker build -t hello-world .
docker run -p 80:8005 hello-world
## open your browser and check http://localhost/
docker login
docker tag hello-world {your_dockerhub_user}/hello-world
docker push {your_dockerhub_user}/hello-world:latest