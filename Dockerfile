FROM gcr.io/tensorflow/tensorflow:latest-devel

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y google-cloud-sdk apt-utils

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD amykey.json /app

# Authorize with my service account key
RUN gcloud auth activate-service-account --key-file=amykey.json

# Install gcsfuse to access cloud storage as a directory on the filesystem
RUN export GCSFUSE_REPO="gcsfuse-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y gcsfuse

# make a directory for mounting
#RUN mkdir -p /mnt/gcs && \
#    gcsfuse copyright /mnt/gcs


#EXPOSE 80

