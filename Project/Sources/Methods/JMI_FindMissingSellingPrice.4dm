//%attributes = {}
// -------
// Method: JMI_FindMissingSellingPrice   ( ) ->
// By: Mel Bohince @ 02/28/17, 15:35:30
// Description
// find items that may mess up the avg selling price on job closeouts
// ----------------------------------------------------
// Modified by: Mel Bohince (5/28/19) remove extra ref to  $_OrderItem which causes false positives
C_DATE:C307($dateEnd; $1; $dateBegin)

If (Count parameters:C259>0)
	$dateEnd:=$1  //Sunday
	$dateBegin:=$dateEnd-6  //Monday
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39>=$dateBegin; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39<=$dateEnd; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]OrderItem:2#"killed")
	$distributionList:=$2
	$subject:="Jobits without selling price"
	$prehead:="Completed Jobits without selling price between "+String:C10($dateBegin; Internal date short special:K1:4)+" and "+String:C10($dateEnd; Internal date short special:K1:4)+"."
	$r:="</td></tr>\r"
	//table heading
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$tableData:=$b+"JOBIT"+$t+"COMPLETED"+$t+"PRODUCT CODE"+$t+"ORDER ITEM"+$r
	//table row
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	
Else 
	utl_LogIt("init")
	qryByDateRange(->[Job_Forms_Items:44]Completed:39)
	QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2#"killed")
	//QUERY([Job_Forms_Items];[Job_Forms_Items]JobForm="13416.05")
End if 

If (Records in selection:C76([Job_Forms_Items:44])>0)
	
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	
	$break:=False:C215
	$numRecs:=Records in selection:C76([Job_Forms_Items:44])
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >)
		
		uThermoInit($numRecs; "Checking for price")
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			$sellingPrc:=0
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				$sellingPrc:=[Customers_Order_Lines:41]Price_Per_M:8
				
			Else   //is it a contract item?
				$numFound:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)  //•030599  MLB  UPR for len ron
				If ($numFound>0)
					$sellingPrc:=[Finished_Goods:26]RKContractPrice:49
				End if 
			End if 
			
			If ($sellingPrc<=0)  //report it
				
				<>USE_SUBCOMPONENT:=True:C214
				C_BOOLEAN:C305($isSubcomponent)  // Modified by: Mel Bohince (3/21/17) 
				$isSubcomponent:=(Substring:C12([Job_Forms_Items:44]OrderItem:2; 1; 2)="JC")
				If (Not:C34($isSubcomponent))
					
					If (Count parameters:C259>0)
						$tableData:=$tableData+$b+[Job_Forms_Items:44]Jobit:4+$t+String:C10([Job_Forms_Items:44]Completed:39; Internal date short special:K1:4)+$t+[Job_Forms_Items:44]ProductCode:3+$t+[Job_Forms_Items:44]OrderItem:2+$r
						
					Else 
						utl_LogIt([Job_Forms_Items:44]Jobit:4+"  "+String:C10([Job_Forms_Items:44]Completed:39; Internal date short special:K1:4)+" "+[Job_Forms_Items:44]ProductCode:3+"  "+[Job_Forms_Items:44]OrderItem:2)
					End if 
					
				End if   //subcomponent
				
			End if 
			
			NEXT RECORD:C51([Job_Forms_Items:44])
			uThermoUpdate($i)
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_Jobit; 0)
		ARRAY TEXT:C222($_OrderItem; 0)
		ARRAY TEXT:C222($_CustId; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_OrderItem; 0)
		ARRAY DATE:C224($_Completed; 0)
		
		// Modified by: Mel Bohince (5/28/19) remove second instance of $_OrderItem which causes false positives
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $_Jobit; [Job_Forms_Items:44]OrderItem:2; $_OrderItem; [Job_Forms_Items:44]CustId:15; $_CustId; [Job_Forms_Items:44]ProductCode:3; $_ProductCode; [Job_Forms_Items:44]Completed:39; $_Completed)  //;[Job_Forms_Items]OrderItem;$_OrderItem
		
		SORT ARRAY:C229($_Jobit; $_OrderItem; $_CustId; $_ProductCode; $_Completed; >)  //$_OrderItem
		
		uThermoInit($numRecs; "Checking for price")
		For ($i; 1; $numRecs; 1)
			$sellingPrc:=0
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$_OrderItem{$i})
			If (Records in selection:C76([Customers_Order_Lines:41])>0)
				$sellingPrc:=[Customers_Order_Lines:41]Price_Per_M:8
			Else 
				$numFound:=qryFinishedGood($_CustId{$i}; $_ProductCode{$i})  //•030599  MLB  UPR for len ron
				If ($numFound>0)
					$sellingPrc:=[Finished_Goods:26]RKContractPrice:49
				End if 
			End if 
			If ($sellingPrc<=0)  //report it
				<>USE_SUBCOMPONENT:=True:C214
				C_BOOLEAN:C305($isSubcomponent)  // Modified by: Mel Bohince (3/21/17) 
				$isSubcomponent:=(Substring:C12($_OrderItem{$i}; 1; 2)="JC")
				If (Not:C34($isSubcomponent))
					If (Count parameters:C259>0)
						$tableData:=$tableData+$b+$_Jobit{$i}+$t+String:C10($_Completed{$i}; Internal date short special:K1:4)+$t+$_ProductCode{$i}+$t+$_OrderItem{$i}+$r
					Else 
						utl_LogIt($_Jobit{$i}+"  "+String:C10($_Completed{$i}; Internal date short special:K1:4)+" "+$_ProductCode{$i}+"  "+$_OrderItem{$i})
					End if 
				End if   //subcomponent
			End if 
			uThermoUpdate($i)
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	uThermoClose
	
	
	
	If (Count parameters:C259>0)
		Email_html_table($subject; $prehead; $tableData; 650; $distributionList)
	Else 
		utl_LogIt("show")
	End if 
	
End if 
