//%attributes = {"publishedWeb":true}
//PM: JML_SetStock(message;jobform;value) -> 
//@author mlb - 4/18/01  09:58

C_TEXT:C284($1; $2; $3)

READ WRITE:C146([Job_Forms_Master_Schedule:67])
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$2)

Case of 
	: (Records in selection:C76([Job_Forms_Master_Schedule:67])=0)
		BEEP:C151
		zwStatusMsg("SET STOCK"; $1+" was not set to "+$3+" on jobform "+$2)
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		
	: ($1="Stock Due")
		[Job_Forms_Master_Schedule:67]DateStockDue:16:=Date:C102($3)
		zwStatusMsg("SET STOCK"; $1+" was set to "+$3+" on jobform "+$2)
		
	: ($1="Stock Received")
		[Job_Forms_Master_Schedule:67]DateStockRecd:17:=Date:C102($3)
		zwStatusMsg("SET STOCK"; $1+" was set to "+$3+" on jobform "+$2)
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		
	: ($1="Stock Number")
		[Job_Forms_Master_Schedule:67]S_Number:7:=$3
		zwStatusMsg("SET STOCK"; $1+" was set to "+$3+" on jobform "+$2)
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
End case 

REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)