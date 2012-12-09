#!/usr/bin/env bash
if [ ! -f ../source ]
then
    echo "Test failed: Did you forget to run make?"
    exit 1
fi
. ../source
mkdir -p work
rm -f work/output.log
cd ../examples
./run_all.sh | tee ../tests/work/output.log
cd ../tests
diff --ignore-space-change --ignore-blank-lines -q work/output.log expected_output.log
if [ $? -eq 0 ]
then
    echo "Test succeeded"
else
    echo "Test failed: Running the examples didn't give the expected output"
fi