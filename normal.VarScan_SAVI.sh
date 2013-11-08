#!/bin/bash
echo normal
tail -n +2 | awk 'BEGIN{FS=OFS="\t"}{print $20,$18}' | \
    while read line; do 
    if grep -q "$line" /ifs/scratch/c2b2/rr_lab/hk2524/Cancer/AllNormals/AllNormals.105.CosmicRemoved; then 
	echo NORMAL
    else 
	echo NOVEL
    fi
done

