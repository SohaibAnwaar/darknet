#!/bin/bash

darknet_location='/forest_3d_app/darknet/'
img_location=/forest_3d_app/forest_3d_app/data/dataset/images
anno_location=/forest_3d_app/forest_3d_app/data/dataset/labels

num_classes=3

# cd $darknet_location/models
# wget https://pjreddie.com/media/files/yolov3-tiny.weights
# wget https://pjreddie.com/media/files/darknet53.conv.74


# max_batches=2000*num_classes*(64/train_bs)
# steps=0.8*max_batches,0.9*max_batches

###############################################################################3

cd $darknet_location

# delete directory if exists
[ -d "tmp_yolo" ] && rm -r tmp_yolo

# setup sub-directories
mkdir tmp_yolo
mkdir tmp_yolo/cfg
mkdir tmp_yolo/train_data
mkdir tmp_yolo/backup

cp $darknet_location/cfg/yolov3-tiny-custom.cfg $darknet_location/tmp_yolo/cfg/yolov3-tiny-custom.cfg
cp $darknet_location/cfg/yolov3-tiny-custom-test.cfg $darknet_location/tmp_yolo/cfg/yolov3-tiny-custom-test.cfg

# object.data
cd $darknet_location/tmp_yolo/cfg
exec 3<> obj.data
	echo "classes = $num_classes" >&3
	echo "train  = $darknet_location/tmp_yolo/train.txt " >&3
	echo "valid  = $darknet_location/tmp_yolo/val.txt " >&3
	echo "names = $darknet_location/tmp_yolo/cfg/obj.names " >&3 
	echo "backup = $darknet_location/tmp_yolo/backup/ " >&3 
exec 3>&-


# obj.names
declare -a arr=("tree" "shrub" "partial")  
j=1
exec 3<> obj.names

	for i in "${arr[@]}"
	do
		echo "$i" >&3   
		let j=j+1
	done
exec 3>&-


# create yolo-type annotation files (from VOC files) and train/val split
# cd ../../
# python $darknet_location/scripts/voc_label_custom.py -d "$anno_location" -c "tree,shrub,partial"   
# python $darknet_location/scripts/split_train_test.py -d "$img_location" -y "$darknet_location" -s "10"

# copy image and anno files 
anno_yolo_location=`dirname "$anno_location"`/anno_yolo
cp -a $img_location/. $darknet_location/tmp_yolo/train_data
cp -a $anno_yolo_location/. $darknet_location/tmp_yolo/train_data



# train detector (run this command on terminal)
darknet detector train tmp_yolo/cfg/obj.data tmp_yolo/cfg/yolov3-tiny-custom.cfg models/darknet53.conv.74


# move test config and weights to deploy folder
mkdir $darknet_location/tmp_yolo/deploy
cp $darknet_location/tmp_yolo/cfg/yolov3-tiny-custom-test.cfg $darknet_location/tmp_yolo/deploy/yolov3.cfg
cp $darknet_location/tmp_yolo/backup/yolov3-tiny-custom_final.weights $darknet_location/tmp_yolo/deploy/yolov3.weights
cp $darknet_location/tmp_yolo/cfg/obj.names $darknet_location/tmp_yolo/deploy/obj.names


# test detector
#./darknet detector test tmp_yolo/cfg/obj.data tmp_yolo/deploy/yolov3.cfg tmp_yolo/deploy/yolov3.weights raster_0.jpg



