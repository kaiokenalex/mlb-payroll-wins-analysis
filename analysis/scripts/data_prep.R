# analysis/scripts/data_prep.R

# Setup ------------------------------------------------------------------------
# This script performs data cleaning and creates Teams_final used for analysis.
# It also produces a processed CSV at data/processed/teams_payroll_1985-2016.csv

# Load libraries
library(tidyverse)
library(skimr)
library(Lahman)

# Load Lahman data ------------------------------------------------------------
data("Teams", package = "Lahman")
data("Salaries", package = "Lahman")

# Quantitative variables ------------------------------------------------------
Teams1 <- Teams %>%
  mutate(W = as.numeric(W)) %>%
  mutate(W_perc = as.numeric(W/(W + L)))

team_payroll <- Salaries %>%
  group_by(yearID, teamID) %>%
  summarize(team_total_payroll = sum(salary, na.rm = TRUE), .groups = "drop") %>%
  mutate(team_total_payroll = as.numeric(team_total_payroll))

# Categorical variables -------------------------------------------------------
Teams1 <- Teams1 %>%
  mutate(lgID = as.factor(lgID)) %>%
  mutate(lgID = fct_collapse(lgID,
                             "AL" = "AL",
                             "NL" = "NL",
                             "Other" = c("AA", "FL", "NA", "PL", "UA"))) %>%
  mutate(divID = as.factor(divID))

team_payroll <- team_payroll %>%
  mutate(spending_tier = cut(team_total_payroll,
                             breaks = c(0, 20000000, 60000000, 120000000, Inf),
                             labels = c("Low", "Mid", "High", "Luxury Tax")))

Teams1$playoff_status <- "No"
Teams1$playoff_status[Teams1$DivWin == "Y"] <- "Yes"
Teams1$playoff_status[Teams1$WCWin == "Y"] <- "Yes"
Teams1$playoff_status <- as.factor(Teams1$playoff_status)

Teams1 <- Teams1 %>%
  mutate(LgWin = as.factor(LgWin),
         WSWin = as.factor(WSWin))

# final dataset ---------------------------------------------------------------
Teams_final <- Teams1 %>%
  left_join(
    team_payroll %>%
      select(yearID, teamID, team_total_payroll, spending_tier),
    by = c("yearID", "teamID")
  ) %>%
  select(yearID, teamID,
         W,
         W_perc,
         team_total_payroll,
         attendance,
         lgID,
         divID,
         spending_tier,
         playoff_status,
         LgWin,
         WSWin) %>%
  filter(yearID >= 1985 & yearID <= 2016) %>%
  mutate(teamID = fct_lump(teamID, n = 35))

# save processed data
if (!dir.exists("data/processed")) dir.create("data/processed", recursive = TRUE)
readr::write_csv(Teams_final, "data/processed/teams_payroll_1985-2016.csv")

# quick summary
skim(Teams_final)
