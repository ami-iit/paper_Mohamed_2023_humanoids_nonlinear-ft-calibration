################################################################################
#                                                                              #
# Copyright (C) 2023 Fondazione Istitito Italiano di Tecnologia (IIT)          #
# All Rights Reserved.                                                         #
#                                                                              #
################################################################################

# Check the Operative System
if(MSVC OR WIN32)
	set(EXPORT_VAR "set")
	set(PATH_SEPARATOR "\\")
	set(VARIABLE_START "%")
	set(VARIABLE_END "%")
	set(PATH_LIST_SEPARATOR ";")
	set(PLUGIN_FOLDER_NAME "bin")
	set(SETUP_SCRIPT_EXTENSION ".bat")
elseif(UNIX)
	set(EXPORT_VAR "export")
	set(PATH_SEPARATOR "/")
	set(VARIABLE_START "$")
	set(VARIABLE_END "")
	set(PATH_LIST_SEPARATOR ":")
	set(PLUGIN_FOLDER_NAME "lib")
	set(SETUP_SCRIPT_EXTENSION ".sh")
endif()


# Defines the CMAKE_INSTALL_LIBDIR, CMAKE_INSTALL_BINDIR and many other useful macros.
# See https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
include(GNUInstallDirs)

############################ CALIBRATION MODELS LIBRARY ###############################

set(SETUP_PATH_CALIBRATION_LIBRARY "
${EXPORT_VAR} MATLABPATH=${VARIABLE_START}MATLABPATH${VARIABLE_END}${PATH_LIST_SEPARATOR}${VARIABLE_START}FT_NONLINEAR_MODELING_INSTALL_PREFIX${VARIABLE_END}${PATH_SEPARATOR}lib${PATH_SEPARATOR}ftcalib ")

######################## ARMS CALIBRATION URDF MODELS PATH ############################

set(SETUP_PATH_URDF_MODELS "
${EXPORT_VAR} FT_ARMS_URDF_MODELS_PATH=${VARIABLE_START}FT_NONLINEAR_MODELING_SOURCE_DIR${VARIABLE_END}${PATH_SEPARATOR}urdf_models${PATH_SEPARATOR}")

######################## CALIBRATION DATASETS PATH ############################

set(SETUP_PATH_DATASETS_MODELS "
${EXPORT_VAR} FT_PAPER_DATASETS_PATH=${VARIABLE_START}FT_NONLINEAR_MODELING_SOURCE_DIR${VARIABLE_END}${PATH_SEPARATOR}datasets${PATH_SEPARATOR}")

################################################################################

# Configure the environment variables file
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/templates/setup.in ${CMAKE_BINARY_DIR}/share/setup${SETUP_SCRIPT_EXTENSION})
INSTALL(FILES ${CMAKE_BINARY_DIR}/share/setup${SETUP_SCRIPT_EXTENSION} DESTINATION ${CMAKE_INSTALL_PREFIX}/share/humanoids_nonlinear_ft_calibration)

################################################################################

add_subdirectory(matlab_classes)
