#!/bin/bash

# Simplest ever interface, every command/process always returns an exit value
$?

# Example creating/deleting/showing files

# returns 0 = exit without errors
echo "Hello scripting" > test.txt
echo $?

# returns 1 = exit with an error
rm  test2.txt
echo $?

# redirecting stderr and stdout to a file
rm  test.txt 2> stderr 1> stdout
rm  test2.txt 2> stderr 1> stdout

cat test.txt 2> stderr 1> stdout
cat test2.txt 2> stderr 1> stdout