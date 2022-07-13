//%attributes = {}
// -------
// Method: Job_getBoardRMCode   ( jobform) -> [Job_Forms_Materials]Raw_Matl_Code
// By: Mel Bohince @ 03/02/18, 15:54:15
// Description
// 
// ----------------------------------------------------
C_TEXT:C284($1; $0; $rmcode; $jf)

If (Count parameters:C259=1)
	$jf:=$1
Else 
	$jf:="99733.01"
End if 

Begin SQL
	select Raw_Matl_Code from Job_Forms_Materials 
	where JobForm = :$jf 
	and (Commodity_Key like '01%' or Commodity_Key like '20%') 
	into :$rmcode
End SQL

If (Length:C16($rmcode)>0)
	$0:=$rmcode
Else 
	$0:="Board not specified"
End if 
