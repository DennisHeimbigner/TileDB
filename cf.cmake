VERBOSE="VERBOSE=1"

for arg in "$@" ; do
case "$arg" in
vs|VS) VS=1 ;;
linux|nix|l|x) unset VS ;;
nobuild|nb) NOBUILD=1 ;;
*) echo "defaulting to linux"; unset VS ;;
esac
done

if test "x$VS" = x1 ; then
  if test "x$2" = xsetup ; then
    VSSETUP=1
  else
    unset VSSETUP
  fi
fi

if test "x$VSSETUP" = x1 ; then
CFG="Debug"
else
CFG="Release"
fi

export CXXFLAGS="-I/usr/local/include -I/usr/local/include/catch2"
export CFLAGS="$CXXFLAGS"

FLAGS="$FLAGS -DCMAKE_INSTALL_PREFIX=/tmp/netcdf"
#FLAGS="$FLAGS -DTILEDB_SUPERBUILD=OFF"
#FLAGS="$FLAGS -DTILEDB_FORCE_ALL_DEPS=ON"
#FLAGS="$FLAGS -DTILEDB_VERBOSE=ON"
#FLAGS="$FLAGS -DTILEDB_S3=ON"
#FLAGS="$FLAGS -DTILEDB_HDFS=ON"
FLAGS="$FLAGS -DTILEDB_WERROR=OFF"
#FLAGS="$FLAGS -DTILEDB_CPP_API=OFF"
#FLAGS="$FLAGS -DTILEDB_CMAKE_IDE=ON"
FLAGS="$FLAGS -DTILEDB_TBB=OFF"
#FLAGS="$FLAGS -DTILEDB_TBB_SHARED=ON"
FLAGS="$FLAGS -DTILEDB_STATIC=ON"
FLAGS="$FLAGS -DTILEDB_COMPRESSORS=dd,rle"

rm -fr build
mkdir build
cd build

if test "x$VS" != x ; then

# Visual Studio
CFG="Release"
NCLIB="${NCLIB}/liblib"
export PATH="${NCLIB}:${PATH}"
#G=
cmake "$G" -DCMAKE_BUILD_TYPE=${CFG} $FLAGS ..
if test "x$NOBUILD" = x ; then
cmake --build . --config ${CFG}
cmake --build . --config ${CFG} --target RUN_TESTS
fi

else # GCC

FLAGS="$FLAGS -DCMAKE_CXX_STANDARD=14"
#FLAGS="$FLAGS -DCMAKE_CXX_EXTENSIONS=OFF"
#FLAGS="$FLAGS -DCMAKE_CXX_STANDARD_REQUIRED=ON"

cmake "${G}" $FLAGS ..
if test "x$NOBUILD" == x ; then
make $VERBOSE all
make check
fi
fi
exit
