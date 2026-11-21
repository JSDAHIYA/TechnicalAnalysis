# ------------------------------------------------------------------
# BDA400 - Data Science Tools and Techniques
# Assignment 2 - Technical Analysis using R (Preliminary Stage)
# File: run_analysis.R
# Purpose: Driver script. It loads the portfolio, imports the stock
#          data, calculates the statistics, displays everything and
#          saves one price chart per stock.
#
# How to run: set the working directory to the Assignment2 folder,
#             then run:  source("run_analysis.R")
#          or from a terminal:  Rscript run_analysis.R
# ------------------------------------------------------------------

# Load the utility functions
source("load_stock_data.R")
source("calculate_statistics.R")
source("display_output.R")

# 1. Import the stock data listed in portfolio.txt
stocks <- load_stock_data("portfolio.txt")

# 2. Calculate the statistics for every stock
all_stats <- calculate_all_statistics(stocks)

# 3. Display the imported data and the statistics
display_all(stocks, all_stats)

# 4. Save one closing-price chart per stock (with 20-day and
#    50-day moving averages) into the output folder
plot_all_stocks(stocks, output_dir = "output")

cat("\nAnalysis complete. Charts saved in the output folder.\n")
