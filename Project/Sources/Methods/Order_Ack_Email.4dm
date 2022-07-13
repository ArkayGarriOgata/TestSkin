//%attributes = {"publishedWeb":true}
//PM:  Order_Ack_Email  090602  mlb
//compose and send the Acknowledgement as email
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	C_TEXT:C284($t; $cr)
	
	$t:=Char:C90(9)
	$cr:=Char:C90(13)
	$cr:="%0D"
	
	utl_Trace
	xTitle:="Arkay Order Acknowledgement"
	xText:="ARKAY ORDER ACKNOWLEDGEMENT"+$cr+$cr
	
	xText:=xText+"We gratefully acknowledge your order, numbered "+String:C10([Customers_Orders:40]OrderNumber:1)
	xText:=xText+", for brand "+[Estimates:17]Brand:3
	xText:=xText+" which we are entering into production based upon specifications in quote "
	xText:=xText+[Customers_Orders:40]EstimateNo:3+"-"+[Customers_Orders:40]CaseScenario:4+" and summarized below:"+$cr+$cr
	
	xText:=xText+"Stock: "+sStock+$cr
	xText:=xText+"Colors: "+String:C10(iColors)+$cr
	xText:=xText+"Embossing: "+sEmboss+$cr
	xText:=xText+"Coating: "+sCoating+$cr
	xText:=xText+"Stamping: "+sStamping+$cr
	xText:=xText+"Packing: "+sPacking+$cr
	
	xText:=xText+"F.O.B: "+sFOB+$cr
	xText:=xText+"Terms: "+sTerms+$cr
	xText:=xText+"Ship via: "+sShipVia+$cr
	xText:=xText+"Expiration: "+String:C10([Customers_Orders:40]ContractExpires:12; System date short:K1:1)+$cr+$cr
	
	xText:=xText+"PO      Product Code      Quantity      Price"+$cr
	FIRST RECORD:C50([Customers_Order_Lines:41])
	For ($i; 1; Records in selection:C76([Customers_Order_Lines:41]))
		xText:=xText+[Customers_Order_Lines:41]PONumber:21+"   "+[Customers_Order_Lines:41]ProductCode:5+"   "+String:C10([Customers_Order_Lines:41]Quantity:6; "###,###,###")+"   "+String:C10([Customers_Order_Lines:41]Price_Per_M:8; "$##,##0.00")+(Num:C11([Customers_Order_Lines:41]SpecialBilling:37)*" EA")+(Num:C11(Not:C34([Customers_Order_Lines:41]SpecialBilling:37))*" /M")+$cr
		NEXT RECORD:C51([Customers_Order_Lines:41])
	End for 
	
	QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=[Customers_Orders:40]SalesRep:13)
	If (Records in selection:C76([Customers_Orders:40])>0)
		$salesMan:=$t+[Salesmen:32]FirstName:3+"."+[Salesmen:32]LastName:2+"@arkay.com"
	Else 
		$salesMan:=""
	End if 
	$distributionList:=[Customers_Orders:40]Contact_Agent:36+$t+"Mitchell.Kaneff@arkay.com"+$salesMan
	t1:=xText
	If (True:C214)
		$cc:=Replace string:C233(Current user:C182; " "; ".")+"@arkay.com"
		util_OpenEmailClient("joe_customer@"+[Customers_Orders:40]CustomerName:39+".com"; $cc; "email.records@arkay.com"; xTitle; xText)
		
	Else 
		NewWindow(550; 400; 0; 5; "Make Corrections")
		DIALOG:C40([zz_control:1]; "text2_dio")
		CLOSE WINDOW:C154
		xText:=t1
		//QM_Sender (xTitle;"";xText;$distributionList)
		rPrintText("Ord Ack")
	End if 
Else 
	
	C_TEXT:C284($t; $cr)
	C_TEXT:C284($salesMan)  // Ps 4D add this line 
	
	$t:=Char:C90(9)
	$cr:=Char:C90(13)
	$cr:="%0D"
	
	utl_Trace
	xTitle:="Arkay Order Acknowledgement"
	xText:="ARKAY ORDER ACKNOWLEDGEMENT"+$cr+$cr
	
	xText:=xText+"We gratefully acknowledge your order, numbered "+String:C10([Customers_Orders:40]OrderNumber:1)
	xText:=xText+", for brand "+[Estimates:17]Brand:3
	xText:=xText+" which we are entering into production based upon specifications in quote "
	xText:=xText+[Customers_Orders:40]EstimateNo:3+"-"+[Customers_Orders:40]CaseScenario:4+" and summarized below:"+$cr+$cr
	
	xText:=xText+"Stock: "+sStock+$cr
	xText:=xText+"Colors: "+String:C10(iColors)+$cr
	xText:=xText+"Embossing: "+sEmboss+$cr
	xText:=xText+"Coating: "+sCoating+$cr
	xText:=xText+"Stamping: "+sStamping+$cr
	xText:=xText+"Packing: "+sPacking+$cr
	
	xText:=xText+"F.O.B: "+sFOB+$cr
	xText:=xText+"Terms: "+sTerms+$cr
	xText:=xText+"Ship via: "+sShipVia+$cr
	xText:=xText+"Expiration: "+String:C10([Customers_Orders:40]ContractExpires:12; System date short:K1:1)+$cr+$cr
	
	xText:=xText+"PO      Product Code      Quantity      Price"+$cr
	
	ARRAY TEXT:C222($_PONumber; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY LONGINT:C221($_Quantity; 0)
	ARRAY REAL:C219($_Price_Per_M; 0)
	ARRAY BOOLEAN:C223($_SpecialBilling; 0)
	
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]PONumber:21; $_PONumber; [Customers_Order_Lines:41]ProductCode:5; $_ProductCode; [Customers_Order_Lines:41]Quantity:6; $_Quantity; [Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M; [Customers_Order_Lines:41]SpecialBilling:37; $_SpecialBilling)
	
	For ($i; 1; Records in selection:C76([Customers_Order_Lines:41]))
		xText:=xText+$_PONumber{$i}+"   "+$_ProductCode{$i}+"   "+String:C10($_Quantity{$i}; "###,###,###")+"   "+String:C10($_Price_Per_M{$i}; "$##,##0.00")+(Num:C11($_SpecialBilling{$i})*" EA")+(Num:C11(Not:C34($_SpecialBilling{$i}))*" /M")+$cr
	End for 
	
	QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=[Customers_Orders:40]SalesRep:13)
	If (Records in selection:C76([Customers_Orders:40])>0)
		$salesMan:=$t+[Salesmen:32]FirstName:3+"."+[Salesmen:32]LastName:2+"@arkay.com"
	End if 
	
	$distributionList:=[Customers_Orders:40]Contact_Agent:36+$t+"Mitchell.Kaneff@arkay.com"+$salesMan
	t1:=xText
	$cc:=Replace string:C233(Current user:C182; " "; ".")+"@arkay.com"
	util_OpenEmailClient("joe_customer@"+[Customers_Orders:40]CustomerName:39+".com"; $cc; "email.records@arkay.com"; xTitle; xText)
	
End if   // END 4D Professional Services : January 2019 First record and next next record

