//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/28/11, 16:12:28
// ----------------------------------------------------
// Method: RMG_getStdCost
// Description
// return standard cost for commoditykey
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($2)
C_REAL:C285($0)

$0:=0

If (Count parameters:C259=1)
	READ ONLY:C145([Raw_Materials_Groups:22])
End if 

SET QUERY LIMIT:C395(1)
QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$1)
If (Records in selection:C76([Raw_Materials_Groups:22])>0)
	$0:=[Raw_Materials_Groups:22]Std_Cost:4
	
	If (Count parameters:C259=1)
		REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
	End if 
End if 

SET QUERY LIMIT:C395(0)