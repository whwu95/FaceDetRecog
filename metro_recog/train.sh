#!/usr/bin/env sh

LOG_FILE=output/half_all.log 
echo "logging to ${LOG_FILE}"
    ../caffe_face/build/tools/caffe train \
    --solver=face_solver.prototxt \
    --gpu 2,3,4,5,6,7  2>&1 | tee ${LOG_FILE} 
    #--weights=face_model.caffemodel 
