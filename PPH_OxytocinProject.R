## Final project for Biostatistics 1 PUBH 6450:
# This is the code for analysis of a data set regarding post partum hemmorrage
# Final report titled: Final project Bioistatistics 1_Spring 24.pdf

setwd("~/Desktop/Spring 2024 Classes/Biostats I PUBH 6040/wk8_project1")
library(readr)
pph <- read_csv("PPH-Oxytocin-RCT.csv")  
# View(pph)

library(psych)
library(lattice)

pph <- read.csv("PPH-Oxytocin-RCT.csv") ## load data

## Summary baseline characteristics for Table 1
table(pph$StudyGroup)   
describeBy(pph$Age, pph$StudyGroup)   
describeBy(pph$GestAge, pph$StudyGroup)
describeBy(pph$HbBaseline, pph$StudyGroup)
describeBy(pph$SBPBaseline, pph$StudyGroup)
describeBy(pph$DBPBaseline, pph$StudyGroup)
describeBy(pph$HRBaseline, pph$StudyGroup)

log.bloodloss <- log(pph$TotalBloodLoss)
histogram(~ log.bloodloss | pph$StudyGroup, xlab = "Log Transformed Total Blood Loss in mL", ylab = "Percent of Participants", main = "Log Transformed Total Blood Loss by Intervention Group" )


histogram(~ pph$TotalBloodLoss | pph$StudyGroup, xlab = "Total Blood Loss in mL", ylab = "Percent of Participants", main = "Total Blood Loss by Intervention Group" )

boxplot(pph$TotalBloodLoss ~ pph$StudyGroup, main="Boxplot of Total Blood Loss by Intervention Group", xlab = "Group", ylab = "Total Blood Loss (mL)")

describeBy(pph$TotalBloodLoss, pph$StudyGroup, IQR = TRUE, quant = c(0.25, 0.75))


hist(pph$TotalBloodLoss)
which(is.na(pph$TotalBloodLoss))
pph$StudyGroup[159]
pph$StudyGroup[177]
pph$StudyGroup[475]
(table(pph$StudyGroup))
prop.table(table(pph$StudyGroup))

group <- pph$StudyGroup
mydf <- as.data.frame(group)
mydf$bloodloss <- bloodloss
bloodloss <- pph$TotalBloodLoss
mydf <- bloodloss

group_by(mydf, group)
summarise(mydf, mean = mean(bloodloss))
hist(log(bloodloss))

covid_last <- summarize(covid_long, covid_last = last(c_cases))

t.test(pph$TotalBloodLoss~pph$StudyGroup, conf.level = 0.95, mu = 0, alternative = "two.sided")
library(stats)
library(pwr)
pwr.t.test(n = 239, power = 0.80, sig.level = 0.05, type = "two.sample", alternative = "two.sided")


wilcox.test(pph$TotalBloodLoss~pph$StudyGroup)
wilcox.test(pph$TotalBloodLoss~pph$StudyGroup, conf.int = TRUE, conf.level = 0.95, alternative = "two.sided", mu = 0)

mydf$log_bloodloss <- log(bloodloss)
mean(mydf$log_bloodloss, na.rm = TRUE)
describeBy(mydf$log_bloodloss, mydf$group)

mydf$trans <- exp(mydf$log_bloodloss)

### Start of Project 2 Week 15, end of semester project ###
setwd("~/Desktop/Spring_2024Classes/Biostats I PUBH 6040/wk15_project2")

pph <- read.csv("PPH-Oxytocin-RCT.csv")
# Shock index (SI) is defined as the ratio of pulse to systolic blood pressure. 
# [Note: It can be interpreted as Normal (SI < 0.90) and abnormal (SI > 0.90), 
#    but this is only for your information if you aren’t familiar with its clinical cut-off values]. 
# 
# You will need to calculate this variable prior to analyzing the dataset. To calculate it, 
# you will need to create a new variable in the dataset that computes the ratio between 
# pulse rate (HR) 15 minutes after birth (HR15) and systolic blood pressure 15 minutes after birth (SBP15). 
# Name this new variable SI15. 

pph$SI15 <- pph$HR15 / pph$SBP15
describeBy(pph$SI15, pph$StudyGroup)
plot(pph$SI15)
cor(pph$SI15, pph$TotalBloodLoss, use = "complete.obs")

plot(x = pph$SI15, y=pph$TotalBloodLoss, col=c("darkorange", "mediumturquoise")[factor(pph$StudyGroup)], 
     pch=16, main = "Total Blood Loss vs Shock Index",
     xlab = "Shock Index (15 mins post-partum)",
     ylab = "Total Blood Loss") 
legend("bottomright", legend = levels(factor(pph$StudyGroup)),
      fill=c("darkorange", "mediumturquoise"),
      box.lty=1)

pph.model1 <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup))
summary(pph.model1)
confint(pph.model1, level = 0.95)
library(ggfortify)
autoplot(pph.model1)

plot(x = pph$SI15, y=pph$TotalBloodLoss, col=c("darkorange", "mediumturquoise")[factor(pph$StudyGroup)], 
     pch=16, main = "Total Blood Loss vs Shock Index",
     xlab = "Shock Index (15 mins post-partum)",
     ylab = "Total Blood Loss") 
legend("bottomright", legend = levels(factor(pph$StudyGroup)),
       fill=c("darkorange", "mediumturquoise"),
       box.lty=1)
abline(a = -12.07, b = 460.52, col="mediumturquoise")
abline(a = 20.95 , b = 460.52, col="darkorange")
# 
# abline( a =3.147, b = 0.129, col="blue") +
# abline(a= 3.31, b = 0.129, col="hotpink")

library(ggplot2)
ggplot(pph, aes(x = SI15, y=pph$TotalBloodLoss), col = pph$StudyGroup) + geom_point()

pph.model2 <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup) + pph$HbBaseline)
summary(pph.model2)

pph.model3 <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup) + factor(pph$PriorPPH))
summary(pph.model3)

pph.model4 <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup) + pph$Age) 
summary(pph.model4)

pph.model.A <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup) + pph$Age + pph$HbBaseline + pph$HRBaseline +
                    pph$NumPregnancies + pph$DiabetesStatus + pph$HypertensionStatus)
summary(pph.model.A)
confint(pph.model.A)

pph.model.B <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup) + pph$SBP30 + pph$DBP30 + pph$HR30 )
summary(pph.model.B)
confint(pph.model.B)

pph.model.C <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup) + pph$SBP45 + pph$DBP45 + pph$HR45 )
summary(pph.model.C)
confint(pph.model.C)

pph.model.D <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup) + pph$SBP30 + pph$DBP30 + pph$HR30 +pph$BloodLoss30)
summary(pph.model.D)
confint(pph.model.D)


pph.model.E <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup) + pph$SBP45 + pph$DBP45 + pph$HR45 + pph$BloodLoss30)
summary(pph.model.E)
confint(pph.model.E)
autoplot(pph.model.E)

pph.model6 <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup)  + pph$chg.bp )
summary(pph.model6)

pph.model16 <- lm(pph$TotalBloodLoss ~ pph$SI15 + factor(pph$StudyGroup)  + pph$chg.bp)
summary(pph.model16)

pph$chg.bp <- pph$SBPBaseline - pph$SBP30
SI.30 <- pph$HR30 / pph$SBP30
pph$SI.30 <- pph$HR30 / pph$SBP30


table(pph$StudyGroup)
# IM: 241 participants and IV: 239 participants

mean(pph$HbPost, na.rm = TRUE)
# 10.38235
sd(pph$HbPost, na.rm = TRUE)
# 1.498344
library(psych)
describeBy(pph$HbPost, pph$StudyGroup)
t.test(pph$HbPost ~ pph$StudyGroup, conf.level = 0.95, mu = 0, alternative = "two.sided")


### Diagnosed with PPH statistical analysis ####
pph.table <- table(pph$StudyGroup, pph$DiagPPHStatus)
prop.table(pph.table, margin = 1)
pph.table2 <- matrix(c(57,184,48,191), nrow = 2, ncol = 2,
       byrow = TRUE, 
       dimnames = list(c("IM", "IV"), c("PPH dx", "No PPH dx")))
# pph.chi <- chisq.test(pph.table2, correct = FALSE)
library(epibasix)
summary(epi2x2(pph.table2))
fisher.test(pph.table2)

#### Blood Loss >/= 500 statistical analysis ####
bl500.table <- table(pph$StudyGroup, pph$BL500)
prop.table(bl500.table, margin = 1)
bl500.table2 <- matrix(c(57,182,49,189), nrow = 2, ncol = 2,
                       byrow = TRUE, 
                       dimnames = list(c("IM", "IV"), c("blood loss >/=500 mL", "blood loss < 500 mL")))
summary(epi2x2(bl500.table2))
fisher.test(bl500.table2)

#### Blood Loss >/= 1000 statistical analysis ####
bl1000.table <- table(pph$StudyGroup, pph$BL1000)
prop.table(bl1000.table, margin = 1)
bl1000.table2 <- matrix(c(18, 221, 14, 224), nrow = 2, ncol = 2, byrow = TRUE, 
                        dimnames = list(c("IM", "IV"), c("blood loss >/= 1000 mL", "blood loss < 1000 mL")))
summary(epi2x2(bl1000.table2))
fisher.test(bl1000.table2)
