#!/bin/bash
# this is the docker entrypoint shell script that
# sets up the files and folders for model building and training

IMGPATH="/root"
LOGFILE="/app/log.txt"

exec &>> $LOGFILE

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

# start jupyter server
jupyter notebook --allow-root --no-browser --notebook-dir='~' 

# extract the images
tar xvf /app/not_sources.tar.gz -C /app
tar xvf /app/sources.tar.gz -C /app
echo "images untarred" >> $LOGFILE

# create input for the model
# mkdir /mnt/copyright
python /app/creating_input.py -i /app/amytmp -o $IMGPATH
echo "created input for inception" >> $LOGFILE

# build
bazel build -c opt --copt=-mavx tensorflow/examples/image_retraining:retrain

# # retrain with my own images (around 2hrs in total)
bazel-bin/tensorflow/examples/image_retraining/retrain \
    --bottleneck_dir=/mnt/bottlenecks \
    --model_dir=/mnt/inception \
    --output_graph=/mnt/retrained_graph.pb \
    --output_labels=/mnt/retrained_labels.txt \
    --image_dir $IMGPATH >> $LOGFILE

# sleep infinity
