//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 01/07/11, 13:40:41
// ----------------------------------------------------
// Method: FG_Bill_and_Hold_Report
// Description
// report fg's with bill&hold qty set, look at inventory, and transactions
// ----------------------------------------------------

C_TEXT:C284($t; $r)
C_TEXT:C284(xTitle; xText; docName)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$r:=Char:C90(13)
xTitle:=""
xText:=""
docName:="Bill_and_Hold_"+String:C10(TSTimeStamp)+".xls"
$docRef:=util_putFileName(->docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; xTitle+$r+$r)
	
	CONFIRM:C162("Show only shortages?"; "Shortages"; "ALL")
	If (OK=1)
		$show_all:=False:C215
		CONFIRM:C162("Clear B&H qty where Onhand=0 and Scraps cover B&H?"; "Report Only"; "Clear")
		If (OK=1)
			$clear:=False:C215
		Else 
			$clear:=True:C214
		End if 
	Else 
		$show_all:=True:C214
		$clear:=False:C215
	End if 
	
	READ WRITE:C146([Finished_Goods:26])
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Bill_and_Hold_Qty:108>0)
	ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1; >)
	
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$numRecs:=Records in selection:C76([Finished_Goods:26])
	xText:=xText+"PRODUCT_CODE"+$t+"BILL&HOLD"+$t+"ON_HAND"+$t+"STATUS"+$t+"SHORTAGE"+$t+"X_DATE"+$t+"X_TYPE"+$t+"X_QTY"+$t+"SUMMARY"+$t+"X_BH"+$t+"X_SCRAP"+$r
	uThermoInit($numRecs; "Analyzing Records")
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		If (Length:C16(xText)>25000)
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
		
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1)
		$onhand:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
		
		If ($onhand>=[Finished_Goods:26]Bill_and_Hold_Qty:108)
			If ($show_all)
				xText:=xText+[Finished_Goods:26]ProductCode:1+$t+String:C10([Finished_Goods:26]Bill_and_Hold_Qty:108)+$t+String:C10($onhand)+$t
				xText:=xText+"OK"+$r+$r
			End if 
		Else 
			xText:=xText+[Finished_Goods:26]ProductCode:1+$t+String:C10([Finished_Goods:26]Bill_and_Hold_Qty:108)+$t+String:C10($onhand)+$t
			xText:=xText+"SHORT"+$t+String:C10([Finished_Goods:26]Bill_and_Hold_Qty:108-$onhand)+$r
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="B@"; *)
			QUERY:C277([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]XactionType:2="Sc@"; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]ProductCode:1=[Finished_Goods:26]ProductCode:1)
			$numXfers:=Records in selection:C76([Finished_Goods_Transactions:33])
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3; <)
				
				$scrapped:=0
				$bh:=0
				For ($xfer; 1; $numXfers)
					xText:=xText+(5*$t)+String:C10([Finished_Goods_Transactions:33]XactionDate:3)+$t+[Finished_Goods_Transactions:33]XactionType:2+$t+String:C10([Finished_Goods_Transactions:33]Qty:6)+$r
					
					Case of 
						: ([Finished_Goods_Transactions:33]XactionType:2="sc@")
							$scrapped:=$scrapped+[Finished_Goods_Transactions:33]Qty:6
						: ([Finished_Goods_Transactions:33]XactionType:2="b@")
							$bh:=$bh+[Finished_Goods_Transactions:33]Qty:6
					End case 
					
					NEXT RECORD:C51([Finished_Goods_Transactions:33])
					uThermoUpdate($i)
				End for 
				
			Else 
				
				ARRAY DATE:C224($_XactionDate; 0)
				ARRAY TEXT:C222($_XactionType; 0)
				ARRAY LONGINT:C221($_Qty; 0)
				
				
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $_XactionDate; [Finished_Goods_Transactions:33]XactionType:2; $_XactionType; [Finished_Goods_Transactions:33]Qty:6; $_Qty)
				
				SORT ARRAY:C229($_XactionDate; $_XactionType; $_Qty; <)
				
				
				$scrapped:=0
				$bh:=0
				For ($Iter; 1; $numXfers; 1)
					xText:=xText+(5*$t)+String:C10($_XactionDate{$Iter})+$t+$_XactionType{$Iter}+$t+String:C10($_Qty{$Iter})+$r
					
					Case of 
						: ($_XactionType{$Iter}="sc@")
							$scrapped:=$scrapped+$_Qty{$Iter}
						: ($_XactionType{$Iter}="b@")
							$bh:=$bh+$_Qty{$Iter}
					End case 
					
					uThermoUpdate($i)
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			xText:=xText+(8*$t)+"====>"+$t+String:C10($bh)+$t+String:C10($scrapped)
			xText:=xText+$r+$r
		End if 
		
		If ($clear)
			If ($onhand=0)
				If ($scrapped>=$bh)
					[Finished_Goods:26]Bill_and_Hold_Qty:108:=0
					SAVE RECORD:C53([Finished_Goods:26])
				End if 
			End if 
			//
		End if 
		NEXT RECORD:C51([Finished_Goods:26])
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	$err:=util_Launch_External_App(docName)
	
Else 
	BEEP:C151
	ALERT:C41("Couldn't open a document to save to.")
End if 