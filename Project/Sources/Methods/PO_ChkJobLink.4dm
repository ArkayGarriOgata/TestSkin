//%attributes = {"publishedWeb":true}
// Method: PO_ChkJobLink () -> 0 if satisfied requirment
// ----------------------------------------------------
//was (p)schkJobPoLnk
//•032496  mBohince  use arrays
// • mel (10/28/04, 10:26:17) qry w/array and add rtn value

C_TEXT:C284($Items)
C_LONGINT:C283($hit; $i; $0)
ARRAY TEXT:C222($aPOItems; 0)
ARRAY TEXT:C222($aPOIcomm; 0)

SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]POItemKey:1; $aPOItems; [Purchase_Orders_Items:12]Commodity_Key:26; $aPOIcomm)
QUERY WITH ARRAY:C644([Raw_Materials_Groups:22]Commodity_Key:3; $aPOIcomm)  // • mel (10/28/04, 10:26:17) qry w/array and other chgs

//uRelateSelect (->[RM_GROUP]Commodity_Key;->[PO_Items]Commodity_Key;0)  `• 4/2/97 cs & Mlb changed from mesage to no message

ARRAY INTEGER:C220($aReceipt; 0)
ARRAY TEXT:C222($aRMCommKey; 0)
SELECTION TO ARRAY:C260([Raw_Materials_Groups:22]ReceiptType:13; $aReceipt; [Raw_Materials_Groups:22]Commodity_Key:3; $aRMCommKey)
REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
$hit:=Find in array:C230($aReceipt; 2)  //quick test for direct purchase

If ($hit<0)  //no direct purchases
	$Items:=""
	
Else   //make sure jobnumbers are specified
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		uRelateSelect(->[Purchase_Orders_Job_forms:59]POItemKey:1; ->[Purchase_Orders_Items:12]POItemKey:1; 0)  //• 4/2/97 cs & Mlb changed from mesage to no message
		
		QUERY SELECTION:C341([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]JobFormID:2#"")  // • mel (10/28/04, 10:26:17)
		
	Else 
		
		RELATE MANY SELECTION:C340([Purchase_Orders_Job_forms:59]POItemKey:1)
		QUERY SELECTION:C341([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]JobFormID:2#"")  // • mel (10/28/04, 10:26:17)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	ARRAY TEXT:C222($aJobLinks; 0)
	SELECTION TO ARRAY:C260([Purchase_Orders_Job_forms:59]POItemKey:1; $aJobLinks)
	REDUCE SELECTION:C351([Purchase_Orders_Job_forms:59]; 0)
	
	For ($i; 1; Size of array:C274($aPOItems))
		$hit:=Find in array:C230($aRMCommKey; $aPOIcomm{$i})
		If ($hit#-1)  //found the commodity
			If ($aReceipt{$hit}=2)  //direct purchase
				$hit:=Find in array:C230($aJobLinks; $aPOItems{$i})  //linked to a job?
				If ($hit<0)  //not linked so warn
					$Items:=$Items+(", "*Num:C11(Length:C16($Items)#0))+$aPOItems{$i}
				End if 
			End if 
		End if 
	End for 
End if 

$0:=Length:C16($Items)
If ($Items#"")
	zwStatusMsg("JOB LINKS"; "There is NO Job Form Record for Items: "+$Items+" You Must Create at least One for Each PO Item.")
End if 