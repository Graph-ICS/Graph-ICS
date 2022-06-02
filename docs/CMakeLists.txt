find_package(Doxygen REQUIRED)
find_package(Sphinx REQUIRED)

set(DOXYGEN_INPUT ${APP_SOURCE_DIR}/model/node.h ${APP_SOURCE_DIR}/model/port.h)

list(JOIN DOXYGEN_INPUT " " DOXYGEN_INPUT)

set(DOXYGEN_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/doxygen)
set(DOXYGEN_INDEX_FILE ${DOXYGEN_OUTPUT_DIR}/xml/index.xml)

set(DOXYFILE_IN ${CMAKE_CURRENT_SOURCE_DIR}/doxygen/DoxyFile)
set(DOXYFILE_OUT ${CMAKE_CURRENT_BINARY_DIR}/doxygen/Doxyfile.out)
configure_file(${DOXYFILE_IN} ${DOXYFILE_OUT} @ONLY)

# create doxygen directory if not there
file(MAKE_DIRECTORY ${DOXYGEN_OUTPUT_DIR})

add_custom_target(
  Doxygen ALL
  DEPENDS ${DOXYFILE_OUT}
  COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE_OUT}
  COMMENT "Generating API documentation with Doxygen"
  VERBATIM)

set(SPHINX_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/sphinx)
set(SPHINX_BUILD ${CMAKE_CURRENT_BINARY_DIR}/sphinx)
set(SPHINX_INDEX_FILE ${SPHINX_BUILD}/index.html)

add_custom_target(
  Sphinx ALL
  DEPENDS ${SPHINX_SOURCE}/index.rst ${SPHINX_SOURCE}/conf.py
  COMMAND
    ${SPHINX_EXECUTABLE} -b html
    # Tell Breathe where to find the Doxygen output
    -Dbreathe_projects.Graph-ICS=${DOXYGEN_OUTPUT_DIR}/xml ${SPHINX_SOURCE}
    ${SPHINX_BUILD}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Generating documentation with Sphinx")

add_dependencies(Sphinx Doxygen)
