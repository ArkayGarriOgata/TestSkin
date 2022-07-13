//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 09/30/15, 11:23:12
// ----------------------------------------------------
// Method: REL_getFirmOrFrcst
// Description
//   // to be called from a release quick report
//
// ----------------------------------------------------

$prefix:=Substring:C12([Customers_ReleaseSchedules:46]CustomerRefer:3; 1; 3)
Case of 
	: ($prefix="<FC")  //looking at date, not qty
		$0:="COMMIT"
	: ($prefix="<FP")
		$0:="FCST"
	: ($prefix="<FF")
		$0:="FIRM"
	: ($prefix="<FD")
		$0:="FCST"
	: ($prefix="<FN")
		$0:="NOT"
		
	Else 
		$0:="FIRM"
End case 
