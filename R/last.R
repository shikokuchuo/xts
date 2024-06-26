#
#   xts: eXtensible time-series
#
#   Copyright (C) 2008  Jeffrey A. Ryan jeff.a.ryan @ gmail.com
#
#   Contributions from Joshua M. Ulrich
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


#' @rdname first
`last` <-
function(x,...)
{
  UseMethod("last")
}

#' @rdname first
`last.default` <-
function(x,n=1,keep=FALSE,...)
{
  if(length(x) == 0)
    return(x)
  if(is.character(n)) {
    xx <- try.xts(x, error=FALSE)
    if(is.xts(xx)) {
      xx <- last.xts(x, n=n, keep=keep, ...)
      return(reclass(xx))
    }
  }
  if(is.null(dim(x))) {
    if(n > 0) {
      sub <- seq.int(to = length(x), length.out = min(n, length(x)))
      xx <- x[sub]
      if(keep) xx <- structure(xx,keep=x[1:(NROW(x)+(-n))])
      xx
    } else if(n < 0) {
      sub <- seq_len(max(length(x) + n, 0L))
      xx <- x[sub]
      if(keep) xx <- structure(xx,keep=x[((NROW(x)-(-n)+1):NROW(x))])
      xx
    } else {
      xx <- x[0]
      if(keep) xx <- structure(xx,keep=x[0])
      xx
    }
  } else {
    if(n > 0) {
      sub <- seq.int(to = NROW(x), length.out = min(n, NROW(x)))
      xx <- x[sub,,drop=FALSE]
      if(keep) xx <- structure(xx,keep=x[1:(NROW(x)+(-n)),])
      xx
    } else if(n < 0) {
      sub <- seq_len(max(NROW(x) + n, 0L))
      xx <- x[sub,,drop=FALSE]
      if(keep) xx <- structure(xx,keep=x[((NROW(x)-(-n)+1):NROW(x)),])
      xx
    } else {
      xx <- x[0,,drop=FALSE]
      if(keep) xx <- structure(xx,keep=x[0,])
      xx
    }
  }
}

#' @rdname first
`last.xts` <-
function(x,n=1,keep=FALSE,...)
{
  if(length(x) == 0)
    return(x)
  if(is.character(n)) {
    # n period set
    np <- strsplit(n," ",fixed=TRUE)[[1]]
    if(length(np) > 2 || length(np) < 1)
      stop(paste("incorrectly specified",sQuote("n"),sep=" "))
    # series periodicity
    sp <- periodicity(x)
    sp.units <- sp[["units"]]
    # requested periodicity$units
    rpu <- np[length(np)]
    rpf <- ifelse(length(np) > 1, as.numeric(np[1]), 1)
    if(rpu == sp.units) {
      n <- rpf
    } else {
      # if singular - add an s to make it work
      if(substr(rpu,length(strsplit(rpu,'')[[1]]),length(strsplit(rpu,'')[[1]])) != 's')
        rpu <- paste(rpu,'s',sep='')
      u.list <- list(secs=4,seconds=4,mins=3,minutes=3,hours=2,days=1,
                     weeks=1,months=1,quarters=1,years=1)
      dt.options <- c('seconds','secs','minutes','mins','hours','days',
                      'weeks','months','quarters','years')
      if(!rpu %in% dt.options)
        stop(paste("n must be numeric or use",paste(dt.options,collapse=',')))
      dt <- dt.options[pmatch(rpu,dt.options)]
      if(u.list[[dt]] > u.list[[sp.units]]) {
        #  req is for higher freq data period e.g. 100 mins of daily data
        stop(paste("At present, without some sort of magic, it isn't possible",
             "to resolve",rpu,"from",sp$scale,"data"))
      }
      ep <- endpoints(x,dt)
      if(rpf > length(ep)-1) {
        rpf <- length(ep)-1
        warning("requested length is greater than original")
      }
      if(rpf > 0) {
        n <- ep[length(ep)-rpf]+1
        if(is.null(dim(x))) {
          xx <- x[n:NROW(x)]
        } else {
          xx <- x[n:NROW(x),,drop=FALSE]
        }
        if(keep) xx <- structure(xx,keep=x[1:(ep[length(ep)+(-rpf)])])
        return(xx)
      } else if(rpf < 0) {
        n <- ep[length(ep)+rpf]
        if(is.null(dim(x))) {
          xx <- x[1:n]
        } else {
          xx <- x[1:n,,drop=FALSE]
        }
        if(keep) xx <- structure(xx,keep=x[(ep[length(ep)-(-rpf)]+1):NROW(x)])
        return(xx)
      } else {
        if(is.null(dim(x))) {
          xx <- x[0]
        } else {
          xx <- x[0,,drop=FALSE]
        }
        if(keep) xx <- structure(xx,keep=x[0])
        return(xx)
      }
    }
  }
  if(length(n) != 1) stop("n must be of length 1")
  if(n > 0) {
    n <- min(n, NROW(x))
    if(is.null(dim(x))) {
      xx <- x[(NROW(x)-n+1):NROW(x)]
    } else {
      xx <- x[(NROW(x)-n+1):NROW(x),,drop=FALSE]
    }
    if(keep) xx <- structure(xx,keep=x[1:(NROW(x)+(-n))])
    xx
  } else if(n < 0) {
    if(abs(n) >= NROW(x))
      return(x[0])
    if(is.null(dim(x))) {
      xx <- x[1:(NROW(x)+n)]
    } else {
      xx <- x[1:(NROW(x)+n),,drop=FALSE]
    }
    if(keep) xx <- structure(xx,keep=x[((NROW(x)-(-n)+1):NROW(x))])
    xx
  } else {
    if(is.null(dim(x))) {
      xx <- x[0]
    } else {
      xx <- x[0,,drop=FALSE]
    }
    if(keep) xx <- structure(xx,keep=x[0])
    xx
  }
}
