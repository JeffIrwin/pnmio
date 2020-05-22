
set(PROJECT pnmio)
project(${PROJECT} Fortran)

add_library(pnmio pnmio.f90)

set(EXE "${PROJECT}exe")
add_executable(${EXE} main.f90)
target_link_libraries(${EXE} ${PROJECT})
set_target_properties(${EXE} PROPERTIES OUTPUT_NAME ${PROJECT})

