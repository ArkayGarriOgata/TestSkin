//%attributes = {}
// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/27/18, 11:24:26
// ----------------------------------------------------
// Method: DieBoardLoadAllRecs
// Description
// 
//
// Parameters
// ----------------------------------------------------
//{$1} = query text
C_TEXT:C284($ttQuery)
$ttQuery:=""
If (Count parameters:C259>0)
	$ttQuery:=$1
End if 
If (Length:C16($ttQuery)=0)
	ALL RECORDS:C47([Job_DieBoard_Inv:168])
Else 
	QUERY:C277([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]OutlineNumber:4=WildCard($ttQuery); *)
	QUERY:C277([Job_DieBoard_Inv:168];  | ; [Job_DieBoard_Inv:168]Customer:2=WildCard($ttQuery); *)
	QUERY:C277([Job_DieBoard_Inv:168];  | ; [Job_DieBoard_Inv:168]CatelogID:10=WildCard($ttQuery); *)
	QUERY:C277([Job_DieBoard_Inv:168];  | ; [Job_DieBoard_Inv:168]DieNumber:3=WildCard($ttQuery))
End if 
ORDER BY:C49([Job_DieBoard_Inv:168]; [Job_DieBoard_Inv:168]CatelogID:10; >)
