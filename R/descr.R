descr <- descriptives <- function(x, digits=4, errorOnFactor = FALSE,
                                  include=c("central tendency", "spread",
                                            "range", "distribution shape", "sample size"),
                                  maxModes = 1,
                                  t=FALSE, conf.level=.95,
                                  quantileType = 2) {
  varName <- deparse(substitute(x));
  if (is.factor(x)) {
    if (errorOnFactor) {
      stop("The first argument (called 'x' in this function, you passed '",
           varName, "') is a factor, and you set 'errorOnFactor'",
           "to TRUE, so here is the error you requested.");
    } else {
      return(freq(x));
    }
  } else if (!is.numeric(x)) {
    stop("The first argument (called 'x' in this function, you passed '",
         varName, "') is not a numeric vector (it has class '",
         class(x), "').");
  } else {
    nrNA <- sum(is.na(x));
    x <- na.omit(x);
    mode <- modus(x);
    if (is.numeric(maxModes)) {
      mode <- ifelse(length(mode) > maxModes, "(multi)", mode);
    }
    meanCi <- formatCI(meanConfInt(x, conf.level=conf.level)$output$ci);
    if (length(mode) > 1) {
      mode <- vecTxt(mode);
    }
    res <- list("central tendency" = data.frame(mean = mean(x),
                                     median = median(x),
                                     mode = mode,
                                     `meanCI` = meanCi),
                spread = data.frame(var = var(x),
                                    sd = sd(x),
                                    iqr = quantile(x, type=quantileType)[4] - quantile(x, type=quantileType)[2],
                                    se = sqrt(var(x)) / sqrt(length(x))),
                range = data.frame(min = min(x),
                                   q1 = median(x[x < median(x)]),
                                   q3 = median(x[x > median(x)]),
                                   max = max(x)),
                "distribution shape" = data.frame(skewness = dataShape(x)$output$skewness,
                                   kurtosis = dataShape(x)$output$kurtosis,
                                   dip = dip.test(x)$statistic[[1]]),
                "sample size" = data.frame(total = length(x) + nrNA,
                                  "NA" = nrNA,
                                  valid = length(x)));
    names(res[['central tendency']])[4] <- paste0(conf.level * 100, '% CI mean');
    row.names(res$spread) <- NULL;
    attr(res, "varName") <- varName;
    attr(res, "digits") <- digits;
    attr(res, "include") <- include;
    attr(res, "transpose") <- t;
    class(res) <- "descr";
    return(res);
  }
}

print.descr <- function(x, digits = attr(x, 'digits'),
                        t = attr(x, 'transpose'),
                        row.names = FALSE, ...) {
  cat("###### Descriptives for", attr(x, "varName"), "\n\n");
  for (current in attr(x, "include")) {
    cat0("Describing the ", current, ":\n");
    if (t) {
      df <- t(x[[current]]);
      colnames(df) <- '';
      print(df, digits=digits, row.names=row.names, ...);
    } else {
      print(x[[current]], digits=digits, row.names=row.names, ...);
    }
    cat("\n");
  }
  if ('shape' %in% names(x)) {
    cat("(You can use the functions 'dataShape' and",
        "'normalityAssessment' to explore the distribution shape",
        "more in depth.)");
  }
  invisible();
}

### Function to smoothly pander descriptives from userfriendlyscience
pander.descr <- function(x, headerPrefix = "",
                         headerStyle = "**", ...) {
  #pander(cat0(unlist(lapply(x, pander, ...)), sep="\n"));
  pander(cat0(unlist(lapply(1:length(x), function(index) {
    cat0("\n\n", headerPrefix, headerStyle,
         "Describing the ", names(x)[index], ":",
         headerStyle, "\n\n");
    pander(x[[index]]);
  }, ...)), sep="\n"));
}
