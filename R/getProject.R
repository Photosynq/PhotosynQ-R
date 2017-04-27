#' Get Project data in a Data Frame from PhotosynQ
#'
#' This function allows you to receive data from PhotosynQ and convert it into a  data frame.
#' @param email Your email address you use to login
#' @param projectID The ID of your Project (Just copy the Project ID from the project page or your user page)
#' @param processedData Receive the processed data when set to TRUE, receive raw Data when set to FALSE. (raw data will increases data size significantly!)
#' @param rawTraces Adds raw traces to processed data. It is ignored when processedData is set to TRUE. (increases data size significantly!)
#' @keywords Project Data 
#' @export
#' @examples
#' getProject("john.doe@domain.com",1566,FALSE)

getProject <- function(email="", projectID="", processedData = TRUE, rawTraces = FALSE){
    if(email !="" && projectID != ""){
        login <- PhotosynQ::login(email)

        if(!is.null(login)){
            project_info <- PhotosynQ::getProjectInfo(login$email, login$token, projectID)
            
            if(!is.null(project_info)){
                # Print Project name
                cat(paste("Project:", project_info$name, "\n", sep=" "))

                project_data <- PhotosynQ::getProjectData(login$email, login$token, projectID, processedData, TRUE)
                if(!is.null(project_data)){

                    dl <- createDataframe(project_info,project_data)
                    cat("Done\n")
                    return(dl)
                }
            }
        }
    }
    else {
        cat("You have to supply email, password and project ID\n")
        return(NULL)
    }
}