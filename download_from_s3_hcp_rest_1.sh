# download files from s3 hcp
# Aspera failed ... which leaves me only doing the following

csv_path=/home/libilab2/a/users/huan1282/dev/src/github.com/EstelleHuang666/GNN-rfMRI-dev/HCP_fMRI_preprocess/data/hcp_s1200.csv
subject_ids=$(awk -F "\"*,\"*" '{print $1}' $csv_path)
subject_id_arr=(`echo ${subject_ids}`)
target_file_path=/scratch/libilab2/data/data/users/huan1282/REST_1_preproc/
s3_head=s3://hcp-openaccess/HCP_1200/

for subject_id in "${subject_id_arr[@]:1}"
do 
  nii_file_dir=$subject_id/MNINonLinear/Results/rfMRI_REST1_LR
  nii_file_path=$nii_file_dir/rfMRI_REST1_LR.nii.gz
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
