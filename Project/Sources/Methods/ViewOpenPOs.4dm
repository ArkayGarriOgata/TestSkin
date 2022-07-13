//%attributes = {"publishedWeb":true}
//(p) ViewOpenPOs
//displays a selection of open POs
//• 7/2/98 cs created
<>PassThrough:=False:C215
$id:=New process:C317("qryOpenPOs"; <>lMinMemPart; "Qry Open PO's")
If (False:C215)
	qryOpenPOs
End if 
Repeat 
	DELAY PROCESS:C323(Current process:C322; 10)
Until (<>PassThrough)
FORM SET INPUT:C55([Purchase_Orders:11]; "Input")
FORM SET OUTPUT:C54([Purchase_Orders:11]; "List")  //• 6/4/97 cs insure that this is PO input NOT Requisition
ViewSetter(3; ->[Purchase_Orders:11])
//
zwStatusMsg("OPEN PO"; "Displaying Approved and Partial Receipts")  //, excluding INX_autoPOs