#' Get Project Data from PhotosynQ
#'
#' This function allows you to receive data from PhotosynQ for a specific project.
#' The revceived data is in the original JSON structure.
#' @param projectID The ID of your Project (Just copy the Project ID from the project page or your user page)
#' @param processedData (optional) Receive the processed data when set to TRUE, receive raw Data when set to FALSE. (raw data will increases data size significantly!)
#' @param rawTraces (optional) Adds raw traces to processed data. It is ignored when processedData is set to TRUE. (increases data size significantly!)
#' @keywords Project Data 
#' @export getProjectData
#' @examples
#' getProjectData(1566)

getProjectData <- function(projectID = "", processedData = TRUE, rawTraces = FALSE){
    if(!is.null(photosynq.env$TOKEN) && photosynq.env$TOKEN != "" && !is.null(photosynq.env$EMAIL) && photosynq.env$EMAIL != ""){
        httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        if(!httrFound){
            install.packages("httr")
            library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        }
        if(projectID != ""){
            url <- paste(photosynq.env$API_DOMAIN,photosynq.env$API_PATH, "projects",toString(projectID),"/data.json", sep="/")
            url <- paste(url,"?user_email=",photosynq.env$EMAIL,"&user_token=",photosynq.env$TOKEN,"&upd=",processedData,"&include_raw_data=",rawTraces, sep="")
            request <- httr::GET(url)
            if(status_code(request) == 500){
                cat("Warning: Failed collect Project data.\n")
                return(NULL)
            }
            content <- content(request)
            if(content$status == "success"){
                return(content$data)
            }
            else if(content$status == "failed"){
                cat(paste(content$notice,"\n", sep=""))
                return(NULL)
            }
            else{
                cat("Warning: There was an error receiving the Project data.\n")
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