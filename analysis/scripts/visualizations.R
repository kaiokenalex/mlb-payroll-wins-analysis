# analysis/scripts/visualizations.R

# This script reads the processed data produced by analysis/scripts/data_prep.R
# and creates the figures saved to outputs/figs/.

# Load libraries
library(tidyverse)
library(ggridges)

# Read processed data
processed_path <- "data/processed/teams_payroll_1985-2016.csv"
if (!file.exists(processed_path)) {
  stop(paste0("Processed data not found at ", processed_path, ". Run analysis/scripts/data_prep.R first."))
}

Teams_final <- readr::read_csv(processed_path, show_col_types = FALSE)

# Ensure spending_tier is a factor with expected levels
Teams_final <- Teams_final %>%
  mutate(spending_tier = factor(spending_tier, levels = c("Low", "Mid", "High", "Luxury Tax")))

# Create outputs directory
if (!dir.exists("outputs/figs")) dir.create("outputs/figs", recursive = TRUE)

# 1 - Violin: Winning percentage by spending tier
p1 <- ggplot(data = Teams_final, 
       mapping = aes(x = spending_tier, y = W_perc, fill = spending_tier)) +
  geom_violin(alpha = 0.7) +
  scale_fill_manual(values = c(
    "Low"        = "#7EB8C9",  
    "Mid"        = "#6DBF8A",  
    "High"       = "#E8A838", 
    "Luxury Tax" = "#C0392B"   
  )) +
  theme_linedraw() +
  labs(title = 'Luxury Tax Ranks Highest in Winning Percentage Historically',
       x = 'Spending Tier of MLB Teams',
       y = 'Winning Percentage')

# 2 - Payroll vs Wins scatter with linear fits
p2 <- ggplot(data = Teams_final, aes(x = team_total_payroll, y = W, color = spending_tier, alpha = .5)) + 
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) + 
  labs(title = 'Higher Team Payroll Is Associated With Wins',
       x = 'Total Team Payroll',
       y = 'Wins' ) +
  scale_color_manual(values = c(
    "Low"        = "#7EB8C9", 
    "Mid"        = "#6DBF8A", 
    "High"       = "#E8A838",  
    "Luxury Tax" = "#C0392B"  
  )) +
  theme_linedraw()

# 3 - Payroll by playoff status boxplot
p3 <- ggplot(Teams_final, aes(x = playoff_status,
                        y = team_total_payroll)) +
    geom_boxplot((aes(fill=playoff_status))) + 
  theme_linedraw() + 
  scale_fill_manual(values = c(
    "No"  = "#7EB8C9",  
    "Yes" = "#C0392B"   
  )) + 
  labs(title = "Playoff Teams Spend More",
       x = 'Playoff Status',
       y = 'Team Total Payroll' )

# 4 - Wins vs Attendance scatter
p4 <- ggplot(Teams_final, aes(x = W, y = attendance, color = spending_tier, alpha = .5)) +
  geom_point() +
  theme_linedraw() +
  scale_color_manual(values = c(
    "Low"        = "#7EB8C9", 
    "Mid"        = "#6DBF8A",  
    "High"       = "#E8A838",  
    "Luxury Tax" = "#C0392B"   
  )) +
  geom_smooth(method = "lm", se = FALSE) + 
  labs(title = 'Wins Attract More Fans',
       x = 'Wins',
       y = 'Attendance (Annual)' )

# 5 - Ridgeline density of W by spending tier
p5 <- ggplot(data = Teams_final,
       mapping = aes(x = W, y = spending_tier)) +
  theme_linedraw() +
  geom_density_ridges(aes(fill = spending_tier), alpha = .5) + 
  facet_wrap(. ~ spending_tier)

# Save plots
ggsave("outputs/figs/violin_wperc_spending_tier.png", plot = p1, width = 8, height = 5)
ggsave("outputs/figs/payroll_vs_wins.png", plot = p2, width = 8, height = 5)
ggsave("outputs/figs/payroll_by_playoff.png", plot = p3, width = 8, height = 5)
ggsave("outputs/figs/wins_vs_attendance.png", plot = p4, width = 8, height = 5)
ggsave("outputs/figs/ridgeline_w_by_tier.png", plot = p5, width = 10, height = 6)
