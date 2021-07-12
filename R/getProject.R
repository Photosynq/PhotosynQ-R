#' Get Project data in a Data Frame from 'PhotosynQ'
#'
#' Get Project data using the Project's ID and create data frame(s).
#'
#' This function produces a data frame for a 'PhotosynQ' Project using the
#' Project's ID. The ID can be found on the Project's page on the 'PhotosynQ'
#' website. This function call includes the Project data as well as information.
#' In case multiple protocols were used, each protocol is in a separate data
#' frame. By default the processed data is not included. The parameter
#' \code{rawTraces} can be set to \code{TRUE} to include the \code{rawTraces} in
#' combination with the processed data. By default the recorded traces are not
#' received. When the original data structure is needed, separate calls have to
#' be used including \code{\link{getProjectInfo}} and
#' \code{\link{getProjectData}}.
#'
#' @section Note: Including the raw data and/or the traces will increase the
#'   data frame size significantly.
#'
#' @param projectID The ID of your Project (Just copy the Project ID from the
#'   project page or your user page)
#' @param processedData (optional) Receive the processed data when set to
#'   \code{TRUE}, receive raw Data when set to \code{FALSE}.
#' @param rawTraces (optional) Adds raw traces to processed data. It is ignored
#'   when processedData is set to \code{TRUE}.
#' @return Separate data frame per protocol including measurement data and
#'   answers to Project.
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
            message(paste("Project:", project_info$name, "\n", sep=" "))

            project_data <- PhotosynQ::getProjectData(projectID, processedData, TRUE)
            if(!is.null(project_data)){

                dl <- createDataframe(project_info,project_data)
                message("Done")
                return(dl)
            }
        }
    }
    else{
        warning("You have to provide a Project ID")
    }
}
