
for dir in ~/work/wavescholar/ds_devops/docker/images/*/     # list directories in the form "/tmp/dirname/"
do
    echo $dir
    cd $dir
    echo '---------------'
    echo `ls`
    base_image_name=$(basename $dir)
    echo $base_image_name
    echo "building : wavescholar/wavescholar-$base_image_name-microservice-image"
    docker build -t wavescholar/wavescholar-$base_image_name-microservice-image .
    docker push wavescholar/wavescholar-$base_image_name-microservice-image:latest
    cd ../
    
done