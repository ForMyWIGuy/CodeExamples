## Volcano plot

install.packages("readxl")
library(readxl)
library(ggplot2)

setwd('~/Desktop/CSCI5465_project/Project_data')
study_data  <- (read_xlsx('~/Desktop/CSCI5465_project/Project_data/GSE207882_All_Differentially_Expressed_tRF.xlsx',skip=18,col_names = TRUE))
# names <- read_xlsx('~/Desktop/CSCI5465_project/Project_data/GSE207882_All_Differentially_Expressed_tRF.xlsx', range="A19:A646", col_names = TRUE)


### pulled res forward from DESeq2 data analysis I ran
fold_change <- res$log2FoldChange # x axis of volcano plot
#sorted_fold_change <- sort(fold_change, decreasing=TRUE)
#length(which(fold_change >= 1.5))
# study used fold change > 1.5 as significant
p_Val = res$pvalue

# adjusted_p = res$padj
# length(which(adjusted_p < 0.05))
# 
# p_Values = res$pvalue
# length(which(p_Values < 0.05))

# Bon_adj_p <-  c() 
# for (number in p_Values){
#     new_p = number/627
#     Bon_adj_p <- c(Bon_adj_p, new_p)
# }
# low_p = Bon_adj_p[which(Bon_adj_p<0.0001)]
# sorted_low_p = sort(low_p, decreasing=FALSE)
### using my own data -- created volcano plot and heat map
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
heatmap(matrix_expr_data, main="tsRNA Study Heatmap")

#### 
# boxplot()
# names_RNA <- rownames(res)
# length(which(rownames(res) == "tRF-1-28-Gly-Gcc-1"))


#### used data reported in study data sets 



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


library(readr)
GO_file <- list()
GO_file$ID <- as.data.frame(spreadsheet_data$MINTbase_ID)
GO_file$Seq <- as.data.frame(spreadsheet_data$tRF_Seq)
GO_file_df <- as.data.frame(GO_file)

output_folder = 'GO_TermSearch'
dir.create(output_folder)
filename = file.path(output_folder)
write.d
write_delim(GO_file_df, file = "GO_file.txt")

# subtype number in group
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
colors = c("palegreen","yellowgreen","orchid1","steelblue","pink3", "turquoise","plum3","yellow","lightblue","purple")
pie(totals, labels=label, col= colors, main="Types Represented tsRNA Study")
legend("bottomleft", cex=0.8, legend = label, fill = c("palegreen","yellowgreen","orchid1","steelblue","pink3", "turquoise","plum3","yellow","lightblue","purple"))
not_resistant_expression1 <- matrix_expr_data[, not_resistant_indices]

for (row in 1:length(not_resistant_expression1)){
    if(not_resistant_expression1!=0){
        
    }
}

length(which(resistant_expression1>0))

trf_type = spreadsheet_data$Type
not_resistant_expression1 <- cbind(not_resistant_expression1, tRF_type=trf_type)

not_resistant_expression1[which(rowSums(not_resistant_expression1)==0),]
index_search = which(rowSums(not_resistant_expression1)==0)
not_resistant_expression1[index_search,]



not_resistant_expression1[,"tRF_type"]
NRtotals <- vector()
NRtype_tots <- vector()
NRtype_count <- vector()
label <- vector()
for (i in 1:length(search_types)){
    NRtype_count = sum(lengths(regmatches(not_resistant_expression1[,"tRF_type"], gregexpr(search_types[i], not_resistant_expression1[,"tRF_type"]))))
    NRtotals <- c( NRtotals, NRtype_count)
    NRtype_tots <- c(NRtype_tots, c(search_types[i], NRtype_count))
    label <- c(label, paste(search_types[i]," (",(as.numeric(NRtype_count)),")", sep=""))
}

NRtype_tots

colors = c("palegreen","yellowgreen","orchid1","steelblue","pink3", "turquoise","plum3","yellow","lightblue","purple")
pie(NRtotals, labels=label, col=colors, main="Not Resistant tsRNA Counts")
legend("bottomleft", cex=0.8, legend=search_types, fill=colors)

resistant_expression1 <- matrix_expr_data[,resistant_indices]
resistant_expression1 <- cbind(resistant_expression1, spreadsheet_data$Type)

sum(types)
head(types)
tail(types)
pie(x=c(numbervector), labels=slice_descriptions, col=rainbow(length(x)))

