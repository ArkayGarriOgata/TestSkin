//%attributes = {}
// Method: wms_verifyPalletContents () -> 
// ----------------------------------------------------
// by: mel: 12/16/04, 19:57:13
// ----------------------------------------------------
// Description:
// prototype a pallet integrity scan, P&G requires uniform pallets
// proceed with extreme prejudice
//called from [WMS-Compostion]verifyPalletLoad.t1()
// ----------------------------------------------------
C_TEXT:C284(t1)  //scan value
C_LONGINT:C283($actualCaseCount; $expectedCases)
C_TEXT:C284($palletID; $caseID)
C_BOOLEAN:C305($requireSameLot; $requireSameSKU; $requireCaseCount; $changePalletAttributes; $debug)
$requireSameLot:=True:C214  //this is an option
$requireSameSKU:=True:C214  //this is an option, redundent if ($requireSameLot=True)
$requireCaseCount:=True:C214  //this is an option, otherwise relabel
READ WRITE:C146([WMS_ItemMasters:123])  //
READ WRITE:C146([WMS_Compositions:124])  //store the pallet contents here
$cursor:=0
SET QUERY LIMIT:C395(1)  //sames should be unique by definition
$debug:=True:C214

Repeat   //continue process for each pallet until DONE is requested or shutdown
	$cursor:=$cursor+1
	ARRAY TEXT:C222(aPallet; 0)  //set up for an Array to Selection
	ARRAY TEXT:C222(aCase; 0)
	$exception:=""  //an exception affects current pallet but not process
	$changePalletAttributes:=False:C215
	
	//scan pallet`start a new pallet
	$palletID:=aBuffer{$cursor}
	
	//test for pending exception, if none proceed:
	//::::::::::::::::::::::::::::::::::::::::::::::::::::
	
	If (($palletID="DONE") | ($palletID="0"))
		$exception:="DONE WITH PROCESS"
		$msg:="Exit requested"
	End if 
	
	If (Length:C16($exception)=0)  //test valid pallet number
		QUERY:C277([WMS_ItemMasters:123]; [WMS_ItemMasters:123]Skidid:1=$palletID)
		If (Records in selection:C76([WMS_ItemMasters:123])#1) & (Not:C34($debug))
			$exception:="PALLET NOT FOUND"
			$msg:=$palletID+" not valid pallet id"
		End if 
	End if 
	
	If (Length:C16($exception)=0)  //test pallet is skid unit
		If ([WMS_ItemMasters:123]STATE:5#"SKID") & (Not:C34($debug))
			$exception:="NOT A SKID"
			$msg:=$palletID+" is not a SKID unit."
		End if 
	End if 
	
	If (Length:C16($exception)=0)  //set up the skid
		$palletRec:=Record number:C243([WMS_ItemMasters:123])  //may need to go back if this is a MIX
		$palletLot:=[WMS_ItemMasters:123]LOT:3
		$palletSKU:=[WMS_ItemMasters:123]SKU:2
		$expectedCases:=[WMS_ItemMasters:123]QTY:7  //this should reflect the packing specification
	End if 
	
	If (Length:C16($exception)=0)  //test lot specified
		If ($requireSameLot) & (Length:C16($palletLot)=0) & (Not:C34($debug))
			$exception:="PALLET LOT NOT SPECIFIED"
			$msg:=$palletID+" has no LOT"
		End if 
	End if 
	
	If (Length:C16($exception)=0)  //test sku specified
		If ($requireSameSKU) & (Length:C16($palletSKU)=0) & (Not:C34($debug))
			$exception:="PALLET SKU NOT SPECIFIED"
			$msg:=$palletID+" has no SKU"
		End if 
	End if 
	
	If (Length:C16($exception)=0)  //test case count specified
		If ($expectedCases=0)
			If ($requireCaseCount) & (Not:C34($debug))
				$exception:="PALLET CASE COUNT NOT SPECIFIED"
				$msg:=$palletID+" has no Case Count"
			Else 
				$expectedCases:=200  //dude...how high can you stack 'em.
			End if 
		End if 
	End if 
	
	ARRAY TEXT:C222(aPallet; $expectedCases)  //set up the containers
	ARRAY TEXT:C222(aCase; $expectedCases)
	$actualCaseCount:=0  //lets start scanning cases
	While ($actualCaseCount<$expectedCases) & (Length:C16($exception)=0)
		//scan case
		$cursor:=$cursor+1
		$caseID:=aBuffer{$cursor}
		If ($caseID="DONE") & (Length:C16($exception)=0)
			$exception:="DONE WITH PALLET"
			$msg:="Exit requested"
		End if 
		
		If ($caseID=$palletID) & (Length:C16($exception)=0)
			$exception:="DONE WITH PALLET"
			$msg:="Exit requested, Pallet re-scanned"
		End if 
		
		If (Length:C16($exception)=0)
			QUERY:C277([WMS_ItemMasters:123]; [WMS_ItemMasters:123]Skidid:1=$caseID)
			If (Records in selection:C76([WMS_ItemMasters:123])#1) & (Not:C34($debug))
				$exception:="ITEM NOT FOUND"
				$msg:=$caseID+" not valid $caseID id"
			End if 
		End if 
		
		If (Length:C16($exception)=0)
			If ([WMS_ItemMasters:123]STATE:5#"CASE") & (Not:C34($debug))
				$exception:="NOT A CASE"
				$msg:=$palletID+" is not a CASE unit."
			End if 
		End if 
		
		If (Length:C16($exception)=0)
			$hit:=Find in array:C230(aCase; $caseID)
			If ($hit>-1)
				$exception:="DUPLICATE SCAN"
				$msg:=$caseID+" was already scanned."
			End if 
		End if 
		
		If (Length:C16($exception)=0)  //prep for next set of tests
			$currentLot:=[WMS_ItemMasters:123]LOT:3
			$currentSKU:=[WMS_ItemMasters:123]SKU:2
		End if 
		
		If (Length:C16($exception)=0)
			If ($requireSameLot)  //most restrictive test
				If ($currentLot#$palletLot) & (Not:C34($debug))
					$exception:="MIXED LOT"
					$msg:=$caseID+" is not of "+$palletLot
				End if 
			Else 
				If ($currentLot#$palletLot)
					GOTO RECORD:C242([WMS_ItemMasters:123]; $palletRec)
					[WMS_ItemMasters:123]LOT:3:="MIX"
					$changePalletAttributes:=True:C214
				End if 
			End if 
		End if 
		
		If (Length:C16($exception)=0)
			If ($requireSameSKU)  //most restrictive test
				If ($currentSKU#$palletSKU)
					$exception:="MIXED LOT"
					$msg:=$caseID+" is not a "+$palletSKU
				End if 
			Else 
				If ($currentSKU#$palletSKU)
					GOTO RECORD:C242([WMS_ItemMasters:123]; $palletRec)
					[WMS_ItemMasters:123]SKU:2:="MIX"
					$changePalletAttributes:=True:C214
				End if 
			End if 
		End if 
		
		Case of   //how did the case scan go?
			: ($exception="DOUBLE SCAN")  //try another case?
				$msg:=$caseID+" was already scanned, try another"
				$exception:=""
				
			: ($exception="CASE NOT FOUND")  //try another case?
				$msg:=$caseID+" was not found, try again or quit"
				$exception:=""
				
			: (Length:C16($exception)>0)  //some other problem
				$msg:=$caseID+" had problem, try again or quit"
				$exception:=""
				
			Else 
				$actualCaseCount:=$actualCaseCount+1
				aPallet{$actualCaseCount}:=$palletID
				aCase{$actualCaseCount}:=$caseID
				If ($changePalletAttributes)
					SAVE RECORD:C53([WMS_ItemMasters:123])
				End if 
		End case 
		
	End while 
	
	If (Length:C16($exception)=0)
		If ($actualCaseCount#$expectedCases)
			If ($requireCaseCount)
				$exception:="WRONG CASE COUNT"
				$msg:=String:C10($actualCaseCount)+" cases scanned, "+String:C10($expectedCases)+" expected"
			Else 
				$exception:="SET CASE COUNT"
				$msg:=String:C10($actualCaseCount)+" cases scanned,  no required count specified"
			End if 
		End if 
	End if 
	
	Case of   //a problem was encountered at the pallet level
		: ($exception="PALLET NOT FOUND")  //fail
			ALERT:C41($msg)
			
		: ($exception="DONE WITH PROCESS")  //drop out of repeat loop
			ok:=0  // da da that's all folk's...
			
		: ($exception="NOT A SKID")  //fail
			
		: ($exception="PALLET LOT NOT SPECIFIED")  //fail
			
		: ($exception="PALLET SKU NOT SPECIFIED")  //fail
			
		: ($exception="PALLET CASE COUNT NOT SPECIFIED")  //re-label pallet?
			
		: ($exception="SET CASE COUNT")  //re-label pallet?
			
		: ($exception="WRONG CASE COUNT")  //fail
			
		: ($exception="NOT A CASE")  //fail
			
		: ($exception="MIXED LOT")  //fail
			
		: ($exception="MIXED SKU")  //fail
			
		: (Length:C16($exception)>0)  //some other problem
			
		Else   //good to go, save the pallet build
			REDUCE SELECTION:C351([WMS_Compositions:124]; 0)
			ARRAY TO SELECTION:C261(aPallet; [WMS_Compositions:124]Container:1; aCase; [WMS_Compositions:124]Content:2)
			REDUCE SELECTION:C351([WMS_Compositions:124]; 0)
	End case 
	
	$exception:=""  //reset
	
Until (ok=0)

//clean up
SET QUERY LIMIT:C395(0)
REDUCE SELECTION:C351([WMS_ItemMasters:123]; 0)
