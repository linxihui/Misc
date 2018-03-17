env=py3
pyversion=3.6

conda create -n $env python=$pyversion

pip install -U pip

pip install -r ./python-most-used-pkgs.txt

conda install pytorch torchvision -c pytorch
