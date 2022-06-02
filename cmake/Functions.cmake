macro(HEADER_DIRECTORIES relative_path return_list)
  file(GLOB_RECURSE new_list ${relative_path}/*.h ${relative_path}/*.hpp)

  set(dir_list "")

  foreach(file_path ${new_list})
    get_filename_component(dir_path ${file_path} PATH)
    set(dir_list ${dir_list} ${dir_path})
  endforeach()

  list(REMOVE_DUPLICATES dir_list)
  set(${return_list} ${dir_list})
endmacro()

function(CopyOpenCVlibs target directory)
  if(APPLE)
    file(GLOB list_globbed ${OpenCV_DIR}/lib/*.dylib)
  elseif(UNIX)
    file(GLOB list_globbed ${OpenCV_DIR}/lib/*.so.405)
  elseif(WIN32)
    file(GLOB list_globbed ${OpenCV_DIR}/bin/${CMAKE_BUILD_TYPE}/*.dll)
  endif()

  foreach(file ${list_globbed})
    add_custom_command(
      TARGET ${target}
      POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${file} ${directory})
  endforeach()

endfunction()

function(AddNodeProviderOutputEntries node_list node_includes node_registration)
  set(includes "")
  set(registration "")

  foreach(NODE IN LISTS ${node_list})
    string(TOLOWER ${NODE} HELP_VAR)
    set(HELP_VAR "#include \"${HELP_VAR}.h\"\n")
    string(APPEND includes "${HELP_VAR}")
    set(HELP_VAR
        "qmlRegisterType<G::${NODE}>(\"Model.${NODE}\", 1, 0, \"${NODE}Model\")<semicolon>\n\t"
    )
    string(APPEND registration "${HELP_VAR}")
  endforeach()

  string(APPEND ${node_includes} ${includes})
  string(APPEND ${node_registration} ${registration})

  set(${node_includes}
      ${${node_includes}}
      PARENT_SCOPE)

  set(${node_registration}
      ${${node_registration}}
      PARENT_SCOPE)

endfunction()

function(AddNodeProviderEntries node_list node_includes node_registration)

  set(includes "")
  set(registration "")

  foreach(NODE IN LISTS ${node_list})
    string(TOLOWER ${NODE} HELP_VAR)
    if(${NODE} STREQUAL "Image") # fix confict in Image Node include
      set(HELP_VAR "#include \"model/input/${HELP_VAR}.h\"\n")
    else()
      set(HELP_VAR "#include \"${HELP_VAR}.h\"\n")
    endif()
    string(APPEND includes "${HELP_VAR}")
    set(HELP_VAR
        "qmlRegisterType<G::${NODE}>(\"Model.${NODE}\", 1, 0, \"${NODE}Model\")<semicolon>\n\tm_nodeList.append(\"${NODE}\")<semicolon>\n\t"
    )
    string(APPEND registration "${HELP_VAR}")
  endforeach()

  string(APPEND ${node_includes} ${includes})
  string(APPEND ${node_registration} ${registration})

  set(${node_includes}
      ${${node_includes}}
      PARENT_SCOPE)

  set(${node_registration}
      ${${node_registration}}
      PARENT_SCOPE)

endfunction()
