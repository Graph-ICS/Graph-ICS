# Plugins/remote
# ******************************************************************************

message(STATUS "")
message(STATUS "Graph-ICS Plugin: Remote - Setup")

# Boost 1.71 (matches Ubuntu Boost package version)
set(Boost_USE_STATIC_LIBS ON)
find_package(Boost 1.71 REQUIRED COMPONENTS system date_time regex
                                            serialization thread)

if(UNIX)
  set(CMAKE_CXX_FLAGS "-pthread")
endif(UNIX)

# Protobuf
find_package(Protobuf REQUIRED)

message(STATUS "Generating Entities...")
protobuf_generate_cpp(PROTO_SOURCE PROTO_HEADER Entities.proto)
message(STATUS "Finished ${PROTO_SOURCE}")
message(STATUS "Finished ${PROTO_HEADER}")

set(REMOTE_PLUGIN_SOURCES commthread.cpp commthread.h Connection.cpp
                          Connection.hpp ${PROTO_SOURCE} ${PROTO_HEADER})

add_library(RemotePlugin STATIC ${REMOTE_PLUGIN_SOURCES})

target_include_directories(
  RemotePlugin
  PUBLIC .
  PUBLIC ${CMAKE_CURRENT_BINARY_DIR}
  PUBLIC ${Boost_INCLUDE_DIRS}
  PUBLIC ${Protobuf_INCLUDE_DIRS})

target_link_libraries(
  RemotePlugin
  PRIVATE Qt5::Core
  PUBLIC ${Boost_LIBRARIES}
  PUBLIC ${Protobuf_LIBRARIES})

# link to Graph-ICS target
target_link_libraries(${PROJECT_NAME} PRIVATE RemotePlugin)
