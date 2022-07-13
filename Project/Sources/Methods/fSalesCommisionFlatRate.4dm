//%attributes = {}
// _______
// Method: fSalesCommisionFlatRate   ( custid ) -> percent commission as decimal
// By: Mel Bohince @ 12/11/19, 12:02:50
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($custId; $1)
C_REAL:C285($0; $decimalCommission; $commissionSetting)
C_OBJECT:C1216($entSel)

If (Count parameters:C259>0)
	$custId:=$1
Else 
	$custId:="01941"
End if 

$entSel:=ds:C1482.Customers.query("ID = :1"; $custId)
If ($entSel.length>0)
	$commissionSetting:=$entSel.first().CommissionPercent
	If ($commissionSetting>0)
		$decimalCommission:=$commissionSetting/100
		
	Else   //not set
		$decimalCommission:=0
	End if 
	
Else   //cust not found
	$decimalCommission:=0
End if 

$0:=$decimalCommission
