#Setup Stuff
USER="raindrops"
USERPW="raindrops"
RSTUDIOPORT=8001
#sudo adduser $USER
sudo useradd -mk . -G admin $USER

git config --global user.email "wavescholar@gmail.com"
git config --global user.name "$GIT_USER"
ssh-keygen -t rsa -b 4096 -C "wavescholar@gmail.com"
#Then add the key to GH
########################################################


package_name <- 'kumagawa'
#Get a auth_token
source('~/.secrets/set_secrets.R')

GITHUB_TOKEN_R

use_git_config(user.name = $GIT_USER_NAME, user.email = "wavescholar@gmail.com")

browse_github_pat()

library(usethis)

# Create a new package -------------------------------------------------
create_package(package_name)

# Modify the description ----------------------------------------------
use_mit_license("wavesholar")

use_package("MASS", "Suggests")

# Set up various packages ---------------------------------------------
use_roxygen_md()

#use_rcpp()

use_revdep()

# Set up other files -------------------------------------------------
use_readme_md()

use_news_md()

use_test("test-a")

x <- 1
y <- 2
use_data(x, y)

use_git(message = "Initial commit")

use_github(auth_token = "GITHUB_PAT", host = NULL)

###########################################################

# set up travis 

