//%attributes = {"publishedWeb":true}
//PM: Email_Opt_AskMe() -> 

//@author mlb - 4/17/01  13:00

C_TEXT:C284($cr; $t)
C_LONGINT:C283($total)
C_TEXT:C284($pdfDoc)

$cr:=Char:C90(13)
$t:=Char:C90(9)

emailBody:=Substring:C12(emailBody; 1; Position:C15($cr; emailBody)-1)
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers_Order_Lines:41])

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=emailBody)
If (Records in selection:C76([Finished_Goods:26])>0)
	emailSubject:=emailSubject+" for "+emailBody
	emailResponse:=$cr+emailBody+" - "+[Finished_Goods:26]Line_Brand:15+"; "+[Finished_Goods:26]CartonDesc:3+$cr
	emailResponse:=emailResponse+"Order Type: "+[Finished_Goods:26]OrderType:59+$cr
	emailResponse:=emailResponse+"Press Date: "+String:C10([Finished_Goods:26]PressDate:64; System date short:K1:1)+$cr
	emailResponse:=emailResponse+"Art Received: "+String:C10([Finished_Goods:26]ArtReceivedDate:56; System date short:K1:1)+$cr
	emailResponse:=emailResponse+"Prep Done: "+String:C10([Finished_Goods:26]PrepDoneDate:58; System date short:K1:1)+$cr
	emailResponse:=emailResponse+"Have Art: "+util_stringBoolean([Finished_Goods:26]HaveArt:51)+$cr
	emailResponse:=emailResponse+"Have Disk: "+util_stringBoolean([Finished_Goods:26]HaveDisk:52)+$cr
	emailResponse:=emailResponse+"Have Black & White: "+util_stringBoolean([Finished_Goods:26]HaveBnW:53)+$cr
	emailResponse:=emailResponse+"Have Size & Style: "+util_stringBoolean([Finished_Goods:26]HaveSnS:54)+$cr
	emailResponse:=emailResponse+"Control#: "+[Finished_Goods:26]ControlNumber:61+$cr
	emailResponse:=emailResponse+"Outline#: "+[Finished_Goods:26]OutLine_Num:4+$cr
	emailResponse:=emailResponse+"Style: "+[Finished_Goods:26]Style:32+$cr
	emailResponse:=emailResponse+"P-spec: "+[Finished_Goods:26]ProcessSpec:33+$cr
	emailResponse:=emailResponse+"Glue Type: "+[Finished_Goods:26]GlueType:34+$cr
	emailResponse:=emailResponse+"UPC: "+[Finished_Goods:26]UPC:37+$cr
	emailResponse:=emailResponse+"Last Order: "+String:C10([Finished_Goods:26]LastOrderNo:18)+$cr
	emailResponse:=emailResponse+"Last Job: "+[Finished_Goods:26]LastJobNo:16+$cr
	emailResponse:=emailResponse+"Last Ship Date: "+String:C10([Finished_Goods:26]LastShipDate:19; System date short:K1:1)+$cr
	emailResponse:=emailResponse+"Last Price: "+String:C10([Finished_Goods:26]LastPrice:27)+$cr
	emailResponse:=emailResponse+"Contract Price: "+String:C10([Finished_Goods:26]RKContractPrice:49)+$cr
	emailResponse:=emailResponse+$cr+"________________"+$cr
	emailResponse:=emailResponse+"INVENTORY ONHAND:"+$cr
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=emailBody)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aLocation; [Finished_Goods_Locations:35]QtyOH:9; $aQty; [Finished_Goods_Locations:35]Jobit:33; $aJobit)
	SORT ARRAY:C229($aJobit; $aLocation; $aQty; >)
	$total:=0
	emailResponse:=emailResponse+"JOBIT      "+$t+"   QUANTITY"+$t+"LOCATION"+$cr
	For ($j; 1; Size of array:C274($aLocation))
		emailResponse:=emailResponse+$aJobit{$j}+$t+String:C10($aQty{$j}; "^^^,^^^,^^^")+$t+$aLocation{$j}+$cr
		$total:=$total+$aQty{$j}
	End for 
	emailResponse:=emailResponse+"TOTAL      "+$t+String:C10($total; "^^^,^^^,^^^")+$cr
	emailResponse:=emailResponse+$cr+"________________"+$cr
	emailResponse:=emailResponse+"OPEN JOBS:"+$cr
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=emailBody; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11=0)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; $aOrderItem; [Job_Forms_Items:44]Qty_Want:24; $aQty; [Job_Forms_Items:44]Jobit:4; $aJobit)
	$total:=0
	SORT ARRAY:C229($aJobit; $aOrderItem; $aQty; >)
	emailResponse:=emailResponse+"JOBIT      "+$t+"   QUANTITY"+$t+"ORDER PEG"+$cr
	For ($j; 1; Size of array:C274($aJobit))
		emailResponse:=emailResponse+$aJobit{$j}+$t+String:C10($aQty{$j}; "^^^,^^^,^^^")+$t+$aOrderItem{$j}+$cr
		$total:=$total+$aQty{$j}
	End for 
	emailResponse:=emailResponse+"TOTAL      "+$t+String:C10($total; "^^^,^^^,^^^")+$cr
	emailResponse:=emailResponse+$cr+"________________"+$cr
	emailResponse:=emailResponse+"OPEN RELEASES:"+$cr
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=emailBody; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustomerRefer:3; $aRefer; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aQty; [Customers_ReleaseSchedules:46]Sched_Date:5; $aSchDate; [Customers_ReleaseSchedules:46]OrderLine:4; $aOrderItem)
	SORT ARRAY:C229($aSchDate; $aRefer; $aQty; $aOrderItem; >)
	$total:=0
	emailResponse:=emailResponse+"DATE    "+$t+"     QUANTITY"+$t+"ORDERLINE"+$t+"REFER"+$cr
	
	For ($j; 1; Size of array:C274($aSchDate))
		If (Length:C16($aOrderItem{$j})#8)
			$aOrderItem{$j}:="-----.--"
		End if 
		$total:=$total+$aQty{$j}
	End for 
	
	For ($j; 1; Size of array:C274($aSchDate))
		emailResponse:=emailResponse+String:C10($aSchDate{$j}; Internal date short:K1:7)+$t+String:C10($aQty{$j}; "^^^,^^^,^^^")+$t+$aOrderItem{$j}+$t+$aRefer{$j}+$cr
	End for 
	emailResponse:=emailResponse+"TOTAL     "+$t+String:C10($total; "^^^,^^^,^^^")+$cr
	emailResponse:=emailResponse+$cr+"________________"+$cr
	emailResponse:=emailResponse+"ORDER HISTORY:"+$cr
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=emailBody)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOrderItem; [Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]PONumber:21; $aPO; [Customers_Order_Lines:41]DateOpened:13; $aSchDate; [Customers_Order_Lines:41]Qty_Open:11; $aOpen; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice)
	SORT ARRAY:C229($aOrderItem; $aPO; $aQty; $aSchDate; $aOpen; $aPrice; >)
	$total:=0
	emailResponse:=emailResponse+"ORDERLIN"+$t+"DATED   "+$t+"     QUANTITY"+$t+"   OPEN QTY"+$t+"    PRICE"+$t+"PURCHASE ORDER"+$cr
	For ($j; 1; Size of array:C274($aOrderItem))
		emailResponse:=emailResponse+$aOrderItem{$j}+$t+String:C10($aSchDate{$j}; Internal date short:K1:7)+$t+String:C10($aQty{$j}; "^^^,^^^,^^^")+$t+String:C10($aOpen{$j}; "^^^,^^^,^^^")
		emailResponse:=emailResponse+$t+String:C10($aPrice{$j}; "^,^^0.000")+$t+$aPO{$j}+$cr
		$total:=$total+$aQty{$j}
	End for 
	emailResponse:=emailResponse+"        "+$t+"TOTAL     "+$t+String:C10($total; "^^^,^^^,^^^")+$cr
	emailResponse:=emailResponse+$cr+$cr
	emailResponse:=emailResponse+FG_SupplyAndDemand([Finished_Goods:26]FG_KEY:47)
	emailResponse:=emailResponse+$cr+$cr
	//$path:=PDF_printSimple (emailSubject;emailResponse)
	
Else 
	emailResponse:=emailBody+" was not found."
End if 

REDUCE SELECTION:C351([Finished_Goods:26]; 0)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)