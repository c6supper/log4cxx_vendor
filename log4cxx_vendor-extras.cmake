# Copyright 2019-2020 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

list(INSERT CMAKE_MODULE_PATH 0 "${log4cxx_vendor_DIR}/Modules")

if(Log4cxx_FOUND AND NOT TARGET log4cxx::log4cxx)
  message(STATUS "Log4cxx was already found when log4cxx_vendor was included, adding missing imported target log4cxx::log4cxx")
  add_library(log4cxx::log4cxx UNKNOWN IMPORTED)
  set_property(TARGET log4cxx::log4cxx PROPERTY IMPORTED_LOCATION ${Log4cxx_LIBRARY})
  set_property(TARGET log4cxx::log4cxx PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${Log4cxx_INCLUDE_DIR})
  list(APPEND Log4cxx_TARGETS log4cxx::log4cxx)
endif()
