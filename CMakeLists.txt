cmake_minimum_required(VERSION 3.5)

project(log4cxx_vendor)

find_package(ament_cmake REQUIRED)

set(PACKAGE_VERSION "1.0.0")

list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")

macro(build_log4cxx)
  set(configure_opts)

  if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(TARGET "--host=x86_64-pc-nto-qnx7.1.0")
  elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64le")
    set(TARGET "--host=aarch64-unknown-nto-qnx7.0.0")
  elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "armv7")
    set(TARGET "--host=arm-unknown-nto-qnx7.1.0eabi")
  else()
    message(FATAL_ERROR "invalid cpu CMAKE_SYSTEM_PROCESSOR:${CMAKE_SYSTEM_PROCESSOR}")
  endif()

  find_package(apr_vendor REQUIRED)
  find_package(apr_util_vendor REQUIRED)
  find_package(APR REQUIRED)

  list(APPEND configure_opts "${TARGET}")
  list(APPEND configure_opts "--prefix=${CMAKE_INSTALL_PREFIX}")
  list(APPEND configure_opts "--with-apr=${CMAKE_INSTALL_PREFIX}")
  list(APPEND configure_opts "--with-apr-util=${CMAKE_INSTALL_PREFIX}")
  list(APPEND configure_opts "CXXFLAGS=${CXXFLAGS} -Wno-terminate --std=c++11 -D_QNX_SOURCE")

  include(ExternalProject)
  ExternalProject_Add(log4cxx
    GIT_REPOSITORY https://github.com/apache/logging-log4cxx.git
    GIT_TAG v0.11.0
    TIMEOUT 600
    CONFIGURE_COMMAND cd ${CMAKE_CURRENT_BINARY_DIR}/log4cxx-prefix/src/log4cxx && ./autogen.sh && ./configure "${configure_opts}"
    BUILD_COMMAND cd ${CMAKE_CURRENT_BINARY_DIR}/log4cxx-prefix/src/log4cxx && make
    INSTALL_COMMAND cd ${CMAKE_CURRENT_BINARY_DIR}/log4cxx-prefix/src/log4cxx && make install
  )
endmacro()

find_package(Log4cxx QUIET)

if(NOT Log4cxx_FOUND)
  build_log4cxx()
endif()

install(DIRECTORY cmake DESTINATION share/${PROJECT_NAME})

ament_package(
  CONFIG_EXTRAS "log4cxx_vendor-extras.cmake"
)
