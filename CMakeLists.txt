cmake_minimum_required(VERSION 3.6)
project(DcoreSDK)
set(CMAKE_CXX_STANDARD 11)

set(SOURCEDIR Sources)
set(TESTDIR Tests)
set(BUILDDIR .build/debug)

file(GLOB_RECURSE SOURCE_FILES ${SOURCEDIR}/*.swift Package.swift)
file(GLOB_RECURSE TEST_FILES ${TESTDIR}/*.swift)

add_custom_target(Build
        COMMAND swift build -v
        BYPRODUCTS .build
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES ${SOURCE_FILES})

add_custom_target(Test
        COMMAND swift test -v
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES ${SOURCE_FILES} ${TEST_FILES}
        )

add_custom_target(Run
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES ${SOURCE_FILES}
        )