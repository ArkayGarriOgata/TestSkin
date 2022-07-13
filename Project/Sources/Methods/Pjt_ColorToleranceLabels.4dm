//%attributes = {"publishedWeb":true}
//Procedure: Pjt_ColorToleranceLabels
//based on rRptRMbarcodes()  121097  MLB.  UPR 237, based on rRpt_SchdLabels
//print barcoded put-away labels for R/Ms
//print labels to a CoStar SE250 throught the modem port

C_TEXT:C284($pjt)
C_LONGINT:C283($i; $numLabels)

READ ONLY:C145([Customers_Projects:9])
SET MENU BAR:C67(<>DefaultMenu)

$pjt:=Pjt_getReferId

If (<>HasLabelPrinter=0)
	<>HasLabelPrinter:=uPrintLabelSetPort
End if 

If (<>HasLabelPrinter#0)
	If (Length:C16($pjt)=5)
		QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$pjt)
		If (Records in selection:C76([Customers_Projects:9])>0)
			$cust:=Request:C163("Customer's Name?"; [Customers_Projects:9]CustomerName:4)
			$line:=Request:C163("Project?"; [Customers_Projects:9]Name:2)
			$type:=Request:C163("Approval for code(s)?"; "All Items")
			$date:=Request:C163("Dated?"; String:C10(4D_Current_date; System date short:K1:1))
			$freeText:=Request:C163("Short Free Text?")
			uPrintLabelColorTol  //set up the printer  
			$numLabels:=Num:C11(Request:C163("Number of copies"; "1"))
			For ($i; 1; $numLabels)
				uPrintLabelColorTol($requestId; $type; $date; $cust; $line; $freeText)
			End for 
			
			uPrintLabelColorTol("11")  //close the channel
			
		End if 
	End if 
End if 

uWinListCleanup