//ibRev ([control]POEvent
//• 3/17/98 cs added code for special screen for accounts receivable personnel
//• 3/24/98 cs insure that input layout is reset correctly, do not display new 
//   layout for Admin

$id:=uSpawnProcess("PoAcctReview"; 0; "Review Purchase Orders"; True:C214; True:C214)
If (False:C215)
	PoAcctReview
End if 

