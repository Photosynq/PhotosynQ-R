#' Get Project data in a Data Frame from PhotosynQ
#' 
#' Get Project data using the Project ID and create data frame(s).
#'
#' This function produces a data frame for a PhotosynQ Project using the Project's ID. The ID can be found on the
#' Projects page on the PhotosynQ website. This function call includes the Project data as well as information.
#' In case multiple protocols were used, each protocol is in a separate data frame. By default the 
#' processed data is not included. The parameter rawTraces can be set to TRUE to include the rawTraces in combination with
#' the processed data. By default the traces are not received.
#' When the original data structure is needed, separate calles have to be used including getProjectInfo and getProjectData.
#' Note: Including the raw data will increase the data size significantly.
#' 
#' @param projectID The ID of your Project (Just copy the Project ID from the project page or your user page)
#' @param processedData (optional) Receive the processed data when set to TRUE, receive raw Data when set to FALSE. (raw data will increases data size significantly!)
#' @param rawTraces (optional) Adds raw traces to processed data. It is ignored when processedData is set to TRUE. (increases data size significantly!)
#' 
#' @export getProject
#' 
#' @keywords Project Data 
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