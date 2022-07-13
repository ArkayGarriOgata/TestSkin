//%attributes = {"publishedWeb":true}
//(p) gRmDateLimit
//$1 pointer (should be reference to self) 
//stops user from entering furture dates in Issue ,Receive, or Adjust

If ($1->>(4D_Current_date+7))
	ALERT:C41("Entered Date is more than One Week in the Future."+<>sCR+"Please Re-enter Date.")
	$1->:=!00-00-00!
End if 