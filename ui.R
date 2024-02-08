library(shiny)
library(dplyr)
library(tm)
library(shinythemes)
suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
shinyUI(navbarPage("Data science Specialization : Capstone Project",
                   tabPanel("Application",
                            HTML("<strong>SL</strong>"),
                            br(),
                            HTML("<strong>Date:08/02/2024</strong>"),
                            br(),
                            # Sidebar
                            sidebarLayout(
                              sidebarPanel(
                                helpText("Enter a  sentence to get next predicted word"),
                                textInput("inputString", "Enter a sentence",value = "")
                                
                              ),
                              mainPanel(
                                h2("Next Predicted word"),
                                verbatimTextOutput("prediction"),
                                strong("Entered Sentence:"),
                                tags$style(type='text/css', '#text1 {background-color: #ffafcc; color: #457b9d;}'), 
                                textOutput('text1'),
                                br(),
                                strong("N-gram used"),
                                tags$style(type='text/css', '#text2 {background-color: #ffc8dd; color: #457b9d;}'),
                                textOutput('text2')
                              )
                            )
                            
                   ),
                   tabPanel("About",
                            mainPanel(
                              h3("About Next Word Predict"),
                              br(),
                              div("Next Word Predict is a Shiny app that uses a text
                            prediction algorithm to predict the next word(s)
                            based on text entered by a user. it also sows the number of n-grams used.",
                                  br(),
                                  br(),
                                  "The predicted next word will be shown when the app
                            detects that you have finished typing one or more
                            words. When entering text, please allow a few
                            seconds for the output to appear.",
                                  br()
                            )
                   )
)
)
)

