#!/bin/bash

mkdir -p /mnt/gcs
gcsfuse copyright /mnt/gcs
jupyter notebook --allow-root "$@"
#/run_jupyter.sh
#sleep infinity
