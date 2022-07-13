//bRMCleanup
//allows administrator to combine RM bins & remove zeros
//most particularlly useful after PI
ALERT:C41("THIS MUST BE RUN IN SINGLE USER (YOU ARE THE ONLY USER)!!!!!")
CONFIRM:C162("Do You Want to Delete Zero OnHand Quantity RM Bins Records, "+"and Combine Multiply Occuring RM Bins?")

If (OK=1)
	$winRef:=NewWindow(270; 40; 6; 1; "")
	MESSAGE:C88(<>sCr+<>sCr+"Combining RM Locations, & Removing Zero RM Bins…")
	gPutRms2OneLoc
	RM_DelZeroBins
	CLOSE WINDOW:C154($winRef)
End if 
//eop