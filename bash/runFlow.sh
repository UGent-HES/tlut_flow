dir=$1

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sourcedir=${scriptdir:0:${#scriptdir}-4}
. $sourcedir/source
export PATH=/opt/Python-2.7.2/bin:$PATH
cd $dir
./tmap.py
