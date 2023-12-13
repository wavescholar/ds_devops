# wavescholar NCSU-STATS OSU-MATH
ORG_ID=wavescholar 

for dir in ~/work/$ORG_ID/*/     # list directories in the form "/tmp/dirname/"
do
    echo dir
    echo $dir
    cd $dir
    echo '---------------'
    echo pwd
    git pull

    cd ../
    
done