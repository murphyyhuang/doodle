# download subject-specific brain anatomy mask from s3 hcp
# resample these downloaded mask from 1mm to 2mm

csv_path=/home/libilab2/a/users/huan1282/dev/src/github.com/EstelleHuang666/GNN-rfMRI-dev/HCP_fMRI_preprocess/data/hcp_s1200.csv
subject_ids=$(awk -F "\"*,\"*" '{print $1}' $csv_path)
subject_id_arr=(`echo ${subject_ids}`)
target_file_path=/scratch/libilab2/data/data/users/huan1282/REST_1_preproc/
s3_head=s3://hcp-openaccess/HCP_1200/

for subject_id in "${subject_id_arr[@]:1}"
do 
  nii_file_dir=$subject_id/T1w
  nii_file_path=$nii_file_dir/wmparc.nii.gz
  path_to_file="$s3_head$nii_file_path"
  exists=$(aws s3 ls $path_to_file)
  if [ -z "$exists" ]; then
    echo "$path_to_file does not exist"
  else
    if [ ! -f "$target_file_path$nii_file_path" ]; then
      s3_transport_path="$target_file_path$nii_file_dir"
      mkdir -p "$target_file_path$nii_file_dir"
      echo "$path_to_file exists"
      echo "save that to $s3_transport_path"
      aws s3 cp $path_to_file $s3_transport_path
    else
      echo "$target_file_path$nii_file_path found!"
    fi
  fi
done

for subject_id in "${subject_id_arr[@]:1}"
do
  nii_1mm_file_dir="$target_file_path$subject_id/T1w/wmparc.nii.gz"
  nii_2mm_file_dir="$target_file_path$subject_id/T1w/wmparc_2mm.nii.gz"
  3dresample -inset ${nii_1mm_file_dir} -prefix ${nii_2mm_file_dir} -dxyz 2 2 2
  echo "Resample $nii_1mm_file_dir to $nii_2mm_file_dir"
done
