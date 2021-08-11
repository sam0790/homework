## Final Project Description

We're selected the dataset of covid-19 test results for 2020 and 2021: https://www.stlouis-mo.gov/data/datasets/distribution.cfm?id=156

### Preprocessing steps we've used

* made sure all the features have the correct data types
* added 2 new columns for month and year
* performed the feature selection with RFE method
* created a box plot to check the outlier and removed the outliers
* we checked the variance and scaled the data using standard scaler method
* before modeling the data, we visualized the data by creating a scatter plot 

### Modeling

We have used 3 total models, 2 of which are supervbied and one of them is unsupervised. 
For the supervised we've used Linear Regression and Random Forest. For the unsupervised one, we used K-Means; specifically we've  used elbow graphs and a dendrogram to select the optimal number of clusters for the effective modeling.

For both of the supervised learning methods, we've checked the training and testing data accuracy scores and they were pretty close to each other which means our models were not underfitted or overfitted.


