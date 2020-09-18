#' Get Project Information from PhotosynQ
#'
#' This function allows you to receive the information about a project from PhotosynQ.
#' @param projectID The ID of your Project (Just copy the Project ID from the project page or your user page)
#' @keywords Project Information 
#' @export getProjectInfo
#' @examples
#' getProjectInfo(1566)

getProjectInfo <- function(projectID = ""){
    if(!is.null(photosynq.env$TOKEN) && photosynq.env$TOKEN != "" && !is.null(photosynq.env$EMAIL) && photosynq.env$EMAIL != ""){
        httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        if(!httrFound){
            install.packages("httr")
            library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        }
        if(projectID != ""){
            url <- paste(photosynq.env$API_DOMAIN,photosynq.env$API_PATH, "projects", toString(projectID), sep="/")
            url <- paste(url,".json?user_email=",photosynq.env$EMAIL,"&user_token=",photosynq.env$TOKEN, "&include_deleted=true", sep="")
            request <- httr::GET(url)
            if(status_code(request) == 500){
                cat("Warning: Failed to receive the project information.\n")
                return(NULL)
            }
            content <- content(request)
            if(content$status == "success"){
                return(content$project)
            }
            else if(content$status == "failed"){
                cat(paste(content$notice,"\n", sep=""))
                return(NULL)
            }
            else{
                cat("Warning: There was an error receiving the Project data\n")
                return(NULL)
            }
        }
        else{
            cat("Warning: You have to provide a Project ID!\n")
            return(NULL)
        }
    }
    else {
        cat("Warning: You have to sign in first!\n")
        return(NULL)
    }
}