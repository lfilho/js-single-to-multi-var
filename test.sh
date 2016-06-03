#!/usr/bin/env sh

cp ./test-original.js ./test-temp.js

vim -e -s -S ./to-multi-var.vim +SingleToMultiVar +wq ./test-temp.js

diff ./test-temp.js ./test-good.js
hasDifference=$?

echo
if [ $hasDifference -eq 0 ]; then
    echo 'Test passed!'
else
    echo 'TEST FAILED: file contents differed'
fi

rm ./test-temp.js

exit $hasDifference
