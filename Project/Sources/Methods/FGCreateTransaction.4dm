//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 06/18/13, 10:09:02
// ----------------------------------------------------
// Method: FGCreateTransaction
// Description:
// This will create a "Adjustment" transaction like the "Adjust Bin Qty" button on the FG Palette.
// Looped twice for the + and the - transaction.
// ----------------------------------------------------
// Modified by: Mel Bohince (3/27/14) make one, not four transactions, don't rely on array elements, switch to args()
// Modified by: Garri Ogata (9/2/20) Allow ($4)ActionTaken and ($5)Reason to be optional parameters

C_TEXT:C284($4; $tActionTaken; $5; $tReason)
C_LONGINT:C283($nNumberOfParameters)

C_TEXT:C284($tJobNum; $tJobForm; $tJobIt; $tProdCode; $tLocation; $tFGXID)
C_LONGINT:C283($i; $xlJobItem; $xlQty)
$tJobIt:=$1
$tJobNum:=Substring:C12($tJobIt; 1; 5)
$tJobForm:=Substring:C12($tJobIt; 1; 8)
$xlJobItem:=Num:C11(Substring:C12($tJobIt; 10; 2))

$tProdCode:=$2
//$xlQty:=axlQuantity{abJobIts}
$tLocation:=$3

$nNumberOfParameters:=Count parameters:C259
$tActionTaken:="Deleted"
$tReason:="System Err"

If ($nNumberOfParameters>=4)
	$tActionTaken:=$4
	If ($nNumberOfParameters>=5)
		$tReason:=$5
	End if 
End if 

READ ONLY:C145([Finished_Goods:26])
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$tProdCode)
READ ONLY:C145([Job_Forms_Items:44])
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$tJobIt)

For ($i; 1; 1)
	$tFGXID:=FGX_NewFG_Transaction("Adjust"; Current date:C33; <>zResp)
	[Finished_Goods_Transactions:33]ProductCode:1:=$tProdCode
	[Finished_Goods_Transactions:33]CustID:12:=[Finished_Goods:26]CustID:2
	[Finished_Goods_Transactions:33]JobNo:4:=$tJobNum
	[Finished_Goods_Transactions:33]JobForm:5:=$tJobForm
	[Finished_Goods_Transactions:33]JobFormItem:30:=$xlJobItem
	If ($i=1)
		[Finished_Goods_Transactions:33]Qty:6:=0  //$xlQty
	Else 
		[Finished_Goods_Transactions:33]Qty:6:=-1*$xlQty
	End if 
	[Finished_Goods_Transactions:33]Location:9:=$tLocation
	[Finished_Goods_Transactions:33]viaLocation:11:="FG +/- Pair"
	[Finished_Goods_Transactions:33]FG_Classification:22:=[Finished_Goods:26]ClassOrType:28
	[Finished_Goods_Transactions:33]CoGS_M:7:=[Job_Forms_Items:44]PldCostTotal:21
	[Finished_Goods_Transactions:33]CoGSExtended:8:=uNANCheck(Round:C94(([Finished_Goods_Transactions:33]Qty:6/1000)*[Job_Forms_Items:44]PldCostTotal:21*(Num:C11(Not:C34([Finished_Goods_Transactions:33]SkipTrigger:14))); 2))
	[Finished_Goods_Transactions:33]ActionTaken:27:=$tActionTaken
	[Finished_Goods_Transactions:33]Reason:26:=$tReason  //Subject for reason-used in reporting, sorting, very uniform
	[Finished_Goods_Transactions:33]ReasonNotes:28:="FG +/- Pair"
	SAVE RECORD:C53([Finished_Goods_Transactions:33])
	UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
End for 