docker container stop enhancer_pipeline_container
docker container kill enhancer_pipeline_container
docker container rm enhancer_pipeline_container

docker container run \
  -d \
  --name enhancer_pipeline_container \
  -p 0.0.0.0:5002:5000 \
  -v /$(pwd)/data:/data \
  phoenixenhancer/enhancer-pipeline \
  tail -f /dev/null



#convert .clustering files to msp file
docker exec -it enhancer_pipeline_container sh -c \
     "python3 \
     /code/venv35/lib/python3.5/site-packages/spectra_cluster-0.1.0-py3.5.egg/spectra_cluster/ui/cluster_to_msp.py \
     --input /data/clustering-files \
     --output /data/test.msp"

#build the library from clustering results in msp 
docker exec -it enhancer_pipeline_container sh -c "echo 'doing spectrast create'>/code/test.log; cd /data; /app/tpp/bin/spectrast -cN test test.msp; cd /code"

#set the configs like Database/ports/lib data files, etc
docker cp config-docker.ini enhancer_pipeline_container:/code/config.ini

#docker cp data/test* enhancer_pipeline_container:/data/.

#import clustering files in to MySQL database
docker exec -it enhancer_pipeline_container sh -c "echo 'import clustering to mysql'>>/code/test.log; cd /code; python3 utils/cluster_mysql_importer.py --input /data/clustering-files --host 192.168.31.12 --over_write_table"

#start the file analysis restful server to support fileuploading/analyzing
docker exec -it enhancer_pipeline_container sh -c "echo 'starting file rest api '>>/code/test.log; python3  file_rest_api.py"



