export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/IUS/vmr101/software/ubuntu12.04/opencv-2.4.5/


OUTPATH_TO_FEATS="../../../data/features/";
for i in ../../../videos/*.wmv;
do
COMMAND="./release/DenseTrack $i | gzip > $OUTPATH_TO_FEATS$(printf '%s.gz' $(b\asename ${i%.avi}))";

echo $COMMAND;#$COMMAND;

done;
