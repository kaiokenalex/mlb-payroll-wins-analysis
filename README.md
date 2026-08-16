# MLB Team Payroll & Winning History

A comparative analysis of how MLB team payroll relates to wins, playoff appearances, and fan attendance — and whether the league's soft salary cap actually promotes competitive balance.

## Motivation

Recent World Series winners have disproportionately come from high-payroll teams (Dodgers, Yankees). Unlike the NFL's hard salary cap, MLB uses a "soft" luxury tax that large-market teams can simply pay as a cost of doing business. This project investigates whether payroll actually predicts winning, and builds a data-driven case for stricter salary cap enforcement.

## Data

- **Source:** [`Lahman`](https://cran.r-project.org/package=Lahman) R package (`Teams` and `Salaries` datasets)
- **Time frame:** 1985–2016 (bounded by salary data availability), 30 modern MLB teams
- **Final dataset:** 918 team-seasons × 12 variables after cleaning and joins

## Methods

- Joined team performance data (`Teams`) with aggregated payroll data (`Salaries`) by year and team
- Engineered variables:
  - `W_perc` — win percentage (handles season-length variation)
  - `spending_tier` — categorical bucket (Low / Mid / High / Luxury Tax) based on total payroll
  - `playoff_status` — binary flag from division/wild card wins
- Collapsed sparse factor levels (8 leagues → AL/NL/Other) for cleaner modeling

**Tools:** R, `tidyverse`, `ggplot2`, `ggridges`, `skimr`

## Key Findings

| Question | Finding |
|---|---|
| Does spending predict wins? | Yes — positive relationship across all spending tiers, strongest in the Mid tier |
| Do playoff teams spend more? | Yes — higher median payroll, though several high-spending teams still miss the playoffs |
| Does winning drive attendance? | Yes, with a "spending multiplier" — at equal win totals, high-payroll teams still draw more fans |
| Is the relationship equal at every spending level? | No — throwing money at mid-tier payrolls doesn't guarantee proportional gains, suggesting scouting/allocation matters as much as raw spend |

## Visualizations

Five `ggplot2` visualizations included: win % distribution by spending tier (violin plot), payroll vs. wins with tier-level trend lines, payroll by playoff status (boxplot), wins vs. attendance by tier, and a faceted win-distribution density plot.

## Limitations

- Spending tier breakpoints don't account for payroll inflation over the 30-year window (a $20M payroll meant something very different in 1989 vs. 2016)
- Analysis is descriptive/correlational, not causal

## Files

- `mlb_payroll_analysis.Rmd` — full analysis with code, visualizations, and write-up
- Rendered HTML/PDF output

---
*Author: Alexis Ortiz — Econ 106 Final Project*
