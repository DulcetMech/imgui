#
# ImGui Library
#
cmake_minimum_required(VERSION 3.6.0)


##################################################################################################################
# Setup (change imgui version according to your needs)
##################################################################################################################
project(imgui
        VERSION 1.00
        LANGUAGES CXX
        DESCRIPTION "ImGui library."
)


#set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/${OUTPUT_DIR})
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/${OUTPUT_DIR})
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/${OUTPUT_DIR})
#set(CMAKE_PDB_OUTPUT_DIRECTORY     ${CMAKE_BINARY_DIR}/bin/${OUTPUT_DIR})

set(CMAKE_VERBOSE_MAKEFILE TRUE)

if (WIN32)
  if (IMGUI_STATIC_LIBRARY)
    message(STATUS "[INFO] Building library as --> Static Library")
    set(BUILD_SHARED_LIBS OFF)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS OFF)
  else()
    message(STATUS "[INFO] Building library as --> DLL")
    set(BUILD_SHARED_LIBS ON)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
  endif()
endif()

set(SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(EXAMPLES_DIR ${SOURCE_DIR}/examples)
set(FONTS_DIR ${SOURCE_DIR}/misc/fonts)


##################################################################################################################
# Project Files
##################################################################################################################
set(HEADERS_CXX_FILES 
    ${SOURCE_DIR}/imgui.h
    ${SOURCE_DIR}/imconfig.h
    ${SOURCE_DIR}/imgui_internal.h
    ${SOURCE_DIR}/imstb_rectpack.h
    ${SOURCE_DIR}/imstb_textedit.h
    ${SOURCE_DIR}/imstb_truetype.h
)

set(SOURCES_CXX_FILES 
    ${SOURCE_DIR}/imgui.cpp
    ${SOURCE_DIR}/imgui_draw.cpp
    ${SOURCE_DIR}/imgui_widgets.cpp
    ${SOURCE_DIR}/imgui_demo.cpp
)

file(GLOB FONTS_FILES ${FONTS_DIR}/*.ttf)

set(HEADERS_CXX_IMPL_FILES)
set(SOURCES_CXX_IMPL_FILES)
if (IMGUI_WITH_IMPL)
  Init_Impl_Files(HEADERS_CXX_IMPL_FILES SOURCES_CXX_IMPL_FILES)
endif()


##################################################################################################################
# IDE Representation
##################################################################################################################
# Groups CMake pre-defined projects:
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

source_group("Header Files" FILES
    ${HEADERS_CXX_FILES}
)

source_group("Source Files" FILES
    ${SOURCES_CXX_FILES}
)




##################################################################################################################
# Target
##################################################################################################################
add_library(${PROJECT_NAME} 
	STATIC
    ${HEADERS_CXX_FILES}
    ${SOURCES_CXX_FILES}
)
target_include_directories(${PROJECT_NAME} PUBLIC 
    ${SOURCE_DIR}
)
if(IMGUI_IMPL_DX12 AND NOT IMGUI_STATIC_LIBRARY)
    target_link_libraries(${PROJECT_NAME} PUBLIC d3d12)
endif()

##################################################################################################################
# Target properties
##################################################################################################################
set_target_properties (imgui PROPERTIES
    FOLDER vendors
)

##################################################################################################################
# Target Install
##################################################################################################################
set (DISTRIBUTE_DIR ${CMAKE_BINARY_DIR}/dist/${OUTPUT_DIR})
install(
    TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${DISTRIBUTE_DIR}/bin
    LIBRARY DESTINATION ${DISTRIBUTE_DIR}/lib
    ARCHIVE DESTINATION ${DISTRIBUTE_DIR}/lib
)
install(
    FILES ${HEADERS_CXX_FILES} ${HEADERS_CXX_IMPL_FILES}
    DESTINATION ${DISTRIBUTE_DIR}/include
)
install(
    FILES ${FONTS_FILES}
    DESTINATION ${DISTRIBUTE_DIR}/misc/fonts
)

# Install PDB files for VS builds to enable debugging:
if (MSVC)
  if (NOT IMGUI_STATIC_LIBRARY)
    install(
        FILES $<TARGET_PDB_FILE:${PROJECT_NAME}> 
        DESTINATION ${DISTRIBUTE_DIR}/lib
        CONFIGURATIONS Debug OR RelWithDebInfo
        COMPONENT libraries
        OPTIONAL
    )
  else()
    install(
        FILES 
          $<$<CONFIG:Debug>:${CMAKE_BINARY_DIR}/bin/${OUTPUT_DIR}/${PROJECT_NAME}.pdb>
          $<$<CONFIG:RelWithDebInfo>:${CMAKE_BINARY_DIR}/${PROJECT_NAME}.dir/${OUTPUT_DIR}/${PROJECT_NAME}.pdb>
        DESTINATION ${DISTRIBUTE_DIR}/lib
        CONFIGURATIONS Debug OR RelWithDebInfo
        COMPONENT libraries
        OPTIONAL
    )
  endif()
endif()