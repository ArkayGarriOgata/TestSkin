//%attributes = {}
//Method:  Arcv_TbSt_ExistsB(nTable;pcFieldName)=>bExists
//Description:  This method checks if the table settings exist for nTable

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nTable)
	C_POINTER:C301($2; $pcFieldName)
	
	C_BOOLEAN:C305($0; $bExists)
	
	C_OBJECT:C1216($esArcvTable)
	
	$nTable:=$1
	$pcFieldName:=$2
	
	$bExists:=False:C215
	
	$esArcvTable:=New object:C1471()
	
End if   //Done initialize

$esArcvTable:=ds:C1482.Arcv_Table.query("TableProperty.nTableNumber==:1"; $nTable)

$bExists:=($esArcvTable.length=1)

If ($bExists)
	
	$pcFieldName->:=$esArcvTable.first().TableProperty.cFieldName
	
End if 

$0:=$bExists