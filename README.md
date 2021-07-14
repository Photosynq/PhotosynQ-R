# PhotosynQ | R

![CRAN/METACRAN](https://img.shields.io/cran/v/PhotosynQ?style=flat-square)

> This package allows to download Project data from the [PhotosynQ] online platform right into [RStudio] or [R], providing a data frame that can be used for a subsequent advanced analysis.

## Installation

If you don't already have, install [RStudio] and [R] first.

### R-Studio (CRAN)

The easiest way to install PhotosynQ for R is through R-Studio using the [CRAN] network that is hosting the repository for R Packages.

1. Open [RStudio]
2. Select Tools from the menu and click on Install Packages
3. Select Install from: Repository (CRAN)
4. Type `PhotosynQ` into the Packages input field
5. Make sure the Install dependencies checkbox is checked
6. Click on Install to finish the installation and close the dialog

*Note:* If you are not using CRAN to install the PhotosynQ Package you might have to install the Packages `httr` and `getPass` it depends on manually using the command: `install.packages(c("httr","getPass"))`.

### From Package Archive File

Download the latest release of the [PhotosynQ R package]. Select the file indicated as `Source code (tar.gz)`. This is the format required by RStudio.

1. Open [RStudio]
2. Select **Tools** from the menu and click on **Install Packages**.
3. Select *Install from:* `Package Archive File (.tgz; .tar-gz)`
4. *Package archive:* Click on **Browse...** and select the downloaded file.
5. Click on **Install** to finish the installation and close the dialog.

### Development version with devtools

For users that already have a development environment, [devtools] provides an easy installation from the GitHub repository.

1. Open [RStudio]
2. Install the release version of devtools from CRAN with `install.packages("devtools")`
3. Make sure you have a working development environment.
    + Windows: Install Rtools.
    + Mac: Install Xcode from the Mac App Store.
    + Linux: Install a compiler and various development libraries (details vary across different flavors of Linux).
4. Install the development version of PhotosynQ-R:
`devtools::install_github("PhotosynQ/PhotosynQ-R")`

## Getting started

Create a list of data frames in a single step from the data of a Project. Each frame in the list represents one measurement protocol. A user account for [PhotosynQ] is required to access the data. You will find the `ID` of your project on the **project page**.

```R
PhotosynQ::login("john.doe@domain.com")
ID <- 1556
dfs <- PhotosynQ::getProject(ID)
```

### Preparing the data for analysis

The **flagged measurements are included** in the dataset and most likely needs to be removed for further analysis. You can use the `filter()` function of the `dplyr` library to remove the flagged measurement from the data frame. You might want to use the same function to select a subset of measurement from your data frame.

```R
# Select a Protocol from the List of Data Frames
df <- dfs$`Protocol Name`

# View the Protocol Output
View(df)

# Filter out flagged data
library(dplyr)
df_filtered <- filter(df, status == "submitted")
```

## Separate Functions

### Login

```R
email <- "john.doe@domain.com"
login <- PhotosynQ::login(email)
```

### Logout

```R
PhotosynQ::logout()
```

### Get Project Information

```R
ID <- 1556
project_info <- PhotosynQ::getProjectInfo(ID)
```

### Get Project Data

```R
ID <- 1556
project_data <- PhotosynQ::getProjectData(ID)

# Use raw data
processed_data <- FALSE
project_data <- PhotosynQ::getProjectData(ID, processed_data)
```

### Create a Data frame

```R
dataframe <- PhotosynQ::createDataframe(project_info, project_data)
```

[PhotosynQ]: https://photosynq.org "PhotosynQ"

[PhotosynQ R package]: https://github.com/Photosynq/PhotosynQ-R/releases "PhotosynQ R package (Latest Release)"

[R]: https://www.r-project.org "R-Project"

[CRAN]: https://cran.r-project.org "CRAN"

[RStudio]: https://www.rstudio.com "RStudio"

[devtools]: https://github.com/r-lib/devtools "devtools"
