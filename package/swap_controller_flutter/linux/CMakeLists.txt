# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "swap_controller_flutter")
project(${PROJECT_NAME} LANGUAGES CXX)

# Invoke the build for native code shared with the other target platforms.
# This can be changed to accommodate different builds.
# add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")

# # List of absolute paths to libraries that should be bundled with the plugin.
# # This list could contain prebuilt libraries, or libraries created by an
# # external build triggered from this build file.
# set(swap_controller_flutter_bundled_libraries
#   # Defined in ../src/CMakeLists.txt.
#   # This can be changed to accommodate different builds.
#   $<TARGET_FILE:swap_controller_flutter>
#   PARENT_SCOPE
# )


# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(swap_controller_flutter_bundled_libraries
  # Defined in ../src/CMakeLists.txt.
  # This can be changed to accommodate different builds. 
  "${CMAKE_CURRENT_SOURCE_DIR}/lib/libgamepadazkadev.so"
  PARENT_SCOPE
)

