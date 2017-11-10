function install {
  echo installing $1
  shift
  sudo apt-get -y install "$@"
}

sudo apt-get -y update

install 'development tools' build-essential
install 'git' git

### Updating gcc

sudo apt-get install python-software-properties
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-4.8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50


### Updating g++

sudo apt-get install g++-4.8
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50


### installing emacs and bc

sudo apt-get -y install emacs23
sudo apt-get install bc

### installing python2.7

sudo wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
sudo tar xzf Python-2.7.13.tgz
cd Python-2.7.13
sudo ./configure
sudo make altinstall


### Downloading llvm 3.0 binaries

cd $HOME
wget http://llvm.org/releases/3.0/clang+llvm-3.0-x86_64-linux-Ubuntu-11_10.tar.gz
tar -xzvf clang+llvm-3.0-x86_64-linux-Ubuntu-11_10.tar.gz
mv clang+llvm-3.0-x86_64-linux-Ubuntu-11_10 llvm-3.0
rm -f clang+llvm-3.0-x86_64-linux-Ubuntu-11_10.tar


### Updating .bashrc file

echo "export PATH=$HOME/llvm-3.0/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$HOME/llvm-3.0/lib:$LD_LIBRARY_PATH" >> ~/.bashrc

export PATH=$HOME/llvm-3.0/bin:$PATH
export LD_LIBRARY_PATH=$HOME/llvm-3.0/lib:$LD_LIBRARY_PATH

echo "export LLVM_COMPILER=clang" >> ~/.bashrc

### Installing scons

cd
wget -qnc http://prdownloads.sourceforge.net/scons/scons-2.4.0.tar.gz
tar xzvf scons-2.4.0.tar.gz
mv scons-2.4.0 scons
cd scons
sudo python2.7 setup.py install

### Cloning Precimonious

cd
git clone https://github.com/corvette-berkeley/precimonious.git
cd precimonious

export CORVETTE_PATH=$HOME/precimonious
echo "export CORVETTE_PATH=$HOME/precimonious" >> ~/.bashrc

echo "export LD_LIBRARY_PATH=${CORVETTE_PATH}/logging:${LD_LIBRARY_PATH}" >> ~/.bashrc
export LD_LIBRARY_PATH=${CORVETTE_PATH}/logging:${LD_LIBRARY_PATH}

source ~/.bashrc


cd src
sed -i "s/SHLINKFLAGS='-Wl',/SHLINKFLAGS='',/g" SConscript
sed -i "s/LIBS='LLVM-\$llvm_version'/#LIBS='LLVM-\$llvm_version'/g" SConscript
scons -U
scons -U test

echo 'all set, rock on!'
