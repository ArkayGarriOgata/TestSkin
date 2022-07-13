//bFGCleanup
//allows administrator to combine FG bins & remove zeros
//most particularlly useful after PI
ALERT:C41("THIS MUST BE RUN IN SINGLE USER (YOU ARE THE ONLY USER)!!!!!")
CONFIRM:C162("Do You Want to Delete Zero OnHand Quantity FG Bins Records, "+"and Combine Multiply Occuring FG Bins?")

If (OK=1)
	MESSAGE:C88(<>sCr+"  Combining FG Locations, & Removing Zero FG Bins…")
	FG_ConsolidateBins
	FG_DelZeroBins
	CLOSE WINDOW:C154
End if 
//eos