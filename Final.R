#install.packages("readxl")
library(readxl)

setwd('~/Desktop/CSCI5465_project/Project_data')
spreadsheet_data  <- (read_xlsx('~/Desktop/CSCI5465_project/Project_data/GSE207882_Expression_tRF.xlsx', col_names = TRUE, skip=11))
resistance_status <- read.csv(file = 'resistance_status.csv')

expression_data <- spreadsheet_data[,(8:17)]
expression_data <- as.data.frame(expression_data)
colnames(expression_data) <- resistance_status$Sample_id


counts_per_Million = spreadsheet_data[18:27]
counts_per_Million = as.data.frame(counts_per_Million)
colnames(counts_per_Million) <- resistance_status$Sample_id


not_resistant_indices = resistance_status$Sample_resistance_status==0
resistant_indices = resistance_status$Sample_resistance_status==1

resistant_samples_GMSnum = resistance_status$Sample_GEO_access[resistant_indices]
not_resistant_samples_GSMnum = resistance_status$Sample_GEO_access[not_resistant_indices]


resistant_samples_id = resistance_status$Sample_id[resistant_indices]
not_resistant_samples_id = resistance_status$Sample_id[not_resistant_indices]

hist(expression_data$`13`)  # demonstrates as null distr

not_resistant_expression = as.matrix(c(expression_data$`5`, expression_data$`9`, expression_data$`13`, expression_data$`17`, expression_data$`21`), byrow=TRUE)
resistant_expression = as.matrix(c(expression_data$`7`,expression_data$`8`, expression_data$`18`, expression_data$`19`, expression_data$`20`), byrow=TRUE)

# convert expression_data to matrix
matrix_expr_data = as.matrix(expression_data)
# Add tRF IDs to matrix
rownames(matrix_expr_data) <- spreadsheet_data$tRF_ID

sample_ids <- as.vector(resistance_status$Sample_id)

output_folder="Histograms"
dir.create(output_folder)

for (i in c(1:10)){
    current_data = matrix_expr_data[,i]
    num = sample_ids[i]
    filename = file.path(output_folder, paste('histogram_', num, '.png', sep = ''))
    # Open the "png" device so that graphics are drawn to a png file
    png(filename, width = 8, height = 6, units = 'in', res = 144)
    hist(log(current_data), xlab= "Count", ylab="Frequency", main=paste("Histogram of ",num, sep=""))
    dev.off()    
}

### initial attempt below was to plot each individually, then
## I was able to complete plot to file in a loop above.
hist(log(matrix_expr_data), main="All Expression Data", xlab="Expression Count")
hist(log(expression_data$`13`), main="Sample 13 Expression Data", xlab="Expression Count", breaks=50)
hist(log(expression_data$`17`), main="Sample 17 Expression Data", xlab="Expression Count", breaks=50)
hist(log(expression_data$`18`), main="Sample 18 Expression Data", xlab="Expression Count", breaks=50)
hist(log(expression_data$`19`), main="Sample 19 Expression Data", xlab="Expression Count", breaks=50)
hist(log(expression_data$`20`), main="Sample 20 Expression Data", xlab="Expression Count", breaks=50)
hist(log(expression_data$`21`), main="Sample 21 Expression Data", xlab="Expression Count", breaks=50)
hist(log(expression_data$`5`), main="Sample 5 Expression Data", xlab="Expression Count", breaks=50)
hist(log(expression_data$`7`), main="Sample 7 Expression Data", xlab="Expression Count", breaks=50)
hist(log(expression_data$`8`), main="Sample 8 Expression Data", xlab="Expression Count", breaks=50)
hist(log(expression_data$`9`), main="Sample 9 Expression Data", xlab="Expression Count", breaks=50)

## Begin DESeq Analysis
# Install DESeq2 package for RNA analysis
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("DESeq2")
library("DESeq2")

# convert resistance status to factor
resistance_status$Sample_resistance_status <- factor(resistance_status$Sample_resistance_status)
# Normalize for size and estimate dispersion of the data
cds <- DESeqDataSetFromMatrix(countData = matrix_expr_data, colData = resistance_status, design = ~Sample_resistance_status)
# Fit DESeq Model
cds <- DESeq(cds)

# Calculate Differential Expression
res <- results(cds)
resDF <- as.data.frame(res)

library(readr)
# send results to file
output_folder = 'DESeq_results'
dir.create(output_folder)
filename = file.path(output_folder)
write_delim(resDF, file = "DESeq_results_file.txt")

# res <- results(cds,contrast = c("Sample_resistance_status","0","1"), alpha = 0.05, lfcThreshold = 1.5)
# Adding in the alpha p < 0.05 and FC > 1.5 as reported gives 0 p values of significance

num_sig <- length(which(res$pvalue<0.05))
sig_results <- res[which(res$pvalue<0.05),]
sorted_sig_results <- sort(sig_results$pvalue, decreasing = FALSE)

sorted_sig_fc = sort(sig_results$log2FoldChange, decreasing=TRUE)
print(sorted_sig_fc[1:10])
### results in 54 items with a p value < 0.05 - Study reported 57 total with 36 upregulated and 21 downregulated
### adding parameters to the results() calculation of diff expression results in no p < 0.05 with lfcThreshold = 1 
res <- res[order(res$padj),]
top_10 <- rownames(res)[1:10]
print(top_10)
table(top_10)

top_20 <- rownames(res)[1:20]
print(top_20)
table(top_20)
res_FC <- res[order(res$log2FoldChange),]

FC_top10 <- rownames(res_FC)[1:10]
print(FC_top10)
res_FC[FC_top10,]

FC_top100 <- rownames(res_FC)[1:100]
print(FC_top100)
res_FC[FC_top100,]

####
#### comparisons between the two groups were performed via ttest
not_resistant_expression1 <- matrix_expr_data[, not_resistant_indices]
resistant_expression1 <- matrix_expr_data[,resistant_indices]
mean_not_resist <- rowMeans(not_resistant_expression1)
mean_resist <- rowMeans(resistant_expression1)

expression_diff <- mean_not_resist - mean_resist
sorted_expr_diff <- expression_diff[order(expression_diff, decreasing = TRUE)]
max_positive = sorted_expr_diff[1:5]
max_negative = sorted_expr_diff[622:627]

NotResistant_variance <- apply(not_resistant_expression1, 1, var)
resistant_variance <- apply(resistant_expression1, 1, var)

t_stats = expression_diff / sqrt(NotResistant_variance/length(not_resistant_samples_id) + resistant_variance/length(resistant_samples_id))
hist(t_stats, main="tsRNA t-stats Histogram", breaks=100)
pvals = 2 * pt(-abs(t_stats), length(not_resistant_samples_id) + length(resistant_samples_id) -2)

sorted_pvals_ind = order(pvals)
sorted_pvals = pvals[sorted_pvals_ind]
sig_names = rownames(matrix_expr_data)[sorted_pvals_ind]
sorted_tstats = t_stats[sorted_pvals_ind]

sig_names[sorted_pvals < 0.05] ## returns 103
length(sorted_tstats[sorted_pvals < 0.05])  ## returns 103
length(sorted_pvals[sorted_pvals < 0.05])  ## returns 103

print(sprintf('Number of significantly differentially expressed genes: %d', sum(pvals < 0.05)))
print(sprintf('Number of significantly differentially expressed genes after a Bonferroni correction: %d', sum(pvals < 0.05/ 627)))
print(sprintf('Number of significantly differentially expressed genes, Not resistant > Resistant: %d', sum(pvals < 0.05 & t_stats > 0)))
print(sprintf('Number of significantly differentially expressed genes, Not resistant < Resistant : %d', sum(pvals < 0.05 & t_stats < 0)))

#### edgeR package for analysis
BiocManager::install("edgeR")
library("edgeR")
edge_data <- DGEList(counts= matrix_expr_data, group=factor(resistance_status$Sample_resistance_status))
dim(edge_data)

edge_data_copy <- edge_data  ## copy data to new variable for back up
head(edge_data$counts)
CPM_edge_data <- (cpm(edge_data))  
# apply(edge_data$counts, 2, sum)
# The tutorial reduced the sample size.  Given my small sample, I did not reduce
# edge_keep = rowSums(cpm(edge_data)>100) >= 2
# edge_data = edge_data[edge_keep,]
# dim(edge_data)
# edge_data1_keep$samples$lib.size <- colSums(edge_data1_keep$counts)
# edge_data1_keep$samples

edge_data <- calcNormFactors(edge_data)  ## Normalize read counts
edge_data  

plotMDS(edge_data, method="bcv", main="tsRNA Analysis of Groups", col=as.numeric(edge_data$samples$group))
legend("right", as.character(unique(edge_data$samples$group)), col=1:3, pch=20)

data_BCVplot = estimateDisp(edge_data, prior.df = 0)
plotBCV(data_BCVplot, main="tsRNA analysis, classic dispersion")

data_BCVplot_1 = estimateDisp(edge_data)
plotBCV(data_BCVplot_1, main="tsRNA analysis default prior.df")

edge_dispursion <- estimateCommonDisp(edge_data, verbose=TRUE)
names(edge_dispursion)
plotBCV(edge_dispursion, main="tsRNA analysis Estimate Common Dispursion")

edge_dispursion = estimateTagwiseDisp(edge_dispursion)
names(edge_dispursion)
plotBCV(edge_dispursion, main="tsRNA Analysis Tagwise Dispersion")

edge_disp = estimateTrendedDisp(edge_dispursion)
plotBCV(edge_disp, main="Trended dispursion")
et01 <- exactTest(edge_disp)

exact_pvals <- et01$table$PValue
install.packages("xlsx")
library("xlsx")
output_folder = 'edgeR_results'
dir.create(output_folder)
filename = file.path(output_folder)
write.xlsx(exact_pvals, file = "exactTestResults_file.xlsx")

test_results = decideTestsDGE(et01, adjust.method="BH", p.value=0.1)
test_results[which(test_results== -1),]
test_results[which(test_results== 1),]

## GLM estimates of dispersion
design.mat_1 <- model.matrix(~ 0 + edge_disp$samples$group)
colnames(design.mat_1) <- levels(edge_disp$samples$group)
edge_disp <- estimateGLMCommonDisp(edge_disp, design.mat_1)
edge_disp <- estimateGLMTrendedDisp(edge_disp, design.mat_1, method="bin.spline")
edge_disp <- estimateGLMTagwiseDisp(edge_disp, design.mat_1)  ## eliminated the design.mat due to "Error in prior.d *m0 : non-conformable arrays"
plotBCV(edge_disp, main="tsRNA data visualization GLM Modeling")
head(edge_disp)
ncol(edge_disp)
et01 <- exactTest(edge_disp)
names(et01$table)
top_output <- topTags(et01)
# not resistant = 0 resistant = 1
sorted_e01 = sort(et01$table$PValue, decreasing = FALSE)
length(which(sorted_e01[1:50] <= 0.05))  ## 47

sorted_edge_FC = sort(et01$table$logFC, decreasing= TRUE)
sorted_edge_FC[sorted_edge_FC>=1.5]  ## study authors considered FC > 1.5 significant

## Graphics 
library(ggplot2)
setwd('~/Desktop/CSCI5465_project/Project_data')
study_data  <- (read_xlsx('~/Desktop/CSCI5465_project/Project_data/GSE207882_All_Differentially_Expressed_tRF.xlsx',skip=18,col_names = TRUE))
# using results of DESeq analysis above
fold_change <- res$log2FoldChange # x axis of volcano plot
p_Val = res$pvalue

volcano_data = list()
volcano_data$Fold_change = fold_change
volcano_data$p_value = p_Val
volcano_data$tRF_ID = rownames(res)
# volcano_data$low_p_values <- volcano_data$p_value[volcano_data$p_value < 0.05]
# volcano_data$filtered_Folds <- volcano_data$Fold_change[volcano_data$Fold_change < 0.6]
df <- as.data.frame(volcano_data)
volcano <- ggplot(data=df, main="Volcano Plot tsRNA Study", aes(x=fold_change, y=-log10(p_Val), col=p_Val)) + geom_point() + theme_classic()
volcano + geom_vline(xintercept = c(-0.5,0.5), linetype="dashed", color="green") +
    geom_hline(yintercept = 1.25, linetype="dashed", col= "green")

## heatmap attempt
heatmap(matrix_expr_data, main="SVR vs NSVR tsRNA Study Heatmap")

### Because my values were not matching study, used study data to create volcano plot to compare, plots are exactly the same
volcano_Sdata_list = list()
volcano_Sdata_list$FC = study_data$Fold_Change 
volcano_Sdata_list$PV = study_data$p_value
volcano_Sdata_list$tRF_ID = study_data$tRF_ID
# volcano_data$low_p_values <- volcano_data$p_value[volcano_data$p_value < 0.05]
# volcano_data$filtered_Folds <- volcano_data$Fold_change[volcano_data$Fold_change < 0.6]
df_Sdata <- as.data.frame(volcano_Sdata_list)
volcano <- ggplot(data=df_Sdata, main="Data directly from tsRNA Study", aes(x=fold_change, y=-log10(p_Val), col=p_Val)) + geom_point() + theme_classic()
volcano + geom_vline(xintercept = c(-0.5,0.5), linetype="dashed", color="green") +
    geom_hline(yintercept = 1.25, linetype="dashed", col= "green")

## Pie charts
types <- spreadsheet_data$Type
search_types <- unique(types)
length(search_types)

sum(lengths(regmatches(types, gregexpr(search_types[1], types))))
sum(lengths(regmatches(types, gregexpr(search_types[2], types))))
sum(lengths(regmatches(types, gregexpr(search_types[3], types))))
sum(lengths(regmatches(types, gregexpr(search_types[4], types))))
sum(lengths(regmatches(types, gregexpr(search_types[5], types))))
sum(lengths(regmatches(types, gregexpr(search_types[6], types))))
sum(lengths(regmatches(types, gregexpr(search_types[7], types))))
sum(lengths(regmatches(types, gregexpr(search_types[8], types))))
sum(lengths(regmatches(types, gregexpr(search_types[9], types))))

totals <- vector()
type_tots <- vector()
type_count <- vector()
label <- vector()
for (i in 1:length(search_types)){
    type_count = sum(lengths(regmatches(types, gregexpr(search_types[i], types))))
    totals <- c( totals, type_count)
    type_tots <- c(type_tots, c(search_types[i], type_count))
    label <- c(label, paste(search_types[i]," (",(as.numeric(type_count)),")", sep=""))
    
}
print(totals)
install.packages(colorspace)
library("colorspace")
# colors = c("palegreen","slateblue","orchid1","steelblue","pink3", "turquoise","plum3","yellow","lightblue","purple")

colors = rainbow_hcl(5)
pie(totals, labels=label, col=colors, main="Types Represented tsRNA Study")
legend("bottomleft", cex=0.8, legend = label, fill = colors)
not_resistant_expression1 <- matrix_expr_data[, not_resistant_indices]
trf_type = spreadsheet_data$Type
not_resistant_expression1 <- cbind(not_resistant_expression1, tRF_type=trf_type)
