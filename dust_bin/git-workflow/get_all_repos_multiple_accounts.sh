
ACCOUNT_LIST=('wavescholar' 'brucebcampbell' 'ncsu-statistics')

for account_name in "${ACCOUNT_LIST[@]}"
do
  echo "Cloning repos for $account_name, please wait ..."

  mkdir $account_name

  cd $account_name

  curl -s https://api.github.com/users/"$account_name"/repos | grep \"clone_url\" | awk '{print $2}' | sed -e 's/"//g' -e 's/,//g' | xargs -n1 git clone
  cd ../
done
