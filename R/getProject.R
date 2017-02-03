#' Get Project Data in a DataFrame from PhotosynQ
#'
#' This function allows you to receive data from PhotosynQ.
#' @param email Your email address you use to sign in
#' @param projectURL The URL of your Project (Just copy the Project page URL from your browser)
#' @keywords Project Data 
#' @export
#' @examples
#' getProject("john.doe@domain.com","https://photosynq.org/projects/getting-started-with-multispeq")

getProject <- function(email="", projectURL=""){
    if(email !="" && projectURL != ""){
        login <- PhotosynQ::login(email)
        
        # Print a welcome statement
        print(paste("Successfully signed in as:", login$name, sep=" "))
        
        if(!is.null(login)){
            project_info <- PhotosynQ::getProjectInfo(login$email, login$token, projectURL)
            
            # Print Project name
            print(paste("Project:", project_info$name, sep=" "))

            if(!is.null(project_info)){
                project_data <- PhotosynQ::getProjectData(login$email, login$token, projectURL)
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