//%attributes = {}
// Method: WMS_LookUp () -> 
// ----------------------------------------------------
// by: mel: 01/21/05, 12:42:57
// ----------------------------------------------------
// Description:
// get info abouta a scanned code


// ----------------------------------------------------

C_TEXT:C284($human; $lot; $serial; $qty)
READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Finished_Goods:26])
SET QUERY LIMIT:C395(1)
Repeat 
	$scanned:=Request:C163("Scan barcode or Cancel:")
	If (ok=1)
		
		Case of 
			: (Length:C16($scanned)=22)
				$human:=WMS_CaseId($scanned; "human")
				$lot:=WMS_CaseId($scanned; "jobit")
				$serial:=WMS_CaseId($scanned; "serial")
				$qty:=WMS_CaseId($scanned; "qty")
				sDesc:="LOT NUMBER NOT FOUND"
				
				QUERY:C277([WMS_ItemMasters:123]; [WMS_ItemMasters:123]LOT:3=$lot)
				$numJMI:=qryJMI($lot)
				If ($numJMI>0)
					qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
					sDesc:=Uppercase:C13([Finished_Goods:26]CartonDesc:3)
					QUERY:C277([Customers:16]; [Customers:16]ID:1=[Job_Forms_Items:44]CustId:15)
				End if 
				
				ALERT:C41($human+Char:C90(13)+"F/G: "+[Job_Forms_Items:44]ProductCode:3+Char:C90(13)+sDesc)
		End case 
		
	End if 
Until (ok=0)
SET QUERY LIMIT:C395(0)