## Train YOLOv3 on custom dataset

1. Get the images
2. Annotate the images with the help of labelImg tool
   1. Download the tool from [here](https://github.com/heartexlabs/labelImg)
   2. Use pascal VOC format
   3. Annotate the images
   4. Save the annotations in the same folder as the images
3. Run the script `setup.sh` to create the required folder structure
4. Pull the docker image from [here](https://hub.docker.com/r/daisukekobayashi/darknet)
5. Run the docker image with the following command

   1. `docker run -it -v /home/sohaib/Documents/kodifly/3d_forest/:/forest_3d_app --gpus=all -p 8888:8888 daisukekobayashi/darknet:darknet_yolo_v4_pre-gpu bash`
   2. This will mount the current directory to the docker container
   3. This will also mount the GPU to the docker container
   4. This will also mount the port 8888 to the docker container in case you want to run jupyter notebook

6. Make yolo compatible annotations
   1. Run the script `make_yolo_annotations.py` to convert the pascal VOC annotations to yolo compatible annotations
   2. `python $darknet_location/scripts/voc_label_custom.py -d "annotation_path/labels/" -c "tree,shrub,partial"   `
   3. This will create a folder called `anno_yolo` in the same directory as the images
7. Run the script `make_train_val_txt.sh` to create the train and test files
   1. Make sure to change these params
      1. images_path=$base_path"forest_3d_app/data/dataset/images/"
      2. output_file1=$base_path"darknet/tmp_yolo/train.txt"
      3. output_file2=$base_path"darknet/tmp_yolo/val.txt"
   2. After running this command you will have `train.txt` and `val.txt` in the `tmp_yolo` folder
8. Go to anno_yolo folder again copy all of the txt label files which you converted from label image annotations to yolo compatible annotations and paste it in images folder
9. Run the script `auto_setup_yolo.sh` to create the required files for training
10. Run this command to start the training
    1. `darknet detector train tmp_yolo/cfg/obj.data tmp_yolo/cfg/yolov3-tiny-custom.cfg models/darknet53.conv.74`
11. Copy weights to the `deploy` folder
    1. `export darknet_location='/forest_3d_app/darknet/'`
    2. mkdir $darknet_location/tmp_yolo/deploy
    3. cp $darknet_location/tmp_yolo/cfg/yolov3-tiny-custom-test.cfg $darknet_location/tmp_yolo/deploy/yolov3.cfg
    4. cp $darknet_location/tmp_yolo/backup/yolov3-tiny-custom_final.weights $darknet_location/tmp_yolo/deploy/yolov3.weights
    5. cp $darknet_location/tmp_yolo/cfg/obj.names $darknet_location/tmp_yolo/deploy/obj.names
