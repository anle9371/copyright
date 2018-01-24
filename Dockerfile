FROM gcr.io/tensorflow/tensorflow:latest-devel

# Copy the current directory contents into the container at /app
COPY myapp/* /app/

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y \
    apt-utils \
    google-cloud-sdk

# gcsfuse - connect to google cloud service
# also see the corresponding lines in amy.sh
# RUN gcloud auth activate-service-account --key-file=/app/amykey.json && \
#     export GCSFUSE_REPO="gcsfuse-$(lsb_release -c -s)" && \
#     echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
#     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
#     apt-get update && apt-get install -y \
#     gcsfuse
    
RUN chmod +x /app/amy.sh

RUN pip install --trusted-host pypi.python.org -r /app/requirements.txt

# Set the working directory to /mnt
WORKDIR /mnt

ENTRYPOINT ["/app/amy.sh"]



