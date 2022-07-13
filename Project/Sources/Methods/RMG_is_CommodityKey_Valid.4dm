//%attributes = {}
// Method: RMG_is_CommodityKey_Valid
// -----------------
// User name (OS): mlb
// Date and time: 05/10/06, 13:09:02
// ----------------
// Description
// see if passed value is in groups table
// Parameters a comkey
// -----------------
// Modified by: MelvinBohince (2/4/22) declare $numGroup

C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_LONGINT:C283($numGroup)

$0:=False:C215

If (Length:C16($1)>3)
	READ ONLY:C145([Raw_Materials_Groups:22])
	$numGroup:=0  // Modified by: MelvinBohince (2/4/22) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numGroup)
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=$1)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	If ($numGroup>0)
		$0:=True:C214
	End if 
End if 