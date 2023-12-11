
# wavescholar NCSU-STATS OSU-MATH
ORG_ID=wavescholar 

COMMIT_MESSAGE="cleaning up"
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

for dir in ~/work/$ORG_ID/*/     # list directories in the form "/tmp/dirname/"
do
    echo dir
    echo $dir
    cd $dir
    echo '---------------'
    echo pwd
    git add .
    git commit -m '$COMMIT_MESSAGE'
    git push
    cd ../
    
done