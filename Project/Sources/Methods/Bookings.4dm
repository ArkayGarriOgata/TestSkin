//%attributes = {"publishedWeb":true}
//PM: Bookings() -> 
//@author mlb - 4/3/03  16:00
//073106 exclude rental orderlines

// Modified by: Mel Bohince (9/26/18) added extended price and period to export in unused columns
// Modified by: Mel Bohince (2/8/19) use extended price value calc'd in OL's trigger
// Modified by: Mel Bohince (7/15/21) added read only
// Modified by: Mel Bohince (10/8/21) change from xls to csv file type

C_TEXT:C284(docName)
C_TIME:C306($docRef)
C_LONGINT:C283($fiscalYear)  //•3/27/00  mlb  fiscal year roll over
C_DATE:C307(dDateBegin; dDateEnd; $2; $1; $fiscalStartDate)

READ ONLY:C145([Customers_Order_Lines:41])  // Modified by: Mel Bohince (7/15/21) added read only

If (Count parameters:C259=2)
	dDateBegin:=$1
	dDateEnd:=$2
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13>=dDateBegin; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=dDateEnd)
	$numRecs:=Records in selection:C76([Customers_Order_Lines:41])
Else 
	$fiscalStartDate:=Date:C102(FiscalYear("start"; 4D_Current_date))
	$numRecs:=qryByDateRange(->[Customers_Order_Lines:41]DateOpened:13; "Orderline Opened from:"; $fiscalStartDate; 4D_Current_date-1)
End if 

If ($numRecs>0)
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"New"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Contract"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Open@"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Rejected"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustomerLine:42#"Rental"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4#"00614"; *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4#"01585")
	
	C_LONGINT:C283($i; $numRecs)
	C_BOOLEAN:C305($break)
	$break:=False:C215
	$numRecs:=Records in selection:C76([Customers_Order_Lines:41])
	If ($numRecs>0)
		docName:="Bookings"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")+".csv"
		$docRef:=util_putFileName(->docName)
		
		C_TEXT:C284($t; $cr)
		$t:=","  //Char(9)// Modified by: Mel Bohince (10/8/21) change from xls to csv file type
		$cr:="\r"  //Char(13)
		uThermoInit($numRecs; "Exporting Orderline Records")
		SEND PACKET:C103($docRef; "OrderLine"+$t+"SalesRep"+$t+"CustomerName"+$t+"CustomerLine"+$t+"Quantity"+$t+"Cost_Per_M"+$t+"Price_Per_M"+$t+"Net_Shipped"+$t+"ExtendedPrice"+$t+"specialBilling"+$t+"DateOpened"+$t+"Period"+$cr)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			//For ($i;1;$numRecs)
			//If ($break)
			//$i:=$i+$numRecs
			//End if 
			//RELATE ONE([Customers_Order_Lines]OrderNumber)
			//If ([Customers_Order_Lines]SpecialBilling)
			//$splBill:="True"
			//$extendedPrice:=[Customers_Order_Lines]Quantity*[Customers_Order_Lines]Price_Per_M
			//Else 
			//$splBill:="False"
			//$extendedPrice:=[Customers_Order_Lines]Quantity*[Customers_Order_Lines]Price_Per_M/1000
			//End if 
			
			
			//SEND PACKET($docRef;[Customers_Order_Lines]OrderLine+$t+[Customers_Order_Lines]SalesRep+$t+[Customers_Order_Lines]CustomerName+$t+[Customers_Order_Lines]CustomerLine+$t+String([Customers_Order_Lines]Quantity)+$t+String([Customers_Order_Lines]Cost_Per_M)+$t+String([Customers_Order_Lines]Price_Per_M)+$t+String([Customers_Order_Lines]Qty_Shipped-[Customers_Order_Lines]Qty_Returned)+$t+String($extendedPrice)+$t+$splBill+$t+String([Customers_Order_Lines]DateOpened;System date short)+$t+fYYYYMM ([Customers_Order_Lines]DateOpened)+$cr)  //+$t+String([Customers_Order_Lines]ExcessQtySold)
			
			//NEXT RECORD([Customers_Order_Lines])
			//uThermoUpdate ($i)
			//End for 
			
		Else 
			
			ARRAY BOOLEAN:C223($_SpecialBilling; 0)
			ARRAY LONGINT:C221($_Quantity; 0)
			ARRAY REAL:C219($_Price_Per_M; 0)
			ARRAY TEXT:C222($_OrderLine; 0)
			ARRAY TEXT:C222($_SalesRep; 0)
			ARRAY TEXT:C222($_CustomerName; 0)
			ARRAY TEXT:C222($_CustomerLine; 0)
			ARRAY REAL:C219($_Cost_Per_M; 0)
			ARRAY REAL:C219($_Price_Per_M; 0)
			ARRAY LONGINT:C221($_Qty_Shipped; 0)
			ARRAY LONGINT:C221($_Qty_Returned; 0)
			ARRAY DATE:C224($_DateOpened; 0)
			ARRAY REAL:C219($_ExtendedPrice; 0)  // Modified by: Mel Bohince (2/8/19) use value calc'd in OL's trigger
			
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]SpecialBilling:37; $_SpecialBilling; [Customers_Order_Lines:41]Quantity:6; $_Quantity; [Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M; [Customers_Order_Lines:41]OrderLine:3; $_OrderLine; [Customers_Order_Lines:41]SalesRep:34; $_SalesRep; [Customers_Order_Lines:41]CustomerName:24; $_CustomerName; [Customers_Order_Lines:41]CustomerLine:42; $_CustomerLine; [Customers_Order_Lines:41]Cost_Per_M:7; $_Cost_Per_M; [Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M; [Customers_Order_Lines:41]Qty_Shipped:10; $_Qty_Shipped; [Customers_Order_Lines:41]Qty_Returned:35; $_Qty_Returned; [Customers_Order_Lines:41]DateOpened:13; $_DateOpened; [Customers_Order_Lines:41]Price_Extended:73; $_ExtendedPrice)
			
			
			For ($i; 1; $numRecs)
				
				
				If ($_SpecialBilling{$i})
					$splBill:="True"
					//$extendedPrice:=$_Quantity{$i}*$_Price_Per_M{$i}// Modified by: Mel Bohince (2/8/19) use value calc'd in OL's trigger
				Else 
					$splBill:="False"
					//$extendedPrice:=$_Quantity{$i}*$_Price_Per_M{$i}/1000// Modified by: Mel Bohince (2/8/19) use value calc'd in OL's trigger
				End if 
				SEND PACKET:C103($docRef; $_OrderLine{$i}+$t+$_SalesRep{$i}+$t+txt_quote($_CustomerName{$i})+$t+txt_quote($_CustomerLine{$i})+$t+String:C10($_Quantity{$i})+$t+String:C10($_Cost_Per_M{$i})+$t+String:C10($_Price_Per_M{$i})+$t+String:C10($_Qty_Shipped{$i}-$_Qty_Returned{$i})+$t+String:C10($_ExtendedPrice{$i})+$t+$splBill+$t+String:C10($_DateOpened{$i}; System date short:K1:1)+$t+fYYYYMM($_DateOpened{$i})+$cr)
				
				uThermoUpdate($i)
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		uThermoClose
		//
		
		CLOSE DOCUMENT:C267($docRef)
		//$err:=// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		//If ($err=0)
		//zwStatusMsg ("Booking Data!";"Type Changed on document named: "+docName)
		//Else 
		//zwStatusMsg ("Booking Data!";"Type Changed on document named: "+docName+" Error: "+String($err))
		//End if 
		
		$err:=util_Launch_External_App(docName)
		If ($err=0)
			zwStatusMsg("Booking Data"; "Saved to document named: "+docName)
		Else 
			zwStatusMsg("Booking Data"; "Saved to document named: "+docName+" Error: "+String:C10($err))
		End if 
	End if 
End if 