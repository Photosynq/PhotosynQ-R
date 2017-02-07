#' Logout from PhotosynQ
#'
#' This function allows you to logout from PhotosynQ after you finished with your session.
#' @param token Your token from the initial login.
#' @keywords logout
#' @export
#' @examples
#' logout("A67DHsajjshda78")

logout <- function(token=""){
    if(token != ""){
        httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        if(!httrFound){
            install.packages("httr")
            library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        }
        url <- "https://photosynq.org/api/v3/sign_out.json"
        request <- httr::DELETE(url, body= list("auth_token" = token))
        print("Goodbye!")
    }
    else {
        print("Warning: You have to provide your login token.")
    }
}