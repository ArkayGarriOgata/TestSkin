//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getCasesByRelLoop - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($xlNumRows; $xlWGTPOerCaseGuess; $i; $xlJMI)
$xlWGTPOerCaseGuess:=25  //wild-ass guess

$xlNumRows:=Size of array:C274(aPackQty)

ARRAY LONGINT:C221(aRecNo; $xlNumRows)
ARRAY TEXT:C222(aCustid; $xlNumRows)
ARRAY LONGINT:C221(aQty; $xlNumRows)
ARRAY TEXT:C222(aCPN; $xlNumRows)
ARRAY DATE:C224(aGlued; $xlNumRows)
ARRAY LONGINT:C221(aWgt; $xlNumRows)

For ($i; 1; $xlNumRows)
	aJobit{$i}:=JMI_makeJobIt(aJobit{$i})
	aLocation{$i}:=wms_convert_bin_id("ams"; aLocation{$i})
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=aLocation{$i}; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Jobit:33=aJobit{$i})
	aRecNo{$i}:=Record number:C243([Finished_Goods_Locations:35])
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	
	$xlJMI:=qryJMI(aJobit{$i})
	aCustid{$i}:=[Job_Forms_Items:44]CustId:15
	aQty{$i}:=0  //this is the onhand qty, ref only
	aCPN{$i}:=[Job_Forms_Items:44]ProductCode:3
	aGlued{$i}:=[Job_Forms_Items:44]Glued:33
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	
	aWGT{$i}:=$xlWGTPOerCaseGuess  //wag
End for 

