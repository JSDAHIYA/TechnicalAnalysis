# ------------------------------------------------------------------
# BDA400 - Data Science Tools and Techniques
# Assignment 2 - Technical Analysis using R (Preliminary Stage)
# File: calculate_statistics.R
# Purpose: Compute basic statistics on a stock's price data -
#          moving average, mean, mode, median and standard
#          deviation - using base R and the TTR package.
# ------------------------------------------------------------------

library(TTR)

#' Mode of a numeric vector (the most frequently occurring value).
#' Base R has no built-in mode function, so it is defined here.
#' For continuous prices the values are first rounded to 2 decimals.
#'
#' @param x A numeric vector.
#' @return The mode (single most frequent value).
get_mode <- function(x) {
  x <- round(x, 2)
  freq <- table(x)
  as.numeric(names(freq)[which.max(freq)])
}

#' Calculate basic statistics for one stock
#'
#' @param stock_xts An xts object of OHLCV data for one stock, as
#'   returned by load_stock_data() (for example result$AAPL).
#' @param ma_short Short moving-average window in days (default 20).
#' @param ma_long Long moving-average window in days (default 50).
#' @return A data frame with one row per statistic, with columns
#'   Statistic and Value.
calculate_statistics <- function(stock_xts,
                                 ma_short = 20,
                                 ma_long = 50) {
  # Use the adjusted closing price when available, else the close
  close_prices <- as.numeric(Cl(stock_xts))

  # Moving averages (simple moving average from TTR)
  sma_short <- SMA(close_prices, n = ma_short)
  sma_long  <- SMA(close_prices, n = ma_long)

  stats <- data.frame(
    Statistic = c(
      paste0("Moving Average (", ma_short, "-day)"),
      paste0("Moving Average (", ma_long, "-day)"),
      "Mean Closing Price",
      "Mode Closing Price",
      "Median Closing Price",
      "Standard Deviation (Closing Price)",
      "Minimum Closing Price",
      "Maximum Closing Price",
      "Number of Trading Days"
    ),
    Value = c(
      round(tail(na.omit(sma_short), 1), 2),
      round(tail(na.omit(sma_long), 1), 2),
      round(mean(close_prices, na.rm = TRUE), 2),
      round(get_mode(close_prices), 2),
      round(median(close_prices, na.rm = TRUE), 2),
      round(sd(close_prices, na.rm = TRUE), 2),
      round(min(close_prices, na.rm = TRUE), 2),
      round(max(close_prices, na.rm = TRUE), 2),
      length(close_prices)
    ),
    stringsAsFactors = FALSE
  )

  return(stats)
}

#' Calculate statistics for every stock in a list
#'
#' @param stock_list Named list of xts objects from load_stock_data().
#' @return A named list of per-stock statistics data frames.
calculate_all_statistics <- function(stock_list,
                                     ma_short = 20,
                                     ma_long = 50) {
  lapply(stock_list, calculate_statistics,
         ma_short = ma_short, ma_long = ma_long)
}
