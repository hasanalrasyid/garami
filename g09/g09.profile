#
# These commands set up for use of Gaussian 09.  They should be source'd
# into each Gaussian 09 user's .login file, after setting the following
# environment variable:
#
# g09root -- Directory which contains the g09 main directory.  Defaults
#            to users's home directory if not defined before entry.
#
# Top directories for the program:
#
gr=$HOME
if [ "$g09root" ]
  then gr=$g09root
  fi
export GAUSS_EXEDIR="$gr/g09/bsd:$gr/g09/local:$gr/g09/extras:$gr/g09"
export GAUSS_LEXEDIR="$gr/g09/linda-exe"
export GAUSS_ARCHDIR="$gr/g09/arch"
export GAUSS_BSDDIR="$gr/g09/bsd"
export GV_DIR="$gr/gv"
if [ -e "$GV_DIR/gview.app" ]; then
  alias gv='open $GV_DIR/gview.app'
else
  alias gv="$GV_DIR/gview.csh"
  fi
if [ "$PATH" ]; then
  export PATH="$PATH:$GAUSS_EXEDIR"
else
  export PATH="$GAUSS_EXEDIR"
  fi
export _DSM_BARRIER="SHM"
if [ "$LD_LIBRARY64_PATH" ]; then
  export LD_LIBRARY64_PATH="$GAUSS_EXEDIR:$GV_DIR/lib:$LD_LIBRARY64_PATH"
else
  if [ "$LD_LIBRARY_PATH" ]; then
#   gv lib has to be at end for IA64 otherwise IA32 .so files there confuse things
    export LD_LIBRARY_PATH="$GAUSS_EXEDIR:$LD_LIBRARY_PATH:$GV_DIR/lib"
  else
    export LD_LIBRARY_PATH="$GAUSS_EXEDIR:$GV_DIR/lib"
    fi
  fi
export G09BASIS="$gr/g09/basis"
alias sl="$gr/g09/tests/searchlog.csh"
mach="$(/share/apps/gau-machine)"
if [ "$mach" = "necsx" ]; then
  export F_ERROPT1="271,271,2,1,2,2,2,2"
  export OMP_NUM_THREADS="1"
  export F_ERROPT2="0,999,1,1,1,1,2,2"
  export F_SYSLEN="1024"
  fi
if [ "$mach" = "sgi" ]; then
  export _RLD_ARGS="-log /dev/null"
  export TRAP_FPE="OVERFL=ABORT;DIVZERO=ABORT;INT_OVERFL=ABORT"
  export MP_STACK_OVERFLOW="OFF"
  fi
if [ "$mach" = "ia64" ]; then
# The following is to avoid weirdness with Intel's MKL library on IA64:
  export KMP_STACKSIZE="20971520"
  export KMP_AFFINITY="disabled"
  place="`which dplace`"
  if [ "$?" == 0 ] ; then
    export GAUSS_DPLACE="1"
    fi
  fi
if [ "$mach" = "crayx1" ]; then
# avoid small heap limit on Cray X1
  export X1_LOCAL_HEAP_SIZE='0xbff7000000'
  fi
if [ "$mach" = "ibm_rs6k_linux" ]; then
# fix LD_LIBRARY_PATH so that the Linda workers can start
  export LD_LIBRARY_PATH="/opt/ibmcmp/lib64:$LD_LIBRARY_PATH"
  fi
export PGI_TERM='trace,abort'
ulimit -c 0
ulimit -d hard
ulimit -f hard
ulimit -l hard
ulimit -m hard
ulimit -n hard
ulimit -s hard
ulimit -t hard
ulimit -u hard
