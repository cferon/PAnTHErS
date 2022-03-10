# PAnTHErS

Prototyping and Analysis Tool for Homomorphic Encryption Schemes (PAnTHErS) is the result of the work presented in [FLL20].

[FLL20] Cyrielle Feron, Loïc Lagadec, Vianney Lapôtre. Automated exploration of homomorphic encryption scheme input parameters, Journal of Information Security and Applications, Volume 55, 2020, 102627, ISSN 2214-2126, https://doi.org/10.1016/j.jisa.2020.102627.

[TOC]

## Quick Presentation

PAnTHErS is a tool written in Python, intented to evaluate Homomorphic Encryption Schemes (HE Schemes).
Its goal is to provide a fast insight of execution time and memory consumption for an application using homomorphic encryption.

PAnTHErS can then help users to choose the optimal HE Scheme to use for a given application.
It also helps to choose the best parameters to use for a given HE Scheme.

## Getting Started

Here are the few steps required to get PAnTHErS up and running on your system.


### Operating system

The install process described here have been tested on a stock 64 bits Debian Linux 11.2 system.
The base system is installed using the [**Debian netinst installer**](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso).

### Install required software
#### Sage

Download Sage installer from [SageMath](https://www.sagemath.org/) website.

At the time we write this Readme, the latest Sage version is 9.5. You may try later versions of Sage, but the final result cannot be guaranteed. 

Note that PAnTHErS was originally developped using Sage 7.6.

Here we download Sage 9.5 64 bits for Debian Linux 11.2 [**sage-9.5.tar.gz**](http://www-ftp.lip6.fr/pub/math/sagemath/src/sage-9.5.tar.gz) (1377.99 MB) dated from 2022-01-03 13:52.



MD5: 86bd1812d4fd8dcdda84d85648d3b0fa

For this installation process, we followed the official [Sage installation guidelines](http://doc.sagemath.org/html/en/installation/source.html).

##### Sage Software requirements

See [Sage installation guide](http://doc.sagemath.org/html/en/installation/source.html#installing-prerequisites) for more details

```bash
$> sudo apt update
$> sudo apt-get install  bc binutils bzip2 ca-certificates cliquer cmake curl ecl eclib-tools fflas-ffpack flintqs g++ g++ gcc gcc gengetopt gfan gfortran glpk-utils gmp-ecm lcalc libatomic-ops-dev libboost-dev libbraiding-dev libbrial-dev libbrial-groebner-dev libbz2-dev libcdd-dev libcdd-tools libcliquer-dev libcurl4-openssl-dev libec-dev libecm-dev libffi-dev libflint-arb-dev libflint-dev libfreetype6-dev libgc-dev libgd-dev libgf2x-dev libgiac-dev libgivaro-dev libglpk-dev libgmp-dev libgsl-dev libhomfly-dev libiml-dev liblfunction-dev liblrcalc-dev liblzma-dev libm4rie-dev libmpc-dev libmpfi-dev libmpfr-dev libncurses5-dev libntl-dev libopenblas-dev libpari-dev libpcre3-dev libplanarity-dev libppl-dev libprimesieve-dev libpython3-dev libqhull-dev libreadline-dev librw-dev libsingular4-dev libsqlite3-dev libssl-dev libsuitesparse-dev libsymmetrica2-dev libz-dev libzmq3-dev libzn-poly-dev m4 make nauty openssl palp pari-doc pari-elldata pari-galdata pari-galpol pari-gp2c pari-seadata patch perl pkg-config planarity ppl-dev python3 python3 python3-distutils r-base-dev r-cran-lattice singular sqlite3 sympow tachyon tar tox xcas xz-utils xz-utils
$> sudo apt-get install  4ti2 clang coinor-cbc coinor-libcbc-dev git graphviz libfile-slurp-perl libgraphviz-dev libigraph-dev libisl-dev libjson-perl libmongodb-perl libnauty-dev libperl-dev libpolymake-dev libsvg-perl libterm-readkey-perl libterm-readline-gnu-perl libterm-readline-gnu-perl libxml-libxslt-perl libxml-writer-perl libxml2-dev libxml2-dev lrslib ninja-build pari-gp2c pdf2svg polymake texinfo
$> sudo apt-get install texlive
```
PAnTHErS interface uses Tk, the following package must be installed:

```bash
$> sudo apt install tk tk-dev
```
From a terminal, extract the Sage archive:

    $> tar -xvf sage-9.5.tar.gz

On the local folder, a SageMath directory is created

    $> cd sage-9.5

Note: before start the build, you need to make sure there is no special characters in path leading to sage-9.5 directory (as, for instance, accents). 

Then start the build. To accelerate the build, you can add extra build jobs by providing a `-j N` option to the make command. Here we start the build with two jobs :

    $> make -j 2

Note: the build process is very time consuming, it can last several hours. 

Add sage folder in your `PATH` in `.bashrc` file. Open `.bashrc` file and add the following lines:

    $> PATH=/path/to/folder/sage:$PATH
    $> export PATH

Finally, when sage is installed, install `psutil` and `python3-tk` as follow:

    $> sage -pip install psutil
    $> sudo apt-get install python3-tk

## PAnTHErS installation
### Get the code

Download [PAnTHErS  code](https://github.com/cferon/PAnTHErS) on your local file system.


```
	$> git clone https://github.com/cferon/PAnTHErS
OR
	$> wget https://github.com/cferon/PAnTHErS/archive/master.zip
	$> unzip master.zip
	$> mv PAnTHErS-master PAnTHErS
```

Then create a symbolic link named `panthers` on your home directory.
This symbolic link is required for PAnTHErS graphical interface.


```
	$> cd ~
	$> ln -s /path/to/folder/panthers/ panthers
```

In `Interface` folder, create folders `Res` and `Tmp`. Furthermore, in `Res` folder, create folders `Graphs` and `Exploration`.

### Starting PAnTHErS 
Start Sage with the following command:

	$> sage

From Sage prompt, go to PAnTHErS interface folder and launch the interface:

    $sage: cd ~/panthers/Interface
    $sage: load("interface.py")

PAnTHErS interface should pop-up.

Note: current interface is pretty wide, a screen resolution at least 1600 pixels wide is required to be able to display the graphical interface.

## Troubleshooting

### User is not in sudoers file 
To be able to run commands as root using the sudo command, a user needs to be registered in the sudoers file.

To do this, you first need to get a root terminal prompt:

    $> su
Type your root password here, then from the root prompt:

    #> visudo
You get to the sudoers file editor.

Below the line:

    root	ALL=(ALL) ALL

Add your user name (here the user is named "user"):

    root	ALL=(ALL) ALL
    user	ALL=(ALL) ALL

Save the file and quit the editor.

The user is now able to run commands as root using *sudo* 

### You want to add Tk support to your already built Sage environment

As explained in the [installation guide](http://doc.sagemath.org/html/en/installation/source.html#tcl-tk), you first need to download the Tk package:

    $> sudo apt install tk tk-dev

Then rebuild Sage's Python:

    $> sage -f python2  # rebuild Python
    $> make             # rebuild components of Sage depending on Python

You must adapt `python2` in `python3` if this last one is used in sage.

Another way to install tk

## Copyright

PAnTHErS is licensed under the [CeCILL 2.1 License](http://www.cecill.info).
See the License.txt file for more details.

© 2018 Cyrielle Feron - ENSTA Bretagne

