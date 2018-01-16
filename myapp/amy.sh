#!/bin/bash

# gcsfuse to connect to google cloud storage
mkdir -p /mnt/gcs
gcsfuse copyright /mnt/gcs

# copy jupyter config file 
mv /app/jupyter_notebook_config.json ~/.jupyter/

# extract the images
cd app
tar xvf /app/not_sources.tar.gz
tar xvf /app/sources.tar.gz

# create input for the model
mkdir /mnt/copyright
python creating_input.py -i /app -o /mnt/copyright

# # build the model - compile the code (can take 2hrs)
# cd /tensorflow
# bazel build -c opt --copt=-mavx /tensorflow/tensorflow/examples/image_retraining:retrain

echo "model has been built"

# # retrain with my own images (around 2hrs in total)
# bazel-bin/tensorflow/examples/image_retraining/retrain \
#     --bottleneck_dir=/mnt/bottlenecks \
#     --model_dir=/mnt/inception \
#     --output_graph=/mnt/retrained_graph.pb \
#     --output_labels=/mnt/retrained_labels.txt \
#     --image_dir /mnt/copyright

jupyter notebook --allow-root "$@"
# sleep infinity
