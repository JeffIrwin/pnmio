
module pnmio

implicit none

contains

!=======================================================================

integer function writepnm(frm, b, fname, header)

! frm
!     1:  B & W      ASCII
!     2:  Grayscale  ASCII
!     3:  RGB        ASCII
!     4:  B & W      Binary
!     5:  Grayscale  Binary
!     6:  RGB        Binary
!
! b
!     Rank-two array of pixel values
!
! fname
!     File name without extension

character :: fname*(*), dat*256
character(len = :), allocatable :: str

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

if (frm == 1) then

  ! B & W (0 and 1)
  open(newunit = iunit, file = trim(fname)//'.pbm')
  write(iunit, '(a)') 'P1'

else if (frm == 2) then

  ! Grayscale (0 - 255)
  open(newunit = iunit, file = trim(fname)//'.pgm')
  write(iunit, '(a)') 'P2'

else if (frm == 3) then

  ! RGB (0 - 255 triplets)
  open(newunit = iunit, file = trim(fname)//'.ppm')
  write(iunit, '(a)') 'P3'

else if (frm == 4) then

  ! B & W (0 and 1)
  open(newunit = iunit, file = trim(fname)//'.pbm')
  write(iunit, '(a)') 'P4'

else if (frm == 5) then

  ! Grayscale (0 - 255)
  open(newunit = iunit, file = trim(fname)//'.pgm')
  write(iunit, '(a)') 'P5'

else if (frm == 6) then

  ! RGB (0 - 255 triplets)
  open(newunit = iunit, file = trim(fname)//'.ppm', form = 'unformatted', access = 'direct', recl = 1)
  dat = 'P6'
  !write(iunit) 'P6'
  !write(iunit, rec = 1) trim(dat)
  write(iunit, rec = 1) 'P'
  write(iunit, rec = 2) '6'

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
  if (frm >= 1 .and. frm <= 3) then
    write(iunit, '(a)') str
  else
    write(iunit) str
  end if
end if

if (frm >= 1 .and. frm <= 3) then
  if (frm == 1 .or. frm == 2) then
    write(iunit, '(i0, a, i0)')  ubound(b, 1) - lbound(b, 1) + 1,      ' ', ubound(b, 2) - lbound(b, 2) + 1
  else
    write(iunit, '(i0, a, i0)') (ubound(b, 1) - lbound(b, 1) + 1) / 3, ' ', ubound(b, 2) - lbound(b, 2) + 1
  end if
else
  if (frm == 4 .or. frm == 5) then
    write(dat, '(i0, a, i0)')  ubound(b, 1) - lbound(b, 1) + 1,      ' ', ubound(b, 2) - lbound(b, 2) + 1
  else
    write(dat, '(i0, a, i0)') (ubound(b, 1) - lbound(b, 1) + 1) / 3, ' ', ubound(b, 2) - lbound(b, 2) + 1
  end if
  write(iunit) trim(dat)
end if

if (frm >= 1 .and. frm <= 3) then
  if (frm == 2 .or. frm == 3) then
    write(iunit, '(i0)') 255
  end if
else
  if (frm == 5 .or. frm == 6) then
    write(dat, '(i0)') 255
    write(iunit) trim(dat)
  end if
end if

do iy = ubound(b, 2), lbound(b, 2), -1
  do ix = lbound(b, 1), ubound(b, 1)
    !write(iunit, '(i0, a)', advance = 'no') b(ix, iy), ' '
    if (frm >= 1 .and. frm <= 3) then
      write(iunit, '(i0, a)', advance = 'no') ichar(b(ix, iy)),' '
    else
      write(iunit) b(ix, iy)
    end if
  end do
  if (frm >= 1 .and. frm <= 3) then
    write(iunit, '(a)', advance = 'yes') ''
  end if
end do

close(iunit)

writepnm = 0

end function writepnm

!=======================================================================

end module pnmio

