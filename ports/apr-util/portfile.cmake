# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(${CMAKE_TRIPLET_FILE})
include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/apr-util-1.5.4)
vcpkg_download_distfile(ARCHIVE
    URLS "https://www.apache.org/dist/apr/apr-util-1.5.4.tar.bz2"
    FILENAME "apr-util-1.5.4.tar.bz2"
    SHA512 ca877d8e444218c4ba0f28063ee075ddcd6c0a487b692dc80ef442fe775ec4eeb337c6957853772e8082e27edcb450d7e909c2c6c3ab4a95bbf0a5ee5ea4a2d1
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS -DINSTALL_PDB=OFF -DAPU_HAVE_CRYPTO=ON -DAPR_INCLUDE_DIR=${CURRENT_INSTALLED_DIR}/include
    # Note: We pass the shared libraries here as we can only pass one library.
    # The static library doesn't really link to the .lib anyway as those libraries
    # are only linked with the final executable
    OPTIONS_RELEASE -DAPR_LIBRARIES=${CURRENT_INSTALLED_DIR}/lib/libapr-1.lib
    OPTIONS_DEBUG -DAPR_LIBRARIES=${CURRENT_INSTALLED_DIR}/debug/lib/libapr-1.lib
)

vcpkg_install_cmake()

# There is no way to suppress installation of the headers in debug builds.
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/apr-util")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/apr-util/LICENSE" "${CURRENT_PACKAGES_DIR}/share/apr-util/copyright")

vcpkg_copy_pdbs()
