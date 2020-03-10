# update anaconda-project and prepare all envs
setup() {
  conda update anaconda-project -y && anaconda-project prepare --all
  source ~/.bashrc
}
install_julia_kernel() {
  conda activate Julia
  # install ijulia kernel - requires internet access..
  julia scripts/ijulia.jl
  jupyter kernelspec install ~/.local/share/jupyter/kernels/julia-1.1 --name "Julia" --prefix $CONDA_PREFIX
}

echoerr() { 
  printf "%s\n" "$*" >&2
}

get_python_major_version() {
   CONDA_PYTHON=$(which python | grep $CONDA_PREFIX)
   [[ -z $CONDA_PYTHON ]] && echoerr "could not find python for activated env ($CONDA_DEFAULT_ENV)" && return 1
   PYVER="$($CONDA_PYTHON -c 'import sys; print(sys.version_info.major)')"
  if [[ $PYVER == 2 || $PYVER == 3 ]]; then 
    echo $PYVER
    return
  else
    echoerr "no python version 2 or 3 found"
    return 1
  fi  
}

get_kernelspec_file_for_env() {
  CONDA_ENV=${1:-$CONDA_DEFAULT_ENV}
  [[ -z $CONDA_ENV ]] && echoerr must have a conda env name && return 1
  [[ ! -d $ANACONDA_PROJECT_ENVS_PATH/$CONDA_ENV/share/jupyter ]] && echoerr could not find the path for env $ANACONDA_PROJECT_ENVS_PATH/$CONDA_ENV/share/jupyter  && return 1
  IFS=$'\n' 
  kernelspecs=( $(find $ANACONDA_PROJECT_ENVS_PATH/$CONDA_ENV/share/jupyter -name kernel.json) ) 
  unset IFS
  [[ -z $kernelspecs ]] && echoerr no kernel found && return 1
  [[ $2=="-a" ]] && ( for i in ${kernelspcs[*]}; do echo "$i"; done && return)
  echo ${kernelspecs[0]}
}

rename_kernelspec() {
  TARGET_ENV=${1:-$CONDA_DEFAULT_ENV}
  DISPLAY_NAME=${2:-$TARGET_ENV}
  KERNELSPEC="$(get_kernelspec_file_for_env $TARGET_ENV)"
  [[ -z $KERNELSPEC ]] && return 1
  grep display_name $KERNELSPEC
  sed -i s/\"display_name\":\ .*/\"display_name\":\ \"$DISPLAY_NAME\",/ $KERNELSPEC
  grep display_name $KERNELSPEC
}

foreach_env() {
  [[ $(command -v anaconda-project) ]] || ( echoerr must have anaconda-project for this to work && echo "" && return 1)
  for e in $(anaconda-project list-env-specs | tail -n +5)
  do
    [[ $2 == -e ]] && echo -n "$e "
    [[ -n $1 ]] && eval $1 $e
  done
}

list_specname_for_env() {
  foreach_env get_kernelspec_file_for_env | xargs grep -Po '"display_name": \K(.*)' /opt/continuum/anaconda/envs/Julia/share/jupyter/kernels/julia-1.1/kernel.json | awk -F/ '{print $6,$11}' | sed 's/kernel.json://g' | sed s/,//
}
