#!bin/bash
sudo -
echo "Check CPU information------"
echo ""
echo "Check Current CPU Clock"
CCPU_CLOCK=`lscpu | grep -i "CPU MHz:"`
echo $CCPU_CLOCK

echo "Check Max CPU Clock"
MCPU_CLOCK=`lscpu | grep -i "max"`
echo $MCPU_CLOCK

echo "Check Min CPU Clock"
NCPU_CLOCK=`lscpu | grep -i "min"`
echo $NCPU_CLOCK


echo "Check Memory information----"
echo ""
echo "Check Memory size"
MEMORY_SIZE=`cat /proc/meminfo |grep MemTotal`
echo $MEMORY_SIZE

echo "Check Main Memory Bank info"
TOTALBANK=`dmidecode -t memory | grep Bank|wc -l`
CBANK=`dmidecode -t memory | grep Bank|wc -l`
echo "$CBANK/$TOTALBANK"
echo "Channel per bank"
dmidecode -t memory | grep Bank

SWAP=`cat /proc/swaps | wc -l`
echo ""

if [ "$SWAP" = "1" ]
then
        echo "Swap is -off-, there is no concern for swap memory."
else
        echo "Swap is -on-, data might load from harddisk"
fi

echo ""
echo ""
echo "Intel CPU HPL is starting,it might take few minutes"
file="l_mklb_p_2019.6.005.tgz"
if [ -f "$file" ]
then
        echo "$file found. Skip for downloading linpack."
        cd l_mklb_p_2019.6.005/benchmarks_2019/linux/mkl/benchmarks/linpack
        ./runme_xeon64 2>&1
        HPL_Result=`cat lin_xeon64.txt | grep 45000| grep pass | cut -d " " -f16`
        echo ""
        echo "CPU HPL result= ${HPL_Result} GFLOPS"
else
        echo "$file not found."
        echo "Dowloading oxford model ..."
        wget https://software.intel.com/sites/default/files/managed/cc/19/$file
        tar xvf l_mklb_p_2019.6.005.tgz
        cd l_mklb_p_2019.6.005/benchmarks_2019/linux/mkl/benchmarks/linpack
        ./runme_xeon64  2>&1
        HPL_Result=`cat lin_xeon64.txt | grep 45000| grep pass | cut -d " " -f16`
        echo ""
        echo "CPU HPL result= ${HPL_Result} GFLOPS"

fi
