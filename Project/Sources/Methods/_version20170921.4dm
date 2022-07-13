//%attributes = {}
// -------
// Method: _version20170921   ( ) ->
// By: Mel Bohince @ 09/20/17, 15:10:58
// Description
// add in Preventative maint
// ----------------------------------------------------

READ ONLY:C145([Cost_Centers:27])
QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]Description:3="Gluer@")
SELECTION TO ARRAY:C260([Cost_Centers:27]ID:1; $aGluers)
REDUCE SELECTION:C351([Cost_Centers:27]; 0)
SORT ARRAY:C229($aGluers; >)

For ($i; 1; Size of array:C274($aGluers))
	CREATE RECORD:C68([Job_Forms_Items:44])
	[Job_Forms_Items:44]JobForm:1:="02017.02"
	[Job_Forms_Items:44]ItemNumber:7:=$i
	[Job_Forms_Items:44]Jobit:4:=JMI_makeJobIt([Job_Forms_Items:44]JobForm:1; [Job_Forms_Items:44]ItemNumber:7)
	[Job_Forms_Items:44]Gluer:47:=$aGluers{$i}
	[Job_Forms_Items:44]ProductCode:3:="Prevent.Maint."
	[Job_Forms_Items:44]Qty_Actual:11:=0
	[Job_Forms_Items:44]ModDate:29:=Current date:C33
	[Job_Forms_Items:44]ModWho:30:=<>zResp
	[Job_Forms_Items:44]PlnnrWho:34:="ams"
	[Job_Forms_Items:44]PlnnrDate:35:=[Job_Forms_Items:44]ModDate:29
	[Job_Forms_Items:44]OrderItem:2:="PV"
	[Job_Forms_Items:44]CustId:15:="00001"
	[Job_Forms_Items:44]MAD:37:=Add to date:C393(Current date:C33; 0; 0; 5)
	[Job_Forms_Items:44]GlueRate:52:=8
	[Job_Forms_Items:44]Qty_Want:24:=9999999
	SAVE RECORD:C53([Job_Forms_Items:44])
End for 