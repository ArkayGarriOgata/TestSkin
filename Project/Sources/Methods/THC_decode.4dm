//%attributes = {"publishedWeb":true}
//THC_decode(thc code)->text desc
// ----------------------------------------------------
// by: mel:
// ----------------------------------------------------
// Description:
// translate numbers in to words
// Updates:
// • mel (7/19/05, 16:58:30) simplify words for mgmt
// ----------------------------------------------------
C_LONGINT:C283($1; $2)
C_TEXT:C284($0)
C_BOOLEAN:C305($newStyle)
$newStyle:=False:C215

If (Count parameters:C259>=1)
	$thc:=$1
	If (Count parameters:C259=2)  // • mel (7/19/05, 16:58:30) simplify words for mgmt
		$newStyle:=True:C214
	End if 
Else 
	$thc:=[Customers_ReleaseSchedules:46]THC_State:39
End if 

If ($newStyle)
	Case of 
		: ($thc=0) | ($thc=1)  // • mel (7/19/05, 16:58:30) simplify words for mgmt
			$0:="On-Hand"
		: ($thc=2) | ($thc=3)  // • mel (7/19/05, 16:58:30) simplify words for mgmt
			$0:="In WIP"
		: ($thc=4) | ($thc=5) | ($thc=7) | ($thc=8)  // • mel (7/19/05, 16:58:30) simplify words for mgmt
			$0:="Action Required"
		: ($thc=9)  // • mel (7/19/05, 16:58:30) simplify words for mgmt
			$0:="Not Analyzed"
		Else 
			$0:=""
	End case 
	
Else 
	Case of 
		: ($thc=0)
			$0:="met: w/Finished Goods"
		: ($thc=1)
			$0:="met: w/F/G & Exam & CC"
		: ($thc=2)
			$0:="met: w/Inventory & WIP"
		: ($thc=3)
			$0:="met: w/WIP"
		: ($thc=4)
			$0:="not met: WIP & Inventory short"
		: ($thc=5)
			$0:="not met: WIP short"
		: ($thc=6)
			$0:="error"
		: ($thc=7)
			$0:="not met: no WIP, Inventory short"
		: ($thc=8)
			$0:="not met: no WIP"
		: ($thc=9)
			$0:="Not Analyzed"
		Else 
			$0:=""
	End case 
End if 