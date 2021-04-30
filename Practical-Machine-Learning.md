---
title: "Practical Machine Learning"
author: "Nicholas Vitsentzatos"
date: "29/4/2021"
output: html_document
---

#Synopsis
Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways.The goal of your project is to predict the manner in which they did the exercise.

The training data for this project are available here: 

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data are available here:

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

The data for this project come from this source: http://groupware.les.inf.puc-rio.br/har.

## Loading Data and the required library

```r
library(caret)
```

```
## Warning: package 'caret' was built under R version 4.0.5
```

```
## Loading required package: lattice
```

```
## Loading required package: ggplot2
```

```r
#download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",destfile="training.csv")
#download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",destfile="testing.csv")
Training<-read.csv("training.csv")
Testing<-read.csv("testing.csv")
dim(Training);dim(Testing)
```

[1] 19622   160
[1]  20 160
So 19622 observations for the training data set,20 for the test data and 160 variable in both of the data sets.Let's take a look to get a sense of the preprocessing we have to do.
## Processing Data

```r
colnames(Training)
```

```
##   [1] "X"                        "user_name"                "raw_timestamp_part_1"     "raw_timestamp_part_2"    
##   [5] "cvtd_timestamp"           "new_window"               "num_window"               "roll_belt"               
##   [9] "pitch_belt"               "yaw_belt"                 "total_accel_belt"         "kurtosis_roll_belt"      
##  [13] "kurtosis_picth_belt"      "kurtosis_yaw_belt"        "skewness_roll_belt"       "skewness_roll_belt.1"    
##  [17] "skewness_yaw_belt"        "max_roll_belt"            "max_picth_belt"           "max_yaw_belt"            
##  [21] "min_roll_belt"            "min_pitch_belt"           "min_yaw_belt"             "amplitude_roll_belt"     
##  [25] "amplitude_pitch_belt"     "amplitude_yaw_belt"       "var_total_accel_belt"     "avg_roll_belt"           
##  [29] "stddev_roll_belt"         "var_roll_belt"            "avg_pitch_belt"           "stddev_pitch_belt"       
##  [33] "var_pitch_belt"           "avg_yaw_belt"             "stddev_yaw_belt"          "var_yaw_belt"            
##  [37] "gyros_belt_x"             "gyros_belt_y"             "gyros_belt_z"             "accel_belt_x"            
##  [41] "accel_belt_y"             "accel_belt_z"             "magnet_belt_x"            "magnet_belt_y"           
##  [45] "magnet_belt_z"            "roll_arm"                 "pitch_arm"                "yaw_arm"                 
##  [49] "total_accel_arm"          "var_accel_arm"            "avg_roll_arm"             "stddev_roll_arm"         
##  [53] "var_roll_arm"             "avg_pitch_arm"            "stddev_pitch_arm"         "var_pitch_arm"           
##  [57] "avg_yaw_arm"              "stddev_yaw_arm"           "var_yaw_arm"              "gyros_arm_x"             
##  [61] "gyros_arm_y"              "gyros_arm_z"              "accel_arm_x"              "accel_arm_y"             
##  [65] "accel_arm_z"              "magnet_arm_x"             "magnet_arm_y"             "magnet_arm_z"            
##  [69] "kurtosis_roll_arm"        "kurtosis_picth_arm"       "kurtosis_yaw_arm"         "skewness_roll_arm"       
##  [73] "skewness_pitch_arm"       "skewness_yaw_arm"         "max_roll_arm"             "max_picth_arm"           
##  [77] "max_yaw_arm"              "min_roll_arm"             "min_pitch_arm"            "min_yaw_arm"             
##  [81] "amplitude_roll_arm"       "amplitude_pitch_arm"      "amplitude_yaw_arm"        "roll_dumbbell"           
##  [85] "pitch_dumbbell"           "yaw_dumbbell"             "kurtosis_roll_dumbbell"   "kurtosis_picth_dumbbell" 
##  [89] "kurtosis_yaw_dumbbell"    "skewness_roll_dumbbell"   "skewness_pitch_dumbbell"  "skewness_yaw_dumbbell"   
##  [93] "max_roll_dumbbell"        "max_picth_dumbbell"       "max_yaw_dumbbell"         "min_roll_dumbbell"       
##  [97] "min_pitch_dumbbell"       "min_yaw_dumbbell"         "amplitude_roll_dumbbell"  "amplitude_pitch_dumbbell"
## [101] "amplitude_yaw_dumbbell"   "total_accel_dumbbell"     "var_accel_dumbbell"       "avg_roll_dumbbell"       
## [105] "stddev_roll_dumbbell"     "var_roll_dumbbell"        "avg_pitch_dumbbell"       "stddev_pitch_dumbbell"   
## [109] "var_pitch_dumbbell"       "avg_yaw_dumbbell"         "stddev_yaw_dumbbell"      "var_yaw_dumbbell"        
## [113] "gyros_dumbbell_x"         "gyros_dumbbell_y"         "gyros_dumbbell_z"         "accel_dumbbell_x"        
## [117] "accel_dumbbell_y"         "accel_dumbbell_z"         "magnet_dumbbell_x"        "magnet_dumbbell_y"       
## [121] "magnet_dumbbell_z"        "roll_forearm"             "pitch_forearm"            "yaw_forearm"             
## [125] "kurtosis_roll_forearm"    "kurtosis_picth_forearm"   "kurtosis_yaw_forearm"     "skewness_roll_forearm"   
## [129] "skewness_pitch_forearm"   "skewness_yaw_forearm"     "max_roll_forearm"         "max_picth_forearm"       
## [133] "max_yaw_forearm"          "min_roll_forearm"         "min_pitch_forearm"        "min_yaw_forearm"         
## [137] "amplitude_roll_forearm"   "amplitude_pitch_forearm"  "amplitude_yaw_forearm"    "total_accel_forearm"     
## [141] "var_accel_forearm"        "avg_roll_forearm"         "stddev_roll_forearm"      "var_roll_forearm"        
## [145] "avg_pitch_forearm"        "stddev_pitch_forearm"     "var_pitch_forearm"        "avg_yaw_forearm"         
## [149] "stddev_yaw_forearm"       "var_yaw_forearm"          "gyros_forearm_x"          "gyros_forearm_y"         
## [153] "gyros_forearm_z"          "accel_forearm_x"          "accel_forearm_y"          "accel_forearm_z"         
## [157] "magnet_forearm_x"         "magnet_forearm_y"         "magnet_forearm_z"         "classe"
```

```r
head(Training)
```

```
##   X user_name raw_timestamp_part_1 raw_timestamp_part_2   cvtd_timestamp new_window num_window roll_belt
## 1 1  carlitos           1323084231               788290 05/12/2011 11:23         no         11      1.41
## 2 2  carlitos           1323084231               808298 05/12/2011 11:23         no         11      1.41
## 3 3  carlitos           1323084231               820366 05/12/2011 11:23         no         11      1.42
## 4 4  carlitos           1323084232               120339 05/12/2011 11:23         no         12      1.48
## 5 5  carlitos           1323084232               196328 05/12/2011 11:23         no         12      1.48
## 6 6  carlitos           1323084232               304277 05/12/2011 11:23         no         12      1.45
##   pitch_belt yaw_belt total_accel_belt kurtosis_roll_belt kurtosis_picth_belt kurtosis_yaw_belt
## 1       8.07    -94.4                3                                                         
## 2       8.07    -94.4                3                                                         
## 3       8.07    -94.4                3                                                         
## 4       8.05    -94.4                3                                                         
## 5       8.07    -94.4                3                                                         
## 6       8.06    -94.4                3                                                         
##   skewness_roll_belt skewness_roll_belt.1 skewness_yaw_belt max_roll_belt max_picth_belt max_yaw_belt
## 1                                                                      NA             NA             
## 2                                                                      NA             NA             
## 3                                                                      NA             NA             
## 4                                                                      NA             NA             
## 5                                                                      NA             NA             
## 6                                                                      NA             NA             
##   min_roll_belt min_pitch_belt min_yaw_belt amplitude_roll_belt amplitude_pitch_belt amplitude_yaw_belt
## 1            NA             NA                               NA                   NA                   
## 2            NA             NA                               NA                   NA                   
## 3            NA             NA                               NA                   NA                   
## 4            NA             NA                               NA                   NA                   
## 5            NA             NA                               NA                   NA                   
## 6            NA             NA                               NA                   NA                   
##   var_total_accel_belt avg_roll_belt stddev_roll_belt var_roll_belt avg_pitch_belt stddev_pitch_belt
## 1                   NA            NA               NA            NA             NA                NA
## 2                   NA            NA               NA            NA             NA                NA
## 3                   NA            NA               NA            NA             NA                NA
## 4                   NA            NA               NA            NA             NA                NA
## 5                   NA            NA               NA            NA             NA                NA
## 6                   NA            NA               NA            NA             NA                NA
##   var_pitch_belt avg_yaw_belt stddev_yaw_belt var_yaw_belt gyros_belt_x gyros_belt_y gyros_belt_z accel_belt_x
## 1             NA           NA              NA           NA         0.00         0.00        -0.02          -21
## 2             NA           NA              NA           NA         0.02         0.00        -0.02          -22
## 3             NA           NA              NA           NA         0.00         0.00        -0.02          -20
## 4             NA           NA              NA           NA         0.02         0.00        -0.03          -22
## 5             NA           NA              NA           NA         0.02         0.02        -0.02          -21
## 6             NA           NA              NA           NA         0.02         0.00        -0.02          -21
##   accel_belt_y accel_belt_z magnet_belt_x magnet_belt_y magnet_belt_z roll_arm pitch_arm yaw_arm total_accel_arm
## 1            4           22            -3           599          -313     -128      22.5    -161              34
## 2            4           22            -7           608          -311     -128      22.5    -161              34
## 3            5           23            -2           600          -305     -128      22.5    -161              34
## 4            3           21            -6           604          -310     -128      22.1    -161              34
## 5            2           24            -6           600          -302     -128      22.1    -161              34
## 6            4           21             0           603          -312     -128      22.0    -161              34
##   var_accel_arm avg_roll_arm stddev_roll_arm var_roll_arm avg_pitch_arm stddev_pitch_arm var_pitch_arm
## 1            NA           NA              NA           NA            NA               NA            NA
## 2            NA           NA              NA           NA            NA               NA            NA
## 3            NA           NA              NA           NA            NA               NA            NA
## 4            NA           NA              NA           NA            NA               NA            NA
## 5            NA           NA              NA           NA            NA               NA            NA
## 6            NA           NA              NA           NA            NA               NA            NA
##   avg_yaw_arm stddev_yaw_arm var_yaw_arm gyros_arm_x gyros_arm_y gyros_arm_z accel_arm_x accel_arm_y accel_arm_z
## 1          NA             NA          NA        0.00        0.00       -0.02        -288         109        -123
## 2          NA             NA          NA        0.02       -0.02       -0.02        -290         110        -125
## 3          NA             NA          NA        0.02       -0.02       -0.02        -289         110        -126
## 4          NA             NA          NA        0.02       -0.03        0.02        -289         111        -123
## 5          NA             NA          NA        0.00       -0.03        0.00        -289         111        -123
## 6          NA             NA          NA        0.02       -0.03        0.00        -289         111        -122
##   magnet_arm_x magnet_arm_y magnet_arm_z kurtosis_roll_arm kurtosis_picth_arm kurtosis_yaw_arm skewness_roll_arm
## 1         -368          337          516                                                                        
## 2         -369          337          513                                                                        
## 3         -368          344          513                                                                        
## 4         -372          344          512                                                                        
## 5         -374          337          506                                                                        
## 6         -369          342          513                                                                        
##   skewness_pitch_arm skewness_yaw_arm max_roll_arm max_picth_arm max_yaw_arm min_roll_arm min_pitch_arm
## 1                                               NA            NA          NA           NA            NA
## 2                                               NA            NA          NA           NA            NA
## 3                                               NA            NA          NA           NA            NA
## 4                                               NA            NA          NA           NA            NA
## 5                                               NA            NA          NA           NA            NA
## 6                                               NA            NA          NA           NA            NA
##   min_yaw_arm amplitude_roll_arm amplitude_pitch_arm amplitude_yaw_arm roll_dumbbell pitch_dumbbell yaw_dumbbell
## 1          NA                 NA                  NA                NA      13.05217      -70.49400    -84.87394
## 2          NA                 NA                  NA                NA      13.13074      -70.63751    -84.71065
## 3          NA                 NA                  NA                NA      12.85075      -70.27812    -85.14078
## 4          NA                 NA                  NA                NA      13.43120      -70.39379    -84.87363
## 5          NA                 NA                  NA                NA      13.37872      -70.42856    -84.85306
## 6          NA                 NA                  NA                NA      13.38246      -70.81759    -84.46500
##   kurtosis_roll_dumbbell kurtosis_picth_dumbbell kurtosis_yaw_dumbbell skewness_roll_dumbbell
## 1                                                                                            
## 2                                                                                            
## 3                                                                                            
## 4                                                                                            
## 5                                                                                            
## 6                                                                                            
##   skewness_pitch_dumbbell skewness_yaw_dumbbell max_roll_dumbbell max_picth_dumbbell max_yaw_dumbbell
## 1                                                              NA                 NA                 
## 2                                                              NA                 NA                 
## 3                                                              NA                 NA                 
## 4                                                              NA                 NA                 
## 5                                                              NA                 NA                 
## 6                                                              NA                 NA                 
##   min_roll_dumbbell min_pitch_dumbbell min_yaw_dumbbell amplitude_roll_dumbbell amplitude_pitch_dumbbell
## 1                NA                 NA                                       NA                       NA
## 2                NA                 NA                                       NA                       NA
## 3                NA                 NA                                       NA                       NA
## 4                NA                 NA                                       NA                       NA
## 5                NA                 NA                                       NA                       NA
## 6                NA                 NA                                       NA                       NA
##   amplitude_yaw_dumbbell total_accel_dumbbell var_accel_dumbbell avg_roll_dumbbell stddev_roll_dumbbell
## 1                                          37                 NA                NA                   NA
## 2                                          37                 NA                NA                   NA
## 3                                          37                 NA                NA                   NA
## 4                                          37                 NA                NA                   NA
## 5                                          37                 NA                NA                   NA
## 6                                          37                 NA                NA                   NA
##   var_roll_dumbbell avg_pitch_dumbbell stddev_pitch_dumbbell var_pitch_dumbbell avg_yaw_dumbbell
## 1                NA                 NA                    NA                 NA               NA
## 2                NA                 NA                    NA                 NA               NA
## 3                NA                 NA                    NA                 NA               NA
## 4                NA                 NA                    NA                 NA               NA
## 5                NA                 NA                    NA                 NA               NA
## 6                NA                 NA                    NA                 NA               NA
##   stddev_yaw_dumbbell var_yaw_dumbbell gyros_dumbbell_x gyros_dumbbell_y gyros_dumbbell_z accel_dumbbell_x
## 1                  NA               NA                0            -0.02             0.00             -234
## 2                  NA               NA                0            -0.02             0.00             -233
## 3                  NA               NA                0            -0.02             0.00             -232
## 4                  NA               NA                0            -0.02            -0.02             -232
## 5                  NA               NA                0            -0.02             0.00             -233
## 6                  NA               NA                0            -0.02             0.00             -234
##   accel_dumbbell_y accel_dumbbell_z magnet_dumbbell_x magnet_dumbbell_y magnet_dumbbell_z roll_forearm
## 1               47             -271              -559               293               -65         28.4
## 2               47             -269              -555               296               -64         28.3
## 3               46             -270              -561               298               -63         28.3
## 4               48             -269              -552               303               -60         28.1
## 5               48             -270              -554               292               -68         28.0
## 6               48             -269              -558               294               -66         27.9
##   pitch_forearm yaw_forearm kurtosis_roll_forearm kurtosis_picth_forearm kurtosis_yaw_forearm
## 1         -63.9        -153                                                                  
## 2         -63.9        -153                                                                  
## 3         -63.9        -152                                                                  
## 4         -63.9        -152                                                                  
## 5         -63.9        -152                                                                  
## 6         -63.9        -152                                                                  
##   skewness_roll_forearm skewness_pitch_forearm skewness_yaw_forearm max_roll_forearm max_picth_forearm
## 1                                                                                 NA                NA
## 2                                                                                 NA                NA
## 3                                                                                 NA                NA
## 4                                                                                 NA                NA
## 5                                                                                 NA                NA
## 6                                                                                 NA                NA
##   max_yaw_forearm min_roll_forearm min_pitch_forearm min_yaw_forearm amplitude_roll_forearm
## 1                               NA                NA                                     NA
## 2                               NA                NA                                     NA
## 3                               NA                NA                                     NA
## 4                               NA                NA                                     NA
## 5                               NA                NA                                     NA
## 6                               NA                NA                                     NA
##   amplitude_pitch_forearm amplitude_yaw_forearm total_accel_forearm var_accel_forearm avg_roll_forearm
## 1                      NA                                        36                NA               NA
## 2                      NA                                        36                NA               NA
## 3                      NA                                        36                NA               NA
## 4                      NA                                        36                NA               NA
## 5                      NA                                        36                NA               NA
## 6                      NA                                        36                NA               NA
##   stddev_roll_forearm var_roll_forearm avg_pitch_forearm stddev_pitch_forearm var_pitch_forearm avg_yaw_forearm
## 1                  NA               NA                NA                   NA                NA              NA
## 2                  NA               NA                NA                   NA                NA              NA
## 3                  NA               NA                NA                   NA                NA              NA
## 4                  NA               NA                NA                   NA                NA              NA
## 5                  NA               NA                NA                   NA                NA              NA
## 6                  NA               NA                NA                   NA                NA              NA
##   stddev_yaw_forearm var_yaw_forearm gyros_forearm_x gyros_forearm_y gyros_forearm_z accel_forearm_x
## 1                 NA              NA            0.03            0.00           -0.02             192
## 2                 NA              NA            0.02            0.00           -0.02             192
## 3                 NA              NA            0.03           -0.02            0.00             196
## 4                 NA              NA            0.02           -0.02            0.00             189
## 5                 NA              NA            0.02            0.00           -0.02             189
## 6                 NA              NA            0.02           -0.02           -0.03             193
##   accel_forearm_y accel_forearm_z magnet_forearm_x magnet_forearm_y magnet_forearm_z classe
## 1             203            -215              -17              654              476      A
## 2             203            -216              -18              661              473      A
## 3             204            -213              -18              658              469      A
## 4             206            -214              -16              658              469      A
## 5             206            -214              -17              655              473      A
## 6             203            -215               -9              660              478      A
```
As we can see there are a lot of irrelevant columns that we have to remove(based on the prediction variables they used previously in http://groupware.les.inf.puc-rio.br/public/papers/2012.Ugulino.WearableComputing.HAR.Classifier.RIBBON.pdf ).Also there are many cases of columns that have NA values that we also have to remove.


```r
Training<-subset(Training,select = -c(X,user_name,raw_timestamp_part_1,raw_timestamp_part_2,cvtd_timestamp,new_window,num_window))
Testing<-subset(Testing,select = -c(X,user_name,raw_timestamp_part_1,raw_timestamp_part_2,cvtd_timestamp,new_window,num_window))
NaValues<-sapply(Training, function(x) mean(is.na(x))) > 0.95
Training<- Training[,NaValues== FALSE]
Testing<- Testing[,NaValues== FALSE]
```
For the last step of the preprocessing process we will the columns that have nearly zero variance.

```r
nsv<-nearZeroVar(Training,saveMetrics=FALSE)
Training<- Training[,-nsv]
Testing<- Testing[,-nsv]
```
## Spliting Data for training and testing.We will do 70% for training and 30% for testing 

```r
inTrain  <- createDataPartition(Training$classe, p=0.7, list=FALSE)
TrainSet <- Training[inTrain, ]
TestSet  <- Training[-inTrain, ]
dim(TrainSet);dim(TestSet)
```

```
## [1] 13737    53
```

```
## [1] 5885   53
```
## Model Training
### Model Training with Predicting with Trees(regression and classification) method

```r
modFit1<-train(classe~.,method="rpart",data=Training)
print(modFit1$finalModel)
```

```
## n= 19622 
## 
## node), split, n, loss, yval, (yprob)
##       * denotes terminal node
## 
##  1) root 19622 14042 A (0.28 0.19 0.17 0.16 0.18)  
##    2) roll_belt< 130.5 17977 12411 A (0.31 0.21 0.19 0.18 0.11)  
##      4) pitch_forearm< -33.95 1578    10 A (0.99 0.0063 0 0 0) *
##      5) pitch_forearm>=-33.95 16399 12401 A (0.24 0.23 0.21 0.2 0.12)  
##       10) magnet_dumbbell_y< 439.5 13870  9953 A (0.28 0.18 0.24 0.19 0.11)  
##         20) roll_forearm< 123.5 8643  5131 A (0.41 0.18 0.18 0.17 0.061) *
##         21) roll_forearm>=123.5 5227  3500 C (0.077 0.18 0.33 0.23 0.18) *
##       11) magnet_dumbbell_y>=439.5 2529  1243 B (0.032 0.51 0.043 0.22 0.19) *
##    3) roll_belt>=130.5 1645    14 E (0.0085 0 0 0 0.99) *
```

```r
library(rattle)
```

```
## Warning: package 'rattle' was built under R version 4.0.5
```

```
## Loading required package: tibble
```

```
## Loading required package: bitops
```

```
## Rattle: A free graphical interface for data science with R.
## Version 5.4.0 Copyright (c) 2006-2020 Togaware Pty Ltd.
## Type 'rattle()' to shake, rattle, and roll your data.
```

```r
par(mfrow=c(1,2))
plot(modFit1$finalModel,uniform = TRUE,main="Classification Tree")
text(modFit1$finalModel,use.n = TRUE,all = TRUE,cex=-1)
fancyRpartPlot(modFit1$finalModel)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)

```r
predict(modFit1,newdata = Testing)
```

```
##  [1] C A C A A C C A A A C C C A C A A A A C
## Levels: A B C D E
```

```r
confusionMatrix(modFit1, Testing$classe)
```

```
## Bootstrapped (25 reps) Confusion Matrix 
## 
## (entries are un-normalized aggregated counts)
##  
##           Reference
## Prediction     A     B     C     D     E
##          A 45327 15618 14954 13551  5463
##          B  1229 11457  1133  5181  4650
##          C  3790  6805 14736  8591  6894
##          D   457   918   627  1983   808
##          E   360   330   120   283 15413
##                             
##  Accuracy (average) : 0.4921
```
As we can see the accuracy is only 0.5121.So we have to use different method to get a better accuracy for the data.

### Model Training with Random Forest method
We set the parameter ntree to produce only 100 trees otherwise the training process takes to long

```r
library(randomForest)
```

```
## Warning: package 'randomForest' was built under R version 4.0.5
```

```
## randomForest 4.6-14
```

```
## Type rfNews() to see new features/changes/bug fixes.
```

```
## 
## Attaching package: 'randomForest'
```

```
## The following object is masked from 'package:rattle':
## 
##     importance
```

```
## The following object is masked from 'package:ggplot2':
## 
##     margin
```

```r
modFit2<-train(classe~.,method="rf",data=Training,ntree=100)
predict(modFit2,newdata = Testing)
```

```
##  [1] B A B A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```

```r
confusionMatrix(modFit2, Testing$classe)
```

```
## Bootstrapped (25 reps) Confusion Matrix 
## 
## (entries are un-normalized aggregated counts)
##  
##           Reference
## Prediction     A     B     C     D     E
##          A 51268   270     5     4     1
##          B    62 34601   189    16    21
##          C    25   113 31074   373    46
##          D     0    10   100 29045   127
##          E    16     2     1    25 33016
##                             
##  Accuracy (average) : 0.9922
```

The accuracy value with this method is substantially better than the one we used before (Accuracy = 0.9927).
In here we set the parameter verbose to FALSE to hide the iteration that are made to produce the model

```r
library(gbm)
```

```
## Warning: package 'gbm' was built under R version 4.0.5
```

```
## Loaded gbm 2.1.8
```

```r
modFit3<-train(classe~.,method="gbm",data=Training,verbose = FALSE)
predict(modFit3,newdata = Testing)
```

```
##  [1] B A B A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```

```r
confusionMatrix(modFit3, Testing$classe)
```

```
## Bootstrapped (25 reps) Confusion Matrix 
## 
## (entries are un-normalized aggregated counts)
##  
##           Reference
## Prediction     A     B     C     D     E
##          A 50605  1113     3    38    66
##          B   545 32874  1091   110   380
##          C   189  1025 29972  1035   280
##          D    97    77   390 28325   479
##          E    29    53    67   207 31864
##                             
##  Accuracy (average) : 0.9598
```

Finally the accuracy value with this method is also good but not as good as the one before(Accuracy= 0.9601 ).

# Conclusion 
The model with the rpart method is inappropriate for the data as it's accuracy is close to 50%.On the other hand the models with the rf and gbm methods perform far better(although they take really long time to return results, especially the one with the gbm method) and are far more accurate with 99% and 96% respectively.So for our predictions the model with the rf method will be the one we choose.One last thing that is worth noting is that both the random forest and boosting models returned similar predictions for the test set and it's good that we see that given that there is (little) difference in the accuracy values
