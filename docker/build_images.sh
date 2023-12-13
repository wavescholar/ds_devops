
for dir in ~/work/ds_devops/docker/*/     # list directories in the form "/tmp/dirname/"
do
    echo $dir
    cd $dir
    echo '---------------'
    echo pwd
    echo ls
    echo "building : wavescholar/wavescholar-$dir-microservice-image"
    #docker build -t wavescholar/wavescholar-$dir-microservice-image .
    cd ../
    
done