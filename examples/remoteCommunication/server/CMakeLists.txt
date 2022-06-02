cmake_minimum_required(VERSION 3.14)

project("ExampleServer")

file(GLOB_RECURSE SOURCES src/*.hpp src/*.h src/*.cpp)

source_group("src" FILES ${SOURCES})

if(APPLE)
  message(STATUS "Target Platform: MacOS")
  set(CMAKE_MACOSX_BUNDLE ON)

  add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SOURCES})

elseif(UNIX)
  message(STATUS "Target Platform: Linux")

  add_executable(${PROJECT_NAME} ${SOURCES})

elseif(WIN32)
  message(STATUS "Target Platform: Windows")

  add_executable(${PROJECT_NAME} ${SOURCES})

else()
  message(FATAL_ERROR "Platform not supported!")
endif()

target_include_directories(
  ${PROJECT_NAME}
  PUBLIC ${CMAKE_CURRENT_BINARY_DIR}
  PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src
  PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src/skeletons
  PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src/service
  PUBLIC ${OpenCV_INCLUDE_DIRS})

target_link_libraries(
  ${PROJECT_NAME}
  PUBLIC ${OpenCV_LIBS}
  PRIVATE RemotePlugin)
