import sys

from distutils.core import setup, Extension
from distutils.sysconfig import get_config_vars
from distutils import util

include_dirs = [
    'src/aig/hop',
    'src/base/abc',
    'src/base/cmd',
    'src/base/io',
    'src/base/main',
    'src/bdd/cudd',
    'src/bdd/epd',
    'src/bdd/mtr',
    'src/misc/extra',
    'src/misc/nm',
    'src/misc/st',
    'src/misc/util',
    'src/misc/vec',
    ]
    
define_macros = []
libraries = []
library_dirs = []

if sys.platform == "win32":
    
    define_macros.append( ('WIN32', 1) )
    define_macros.append( ('ABC_DLL', 'ABC_DLLEXPORT') )
    
    libraries.append('abcr')
    library_dirs.append('./lib')

else:

    if get_config_vars()['SIZEOF_VOID_P'] > 4:
        define_macros.append( ('LIN64', 1) )
    else:
        define_macros.append( ('LIN', 1) )

    libraries.append( 'abc' )
    library_dirs.append('.')

ext = Extension(
    '_pyabc',
    ['abc.i'],
    define_macros=define_macros,
    include_dirs = include_dirs,
    library_dirs=library_dirs,
    libraries=libraries
    )

setup(
    name='pyabc',
    version='1.0',
    ext_modules=[ext],
    py_modules=['pyabc']
)
