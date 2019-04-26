#' Get Project data in a Data Frame from PhotosynQ
#'
#' This function allows you to receive data from PhotosynQ and convert it into a  data frame.
#' @param projectID The ID of your Project (Just copy the Project ID from the project page or your user page)
#' @param processedData (optional) Receive the processed data when set to TRUE, receive raw Data when set to FALSE. (raw data will increases data size significantly!)
#' @param rawTraces (optional) Adds raw traces to processed data. It is ignored when processedData is set to TRUE. (increases data size significantly!)
#' @keywords Project Data 
#' @export getProject
#' @examples
#' getProject(1566)

getProject <- function(projectID = "", processedData = TRUE, rawTraces = FALSE){
    if(projectID != ""){
        project_info <- PhotosynQ::getProjectInfo(projectID)
        
        if(!is.null(project_info)){
            # Print Project name
            cat(paste("Project:", project_info$name, "\n", sep=" "))

            project_data <- PhotosynQ::getProjectData(projectID, processedData, TRUE)
            if(!is.null(project_data)){

                dl <- createDataframe(project_info,project_data)
                cat("Done\n")
                return(dl)
            }
        }
    }
    else{
        cat("Warning: You have to provide a Project ID!\n")
    }
}