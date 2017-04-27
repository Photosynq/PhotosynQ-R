#' Get Project Data from PhotosynQ
#'
#' This function allows you to receive data from PhotosynQ for a specific project.
#' The revceived data is in the original JSON structure.
#' @param email Your email address you use to login
#' @param token Your login token from the login function
#' @param projectID The ID of your Project (Just copy the Project ID from the project page or your user page)
#' @param processedData Receive the processed data when set to TRUE, receive raw Data when set to FALSE. (raw data will increases data size significantly!)
#' @param rawTraces Adds raw traces to processed data. It is ignored when processedData is set to TRUE. (increases data size significantly!)
#' @keywords Project Data 
#' @export
#' @examples
#' getProjectData("john.doe@domain.com","A67DHsajjshda78",1566, FALSE)

getProjectData <- function(email="", token="", projectID="", processedData = TRUE, rawTraces = FALSE){
    if(email !="" && token != "" && projectID != ""){
        httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        if(!httrFound){
            install.packages("httr")
            library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        }
        url <- paste("https://photosynq.org/api/v3/projects/",toString(projectID),"/data.json?user_email=",email,"&user_token=",token,"&upd=",processedData,"&include_raw_data=",rawTraces, sep="")
        request <- httr::GET(url)
        if(status_code(request) == 500){
            cat("Warning: Failed collect project data.\n")
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
            cat("Warning: There was an error receiving the project data.\n")
            return(NULL)
        }
    }
    else {
        cat("Warning: Project does not exist or is not available.\n")
        return(NULL)
    }
}