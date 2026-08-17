# analysis/scripts/data_prep.R
# Data cleaning / preprocessing for MLB payroll analysis
# - Computes numeric W, win percentage (W_perc), and team_total_payroll by team-year
# - Assumes the Lahman package is available and its Teams and Salaries data frames are loaded

# Usage:
# 1. Open an R session in the project root
# 2. Install/load packages: install.packages(c("dplyr","Lahman")); library(dplyr); library(Lahman)
# 3. Run this script (source("analysis/scripts/data_prep.R")) or copy the code into an RMarkdown chunk

# Load packages (explicitly) --------------------------------------------------
if (!requireNamespace("dplyr", quietly = TRUE)) stop("Please install dplyr")
if (!requireNamespace("Lahman", quietly = TRUE)) stop("Please install Lahman")

library(dplyr)
library(Lahman)

# Ensure datasets are available -----------------------------------------------
# Lahman provides Teams and Salaries data frames
data("Teams", package = "Lahman")
data("Salaries", package = "Lahman")

# Quantitative variable 1 - W (wins) -----------------------------------------
Teams1 <- Teams %>%
  mutate(W = as.numeric(W))

# Quantitative variable 2 - W_perc (win percentage) --------------------------
Teams1 <- Teams1 %>%
  mutate(W_perc = W / (W + L)) %>%
  mutate(W_perc = as.numeric(W_perc))

# Quantitative variable 3 - team_payroll (aggregated team payroll by year/team)
team_payroll <- Salaries %>%
  group_by(yearID, teamID) %>%
  summarize(team_total_payroll = sum(salary, na.rm = TRUE), .groups = "drop") %>%
  mutate(team_total_payroll = as.numeric(team_total_payroll))

# Optional: join payroll to Teams1 (example join) ----------------------------
# Adjust join keys if your team identifiers differ (teamID vs franchiseID/year)
team_data <- Teams1 %>%
  left_join(team_payroll, by = c("yearID", "teamID" = "teamID"))

# Save a cleaned, small CSV for quick inspection (recommended path)
if (!dir.exists("data/processed")) dir.create("data/processed", recursive = TRUE)
write.csv(team_data, file = "data/processed/teams_payroll_1985-2016.csv", row.names = FALSE)

message("Data prep complete. Processed file written to data/processed/teams_payroll_1985-2016.csv (if Teams/Salaries contained those years).")
