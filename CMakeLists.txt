# Copyright (C) 2023 Istituto Italiano di Tecnologia (IIT). All rights reserved.
# This software may be modified and distributed under the terms of the
# GNU Lesser General Public License v2.1 or any later version.
# Authors: Hosameldin Mohamed hosameldin.mohamed@iit.it

cmake_minimum_required(VERSION 3.5)

project(humanoids_nonlinear_ft_calibration LANGUAGES CXX
                              VERSION 1.0.0)

file(TO_NATIVE_PATH "${PROJECT_SOURCE_DIR}" REPO_SOURCE_DIR)

add_subdirectory(software)
