# TechnicalAnalysis

Course: BDA400 - Data Science Tools and Techniques
Assignment 2 - Technical Analysis using R, Preliminary Stage (5%)

This repository holds all assignments for the course, one folder per
assignment.

## Assignment 2

Folder: `Assignment2/`

| File | Purpose |
| --- | --- |
| `portfolio.txt` | Stock symbols for the portfolio, one per line (AAPL, MSFT, NVDA, AMZN, GOOGL, TSLA). |
| `load_stock_data.R` | `load_stock_data()` - reads `portfolio.txt` and imports each symbol's data with quantmod. |
| `calculate_statistics.R` | `calculate_statistics()` and `get_mode()` - moving average (20-day and 50-day), mean, mode, median and standard deviation. |
| `display_output.R` | `display_stock_data()`, `display_statistics()`, `display_all()` and `plot_stock_with_ma()` - display functions and price charts. |
| `run_analysis.R` | Driver script that runs the whole analysis end to end. |
| `output/` | Charts produced by the analysis (one PNG per stock) and the console output log. |

## How to run

1. Install R and RStudio, then install the packages:
   `install.packages(c("quantmod", "TTR", "ggplot2"))`
2. Set the working directory to the `Assignment2` folder.
3. Run: `Rscript run_analysis.R`

The script downloads one year of daily data per symbol from Yahoo
Finance, prints the imported data and the calculated statistics for
each stock, and saves a closing-price chart with 20-day and 50-day
moving averages for each stock in `output/`.
