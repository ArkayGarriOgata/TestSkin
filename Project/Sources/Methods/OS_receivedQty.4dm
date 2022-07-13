//%attributes = {}
// Method: OS_receivedQty () -> 
// ----------------------------------------------------
// by: mel: 08/23/04, 12:47:55
// ----------------------------------------------------

C_LONGINT:C283($2)  //qty
C_TEXT:C284($1)  //po item

READ WRITE:C146([ProductionSchedules:110])
QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]PurchaseOrder:34=$1)  //try by item# first

Case of 
	: (Records in selection:C76([ProductionSchedules:110])=1)
		[ProductionSchedules:110]WIPreturnedSheets:37:=[ProductionSchedules:110]WIPreturnedSheets:37+$2
		SAVE RECORD:C53([ProductionSchedules:110])
		
	: (Records in selection:C76([ProductionSchedules:110])>1)
		APPLY TO SELECTION:C70([ProductionSchedules:110]; [ProductionSchedules:110]WIPreturnedSheets:37:=[ProductionSchedules:110]WIPreturnedSheets:37+$2)
		
	Else   //maybe just the po will work
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]PurchaseOrder:34=(Substring:C12($1; 1; 7)))
		If (Records in selection:C76([ProductionSchedules:110])=1)
			[ProductionSchedules:110]WIPreturnedSheets:37:=[ProductionSchedules:110]WIPreturnedSheets:37+$2
			SAVE RECORD:C53([ProductionSchedules:110])
		End if 
		
End case 
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([ProductionSchedules:110])
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	
Else 
	
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	
End if   // END 4D Professional Services : January 2019 
