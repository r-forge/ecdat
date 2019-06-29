.onAttach <- function(libname, pkgname) {
  repo <- "https://github.com/sbgraves237/Ecdat"
  packageStartupMessage(
    "WARNING: this package was installed from R-Forge,", 
    " but development has\n",
    "moved to GitHub. Please re-install the package ", 
    "using the GitHub repo at:\n",repo, 
    " using\n\ndevtools::install_github(", 
    '"sbgraves237/Ecdat/pkg/Ecfun")')
}