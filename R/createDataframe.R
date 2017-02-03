#' Create a DataFrame from PhotosynQ Project Data
#'
#' This function allows you to create a dataframe based on the
#' Project information and Project data receive data from PhotosynQ.
#' @param project_info Object returned by getProjectInfo()
#' @param project_data Object returned by getProjectData()
#' @keywords Project Data dataframe
#' @export
#' @examples
#' createDataframe(project_info,project_data)

createDataframe <- function(project_info="", project_data =""){

    if(!is.null(project_info) && !is.null(project_data)){

        # Print Project data receival information
        print("Project data received, generating dataframe.")

        # Exclusion list
        ToExclude <- c("protocol_number","protocol_id","id","protocol_name","baseline_values","chlorophyll_spad_calibration","averages","data_raw","baseline_sample","HTML","Macro","GraphType","time","time_offset","get_ir_baseline","get_blank_cal","get_userdef0","get_userdef1","get_userdef2","get_userdef3","get_userdef4","get_userdef5","get_userdef6","get_userdef7","get_userdef8","get_userdef9","get_userdef10","get_userdef11","get_userdef12","get_userdef13","get_userdef14","get_userdef15","get_userdef16","get_userdef17","get_userdef18","get_userdef19","get_userdef20","r","g","b","recall","messages","order")
        
        # Since we have all the information ready
        # now it is time to preprocess the data
        
        # Let's count the protocols first, to see which ones we actually need
        # and generate a lookup table
        protocols <- list();
        for(protocol in project_info$protocols){
            protocols[[toString(protocol$id)]] <- list("name" = protocol$name, parameters = c(), "count" = 0 )
        }

        # Add counter for custom data
        protocols[["custom"]] <- list("name" = "Imported Data (Custom Data)", parameters = c(), "count" = 0 )

        # Now we work on the actual data
        for (sampleindex in project_data) {

            # Remove data entries that don't have the sample key
            if(!exists("sample", sampleindex)){
                sampleindex <- NULL
                next
            }

            # We skip the time changes for now
            # TODO: Implement the new timestamps here

            # Make sure location is false or an array
            if(exists("location", sampleindex)){
                if(typeof(sampleindex$location) == "character"){
                    sampleindex$location <- strsplit(sampleindex$location,",")
                }
            }

            # Make sure answers are an array
            if(!exists("user_answers", sampleindex) || typeof(sampleindex$user_answers) == "character")
                sampleindex$user_answers <- list()

            # Loop through measurements of one sample
            for(sampleprotocol in sampleindex$sample){

                # Skip Measurements without protocol id
                if(!exists("protocol_id",sampleprotocol) ){
                    next
                }

                # Correct timestamp
                if(!exists("time",sampleprotocol) ){
                    sampleprotocol$time <- sampleindex$time
                }

                # Build the user answers
                answers <-list()
                for(filters in project_info$filters){
                    answers[[paste("answer",toString(filters$id),sep="_")]] <- filters$label
                }

                protocols[[toString(sampleprotocol$protocol_id)]]$parameters <- c(protocols[[toString(sampleprotocol$protocol_id)]]$parameters, names(sampleprotocol))

                # Add Dummy for unknown protocols
                if(!exists(toString(sampleprotocol$protocol_id), protocols)){
                    protocols[[toString(sampleprotocol$protocol_id)]] <- list("name" = paste("Unknown Protocol (ID: ", sampleprotocol$protocol_id, ")", sep = "") , parameters = c(), "count" = 0)
                }
                else{
                    if(!exists("count",protocols[[toString(sampleprotocol$protocol_id)]])){
                        protocols[[toString(sampleprotocol$protocol_id)]]$count <- 1
                    }
                    else{
                        protocols[[toString(sampleprotocol$protocol_id)]]$count <- protocols[[toString(sampleprotocol$protocol_id)]]$count + 1
                    }
                }

                # Check if there is custom data
                if(exists("custom", sampleindex)){
                    protocols$custom <- protocols$custom + 1
                }

            }

        }

        for(p in names(protocols)){
            protocols[[p]][["parameters"]] <- unique(protocols[[p]][["parameters"]])
        }

        # Now that the preprocessing is done, we can start putting 
        # the data into the data frame

        spreadsheet <- list();
        for(p in names(protocols)){

            if(protocols[[p]]$count == 0){
                next
            }
            
            spreadsheet[[p]] <- list()

            spreadsheet[[p]][["datum_id"]] <- c(1)
            spreadsheet[[p]][["time"]] <- c(1)

            for(a in names(answers)){
                spreadsheet[[p]][[a]] <- c(1)
            }

            # Add the protocol to the list
            for(i in 1:length(protocols[[p]]$parameters)){
                if(!is.element( toString(protocols[[p]]$parameters[i]), ToExclude ) ){
                    spreadsheet[[p]][[toString(protocols[[p]]$parameters[i])]] <- c(1)
                }
            }

            spreadsheet[[p]][["user_id"]] <- c(1)
            spreadsheet[[p]][["device_id"]] <- c(1)
            spreadsheet[[p]][["status"]] <- c(1)
            spreadsheet[[p]][["notes"]] <- c(1)
            spreadsheet[[p]][["longitude"]] <- c(1)
            spreadsheet[[p]][["latitute"]] <- c(1)
        }

        for(measurement in project_data){
            for(prot in measurement$sample){
                protocolID <- toString(prot[["protocol_id"]])
                for(param in names(spreadsheet[[protocolID]])){

                    if(param == "datum_id"){
                        spreadsheet[[protocolID]][["datum_id"]] <- c(spreadsheet[[protocolID]][["datum_id"]], measurement$datum_id )
                        next
                    }

                    if(param == "time"){
                        time <- as.POSIXlt((prot[[toString(param)]]/1000), origin="1970-01-01")
                        spreadsheet[[protocolID]][["time"]] <- c(spreadsheet[[protocolID]][["time"]], toString(time))
                        next
                    }

                    if(param == "user_id"){
                        spreadsheet[[protocolID]][["user_id"]] <- c(spreadsheet[[protocolID]][["user_id"]], toString(measurement$user_id))
                        next
                    }

                    if(param == "device_id"){
                        spreadsheet[[protocolID]][["device_id"]] <- c(spreadsheet[[protocolID]][["device_id"]], toString(measurement$device_id))
                        next
                    }                                                                

                    if(param == "longitude"){
                        spreadsheet[[protocolID]][["longitude"]] <- c(spreadsheet[[protocolID]][["longitude"]], toString(measurement$location[[1]]))
                        next
                    }                                                                

                    if(param == "latitute"){
                        spreadsheet[[protocolID]][["latitute"]] <- c(spreadsheet[[protocolID]][["latitute"]], toString(measurement$location[[2]]))
                        next
                    }  

                    if(param == "notes"){
                        spreadsheet[[protocolID]][["notes"]] <- c(spreadsheet[[protocolID]][["notes"]], toString(measurement$note))
                        next
                    }

                    if(param == "status"){
                        spreadsheet[[protocolID]][["status"]] <- c(spreadsheet[[protocolID]][["status"]], toString(measurement$status))
                        next
                    }

                    if(substr(param,0,7) == "answer_"){
                        answer <- strsplit(param,"_")[[1]][2]
                        spreadsheet[[protocolID]][[param]] <- c(spreadsheet[[protocolID]][[param]], measurement$user_answers[[toString(answer)]])
                        next
                    }

                    if( is.atomic(prot[[toString(param)]]) ){
                        spreadsheet[[protocolID]][[param]] <- c(spreadsheet[[protocolID]][[param]], toString(prot[[toString(param)]]))
                    }else{
                        spreadsheet[[protocolID]][[param]] <- c(spreadsheet[[protocolID]][[param]], prot[[toString(param)]])
                    }
                }

            }

        }

        # Stupid, but we have to do this to remove the first row
        for(protocol in names(spreadsheet)){
            ii <- 1
            for(parameter in names(spreadsheet[[protocol]])){
                len <- length(spreadsheet[[protocol]][[parameter]])
                spreadsheet[[protocol]][[parameter]] <- spreadsheet[[protocol]][[parameter]] [2:len]

                if(!is.null(answers[[parameter]])){
                    names(spreadsheet[[protocol]])[ii] <- answers[[parameter]]
                }
                ii <- ii + 1
            }
        }

        i <- 1
        for(protocol in names(spreadsheet)){
            if(!is.null(protocols[[toString(protocol)]]$name)){
                names(spreadsheet)[i] <- protocols[[toString(protocol)]]$name
            }
            i <- i + 1
        }

        return(spreadsheet)
    }
    else{
        print("Warning: Missing objects")
        return(NULL)
    }
}