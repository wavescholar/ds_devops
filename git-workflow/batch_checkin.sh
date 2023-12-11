
# wavescholar NCSU-STATS OSU-MATH
ORG_ID=wavescholar 

COMMIT_MESSAGE="cleaning up"

for dir in ~/work/$ORG_ID/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    echo "${dir##*/}"    # print everything after the final "/"
    git pull
    
    
done

for dir in ~/work/$ORG_ID/*/     # list directories in the form "/tmp/dirname/"
do
    echo dir
    echo $dir
    
    dir=${dir%*/}      # remove the trailing "/"
    echo "${dir##*/}"    # print everything after the final "/"
    cd $dir
    git add .
    git commit -m $COMMIT_MESSAGE
    git push
    cd ../
    
done