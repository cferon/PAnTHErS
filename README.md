# PAnTHErS

Prototyping and Analysis Tool for Homomorphic Encryption Schemes

[TOC]

## Presentation / Why ?

Quick tool presentation -- TODO

## Getting Started

Here are the few steps required to get PAnTHErS up and running on your system.


### Operating system

The install process described here have been tested on a stock 64 bits Debian Linux 9.5 system.
The base system is installed using the [**Debian netinst installer**](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.5.0-amd64-netinst.iso).

### Install required software
#### Sage

Download Sage installer from [SageMath](https://www.sagemath.org/) website.

At the time we write this Readme, the latest Sage version is 8.2. You may try later versions of Sage, but the final result cannot be guaranteed. 

Note that PAnTHErS was originally developped using Sage 7.6.

Here we download Sage 8.2 64 bits for Debian Linux 9 [**sage-8.2-Debian_GNU_Linux_9-x86_64.tar.bz2**](http://www-ftp.lip6.fr/pub/math/sagemath/linux/64bit/sage-8.2-Debian_GNU_Linux_9-x86_64.tar.bz2) (1658.98 MB) dated from 2018-05-08 22:01.

MD5: fd83b2b63699b90c41e74e9988c705d2

For this installation process, we followed the official [Sage installation guidelines](http://doc.sagemath.org/html/en/installation/source.html).

##### Sage Software requirements

See [Sage installation guide](http://doc.sagemath.org/html/en/installation/source.html#installing-prerequisites) for more details

```bash
$> sudo apt update
$> sudo apt install binutils gcc make m4 perl tar git openssl libssl-dev
```
PAnTHErS interface uses Tk, the following package must be installed:

```bash
$> sudo apt install tk tk-dev
```
From a terminal, extract the Sage archive:

    $> tar -jxvf sage-8.2-Debian_GNU_Linux_9-x86_64.tar.bz2 

On the local folder, a SageMath directory is created

    $> cd SageMath
Then start the build. To accelerate the build, you can add extra build jobs by providing a `-j N` option to the make command. Here we start the build with two jobs :

    $> make -j 2

Note: the build process is very time consuming, it can last several hours. 

## PAnTHErS installation
### Get the code

Download [PAnTHErS  code](code%20url) on your local file system.

Unpack the downloaded archive on your user home folder


    cd 
    tar -xvf /path/to/panthers/archive.tar.gz 

### Starting PAnTHErS 
Go to your Sage build folder and start Sage with the following command:

	$> cd /path/to/SageMath
	$> ./sage
From Sage prompt, go to PAnTHErS interface folder and launch the interface:

    $sage: cd
    $sage: cd panthers/Interface
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

## Copyright

PAnTHErS is licensed under the [CeCILL 2.1 License](http://www.cecill.info).
See the License.txt file for more details.

© 2018 Cyrielle Feron - ENSTA Bretagne

