#!/bin/bash

# Choose the default directories
source_dir="source"
build_dir="source/_build"
venv_dir="venv"
tiledb_root_dir="../"
cmake=`which cmake`

make_jobs=1
if [ -n "$(command nproc)" ]; then
  make_jobs=`nproc`
elif [ -n "$(command sysctl -n hw.logicalcpu)" ]; then
  make_jobs=`sysctl -n hw.logicalcpu`
fi

die() {
  echo "$@" 1>&2 ; popd 2>/dev/null; exit 1
}

arg() {
  echo "$1" | sed "s/^${2-[^=]*=}//" | sed "s/:/;/g"
}

# Display bootstrap usage
usage() {
echo '
Usage: '"$0"' [<options>]
    Builds the TileDB ReadTheDocs website locally.

Options: [defaults in brackets after descriptions]
Configuration:
    --help                          print this message

Dependencies:
    c/c++ compiler
    GNU make
    cmake           http://www.cmake.org/
    python3
    pip3
    virtualenv
'
  exit 10
}

setup_venv() {
  if [ ! -d "${venv_dir}" ]; then
    virtualenv "${venv_dir}" || die "could not create virtualenv"
  fi
  source "${venv_dir}/bin/activate" || die "could not activate virtualenv"
  pip install 'Sphinx' \
       'breathe' \
       'sphinx_rtd_theme' || die "could not install doc dependencies"
}

run_doxygen() {
    pushd "$tiledb_root_dir"
    if [ ! -d "build" ]; then
        mkdir build
        pushd build
        ../bootstrap || die "could not bootstrap tiledb"
        popd
    fi
    cd build
    make doc || die "could not build doxygen docs"
    popd
}

build_site() {
    sphinx-build -E -b html -d ${build_dir}/doctrees -j auto -D language=en ${source_dir} ${build_dir}/html || \
        die "could not build sphinx site"
}

run() {
  setup_venv
  run_doxygen
  build_site
  echo "Build complete. Open '${build_dir}/html/index.html' in your browser."
}

run
