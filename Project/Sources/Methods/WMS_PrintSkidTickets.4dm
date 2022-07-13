//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 01/20/06, 10:52:42
// ----------------------------------------------------
// Method: WMS_PrintSkidTickets
// Description
// replicate the multi-part carbon form used to record activity/qty's on a skid
//`print multiple "uniquely" numbered forms

// Parameters 
//jobit
// ----------------------------------------------------

//gather the data needed for the form

//print multiple "uniquely" numbered forms
C_TEXT:C284($lot; $1)
If (Count parameters:C259=0)
	$lot:=Request:C163("Jobit:"; ""; "Ok"; "Cancel")
Else 
	$lot:=$1
End if 
C_TEXT:C284($prefix)  //;$code39)
//$code39:="*"
C_LONGINT:C283($startingNumber; $startingNumber; $skidNo)
C_TEXT:C284($applicationCode)
C_DATE:C307(dDate)
dDate:=Current date:C33
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_Order_Lines:41])

util_PAGE_SETUP(->[WMS_ItemMasters:123]; "SkidTicket_Laser")
//PRINT SETTINGS

If (ok=1)
	
	$numberOfSkids:=Num:C11(Request:C163("How many Skid Tickets?"; "0"; "Print"; "Cancel"))
	If (ok=1) & ($numberOfSkids>0)
		
		$startingNumber:=Num:C11(Request:C163("Starting pallet number:"; "1"; "Print"; "Cancel"))  //WMS_nextSkidNumber ($numberOfSkids)
		
		zwStatusMsg("PRINTING"; "Skid Tickets "+String:C10($startingNumber; "000000")+" to "+String:C10($startingNumber-1+$numberOfSkids; "000000"))
		
		$applicationCode:="9"
		$applicationCode:=Request:C163("What is the SSCC app code desired?"; $applicationCode)
		
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "beforeLabeling")
			UNLOAD RECORD:C212([Job_Forms_Items:44])
			
		Else 
			CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "beforeLabeling")
			
		End if   // END 4D Professional Services : January 2019 
		
		$numRecs:=qryJMI($lot)
		
		$numRecs:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
		sDesc:=Uppercase:C13(Substring:C12([Finished_Goods:26]CartonDesc:3; 1; 80))
		
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Job_Forms_Items:44]CustId:15)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
		
		wmsSkidNumber:=$startingNumber
		$lastNumber:=$startingNumber+$numberOfSkids
		$skidNo:=0
		While (wmsSkidNumber<$lastNumber)
			$barcodeValue:=WMS_SkidId(""; "set"; $applicationCode; wmsSkidNumber)  //start with the last
			SSCC_HumanReadable:=WMS_SkidId($barcodeValue; "human")
			SSCC_Barcode:=WMS_SkidId(SSCC_HumanReadable; "barcode")
			
			PDF_setUp($lot+String:C10(wmsSkidNumber)+".pdf")
			Print form:C5([WMS_ItemMasters:123]; "SkidTicket_Laser")
			PAGE BREAK:C6
			wmsSkidNumber:=wmsSkidNumber+1
		End while 
		
		//For ($skid;1;$numberOfSkids)
		//$skidNo:=$startingNumber+$skid
		
		//wmsHumanReadable1:=$prefix+String($skidNo;"000000")
		//wmsCaseId1:=BarCode_128auto (wmsHumanReadable1)
		
		//PDF_setUp ($lot+String($skidNo)+".pdf")
		//Print form([WMS_ItemMasters];"SkidTicket_Laser")
		//PAGE BREAK
		//End for 
		zwStatusMsg("PRINTED"; "Skid Tickets "+String:C10($startingNumber)+" to "+String:C10($startingNumber-1+$numberOfSkids))
		
		
		USE NAMED SELECTION:C332("beforeLabeling")
		
	Else 
		BEEP:C151
		zwStatusMsg("PRINT CANCELLED"; "No Skid Tickets will be printed.")
	End if   //skid cnt cancelled
Else 
	zwStatusMsg("PRINT CANCELLED"; "No Skid Tickets will be printed.")
End if   //print settings cancelled

