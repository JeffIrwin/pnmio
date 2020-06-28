
# pnmio
Fortran I/O routines for portable anymap image files (.pbm, .pgm, .ppm)

Currently only output routines are provided.  Input is left as an exercise to the reader.

For projects that use the pnmio, see [life](https://github.com/JeffIrwin/life) or [mandelbrotZoom](https://github.com/JeffIrwin/mandelbrotZoom).

## Download
_From your project:_

    git submodule add https://github.com/JeffIrwin/pnmio
    
## CMake build
    add_subdirectory("pnmio/")
    
    ...
    
    include_directories("pnmio/")
    target_link_libraries("pnmio")

## Usage
Fortran:

    program example
    
    use pnmio
    
    character, allocatable :: b(:,:)
    integer :: i, io, nx, ny, frm
    
    ! Grayscale formats are the simplest.  Black and white and RGB color
    ! formats are slightly different.  See main.f90 for full details.
    
    ! Allocate bytes for pixel values
    nx = 1080
    ny = 240
    allocate(b(nx, ny))
    
    ! Black to white gradient left to right
  	do i = 1, nx
	  	b(i,:) = achar(nint(255.d0 * (i-1) / (nx-1)))
  	end do

  	frm = PNM_GRAY_ASCII
  	io = writepnm(frm, b, "myfile_grayscale_ascii")

  	frm = PNM_GRAY_BINARY
  	io = writepnm(frm, b, "myfile_grayscale_binary")
  	deallocate(b)
    
    end program example
