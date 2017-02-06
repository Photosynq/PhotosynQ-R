PhotosynQ | R
=====================

Truly Collaborative Plant Research
----------------------------------

PhotosynQ helps you to make your plant research more efficient. For an advanced analysis, this package allows to pull data from projects right into **[R]**. We recommend to use it with **[RStudio]**.

***

### Installation
If you don't already have it, install **[RStudio]** first. Download the latest release of the [PhotosynQ R package]. Select the file indicated as `Source code (tar.gz)`. This is the format required by RStudio.

1. Open **[RStudio]**
2. Select **Tools** from the menu and click on **Install Packages**.
3. Select *Install from:* `Package Archive File (.tgz; .tar-gz)`
4. *Package archive:* Click on **Browse...** and select the downloaded file.
5. Click on **Install** to finish the installation and close the dialog.

***

### Getting started
Create a data frame in a single step from the data of a Project. A user account for [PhotosynQ] is required to access the data.

```R
url <- "https://photosynq.org/projects/getting-started-with-multispeq"
dataframe <- PhotosynQ::getProject("john.doe@domain.com",url)
```

### Separate Functions

#### Login
```R
login <- PhotosynQ::login("john.doe@domain.com")
```

#### Logout
```R
PhotosynQ::login(login$token)
```

#### Get Project Information
```R
url <- "https://photosynq.org/projects/getting-started-with-multispeq"
project_info <- PhotosynQ::getProjectInfo(login$email, login$token, url)
```

#### Get Project Data
```R
url <- "https://photosynq.org/projects/getting-started-with-multispeq"
project_data <- PhotosynQ::getProjectData(login$email, login$token, url)
```

#### Create a Data frame
```R
dataframe <- PhotosynQ::createDataframe(project_info, project_data)
```

[PhotosynQ]: https://photosynq.org "PhotosynQ"

[PhotosynQ R package]: https://github.com/Photosynq/PhotosynQ-R/releases "PhotosynQ R package (Latest Release)"

[R]: https://www.r-project.org "R-Project"

[RStudio]: https://www.rstudio.com "RStudio"