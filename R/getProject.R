#' Get Project data in a Data Frame from PhotosynQ
#'
#' This function allows you to receive data from PhotosynQ and convert it into a  data frame.
#' @param email Your email address you use to login
#' @param projectID The ID of your Project (Just copy the Project ID from the project page or your user page)
#' @param rawTraces Include the raw traces for each measurement (increases data size significantly!)
#' @keywords Project Data 
#' @export
#' @examples
#' getProject("john.doe@domain.com",1566,FALSE)

getProject <- function(email="", projectID="", rawTraces = FALSE){
    if(email !="" && projectID != ""){
        login <- PhotosynQ::login(email)
        
        # Print a welcome statement
        print(paste("Successfully signed in as:", login$name, sep=" "))
        
        if(!is.null(login)){
            project_info <- PhotosynQ::getProjectInfo(login$email, login$token, projectID)
            
            # Print Project name
            print(paste("Project:", project_info$name, sep=" "))

            if(!is.null(project_info)){
                project_data <- PhotosynQ::getProjectData(login$email, login$token, projectID, rawTraces)
                if(!is.null(project_data)){

                    dl <- createDataframe(project_info,project_data)
                    return(dl)

                }
                else {
                    print("Warning: Project Data download failed.")
                    return(NULL)
                }
            }
            else {
                print("Warning: Project does not exist.")
                return(NULL)
            }
        }
        else {
            print("Warning: Login failed.")
            return(NULL)
        }
    }
    else {
        print("You have to supply email, password and project ID")
        return(NULL)
    }
}