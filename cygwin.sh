VERBOSE="VERBOSE=1"

export CXXFLAGS="-I/usr/local/include -I/usr/local/include/catch2"
export CXXFLAGS="$CXXFLAGS -D_GNU_SOURCE=1"

export CFLAGS="$CXXFLAGS"

# my additions

# flag settings
FLAGS="$FLAGS -DCMAKE_INSTALL_PREFIX=/tmp/netcdf"
FLAGS="$FLAGS -DTILEDB_SUPERBUILD=OFF"
FLAGS="$FLAGS -DTILEDB_WERROR=OFF"
FLAGS="$FLAGS -DTILEDB_TBB=OFF"
FLAGS="$FLAGS -DTILEDB_STATIC=ON"
#FLAGS="$FLAGS -DTILEDB_TESTS=OFF"
#FLAGS="$FLAGS -DTILEDB_FORCE_ALL_DEPS=ON"
#FLAGS="$FLAGS -DTILEDB_VERBOSE=ON"
#FLAGS="$FLAGS -DTILEDB_HDFS=ON"
#FLAGS="$FLAGS -DTILEDB_CPP_API=OFF"
#FLAGS="$FLAGS -DTILEDB_CMAKE_IDE=ON"
#FLAGS="$FLAGS -DTILEDB_TESTS_AWS_S3_CONFIG=ON"
#FLAGS="$FLAGS -DTILEDB_TBB_SHARED=ON"
#FLAGS="$FLAGS -DTILEDB_S3=ON"
FLAGS="$FLAGS -DTILEDB_FILTERS=dd,rle" # New flag
FLAGS="$FLAGS -DTILEDB_EXAMPLES=OFF" # New flag

# externals
FLAGS="$FLAGS -DSPDLOG_INCLUDE_DIR=/cygdrive/d/git/TileDB/external/include"
FLAGS="$FLAGS -DCATCH_INCLUDE_DIR=/cygdrive/d/git/TileDB/external/include"

rm -fr build
mkdir build
cd build

# Fixes
FLAGS="$FLAGS -DCMAKE_CXX_STANDARD=14"
FLAGS="$FLAGS -DCMAKE_CXX_EXTENSIONS=OFF"
FLAGS="$FLAGS -DCMAKE_CXX_STANDARD_REQUIRED=ON"

cmake "${G}" $FLAGS ..
make $VERBOSE all
make check

exit
