local({r <- getOption('repos'); r['CRAN'] <- 'http://cran.r-project.org' ; options(repos=r)})
if(!require(devtools)){install.packages( 'devtools',dependencies = TRUE) }
devtools::install_github('r-dbi/odbc')

# https://www.rdocumentation.org/

# DevOps ------------------------------------------------------------
if(!require(foreach)){install.packages( 'foreach',dependencies = TRUE) }
if(!require(doMC)){install.packages( 'doMC',dependencies = TRUE) }
if(!require(base64enc)){install.packages( 'base64enc',dependencies = TRUE) }
if(!require(profvis)){install.packages( 'profvis',dependencies = TRUE) }
if(!require(formatR)){install.packages( 'formatR',dependencies = TRUE) }#formatR: Format R Code Automatically Provides a function tidy_source() to format R source code
if(!require(profmem)){install.packages( 'profmem',dependencies = TRUE) }
if(!require(lintr)){install.packages('lintr',dependencies = TRUE) }
if(!require(covr)){install.packages('covr',dependencies = TRUE) }
if(!require(data.table)){install.packages( 'data.table',dependencies = TRUE) }
if(!require(sqldf)){install.packages( 'sqldf',dependencies = TRUE) }
if(!require(glue)){install.packages( 'glue',dependencies = TRUE) } # interpreted string literals
if(!require(roxygen)){install.packages( 'roxygen',dependencies = TRUE) }
if(!require(roxygen2)){install.packages( 'roxygen2',dependencies = TRUE) }
if(!require(knitr)){install.packages( 'knitr',dependencies = TRUE) }
if(!require(rmarkdown)){install.packages( 'rmarkdown',dependencies = TRUE) }
if(!require(papeR)){install.packages( 'papeR',dependencies = TRUE) } # LaTeX Tools - prettify, summarize, to LaTex table
if(!require(revealjs)){install.packages( 'revealjs',dependencies = TRUE) }
if(!require(pander)){install.packages( 'pander',dependencies = TRUE) }
if(!require(latex2exp)){install.packages( 'latex2exp',dependencies = TRUE) }
if(!require(RPostgres)){install.packages('RPostgres',dependencies = TRUE) }
if(!require(aws.s3)){install.packages( 'aws.s3',dependencies = TRUE) }
if(!require(redshiftTools)){devtools::install_github('sicarul/redshiftTools', upgrade = FALSE)}
if(!require(data.table)){install.packages('data.table',dependencies = TRUE) }
if(!require(log4r)){install.packages('log4r',dependencies = TRUE) }
if(!require(tictoc)){install.packages('tictoc',dependencies = TRUE) }
if(!require(renv)){install.packages('renv',dependencies = TRUE) }
if(!require(parallel)){install.packages('parallel',dependencies = TRUE) }
if(!require(httr)){install.packages('httr',dependencies = TRUE) }
if(!require(rversions)){install.packages('rversions',dependencies = TRUE) }
if(!require(extrafont)){install.packages('extrafont',dependencies = TRUE) }
if(!require(kable)){install.packages('kable',dependencies = TRUE) }
if(!require(bookdown)){install.packages('bookdown',dependencies = TRUE) }
if(!require(RJDBC)){install.packages('RJDBC',dependencies = TRUE) }
if(!require(Cairo)){install.packages('Cairo',dependencies = TRUE) }


if(!require(MASS)){install.packages( 'MASS',dependencies = TRUE) }
if(!require(car)){install.packages( 'car',dependencies = TRUE) }
if(!require(plyr)){install.packages( 'plyr',dependencies = TRUE) }
if(!require(xtable)){install.packages( 'xtable',dependencies = TRUE) }
if(!require(pracma)){install.packages( 'pracma',dependencies = TRUE) }
if(!require(moments)){install.packages( 'moments',dependencies = TRUE) }
if(!require(outliers)){install.packages( 'outliers',dependencies = TRUE) }
if(!require(e1071)){install.packages( 'e1071',dependencies = TRUE) }
if(!require(caret)){install.packages( 'caret',dependencies = TRUE) }
if(!require(glmnet)){install.packages( 'glmnet',dependencies = TRUE) }
if(!require(anocva)){install.packages( 'anocva',dependencies = TRUE) }
if(!require(formula.tools)){install.packages( 'formula.tools',dependencies = TRUE) }

# Visualization ------------------------------------------------------
if(!require(grid)){install.packages('grid',dependencies = TRUE) } # Base for ggplot2 no user functions here really
if(!require(ggplot2)){install.packages( 'ggplot2',dependencies = TRUE) }
if(!require(corrplot)){install.packages( 'corrplot',dependencies = TRUE) }
if(!require(GGally)){install.packages( 'GGally',dependencies = TRUE) }
if(!require(ggthemes)){install.packages( 'ggthemes',dependencies = TRUE) }
if(!require(RColorBrewer)){install.packages( 'RColorBrewer',dependencies = TRUE) }
if(!require(wesanderson)){install.packages('wesanderson',dependencies = TRUE) } # Color Ramps! https://github.com/karthik/wesanderson
if(!require(ggsci)){install.packages('ggsci',dependencies = TRUE) } # high-quality color palettes inspired by colors used in scientific journals, data visualization libraries, science fiction movies, and TV shows
if(!require(htmlwidgets)){install.packages( 'htmlwidgets',dependencies = TRUE) }
if(!require(ggmap)){install.packages( 'ggmap',dependencies = TRUE) }
if(!require(corrgram)){install.packages( 'corrgram',dependencies = TRUE) }
if(!require(leaflet)){install.packages( 'leaflet',dependencies = TRUE) }
if(!require(choroplethr)){install.packages( 'choroplethr',dependencies = TRUE) }
if(!require(choroplethrMaps)){install.packages( 'choroplethrMaps',dependencies = TRUE) }
if(!require(hrbrthemes)){install.packages( 'hrbrthemes',dependencies = TRUE) }
if(!require(raincloudplots)){install.packages( 'raincloudplots',dependencies = TRUE) }
if(!require(lattice)){install.packages('lattice',dependencies = TRUE) }
if(!require(cowplot)){install.packages( 'cowplot',dependencies = TRUE) }
if(!require(gridExtra)){install.packages('gridExtra',dependencies = TRUE) } # user-level functions to work with "grid" graphics, notably to arrange multiple grid-based plots on a page
if(!require(ggeffects)){install.packages('ggeffects',dependencies = TRUE) } #Estimated Marginal Means and Adjusted Predictions from Regression Models
if(!require(scatterplot3d)){install.packages( 'scatterplot3d',dependencies = TRUE) }
if(!require(hexbin)){install.packages( 'hexbin',dependencies = TRUE) }

# DataFrame Viz -----------------------------------------------------
if(!require(DataExplorer)){install.packages( 'DataExplorer',dependencies = TRUE) }
if(!require(summarytools)){install.packages( 'summarytools',dependencies = TRUE) }
if(!require(skimr)){install.packages('skimr',dependencies = TRUE) } #skimr is designed to provide summary statistics about variables in data frames, tibbles, data tables and vectors.


# Graphs -------------------------------------------------------------
if(!require(igraph)){install.packages( 'igraph',dependencies = TRUE) }
if(!require(graph)){install.packages('graph',dependencies = TRUE) }
if(!require(Rgraphviz)){install.packages('Rgraphviz',dependencies = TRUE) }
if(!require(DiagrammeR)){install.packages( 'DiagrammeR',dependencies = TRUE) } #Generate graph diagrams using text in a Markdown-like syntax. : R + RStudio + htmlwidgets + JavaScript + d3.js + viz.js + mermaid.js
if(!require(diagram)){install.packages( 'diagram',dependencies = TRUE) } #Basic visualising simple graphs, flowcharts, and webs
if(!require(RBGL)){install.packages('RBGL',dependencies = TRUE) } # A fairly extensive and comprehensive interface to the graph algorithms contained in the BOOST library.
if(!require(ggraph)){install.packages('ggraph',dependencies = TRUE) } #ggraph: An Implementation of Grammar of Graphics for Graphs and Networks. ... ggraph is an extension of the ggplot2 API 

# Tydyverse --------------------------------------------------
if(!require(dplyr)){install.packages( 'dplyr',dependencies = TRUE) }
if(!require(tidyr)){install.packages( 'tidyr',dependencies = TRUE) }
if(!require(readr)){install.packages( 'readr',dependencies = TRUE) }
if(!require(purrr)){install.packages( 'purrr',dependencies = TRUE) }
if(!require(tibble)){install.packages( 'tibble',dependencies = TRUE) }
if(!require(stringr)){install.packages( 'stringr',dependencies = TRUE) } #stringr is built on top of stringi, which uses the ICU C library to provide fast, correct implementations of common string manipulations
if(!require(tidyquant)){install.packages( 'tidyquant',dependencies = TRUE) }
if(!require(tibbletime)){install.packages( 'tibbletime',dependencies = TRUE) }
if(!require(styler)){install.packages( 'styler',dependencies = TRUE) }
if(!require(tidygraph)){install.packages( 'tidygraph',dependencies = TRUE) }
if(!require(usethis)){install.packages( 'usethis',dependencies = TRUE) }
if(!require(pkgdown)){install.packages( 'pkgdown',dependencies = TRUE) }
if(!require(recipes)){install.packages( 'recipes',dependencies = TRUE) } #recipes package is an alternative method for creating and preprocessing design matrices that can be used for modeling or visualization
if(!require(forcats)){install.packages( 'forcats',dependencies = TRUE) } #provide a suite of tools that solve common problems with factors, including changing the order of levels or the values
if(!require(tidymodels)){install.packages( 'tidymodels',dependencies = TRUE) }
if(!require(modeltime)){install.packages( 'modeltime',dependencies = TRUE) } # Prophet, Boosting, ARIMA et al - Tidy time series forecasting with tidymodels

# Time Series 
if(!require(timetk)){install.packages( 'timetk',dependencies = TRUE) } #A tidyverse toolkit to visualize, wrangle, and transform time series data
if(!require(ggfortify)){install.packages( 'ggfortify',dependencies = TRUE) }#for plotting timeseries
if(!require(changepoint)){install.packages( 'changepoint',dependencies = TRUE) }
if(!require(strucchange)){install.packages( 'strucchange',dependencies = TRUE) }
if(!require(ggpmisc)){install.packages( 'ggpmisc',dependencies = TRUE) }

if(!require(tidyposterior)){install.packages( 'tidyposterior',dependencies = TRUE) } #post hoc analyses of resampling results generated by models -  Bayesian generalized linear models for this purpose and can be considered an upgraded version of the caret::resamples()
if(!require(tsibble)){install.packages( 'tsibble',dependencies = TRUE) }  #tsibble for time series based on tidy principles
if(!require(fable)){install.packages( 'fable',dependencies = TRUE) }  #for forecasting based on tidy principles
if(!require(forecast)){install.packages( 'forecast',dependencies = TRUE) }  #for forecast function
if(!require(tseries)){install.packages( 'tseries',dependencies = TRUE) } # GARCH etc Time series analysis and computational finance
if(!require(chron)){install.packages( 'chron',dependencies = TRUE) } #Create chronological objects which represent dates and times of day - not time zone friendly
if(!require(lubridate)){install.packages( 'lubridate',dependencies = TRUE) }
if(!require(directlabels)){install.packages( 'directlabels',dependencies = TRUE) } # put group labels on plot instead of legend
if(!require(zoo)){install.packages( 'zoo',dependencies = TRUE) } # time series
   
   
if(!require(rsample)){install.packages( 'rsample',dependencies = TRUE) }
if(!require(yardstick)){install.packages( 'yardstick',dependencies = TRUE) }
if(!require(reshape2)){install.packages( 'reshape2',dependencies = TRUE) }


if(!require(Kendall)){install.packages( 'Kendall',dependencies = TRUE) }
if(!require(compare)){install.packages( 'compare',dependencies = TRUE) }
if(!require(ROCR)){install.packages( 'ROCR',dependencies = TRUE) }


if(!require(class)){install.packages( 'class',dependencies = TRUE) }
if(!require(rpart)){install.packages( 'rpart',dependencies = TRUE) }
if(!require(rattle)){install.packages( 'rattle',dependencies = TRUE) }
if(!require(rpart.plot)){install.packages( 'rpart.plot',dependencies = TRUE) }
if(!require(party)){install.packages( 'party',dependencies = TRUE) }
if(!require(partykit)){install.packages( 'partykit',dependencies = TRUE) }
if(!require(Ckmeans.1d.dp)){install.packages( 'Ckmeans.1d.dp',dependencies = TRUE) }

# ML ------------------------------------------------------------
if(!require(xgboost)){install.packages( 'xgboost',dependencies = TRUE) }
if(!require(randomForest)){install.packages( 'randomForest',dependencies = TRUE) }

if(!require(tsne)){install.packages( 'tsne',dependencies = TRUE) }
if(!require(Rtsne)){install.packages( 'Rtsne',dependencies = TRUE) }

if(!require(neuralnet)){install.packages( 'neuralnet',dependencies = TRUE) }
if(!require(gbm)){install.packages( 'gbm',dependencies = TRUE) }
if(!require(mlbench)){install.packages( 'mlbench',dependencies = TRUE) }
if(!require(mixtools)){install.packages( 'mixtools',dependencies = TRUE) }#Analyzes finite mixture models for various parametric and semiparametric settings. This includes mixtures of parametric distributions (normal, multivariate normal, multinomial, gamma)
if(!require(superml)){install.packages('superml',dependencies = TRUE) } # SuperML R package is designed to unify the model training process in R 

if(!require(dbscan)){install.packages('dbscan',dependencies = TRUE) }
if(!require(cluster)){install.packages( 'cluster',dependencies = TRUE) } # Base R Methods for Cluster analysis

if(!require(arules)){install.packages('arules',dependencies = TRUE) }
if(!require(arulesViz)){install.packages('arulesViz',dependencies = TRUE) }


# Linear Algebra --------------------------------------------------
if(!require(Matrix)){install.packages( 'Matrix',dependencies = TRUE) }
if(!require(RcppEigen)){install.packages( 'RcppEigen',dependencies = TRUE) }
if(!require(expm)){install.packages( 'expm',dependencies = TRUE) }
if(!require(markovchain)){install.packages( 'markovchain',dependencies = TRUE) }
if(!require(rARPACK)){install.packages( 'rARPACK',dependencies = TRUE) }

# Bayesian -----------------------------------------------------
if(!require(bnlearn)){install.packages( 'bnlearn',dependencies = TRUE) }

if(!require(rjags)){install.packages( 'rjags',dependencies = TRUE) }
if(!require(runjags)){install.packages( 'runjags',dependencies = TRUE) }
if(!require(coda)){install.packages('coda',dependencies = TRUE) }
if(!require(model)){install.packages('modest',dependencies = TRUE) }
if(!require(R2jags)){install.packages('R2jags',dependencies = TRUE) }

if(!require(modeest)){install.packages( 'modeest',dependencies = TRUE) }

if(!require(rstan)){install.packages( 'rstan',dependencies = TRUE) }
if(!require(shinystan)){install.packages( 'shinystan',dependencies = TRUE) }
if(!require(rstanarm)){install.packages( 'rstanarm',dependencies = TRUE) }
if(!require(brms)){install.packages( 'brms',dependencies = TRUE) }
if(!require(rethinking)){install.packages( 'rethinking',dependencies = TRUE) }
if(!require(greta)){install.packages( 'greta',dependencies = TRUE) }
if(!require(bayesplot)){install.packages( 'bayesplot',dependencies = TRUE) }
if(!require(bayesm)){install.packages( 'bayesm',dependencies = TRUE) }

install.packages('INLA', repos=c(getOption('repos'), INLA='https://inla.r-inla-download.org/R/stable'), dep=TRUE)

if(!require(sf)){install.packages( 'sf',dependencies = TRUE) }

if(!require(fractal)){install.packages( 'fractal',dependencies = TRUE) }
if(!require(fractaldim)){install.packages( 'fractaldim',dependencies = TRUE) }

if(!require(Rwave)){install.packages( 'Rwave',dependencies = TRUE) }
if(!require(ifultools)){install.packages( 'ifultools',dependencies = TRUE) }
if(!require(wmtsa)){install.packages( 'wmtsa',dependencies = TRUE) }
if(!require(xml2)){install.packages( 'xml2',dependencies = TRUE) }


if(!require(leaps)){install.packages( 'leaps',dependencies = TRUE) } # n Regression subset selection, including exhaustive search regsubset 
if(!require(lme4)){install.packages( 'lme4',dependencies = TRUE) }

if(!require(stargazer)){install.packages( 'stargazer',dependencies = TRUE) }

if(!require(pscl)){install.packages( 'pscl',dependencies = TRUE) }
if(!require(ggmcmc)){install.packages( 'ggmcmc',dependencies = TRUE) }
if(!require(brms)){install.packages( 'brms',dependencies = TRUE) }

if(!require(spdep)){install.packages( 'spdep',dependencies = TRUE) }

if(!require(reshape2)){install.packages( 'reshape2',dependencies = TRUE) }

if(!require(stargaze)){install.packages( 'stargaze',dependencies = TRUE) }

if(!require(fs)){install.packages( 'fs',dependencies = TRUE) }

if(!require(ggfittext)){install.packages('ggfittext',dependencies = TRUE) }
if(!require(inspectdf)){install.packages('inspectdf',dependencies = TRUE) }

if(!require(sandwich)){install.packages('sandwich',dependencies = TRUE) }
if(!require(lmtest)){install.packages('lmtest',dependencies = TRUE) }

if(!require(faraway)){install.packages('faraway',dependencies = TRUE) }


if(!require(factoextra)){install.packages('factoextra',dependencies = TRUE) }

if(!require(StatMatch)){install.packages('StatMatch',dependencies = TRUE) }
if(!require(matchit)){install.packages('matchit',dependencies = TRUE) }


if(!require(rdist)){install.packages('rdist',dependencies = TRUE) }
if(!require(nomclust)){install.packages('nomclust',dependencies = TRUE) }

if(!require(FNN)){install.packages('FNN',dependencies = TRUE) }

# Information Theory 
if(!require(philentropy)){install.packages('philentropy',dependencies = TRUE) }
if(!require(infotheo)){install.packages('infotheo',dependencies = TRUE) }
if(!require(LaplacesDemon)){install.packages('LaplacesDemon',dependencies = TRUE) }

# GIS -------------------------------------------------------------
if(!require(rgdal)){install.packages( 'rgdal',dependencies = TRUE) } #Provides bindings to the 'Geospatial' Data Abstraction Library
if(!require(maptools)){install.packages( 'maptools',dependencies = TRUE) }

# Data ------------------------------------------------------------
if(!require(FedData)){install.packages( 'FedData',dependencies = TRUE) }


#Rwave dependency viewer.  Really helpful for R development
install.packages('Rwave')
library(Rwave)
devtools::install_github('datastorm-open/DependenciesGraphs')
#library(DependenciesGraphs)
# Prepare data
# dep <- envirDependencies('package:Rwave')
# # visualization
# plot(dep)

# #OR - run the shiny app interactively
# launch.app()

#List all user installed packages
ip <- as.data.frame(installed.packages()[,c(1,3:4)])
rownames(ip) <- NULL
ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]
print(ip, row.names=FALSE)
