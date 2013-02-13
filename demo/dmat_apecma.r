### Setup mpi environment.
library(pmclust, quiet = TRUE)
init.grid()
comm.set.seed(123, diff = TRUE)

### Generate an example data.
N.allspmds <- rep(5000, comm.size())
N.spmd <- 5000
N.K.spmd <- c(2000, 3000)
N <- 5000 * comm.size()
p <- 2
K <- 2
data.spmd <- generate.basic(N.allspmds, N.spmd, N.K.spmd, N, p, K)
X.dmat <- ddmatrix(0, N, p, bldim = c(N.spmd, p), CTXT = 2)
X.dmat@Data <- data.spmd$X.spmd
X.dmat <- redistribute(X.dmat, bldim = .BLDIM, ICTXT = 0)

### Run clustering.
PARAM.org <- set.global.dmat(K = K)
PARAM.org <- initial.em.dmat(PARAM.org)
PARAM.new <- apecma.step.dmat(PARAM.org)
em.update.class.dmat()
mb.print(PARAM.new, .pmclustEnv$CHECK)

### Get results.
N.CLASS <- get.N.CLASS.dmat(K)
comm.cat("# of class:", N.CLASS, "\n")

### Print run time and quit Rmpi.
finalize()
