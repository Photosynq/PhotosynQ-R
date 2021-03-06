% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getProject.R
\name{getProject}
\alias{getProject}
\title{Get Project data in a Data Frame from 'PhotosynQ'}
\usage{
getProject(projectID = "", processedData = TRUE, rawTraces = FALSE)
}
\arguments{
\item{projectID}{The ID of your Project (Just copy the Project ID from the
project page or your user page)}

\item{processedData}{(optional) Receive the processed data when set to
\code{TRUE}, receive raw Data when set to \code{FALSE}.}

\item{rawTraces}{(optional) Adds raw traces to processed data. It is ignored
when processedData is set to \code{TRUE}.}
}
\value{
Separate data frame per protocol including measurement data and
  answers to Project.
}
\description{
Get Project data using the Project's ID and create data frame(s).
}
\details{
This function produces a data frame for a 'PhotosynQ' Project using the
Project's ID. The ID can be found on the Project's page on the 'PhotosynQ'
website. This function call includes the Project data as well as information.
In case multiple protocols were used, each protocol is in a separate data
frame. By default the processed data is not included. The parameter
\code{rawTraces} can be set to \code{TRUE} to include the \code{rawTraces} in
combination with the processed data. By default the recorded traces are not
received. When the original data structure is needed, separate calls have to
be used including \code{\link{getProjectInfo}} and
\code{\link{getProjectData}}.
}
\section{Note}{
 Including the raw data and/or the traces will increase the
  data frame size significantly.
}

\examples{
getProject(1566)
}
\keyword{Data}
\keyword{Project}
