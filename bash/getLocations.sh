xdlFile=$1
nameFile=$2
locFile=$3

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $scriptdir
sourcedir=${scriptdir:0:${#scriptdir}-4}
echo $sourcedir
export RAPIDSMITH_PATH=$sourcedir/third_party/rapidSmith
#export RAPIDSMITH_PATH=~/recomp/tools/rapidSmith/trunk/rapidSmith-0.5.1/
java -jar $sourcedir/third_party/rapidSmith/ExtractInfo.jar $xdlFile $nameFile $locFile

