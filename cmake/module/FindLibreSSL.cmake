#[=======================================================================[

Copyright (c) 2019 John Norrbin <jlnorrbin@johnex.se>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Some trivial modifications by Alex Benedict on 01/29/2020.

FindBoringSSL
------------

Find the BoringSSL encryption library.

Optional Components
^^^^^^^^^^^^^^^^^^^

This module supports two optional components: SSL and TLS.  Both
components have associated imported targets, as described below.

Imported Targets
^^^^^^^^^^^^^^^^

This module defines the following imported targets:

BoringSSL::Crypto
    The LibreSSL crypto library, if found.

BoringSSL::SSL
    The LibreSSL ssl library, if found. Requires and includes LibreSSL::Crypto automatically.

Result Variables
^^^^^^^^^^^^^^^^

This module will set the following variables in your project:

BORINGSSL_FOUND
    System has the LibreSSL library. If no components are requested it only requires the crypto library.
BORINGSSL_INCLUDE_DIR
    The LibreSSL include directory.
BORINGSSL_CRYPTO_LIBRARY
    The LibreSSL crypto library.
BORINGSSL_SSL_LIBRARY
    The LibreSSL SSL library.
BORINGSSL_LIBRARIES
    All LibreSSL libraries.
BORINGSSL_VERSION
    This is set to $major.$minor.$revision (e.g. 2.6.8).

Hints
^^^^^

Set LIBRESSL_ROOT_DIR to the root directory of an LibreSSL installation.

]=======================================================================]

# Set Hints
set(_BORINGSSL_ROOT_HINTS
        ${BORINGSSL_ROOT_DIR}
        ENV BORINGSSL_ROOT_DIR
        )

# Set Paths
if (WIN32)
    file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _programfiles)
    set(_BORINGSSL_ROOT_PATHS
            "${_programfiles}/BoringSSL"
            )
    unset(_programfiles)
else()
    set(_BORINGSSL_ROOT_PATHS
            "/usr/local/"
            )
endif()

# Combine
set(_BORINGSSL_ROOT_HINTS_AND_PATHS
        HINTS ${_BORINGSSL_ROOT_HINTS}
        PATHS ${_BORINGSSL_ROOT_PATHS}
        )

# Find Include Path
find_path(BORINGSSL_INCLUDE_DIR
        NAMES
        tls.h
        ${_BORINGSSL_ROOT_HINTS_AND_PATHS}
        PATH_SUFFIXES
        include
        )

# Find Crypto Library
find_library(BORINGSSL_CRYPTO_LIBRARY
        NAMES
        libcrypto
        crypto
        NAMES_PER_DIR
        ${_BORINGSSL_ROOT_HINTS_AND_PATHS}
        PATH_SUFFIXES
        lib
        )

# Find SSL Library
find_library(BORINGSSL_SSL_LIBRARY
        NAMES
        libssl
        ssl
        NAMES_PER_DIR
        ${_BORINGSSL_ROOT_HINTS_AND_PATHS}
        PATH_SUFFIXES
        lib
        )


# Set Libraries
set(BORINGSSL_LIBRARIES ${BORINGSSL_CRYPTO_LIBRARY} ${BORINGSSL_SSL_LIBRARY} ${BORINGSSL_TLS_LIBRARY})

# Mark Variables As Advanced
mark_as_advanced(BORINGSSL_INCLUDE_DIR BORINGSSL_LIBRARIES BORINGSSL_CRYPTO_LIBRARY BORINGSSL_SSL_LIBRARY BORINGSSL_TLS_LIBRARY)

# Find Version File
if(BORINGSSL_INCLUDE_DIR AND EXISTS "${BORINGSSL_INCLUDE_DIR}/openssl/opensslv.h")

    # Get Version From File
    file(STRINGS "${BORINGSSL_INCLUDE_DIR}/openssl/opensslv.h" OPENSSLV.H REGEX "#define BORINGSSL_VERSION_TEXT[ ]+\".*\"")

    # Match Version String
    string(REGEX REPLACE ".*\".*([0-9]+)\\.([0-9]+)\\.([0-9]+)\"" "\\1;\\2;\\3" BORINGSSL_VERSION_LIST "${OPENSSLV.H}")

    # Split Parts
    list(GET BORINGSSL_VERSION_LIST 0 BORINGSSL_VERSION_MAJOR)
    list(GET BORINGSSL_VERSION_LIST 1 BORINGSSL_VERSION_MINOR)
    list(GET BORINGSSL_VERSION_LIST 2 BORINGSSL_VERSION_REVISION)

    # Set Version String
    set(BORINGSSL_VERSION "${BORINGSSL_VERSION_MAJOR}.${BORINGSSL_VERSION_MINOR}.${BORINGSSL_VERSION_REVISION}")

endif()

# Set Find Package Arguments
find_package_handle_standard_args(BoringSSL
        REQUIRED_VARS
        BORINGSSL_CRYPTO_LIBRARY
        BORINGSSL_INCLUDE_DIR
        VERSION_VAR
        BORINGSSL_VERSION
        HANDLE_COMPONENTS
        FAIL_MESSAGE
        "Could NOT find BoringSSL, try setting the path to BoringSSL using the BORINGSSL_ROOT_DIR environment variable"
        )

# BoringSSL Found
if(BORINGSSL_FOUND)

    # Set BoringSSL::Crypto
    if(NOT TARGET BoringSSL::Crypto AND EXISTS "${BORINGSSL_CRYPTO_LIBRARY}")

        # Add Library
        add_library(BoringSSL::Crypto UNKNOWN IMPORTED)

        # Set Properties
        set_target_properties(
                BoringSSL::Crypto
                PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${BORINGSSL_INCLUDE_DIR}"
                IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                IMPORTED_LOCATION "${BORINGSSL_CRYPTO_LIBRARY}"
        )

    endif() # BoringSSL::Crypto

    # Set BoringSSL::SSL
    if(NOT TARGET BoringSSL::SSL AND EXISTS "${BORINGSSL_SSL_LIBRARY}")

        # Add Library
        add_library(BoringSSL::SSL UNKNOWN IMPORTED)

        # Set Properties
        set_target_properties(
                BoringSSL::SSL
                PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${BORINGSSL_INCLUDE_DIR}"
                IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                IMPORTED_LOCATION "${BORINGSSL_SSL_LIBRARY}"
                INTERFACE_LINK_LIBRARIES LibreSSL::Crypto
        )

    endif() # BoringSSL::SSL

    

endif(BORINGSSL_FOUND)
