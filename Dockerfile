FROM gcr.io/tensorflow/tensorflow:latest-devel

# Copy the current directory contents into the container at /app
COPY amy* /app/

COPY *.ipynb /app/

# Set the working directory to /app
WORKDIR /app

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y \
    apt-utils \
    google-cloud-sdk && \
    gcloud auth activate-service-account --key-file=/app/amykey.json && \
    export GCSFUSE_REPO="gcsfuse-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y \
    gcsfuse && \
    chmod +x /app/amy.sh


RUN pip install --trusted-host pypi.python.org -r requirements.txt

ENTRYPOINT ["/app/amy.sh"]

#EXPOSE 80

