//%attributes = {}
// ----------------------------------------------------
// Method: wmss_CaseState   ( case_status_code) -> status
// By: Mel Bohince @ 04/07/16, 10:09:47
// Description
// convert case_status_code from number to english
// ----------------------------------------------------

C_TEXT:C284($0)
C_LONGINT:C283($1)
Case of 
	: ($1=1)
		$0:=" CERTIFICATION "
		
	: ($1=10)
		$0:=" EXAMINING "
		
	: ($1=110)
		$0:=" BOL PENDING "
		
	: ($1=130)
		$0:=" RE-CERT "
		
	: ($1=200)
		$0:=" B&H "
		
	: ($1=250)
		$0:=" EXCESS "
		
	: ($1=300)
		$0:=" SHIPPED "
		
	: ($1=350)
		$0:=" RE-CERT "
		
	: ($1=400)
		$0:=" SCRAPPED "
		
	: ($1=500)
		$0:=" UNKNOWN "
		
	Else 
		$0:=" FG "
End case 