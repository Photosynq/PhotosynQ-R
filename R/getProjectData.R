#' Get Project Data from 'PhotosynQ'
#'
#' Get Project Data using the Project's ID
#'
#' This function receives the data from 'PhotosynQ' for a specific Project. The
#' revceived data is in the original 'JSON' structure. When setting the
#' \code{processedDate} to \code{FALSE} the raw data will be received instead of
#' the processed data. By default the processed data is not included. The
#' parameter \code{rawTraces} can be set to \code{TRUE} to include the
#' \code{rawTraces} in combination with the processed data. By default the
#' traces are not received.
#'
#' @section Note: Including the raw data and/or the traces will increase the
#'   data frame size significantly.
#'
#' @param projectID The ID of your Project (Just copy the Project's ID from the
#'   project page or your user page)
#' @param processedData (optional) Receive the processed data when set to
#'   \code{TRUE}, receive raw Data when set to \code{FALSE}.
#' @param rawTraces (optional) Adds raw traces to processed data. It is ignored
#'   when processedData is set to \code{TRUE}.
#' @return Project data is returned in the 'JSON' format. In case of issues it
#'   will return \code{NULL}.
#'
#' @export getProjectData
#' @import httr
#'
#' @keywords Project Data
#' @examples
#' getProjectData(1566)

getProjectData <- function(projectID = "", processedData = TRUE, rawTraces = FALSE){
    if(!is.null(photosynq.env$TOKEN) && photosynq.env$TOKEN != "" && !is.null(photosynq.env$EMAIL) && photosynq.env$EMAIL != ""){
        # httrFound <- require("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # if(!httrFound){
        #     install.packages("httr")
            # library("httr",quietly = TRUE, warn.conflicts = FALSE, character.only = TRUE)
        # }
        if(projectID != ""){
            url <- paste(photosynq.env$API_DOMAIN,photosynq.env$API_PATH, "projects",toString(projectID),"/data.json", sep="/")
            url <- paste(url,"?user_email=",photosynq.env$EMAIL,"&user_token=",photosynq.env$TOKEN,"&upd=",processedData,"&include_raw_data=",rawTraces, sep="")
            request <- httr::GET(url)
            if(status_code(request) == 500){
                warning("Failed collect Project data")
                return(NULL)
            }
            content <- content(request)
            if(content$status == "success"){
                return(content$data)
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
