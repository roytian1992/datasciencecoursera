
### Statistical Inference ###

- Author: Roy tian

** Part I **

In this project you will investigate the exponential distribution in R and compare it with the Central Limit Theorem. The exponential distribution can be simulated in R with rexp(n, lambda) where lambda is the rate parameter. The mean of exponential distribution is 1/lambda and the standard deviation is also 1/lambda. Set lambda = 0.2 for all of the simulations. You will investigate the distribution of averages of 40 exponentials. Note that you will need to do a thousand simulations.


```R
set.seed(110)
vars <- rexp(1000, 0.2)
mean(vars)
sd(vars)
hist(vars)
```


5.16837213376778



5.21522011159901



![png](output_1_2.png)


Both mean and standard deviation are close to $1/0.2 = 5$


```R
EXP.means = NULL
set.seed(2333333)
for (i in 1 : 1000) {
    EXP.means = c(EXP.means, mean(rexp(40, 0.2)))
}
hist(EXP.means, breaks = 100)
abline(v = 5, col = 'red', lwd = 2) # theoretic value
abline(v = mean(EXP.means), col = 'green', lwd =2) # simulation result
```


![png](output_3_0.png)



```R
qqnorm(EXP.means)
```


![png](output_4_0.png)


By qqnorm plot of the distribution vs the standard norm distribution, the distribution is close to norm.


```R
sample_var <- var(EXP.means)
true_var <- 5^2/40
sample_var
true_var
```


0.626156804336136



0.625


Sample variance is quite close to its theoretic value.

** Part II ** 

Now in the second portion of the project, we're going to analyze the ToothGrowth data in the R datasets package.

Load the ToothGrowth data and perform some basic exploratory data analyses
Provide a basic summary of the data.
Use confidence intervals and/or hypothesis tests to compare tooth growth by supp and dose. (Only use the techniques from class, even if there's other approaches worth considering)
State your conclusions and the assumptions needed for your conclusions.


```R
data(ToothGrowth)
head(ToothGrowth)
dim(ToothGrowth)
summary(ToothGrowth)
```


<table>
<thead><tr><th scope=col>len</th><th scope=col>supp</th><th scope=col>dose</th></tr></thead>
<tbody>
	<tr><td> 4.2</td><td>VC  </td><td>0.5 </td></tr>
	<tr><td>11.5</td><td>VC  </td><td>0.5 </td></tr>
	<tr><td> 7.3</td><td>VC  </td><td>0.5 </td></tr>
	<tr><td> 5.8</td><td>VC  </td><td>0.5 </td></tr>
	<tr><td> 6.4</td><td>VC  </td><td>0.5 </td></tr>
	<tr><td>10.0</td><td>VC  </td><td>0.5 </td></tr>
</tbody>
</table>




<ol class=list-inline>
	<li>60</li>
	<li>3</li>
</ol>




          len        supp         dose      
     Min.   : 4.20   OJ:30   Min.   :0.500  
     1st Qu.:13.07   VC:30   1st Qu.:0.500  
     Median :19.25           Median :1.000  
     Mean   :18.81           Mean   :1.167  
     3rd Qu.:25.27           3rd Qu.:2.000  
     Max.   :33.90           Max.   :2.000  



```R
# Partition the data set according to different dose levels
ind1 <- (ToothGrowth$dose == 0.5)
ind2 <- (ToothGrowth$dose == 1)
ind3 <- (ToothGrowth$dose == 2)
data1 <- ToothGrowth[ind1,]
data2 <- ToothGrowth[ind2,]
data3 <- ToothGrowth[ind3,]
```


```R
# At low dose level
len1.VC <- data1$len[data1$supp == 'VC']
len1.OJ <- data1$len[data1$supp == 'OJ']
t.test(len1.VC, len1.OJ) # no information saying the data are paired, and thus useing unpaired t-test is appropriate

# At middle dose level
len2.VC <- data2$len[data2$supp == 'VC']
len2.OJ <- data2$len[data2$supp == 'OJ']
t.test(len2.VC, len2.OJ)

# At high dose level
len3.VC <- data3$len[data3$supp == 'VC']
len3.OJ <- data3$len[data3$supp == 'OJ']
t.test(len3.VC, len3.OJ)
```


-5.25



    
    	Welch Two Sample t-test
    
    data:  len1.VC and len1.OJ
    t = -3.1697, df = 14.969, p-value = 0.006359
    alternative hypothesis: true difference in means is not equal to 0
    95 percent confidence interval:
     -8.780943 -1.719057
    sample estimates:
    mean of x mean of y 
         7.98     13.23 




    
    	Welch Two Sample t-test
    
    data:  len2.VC and len2.OJ
    t = -4.0328, df = 15.358, p-value = 0.001038
    alternative hypothesis: true difference in means is not equal to 0
    95 percent confidence interval:
     -9.057852 -2.802148
    sample estimates:
    mean of x mean of y 
        16.77     22.70 




    
    	Welch Two Sample t-test
    
    data:  len3.VC and len3.OJ
    t = 0.046136, df = 14.04, p-value = 0.9639
    alternative hypothesis: true difference in means is not equal to 0
    95 percent confidence interval:
     -3.63807  3.79807
    sample estimates:
    mean of x mean of y 
        26.14     26.06 




```R
# At low dose level
mean(len1.VC) - mean(len1.OJ)
# At middle dose level
mean(len2.VC) - mean(len2.OJ)
# At high dose level
mean(len3.VC) - mean(len3.OJ)
```


-5.25



-5.93



0.0800000000000018


### Conclusion

- At both low dose and middle dose levels, orange juice provides more tooth growth than ascorbic acid.
- At high dose level, there is no statistical difference between those two methods of supplement.
