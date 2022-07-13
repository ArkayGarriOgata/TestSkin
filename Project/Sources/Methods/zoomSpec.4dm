//%attributes = {"publishedWeb":true}
C_TEXT:C284($1; $spec)  //zoomspec
C_LONGINT:C283($temp)
$spec:=$1
$temp:=iMode
iMode:=3
fromZoom:=True:C214
READ ONLY:C145([Process_Specs:18])
//If (Count parameters=2)                         pspec id is unique
// SEARCH([PROCESS_SPEC];[PROCESS_SPEC]ID=$spec;*)
// SEARCH([PROCESS_SPEC]; & [PROCESS_SPEC]Cust_ID=$2)
//Else 
QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=$spec)
//End if 

If (Records in selection:C76([Process_Specs:18])=1)
	Open window:C153(12; 50; 518; 348; 8; "Zoom Process Spec:"+[Process_Specs:18]ID:1+" from Form")  //;"wCloseWinBox")  
	DISPLAY SELECTION:C59([Process_Specs:18]; *)
Else 
	BEEP:C151
	ALERT:C41($spec+" is not a valid process spec anymore.")
End if 
iMode:=$temp
fromZoom:=False:C215
//