#' Get Project Information from PhotosynQ
#'
#' This function allows you to sign in to PhotosynQ and receive your authentication token.
#' @param email Your email address you use to login
#' @param token Your password you use to sign in
#' @param projectURL The URL of your Project (Just copy the Project page URL from your browser)
#' @keywords Project Information 
#' @export
#' @examples
#' getProjectInfo("john.doe@domain.com","A67DHsajjshda78","https://photosynq.org/projects/getting-started-with-multispeq")

getProjectInfo <- function(email="", token="", projectURL=""){
    if(email !="" && token != "" && projectURL != ""){
        httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        if(!httrFound){
            install.packages("httr")
            library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        }
        projectURL <- strsplit(projectURL, "\\?")[[1]][1]
        slug <- tail( strsplit(projectURL,"/")[[1]], n=1 )
        url <- paste("https://photosynq.org/api/v3/projects/",toString(slug),".json?user_email=",email,"&user_token=",token, sep="")
        request <- httr::GET(url)
        if(status_code(request) == 500){
            print("Warning: Failed to get project info.")
            return(NULL)
        }
        content <- content(request)
        if(content$status == "success")
            return(content$project)
        else{
            print("Warning: There was an error receiving the project data")
            return(NULL)
        }
    }
    else {
        print("Warning: Project does not exist or is not available.")
        return(NULL)
    }
}