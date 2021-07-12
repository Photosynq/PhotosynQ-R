#' Get Project Information from 'PhotosynQ'
#'
#' Get Project Information using the Project's ID
#'
#' This function receives the information about a project from 'PhotosynQ'
#' including used Protocols and Project Questions. The information is also
#' required to process the Project's data for the data frame used in the
#' \code{\link{createDataframe}} function.
#'
#' @param projectID The ID of your Project (Just copy the Project ID from the
#'   project page or your user page)
#' @return Project information is returned in the 'JSON' format. In case of
#'   issues it will return \code{NULL}.
#'
#' @export getProjectInfo
#' @import httr
#'
#' @keywords Project Information
#' @examples
#' getProjectInfo(1566)

getProjectInfo <- function(projectID = ""){
    if(!is.null(photosynq.env$TOKEN) && photosynq.env$TOKEN != "" && !is.null(photosynq.env$EMAIL) && photosynq.env$EMAIL != ""){
        # httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # if(!httrFound){
        #     install.packages("httr")
            # library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # }
        if(projectID != ""){
            url <- paste(photosynq.env$API_DOMAIN,photosynq.env$API_PATH, "projects", toString(projectID), sep="/")
            url <- paste(url,".json?user_email=",photosynq.env$EMAIL,"&user_token=",photosynq.env$TOKEN, "&include_deleted=true", sep="")
            request <- httr::GET(url)
            if(status_code(request) == 500){
                warning("Failed to receive the Project information")
                return(NULL)
            }
            content <- content(request)
            if(content$status == "success"){
                return(content$project)
            }
            else if(content$status == "failed"){
                warning(paste(content$notice,"\n", sep=""))
                return(NULL)
            }
            else{
                warning("There was an error receiving the Project data")
                return(NULL)
            }
        }
        else{
            warning("You have to provide a Project ID")
            return(NULL)
        }
    }
    else {
        warning("You have to sign in first")
        return(NULL)
    }
}
