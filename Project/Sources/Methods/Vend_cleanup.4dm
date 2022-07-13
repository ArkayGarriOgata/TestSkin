//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/22/09, 10:17:31
// ----------------------------------------------------
// Method: Vend_cleanup
// Description
// 
//
// Parameters
// ----------------------------------------------------

<>cutOffDate1:=Date:C102(Request:C163("Cutoff date?"; "10/15/2014"; "Ok"; "Cancel"))  //!10/15/2014!  //keep 1 yrs plus current
If (ok=1)
	ams_RecentVendors(<>cutOffDate1)  //mark recent vendors to keep
	BEEP:C151
End if 