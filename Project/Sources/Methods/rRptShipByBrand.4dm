//%attributes = {"publishedWeb":true}
//Procedure: rRptShipByBrand
//4/25/95 upr 1472
//5/4/95 add break on Brand
//•051195 save file not from mth end suite
//•061395  MLB  UPR 176 rewrite cause compiled version accum. style failed
//•090895  MLB  UPR 228
//•100997  mBohince  specific division, so get the fg transactions 

C_LONGINT:C283(iShipTot; iShipments; iShipQty; iTotShipQty)
C_LONGINT:C283(rb1; rb2; rb3; rb4; rb5; rb6; Li1; Li2; $i)
C_TEXT:C284($prefix)

rb1:=0  //cust b1 total shipments
rb2:=0  //cust b1 total qty
rb3:=0  //brand b2 total shipments
rb4:=0  //brand b2 total qty
rb5:=0  //cpn/shipto total shipments
rb6:=0  //cpn/shipto total qty
Li1:=0
Li2:=0
iShipments:=0
iShipQty:=0
//iShipTot:=0  `break totals
//iTotShipQty:=0  `break totals
READ ONLY:C145([Customers:16])
READ ONLY:C145([Customers_ReleaseSchedules:46])
t2:="Shipment Quantities by Customer and Brand"  //titles
t2b:="For Dates : "+String:C10(dDateBegin)+" - "+String:C10(dDateEnd)
dDate:=4D_Current_date
tTime:=4d_Current_time
//*Get a selection of release records
If (Count parameters:C259=0)  //called from month end suite
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>=dDateBegin; *)  //search for all customers in date range
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7<=dDateEnd; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8>0)  // dont include returns
	//*set up printer
	util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "ShipmentByBrand")  //•090895  MLB  UPR 228
	$fContinue:=True:C214
	
Else   //called from fg report menu
	//•051195 save file not from mth end suite
	C_BOOLEAN:C305(fSave)
	//uConfirm ("Would you like to also save this report in Excel format?";"Save file";"Don't save")
	//If (ok=1)
	//vDoc:=Create document("")
	//If (ok=1)
	//fSave:=True
	//Else 
	fSave:=False:C215
	//End if 
End if 

$fContinue:=False:C215
$Start:=$1
$End:=$2
$Cust:=$3
//SEARCH([ReleaseSchedule];[ReleaseSchedule]CustID="00152";*)  `••••debug
//SEARCH([ReleaseSchedule]; | [ReleaseSchedule]CustID="00235";*)
//SEARCH([ReleaseSchedule]; | [ReleaseSchedule]CustID="00050";*)
//If (uNowOrDelay )  `print now?
$fContinue:=True:C214
//End if 
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=$Cust; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7>=$Start; *)  //search for specified cusatomer in date range
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7<=$End; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8>0)  // dont include returns

Case of   //•100997  mBohince  specific division, so get the fg transactions 
	: (rbVendor=1)
		t2:="Hauppauge "+t2
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "theHits")
			For ($i; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=([Customers_ReleaseSchedules:46]OrderLine:4+"/"+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)))
				ARRAY TEXT:C222($aBins; 0)
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]viaLocation:11; $aBins)
				If (Size of array:C274($aBins)>0)  //just test the first one
					$prefix:=Substring:C12($aBins{1}; 1; 4)
					If (Position:C15("R"; $prefix)=0)
						ADD TO SET:C119([Customers_ReleaseSchedules:46]; "theHits")
					End if 
				End if 
				NEXT RECORD:C51([Customers_ReleaseSchedules:46])
			End for 
			USE SET:C118("theHits")
			CLEAR SET:C117("theHits")
			
		Else 
			
			// Laghzaoui replace  next by selection and empty set and add record
			
			ARRAY TEXT:C222($_OrderLine; 0)
			ARRAY LONGINT:C221($_ReleaseNumber; 0)
			ARRAY LONGINT:C221($_Record_number; 0)
			ARRAY LONGINT:C221($_Record_finale; 0)
			
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine; \
				[Customers_ReleaseSchedules:46]ReleaseNumber:1; $_ReleaseNumber; \
				[Customers_ReleaseSchedules:46]; $_Record_number)
			
			For ($i; 1; Size of array:C274($_OrderLine); 1)
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=($_OrderLine{$i}+"/"+String:C10($_ReleaseNumber{$i})))
				ARRAY TEXT:C222($aBins; 0)
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]viaLocation:11; $aBins)
				If (Size of array:C274($aBins)>0)  //just test the first one
					$prefix:=Substring:C12($aBins{1}; 1; 4)
					If (Position:C15("R"; $prefix)=4)
						APPEND TO ARRAY:C911($_Record_finale; $_Record_number{$i})
					End if 
				End if 
			End for 
			CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_Record_finale)
			
		End if   // END 4D Professional Services : January 2019 
		
	: (rbDivision=1)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			t2:="Roanoke "+t2
			
			CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "theHits")
			For ($i; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=([Customers_ReleaseSchedules:46]OrderLine:4+"/"+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)))
				ARRAY TEXT:C222($aBins; 0)
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]viaLocation:11; $aBins)
				If (Size of array:C274($aBins)>0)  //just test the first one
					$prefix:=Substring:C12($aBins{1}; 1; 4)
					If (Position:C15("R"; $prefix)=4)
						ADD TO SET:C119([Customers_ReleaseSchedules:46]; "theHits")
					End if 
				End if 
				NEXT RECORD:C51([Customers_ReleaseSchedules:46])
			End for 
			USE SET:C118("theHits")
			CLEAR SET:C117("theHits")
			FIRST RECORD:C50([Customers_ReleaseSchedules:46])
			
		Else 
			// Laghzaoui replace  next by selection and empty set and add record
			t2:="Roanoke "+t2
			
			ARRAY TEXT:C222($_OrderLine; 0)
			ARRAY LONGINT:C221($_ReleaseNumber; 0)
			ARRAY LONGINT:C221($_Record_number; 0)
			ARRAY LONGINT:C221($_Record_finale; 0)
			
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine; \
				[Customers_ReleaseSchedules:46]ReleaseNumber:1; $_ReleaseNumber; \
				[Customers_ReleaseSchedules:46]; $_Record_number)
			
			For ($i; 1; Size of array:C274($_OrderLine); 1)
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=($_OrderLine{$i}+"/"+String:C10($_ReleaseNumber{$i})))
				ARRAY TEXT:C222($aBins; 0)
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]viaLocation:11; $aBins)
				If (Size of array:C274($aBins)>0)  //just test the first one
					$prefix:=Substring:C12($aBins{1}; 1; 4)
					If (Position:C15("R"; $prefix)=4)
						
						APPEND TO ARRAY:C911($_Record_finale; $_Record_number{$i})
						
					End if 
				End if 
			End for 
			
			CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_Record_finale)
			FIRST RECORD:C50([Customers_ReleaseSchedules:46])
			
		End if   // END 4D Professional Services : January 2019 
		
End case 

//*set up printer
util_PAGE_SETUP(->[Customers_ReleaseSchedules:46]; "ShipmentByBrand")
//*print the report
If ($fContinue)
	If (fSave)
		SEND PACKET:C103(vDoc; String:C10(dDate; 2)+Char:C90(9)+Char:C90(9)+t2+Char:C90(13))
		SEND PACKET:C103(vDoc; String:C10(tTime; 5)+Char:C90(9)+Char:C90(9)+t2b+Char:C90(13)+Char:C90(13))
	End if 
	SET WINDOW TITLE:C213("Shipments by Customer & Brand, "+String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" releases")
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12; >; [Customers_ReleaseSchedules:46]CustomerLine:28; >; [Customers_ReleaseSchedules:46]ProductCode:11; >; [Customers_ReleaseSchedules:46]Shipto:10; >)  //sort for break processing
	//*initialize vars on report  
	
	//ACCUMULATE(i)  `dummy to force break levels
	ACCUMULATE:C303([Customers_ReleaseSchedules:46]NumberOfCases:30; iShipTot; iTotShipQty; rb6; rb5; rb4; rb3; rb2; rb1; Li1; Li2; [Customers_ReleaseSchedules:46]Actual_Qty:8)
	BREAK LEVEL:C302(4)
	FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "ShipmentByBrand")
	PDF_setUp(<>pdfFileName)
	PRINT SELECTION:C60([Customers_ReleaseSchedules:46]; *)
End if 

If (fSave)
	If (Count parameters:C259=0)  //called from month end suite
		SEND PACKET:C103(vDoc; Char:C90(13)+Char:C90(13))  //•061495  MLB     
	Else 
		CLOSE DOCUMENT:C267(vDoc)
	End if 
	
End if 

FORM SET OUTPUT:C54([Customers_ReleaseSchedules:46]; "List")