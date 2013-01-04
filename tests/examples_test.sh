#!/usr/bin/env bash
if [ ! -f ./examples_test.sh ]
then
    echo "Test failed: You are probably not in the 'tests' directory"
    exit 1
fi
if [ ! -d ../examples ]
then
    echo "Test failed: Did you move the 'tests' or 'examples' directories from their original location?"
    exit 1
fi
if [ ! -f ../source ]
then
    echo "Test failed: Did you forget to run make?"
    exit 1
fi
mkdir -p work
rm -f work/examples_output.log
cd ../examples
./run_all.sh | tee ../tests/work/examples_output.log
cd ../tests
diff --ignore-space-change --ignore-blank-lines -q work/examples_output.log expected_output.log
if [ $? -eq 0 ]
then
    echo "Test succeeded"
else
    echo "Test failed: Running the examples didn't give the expected output"
    echo "Log file: work/examples_output.log"
fi
