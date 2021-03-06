% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_prediction_breakdown.R
\name{plot.surv_prediction_breakdown_explainer}
\alias{plot.surv_prediction_breakdown_explainer}
\title{Plot for surv_breakdown object}
\usage{
\method{plot}{surv_prediction_breakdown_explainer}(
  x,
  ...,
  numerate = TRUE,
  lines = TRUE,
  lines_type = 1,
  lines_col = "black",
  scale_col = c("#010059", "#e0f6fb")
)
}
\arguments{
\item{x}{an object of class "surv_prediction_breakdown_explainer"}

\item{...}{optional, additional objects of class "surv_prediction_breakdown_explainer"}

\item{numerate}{logical; indicating whether we want to number curves}

\item{lines}{logical; indicating whether we want to add lines on chosen time point or probability}

\item{lines_type}{a type of line; see http://sape.inf.usi.ch/quick-reference/ggplot2/linetype}

\item{lines_col}{a color of line}

\item{scale_col}{a vector containig two colors for gradient scale in legend}
}
\description{
Function plot for surv_breakdown object visualise estimated survival curve of mean probabilities in chosen time points.
}
\examples{
\donttest{
library(survxai)
library(rms)
data("pbcTest")
data("pbcTrain")
predict_times <- function(model, data, times){
                  prob <- rms::survest(model, data, times = times)$surv
                  return(prob)
                  }
cph_model <- cph(Surv(years, status)~sex + bili + stage, data=pbcTrain, surv=TRUE, x = TRUE, y=TRUE)
surve_cph <- explain(model = cph_model, data = pbcTest[,-c(1,5)],
                    y = Surv(pbcTest$years, pbcTest$status), predict_function = predict_times)
broken_prediction <- prediction_breakdown(surve_cph, pbcTest[1,-c(1,5)])
plot(broken_prediction)
}
}
