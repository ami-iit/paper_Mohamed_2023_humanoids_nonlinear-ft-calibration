################################################################################
#                                                                              #
# Copyright (C) 2023 Fondazione Istitito Italiano di Tecnologia (IIT)          #
# All Rights Reserved.                                                         #
#                                                                              #
################################################################################

# Install the MATLAB script into the install folder
file(GLOB m_files "*.m")
install(FILES ${m_files} DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/ftcalib/@FTSensor)
