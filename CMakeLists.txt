# Project setup
# ******************************************************************************

cmake_minimum_required(VERSION 3.14)

string(TIMESTAMP BUILD_DATE "%Y-%m-%d")

project(
  "Graph-ICS"
  VERSION "1.0"
  DESCRIPTION
    "Graph-ICS is an open-source tool to define, filter and visualize image and data streams."
  HOMEPAGE_URL "https://github.com/Graph-ICS/Graph-ICS"
  LANGUAGES CXX)

set(GRAPHICS_CAMERA_USAGE
    "Graph-ICS uses camera to filter and record camera streams.")

if(CMAKE_BUILD_TYPE STREQUAL "Release")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/package/package.xml.in
                 ${CMAKE_CURRENT_BINARY_DIR}/package/package.xml)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/package/installscript.js
                 ${CMAKE_CURRENT_BINARY_DIR}/package/installscript.js COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt
                 ${CMAKE_CURRENT_BINARY_DIR}/package/LICENSE.txt COPYONLY)
endif()

# Set CMake Test Program to be a library (Fix 'C Comiler not able to compile a
# simple test program' Bug)
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Add CMake custom functions
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/cmake;")
include(Functions)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Libraries
# ******************************************************************************

# Qt
set(QT_VERSION "5.15.2")

set(QT_MODULES
    Core
    Widgets
    Gui
    Quick
    Qml
    Concurrent
    Svg
    Charts
    Multimedia
    WebEngine)

find_package(Qt5 ${QT_VERSION} CONFIG REQUIRED ${QT_MODULES})

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

add_compile_options(${QT_DEFINITIONS})
add_compile_options(-DUSE_INSTALL_TARGET)
add_compile_options(-DQT_QML_RELEASE)
add_compile_options(${Qt5Widgets_DEFINITIONS} ${QtQml_DEFINITIONS}
                    ${${Qt5Quick_DEFINITIONS}})

# ITK
set(ITK_VERSION "5.2.1")
find_package(ITK ${ITK_VERSION} REQUIRED)
include(${ITK_USE_FILE})

# OpenCV
set(OPENCV_VERSION "4.5.5")
find_package(OpenCV ${OPENCV_VERSION} REQUIRED)

# App
# ******************************************************************************

message(STATUS "")
message(STATUS "Graph-ICS - Setup")

set(NODEPROVIDER_INCLUDES "")
set(NODEPROVIDER_REGISTRATION "")

add_subdirectory(app)

# Plugins
# ******************************************************************************
add_subdirectory(plugins)

# Examples
# ******************************************************************************
option(GRAPHICS_BUILD_EXAMPLES "Build the Examples" OFF)
if(GRAPHICS_BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()

# Code generation (nodeprovider.cpp, gappinfo.h)
# ******************************************************************************
message(STATUS "")
message(STATUS "Graph-ICS - Code Generation")
# Generate gappinfo.cpp
message(STATUS "Generating GAppInfo...")
set(APPINFO_H_PATH ${CMAKE_CURRENT_BINARY_DIR}/app/gappinfo.h)
configure_file(app/src/gappinfo.h.in ${APPINFO_H_PATH})
message(STATUS "Finished ${APPINFO_H_PATH}")

# fix c++ code line ending. ";" gets removed because cmake thinks that the
# entries define a list (cmake standard list seperator is ";")
string(REPLACE "<semicolon>" ";" NODEPROVIDER_REGISTRATION
               "${NODEPROVIDER_REGISTRATION}")

message(STATUS "Generating NodeProvider...")
# Generate code from NODEPROVIDER_INCLUDES and NODEPROVIDER_REGISTRATION
set(NODEPROVIDER_CPP_PATH ${CMAKE_CURRENT_BINARY_DIR}/app/nodeprovider.cpp)
configure_file(app/src/nodeprovider.cpp.in ${NODEPROVIDER_CPP_PATH})

message(STATUS "Finished ${NODEPROVIDER_CPP_PATH}")

target_sources(${PROJECT_NAME} PRIVATE ${NODEPROVIDER_CPP_PATH}
                                       ${APPINFO_H_PATH})

message(STATUS "")

# Documentation (Doxygen, Sphinx, Breathe)
# ******************************************************************************

set(APP_SOURCE_DIR ${CMAKE_SOURCE_DIR}/app/src)

option(GRAPHICS_BUILD_DOCUMENTATION "Build the API documentation" OFF)

if(GRAPHICS_BUILD_DOCUMENTATION)

  message(STATUS "Graph-ICS API Documentation - Setup")

  add_subdirectory(docs)

  message(STATUS "Finished")

  message(STATUS "")
endif()
