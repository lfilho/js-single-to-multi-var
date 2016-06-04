#!/usr/bin/env bash

goodFile='./test-good.js'
orignalFile='./test-original.js'
tempFile='./test-temp.js'

cp "$orignalFile" "$tempFile"

./to-multi-var "$tempFile"

diff "$tempFile" "$goodFile"
hasDifference=$?

if [ $hasDifference -eq 0 ]; then
    echo '✓ TEST PASSED! File contents matched.'
else
    echo
    echo "✗ TEST FAILED! See contents' difference above."
fi

rm "$tempFile"

exit $hasDifference
