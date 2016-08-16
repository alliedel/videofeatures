# !/bin/bash
export LD_LIBRARY_PATH=/IUS/vmr101/software/ubuntu12.04/opencv-2.4.5/lib/

#!/bin/bash
# exec bash -c "$*"
# ret=$?
# exit $ret
cmd="$*"
# test_sequences/person01_boxing_d1_uncomp.avi tstN.bin
echo "cmd=$cmd";
exec bash -c "$cmd"
