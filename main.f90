
program main

	use pnmio
	implicit none

	character(len = *), parameter :: me = "pnmio", tab = char(9)
	character(len = :), allocatable :: fi, fo, fbase
	character, allocatable :: b(:,:), bb(:,:)
	character(len = 1024) :: buffer

	integer :: argc, io, nx, ny, i, ii, j, jmod, frm, nc

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

	! Checkerboard with squares size nc
	nc = 15
	allocate(b(nx, ny))
	allocate(bb(nx / 8, ny))  ! pack 8 bits into each byte
	b  = achar(0)
	bb = achar(0)
	do j = 1, ny
		jmod = mod((j-1) / nc, 2)
		do i = 1, nx
			if (mod((i-1) / nc, 2) /= jmod) then
				ii = (i-1)/8 + 1
				b(i,j) = achar(1)
				bb(ii,j) = achar(ibset(ichar(bb(ii,j), 1), 7 - mod(i-1,8)))
			end if
		end do
	end do

	frm = PNM_BW_ASCII
	fo = fbase//'_1'
	io = writepnm(frm, b, fo)
	deallocate(b)

	frm = PNM_BW_BINARY
	fo = fbase//'_4'
	io = writepnm(frm, bb, fo)
	deallocate(bb)

	! Black to white gradient left to right
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
	deallocate(b)

	write(*,*) "Done "//me
	write(*,*)

end program main

