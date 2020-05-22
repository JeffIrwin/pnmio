program main

	use pnmio
	implicit none

	character(len = *), parameter :: me = "pnmio", tab = char(9)
	character(len = :), allocatable :: fi, fo, fbase
	character, allocatable :: b(:,:)
	character(len = 1024) :: buffer

	integer :: argc, io, nx, ny, i, frm

	write(*,*) "Starting "//me//" ..."
	io = 0

	argc = command_argument_count()
	if (argc < 1) then
		io = -1
		write(*,*) "Usage:"
		write(*,*) tab//me//" dummy.txt"
		return
	end if

	call get_command_argument(1, buffer)
	fi = trim(buffer)
	i = scan(fi, '.', .true.)
	if (i /= 0) then
		fbase = fi(1: i - 1)
	else
		fbase = fi
	end if

	nx = 1080
	ny = 240

	!allocate(b(nx / 8, ny))
	!b(1: nx / 8 / 2, :) = achar(0)
	!b(nx / 8 / 2 + 1: nx / 8, :) = achar(255)

	!frm = PNM_BW_ASCII
	!fo = fbase//'_1'
	!io = writepnm(frm, b, fo)

	!frm = PNM_BW_BINARY
	!fo = fbase//'_4'
	!io = writepnm(frm, b, fo)

	allocate(b(nx, ny))
	do i = 1, nx
		b(i,:) = achar(nint(255.d0 * (i-1) / (nx-1)))
	end do

	frm = PNM_GRAY_ASCII
	fo = fbase//'_2'
	io = writepnm(frm, b, fo)

	frm = PNM_GRAY_BINARY
	fo = fbase//'_5'
	io = writepnm(frm, b, fo)

	write(*,*) "Done "//me
	write(*,*)

end program main
