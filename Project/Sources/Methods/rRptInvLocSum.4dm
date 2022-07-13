//%attributes = {"publishedWeb":true}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// ----------------------------------------------------
// Method: rRptInvLocSum
// Description
// //◊MthEndSuite{35}:="FG/CC/RC/EX Summary"  `•121495 KS
// •Grand totals of each main inventory location• 
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (12/3/15) save to disk also
// Modified by: Mel Bohince (1/21/16) added transit, vista and o/s

C_LONGINT:C283($i; $locs; $FG; $CC; $XC; $EX; $BH; $NA; $AV; $FX)
ALL RECORDS:C47([Finished_Goods_Locations:35])
//$locs:=Records in selection([Finished_Goods_Locations])
$FG:=0
$CC:=0
$XC:=0
$EX:=0
$BH:=0
$NA:=0
$AV:=0
$Vista:=0
$transit:=0
$outside:=0

ARRAY TEXT:C222($aLocation; 0)
ARRAY LONGINT:C221($aQty; 0)

SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aLocation; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
$locs:=Size of array:C274($aLocation)
ARRAY TEXT:C222($badLocations; 0)
If (Count parameters:C259=1)
	$distributionList:=$1
Else 
	$distributionList:=Email_WhoAmI
End if 
uThermoInit($locs; "Tallying inventory")
For ($i; 1; $locs)
	Case of 
		: (Position:C15("transit"; $aLocation{$i})>0)
			$transit:=$transit+$aQty{$i}
			
		: ($aLocation{$i}="FG:V@")
			$Vista:=$Vista+$aQty{$i}
			
		: ($aLocation{$i}="@OS@")
			$outside:=$outside+$aQty{$i}
			
		: ($aLocation{$i}="FG:AV@")
			$AV:=$AV+$aQty{$i}
			
		: ($aLocation{$i}="FG@")
			$FG:=$FG+$aQty{$i}
			
		: ($aLocation{$i}="CC@")
			$CC:=$CC+$aQty{$i}
			
		: ($aLocation{$i}="XC@")
			$XC:=$XC+$aQty{$i}
			
		: ($aLocation{$i}="EX@")
			$EX:=$EX+$aQty{$i}
			
		Else 
			$NA:=$NA+$aQty{$i}
			APPEND TO ARRAY:C911($badLocations; $aLocation{$i})
	End case 
	
	//NEXT RECORD([Finished_Goods_Locations])
	uThermoUpdate($i)
End for 
uThermoClose

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Bill_and_Hold_Qty:108>0)
If (Records in selection:C76([Finished_Goods:26])>0)
	$BH:=Sum:C1([Finished_Goods:26]Bill_and_Hold_Qty:108)
End if 

$subject:="FG, CC, XC, EX, BH, & AV Totals as of "+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
$preBody:="Inventory quantities by primary categories--FG, CC, XC, EX, BH, & Consignment."
$table:=""

$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$e:="</td></tr>"+<>CR
$table:=$table+$b+"AREA"+$t+"QTY_ONHAND"+$e
$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"

$table:=$table+$b+"CONSIGN"+$t+String:C10($AV; "###,###,###,##0")+$e
$table:=$table+$b+"FG"+$t+String:C10($FG; "###,###,###,##0")+$e
$table:=$table+$b+"FGVista"+$t+String:C10($Vista; "###,###,###,##0")+$e
$table:=$table+$b+"FGTransit"+$t+String:C10($transit; "###,###,###,##0")+$e
$table:=$table+$b+"O/S"+$t+String:C10($outside; "###,###,###,##0")+$e
$table:=$table+$b+"CC"+$t+String:C10($CC; "###,###,###,##0")+$e
$table:=$table+$b+"XC"+$t+String:C10($XC; "###,###,###,##0")+$e
$table:=$table+$b+"EX"+$t+String:C10($EX; "###,###,###,##0")+$e
$table:=$table+$b+"BH"+$t+String:C10($BH; "###,###,###,##0")+$e

$table:=$table+$b+"INVALID:"+$t+String:C10($NA; "###,###,###,##0")+$e
For ($i; 1; Size of array:C274($badLocations))
	$table:=$table+$b+$badLocations{$i}+$t+" "+$e
End for 

//rPrintText 
Email_html_table($subject; $preBody; $table; 300; $distributionList)
// Modified by: Mel Bohince (12/3/15) save to disk also
docName:="FG_SUMMARY_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)  //doc created
	$t:=Char:C90(Tab:K15:37)
	xText:=""
	xText:=xText+"CONSIGN"+$t+String:C10($AV; "###,###,###,##0")+<>CR
	xText:=xText+"FG"+$t+String:C10($FG; "###,###,###,##0")+<>CR
	xText:=xText+"FGVista"+$t+String:C10($Vista; "###,###,###,##0")+<>CR
	xText:=xText+"FGTransit"+$t+String:C10($transit; "###,###,###,##0")+<>CR
	xText:=xText+"O/S"+$t+String:C10($outside; "###,###,###,##0")+<>CR
	xText:=xText+"CC"+$t+String:C10($CC; "###,###,###,##0")+<>CR
	xText:=xText+"XC"+$t+String:C10($XC; "###,###,###,##0")+<>CR
	xText:=xText+"EX"+$t+String:C10($EX; "###,###,###,##0")+<>CR
	xText:=xText+"BH"+$t+String:C10($BH; "###,###,###,##0")+<>CR
	
	xText:=xText+"INVALID:"+$t+String:C10($NA; "###,###,###,##0")+<>CR
	For ($i; 1; Size of array:C274($badLocations))
		xText:=xText+$badLocations{$i}+$t+" "+<>CR
	End for 
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
End if 

//