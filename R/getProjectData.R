#' Get Project Data from PhotosynQ
#'
#' This function allows you to receive data from PhotosynQ for a specific project.
#' The revceived data is in the original JSON structure.
#' @param email Your email address you use to login
#' @param token Your login token from the login function
#' @param projectID The ID of your Project (Just copy the Project ID from the project page or your user page)
#' @param rawTraces Include the raw traces for each measurement (increases data size significantly!)
#' @keywords Project Data 
#' @export
#' @examples
#' getProjectData("john.doe@domain.com","A67DHsajjshda78",1566, FALSE)

getProjectData <- function(email="", token="", projectID="", rawTraces = FALSE){
    if(email !="" && token != "" && projectID != ""){
        httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        if(!httrFound){
            install.packages("httr")
            library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        }
        url <- paste("https://photosynq.org/api/v3/projects/",toString(projectID),"/data.json?user_email=",email,"&user_token=",token,"&upd=true&include_raw_data=",rawTraces, sep="")
        request <- httr::GET(url)
        if(status_code(request) == 500){
            print("Warning: Failed collect project data.")
            return(NULL)
        }
        content <- content(request)
        if(content$status == "success"){
            return(content$data)
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