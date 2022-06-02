# App
# ******************************************************************************

# Graph-ICS Application

set(PLATFORM_ICON)

set(GRAPHICS_OUTPUT "${CMAKE_BINARY_DIR}/bin")

# Specify the platform specific executable
if(APPLE)
  message(STATUS "Target Platform: MacOS")

  set(MACOSX_BUNDLE_ICON_FILE
      logo.icns
      PARENT_SCOPE)

  set(PLATFORM_ICON img/logo.icns)

  set_source_files_properties(${PLATFORM_ICON}
                              PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

  set(OPENCV_AVFOUNDATION_SKIP_AUTH 0)
  set(CMAKE_MACOSX_BUNDLE ON)

  add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${PLATFORM_ICON})

  set_target_properties(
    ${PROJECT_NAME}
    PROPERTIES MACOSX_BUNDLE_NAME ${PROJECT_NAME}
               MACOSX_BUNDLE_INFO_PLIST
               ${CMAKE_SOURCE_DIR}/platform/Info.plist.in)

elseif(UNIX)
  message(STATUS "Target Platform: Linux")

  add_executable(${PROJECT_NAME} "")
  # fix Ubuntu 18.04 mistaking executable as shared library
  target_link_options(${PROJECT_NAME} PUBLIC -no-pie)

  configure_file(${CMAKE_SOURCE_DIR}/platform/Graph-ICS.desktop.in
                 ${GRAPHICS_OUTPUT}/${PROJECT_NAME}.desktop)

  set(PLATFORM_ICON img/logo_256px.png)
  configure_file(${PLATFORM_ICON} ${GRAPHICS_OUTPUT}/${PROJECT_NAME}.png
                 COPYONLY)

elseif(WIN32)
  message(STATUS "Target Platform: Windows")

  set(PLATFORM_ICON img/myapp.rc)

  add_executable(${PROJECT_NAME} WIN32 ${PLATFORM_ICON})

  copyopencvlibs(${PROJECT_NAME} ${GRAPHICS_OUTPUT}/${CMAKE_BUILD_TYPE})

else()
  message(FATAL_ERROR "Platform not supported!")
endif()

include(Nodes.cmake)

# Register all Input and Filter Nodes
set(NODES ${INPUT_NODES} ${GENERIC_NODES} ${ITK_NODES} ${OPENCV_NODES}
          ${QT_NODES})
addnodeproviderentries(NODES NODEPROVIDER_INCLUDES NODEPROVIDER_REGISTRATION)

# Register the Output Nodes
addnodeprovideroutputentries(OUTPUT_NODES NODEPROVIDER_INCLUDES
                             NODEPROVIDER_REGISTRATION)

set(NODEPROVIDER_INCLUDES
    ${NODEPROVIDER_INCLUDES}
    PARENT_SCOPE)

set(NODEPROVIDER_REGISTRATION
    ${NODEPROVIDER_REGISTRATION}
    PARENT_SCOPE)

set(RESOURCES qml/qml.qrc img/img.qrc font/font.qrc)
qt5_add_resources(QT_RESOURCES ${RESOURCES})

set(QML_IMPORT_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/qml"
    CACHE STRING "Path to QML Files")

set_target_properties(
  ${PROJECT_NAME}
  PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
             LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
             RUNTIME_OUTPUT_DIRECTORY "${GRAPHICS_OUTPUT}")

header_directories(src APP_INCLUDE_DIRS)
target_include_directories(${PROJECT_NAME} PRIVATE ${APP_INCLUDE_DIRS}
                                                   ${CMAKE_CURRENT_BINARY_DIR})

file(GLOB_RECURSE APP_SOURCES src/*.h src/*.hpp src/*.cpp src/*.cc)
target_sources(${PROJECT_NAME} PRIVATE ${APP_SOURCES} ${QT_RESOURCES})

target_link_libraries(
  ${PROJECT_NAME}
  PUBLIC Qt5::Core
  PUBLIC Qt5::Gui
  PUBLIC Qt5::Quick
  PUBLIC Qt5::Qml
  PUBLIC Qt5::Svg
  PUBLIC Qt5::Charts
  PUBLIC Qt5::WebEngine
  PUBLIC ${ITK_LIBRARIES}
  PUBLIC ${OpenCV_LIBS})

source_group("src" FILES ${APP_SOURCES})
source_group("res" FILES ${PLATFORM_ICON} ${RESOURCES})
