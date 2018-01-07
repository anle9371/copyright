#!/bin/bash

# gcsfuse to connect to google cloud storage
mkdir -p /mnt/gcs
gcsfuse copyright /mnt/gcs

# # Use signals to communicate with an application from the host machine


# # build the model - compile the code (can take five to ten minutes)
# bazel build -c opt --copt=-mavx /tensorflow/tensorflow/examples/image_retraining:retrain

# # retrain with the flower images (around twenty minutes in total)
# bazel-bin/tensorflow/examples/image_retraining/retrain \
#     --bottleneck_dir=/tf_files/bottlenecks \
#     --model_dir=/tf_files/inception \
#     --output_graph=/tf_files/retrained_graph.pb \
#     --output_labels=/tf_files/retrained_labels.txt \
#     --image_dir /tf_files/flower_photos

jupyter notebook --allow-root "$@"
# sleep infinity
