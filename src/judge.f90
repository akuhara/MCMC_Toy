subroutine judge(lppd, lppdp, qrat, t, accept)
  use mt19937
  implicit none 
  real(8), intent(in) :: lppd, lppdp, qrat, t
  logical, intent(out) :: accept
  real(8) :: a
  
  accept = .false.
  a = (lppdp - lppd + log(qrat)) / t
  
  if (log(grnd()) < a) then
     accept = .true.
  end if

  return 
end subroutine judge
