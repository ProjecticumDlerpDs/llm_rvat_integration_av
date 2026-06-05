# Data description

This is the data structure for the table 'varInfo_synthetic'.
This dataset is based on a VCF file where gene variants data is stored. 
The table has the following column names.

## Column names 

**VAR_id**: generic generated variant ID  
**CHROM**: chromosome  
**POS**: position on the chromosome  
**ID**: If available an ID from other databases like rsID from dbSNP  
**REF**: reference allel  
**ALT**: alternative allel  
**QUAL**: Read quality  
**FILTER**: Does quality pass filter?  
**AC**: alternative allel count  
**AN**: total number of allelles  
**AF**: allel frequency  
**gene_name**: Name of the gene  
**HighImpact**: If it's a nonsense mutation or frameshift gives score 1 else 0  
**ModerateImpact**: If it's a missense mutation gives score 1 else 0  
**Synonymous**: If it's a silent mutation (amino acid remains same) gives score 1 else 0  
**CADDphred**:Combined Annotation Dependent Depletion (CADD) Phred-like score  
**PolyPhen**: Polymorphism Phenotyping v2 (PolyPhen-2) score (B = benign, P = possibly deletorious, D = deletorious)  
**SIFT**: Sorting Intolerant From Tolerant (SIFT) score. (D= deletorious, T = tolerated)  
**ALS_\***: patient with ALS where \* is identifying number, the genotype is shown here. value 0 = homozygous for the reference allele, 1 = heterozygous, 2 = homozygous for the alternative allele  
**Control_\***: healthy control where \* is identifying number, showing the genotype, value 0 = homozygous for the reference allele, 1 = heterozygous, 2 = homozygous for the alternative allele