# update anaconda-project and prepare all envs
conda update anaconda-project -y && anaconda-project prepare --all
conda init
source ~/.bashrc
conda activate Julia

# install ijulia kernel - requires internet access..
julia scripts/ijulia.jl

# install kernel in local jupyter
jupyter kernelspec install /opt/continuum/.local/share/jupyter/kernels/julia-1.1 --prefix $CONDA_PREFIX

#remove conda init from ~/.bashrc
sed -i '/^# >>>/,/# <<</d' ~/.bashrc


