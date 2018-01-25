FROM gcr.io/tensorflow/tensorflow:latest-devel

## these RUN commands set up the docker with google cloud services (sdk and storgage)
# RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
#     echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
#     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
#     apt-get update && apt-get install -y \
#     apt-utils \
#     google-cloud-sdk

# gcsfuse - connect to google cloud service
# also see the corresponding lines in amy.sh
# RUN gcloud auth activate-service-account --key-file=/app/amykey.json && \
#     export GCSFUSE_REPO="gcsfuse-$(lsb_release -c -s)" && \
#     echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
#     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
#     apt-get update && apt-get install -y \
#     gcsfuse

RUN apt-get update && apt-get install -y \
    python-tk

# Copy the current directory contents into the container at /app
ADD myapp/ /app

RUN chmod +x /app/amy.sh

#RUN chmod +x /app/model.sh

RUN pip install --trusted-host pypi.python.org -r /app/requirements.txt

# Set the working directory 
WORKDIR /tensorflow

ENTRYPOINT ["/app/amy.sh"]