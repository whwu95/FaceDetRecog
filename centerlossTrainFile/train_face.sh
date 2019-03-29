#!/usr/bin/env sh

LOG_FILE=output/scratch_half_all/half_kernel_fc.log 
echo "logging to ${LOG_FILE}"
    ../caffe_face/build/tools/caffe train \
    --solver=face_solver1.prototxt \
    --gpu 4,5,6,7  2>&1 | tee ${LOG_FILE} 
    #--weights=face_model.caffemodel 
