function(AddSources rel_path group_name list_src)
  message(STATUS "   > ${rel_path} >> ${group_name}")
   include_directories(${rel_path})
  file(GLOB list_globbed "${rel_path}/*.h" "${rel_path}/*.cpp" "${rel_path}/*.cxx" "${rel_path}/*.hpp")
  foreach(file ${list_globbed})
    message(STATUS "     - ${file}")
  endforeach()
  set(list_return ${list_globbed} ${${list_src}})
  set(${list_src} ${list_return} PARENT_SCOPE)
  source_group(${group_name} FILES ${list_globbed})
endfunction()

function(AddResources rel_path group_name list_res)
  message(STATUS "   > ${rel_path} >> ${group_name}")
  file(GLOB list_globbed "${rel_path}/*.qml" "${rel_path}/*.png" "${rel_path}/*.ttf" "${rel_path}/*.js" "${rel_path}/*.json" "${rel_path}/*.jpg" "${rel_path}/*.gif" "${rel_path}/*.svg")
  foreach(file ${list_globbed})
    message(STATUS "     - ${file}")
  endforeach()
  source_group(${group_name} FILES ${list_globbed})
  set(list_return ${list_globbed} ${${list_res}})
  set(${list_res} ${list_return} PARENT_SCOPE)
endfunction()

macro(HEADER_DIRECTORIES relative_path return_list)
    FILE(GLOB_RECURSE new_list "${relative_path}/*.h")
    SET(dir_list "")

    FOREACH(file_path ${new_list})
        GET_FILENAME_COMPONENT(dir_path ${file_path} PATH)
        SET(dir_list ${dir_list} ${dir_path})
    ENDFOREACH()

    LIST(REMOVE_DUPLICATES dir_list)
    SET(${return_list} ${dir_list})
endmacro()
