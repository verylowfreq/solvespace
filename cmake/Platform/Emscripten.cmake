set(EMSCRIPTEN 1)

set(CMAKE_C_OUTPUT_EXTENSION   ".o")
set(CMAKE_CXX_OUTPUT_EXTENSION ".o")
set(CMAKE_EXECUTABLE_SUFFIX    ".html")

set(CMAKE_SIZEOF_VOID_P 4)

set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

# WORKAROUND: Disable pixman's local thread storage support.
add_compile_definitions(PIXMAN_NO_TLS)

# WORKAROUND: For developers to debug
add_compile_options(-g)
add_link_options(-sASSERTIONS=1 -sDYNCALLS=1)

# WORKAROUND: Suppress non-c-typedef-for-linkage warnings in solvespace.h
add_compile_options(-Wno-non-c-typedef-for-linkage)
