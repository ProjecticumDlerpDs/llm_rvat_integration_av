# Necessary packages
library(tidyverse)

# Extract questions from greeting.md
text <- as.vector(read_file("prototype/prompts/greeting.md"))
clean_questions <- as_tibble(str_extract_all(text, 
                                   "<span class=\"suggestion\">.*</span>", 
                                   simplify = TRUE))

# Make data tidy 
clean_questions <- pivot_longer(clean_questions, 
                                cols = V1:V17,  
                                names_to = "question_nr",
                                values_to = "question")

# Delete the <span class=\"suggestion\"> and </span> part of the string
clean_questions$question <- clean_questions$question |>
  str_replace_all(pattern = "<span class=\"suggestion\">", replacement = "") |>
  str_replace(pattern = "</span>", replacement = "")

# Put gold truth queries in string
gold_truth <- c("SELECT COUNT(VAR_id) AS number_of_variants
                     FROM varInfo_synthetic
                     WHERE gene_name = 'NEK1'",
                "SELECT *
                     FROM varInfo_synthetic
                     WHERE HighImpact = 1 AND CADDphred > 20 AND gene_name = 'NEK1'",
                "SELECT COUNT(*) AS number_of_variants_with_SIFT_D
                     FROM varInfo_synthetic
                     WHERE gene_name = 'TARDBP' AND SIFT = 'D'",
                "SELECT *
                     FROM varInfo_synthetic
                     WHERE HighImpact = 1 AND (ALS_1 = 2 OR ALS_2 = 2 OR ALS_3 = 2 OR ALS_4 = 2 OR ALS_5 = 2)",
                "SELECT *
                FROM varInfo_synthetic
                WHERE CADDphred > 20 AND SIFT = 'D' AND PolyPhen = 'D' AND gene_name = 'ABCA4'
                ORDER BY CADDphred DESC
                LIMIT 10;",
                "SELECT VAR_id, MAX(AF) AS highest_allele_frequency
                FROM varInfo_synthetic",
                "SELECT
                  AVG(CASE WHEN Synonymous = 1 THEN AF END) AS average_AF_synonymous,
                  AVG(CASE WHEN ModerateImpact = 1 THEN AF END) AS average_AF_moderate,
                  AVG(CASE WHEN HighImpact = 1 THEN AF END) AS average_AF_high
                FROM varInfo_synthetic",
                "SELECT
                  SUM(CASE WHEN ALS_1 = 1 THEN 1 ELSE 0 END) AS heterozygous,
                  SUM(CASE WHEN ALS_1 = 2 THEN 1 ELSE 0 END) AS homozygous
                FROM varInfo_synthetic
                WHERE HighImpact = 1;",
                "SELECT
                SUM(ALS_1 + ALS_2 + ALS_3 + ALS_4 + ALS_5) AS total_cases_burden,
                SUM(Control_1 + Control_2 + Control_3 + Control_4 + Control_5) AS total_controls_burden
                FROM varInfo_synthetic;",
                "SELECT
                VAR_id,
                gene_name,
                (ALS_1 + ALS_2 + ALS_3 + ALS_4 + ALS_5) AS case_count,
                (Control_1 + Control_2 + Control_3 + Control_4 + Control_5) AS control_count,
                ((ALS_1 + ALS_2 + ALS_3 + ALS_4 + ALS_5) * 1.0) /
                  NULLIF((Control_1 + Control_2 + Control_3 + Control_4 + Control_5), 0) AS case_control_ratio
                FROM varInfo_synthetic
                ORDER BY case_control_ratio DESC
                LIMIT 10;",
                "SELECT
                gene_name,
                CHROM,
                COUNT(*) AS total_variants,
                SUM(CASE WHEN HighImpact = 1 THEN 1 ELSE 0 END) AS high_impact_count,
                SUM(CASE WHEN ModerateImpact = 1 THEN 1 ELSE 0 END) AS moderate_impact_count,
                SUM(CASE WHEN Synonymous = 1 THEN 1 ELSE 0 END) AS synonymous_count,
                AVG(AF) AS mean_AF,
                MIN(POS) AS start_pos,
                MAX(POS) AS end_pos,
                (MAX(POS) - MIN(POS)) AS length
                FROM varInfo_synthetic
                GROUP BY gene_name, CHROM
                HAVING total_variants > 10
                ORDER BY total_variants DESC",
                NA,
                NA,
                NA,
                NA,
                NA,
                NA)


# To compare the generated query of LLM to the gold_truth we don't want to compare
# the AS component, since this is the name of the column which is not realistic to 
# exactly match. This is done by putting the regex \\s*(?:AS\\s+\\w+\\s+)? in stead of
# the AS component.

gold_truth_no_AS <- c("SELECT COUNT\\(VAR_id\\)\\s*(?:AS\\s+\\w+\\s+)?FROM varInfo_synthetic
                     WHERE gene_name = 'NEK1'",
                      "SELECT VAR_id, gene_name, HighImpact, CADDphred
                      FROM varInfo_synthetic
                      WHERE HighImpact = 1 AND CADDphred > 20 AND gene_name = 'NEK1'",
                      "SELECT COUNT\\(\\*\\)\\s*(?:AS\\s+\\w+\\s+)?FROM varInfo_synthetic
                      WHERE gene_name = 'TARDBP' AND SIFT = 'D'",
                      "SELECT VAR_id, gene_name, HighImpact, ALS_1, ALS_2, ALS_3, ALS_4, ALS_5
                      FROM varInfo_synthetic
                      WHERE HighImpact = 1 AND \\(ALS_1 = 2 OR ALS_2 = 2 OR ALS_3 = 2 OR ALS_4 = 2 OR ALS_5 = 2\\)",
                      "SELECT VAR_id,
                      gene_name,
                      CADDphred,
                      SIFT,
                      PolyPhen
                      FROM varInfo_synthetic
                      WHERE CADDphred > 20 AND SIFT = 'D' AND PolyPhen = 'D' AND gene_name = 'ABCA4'
                      ORDER BY CADDphred DESC
                      LIMIT 10;",
                      "SELECT VAR_id, MAX\\(AF\\)\\s*(?:AS\\s+\\w+\\s+)?FROM varInfo_synthetic",
                      "SELECT
                      AVG\\(CASE WHEN Synonymous = 1 THEN AF END\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      AVG\\(CASE WHEN ModerateImpact = 1 THEN AF END\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      AVG\\(CASE WHEN HighImpact = 1 THEN AF END\\)\\s*(?:AS\\s+\\w+\\s*)?
                      FROM varInfo_synthetic",
                      "SELECT
                      SUM\\(CASE WHEN ALS_1 = 1 THEN 1 ELSE 0 END\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      SUM\\(CASE WHEN ALS_1 = 2 THEN 1 ELSE 0 END\\)\\s*(?:AS\\s+\\w+\\s*)?
                      FROM varInfo_synthetic
                      WHERE HighImpact = 1;",
                      "SELECT
                      SUM\\(ALS_1 \\+ ALS_2 \\+ ALS_3 \\+ ALS_4 \\+ ALS_5\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      SUM\\(Control_1 \\+ Control_2 \\+ Control_3 \\+ Control_4 \\+ Control_5\\)\\s*(?:AS\\s+\\w+\\s*)?
                      FROM varInfo_synthetic;",
                      "SELECT
                      VAR_id,
                      gene_name,
                      \\(ALS_1 \\+ ALS_2 \\+ ALS_3 \\+ ALS_4 \\+ ALS_5\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      \\(Control_1 \\+ Control_2 \\+ Control_3 \\+ Control_4 \\+ Control_5\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      \\(\\(ALS_1 \\+ ALS_2 \\+ ALS_3 \\+ ALS_4 \\+ ALS_5\\) \\* 1\\.0\\) /
                      NULLIF\\(\\(Control_1 \\+ Control_2 \\+ Control_3 \\+ Control_4 \\+ Control_5\\), 0\\)\\s*(?:AS\\s+\\w+\\s*)?
                      FROM varInfo_synthetic
                      ORDER BY case_control_ratio DESC
                      LIMIT 10;",
                      "SELECT
                      gene_name,
                      CHROM,
                      COUNT\\(\\*\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      SUM\\(CASE WHEN HighImpact = 1 THEN 1 ELSE 0 END\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      SUM\\(CASE WHEN ModerateImpact = 1 THEN 1 ELSE 0 END\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      SUM\\(CASE WHEN Synonymous = 1 THEN 1 ELSE 0 END\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      AVG\\(AF\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      MIN\\(POS\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      MAX\\(POS\\)\\s*(?:AS\\s+\\w+\\s*,\\s*)?
                      \\(MAX\\(POS\\) - MIN\\(POS\\)\\)\\s*(?:AS\\s+\\w+\\s*)?
                      FROM varInfo_synthetic
                      GROUP BY gene_name, CHROM
                      HAVING total_variants > 10
                      ORDER BY total_variants DESC",
                      NA,
                      NA,
                      NA,
                      NA,
                      NA,
                      NA)


# Make tibble with question number, question 
# and type of question (lookup, analytic or negative control (nc))
control_questions <- tibble(question_nr = seq(1:17),
       question = clean_questions$question,
       gold_truth = gold_truth,
       gold_truth_no_AS = gold_truth_no_AS)

# Add type_question and question_nr to the raw_data table and call it data_complete.
raw_data <- readRDS("data/raw_data.rds")
question_nr <- control_questions |>
  select(question_nr, question)
data_complete <- left_join(raw_data,
                           question_nr,
                           by = join_by(prompt == question))

# Add timeout results (question 5, 4 times, question 7 ,8 and 9 2 times and question 16 once). 
# Notice that these are not in raw_data and should be manually added. If deciding to leave these out, 
# simply put this part in comments
data_complete$fail_reason <- NA
data_complete <- data_complete |> add_row(question_nr = 5, 
                                          replicate = 2, 
                                          model = "qwen3:8b",
                                          fail_reason = "timeout") |>
  add_row(question_nr = 5, replicate = 3, model = "qwen3:8b", fail_reason = "timeout") |>
  add_row(question_nr = 5, replicate = 4, model = "qwen3:8b", fail_reason = "timeout") |>
  add_row(question_nr = 5, replicate = 5, model = "qwen3:8b", fail_reason = "timeout") |>

# twice for question 7 
  add_row(question_nr = 7, replicate = 3, model = "qwen3:8b", fail_reason = "timeout") |> 
  add_row(question_nr = 7, replicate = 4, model = "qwen3:8b", fail_reason = "timeout") |>

# Twice for question 8
  add_row(question_nr = 8, replicate = 2, model = "qwen3:8b", fail_reason = "timeout") |> 
  add_row(question_nr = 8, replicate = 4, model = "qwen3:8b", fail_reason = "timeout") |>

# Twice for question 9
  add_row(question_nr = 9, replicate = 2, model = "qwen3:8b", fail_reason = "timeout") |>
  add_row(question_nr = 9, replicate = 3, model = "qwen3:8b", fail_reason = "timeout") |>
  add_row(question_nr = 9, replicate = 4, model = "qwen3:8b", fail_reason = "timeout") |>

# Once for question 10
  add_row(question_nr = 10, replicate = 3, model = "qwen3:8b", fail_reason = "timeout") |>
  add_row(question_nr = 10, replicate = 4, model = "qwen3:8b", fail_reason = "timeout") |>

# Once for question 16
  add_row(question_nr = 16, replicate = 3, model = "qwen3:8b", fail_reason = "timeout")

# Only keeps unique rows, if a chat is saved multiple times it deletes the duplicate 
data_complete <- data_complete |> distinct(across(-timestamp), .keep_all = TRUE)

# Make sure only complete benchmark questions are kept by excluding NA's in 
# question_nr or model (a missing model means the 'Save Chat History' button was pressed
# before the chat was over)
data_complete <- data_complete |>
  filter(!is.na(question_nr) & !is.na(model))

# The first 5 questions are lookup questions, questions 6 to 11 are analytical questions
# Question 12 to 17 are negative control questions (nc). Add type_question
data_complete <- data_complete |>
  mutate(type_question = case_when(
    data_complete$question_nr <= 5 ~ "lookup",
    data_complete$question_nr > 5 & data_complete$question_nr <= 11 ~ "analytical",
    TRUE ~ "nc"
  ))

# Make type_questions a factor for better visualizing in graphs
type_questions <- c("lookup", "analytical", "nc")
data_complete$type_question <- factor(data_complete$type_question, 
                                      levels = type_questions)

# Add gold_truth information
gold_truth_info <- control_questions |>
  select(question_nr, gold_truth, gold_truth_no_AS)
data_complete <- left_join(data_complete, gold_truth_info)

#Write file
write_rds(data_complete, "data/data_complete.rds")                           

