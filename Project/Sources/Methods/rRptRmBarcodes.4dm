//%attributes = {"publishedWeb":true}
//Procedure: rRptRMbarcodes()  121097  MLB.  UPR 237, based on rRpt_SchdLabels
//print barcoded put-away labels for R/Ms
//print labels to a CoStar SE250 throught the modem port
//• 12/10/97 cs aded ability to print these labels based on a selected POI from 
//010698 change to desc
//  receiving screen (uses interprocess var)
//• 5/22/98 cs RM description was occasionally to long
C_TEXT:C284($input)
C_LONGINT:C283($numPOI; $count; $i)
C_TEXT:C284($vendor; $rmCode)
READ ONLY:C145([Purchase_Orders_Items:12])
READ ONLY:C145([Vendors:7])
SET MENU BAR:C67(<>DefaultMenu)
C_TEXT:C284(<>RMBarCodePO)  //• 12/10/97 cs 
C_REAL:C285(<>RMPOICount)  //• 12/10/97 cs 

If (<>HasLabelPrinter=0)
	<>HasLabelPrinter:=uPrintLabelSetPort
End if 
If (<>HasLabelPrinter#0)
	Repeat 
		
		If (<>RMBarCodePO#"")  //• 12/10/97 cs 
			uConfirm("Print Barcode labels for: "+<>RMBarCodePO+"?")  //• 12/10/97 cs 
			
			If (OK=1)  //• 12/10/97 cs 
				$Input:=<>RMBarCodePO
			End if 
		Else 
			$input:=Substring:C12(Request:C163("Enter a Purchase Order Item number to print:"; "123456789"); 1; 9)
		End if 
		
		If (ok=1)
			
			If (Length:C16($input)=9)
				QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$input)
				$numPOI:=Records in selection:C76([Purchase_Orders_Items:12])
				
				If ($numPOI=1)
					$rmCode:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
					$desc:=Substring:C12([Purchase_Orders_Items:12]RM_Description:7; 1; 40)  //• 5/22/98 cs changed from [PO_ITEMS]RM_Description  
					$uom:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
					$dept:=[Purchase_Orders_Items:12]CompanyID:45+" - "+[Purchase_Orders_Items:12]DepartmentID:46
					
					If (<>RMPOICount>0)  //• 12/10/97 cs 
						$Count:=<>RMPOICount
					Else 
						$Count:=1
					End if 
					$count:=Num:C11(Request:C163("Enter the number of labels you need:"; String:C10($Count)))  //• 12/10/97 cs               
					
					Case of 
						: ($count<1)
							$count:=1
						: ($count>20)
							BEEP:C151
							CONFIRM:C162("Are you sure you want to print "+String:C10($count)+" labels?")
							
							If (ok=0)
								$count:=1
							End if 
					End case 
					
					QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders_Items:12]VendorID:39)
					$vendor:=[Vendors:7]Name:2
					REDUCE SELECTION:C351([Vendors:7]; 0)
					RM_PrintLabel  //set up the printer  
					
					For ($i; 1; $count)
						RM_PrintLabel($input; $rmCode; $desc; $vendor; $uom; $dept)
					End for 
					RM_PrintLabel("11")  //close the channel
					
				Else 
					BEEP:C151
					ALERT:C41($input+" was not found, try again or cancel.")
				End if 
				REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
				
			Else   //wrong length
				BEEP:C151
				ALERT:C41("9 character PO Item number must be entered in the form: 012345612")
			End if   //length
			
		End if   //ok'd
		
	Until (ok=0)
	
End if   //connected  

uWinListCleanup
//