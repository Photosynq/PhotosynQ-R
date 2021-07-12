#' Logout from 'PhotosynQ'
#'
#' Logout from 'PhotosynQ' and end session
#'
#' This function ends the current session and logs out the current user out from
#' 'PhotosynQ'. Use the login function to sign in again and start a new session
#' if needed.
#'
#' @return Session data is removed from the global variables. Nothing is
#'   returned
#'
#' @export logout
#' @import httr
#'
#' @keywords logout
#' @examples
#' logout()

logout <- function(){
    if(!is.null(photosynq.env$TOKEN) && photosynq.env$TOKEN != ""){
        # httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # if(!httrFound){
            # install.packages("httr")
            # library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # }
        url <- paste(photosynq.env$API_DOMAIN,photosynq.env$API_PATH, "sign_out.json", sep="/")
        request <- httr::DELETE(url, body= list("auth_token" = photosynq.env$TOKEN))
        assign( "EMAIL", NULL, envir = photosynq.env )
        assign( "TOKEN", NULL, envir = photosynq.env )
        assign( "API_DOMAIN", photosynq.env$DEFAULT_API_DOMAIN, envir = photosynq.env )
        message("Signed out")
    }
    else {
        assign( "EMAIL", NULL, envir = photosynq.env )
        assign( "TOKEN", NULL, envir = photosynq.env )
        assign( "API_DOMAIN", photosynq.env$DEFAULT_API_DOMAIN, envir = photosynq.env )
        warning("It seems you are already signed out")
    }
}
