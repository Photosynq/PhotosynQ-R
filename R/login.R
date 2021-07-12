#' Login to 'PhotosynQ'
#'
#' Login to 'PhotosynQ' to allow data access.
#'
#' This function allows a user to login to 'PhotosynQ' and start a session. The
#' functions \code{\link{getProjectInfo}}, \code{\link{getProjectData}},
#' \code{\link{getProject}} and \code{\link{logout}} require a session started
#' by login in. A login is only required once at the beginning of a session.
#'
#' @section Note: The password needs to be entered in a dialog and gets never
#'   saved nor should it be saved anywhere in the code.
#'
#' @param email Your email address you use to login
#' @param url (optional) Change the default URL to point to another instance
#' @return Session key is received and session data is stored as a global
#'   variable. Otherwise nothing is returned.
#'
#' @export login
#' @import httr getPass
#'
#' @keywords login
#' @examples
#' \dontrun{
#' login("john.doe@domain.com")
#' }

login <- function(email = "", url = photosynq.env$DEFAULT_API_DOMAIN){
    if(email !=""){
        # httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # if(!httrFound){
            # install.packages("httr")
            # library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # }
        # getPassFound <- require("getPass",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # if(!getPassFound){
            # install.packages("getPass")
            # library("getPass",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # }
        pwd <- getPass(msg = "Your PhotosynQ Password: ", forcemask = FALSE)
        if(is.null(pwd)){
            warning("Login canceled")
        }
        if(url != photosynq.env$DEFAULT_API_DOMAIN){
            assign( "API_DOMAIN", url, envir = photosynq.env )
        }
        else{
            assign( "API_DOMAIN", photosynq.env$DEFAULT_API_DOMAIN, envir = photosynq.env )
        }
        url <- paste(url,photosynq.env$API_PATH, "sign_in.json", sep="/")
        request <- httr::POST(url, body= list("user[email]" = email,"user[password]" = pwd))
        if(status_code(request) == 500){
            warning("Failed to login")
        }
        else{
            content <- content(request)
            if(length(content) == 0){
                warning("Failed to login")
            }
            else{
                if(content$status == "success"){
                    message("Successfully signed in as: ", content$user$name,"\n", sep=" ")
                    result <- list(email=content$user$email,token=content$user$auth_token,name=content$user$name)
                    assign( "EMAIL", content$user$email, envir = photosynq.env )
                    assign( "TOKEN", content$user$auth_token, envir = photosynq.env )
                }
                else if(content$status == "failed"){
                    warning(paste(content$notice,"\n", sep=""))
                }
            }
        }
    }
    else {
        warning("Please provide your email to login")
    }
}
