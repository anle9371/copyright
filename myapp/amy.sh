#!/bin/bash

# this is the docker entrypoint shell script that
# sets up the files and folders for model building and training

IMGPATH="~"
LOGFILE="/app/log.txt"

# create logfile
touch $LOGFILE
echo "logfile created" >> $LOGFILE

# # gcsfuse to connect to google cloud storage
# mkdir -p /mnt/gcs
# gcsfuse copyright /mnt/gcs

# copy jupyter config file 
mv /app/jupyter_notebook_config.json ~/.jupyter/
echo "jupyter config transferred" >> $LOGFILE

# copy demo notebook
mv /app/using_inception.ipynb ~
echo "demo notebook moved to home" >> $LOGFILE

# extract the images
tar xvf /app/not_sources.tar.gz -C /app
tar xvf /app/sources.tar.gz -C /app
echo "images untarred" >> $LOGFILE

# create input for the model
# mkdir /mnt/copyright
python /app/creating_input.py -i /app -o $IMGPATH
echo "created input for inception" >> $LOGFILE

# # # build the model - compile the code (can take 2hrs)
# cd /tensorflow
# bazel build -c opt --copt=-mavx /tensorflow/tensorflow/examples/image_retraining:retrain >> $LOGFILE

# echo "\n\n model has been built \n\n" >> $LOGFILE

# # retrain with my own images (around 2hrs in total)
# bazel-bin/tensorflow/examples/image_retraining/retrain \
#     --bottleneck_dir=/mnt/bottlenecks \
#     --model_dir=/mnt/inception \
#     --output_graph=/mnt/retrained_graph.pb \
#     --output_labels=/mnt/retrained_labels.txt \
#     --image_dir $IMGPATH >> $LOGFILE

# echo "\n\n model has been retrained \n\n" >> $LOGFILE


#jupyter notebook --allow-root --no-browser "$@"
jupyter notebook --allow-root --no-browser --notebook-dir='~' 

# sleep infinity
