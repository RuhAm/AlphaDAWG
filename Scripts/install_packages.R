# install_packages.R
options(repos = c(CRAN = "https://cran.rstudio.com/"))

# Function to install a package if it's not already installed
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
  }
}

# Install each package individually
install.packages("abind")
install.packages("glmnet")
install.packages("caret")
install.packages("waveslim")
