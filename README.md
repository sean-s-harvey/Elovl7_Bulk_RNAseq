# How does loss of endothelial Elovl7 expression impact gene expression in the brain, and does this impact age-associated transcriptomic changes?
Here you can find all scripts and jupyter notebooks used for analyzing our Elovl7 bulk RNA-sequencing (RNAseq) dataset. Specifically, we sequenced the transcriptomes of all cells within cortical isolates from endothelial-specific Elovl7 conditional knockout (cKO) mice and litter-mate control, across the aging process. Specifically, we performed RNAseq in 4-month old mice, and 20-month old mice. Therefore, this allows us to compare how loss of Elovl7 impacts gene expression in the brain, and allows us to determine how loss of Elovl7 affects age-related transcriptomic changes.

Sequencing libraries were prepared at the UC San Diego IGM Genomics Center with a stranded mRNA kit, and sequenced on an Illumina NovaSeq X Plus leveraging a paired-end sequencing approach. 

# Mapping and Counting Features
Sequencing reads were aligned to the mm10 genome (refdata-gex-mm10-2020-A) using STAR (v2.7.10a). Gene counts were determined using the featureCounts function in Subread (v2.0.6).

# Analysis Pipeline 
Count matrix and metadata were loaded into R (v4.3.2). Differential expression (DE) analysis was performed using DESeq2 (v1.40.2), with Wald's test and Benjamini-Hochberg multiple testing procedure. In a preliminary test, DE analysis between cKO and control was performed across the entire dataset (aged and young together), with an Age:Genotype interaction term included; however, this approach resulted in the model fitting more to noise (low-abundance hypervariable features), and missed the real changes. DE analysis was ultimately performed pair-wise between Elovl7 cKO and litter-mate control samples across ages with sex of the mice considered as a covariate in all comparisons. In this approach, each age group (4 months and 20 months), were essentially treated as entirely distinct datasets. Additionally, DE analysis was used to compare Aged controls to Young controls, and Aged cKO to Young cKO. Differentially expressed genes (DEGs) were determined as those with BH-adjusted p-values < 0.05.    

For clustering and principal component analysis (PCA), variance across the range of expression values was stabilized using the variance stabilizing transformation function (vst), and stabilized data were then projected into principal component (PC) space using the plotPCA function. 

![PCA.pdf](https://github.com/user-attachments/files/21025935/PCA.pdf)

Volcano plots and MA plots were generated with gpplot2 (v3.5.1) utilizing the results output from DESeq2.
![Volcano_Ctrl_AgedvsYoung.pdf](https://github.com/user-attachments/files/21025940/Volcano_Ctrl_AgedvsYoung.pdf)

![MA_Ctrl_AgedvsYoung.pdf](https://github.com/user-attachments/files/21025943/MA_Ctrl_AgedvsYoung.pdf)

Additonally, the DESeq2 notebook contains custom code to convert count matrix data into transcripts-per-million (TPM) values, and export these results along with the output from all DESeq2 experiments. This provides a clean and tidy dataset to look through, with all TPM values for all samples alongside the output from all statistical comparisons. 
