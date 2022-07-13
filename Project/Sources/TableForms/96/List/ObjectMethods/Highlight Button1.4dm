If (True:C214)
	IBOL_IntraPlanTransfer
Else 
	C_DATE:C307(dDate)
	dDate:=4D_Current_date
	C_TEXT:C284($r)
	$r:=Char:C90(13)
	C_TEXT:C284($SHIPTO; $SOLDTO)
	$SOLDTO:="02565"  //The Olay Co
	$SHIPTO:="02563"  //RAMA
	C_BOOLEAN:C305($continue)
	$continue:=True:C214
	C_LONGINT:C283(<>BOL; $numPallets)
	uConfirm("Create a new Bill of Lading?"; "Yes"; "Existing")
	If (ok=1)
		CREATE RECORD:C68([Customers_Bills_of_Lading:49])
		[Customers_Bills_of_Lading:49]ShippersNo:1:=app_AutoIncrement(->[Customers_Bills_of_Lading:49])
		<>BOL:=[Customers_Bills_of_Lading:49]ShippersNo:1
		[Customers_Bills_of_Lading:49]ShipDate:20:=dDate
		[Customers_Bills_of_Lading:49]Carrier:9:="Horizon"
		If (User in group:C338(Current user:C182; "Roanoke"))
			[Customers_Bills_of_Lading:49]ShippedFrom:5:="2"
		Else 
			[Customers_Bills_of_Lading:49]ShippedFrom:5:="1"
		End if 
		[Customers_Bills_of_Lading:49]Total_Cartons:12:=Sum:C1([WMS_SerializedShippingLabels:96]Quantity:4)
		[Customers_Bills_of_Lading:49]Total_Skids:17:=Records in selection:C76([WMS_SerializedShippingLabels:96])
		[Customers_Bills_of_Lading:49]Notes:7:=""  //add packing slip below
		[Customers_Bills_of_Lading:49]DockAppointment:21:="Outside Finishing"
		[Customers_Bills_of_Lading:49]PayUse:23:=True:C214
		[Customers_Bills_of_Lading:49]BillTo:4:=$SOLDTO
		[Customers_Bills_of_Lading:49]ShipTo:3:=$SHIPTO
		SAVE RECORD:C53([Customers_Bills_of_Lading:49])
		<>BOL:=[Customers_Bills_of_Lading:49]ShippersNo:1
		$setting:=True:C214
		
	Else 
		uConfirm("Are you Adding to the BOL or just re-Printing?"; "Add"; "Reprint")
		If (ok=1)
			$setting:=True:C214
			<>BOL:=Num:C11(Request:C163("Enter Shipper's Number (BOL#) for these pallets:"; String:C10(<>BOL); "Set"; "Cancel"))
		Else 
			$setting:=False:C215
			<>BOL:=Num:C11(Request:C163("Enter Shipper's Number (BOL#) to reprint:"; String:C10(<>BOL); "Print"; "Cancel"))
		End if 
		If (ok=1)
			READ WRITE:C146([Customers_Bills_of_Lading:49])  //update date and skids
			QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=<>BOL)
			If (Records in selection:C76([Customers_Bills_of_Lading:49])=1)
				If (Not:C34(fLockNLoad(->[Customers_Bills_of_Lading:49])))  //can modify
					$continue:=False:C215
				End if 
			Else   //bol not found
				$continue:=False:C215
				<>BOL:=-1
			End if 
		Else   //cancelled
			$continue:=False:C215
			<>BOL:=-2
		End if 
	End if 
	
	Case of 
		: ($continue)
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
				
				COPY NAMED SELECTION:C331([WMS_SerializedShippingLabels:96]; "beforePrint")
				
				
			Else 
				
				ARRAY LONGINT:C221($_beforePrint; 0)
				LONGINT ARRAY FROM SELECTION:C647([WMS_SerializedShippingLabels:96]; $_beforePrint)
				
				
			End if   // END 4D Professional Services : January 2019 
			If ($setting)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
					
					ORDER BY:C49([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]Jobit:3; >; [WMS_SerializedShippingLabels:96]HumanReadable:5; >)
					FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
					
					
				Else 
					
					ORDER BY:C49([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]Jobit:3; >; [WMS_SerializedShippingLabels:96]HumanReadable:5; >)
					
				End if   // END 4D Professional Services : January 2019 First record
				//cross reference the BOL
				For ($i; 1; Records in selection:C76([WMS_SerializedShippingLabels:96]))
					If (fLockNLoad(->[WMS_SerializedShippingLabels:96]))
						[WMS_SerializedShippingLabels:96]ShippersNumber:14:=<>BOL
						[WMS_SerializedShippingLabels:96]Sent:15:=dDate
						SAVE RECORD:C53([WMS_SerializedShippingLabels:96])
						
						WIP_comesBack("Flat"; [WMS_SerializedShippingLabels:96]HumanReadable:5)
						
					Else 
						BEEP:C151
						ALERT:C41([WMS_SerializedShippingLabels:96]HumanReadable:5+" could not be marked as Sent.")
					End if 
					NEXT RECORD:C51([WMS_SerializedShippingLabels:96])
				End for 
			End if 
			
			//prep a report for everything on this BOL
			QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]ShippersNumber:14=<>BOL)
			$numPallets:=Records in selection:C76([WMS_SerializedShippingLabels:96])
			If ([Customers_Bills_of_Lading:49]Total_Skids:17#$numPallets)
				[Customers_Bills_of_Lading:49]Total_Skids:17:=$numPallets
			End if 
			
			If ([Customers_Bills_of_Lading:49]ShipDate:20#dDate)
				uConfirm("Change the Ship date to "+String:C10(dDate; System date short:K1:1)+"?")
				If (ok=1)
					[Customers_Bills_of_Lading:49]ShipDate:20:=dDate
				End if 
			End if 
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				ORDER BY:C49([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]Jobit:3; >; [WMS_SerializedShippingLabels:96]HumanReadable:5; >)
				FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
				
				
			Else 
				
				ORDER BY:C49([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]Jobit:3; >; [WMS_SerializedShippingLabels:96]HumanReadable:5; >)
				
			End if   // END 4D Professional Services : January 2019 First record
			$currentJobit:=[WMS_SerializedShippingLabels:96]Jobit:3
			$palletsForJobit:=0
			$columnTitles1:="ITEM  SSCC#                        QTY      LOT#       P&G ITEM   PO"
			$columnTitles2:="----  --------------------------  -----  -----------   --------   ----------"
			utl_LogIt("init")
			utl_LogIt(String:C10($numPallets)+" Pallets on Bill of Lading# "+String:C10(<>BOL)+" detailed below:")
			utl_LogIt($columnTitles1)
			utl_LogIt($columnTitles2)
			//utl_LogIt ("**")
			//utl_LogIt ("JobItem: "+$currentJobit)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				For ($i; 1; $numPallets)
					If ($currentJobit#[WMS_SerializedShippingLabels:96]Jobit:3)
						utl_LogIt("** "+String:C10($palletsForJobit)+" pallets for lot# "+$currentJobit)
						$currentJobit:=[WMS_SerializedShippingLabels:96]Jobit:3
						$palletsForJobit:=0
						//utl_LogIt ("JobItem: "+$currentJobit)
					End if 
					$palletsForJobit:=$palletsForJobit+1
					utl_LogIt(" "+String:C10($i; "00")+"   "+BarCode_HumanReadableSSCC([WMS_SerializedShippingLabels:96]HumanReadable:5)+"  "+String:C10([WMS_SerializedShippingLabels:96]Quantity:4)+"  "+$currentJobit+"   "+[WMS_SerializedShippingLabels:96]CPN:2+"   "+[WMS_SerializedShippingLabels:96]POnumber:10)
					If ([WMS_SerializedShippingLabels:96]CPN:2="MIXED")  //print the details after doing a little touch up
						$cr:=Position:C15($r; [WMS_SerializedShippingLabels:96]Comment:17)+1
						$comments:=Substring:C12([WMS_SerializedShippingLabels:96]Comment:17; $cr)  //strip the column headings
						$cr:=Position:C15($r; $comments)
						While ($cr>0)
							$line:=Substring:C12($comments; 1; $cr)
							$line:=Replace string:C233($line; "~"; (" "*28))  //pad it
							$posDesc:=Position:C15("{"; $line)
							$line:=Substring:C12($line; 1; $posDesc-1)  //trunc the description
							utl_LogIt($line)
							$comments:=Substring:C12($comments; $cr+1)
							$cr:=Position:C15(Char:C90(13); $comments)
						End while 
					End if 
					NEXT RECORD:C51([WMS_SerializedShippingLabels:96])
				End for 
				
			Else 
				
				ARRAY TEXT:C222($_Jobit; 0)
				ARRAY TEXT:C222($_HumanReadable; 0)
				ARRAY LONGINT:C221($_Quantity; 0)
				ARRAY TEXT:C222($_CPN; 0)
				ARRAY TEXT:C222($_POnumber; 0)
				ARRAY TEXT:C222($_Comment; 0)
				
				
				SELECTION TO ARRAY:C260([WMS_SerializedShippingLabels:96]Jobit:3; $_Jobit; [WMS_SerializedShippingLabels:96]HumanReadable:5; $_HumanReadable; [WMS_SerializedShippingLabels:96]Quantity:4; $_Quantity; [WMS_SerializedShippingLabels:96]CPN:2; $_CPN; [WMS_SerializedShippingLabels:96]POnumber:10; $_POnumber; [WMS_SerializedShippingLabels:96]Comment:17; $_Comment)
				
				
				For ($i; 1; $numPallets; 1)
					If ($currentJobit#$_Jobit{$i})
						utl_LogIt("** "+String:C10($palletsForJobit)+" pallets for lot# "+$currentJobit)
						$currentJobit:=$_Jobit{$i}
						$palletsForJobit:=0
					End if 
					$palletsForJobit:=$palletsForJobit+1
					utl_LogIt(" "+String:C10($i; "00")+"   "+BarCode_HumanReadableSSCC($_HumanReadable{$i})+"  "+String:C10($_Quantity{$i})+"  "+$currentJobit+"   "+$_CPN{$i}+"   "+$_POnumber{$i})
					If ($_CPN{$i}="MIXED")  //print the details after doing a little touch up
						$cr:=Position:C15($r; $_Comment{$i})+1
						$comments:=Substring:C12($_Comment{$i}; $cr)  //strip the column headings
						$cr:=Position:C15($r; $comments)
						While ($cr>0)
							$line:=Substring:C12($comments; 1; $cr)
							$line:=Replace string:C233($line; "~"; (" "*28))  //pad it
							$posDesc:=Position:C15("{"; $line)
							$line:=Substring:C12($line; 1; $posDesc-1)  //trunc the description
							utl_LogIt($line)
							$comments:=Substring:C12($comments; $cr+1)
							$cr:=Position:C15(Char:C90(13); $comments)
						End while 
					End if 
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			utl_LogIt("** "+String:C10($palletsForJobit)+" pallets for lot# "+$currentJobit)
			utl_LogIt("End of Bill of Lading# "+String:C10(<>BOL))
			
			
			xText:=tCalculationLog
			tCalculationLog:=tCalculationLog
			
			[Customers_Bills_of_Lading:49]Notes:7:=tCalculationLog
			If (Modified record:C314([Customers_Bills_of_Lading:49]))
				SAVE RECORD:C53([Customers_Bills_of_Lading:49])
			End if 
			
			uConfirm("Print Shipper/Packing Slip?"; "Print"; "Later")
			If (ok=1)
				util_PAGE_SETUP(->[Customers_Bills_of_Lading:49]; "ShipperDoc")
				FORM SET OUTPUT:C54([Customers_Bills_of_Lading:49]; "ShipperDoc")
				$rows:=util_text2array(->xText)
				
				iPage:=1
				$lineNum:=1
				$row:=1
				$maxLines:=35
				$numPages:=$rows\$maxLines
				If (($rows%$maxLines)>0)
					$numPages:=$numPages+1
				End if 
				t10:=" of "+String:C10($numPages)
				xText:=""
				Repeat 
					PDF_setUp("BOL"+"_"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+"_"+String:C10(iPage)+".pdf")
					
					While ($lineNum<=$maxLines) & ($row<=$rows)
						xText:=xText+axText{$row}+$r
						$lineNum:=$lineNum+1
						$row:=$row+1
					End while 
					PRINT RECORD:C71([Customers_Bills_of_Lading:49]; *)
					$lineNum:=1
					iPage:=iPage+1
					xText:=$columnTitles1+$r+$columnTitles2+$r
				Until ($row>$rows)
				
				FORM SET OUTPUT:C54([WMS_SerializedShippingLabels:96]; "List")
			End if 
			
			uConfirm("Prepare Advanced Shipment Notice?"; "Prepare"; "Later")
			If (ok=1)
				utl_LogIt("show")
			End if 
			
			uConfirm("Display all SSCC's for "+String:C10(<>BOL); "ALL"; "Just Added")
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
				
				If (ok=0)
					USE NAMED SELECTION:C332("beforePrint")
				End if 
				CLEAR NAMED SELECTION:C333("beforePrint")
				
			Else 
				
				If (ok=0)
					
					CREATE SELECTION FROM ARRAY:C640([WMS_SerializedShippingLabels:96]; $_beforePrint)
					
				End if 
				
			End if   // END 4D Professional Services : January 2019 
			
		: (<>BOL<=0)
			BEEP:C151
			ALERT:C41("You need to enter a valid BOL number.")
			
		Else   //locked
			BEEP:C151
	End case 
End if   //true
