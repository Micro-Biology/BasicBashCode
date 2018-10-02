#Q2ManifestMaker
#Here I present my tutorial for making a QIIME2 ‘Manifest.csv’ automatically using an R conda environment, to be used to import data according to the " “Fastq manifest” formats" part of the Importing data tutorial, on the QIIME2 website. 

#I wrote this script because we intended on running a lot of analyses through QIIME2 and I did not want to manually make a manifest file to import samples every time.  This guide assumes you have a version of conda installed, and that files at names samplename.R1.fastq.gz for forward reads and samplename.R2.fastq.gz for reverse reads. Although it would be very easy to alter the code to work with similar naming schemes.  All your fastq.gz files must be in a folder called “Data” within your current directory.



# 'Install' Instructions:

#If you already happen to have a conda environment with these R packages installed then you can skip this step if you change some of the code.

    #conda create -n R-Env r-essentials -y

    #source activate R-Env

    #conda install -c r r-tidyverse -y

    #conda install -c r r-gdata -y


#Information and potentially support available here: https://forum.qiime2.org/t/automatic-manifest-maker-in-r/2921

#Actual Script

library(tidyverse)

SamplesF <- list.files(path = "Data", pattern = "*.R1.fastq.gz", all.files = FALSE,
       full.names = TRUE, recursive = FALSE,
       ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)

TabF <- as.data.frame(SamplesF)

PathF <- data.frame(lapply(TabF, function(TabF) {gsub("Data/", "$PWD/N/", TabF)}))
PathF <- data.frame(lapply(PathF, function(PathF) {gsub("fastq.gz", "fastq.gip", PathF)}))

names(PathF)[names(PathF)=="SamplesF"] <- "absolute-filepath" 

PathF['direction']='forward'

PathF['sample-id']= SamplesF

PathF <- data.frame(lapply(PathF, function(PathF) {gsub("Data/", "sample-", PathF)}))
PathF <- data.frame(lapply(PathF, function(PathF) {gsub(".R1.fastq.gz", "", PathF)}))
PathF <- data.frame(lapply(PathF, function(PathF) {gsub("fastq.gip", "fastq.gz", PathF)})) 
PathF <- data.frame(lapply(PathF, function(PathF) {gsub("/N/", "/Data/", PathF)})) 

PathF <- PathF[,c(3,1,2)]


SamplesR <- list.files(path = "Data", pattern = "*.R2.fastq.gz", all.files = FALSE,
       full.names = TRUE, recursive = FALSE,
       ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)

TabR <- as.data.frame(SamplesR)

PathR <- data.frame(lapply(TabR, function(TabR) {gsub("Data/", "$PWD/N/", TabR)}))
PathR <- data.frame(lapply(PathR, function(PathR) {gsub("fastq.gz", "fastq.gip", PathR)}))

names(PathR)[names(PathR)=="SamplesR"] <- "absolute-filepath" 

PathR['direction']='reverse'

PathR['sample-id']= SamplesR

PathR <- data.frame(lapply(PathR, function(PathR) {gsub("Data/", "sample-", PathR)}))
PathR <- data.frame(lapply(PathR, function(PathR) {gsub(".R2.fastq.gz", "", PathR)}))
PathR <- data.frame(lapply(PathR, function(PathR) {gsub("fastq.gip", "fastq.gz", PathR)})) 
PathR <- data.frame(lapply(PathR, function(PathR) {gsub("/N/", "/Data/", PathR)})) 

PathR <- PathR[,c(3,1,2)]

Manifest <- rbind(PathF, PathR)

names(Manifest)[names(Manifest)=="sample.id"] <- "sample-id" 

names(Manifest)[names(Manifest)=="absolute.filepath"] <- "absolute-filepath" 

write_csv(Manifest, "Manifest.csv") 
