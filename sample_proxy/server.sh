#!/usr/bin/env bash
client() {
  echo https://$TOOL_HOST/proxy/8086
}
server() {
  python -m http.server ${1:-8086}
}

cd  sample_proxy
echo '<H1>Hellow World!! Environment Report...</H1>' > index.html
date >> index.html
echo '<H2>Conda Packages</H2>' >> index.html
conda list >> index.html
echo '<H2>Conda info</H2>' >> index.html
conda info >> index.html
echo '<H2>Conda envs</H2>' >> index.html
conda env list >> index.html
echo '<H2>Python-executable</H2>' >> index.html
PY=$(which python)
if [[ -n $PY ]]; then
  echo "using $PY" >> index.html
  echo -n "Version: " >> index.html
  $PY --version >> index.html
else
  echo none >> index.html
fi





server 
