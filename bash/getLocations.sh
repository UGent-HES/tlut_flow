xdlFile=$1
nameFile=$2
locFile=$3

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sourcedir=${scriptdir:0:${#scriptdir}-4}
export RAPIDSMITH_PATH=$sourcedir/third_party/rapidSmith
java -jar $sourcedir/third_party/rapidSmith/ExtractInfo.jar $xdlFile $nameFile $locFile

