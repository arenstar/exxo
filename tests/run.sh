#!/bin/bash -ue

topdir=$(git rev-parse --show-toplevel)
orig_python=$(which python3)

function _exxo {
    PYTHONPATH="$topdir:${PYTHONPATH:-}" "$orig_python" -m exxo.exxo $@
}

function run_inzip_test {
    pyversion="$1"
    shift
    args="$@"
    rm -rf inzip/env inzip/dist
    _exxo venv -p "$pyversion" inzip/env
    set +u
    . inzip/env/bin/activate
    make -C inzip clean all
    _exxo build -s inzip
    deactivate
    set -u
    ( cd inzip/dist && ./inzip -rx -v $args --pyarg inzip )
}


run_inzip_test 3.4
# TODO: figure out why --assert=plain is needed
run_inzip_test 2.7 --assert=plain
