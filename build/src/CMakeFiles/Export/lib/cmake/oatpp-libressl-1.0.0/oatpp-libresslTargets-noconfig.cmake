#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "oatpp::oatpp-libressl" for configuration ""
set_property(TARGET oatpp::oatpp-libressl APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(oatpp::oatpp-libressl PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/oatpp-1.0.0/liboatpp-libressl.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS oatpp::oatpp-libressl )
list(APPEND _IMPORT_CHECK_FILES_FOR_oatpp::oatpp-libressl "${_IMPORT_PREFIX}/lib/oatpp-1.0.0/liboatpp-libressl.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
