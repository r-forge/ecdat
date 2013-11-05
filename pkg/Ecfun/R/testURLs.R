testURLs <- function(urls=c(
 wiki="http://en.wikipedia.org",
 wiki.PVI="http://en.wikipedia.org/wiki/Cook_Partisan_Voting_Index",
 house="http://house.gov",
 house.reps="http://house.gov/representatives"),
         file.='testURLresults.csv', n=10, maxFail=10){
##
## 1. set up
##
  library(RCurl)
  ku <- length(urls)
  uNames <- names(urls)
  if(is.null(uNames))
      uNames <- sub('^http://', '', urls)
  Read <- vector('list', ku)
  names(Read) <- uNames
  msgs <- Read
  .Names <- as.vector(outer(c('read', 'time'), uNames, paste, sep='.'))
  results <- matrix(NA, n, 2*ku,
                    dimnames=list(NULL, .Names))
##
## 2.  Do
##
  for(i in 1:n){
      cat(i, '\n')
      if(i<2){
          fi <- file.info(file.)
          if(is.na(fi[1,1]))
              cat('time,', paste(.Names, collapse=','),'\n', file=file.)
      }
      elapsed.time <- success <- rep(NA, ku)
      for(j in 1:ku){
          start.time <- proc.time()
          cat(uNames[j], '')
          readi <- try(getURL(urls[[j]]))
          et <- max(proc.time() - start.time, na.rm=TRUE)
          elapsed.time[j] <- et
          si <- (class(readi)!='try-error')
          success[j] <- si
          if(si){
              Read[[j]] <- readi
          } else {
              ri <- gsub('\n', ' ', readi)
              msgs[[j]] <- c(msgs[[j]], ri)
          }
          cat(si, et, '\n')
      }
      outvec <- as.numeric(rbind(success, elapsed.time))
      Out <- cbind(Time=date(), as.data.frame(matrix(outvec, 1)))
      write.table(Out, file., append=TRUE, sep=',', row.names=FALSE,
                  col.names=FALSE)
      results[i,] <- outvec
  }
##
## 3.  Done
##
  attr(Read, 'urls') <- urls
  attr(Read, 'testResults') <- results
  Msgs <- lapply(msgs, table)
  attr(Read, 'errorMessages') <- Msgs
  for(j in 1:ku){
      if(length(Msgs[[j]])>0){
          mj <- paste(uNames[j], ":", Msgs[[j]], " ", names(Msgs[[j]]),
                      sep="")
          cat(mj, '\n', file=file., append=TRUE)
      }
  }
#
  Read
}