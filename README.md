Application of Data Mining
By: Roshen Cherian and Tristan Gooding

Data: [Playbyplay for 2023](url)   [Link to NflVerse](url)   [Data Definitions](url)    




1. **Dataset Acquisition:**
The dataset we are using for this project is the 2023 NFL play by play dataset. This dataset is gathered according to official released NFL statistics. The data records 372 features for each play during the season. Our dataset has 49,965 instances.



  

3. **Data Analysis:**
The dataset had missing values for certain plays such as passing data for run plays. These are taken care of by deletion. Selecting and deriving relevant features from the dataset required decisions to make sure the selected data is relevant to our goal. Fortunately the model did not have any extreme outliers giving any issue. For the most part the data is relatively “clean”, although the data records many attributes that are not needed for our modeling. For these attributes we simply removed them from the dataset as they hold no correlation to our goal state. We also had a mix of numerical and categorical data.
Categorical Variables: We used one-hot encoding to use pass_location in our neural network.
Numerical Variables: Continuous variables such as air_yards, score_difference, ydstogo, and yardline_100 were represented as numeric data types.

  

4. **Data Preprocessing:**
The dataset was cleaned of missing values, particularly in regard to the features we wanted. This cut the size of the dataset almost in half as many plays don't involve dropbacks. Numerical features were normalized to increase accuracy of the models. Once this was done, the split data was ready for model training and testing, with no significant data quality issues remaining.

**What challenges did we face during data cleaning and preprocessing?**
We had to deal with what data entries to remove to get the dataset down to only what we wanted. It was more difficult than just filtering for pass plays because there were special instances in which some other variables were missing too. To handle missing values, we ran a loop to see how many missing values there were in each variable and then looked at the data to see in what cases those values were missing. We often decided to remove those entries or set it equal to similar values.


4. **Implementation:**
Neural net implementation: Our first model was a neural network with 2 hidden layers, the first layer had 5 neurons and the second layer had 3. 

Decision tree implementation:  Our second model was a decision tree that was split into a balanced tree with a depth of 4

**How did we choose which models to implement?**
We wanted one deep learning model and one explainable model, so we chose a neural network and a decision tree

**What were the key factors that influenced the performance of our models?**
The decision tree model allowed us to see the importance of each input variable. It showed that whether the pass was completed or not was the most important variable, then the air yards, then whether there was an interception or a touchdown.

The neural network results are harder to explain, but I believe we got good performance that reflects the strength of the pattern in the data. The accuracy also greatly improved after normalizing the data.

**How did we interpret the results of our chosen models?**
Our chosen metric was accuracy within a threshold. If the model guessed the QB EPA within a hyperparameter threshold value, it was counted as an accurate prediction. The standard deviation of QB EPA in the dataset was 1.25, so our threshold was 1 as a reasonable hyperparameter.
The accuracy of the decision tree was 84.3%
The accuracy of the neural network was 85.4%

We were surprised that the decision tree performed so well for this task, but the actual EPA model that we were attempting to recreate is also a decision tree so that helps explain this outcome. (source: https://opensourcefootball.com/posts/2020-09-28-nflfastr-ep-wp-and-cp-models/)


**What insights can we draw from the data and our analysis?**
There are two main impacts from our analysis. The first is seeing what factors are most heavily weighed in determining QB EPA. The strength of this analysis depends on the accuracy of our model of course, but because our decision tree model is accurate, we can see the importance of the factors. We can conclude, unsurprisingly, that whether or not a pass was completed is the most important factor for QB EPA, followed by how many air yards the pass traveled.

The second impact is the ability to reverse engineer a rough estimate of QB_EPA by looking at the resulting data. The actual EPA model is highly complex and difficult to understand, but we can still recreate a rough estimate using our data mining techniques.


