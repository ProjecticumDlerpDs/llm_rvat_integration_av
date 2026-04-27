# Data description

This is data for the table varInfo_synthetic-1
This dataset is based on a VCF file where gene variants data is stored. 
The table has the following column names.

## Column names 

VAR_id: generic generated gene variant_id /n  
CHROM: chromosome  
POS: position on the chromosome  
ID: If available a variant ID  
REF: reference allel  
ALT: alternative allel  
QUAL: Quality of reads  
FILTER: Does quality pass filter?  
AC: alternative allel count  
AN: total number of allelles  
AF: allel frequency  
gene_name: Name of the gene  
HighImpact: If it's a nonsense mutation or frameshift gives score 1  
ModerateImpact: If it's a missense mutation gives score 1  
Synonymous: If it's a silent mutation (amino acid remains same) gives score 1  
CADDphred:Combined Annotation Dependent Depletion (CADD) Phred-like score  
PolyPhen: Polymorphism Phenotyping v2 (PolyPhen-2) score (B = benign, P = possibly deletorious, D = deletorious)  
SIFT: Sorting Intolerant From Tolerant (SIFT) score. (D= deletorious, T = tolerated)  
ALS_\*: patient with ALS where \* is identifying number  
Control_\*: healthy control where \* is identifying number