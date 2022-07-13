//OM: bHelp() -> 
//@author mlb - 2/21/02  14:41

C_TEXT:C284($server)
$server:="?"
C_LONGINT:C283($rga_id)
app_getNextID(8003; ->$server; ->$rga_id)  //requires separate sequence
[QA_Corrective_Actions:105]RGA:4:="R"+String:C10($rga_id; "0000")
//[QA_Corrective_Actions]RGA:="R"+app_set_id_as_string (8003;"0000")  `String(nNextID (8003);"0000")
If (Length:C16([QA_Corrective_Actions:105]RGA:4)>0)
	OBJECT SET ENABLED:C1123(bRGA; False:C215)
Else 
	OBJECT SET ENABLED:C1123(bRGA; True:C214)
End if 