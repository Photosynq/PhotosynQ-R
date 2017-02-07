#' Get Project Information from PhotosynQ
#'
#' This function allows you to receive the information about a project from PhotosynQ.
#' @param email Your email address you use to login
#' @param token Your login token from the login function
#' @param projectID The ID of your Project (Just copy the Project ID from the project page or your user page)
#' @keywords Project Information 
#' @export
#' @examples
#' getProjectInfo("john.doe@domain.com","A67DHsajjshda78",1566)

getProjectInfo <- function(email="", token="", projectID=""){
    if(email !="" && token != "" && projectID != ""){
        httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        if(!httrFound){
            install.packages("httr")
            library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        }
        url <- paste("https://photosynq.org/api/v3/projects/",toString(projectID),".json?user_email=",email,"&user_token=",token, sep="")
        request <- httr::GET(url)
        if(status_code(request) == 500){
            print("Warning: Failed to get project info.")
            return(NULL)
        }
        content <- content(request)
        if(content$status == "success"){
            return(content$project)
        }
        else if(content$status == "failed"){
            print(content$notice)
            return(NULL)
        }
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