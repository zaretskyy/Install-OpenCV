# Dan Walkes
# 2014-01-29
# Call this script after configuring variables:
# version - the version of OpenCV to be installed
# downloadfile - the name of the OpenCV download file
# dldir - the download directory (optional, if not specified creates an OpenCV directory in the working dir)
if [[ -z "$version" ]]; then
	echo "Please define version before calling `basename $0` or use a wrapper like opencv_latest.sh"
	exit 1
fi
if [[ -z "$downloadfile" ]]; then
	echo "Please define downloadfile before calling `basename $0` or use a wrapper like opencv_latest.sh"
	exit 1
fi
if [[ -z "$dldir" ]]; then
	dldir=OpenCV
fi
echo "Installing OpenCV" $version
mkdir -p $dldir
cd $dldir
echo "Installing Dependencies"
sudo yum -y install http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
sudo yum -y groupinstall "Development Tools"
sudo yum -y install wget unzip opencv opencv-devel gtk2-devel cmake

wget https://github.com/opencv/opencv/archive/${version}.zip
unzip ${version}.zip
rm ${version}.zip
mv opencv-${version} OpenCV
cd OpenCV
mkdir build
cd build
cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON -DENABLE_PRECOMPILED_HEADERS=OFF ..
make -j 4
sudo make install
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
echo "OpenCV" $version "ready to be used"
