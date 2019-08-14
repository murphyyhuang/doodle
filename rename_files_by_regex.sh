#!/bin/sh
for file in *.nii; do
  if [ -e "$file" ]; then
    newname=`echo "$file" | sed -E 's/^([0-9]{6}\_rfMRI\_REST[1|2]\_LR\_vol)\.nii/\1.mat/'`
    echo "mv $file $newname"
    mv "$file" "$newname"
  fi
done
