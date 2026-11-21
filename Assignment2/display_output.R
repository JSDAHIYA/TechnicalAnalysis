# ------------------------------------------------------------------
# BDA400 - Data Science Tools and Techniques
# Assignment 2 - Technical Analysis using R (Preliminary Stage)
# File: display_output.R
# Purpose: Display the imported stock data and the calculated
#          statistics, and draw price charts with moving averages.
# ------------------------------------------------------------------

library(quantmod)
library(ggplot2)

#' Show the first rows, last rows and structure of one stock's data
#'
#' @param stock_xts An xts object of OHLCV data for one stock.
#' @param symbol The stock symbol (used in the headings).
#' @param n Number of rows to show at the head and tail (default 6).
display_stock_data <- function(stock_xts, symbol, n = 6) {
  cat("\n============================================================\n")
  cat(" ", symbol, " - Imported Stock Data\n")
  cat("============================================================\n")
  cat("Rows:", nrow(stock_xts),
      " Columns:", paste(colnames(stock_xts), collapse = ", "), "\n")
  cat("Date range:", format(index(stock_xts)[1]), "to",
      format(index(stock_xts)[nrow(stock_xts)]), "\n\n")

  cat("--- First", n, "rows ---\n")
  print(head(stock_xts, n))
  cat("\n--- Last", n, "rows ---\n")
  print(tail(stock_xts, n))
  cat("\n--- Structure ---\n")
  str(stock_xts)
}

#' Print the statistics table for one stock
#'
#' @param stats_df A statistics data frame from calculate_statistics().
#' @param symbol The stock symbol (used in the heading).
display_statistics <- function(stats_df, symbol) {
  cat("\n------------------------------------------------------------\n")
  cat(" ", symbol, " - Calculated Statistics\n")
  cat("------------------------------------------------------------\n")
  print(stats_df, row.names = FALSE)
}

#' Display data and statistics for every stock in a list
#'
#' @param stock_list Named list of xts objects from load_stock_data().
#' @param stats_list Named list of statistics data frames.
display_all <- function(stock_list, stats_list) {
  for (symbol in names(stock_list)) {
    display_stock_data(stock_list[[symbol]], symbol)
    display_statistics(stats_list[[symbol]], symbol)
  }
}

#' Draw a closing-price chart with 20-day and 50-day moving
#' averages and save it as a PNG file.
#'
#' @param stock_xts An xts object of OHLCV data for one stock.
#' @param symbol The stock symbol (used in the title and file name).
#' @param output_dir Folder to save the chart in (default "output").
#' @return The path of the saved PNG file (invisibly).
plot_stock_with_ma <- function(stock_xts, symbol,
                               output_dir = "output") {
  close_prices <- Cl(stock_xts)
  df <- data.frame(
    Date = index(close_prices),
    Close = as.numeric(close_prices),
    MA20 = as.numeric(SMA(close_prices, n = 20)),
    MA50 = as.numeric(SMA(close_prices, n = 50))
  )

  p <- ggplot(df, aes(x = Date)) +
    geom_line(aes(y = Close, colour = "Close"), linewidth = 0.8) +
    geom_line(aes(y = MA20, colour = "MA 20-day"), linewidth = 0.8) +
    geom_line(aes(y = MA50, colour = "MA 50-day"), linewidth = 0.8) +
    labs(title = paste(symbol, "- Closing Price with Moving Averages"),
         x = "Date", y = "Price (USD)", colour = "Series") +
    theme_minimal()

  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
  file_path <- file.path(output_dir, paste0(symbol, "_chart.png"))
  ggsave(file_path, plot = p, width = 10, height = 6, dpi = 150)
  message("Chart saved: ", file_path)
  invisible(file_path)
}

#' Draw and save a chart for every stock in a list
#'
#' @param stock_list Named list of xts objects from load_stock_data().
#' @param output_dir Folder to save the charts in (default "output").
plot_all_stocks <- function(stock_list, output_dir = "output") {
  for (symbol in names(stock_list)) {
    plot_stock_with_ma(stock_list[[symbol]], symbol, output_dir)
  }
}
