## Connecting RVAT-database with querychat
In this querychat dashboard you can explore the table with generated data through natural language prompts. 
The large language model returns an SQL-query to the table to answer your question.
The table contains generated data modeled after the databases the RVAT R-package creates. 
It contains gene variant information based on sequencing data along with genotype information of 5 ALS patients and 5 healthy controls. 
If you want to save your chat history, click the 'Save chat history' button.


#### Benchmarking  
Benchmarking was done by asking the benchmarking questions below and scoring the answers given.

##### Lookup questions
  
- <span class="suggestion"> Select number of variants in NEK1 </span>
- <span class="suggestion"> Select variants in NEK1 that with HighImpact and a CADDphered > 20 </span>
- <span class="suggestion"> How many variants in TARDBP are predicted deletorious by SIFT? </span>
- <span class="suggestion"> Which high-impact variants have at least one ALS patient that is homozygous for this variant? </span>
- <span class="suggestion"> What are the ten most deleterious variants in ABCA4 </span>
  
  
##### Analytical questions
  
- <span class="suggestion"> What is the variant with the highest allele frequency </span>
- <span class="suggestion"> What is te average allele frequency for synonymous, moderate, and high-impact variants? </span>
- <span class="suggestion"> How many high-impact variants does the ALS_1 patient carry? </span>
- <span class="suggestion"> What is the total burden of cases versus controls (so how many effect alleles do the ALS cases carry vs controls) </span>
- <span class="suggestion"> Are there more variants in cases than controls? </span>
- <span class="suggestion"> Summarize variant info for each gene. Only select genes that have more than 10 variants. Order the results by the number of variants. </span>
  
  
##### Unanswerable questions
  
- <span class="suggestion"> What is the average age of ALS cases? </span>
- <span class="suggestion"> Is VAR_id 100 previously reported as pathogenic? </span>
- <span class="suggestion"> What is the allele frequency of VAR_id 30 in Europeans? </span>
- <span class="suggestion"> What is the sex distribution of carriers? </span>-
- <span class="suggestion"> Which variants are most important? </span>
- <span class="suggestion"> Which variants are both synonymous and high impact? </span>

