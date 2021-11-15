FROM r-base:4.0.3

RUN R --no-save -e "install.packages(c('log4r','foreach','doMC','sqldf','data.table','usethis','gridExtra','tictoc','devtools','base64enc'))"
RUN R --no-save -e "install.packages(c('bayesplot','parallel','pscl','sandwich','lmtest','faraway','lattice','hexbin','httr', 'rversions','extrafont' ))"
RUN R --no-save -e "install.packages(c('knitr' , 'rmarkdown', 'pander','kable','bookdown','latex2exp', 'GGally', 'ggthemes','RColorBrewer' ))"
RUN R --no-save -e "install.packages(c('MASS','car','plyr','xtable','ggplot2' ,'grid','dplyr','lme4','RJDBC','factoextra','dbscan','StatMatch','arules','arulesViz'))"
RUN R --no-save -e "install.packages(c('lintr','covr','Cairo','rdist','nomclust'))"
RUN R --no-save -e "install.packages(c('superml'),dependencies=TRUE)"
RUN R --no-save -e "install.packages(c('ggraph','tidygraph','igraph'))"
RUN R --no-save -e "install.packages(c('FNN','philentropy','infotheo','LaplacesDemon'))"
RUN R --no-save -e "install.packages(c('coda' , 'modest', 'rjags','R2jags','rstan', 'shinystan', 'rstanarm','papeR','faraway'))"
RUN R --no-save -e "install.packages(c('skimr','MatchIt','ggeffects','wesanderson','ggsci','pkgdown'),dependencies = TRUE)"

EXPOSE 6060

RUN echo "hi there"
ENTRYPOINT ["sh"]



#CMD ["tf-server", "--protected-mode no"]
