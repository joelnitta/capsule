##' Create a capsule library context to run code in
##'
##' Dependencies to be encapsulated are detected from files you nominate in
##' `dep_source_paths`. Good practice would be to have a single dependencies R
##' file that contains all library() calls - hence this makes an explicit
##' assertion of your dependencies. This way spurious usages of pkg:: for
##' packages not stated as dependencies will cause errors that can be caught.
##' 
##' @title create
##' @param dep_source_paths files to find package dependencies in.
##' @param lockfile path to write the lockfile; defaults to "renv.lock" in the current project.
##' @return nothing. Creates a capsule as a side effect.
##' @author Miles McBain
##' @export
create <- function(dep_source_paths = "./packages.R", lockfile = renv::paths$lockfile()) {

  callr::r(function(){
    renv::init(bare = TRUE)
    renv::deactivate()
  })


  renv::hydrate(detect_dependencies(dep_source_paths),
                library = renv::paths$library(),
                update = "all")

  delete_unneeded()

  renv::snapshot(type = "simple",
                 library = c(renv::paths$library()),
                 lockfile = lockfile,
                 confirm = FALSE,
                 force = TRUE)

}
