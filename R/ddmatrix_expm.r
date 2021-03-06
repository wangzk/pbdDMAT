# Matrix exponentiation using Pade' approximations and scaling and squaring from:
# "New Scaling and Squaring Algorithm for the Matrix Exponential"
# Awad H. Al-Mohy and Nicholas J. Higham, August 2009



p_matpow_by_squaring <- function(A, b=1)
{
  b <- as.integer(b)
  
  desca <- base.descinit(dim=A@dim, bldim=A@bldim, ldim=A@ldim, ICTXT=A@ICTXT)
  
  out <- base.p_matpow_by_squaring_wrap(A=A@Data, desca=desca, b=b)
  
  ret <- new("ddmatrix", Data=out, dim=A@dim, ldim=A@ldim, bldim=A@bldim, ICTXT=A@ICTXT)
  
  return( ret )
}


#matpow <- function(A, n)
#{
#  m <- nrow(A)
#  
##  if (n==0)
##    return(diag(1, m))
##  else if (n==1)
##    return(A)
##  
##  if (n >= 2^8)
##  {
##    E <- eigen(A)
##    B <- E$vectors %*% diag(E$values^n) %*% solve(E$vectors)
##    
##    return( B )
##  }
#  
#  B <- matpow_by_squaring(A, n)
#  
#  return(B)
#}



p_matexp_pade <- function(A, p)
{
  desca <- base.descinit(dim=A@dim, bldim=A@bldim, ldim=A@ldim, ICTXT=A@ICTXT)
  
  out <- base.p_matexp_pade_wrap(A=A@Data, desca=desca, p=p)
  
  N <- new("ddmatrix", Data=out$N, dim=A@dim, ldim=A@ldim, bldim=A@bldim, ICTXT=A@ICTXT)
  D <- new("ddmatrix", Data=out$D, dim=A@dim, ldim=A@ldim, bldim=A@bldim, ICTXT=A@ICTXT)
  
  R <- solve(D) %*% N
  
  return( R )
}



setMethod("expm", signature(x="matrix", y="missing"), 
  function(x, t=1, p=6)
  {
    if (nrow(x) != ncol(x))
      stop("Matrix exponentiation is only defined for square matrices.")
    
    if (p > 13)
      stop("argument 'p' must be between 1 and 13.")
    
    S <- base.matexp(A=x, p=p, t=t)
    
    return( S )
  }
)



setMethod("expm", signature(x="ddmatrix", y="missing"), 
  function(x, t=1, p=6)
  {
    if (nrow(x) != ncol(x))
      stop("Matrix exponentiation is only defined for square matrices.")
    
    n <- matexp_scale_factor(x)
    
    if (n == 0)
      return( p_matexp_pade(t*x, p=p) )
    
    x <- t*x/n
    
    S <- p_matexp_pade(x, p=p)
    S <- p_matpow_by_squaring(S, n)
    
    return( S )
  }
)


