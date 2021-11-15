#Shiny RStudio and shiny-server notes.

This document describes operations and interop between shiny and R / RStudio

First follow the instructions in RStudio-shiny-server.sh to get setup
Note that you may have to install rmarkdown after the setup.  It appears
```
sudo su - ruser -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""
```
is not working for some reason.  It's likely a repo issue. 


There are two main types of Shiny apps 
- A client server model with R scripts for each (server.R and ui.R ).  These contain defitions for shinyUI and shinyServer.  I believe it's also possible to define both of these in one script.  Also I've seen
- rmarkdown - this is the basis of the new notebook rendering in RStudio. The app is contained in an Rmd file. It's not clear yet if this is only for serving static data. 
- custom javascript widgets may be embedded in a shiny app as well. There is a nice tutorial here <http://shiny.rstudio.com/tutorial/>

To create a dashboard we start with a index.html located in the shiny app directory;

/srv/shiny-server/MyApp

Then we create the dashboard via iframes
```
      <div id="shiny">
        <iframe src="./sample-apps/widget1/" style="border: 1px solid #AAA; width: 290px; height: 460px"></iframe>
        <div class="caption">
          Put a caption here
        </div>
```
Put the Rmd or the server.R/ui.R files in the widget1 location

/srv/shiny-server/MyApp/widget1

Then if shiny-server is hosted on xx.xx.xx.xx:port the app can be accessed via xx.xx.xx.xx:port\MyApp

There is a tutorial on how to set up hosting on https here <https://www.r-bloggers.com/deploying-your-very-own-shiny-server/>.  This is a good idea that should be followed up on.


Prior to Shiny 0.10, the server.R and ui.R files required calls to shinyServer() and shinyUI() respectively. 
As of Shiny 0.10.2, applications can be created with a single file, app.R, which contains both the UI and server code. This file must return an object created by the shinyApp() function. Here is a single file shiny app loading data from a local file
```
library(shiny)

# Define the fields we want to save from the form
fields <- c("name", "used_shiny", "r_num_years")

# Shiny app with 3 fields that the user can submit data for
shinyApp(
  ui = fluidPage(
    DT::dataTableOutput("responses", width = 300), tags$hr(),
    textInput("name", "Name", ""),
    checkboxInput("used_shiny", "I've built a Shiny app in R before", FALSE),
    sliderInput("r_num_years", "Number of years using R", 0, 25, 2, ticks = FALSE),
    actionButton("submit", "Submit")
  ),
  server = function(input, output, session) {
    
    # Whenever a field is filled, aggregate all form data
    formData <- reactive({
      data <- sapply(fields, function(x) input[[x]])
      data
    })
    
    # When the Submit button is clicked, save the form data
    observeEvent(input$submit, {
      saveData(formData())
    })
    
    # Show the previous responses
    # (update with current response when Submit is clicked)
    output$responses <- DT::renderDataTable({
      input$submit
      loadData()
    })     
  }
)

```


Here are steps to set up shiny-server to run as another user.  These need revising - it did not work the first time we tried it.

```
Edit /etc/init/shiny-server.conf, and
Add the following two lines at the beginning
setuid hadoop
setgid hadoop
Change the 3rd last line to
exec shiny-server --pidfile=/home/hadoop/shiny-server.pid >> /home/hadoop/shiny-server.log 2>&1
Note that Shiny has two default log file locations.
/var/log/shiny-server.log contains the logs for the server itself, and is defined in /etc/init/shiny-server.conf
/var/log/shiny-server/ is the folder that contains log files for your applications, and is defined in /etc/shiny-server/shiny-server.conf.
Once you made the changes above and also changed the run_as user, start shiny-server again with  sudo start shiny-server, and you'll notice that shiny-server is in fact running as the non-root user, and the warning in the log file will be gone too.
```

