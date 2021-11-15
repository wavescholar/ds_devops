##Management of Data and Code for statistical analysis project

The scale and goals of statistical projects are as varied as the data itself. They can range from answering a basic question from a small csv file to deployment of a robust classifier in a commercial distributed computing environment.

The two main things that need to be organized in a statistical analysis project are code and data.  These are commended on in the sections below.  A major concern is versioning of code and data so that results are reproducible. Generally data and results will not be kept in version control.  Reports go in a document store.  Code goes in source control.  Data lives in one or more data stores.  Reports code and data all need versions.

##Management of R code for statistical analysis projects

Break project into 4 pieces:
load.R
clean.R
analyticFunctions.R
doAnalysis.R

load.R:Takes care of loading in all the data required. Typically this is a short file, reading in data from files, URLs and/or ODBC. Depending on the project at this point I'll either write out the workspace using save() or just keep things in memory for the next step.

clean.R: This is where all the ugly stuff lives - taking care of missing values, merging data frames, handling outliers.

analyticFunctions.R: Contains all of the functions needed to perform the actual analysis. sourcing this file should have no side effects other than loading up the function definitions. This means that you can modify this file and reload it without having to go back an repeat steps 1 & 2 which can take a long time to run for large data sets.

doAnalysis.R: Calls the functions defined in analyticFunctions.R to perform the analysis and produce charts and tables.

The main motivation for this set up is for working with large data whereby you don't want to have to reload the data each time you make a change to a subsequent step. Keeping  the code compartmentalized like this means you can come back to a long forgotten project and quickly read load.R and work out what data you need to update, and then look at do.R to work out what analysis was performed.

When manipulating data frames - use variables and never indices.  In this way we are intentional with our data.  Columns come and go in the raw data so it's best to catch problems early.


##Management of Data for statistical analysis projects

Keep raw data unaltered.

Document data pedigree.

Document transformations and steps to clean data - both manual steps and steps implemented in code.

##Versioning

As mentioned above - code data and reports all need versioning. Since reports depend on code and data, I generally use a report_verion=(data_version,code_version,date_of_report) scheme.

Reports and plots generally follow the same scheme.  Encoding of the version is done through the directory structure;

data_version\report_version


## Examples

In particular, as.numeric applied to a factor is meaningless, and may happen by implicit coercion.
To transform a factor f to approximately its original numeric values, as.numeric(levels(f))[f] is
recommended and slightly more efficient than  as.numeric(as.character(f)).

On require versus library
Both require() and library() can load (strictly speaking, attach) an R package.
 library() loads a package, and require() tries to load  a package.

```{r}getwd() #Get working directory
ls()
setwd()
```

ctrl 1 or 2 moves from edit to command in RstudioServer

Clear all plots

```{r}
dev.off(dev.list()["RStudioGD"])
```
In RStudio, document output can be generated using knitr by clicking on the knit button.
You can also directly enter a command in the R command line. If you leave out the second argument, then the output
specification in the markdown document determines the output format:
rmarkdown::render("introduction.Rmd","pdf_document").
To create the output in all formats mentioned in the markdown document, use the following command:

```{r}
rmarkdown::render("introduction.Rmd","all")
```

pch = "."

The argument controlling the box around a graph is bty (i.e., box type).
To suppress the box entirely, issue the
par(bty="n")

par(bty = "n")  
stripchart(Volume, method = "jitter", pch = 20,   xlab = "Volume in cubic feet")
axis(1, col = "dodgerblue4", at = c(10,20,30,40,50,60,70,80))

The mtext() command adds a note outside of the plotting area of the graph.

```{r}
mtext("Data source: Minitab Student Handbook",
side = 1, line = 4, adj = 1, col = "dodgerblue4", cex = .7)
```
Dotchart
```{r}
dotchart(data2$X1, labels = row.names(data2),
    cex = .5, main = "X1 Chart Title",
    xlab = "X1 description")
```

# Parallel with error handling 

```{r}
library(randomForest)
library(foreach)


x <- 1:100
beta <- 1
e <- rnorm(100)
y <- beta * x + e
plot(x, y)

rf <- foreach(ntree=rep(250, 4), .combine=combine, .packages='randomForest') %dopar%
{
  result<-tryCatch(
    {

      randomForest(data.frame(x), y, ntree=ntree)
    }, error=function(e){
      class(e)<-class(simpleWarning(''))
      warning(e)
      NULL
    }
  )
}
```
Many R functions recycle arguments. This means that if there are not enough items in a vector, for instance, R will reuse items. So, to make Figure 4-4, the argument col = c("darkblue","dodgerblue") applies to the 50 states. Because there are only two colors specified, when R needs to apply a color to the third state, it goes back to the first color, and so on until all the states have colors.


Box Plot Demo

```{r}
par(mfrow=c(2,2))   #set up page for 2 rows of 2 graphs each
attach(MathAchieve)

boxplot(MathAch ~ Minority, xlab = "boxplot(MathAch~Minority)",
  main = "a. Math by Minority", cex = .4)

boxplot(MathAch~Minority*Sex,
  xlab = "boxplot(MathAch ~ Minority*Sex)",
  main = "b. Math by Min & Sex", cex = .4)

boxplot(MathAch ~ Minority * Sex,
  xlab = "boxplot(MathAch ~ Minority * Sex)",
  sub = 'varwidth=TRUE))', varwidth = TRUE,
  main = "c. By Min & Sex, width~size", cex = .4)

boxplot(MathAch ~ Minority*Sex,
  xlab = 'boxplot(MathAch ~ Minority * Sex',
  varwidth = TRUE, col = c("red","blue"),
  main = "d. Same as c. plus color",
  cex = .4, sub = 'varwidth = TRUE,
  col = c("red","blue"))')
```

Wonderful Plot
```{r}
attach(Nimrod)
# par() sets bkgrnd color, foreground color, axis color,
# text size (cex), horiz.
# text on y-axis (las=1), margins (mar). Graph too big for
# default margins. ?par for more info on above arguments.

par(bg = "white", fg = "white",
  col.axis = "gray47", mar = c(7,8,5,4),
  cex = .65, las = 1)

# boxplot() determines formula (time ~ level * medium),
# makes plot horizontal,
# sets color for box border and box colors (col),
# creates titles (main, xlab), creates names
# for the combinations of level*medium (names), names size
# (cex.names). One of the names is "" because there is no
# category "amateur organ."

boxplot(time ~ level * medium, horizontal = TRUE,
  border = "cadetblue",
  main="Performance Times of Elgar's Nimrod",
  col = c("deepskyblue","peachpuff4"),
  xlab = "Time in seconds",
  names = c("brass band","brass band","concert
  band", "concert band","", "organ ", "orchestra","orchestra"),
  cex.names = .4)

# abline() puts vert. line at time = 186 sec. to show the
# performance conducted by Elgar. Line type (lty) dotted & color
# (col) black.

abline(v = 186, lty = "dotted", col = "black")

# legend() chooses legend text & color & location on the graph.
# Legend shows that pros are peachpuff4 & amateurs are
# deepskyblue.

legend("right", title = "Level", title.col = "black",
  c("Professional","Amateur"),
  text.col = c("peachpuff4","deepskyblue"),
  text.font = 2, cex = 1.2)

# mtext() puts text at a place specified by the user
mtext("  Elgar himself - - >", side = 3,
  line = -2, adj = 0,
  cex = .7, col = "black")

# axis() modifies x-axis (1)  & sets the color & length and
# tickmarks
axis(1, col = "cadetblue", at = c(160,200,250,300))

detach(Nimrod)
```



label = T adds the frequency number at the top of each bar, col="maroon" determines the color of the bars, and the xlab = argument provides a more descriptive label on the x-axis:
```{r}
hist(sbp, main = "sbp dataset", las = 1, label = T,
  col = "maroon", xlab = "Systolic blood pressure")
```

Nice desnity   -
```{r}
smoothScatter(x,y)
lines(lowess(x,y))
```

If you get a bandwidth error try manually specifying the bandwidth. Possibly the function's attempt to select sensible bandwidth is failing. For smoothScatter, bandwidth seems to have the same units as your data, so if your range is 1-100, try bandwidth=2 (smoothing over 2%-wide regions). Also be aware that x and y can have different scales, and therefore need different bandwidths: bandwidth=c(2, 0.1)

smoothScatter uses a color ramp.  Here are examples of how to generate color ramps for smooth scatter

```{r}
pal <- colorRampPalette(c("red", "blue"))

plot(rnorm(1000), seq(1, 1000, by = 1)
      , col = pal(1000)
      , xlab = "x"
      , ylab = "y"
      , main = "Fun with rnorm + colorRampPalette")

# => view Plot 1

pal <- colorRampPalette(c("red", "yellow", "blue"))

plot(rnorm(1000), seq(1, 1000, by = 1)
      , col = pal(1000)
      , xlab = "x"
      , ylab = "y"
      , main = "Fun with rnorm + colorRampPalette (double rainbow)")

# => view Plot 2

pal <- colorRampPalette(c("dark blue", "light blue"))

plot(rnorm(1000), seq(1, 1000, by = 1)
      , col = pal(1000)
      , xlab = "x"
      , ylab = "y"
      , main = "Fun with rnorm + colorRampPalette (the blues)")
```


Random Sample
```{r}
dfSampled <- df[sample(1:nrows(df),sampleSize),]
```

Mode of data
```{r}
temp <-table(X1)
names(temp)[temp==max(temp)]
```


Plotting Contours
```{r}
if(!require("mixtools")) { install.packages("mixtools");  require("mixtools") }
data_f <- faithful
plot(data_f$waiting, data_f$eruptions)
data_f.k2 = mvnormalmixEM(as.matrix(data_f), k=2, maxit=100, epsilon=0.01)
data_f.k2$mu # estimated mean coordinates for the 2 multivariate Gaussians
data_f.k2$sigma # estimated covariance matrix
```

group data for coloring

```{r}
data_f$group <- factor(apply(data_f.k2$posterior, 1, which.max))
# plotting
plot(data_f$eruptions, data_f$waiting, col = data_f$group)
for (i in 1: length(data_f.k2$mu))  ellipse(data_f.k2$mu[[i]],data_f.k2$sigma[[i]], col=i)


# needs ggplot2 package
require("ggplot2")
# ellipsis data
ell <- cbind(data.frame(group=factor(rep(1:length(data_f.k2$mu), each=250))),
             do.call(rbind, mapply(ellipse, data_f.k2$mu, data_f.k2$sigma,
                                   npoints=250, SIMPLIFY=FALSE)))

# plotting command
p <- ggplot(data_f, aes(color=group)) +
  geom_point(aes(waiting, eruptions)) +
  geom_path(data=ell, aes(x=`2`, y=`1`)) +
  theme_bw(base_size=16)
print(p)
```

How to convert datatypes in bulk
```{r}instanceconvert <- colnames(df[1:10])
df[,instanceconvert] <-
  lapply(df[,instanceconvert,drop=FALSE],as.numeric)
```

Marginal Histograms for ggplot2
```{r}
library(ggplot2)
# create dataset with 1000 normally distributed points
df <- data.frame(x = rnorm(1000, 50, 10), y = rnorm(1000, 50, 10))
# create a ggplot2 scatterplot
p <- ggplot(df, aes(x, y)) + geom_point() + theme_classic()
# add marginal histograms
ggExtra::ggMarginal(p, type = "histogram")
```

Use cut to convert a continuous variable to a factor.  
```{r}# Here is a nice way to bin numeric data.
 h<-hist(df$dT,12)
 b<-h["breaks"]
 bc<-rapply(b,c)
 typeof(rapply(b,c))
 x <-cut(df$dT,bc)
```


Use this to diagnose errors
```{r}
 traceback()
```

Upgrading R on Windows is not easy. While the R FAQ offer guidelines, some users may prefer to simply run a command in order to upgrade their R to the latest version. That is what the new {installr} package is all about.
The {installr} package offers a set of R functions for the installation and updating of software (currently, only on Windows OS), with a special focus on R itself. To update R, you can simply run the following code:

```{r}
# installing/loading the package:
if(!require(installr)) {
install.packages("installr"); require(installr)} #load / install+load installr

# using the package:
updateR()
```

###Lattice Graphics are powerful methods of data visualization
One of the most powerful features of lattice graphs is the ability to add conditioning variables.
 If one conditioning variable is present, a separate panel is created for each level.
 If two conditioning variables are present, a separate panel is created for each combination of levels for
 the two variables. It’s rarely useful to include more than two conditioning variables.
 Typically, conditioning variables are factors. But what if you want to condition on a continuous variable?
 One approach would be to transform the continuous variable into a discrete variable using R’s cut() function.
 Alternatively, the lattice package provides functions for transforming a continuous variable into a data structure
 called a shingle. Specifically, the continuous variable is divided into a series of (possibly) overlapping ranges.
 For example, the function
 myshingle <- equal.count(x, number=n, overlap=proportion)
 takes continuous variable x and divides it into n intervals with proportion overlap and equal numbers of bservations
 in each range, and returns it as the variable myshingle (of class shingle). Printing or plotting this object
 (for example, plot(myshingle)) displays the shingle’s intervals.
 Once a continuous variable has been converted to a shingle, you can use it as a conditioning variable.

#------------------------------------Categorical Data
# Discrete distributions
# distplot Plots for discrete distributions
# goodfit Goodness-of-fit for discrete distributions
# ordplot Ord plot for discrete distributions
# poisplot Poissonness plot
# rootgram Hanging rootograms
# Two-way and n-way tables
# agreementplot Observer agreement chart
# fourfold Fourfold displays for 2 × 2 × k tables
# sieve Sieve diagrams
# mosaic Mosaic displays
# pairs.table Matrix of pairwise association displays
# structable Manipulate high-dimensional contingency tables
# triplot Trilinear plots for n × 3 tables
# glm Fitting generalized linear models
# gnm Fitting generalized non-linear models, e.g., RC(1) model
# loglm MASS package: Fitting loglinear models
# Rcmdr Menu-driven package for statistical analysis and graphics
# car Graphics and extensions of generalized linear models
# effects Effects plots for generalized linear models
# vcdExtra package
# vcd-tutorial Vignette on working with categorical data and the vcd package
# mosaic.glm mosaic displays for GLMs and GNMs
# mosaic3d 3D mosaic displays
# glmlist Methods for working with lists of models

Here's how to do error handling in ply functions
```{r}
calculatEntropy <- function(df) {
  result<-tryCatch(
    {Data <- df$consumption
  result <- array(dim=c(1,2))
  tsRep <- ts(data=tail(Data, 500))
  AE <- approx_entropy(tsRep, edim=2, r=0.2*sd(tsRep), elag=1)
  SE <- sample_entropy(tsRep, edim=2, r=0.2*sd(tsRep), tau=1)
  result[1] <- AE
  if(is.na(SE) | is.nan(SE)) {      
    result[2] <- 0
  } else {      
    result[2] <- SE
  }
    }, error=function(e){
      class(e)<-class(simpleWarning(''))
      warning(e)
      NULL
      })
}
```

 Merge data frame base on rownames
```{r}
cbind(t, z[, "symbol"][match(rownames(t), rownames(z))])
```


Fast file IO better than read.csv

https://cran.r-project.org/web/packages/data.table/index.html
```{r}
# Read voltage
dataFilePath      = "E:/Analyses/Electric Meter Over-temperature/Data/121715/icon_voltage.csv"
dataFrameHeaders  = c("repid", "timeofevent", "maximum_voltage")
missingFlag         = "\\N"
dataRaw = fread(dataFilePath,
                 na.strings = missingFlag,
                 colClasses = dataFrameTypes)
```{r}

Solarized GGplot
```{r}
library("ggplot2")
library("ggthemes")

p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  ggtitle("Cars")

p2 <- ggplot(mtcars, aes(x = wt, y = mpg, colour = factor(gear))) +
  geom_point() +
  ggtitle("Cars")

p3 <- p2 + facet_wrap(~ am)
print(p3)

p4 <- p3 + theme_solarized(light = FALSE) +
  scale_colour_solarized("red")
print(p4)

p5 <-p3 + theme_solarized_2(light = FALSE) +
  scale_colour_solarized("blue")
print(p5)
```



GGally Scatterplot For Multiclass
```{r}
# another option
makePairs <- function(data)
{
  grid <- expand.grid(x = 1:ncol(data), y = 1:ncol(data))
  grid <- subset(grid, x != y)
  all <- do.call("rbind", lapply(1:nrow(grid), function(i) {
    xcol <- grid[i, "x"]
    ycol <- grid[i, "y"]
    data.frame(xvar = names(data)[ycol], yvar = names(data)[xcol],
               x = data[, xcol], y = data[, ycol], data)
  }))
  all$xvar <- factor(all$xvar, levels = names(data))
  all$yvar <- factor(all$yvar, levels = names(data))
  densities <- do.call("rbind", lapply(1:ncol(data), function(i) {
    data.frame(xvar = names(data)[i], yvar = names(data)[i], x = data[, i])
  }))
  list(all=all, densities=densities)
}

# expand iris data frame for pairs plot
gg1 = makePairs(iris[,-5])

# new data frame mega iris
mega_iris = data.frame(gg1$all, Species=rep(iris$Species, length=nrow(gg1$all)))

# pairs plot
ggplot(mega_iris, aes_string(x = "x", y = "y")) +
  facet_grid(xvar ~ yvar, scales = "free") +
  geom_point(aes(colour=Species), na.rm = TRUE, alpha=0.8) +
  stat_density(aes(x = x, y = ..scaled.. * diff(range(x)) + min(x)),
               data = gg1$densities, position = "identity",
               colour = "grey20", geom = "line")
```






Silouhette Chart Demo for evaluating quality of clustering algorithm
```{r}
  data(ruspini)
pr4 <- pam(ruspini, 4)
str(si <- silhouette(pr4))
(ssi <- summary(si))
plot(si) # silhouette plot
plot(si, col = c("red", "green", "blue", "purple"))# with cluster-wise coloring

si2 <- silhouette(pr4$clustering, dist(ruspini, "canberra"))
summary(si2) # has small values: "canberra"'s fault
plot(si2, nmax= 80, cex.names=0.6)

op <- par(mfrow= c(3,2), oma= c(0,0, 3, 0),
          mgp= c(1.6,.8,0), mar= .1+c(4,2,2,2))
for(k in 2:6)
   plot(silhouette(pam(ruspini, k=k)), main = paste("k = ",k), do.n.k=FALSE)
mtext("PAM(Ruspini) as in Kaufman & Rousseeuw, p.101",
      outer = TRUE, font = par("font.main"), cex = par("cex.main")); frame()

## the same with cluster-wise colours:
c6 <- c("tomato", "forest green", "dark blue", "purple2", "goldenrod4", "gray20")
for(k in 2:6)
   plot(silhouette(pam(ruspini, k=k)), main = paste("k = ",k), do.n.k=FALSE,
        col = c6[1:k])
par(op)

## clara(): standard silhouette is just for the best random subset
data(xclara)
set.seed(7)
str(xc1k <- xclara[sample(nrow(xclara), size = 1000) ,])
cl3 <- clara(xc1k, 3)
plot(silhouette(cl3))# only of the "best" subset of 46
## The full silhouette: internally needs large (36 MB) dist object:
sf <- silhouette(cl3, full = TRUE) ## this is the same as
s.full <- silhouette(cl3$clustering, daisy(xc1k))
if(paste(R.version$major, R.version$minor, sep=".") >= "2.3.0")
   stopifnot(all.equal(sf, s.full, check.attributes = FALSE, tolerance = 0))
## color dependent on original "3 groups of each 1000":
plot(sf, col = 2+ as.integer(names(cl3$clustering) ) %/% 1000,
     main ="plot(silhouette(clara(.), full = TRUE))")

## Silhouette for a hierarchical clustering:
ar <- agnes(ruspini)
si3 <- silhouette(cutree(ar, k = 5), # k = 4 gave the same as pam() above
                 daisy(ruspini))
plot(si3, nmax = 80, cex.names = 0.5)
## 2 groups: Agnes() wasn't too good:
si4 <- silhouette(cutree(ar, k = 2), daisy(ruspini))
plot(si4, nmax = 80, cex.names = 0.5)
```
