#' Login to PhotosynQ
#'
#' This function allows you to login to PhotosynQ and start your session.
#' The functions getProjectInfo(), getProjectData(), getProject() and logout()
#' require a session started by login in.
#' Login is only required once at the beginning of a session.
#' @param email Your email address you use to login
#' @param url (optional) Change the default URL to point to another instance
#' @keywords login
#' @export login
#' @examples
#' login("john.doe@domain.com")

login <- function(email = "", url = photosynq.env$DEFAULT_API_DOMAIN){
    if(email !=""){
        httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        if(!httrFound){
            install.packages("httr")
            library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        }
        getPassFound <- require("getPass",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        if(!getPassFound){
            install.packages("getPass")
            library("getPass",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        }
        pwd <- getPass(msg = "Your PhotosynQ Password: ", forcemask = FALSE)
        if(is.null(pwd)){
            cat("Info: Login canceled.\n")
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
            cat("Warning: Failed to login.\n")
        }
        else{
            content <- content(request)
            if(length(content) == 0){
                cat("Warning: Failed to login.\n")
            }
            else{
                if(content$status == "success"){
                    cat("Successfully signed in as: ", content$user$name,"\n", sep=" ")
                    result <- list(email=content$user$email,token=content$user$auth_token,name=content$user$name)
                    assign( "EMAIL", content$user$email, envir = photosynq.env )
                    assign( "TOKEN", content$user$auth_token, envir = photosynq.env )
                }
                else if(content$status == "failed"){
                    cat(paste(content$notice,"\n", sep=""))
                }
            }
        }
    }
    else {
        cat("Warning: Please provide your email to login.\n")
    }
}