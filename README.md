PhotosynQ | R
=====================

Truly Collaborative Plant Research
----------------------------------

PhotosynQ helps you to make your plant research more efficient. For an advanced analysis, this package allows to pull data from projects right into **[R]**. We recommend to use it with **[RStudio]**.

***

### Installation
If you don't already have it, install **[RStudio]** first. Download the latest release of the [PhotosynQ R package]. Select the file indicated as `Source code (tar.gz)`. This is the format required by RStudio.
 
#### From Package Archive File
1. Open **[RStudio]**
2. Select **Tools** from the menu and click on **Install Packages**.
3. Select *Install from:* `Package Archive File (.tgz; .tar-gz)`
4. *Package archive:* Click on **Browse...** and select the downloaded file.
5. Click on **Install** to finish the installation and close the dialog.

#### Development version with devtools
For users that already have a develepment environment, **[devtools]** provides an easy installation from the github repository.
1. Open **[RStudio]**
2. Install the release version of devtools from CRAN with `install.packages("devtools")`
3. Make sure you have a working development environment.
    *Windows: Install Rtools.
    *Mac: Install Xcode from the Mac App Store.
    *Linux: Install a compiler and various development libraries (details vary across different flavors of Linux).
4. Install the development version of PhotosynQ-R:
`devtools::install_github("PhotosynQ/PhotosynQ-R")`

***

### Getting started
Create a list of data frames in a single step from the data of a Project. Each frame in the list represents one measurment protocol. A user account for [PhotosynQ] is required to access the data. You will find the `ID` of your project on the **project page**.

```R
ID <- 1556
dfs <- PhotosynQ::getProject("john.doe@domain.com",ID)
```

#### Preparing the data for analysis
The **flagged measurements are included** in the dataset and most likely needs to be removed for futher analysis. You can use the `filter()` function of the `dplyr` library to remove the flagged measurement from the data frame. You might want to use the same function to select a subset of measurement from your data frame.

```R
# Select a Protocol from the List of Data Frames
df <- dfs$`Protocol Name`

# View the Protocol Output
View(df)

# Filter out flagged data
library(dplyr)
df_filtered <- filter(df, status == "submitted")
```

***

### Separate Functions

#### Login
```R
email <- "john.doe@domain.com"
login <- PhotosynQ::login(email)
```

#### Logout
```R
PhotosynQ::login(login$token)
```

#### Get Project Information
```R
ID <- 1556
project_info <- PhotosynQ::getProjectInfo(login$email, login$token, ID)
```

#### Get Project Data
```R
ID <- 1556
project_data <- PhotosynQ::getProjectData(login$email, login$token, ID)

# Use raw data
processed_data <- FALSE
project_data <- PhotosynQ::getProjectData(login$email, login$token, ID, processed_data)
```

#### Create a Data frame
```R
dataframe <- PhotosynQ::createDataframe(project_info, project_data)
```

[PhotosynQ]: https://photosynq.org "PhotosynQ"

[PhotosynQ R package]: https://github.com/Photosynq/PhotosynQ-R/releases "PhotosynQ R package (Latest Release)"

[R]: https://www.r-project.org "R-Project"

[RStudio]: https://www.rstudio.com "RStudio"

[devtools]: https://github.com/hadley/devtools "devtools"
