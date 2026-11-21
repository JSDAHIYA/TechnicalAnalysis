# ------------------------------------------------------------------
# BDA400 - Data Science Tools and Techniques
# Assignment 2 - Technical Analysis using R (Preliminary Stage)
# File: load_stock_data.R
# Purpose: Read stock symbols from portfolio.txt and import their
#          historical price data with the quantmod package.
# ------------------------------------------------------------------

library(quantmod)

#' Load stock data for every symbol listed in portfolio.txt
#'
#' @param portfolio_file Path to the text file with one stock symbol
#'   per line (default "portfolio.txt").
#' @param from Start date for the historical data (default one year
#'   of data up to today).
#' @param to End date for the historical data (default today).
#' @return A named list. Each element is one stock's data as an xts
#'   object, named after its symbol (for example result$AAPL).
#'   Symbols that fail to download are skipped with a warning.
load_stock_data <- function(portfolio_file = "portfolio.txt",
                            from = Sys.Date() - 365,
                            to = Sys.Date()) {
  # Read the symbols, one per line, and drop blank lines
  symbols <- readLines(portfolio_file, warn = FALSE)
  symbols <- trimws(symbols)
  symbols <- symbols[symbols != ""]
  symbols <- toupper(symbols)

  message("Loading data for ", length(symbols), " symbol(s): ",
          paste(symbols, collapse = ", "))

  stock_data <- list()

  for (symbol in symbols) {
    message("Downloading ", symbol, " ...")
    data <- tryCatch(
      {
        getSymbols(symbol,
                   src = "yahoo",
                   from = from,
                   to = to,
                   auto.assign = FALSE)
      },
      error = function(e) {
        warning("Could not download ", symbol, ": ",
                conditionMessage(e))
        NULL
      }
    )

    if (!is.null(data)) {
      stock_data[[symbol]] <- data
      message(symbol, ": ", nrow(data), " trading days loaded (",
              format(index(data)[1]), " to ",
              format(index(data)[nrow(data)]), ")")
    }
  }

  return(stock_data)
}
