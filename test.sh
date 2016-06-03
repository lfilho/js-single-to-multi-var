#!/usr/bin/env sh

cp ./test-original.js ./test-temp.js

vim -u ./vimrc -e -s -S ./to-multi-var.vim +SingleToMultiVar +wq ./test-temp.js

diff ./test-temp.js ./test-good.js
hasDifference=$?

if [ $hasDifference -eq 0 ]; then
    echo 'TEST PASSED! File contents matched.'
else
    echo
    echo 'TEST FAILED! File contents differed.'
fi

rm ./test-temp.js

exit $hasDifference
