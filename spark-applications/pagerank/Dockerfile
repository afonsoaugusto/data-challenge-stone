# docker image [gcp]
FROM gcr.io/spark-operator/spark-py:v3.0.0

LABEL MAINTAINER="Afonso Rodrigues"
LABEL MAINTAINER_EMAIL=afonsoaugustoventura@gmail.com

# using root user
USER root:root

# create directory for apps
RUN mkdir -p /app

# copy spark program
COPY pagerank.py /app/

# copy file to process
ADD https://gist.githubusercontent.com/afonsoaugusto/a297cbc31907ecab6e721ecdba15c292/raw/189eea78f1cc0f04b2a4b876d49ae2e7750f5e9e/pagerank_data.txt /app/

RUN /bin/chown 1001 /app -R
# set work directory
WORKDIR /app

# user
USER 1001