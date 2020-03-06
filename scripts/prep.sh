# update anaconda-project and prepare all envs
conda update anaconda-project -y && anaconda-project prepare --all
source ~/.bashrc
conda activate Julia

# install ijulia kernel - requires internet access..
julia scripts/ijulia.jl

# install kernel in local jupyter
jupyter kernelspec install /opt/continuum/.local/share/jupyter/kernels/julia-1.1 --prefix $CONDA_PREFIX

# export kname="py37" ;   more /opt/continuum/anaconda/envs/py37/share/jupyter/kernels/python/kernel.json | sed s/\"display_name\":\ .*/\"display_name\":\ \"$kname\",/
export kenv="py37"
export pyver="3"
sed -i s/\"display_name\":\ .*/\"display_name\":\ \"$kname\",/ /opt/continuum/anaconda/envs/$kenv/share/jupyter/kernels/python$pyver/kernel.json



