
## Human Activity Recognition ##
- Author: Roy Tian

** Background ** 

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. <br>

Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E).

Read more: http://groupware.les.inf.puc-rio.br/har#ixzz4Yxe9P3S7

** Data Source **

http://groupware.les.inf.puc-rio.br/har

### Procedures:
0. Decide the variables should be included in the model building; (Remove zero covariates)
0. Remove NAs in train data;
0. Partition train data;
0. Try different predicton methods: tree, random forest, and support vector machine
0. Use the method with best accuracy to predict new cases from test data.


```R
# Read the test data
train.data <- read.table('pml-training.csv',sep=',',header=TRUE) 
head(train.data)
```


<table>
<thead><tr><th scope=col>X</th><th scope=col>user_name</th><th scope=col>raw_timestamp_part_1</th><th scope=col>raw_timestamp_part_2</th><th scope=col>cvtd_timestamp</th><th scope=col>new_window</th><th scope=col>num_window</th><th scope=col>roll_belt</th><th scope=col>pitch_belt</th><th scope=col>yaw_belt</th><th scope=col>⋯</th><th scope=col>gyros_forearm_x</th><th scope=col>gyros_forearm_y</th><th scope=col>gyros_forearm_z</th><th scope=col>accel_forearm_x</th><th scope=col>accel_forearm_y</th><th scope=col>accel_forearm_z</th><th scope=col>magnet_forearm_x</th><th scope=col>magnet_forearm_y</th><th scope=col>magnet_forearm_z</th><th scope=col>classe</th></tr></thead>
<tbody>
	<tr><td>1               </td><td>carlitos        </td><td>1323084231      </td><td>788290          </td><td>05/12/2011 11:23</td><td>no              </td><td>11              </td><td>1.41            </td><td>8.07            </td><td>-94.4           </td><td>⋯               </td><td>0.03            </td><td> 0.00           </td><td>-0.02           </td><td>192             </td><td>203             </td><td>-215            </td><td>-17             </td><td>654             </td><td>476             </td><td>A               </td></tr>
	<tr><td>2               </td><td>carlitos        </td><td>1323084231      </td><td>808298          </td><td>05/12/2011 11:23</td><td>no              </td><td>11              </td><td>1.41            </td><td>8.07            </td><td>-94.4           </td><td>⋯               </td><td>0.02            </td><td> 0.00           </td><td>-0.02           </td><td>192             </td><td>203             </td><td>-216            </td><td>-18             </td><td>661             </td><td>473             </td><td>A               </td></tr>
	<tr><td>3               </td><td>carlitos        </td><td>1323084231      </td><td>820366          </td><td>05/12/2011 11:23</td><td>no              </td><td>11              </td><td>1.42            </td><td>8.07            </td><td>-94.4           </td><td>⋯               </td><td>0.03            </td><td>-0.02           </td><td> 0.00           </td><td>196             </td><td>204             </td><td>-213            </td><td>-18             </td><td>658             </td><td>469             </td><td>A               </td></tr>
	<tr><td>4               </td><td>carlitos        </td><td>1323084232      </td><td>120339          </td><td>05/12/2011 11:23</td><td>no              </td><td>12              </td><td>1.48            </td><td>8.05            </td><td>-94.4           </td><td>⋯               </td><td>0.02            </td><td>-0.02           </td><td> 0.00           </td><td>189             </td><td>206             </td><td>-214            </td><td>-16             </td><td>658             </td><td>469             </td><td>A               </td></tr>
	<tr><td>5               </td><td>carlitos        </td><td>1323084232      </td><td>196328          </td><td>05/12/2011 11:23</td><td>no              </td><td>12              </td><td>1.48            </td><td>8.07            </td><td>-94.4           </td><td>⋯               </td><td>0.02            </td><td> 0.00           </td><td>-0.02           </td><td>189             </td><td>206             </td><td>-214            </td><td>-17             </td><td>655             </td><td>473             </td><td>A               </td></tr>
	<tr><td>6               </td><td>carlitos        </td><td>1323084232      </td><td>304277          </td><td>05/12/2011 11:23</td><td>no              </td><td>12              </td><td>1.45            </td><td>8.06            </td><td>-94.4           </td><td>⋯               </td><td>0.02            </td><td>-0.02           </td><td>-0.03           </td><td>193             </td><td>203             </td><td>-215            </td><td> -9             </td><td>660             </td><td>478             </td><td>A               </td></tr>
</tbody>
</table>




```R
# Load the caret pakage for Machine Learning
library(caret)
```


```R
train.data <- train.data[,-c(1:7)]
nzv <- nearZeroVar(train.data)
names(train.data)[nzv]
```


<ol class=list-inline>
	<li>'kurtosis_roll_belt'</li>
	<li>'kurtosis_picth_belt'</li>
	<li>'kurtosis_yaw_belt'</li>
	<li>'skewness_roll_belt'</li>
	<li>'skewness_roll_belt.1'</li>
	<li>'skewness_yaw_belt'</li>
	<li>'max_yaw_belt'</li>
	<li>'min_yaw_belt'</li>
	<li>'amplitude_yaw_belt'</li>
	<li>'avg_roll_arm'</li>
	<li>'stddev_roll_arm'</li>
	<li>'var_roll_arm'</li>
	<li>'avg_pitch_arm'</li>
	<li>'stddev_pitch_arm'</li>
	<li>'var_pitch_arm'</li>
	<li>'avg_yaw_arm'</li>
	<li>'stddev_yaw_arm'</li>
	<li>'var_yaw_arm'</li>
	<li>'kurtosis_roll_arm'</li>
	<li>'kurtosis_picth_arm'</li>
	<li>'kurtosis_yaw_arm'</li>
	<li>'skewness_roll_arm'</li>
	<li>'skewness_pitch_arm'</li>
	<li>'skewness_yaw_arm'</li>
	<li>'max_roll_arm'</li>
	<li>'min_roll_arm'</li>
	<li>'min_pitch_arm'</li>
	<li>'amplitude_roll_arm'</li>
	<li>'amplitude_pitch_arm'</li>
	<li>'kurtosis_roll_dumbbell'</li>
	<li>'kurtosis_picth_dumbbell'</li>
	<li>'kurtosis_yaw_dumbbell'</li>
	<li>'skewness_roll_dumbbell'</li>
	<li>'skewness_pitch_dumbbell'</li>
	<li>'skewness_yaw_dumbbell'</li>
	<li>'max_yaw_dumbbell'</li>
	<li>'min_yaw_dumbbell'</li>
	<li>'amplitude_yaw_dumbbell'</li>
	<li>'kurtosis_roll_forearm'</li>
	<li>'kurtosis_picth_forearm'</li>
	<li>'kurtosis_yaw_forearm'</li>
	<li>'skewness_roll_forearm'</li>
	<li>'skewness_pitch_forearm'</li>
	<li>'skewness_yaw_forearm'</li>
	<li>'max_roll_forearm'</li>
	<li>'max_yaw_forearm'</li>
	<li>'min_roll_forearm'</li>
	<li>'min_yaw_forearm'</li>
	<li>'amplitude_roll_forearm'</li>
	<li>'amplitude_yaw_forearm'</li>
	<li>'avg_roll_forearm'</li>
	<li>'stddev_roll_forearm'</li>
	<li>'var_roll_forearm'</li>
	<li>'avg_pitch_forearm'</li>
	<li>'stddev_pitch_forearm'</li>
	<li>'var_pitch_forearm'</li>
	<li>'avg_yaw_forearm'</li>
	<li>'stddev_yaw_forearm'</li>
	<li>'var_yaw_forearm'</li>
</ol>




```R
length(train.data[1,])
length(nzv)
```


153



59



```R
# Remove all the Near Zero Covariates
train.data <- train.data[,-c(nzv)]
dim(train.data)
```


<ol class=list-inline>
	<li>19622</li>
	<li>94</li>
</ol>




```R
NoNAs <- numeric(dim(train.data)[2])
for (i in 1:length(NoNAs)){
    NoNAs[i] <- sum(is.na(train.data[,i]))
}
NoNAs
```


<ol class=list-inline>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>19216</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>0</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>19216</li>
	<li>19216</li>
	<li>19216</li>
	<li>0</li>
	<li>19216</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
	<li>0</li>
</ol>




```R
index <- (NoNAs == 0)
train.data.cleaned <- train.data[,index]
dim(train.data.cleaned)
```


<ol class=list-inline>
	<li>19622</li>
	<li>53</li>
</ol>




```R
set.seed(2333)
inTrain <- createDataPartition(y = train.data.cleaned$classe, p = 0.7, list = FALSE)
train.set <- train.data.cleaned[inTrain,]
test.set <- train.data.cleaned[-inTrain,]
dim(train.set)
dim(test.set)
names(train.set)
```


<ol class=list-inline>
	<li>13737</li>
	<li>53</li>
</ol>




<ol class=list-inline>
	<li>5885</li>
	<li>53</li>
</ol>




<ol class=list-inline>
	<li>'roll_belt'</li>
	<li>'pitch_belt'</li>
	<li>'yaw_belt'</li>
	<li>'total_accel_belt'</li>
	<li>'gyros_belt_x'</li>
	<li>'gyros_belt_y'</li>
	<li>'gyros_belt_z'</li>
	<li>'accel_belt_x'</li>
	<li>'accel_belt_y'</li>
	<li>'accel_belt_z'</li>
	<li>'magnet_belt_x'</li>
	<li>'magnet_belt_y'</li>
	<li>'magnet_belt_z'</li>
	<li>'roll_arm'</li>
	<li>'pitch_arm'</li>
	<li>'yaw_arm'</li>
	<li>'total_accel_arm'</li>
	<li>'gyros_arm_x'</li>
	<li>'gyros_arm_y'</li>
	<li>'gyros_arm_z'</li>
	<li>'accel_arm_x'</li>
	<li>'accel_arm_y'</li>
	<li>'accel_arm_z'</li>
	<li>'magnet_arm_x'</li>
	<li>'magnet_arm_y'</li>
	<li>'magnet_arm_z'</li>
	<li>'roll_dumbbell'</li>
	<li>'pitch_dumbbell'</li>
	<li>'yaw_dumbbell'</li>
	<li>'total_accel_dumbbell'</li>
	<li>'gyros_dumbbell_x'</li>
	<li>'gyros_dumbbell_y'</li>
	<li>'gyros_dumbbell_z'</li>
	<li>'accel_dumbbell_x'</li>
	<li>'accel_dumbbell_y'</li>
	<li>'accel_dumbbell_z'</li>
	<li>'magnet_dumbbell_x'</li>
	<li>'magnet_dumbbell_y'</li>
	<li>'magnet_dumbbell_z'</li>
	<li>'roll_forearm'</li>
	<li>'pitch_forearm'</li>
	<li>'yaw_forearm'</li>
	<li>'total_accel_forearm'</li>
	<li>'gyros_forearm_x'</li>
	<li>'gyros_forearm_y'</li>
	<li>'gyros_forearm_z'</li>
	<li>'accel_forearm_x'</li>
	<li>'accel_forearm_y'</li>
	<li>'accel_forearm_z'</li>
	<li>'magnet_forearm_x'</li>
	<li>'magnet_forearm_y'</li>
	<li>'magnet_forearm_z'</li>
	<li>'classe'</li>
</ol>




```R
# Predict with Trees
fitControl <- trainControl(method = "cv",
                           number = 10,
                           repeats = 10,
                   classProbs = TRUE)
mod.tree = train (classe ~ .,
           data = train.set,
           method = "rpart",
           tuneLength = 20,
           trControl = fitControl)
```


```R
library(rattle)
fancyRpartPlot(mod.tree$finalModel)
```


![png](output_11_0.png)



```R
predictions <- predict(mod.tree, newdata = test.set)
confusionMatrix(predictions, test.set$classe)
```


    Confusion Matrix and Statistics
    
              Reference
    Prediction    A    B    C    D    E
             A 1532  153   17   46   21
             B   38  786  104   41   63
             C   33  109  817   33   95
             D   45   42   68  790  117
             E   26   49   20   54  786
    
    Overall Statistics
                                              
                   Accuracy : 0.8005          
                     95% CI : (0.7901, 0.8107)
        No Information Rate : 0.2845          
        P-Value [Acc > NIR] : < 2.2e-16       
                                              
                      Kappa : 0.7473          
     Mcnemar's Test P-Value : < 2.2e-16       
    
    Statistics by Class:
    
                         Class: A Class: B Class: C Class: D Class: E
    Sensitivity            0.9152   0.6901   0.7963   0.8195   0.7264
    Specificity            0.9437   0.9482   0.9444   0.9447   0.9690
    Pos Pred Value         0.8660   0.7616   0.7516   0.7439   0.8406
    Neg Pred Value         0.9655   0.9273   0.9564   0.9639   0.9402
    Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
    Detection Rate         0.2603   0.1336   0.1388   0.1342   0.1336
    Detection Prevalence   0.3006   0.1754   0.1847   0.1805   0.1589
    Balanced Accuracy      0.9294   0.8191   0.8704   0.8821   0.8477



```R
# Predict with Random Forest
library(randomForest)
mod.rf <- randomForest(classe ~ ., data = train.set)

prediction.rf <- predict(mod.rf, newdata = test.set, type = 'class')
confusionMatrix(prediction.rf, test.set$classe)
```


    Confusion Matrix and Statistics
    
              Reference
    Prediction    A    B    C    D    E
             A 1674    0    0    0    0
             B    0 1138    8    0    0
             C    0    1 1016   10    0
             D    0    0    2  951    2
             E    0    0    0    3 1080
    
    Overall Statistics
                                              
                   Accuracy : 0.9956          
                     95% CI : (0.9935, 0.9971)
        No Information Rate : 0.2845          
        P-Value [Acc > NIR] : < 2.2e-16       
                                              
                      Kappa : 0.9944          
     Mcnemar's Test P-Value : NA              
    
    Statistics by Class:
    
                         Class: A Class: B Class: C Class: D Class: E
    Sensitivity            1.0000   0.9991   0.9903   0.9865   0.9982
    Specificity            1.0000   0.9983   0.9977   0.9992   0.9994
    Pos Pred Value         1.0000   0.9930   0.9893   0.9958   0.9972
    Neg Pred Value         1.0000   0.9998   0.9979   0.9974   0.9996
    Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
    Detection Rate         0.2845   0.1934   0.1726   0.1616   0.1835
    Detection Prevalence   0.2845   0.1947   0.1745   0.1623   0.1840
    Balanced Accuracy      1.0000   0.9987   0.9940   0.9929   0.9988



```R
# Predict with Support Vector Machine
library(e1071)
mod.svm = svm (classe ~ ., data = train.set)

prediction.svm <- predict(mod.svm, newdata = test.set)
confusionMatrix(prediction.svm, test.set$classe)
```


    Confusion Matrix and Statistics
    
              Reference
    Prediction    A    B    C    D    E
             A 1666   68    2    3    0
             B    4 1049   32    0    9
             C    3   21  983   77   28
             D    0    1    8  883   31
             E    1    0    1    1 1014
    
    Overall Statistics
                                              
                   Accuracy : 0.9507          
                     95% CI : (0.9449, 0.9561)
        No Information Rate : 0.2845          
        P-Value [Acc > NIR] : < 2.2e-16       
                                              
                      Kappa : 0.9376          
     Mcnemar's Test P-Value : < 2.2e-16       
    
    Statistics by Class:
    
                         Class: A Class: B Class: C Class: D Class: E
    Sensitivity            0.9952   0.9210   0.9581   0.9160   0.9372
    Specificity            0.9827   0.9905   0.9735   0.9919   0.9994
    Pos Pred Value         0.9580   0.9589   0.8840   0.9567   0.9971
    Neg Pred Value         0.9981   0.9812   0.9910   0.9837   0.9860
    Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
    Detection Rate         0.2831   0.1782   0.1670   0.1500   0.1723
    Detection Prevalence   0.2955   0.1859   0.1890   0.1568   0.1728
    Balanced Accuracy      0.9889   0.9558   0.9658   0.9539   0.9683


** Conclusion: **

The accuracy of prediction tree algorithm is much lower than that of random forest and support vector machine. 
Both random forest and support vector machine have an accurary over 95%.
Random Forest has the best accuracy, and thus we choose to use it to predict the new cases.


```R
test.data <- read.table('pml-testing.csv',sep=',',header=TRUE) 
varSelect <- names(train.set)[1:(length(names(train.set))-1)]
test.data <- test.data[,varSelect]
pred.rf <- predict(mod.rf, newdata = test.data)
pred.rf
```


<dl class=dl-horizontal>
	<dt>1</dt>
		<dd>B</dd>
	<dt>2</dt>
		<dd>A</dd>
	<dt>3</dt>
		<dd>B</dd>
	<dt>4</dt>
		<dd>A</dd>
	<dt>5</dt>
		<dd>A</dd>
	<dt>6</dt>
		<dd>E</dd>
	<dt>7</dt>
		<dd>D</dd>
	<dt>8</dt>
		<dd>B</dd>
	<dt>9</dt>
		<dd>A</dd>
	<dt>10</dt>
		<dd>A</dd>
	<dt>11</dt>
		<dd>B</dd>
	<dt>12</dt>
		<dd>C</dd>
	<dt>13</dt>
		<dd>B</dd>
	<dt>14</dt>
		<dd>A</dd>
	<dt>15</dt>
		<dd>E</dd>
	<dt>16</dt>
		<dd>E</dd>
	<dt>17</dt>
		<dd>A</dd>
	<dt>18</dt>
		<dd>B</dd>
	<dt>19</dt>
		<dd>B</dd>
	<dt>20</dt>
		<dd>B</dd>
</dl>


