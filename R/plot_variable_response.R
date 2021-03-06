#' @title Plot for surv_variable_response object
#'
#' @description Function plot for surv_variable_response object shows the expected output condition on a selected variable.
#'
#' @param x an object of class "surv_variable_response"
#' @param ... optional, additional objects of class "surv_variable_response_explainer"
#' @param split a character, either "model" or "variable"; sets the variable for faceting
#'
#' @import ggplot2
#' @importFrom stats aggregate quantile
#'
#' @examples
#' \donttest{
#' library(survxai)
#' library(rms)
#' data("pbcTest")
#' data("pbcTrain")
#' predict_times <- function(model, data, times){
#'                   prob <- rms::survest(model, data, times = times)$surv
#'                   return(prob)
#'                   }
#' cph_model <- cph(Surv(years, status)~sex + bili + stage, data=pbcTrain, surv=TRUE, x = TRUE, y=TRUE)
#' surve_cph <- explain(model = cph_model, data = pbcTest[,-c(1,5)],
#'              y = Surv(pbcTest$years, pbcTest$status), predict_function = predict_times)
#' svr_cph <- variable_response(surve_cph, "sex")
#' plot(svr_cph)
#' }
#'
#' @method plot surv_variable_response_explainer
#' @export

plot.surv_variable_response_explainer <- function(x, ..., split = "model"){
  y <- color <- NULL

  df <- data.frame(x)
  dfl <- list(...)
  if (length(dfl) > 0) {
    for (resp in dfl) {
      class(resp) <- "data.frame"
      df <- rbind(df, resp)
    }
  }

  if (is.numeric(df$value) & length(unique(df$value))>=4) {
    df$value <- cut(df$value, quantile(df$value, prob = seq(0, 1, length.out = 6)), include.lowest = TRUE)
    df <- aggregate(y~., data = df, mean)
  }

  if (split == "variable") {
    add_facet <- facet_wrap(~value, ncol = 1)
    df$color <- factor(df$label)
    legend <- "model"
  } else {
    add_facet <- facet_wrap(~label, ncol = 1)
    df$color <- factor(df$value)
    legend <- x$var[1]
  }


  ggplot(df, aes(x, y, color = color)) +
    geom_step() +
    labs(title = paste0("Partial Dependency Plot of variable ", df$var[1]),
         x = "time",
         y = "mean survival probability",
         col = legend) +
    add_facet +
    theme_mi2()+
    scale_y_continuous(breaks = seq(0,1,0.1),
                       limits = c(0,1),
                       labels = paste(seq(0,100,10),"%"),
                       name = "survival probability")


}
