# Examples/remoteCommunication
# ******************************************************************************

# Add sources to Graph-ICS target
file(GLOB_RECURSE CLIENT_SOURCES client/*.cpp client/*.cc client/*.hpp
     client/*.h)

target_sources(${PROJECT_NAME} PRIVATE ${CLIENT_SOURCES})

header_directories(client CLIENT_INCLUDE_DIRS)
target_include_directories(${PROJECT_NAME} PRIVATE ${CLIENT_INCLUDE_DIRS})

add_subdirectory(server)

source_group("src" FILES ${CLIENT_SOURCES})
