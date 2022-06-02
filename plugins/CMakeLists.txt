# Plugins
# ******************************************************************************

option(GRAPHICS_PLUGIN_REMOTE "Enable Remote Plugin" OFF)

if(GRAPHICS_PLUGIN_REMOTE)

  set(REMOTE_PLUGIN_ENABLED
      "true"
      PARENT_SCOPE)

  add_subdirectory(remote)

else()
  # needed for code generation in GAppInfo
  set(REMOTE_PLUGIN_ENABLED
      "false"
      PARENT_SCOPE)
endif()
