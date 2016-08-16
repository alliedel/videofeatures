#!/bin/bash
#FILENAMES=$(ls /usr0/tmp/yuichi/Personal_Video_dataset/dataset)
#AVI_FILE=$(printf '"' $val1 $val2)
#./release/DenseTrajectory $AVI_FILE
#echo $STR 

#var=$(printf 'FILE_%s_%s.dat' $val1 $val2)

OUTPATH_TO_FEATS="../../../../data/features/";

for i in /usr0/tmp/yuichi/Personal_Video_dataset/dataset/*.avi;
do
COMMAND="./release/DenseTrack $i | gzip > $OUTPATH_TO_FEATS$(printf '%s.gz' $(basename ${i%.avi}))";
echo $COMMAND;
#$COMMAND;
done;
