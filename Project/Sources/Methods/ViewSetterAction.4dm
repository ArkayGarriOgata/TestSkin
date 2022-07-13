//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/11/10, 10:33:01
// ----------------------------------------------------
// Method: ViewSetterAction
// Description
// return text of mode called
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($0; $2)
C_LONGINT:C283($1)  //mode

Case of 
	: ($1=1)
		$0:="New"
	: ($1=2)
		$0:="Modify"
	: ($1=3)
		$0:="Review"
	: ($1=4)
		$0:="Delete"
	: ($1=5)
		$0:="Copy Estimate"
	: ($1=96)
		$0:="Dept List"
	: ($1=97)
		$0:="DeptAndPos"
	: ($1=7)
		$0:="doRpt-"+$2
	: ($1=30)
		$0:="doRMRpt-"+$2
	: ($1=35)
		If ($2="Month End@")
			$0:="MthEndSuite_Reports"
		Else 
			$0:="doFGRpt-"+$2
		End if 
	: ($1=40)
		$0:="obsolete-BkRpt"+$2
	: ($1=50)
		$0:="doJobRpt-"+$2
	: ($1=78)
		$0:="doRptNoSearch-"+$2
End case 
