# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/calcu_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/calcu_autogen.dir/ParseCache.txt"
  "calcu_autogen"
  )
endif()
