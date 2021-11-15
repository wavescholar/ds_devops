libs <-c("devtools","base64enc","profvis","profmem","MASS","car","plyr","xtable","ggplot2","dplyr","tidyr","readr","purrr","tibble","stringr","forcats","glue","timetk","tidyquant","tibbletime","styler","DiagrammeR","cowplot","recipes","rsample","yardstick","knitr","rmarkdown","pander","latex2exp","reshape2","GGally","htmlwidgets","devtools","ggthemes, dependencies = TRUE","formatR","pracma","moments","outliers","RColorBrewer","foreach","doMC","Kendall","corrplot","compare","pracma","e1071","caret","glmnet","ROCR","scatterplot3d","tsne","Rtsne","neuralnet","class","rpart","rattle","rpart.plot","party","partykit","randomForest","gbm","mlbench","ggmap","corrgram","leaflet","mixtools","hexbin","bnlearn","Matrix","igraph","RcppEigen","expm","markovchain","diagram","sqldf","data.table","rjags","runjags","rstan","shinystan","rstanarm","choroplethr","choroplethrMaps","sf","modeest","FedData","rethinking","greta","bayesplot","bayesm","fractal","fractaldim","Rwave","ifultools","wmtsa","xml2","aws.s3","cluster","anocva","formula.tools","leaps","stargazer","xgboost","Ckmeans.1d.dp","lme4","pscl","ggmcmc","brms","maptools","spdep","rgdal","reshape2","papeR","rARPACK","stargaze","roxygen","roxygen2","fs","tidygraph","usethis","pkgdown","revealjs")



new_libs <- c('hrbrthemes' ,'summarytools')


check_and_install<- function(package_name)
{
  if(!require(package_name))
  {
    install.packages( package_name )
  }

}

for( package_name in new_libs)
{
  check_and_install(package_name)
}
