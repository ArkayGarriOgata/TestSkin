//%attributes = {}
// Method: PnG_DeliverySchedule () -> 
// ----------------------------------------------------
// by: mel: 06/09/05, 14:38:48
// ----------------------------------------------------
// Description:
// read in a downloaded DeliverySchedule Doc and compare to Releases
// • mel (6/20/05, 11:35:31) clear prior imports
// • mel (11/18/10) added column for DS Line #
// • mel (2/3/11) allow plant name to be entered if not on csv file
// ----------------------------------------------------

READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ WRITE:C146([Finished_Goods:26])

C_TEXT:C284(xTitle; xText; $line; $columnHeaders)
C_TIME:C306($docRef)
C_DATE:C307($version)
C_TEXT:C284($period)  //fYYYYMM
C_TEXT:C284($t; $r)

$columnHeaders:="Schedule Date From,Timestamp,Time Zone,Material Number,Document,Item,DS Line #,Material Description,"
$columnHeaders:=$columnHeaders+"Base Unit,Change Indicator,New Indicator,P&G MRP Controller,Document Quantity,"
$columnHeaders:=$columnHeaders+"Notified Quantity,Delivered Quantity,Open Quantity,Storage Location,Last Updated,"
xTitle:=""
xText:=""
COMPARE_CUSTID:="00199"
$version:=4D_Current_date
$t:=","
$r:=Char:C90(13)
$eol:=Char:C90(10)
$quit:=True:C214

SET MENU BAR:C67(<>DefaultMenu)

Repeat 
	$docRef:=Open document:C264("")
	If ($docRef#?00:00:00?)
		RECEIVE PACKET:C104($docRef; $line; 1)
		$char:=Character code:C91($line)
		If ($char<14)
			$eol:=$line
		End if 
		$PnG_Plant:=""
		Repeat 
			RECEIVE PACKET:C104($docRef; $line; $eol)
		Until (Length:C16($line)>1) | (ok=0)
		//RECEIVE PACKET($docRef;$line;$eol)
		util_TextParser(5; $line; Character code:C91($t); Character code:C91($r))
		$PnG_Plant:=util_TextParser(5)
		If (Position:C15($PnG_Plant; " cayey belle swing brown iowa ")=0)
			//ask later, default to "swing" to get shipto 02033 in Greensboro
		End if 
		
		Case of 
			: (Position:C15("cayey"; $PnG_Plant)>0)
				$PnG_Plant:="01666"
			: (Position:C15("belle"; $PnG_Plant)>0)
				$PnG_Plant:="02284"
			: (Position:C15("swing"; $PnG_Plant)>0)
				$PnG_Plant:="02033"
			: (Position:C15("brown"; $PnG_Plant)>0)
				$PnG_Plant:="02439"
			: (Position:C15("iowa"; $PnG_Plant)>0)
				$PnG_Plant:="02620"
			: (Position:C15("hunt"; $PnG_Plant)>0)
				$PnG_Plant:="04475"
			Else 
				$PnG_Plant:=Request:C163("Which plant? cayey belle swing(02033) brown iowa "; "swing hunt Greensboro"; "OK"; "Don't Care")  // • mel (2/3/11) allow plant name to be entered if not on csv file
				Case of 
					: (Position:C15("cayey"; $PnG_Plant)>0)
						$PnG_Plant:="01666"
					: (Position:C15("belle"; $PnG_Plant)>0)
						$PnG_Plant:="02284"
					: (Position:C15("swing"; $PnG_Plant)>0)
						$PnG_Plant:="02033"
					: (Position:C15("brown"; $PnG_Plant)>0)
						$PnG_Plant:="02439"
					: (Position:C15("iowa"; $PnG_Plant)>0)
						$PnG_Plant:="02620"
					: (Position:C15("hunt"; $PnG_Plant)>0)
						$PnG_Plant:="04475"
					Else 
						$PnG_Plant:=Substring:C12($PnG_Plant; 1; 5)
				End case 
		End case 
		
		// • mel (6/20/05, 11:35:31) clear prior imports
		C_BOOLEAN:C305($continue)
		$continue:=False:C215
		READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
		QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8=$PnG_Plant)
		If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])>0)
			uConfirm("Delete the prior import of plant# "+$PnG_Plant+" ?"; "Delete"; "Skip Import")
			If (ok=1)
				util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
				QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8="")
				util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
				$continue:=True:C214
			End if 
		Else 
			$continue:=True:C214
		End if 
		
		RECEIVE PACKET:C104($docRef; $line; $eol)  //vendor name
		RECEIVE PACKET:C104($docRef; $line; $eol)  //address
		Repeat 
			RECEIVE PACKET:C104($docRef; $line; $eol)
		Until (Length:C16($line)>1) | (ok=0)
		
		If (ok=1) & ($continue)
			If ($line=$columnHeaders)  //continue
				RECEIVE PACKET:C104($docRef; $line; $eol)  //blankline
				If (Length:C16($line)=0)
					$currentSize:=300
					ARRAY TEXT:C222($cpn; $currentSize)
					ARRAY DATE:C224($schd; $currentSize)
					ARRAY LONGINT:C221($qty; $currentSize)
					ARRAY LONGINT:C221($qtyOrd; $currentSize)
					ARRAY LONGINT:C221($qtyRec; $currentSize)
					ARRAY TEXT:C222($refer; $currentSize)
					ARRAY TEXT:C222($asOf; $currentSize)
					C_LONGINT:C283($cursor)
					$cursor:=0
					RECEIVE PACKET:C104($docRef; $line; $eol)
					uThermoInit(200; "Importing from "+document)
					$thermo:=0
					While (ok=1) & (Length:C16($line)>0)
						util_TextParser(18; $line; Character code:C91($t); Character code:C91($r))
						$cursor:=$cursor+1
						$currentSize:=Size of array:C274($qty)
						If ($cursor>$currentSize)
							$currentSize:=$currentSize+20
							ARRAY TEXT:C222($cpn; $currentSize)
							ARRAY DATE:C224($schd; $currentSize)
							ARRAY LONGINT:C221($qty; $currentSize)
							ARRAY LONGINT:C221($qtyOrd; $currentSize)
							ARRAY LONGINT:C221($qtyRec; $currentSize)
							ARRAY TEXT:C222($refer; $currentSize)
							ARRAY TEXT:C222($asOf; $currentSize)
						End if 
						$cpn{$cursor}:=util_TextParser(4)
						$schd{$cursor}:=util_dateFromYYYYMMDD(util_TextParser(1))
						$qty{$cursor}:=Num:C11(util_TextParser(16))
						$qtyOrd{$cursor}:=Num:C11(util_TextParser(13))
						$qtyRec{$cursor}:=Num:C11(util_TextParser(15))
						$temp:=Num:C11(util_TextParser(14))
						If ($temp>$qtyRec{$cursor})
							$qtyRec{$cursor}:=$temp
						End if 
						$refer{$cursor}:=util_TextParser(5)+"."+util_TextParser(6)
						If (util_TextParser(3)="P")
							$refer{$cursor}:="<FDS>"+$refer{$cursor}
						End if 
						$asOf{$cursor}:=fYYMMDD(Date:C102(Substring:C12(util_TextParser(18); 1; 10)); 4)
						RECEIVE PACKET:C104($docRef; $line; $eol)
						$thermo:=$thermo+1
						uThermoUpdate($thermo)
					End while 
					
					ARRAY TEXT:C222($cpn; $cursor)
					ARRAY DATE:C224($schd; $cursor)
					ARRAY LONGINT:C221($qty; $cursor)
					ARRAY LONGINT:C221($qtyOrd; $cursor)
					ARRAY LONGINT:C221($qtyRec; $cursor)
					ARRAY TEXT:C222($refer; $cursor)
					ARRAY TEXT:C222($asOf; $cursor)
					MULTI SORT ARRAY:C718($cpn; >; $schd; >; $qty; $refer; $asOf)
					
					ARRAY TEXT:C222($id; $cursor)
					ARRAY TEXT:C222($plant; $cursor)
					ARRAY TEXT:C222($aCustid; $cursor)
					
					C_LONGINT:C283($i; $numElements)
					$numElements:=Size of array:C274($cpn)
					For ($i; 1; $numElements)
						$id{$i}:=String:C10($i; "00000")
						$plant{$i}:=$PnG_Plant
						$aCustid{$i}:="00199"
					End for 
					$thermo:=$thermo+((200-$thermo)/2)
					uThermoUpdate($thermo)
					
					REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
					ARRAY TO SELECTION:C261($id; [Finished_Goods_DeliveryForcasts:145]id:1; $cpn; [Finished_Goods_DeliveryForcasts:145]ProductCode:2; $schd; [Finished_Goods_DeliveryForcasts:145]DateDock:4; $qty; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; $refer; [Finished_Goods_DeliveryForcasts:145]refer:3; $plant; [Finished_Goods_DeliveryForcasts:145]ShipTo:8; $asOf; [Finished_Goods_DeliveryForcasts:145]asOf:9; $qtyOrd; [Finished_Goods_DeliveryForcasts:145]QtyWanted:5; $qtyRec; [Finished_Goods_DeliveryForcasts:145]QtyReceived:6; $aCustid; [Finished_Goods_DeliveryForcasts:145]Custid:12)
					$thermo:=$thermo+1
					//PnG_DeliveryScheduleCompare 
					$thermo:=200
					uThermoUpdate($thermo)
					uThermoClose
					
					PnP_setFGowner
					
				Else 
					uConfirm("Expected row 8 to be empty."; "Fix in Excel"; "Help")
				End if 
			End if 
		End if 
		CLOSE DOCUMENT:C267($docRef)
		BEEP:C151
	End if 
	
	uConfirm("Import another file?"; "Done"; "Another")
	If (ok=1)
		$quit:=True:C214
	Else 
		$quit:=False:C215
	End if 
Until ($quit)
REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)