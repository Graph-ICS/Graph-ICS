#
# Copyright by The HDF Group.
# All rights reserved.
#
# This file is part of HDF5.  The full HDF5 copyright notice, including
# terms governing use, modification, and redistribution, is contained in
# the COPYING file, which can be found at the root of the source code
# distribution tree, or in https://support.hdfgroup.org/ftp/HDF5/releases.
# If you do not have access to either file, you may request a copy from
# help@hdfgroup.org.
#
# grepTest.cmake executes a command and captures the output in a file. File is then compared
# against a reference file. Exit status of command can also be compared.

# arguments checking
if (NOT TEST_PROGRAM)
  message (FATAL_ERROR "Require TEST_PROGRAM to be defined")
endif ()
#if (NOT TEST_ARGS)
#  message (STATUS "Require TEST_ARGS to be defined")
#endif ()
if (NOT TEST_FOLDER)
  message ( FATAL_ERROR "Require TEST_FOLDER to be defined")
endif ()
if (NOT TEST_OUTPUT)
  message (FATAL_ERROR "Require TEST_OUTPUT to be defined")
endif ()
#if (NOT TEST_EXPECT)
#  message (STATUS "Require TEST_EXPECT to be defined")
#endif ()
if (NOT TEST_FILTER)
  message (STATUS "Require TEST_FILTER to be defined")
endif ()
if (NOT TEST_REFERENCE)
  message (FATAL_ERROR "Require TEST_REFERENCE to be defined")
endif ()

message (STATUS "COMMAND: ${TEST_PROGRAM} ${TEST_ARGS}")

# run the test program, capture the stdout/stderr and the result var
execute_process (
    COMMAND ${TEST_PROGRAM} ${TEST_ARGS}
    WORKING_DIRECTORY ${TEST_FOLDER}
    RESULT_VARIABLE TEST_RESULT
    OUTPUT_FILE ${TEST_OUTPUT}
    ERROR_FILE ${TEST_OUTPUT}.err
    OUTPUT_VARIABLE TEST_OUT
    ERROR_VARIABLE TEST_ERROR
)

message (STATUS "COMMAND Result: ${TEST_RESULT}")
message (STATUS "COMMAND Error: ${TEST_ERROR}")

# now grep the output with the reference
file (READ ${TEST_FOLDER}/${TEST_OUTPUT} TEST_STREAM)

# TEST_REFERENCE should always be matched
string (REGEX MATCH "${TEST_REFERENCE}" TEST_MATCH ${TEST_STREAM})
string (COMPARE EQUAL "${TEST_REFERENCE}" "${TEST_MATCH}" TEST_RESULT)
if ("${TEST_RESULT}" STREQUAL "0")
  message (FATAL_ERROR "Failed: The output of ${TEST_PROGRAM} did not contain ${TEST_REFERENCE}")
endif ()

string (REGEX MATCH "${TEST_FILTER}" TEST_MATCH ${TEST_STREAM})
if ("${TEST_EXPECT}" STREQUAL "1")
  # TEST_EXPECT (1) interperts TEST_FILTER as NOT to match
  string (LENGTH "${TEST_MATCH}" TEST_RESULT)
  if (NOT "${TEST_RESULT}" STREQUAL "0")
    message (FATAL_ERROR "Failed: The output of ${TEST_PROGRAM} did contain ${TEST_FILTER}")
  endif ()
endif ()

# everything went fine...
message ("Passed: The output of ${TEST_PROGRAM} matched")

