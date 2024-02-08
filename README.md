# Next-Word-Prediction

## Objective
The main goal of this project is to build a shiny application that is able to predict the next word.

It has few sub tasks 
1. Data Cleaning 
2. Exploratory Analysis 
3. The creation of a predictive model.

The data file is from (http://www.corpora.heliohost.org/).

All NLP was done with the usage of a variety of well-known R packages.

Please find a full summary report linked here: (https://rpubs.com/sham_bhavi/swift)

## Predictive Algorithm Approach
After cleaning of the data removing whitespace,special charector,repeative words. etc.

This data sample was then tokenized called n-gram

Those aggregated bi-,tri- and quadgram term frequency matrices have been transferred into frequency dictionaries.

The resulting data.frames are used to predict the next word in connection with the text input by a user of the described application and the frequencies of the underlying n-grams table.

## Usage of the App
1. The use must enter some text into the input box
2. Based on the designed predictive algorithm, the most frequent possible next word will be displayed
3. The total number of N-grams used will also be displayed.

The app can be viewed on https://shams10.shinyapps.io/SwiftKeyDataPrediction/ 


