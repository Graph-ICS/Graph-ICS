# Examples
# ******************************************************************************
message(STATUS "")
message(STATUS "Graph-ICS Examples - Setup")

if(GRAPHICS_PLUGIN_REMOTE)
  add_subdirectory(remoteCommunication)

  include(remoteCommunication/client/Nodes.cmake)
  addnodeproviderentries(REMOTE_EXAMPLE_CLIENT_NODES NODEPROVIDER_INCLUDES
                         NODEPROVIDER_REGISTRATION)

  set(NODEPROVIDER_INCLUDES
      ${NODEPROVIDER_INCLUDES}
      PARENT_SCOPE)

  set(NODEPROVIDER_REGISTRATION
      ${NODEPROVIDER_REGISTRATION}
      PARENT_SCOPE)

else()
  message(
    FATAL_ERROR
      "The Graph-ICS Remote plugin needs to be enabled to build the remoteCommunication example! (Enable CMake cache variable GRAPHICS_BUILD_PLUGINS and GRAPHICS_PLUGIN_REMOTE)"
  )
endif()

message(STATUS "Finished")
