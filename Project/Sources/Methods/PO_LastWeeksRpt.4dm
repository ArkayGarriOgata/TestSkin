//%attributes = {}
// Method: PO_LastWeeksRpt () -> 
// ----------------------------------------------------
// by: mel: 02/24/05, 13:08:02
// ----------------------------------------------------
// Description:
// export poitems based on date  range
// Updates:
// • mel (3/8/05, 09:14:17)  offer to exclude inx and lasercam
// • mel (3/17/05, 10:41:31) exclude non-approved po's
// • mel (6/29/05, 17:13:50) add Buyer for MSK's review
//mlb 021606 change from [PO_Items]PoItemDate to [PURCHASE_ORDER]DateApproved
// ----------------------------------------------------

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
C_TEXT:C284($t; $cr)
C_DATE:C307($End; $Begin; $1; $2)
C_TEXT:C284($blackList)  // • mel (3/8/05, 09:14:17)  offer to exclude inx and lasercam
ARRAY TEXT:C222($aLocation; 5)

$break:=False:C215
$t:=Char:C90(9)
$cr:=Char:C90(13)
$blackList:="04145 04526"  // INX and LaserCam
$aLocation{1}:="Hauppauge"
$aLocation{2}:="Roanoke"
$aLocation{3}:="Administrative"
$aLocation{4}:="Vista"
$aLocation{5}:="Other"

READ ONLY:C145([Purchase_Orders:11])
READ ONLY:C145([Purchase_Orders_Items:12])

If (Count parameters:C259=0)
	$numRecs:=qryByDateRange(->[Purchase_Orders:11]DateApproved:56; "Enter a date range"; 4D_Current_date-8; 4D_Current_date-1)
Else 
	$Begin:=$1
	$End:=$2
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]DateApproved:56>=$Begin; *)
	QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]DateApproved:56<=$End)
End if 

RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]PONo:2)
$numRecs:=Records in selection:C76([Purchase_Orders_Items:12])
//QUERY SELECTION([PO_Items])
//$numRecs:=Records in selection([PO_Items])

If ($numRecs>0)
	If (Count parameters:C259=0)
		$blackList:=Request:C163("Exclude vender id(s):"; $blackList; "Exclude"; "Show All")
		If (ok=0)
			$blackList:=""
		End if 
	End if 
	
	ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
	C_TIME:C306($docRef)
	docName:="POsLastWeek"+fYYMMDD(4D_Current_date)+".xls"
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		C_TEXT:C284(xTitle; xText)
		xTitle:="Purchases from "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)
		xText:="POItem"+$t+"Location"+$t+"Vendor"+$t+"Commodity"+$t+"CommodityKey"+$t+"RawMatlCode"+$t+"Qty"+$t+"UnitPrice"+$t+"ExtendedPrice"+$t+"PO_Approved"+$t+"Buyer"+$t+"Description"+$cr
		SEND PACKET:C103($docRef; xTitle+$cr+$cr)
		
		uThermoInit($numRecs; "Updating Records")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; $numRecs)
				If ($break)
					$i:=$i+$numRecs
				End if 
				
				If (Length:C16(xText)>28000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
				RELATE ONE:C42([Purchase_Orders_Items:12]PONo:2)
				Case of   // • mel (3/8/05, 09:14:17)  offer to exclude inx and lasercam
					: ([Purchase_Orders:11]INX_autoPO:48)
						//skip
					: (Position:C15([Purchase_Orders_Items:12]VendorID:39; $blackList)>0)
						//skip
					: (Not:C34([Purchase_Orders:11]PurchaseApprv:44))  // • mel (3/17/05, 10:41:31)
						//skip
					Else 
						xText:=xText+[Purchase_Orders_Items:12]POItemKey:1+$t+$aLocation{Num:C11([Purchase_Orders:11]CompanyID:43)}+$t+[Purchase_Orders:11]VendorName:42+$t+String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00")+$t+[Purchase_Orders_Items:12]Commodity_Key:26+$t+[Purchase_Orders_Items:12]Raw_Matl_Code:15+$t+String:C10([Purchase_Orders_Items:12]Qty_Ordered:30)+$t+String:C10([Purchase_Orders_Items:12]UnitPrice:10)+$t+String:C10([Purchase_Orders_Items:12]ExtPrice:11)+$t+String:C10([Purchase_Orders:11]DateApproved:56; System date short:K1:1)+$t+User_ResolveInitials([Purchase_Orders_Items:12]ReqnBy:18)+$t+Replace string:C233([Purchase_Orders_Items:12]RM_Description:7; $cr; "•")+$cr
				End case 
				
				NEXT RECORD:C51([Purchase_Orders_Items:12])
				uThermoUpdate($i)
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_PONo; 0)
			ARRAY TEXT:C222($_VendorID; 0)
			ARRAY TEXT:C222($_POItemKey; 0)
			ARRAY INTEGER:C220($_CommodityCode; 0)
			ARRAY TEXT:C222($_Commodity_Key; 0)
			ARRAY TEXT:C222($_Raw_Matl_Code; 0)
			ARRAY REAL:C219($_Qty_Ordered; 0)
			ARRAY REAL:C219($_UnitPrice; 0)
			ARRAY REAL:C219($_ExtPrice; 0)
			ARRAY TEXT:C222($_ReqnBy; 0)
			ARRAY TEXT:C222($_RM_Description; 0)
			ARRAY TEXT:C222($_PONo; 0)
			ARRAY BOOLEAN:C223($_INX_autoPO; 0)
			ARRAY BOOLEAN:C223($_PurchaseApprv; 0)
			ARRAY TEXT:C222($_CompanyID; 0)
			ARRAY TEXT:C222($_VendorName; 0)
			ARRAY DATE:C224($_DateApproved; 0)
			
			GET FIELD RELATION:C920([Purchase_Orders_Items:12]PONo:2; $lienAller; $lienRetour)
			SET FIELD RELATION:C919([Purchase_Orders_Items:12]PONo:2; Automatic:K51:4; Do not modify:K51:1)
			
			SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]PONo:2; $_PONo; [Purchase_Orders_Items:12]VendorID:39; $_VendorID; [Purchase_Orders_Items:12]POItemKey:1; $_POItemKey; [Purchase_Orders_Items:12]CommodityCode:16; $_CommodityCode; [Purchase_Orders_Items:12]Commodity_Key:26; $_Commodity_Key; [Purchase_Orders_Items:12]Raw_Matl_Code:15; $_Raw_Matl_Code; [Purchase_Orders_Items:12]Qty_Ordered:30; $_Qty_Ordered; [Purchase_Orders_Items:12]UnitPrice:10; $_UnitPrice; [Purchase_Orders_Items:12]ExtPrice:11; $_ExtPrice; [Purchase_Orders_Items:12]ReqnBy:18; $_ReqnBy; [Purchase_Orders_Items:12]RM_Description:7; $_RM_Description; [Purchase_Orders:11]PONo:1; $_PONo; [Purchase_Orders:11]INX_autoPO:48; $_INX_autoPO; [Purchase_Orders:11]PurchaseApprv:44; $_PurchaseApprv; [Purchase_Orders:11]CompanyID:43; $_CompanyID; [Purchase_Orders:11]VendorName:42; $_VendorName; [Purchase_Orders:11]DateApproved:56; $_DateApproved)
			
			
			SET FIELD RELATION:C919([Purchase_Orders_Items:12]PONo:2; $lienAller; $lienRetour)
			
			
			For ($i; 1; $numRecs; 1)
				
				If (Length:C16(xText)>28000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
				Case of   // • mel (3/8/05, 09:14:17)  offer to exclude inx and lasercam
					: ($_INX_autoPO{$i})
						//skip
					: (Position:C15($_VendorID{$i}; $blackList)>0)
						//skip
					: (Not:C34($_PurchaseApprv{$i}))  // • mel (3/17/05, 10:41:31)
						//skip
					Else 
						xText:=xText+$_POItemKey{$i}+$t+$aLocation{Num:C11($_CompanyID{$i})}+$t+$_VendorName{$i}+$t+String:C10($_CommodityCode{$i}; "00")+$t+$_Commodity_Key{$i}+$t+$_Raw_Matl_Code{$i}+$t+String:C10($_Qty_Ordered{$i})+$t+String:C10($_UnitPrice{$i})+$t+String:C10($_ExtPrice{$i})+$t+String:C10($_DateApproved{$i}; System date short:K1:1)+$t+User_ResolveInitials($_ReqnBy{$i})+$t+Replace string:C233($_RM_Description{$i}; $cr; "•")+$cr
				End case 
				
				uThermoUpdate($i)
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		SEND PACKET:C103($docRef; xText)
		uThermoClose
		// 
		CLOSE DOCUMENT:C267($docRef)
		BEEP:C151
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		If (Count parameters:C259=0)
			$err:=util_Launch_External_App(docName)
		End if 
		//
		
	Else 
		If (Count parameters:C259=0)
			BEEP:C151
			ALERT:C41("Couldn't create a document.")
		End if 
	End if 
	
Else 
	If (Count parameters:C259=0)
		BEEP:C151
		ALERT:C41("No POItems in that date range.")
	End if 
End if 