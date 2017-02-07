#' Login to PhotosynQ
#'
#' This function allows you to login to PhotosynQ and receive your authentication token.
#' The functions getProjectInfo(), getProjectData() and logout() require the token to
#' receive data from PhotosynQ
#' @param email Your email address you use to login
#' @keywords login
#' @export
#' @examples
#' login("john.doe@domain.com")

login <- function(email=""){
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
            print("Info: Login canceled.")
            return(NULL) 
        }
        url <- "https://photosynq.org/api/v3/sign_in.json"
        request <- httr::POST(url, body= list("user[email]" = email,"user[password]" = pwd))
        if(status_code(request) == 500){
            print("Warning: Failed to login.")
            return(NULL)
        }
        content <- content(request)
        if(content$status == "success"){
            paste("Hello", content$user$name, sep=" ")
            result <- list(email=content$user$email,token=content$user$auth_token,name=content$user$name)
            return(result)
        }
        else if(content$status == "failed"){
            print(content$notice)
            return(NULL)
        }
    }
    else {
        print("Warning: Please provide your email to login.")
        return(NULL)
    }
}