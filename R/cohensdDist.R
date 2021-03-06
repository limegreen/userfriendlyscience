dCohensd <- dd <- function(x, df, populationD = 0) {
  ### Return density for given Cohen's d
  return(dt(convert.d.to.t(x, df + 2), df,
            ncp=convert.d.to.t(populationD, df + 2)));
}

pCohensd <- pd <- function(q, df, populationD = 0, lower.tail=TRUE) {
  ### Return p-value for given Cohen's d
  return(pt(convert.d.to.t(q, df + 2), df,
            ncp=convert.d.to.t(populationD, df + 2),
            lower.tail=lower.tail));
}

qCohensd <- qd <- function(p, df, populationD = 0, lower.tail=TRUE) {
  ### Return Cohen's d for given p-value
  return(convert.t.to.d(qt(p, df,
                           ncp=convert.d.to.t(populationD, df + 2),
                           lower.tail=lower.tail), df + 2));
}

rCohensd <- rd <- function(n, df, populationD = 0) {
  ### Return random Cohen's d value(s)
  return(convert.t.to.d(rt(n, df,
                           ncp=convert.d.to.t(populationD, df + 2)),
                        df=df));
}

pdInterval <- function(ds, n, populationD = 0) {
  return(pd(max(ds), n - 2, populationD=populationD) -
           pd(min(ds), n - 2, populationD=populationD));
}

pdExtreme <- function(d, n, populationD = 0) {
  return(2 * pd(d, n - 2, populationD=populationD,
                lower.tail = (d <= populationD)));
}

pdMild <- function(d, n, populationD = 0) {
  return(1 - pdExtreme(d, n, populationD=populationD));
}
