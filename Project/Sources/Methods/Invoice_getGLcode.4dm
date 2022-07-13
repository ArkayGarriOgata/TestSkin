//%attributes = {"publishedWeb":true}
//PM: Invoice_getGLcode() -> 
//@author mlb - 8/9/01  11:11
//mlb 2/7/06 fix missing hyphen
// Modified by Mel Bohince on 1/3/07 at 10:33:38 : all dept codes as 000
C_TEXT:C284($0; $shippedFrom; $1)
$shippedFrom:="-000"
Case of 
	: (<>FlexwareActive)
		$shippedFrom:=[Customers_Bills_of_Lading:49]ShippedFrom:5
		Case of 
			: (Records in selection:C76([Customers_Bills_of_Lading:49])=0)
				$shippedFrom:="3-"
			: ($shippedFrom="1")
				$shippedFrom:=$shippedFrom+"-"
			: ($shippedFrom="2")
				$shippedFrom:=$shippedFrom+"-"
			Else 
				$shippedFrom:="3-"
		End case 
		$0:=$shippedFrom+[Finished_Goods_Classifications:45]FlexwareGLcode:5
		
	: (<>AcctVantageActive)
		$shippedFrom:=[Customers_Bills_of_Lading:49]ShippedFrom:5
		Case of 
			: (True:C214)
				$shippedFrom:="-000"  // Modified by Mel Bohince on 1/3/07 at 10:33:38 : 
				
			: (Records in selection:C76([Customers_Bills_of_Lading:49])=0)
				Case of 
					: ([Finished_Goods_Classifications:45]Class:1="80")  //rental
						$shippedFrom:="-300"
					: ([Finished_Goods_Classifications:45]Class:1="81")  //electric
						$shippedFrom:="-100"
					Else 
						$shippedFrom:="-200"
				End case 
				
			: ($shippedFrom="1")
				$shippedFrom:="-"+$shippedFrom+"00"  //mlb 2/7/06 fix missing hyphen
			: ($shippedFrom="2")
				$shippedFrom:="-"+$shippedFrom+"00"  //mlb 2/7/06 fix missing hyphen
			Else 
				$shippedFrom:="-200"
		End case 
		$0:=[Finished_Goods_Classifications:45]AcctVantageGLcode:6+$shippedFrom
		
	Else 
		$0:=[Finished_Goods_Classifications:45]AcctVantageGLcode:6+$shippedFrom
End case 
