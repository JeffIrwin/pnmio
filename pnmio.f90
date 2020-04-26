
module pnmio

implicit none

integer, parameter ::    &
    PNM_BW_ASCII    = 1, &
    PNM_GRAY_ASCII  = 2, &
    PNM_RGB_ASCII   = 3, &
    PNM_BW_BINARY   = 4, &
    PNM_GRAY_BINARY = 5, &
    PNM_RGB_BINARY  = 6

contains

!=======================================================================

integer function writepnm(frm, b, fname, header)

! frm
!     One of the 6 parameters above indicating black and white, grayscale, or
!     RGB, as well as ASCII or binary
!
! b(:,:)
!     Rank-two byte array of pixel values.  The RGB versions have the RGB
!     triplets stretched out along the first array dimension.  The binary B&W
!     version has 8 bits of B&W pixels packed into a single byte of the array
!     along the first dimension.
!
! fname
!     File name without extension

character :: fname*(*), dat*256
character(len = :), allocatable :: str, frmstr

integer :: frm, ix, iy, iunit
character, allocatable :: b(:,:)

logical, optional, intent(in) :: header
logical :: headerl

writepnm = -1

if (present(header)) then
  headerl = header
else
  headerl = .true.
end if

if (frm == PNM_BW_ASCII) then

  ! B & W (0 and 1)
  open(newunit = iunit, file = trim(fname)//'.pbm')
  write(iunit, '(a)') 'P1'

else if (frm == PNM_GRAY_ASCII) then

  ! Grayscale (0 - 255)
  open(newunit = iunit, file = trim(fname)//'.pgm')
  write(iunit, '(a)') 'P2'

else if (frm == PNM_RGB_ASCII) then

  ! RGB (0 - 255 triplets)
  open(newunit = iunit, file = trim(fname)//'.ppm')
  write(iunit, '(a)') 'P3'

else if (frm == PNM_BW_BINARY) then

  ! B & W (0 and 1)
  open(newunit = iunit, file = trim(fname)//'.pbm', form = 'unformatted', access = 'stream')
  write(iunit) 'P4', char(10)

else if (frm == PNM_GRAY_BINARY) then

  ! Grayscale (0 - 255)
  open(newunit = iunit, file = trim(fname)//'.pgm', form = 'unformatted', access = 'stream')
  write(iunit) 'P5', char(10)

else if (frm == PNM_RGB_BINARY) then

  ! RGB (0 - 255 triplets)
  open(newunit = iunit, file = trim(fname)//'.ppm', form = 'unformatted', access = 'stream')
  write(iunit) 'P6', char(10)

else

  write(*,*)
  write(*,*) 'ERROR in writepnm'
  write(*,*) 'Invalid format'
  write(*,*) 'Valid values frm = 1 - 6'
  write(*,*)
  writepnm = -2
  return

end if

if (headerl) then
  ! This header string could be corrected to reflect the current function name,
  ! but it will require updated the "expected output" in parent repo tests.
  str = '# Pixel bit map in netpbm format, generated by writepbm'
  if (frm >= PNM_BW_ASCII .and. frm <= PNM_RGB_ASCII) then
    write(iunit, '(a)') str
  else
    write(iunit) str
  end if
end if

if (frm >= PNM_BW_ASCII .and. frm <= PNM_RGB_ASCII) then
  if (frm == PNM_BW_ASCII .or. frm == PNM_GRAY_ASCII) then
    write(iunit, '(i0, a, i0)')  ubound(b, 1) - lbound(b, 1) + 1,      ' ', ubound(b, 2) - lbound(b, 2) + 1
  else
    write(iunit, '(i0, a, i0)') (ubound(b, 1) - lbound(b, 1) + 1) / 3, ' ', ubound(b, 2) - lbound(b, 2) + 1
  end if
else
  if (frm == PNM_BW_BINARY) then
    ! 8 bits packed into a byte
    write(dat, '(i0, a, i0)') (ubound(b, 1) - lbound(b, 1) + 1)*8,   ' ', ubound(b, 2) - lbound(b, 2) + 1
  else if (frm == PNM_GRAY_BINARY) then
    write(dat, '(i0, a, i0)')  ubound(b, 1) - lbound(b, 1) + 1,      ' ', ubound(b, 2) - lbound(b, 2) + 1
  else
    ! RGB triples
    write(dat, '(i0, a, i0)') (ubound(b, 1) - lbound(b, 1) + 1) / 3, ' ', ubound(b, 2) - lbound(b, 2) + 1
  end if
  write(iunit) trim(dat), char(10)
end if

if (frm >= PNM_BW_ASCII .and. frm <= PNM_RGB_ASCII) then
  if (frm == PNM_GRAY_ASCII .or. frm == PNM_RGB_ASCII) then
    write(iunit, '(i0)') 255
  end if
else
  if (frm == PNM_GRAY_BINARY .or. frm == PNM_RGB_BINARY) then
    write(dat, '(i0)') 255
    write(iunit) trim(dat), char(10)
  end if
end if

if (frm >= PNM_BW_ASCII .and. frm <= PNM_RGB_ASCII) then

  !! This works, and libre office and ffmpeg can read the results.  But each
  !! number is on its own line.
  !write(iunit, '(i0,x)') [((ichar(b(ix, iy)), ix = lbound(b,1), ubound(b,1)), iy = ubound(b,2), lbound(b,2), -1)]

  write(dat, '(a,i0,a)') '(', ubound(b,1) - lbound(b,1) + 1, '(i0,x))'
  frmstr = trim(dat)
  write(iunit, frmstr) [((ichar(b(ix, iy)), ix = lbound(b,1), ubound(b,1)), iy = ubound(b,2), lbound(b,2), -1)]

else
  write(iunit) [((b(ix, iy), ix = lbound(b,1), ubound(b,1)), iy = ubound(b,2), lbound(b,2), -1)]
end if

close(iunit)

writepnm = 0

end function writepnm

!=======================================================================

end module pnmio

