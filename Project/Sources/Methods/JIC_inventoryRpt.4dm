//%attributes = {"publishedWeb":true}
//PM:  JIC_inventoryRpt  111299  mlb
//write a report to diskfile
//•121099  mlb  add columns for closedout at actual
// Modified by Mel Bohince on 2/28/07 at 16:31:44 : don't cost r&d and proofs
// Modified by: Mel Bohince (4/4/14) Retrofit server execution and pass back to client
// Modified by: Mel Bohince (12/2/15) undo the server execution
// Modified by: Mel Bohince (1/6/17) hang on to the lastest price to show unit price
// Modified by: MelvinBohince (4/4/22) change to CSV

C_TEXT:C284($1; $client_call_back; $docShortName; docName)
C_BOOLEAN:C305($isCosted)
C_LONGINT:C283($i; $j; $numOrdLines; $numJIC; $jobform)
C_TIME:C306($docRef)
C_TEXT:C284($t; $r)
$t:=","  // Modified by: MelvinBohince (4/4/22) change to CSV Char(Tab)
$r:=Char:C90(Carriage return:K15:38)
C_BLOB:C604($blob)
SET BLOB SIZE:C606($blob; 0)

Case of 
	: (Count parameters:C259=2)  //FiFo_Inventory_Report
		$client_call_back:=$1
		docName:=$2
	: (Count parameters:C259=1)
		$distributionList:=$1
		docName:="INVEN@FIFO_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"  // Modified by: MelvinBohince (4/4/22) change to CSV
	Else 
		$client_call_back:=""
		docName:="INVEN@FIFO_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"  // Modified by: MelvinBohince (4/4/22) change to CSV
End case 

$docShortName:=docName  //capture before path is prepended
$docRef:=util_putFileName(->docName)

MESSAGES OFF:C175

zwStatusMsg("FIFO INV RPT"; "Loading Bins")
<>FgBatchDat:=!00-00-00!
BatchFGinventor  //consolidate bins by cpn
SORT ARRAY:C229(<>aFGKey; <>aQty_CC; <>aQty_FG; <>aQty_EX; <>aQty_BH; <>aQty_OH; >)
$numOrdLines:=qryOpenOrdLines
CREATE SET:C116([Customers_Order_Lines:41]; "openOrders")

$text:="CUSTOMER"+$t+"CUSTOMER_LINE"+$t+"CPN"+$t+"BH"+$t+"FG"+$t+"CC"+$t+"EX"+$t+"ONHAND_QTY"+$t+"COSTED_QTY"+$t
$text:=$text+"INVESTMENT"+$t+"@COST$"+$t+"$MATL"+$t+"$LABOR"+$t+"$BURDEN"+$t+"$ACTMATL"+$t+"$ACTLABOR"+$t+"$ACTBURDEN"+$t+"DEMAND_QTY"+$t+"VALUED_QTY"+$t+"@SELLING$"+$t+"LastUnit$"+$r

uThermoInit(Size of array:C274(<>aFGKey); "Saving Inventory @ FIFO to disk")
For ($i; 1; Size of array:C274(<>aFGKey))
	If (Length:C16($text)>20000)
		SEND PACKET:C103($docRef; $text)
		$text:=""
	End if 
	
	$custName:=txt_quote(CUST_getName(Substring:C12(<>aFGKey{$i}; 1; 5)))  // Modified by: MelvinBohince (4/4/22) change to CSV
	$brand:=txt_quote(FG_getLine(Substring:C12(<>aFGKey{$i}; 7)))  // Modified by: MelvinBohince (4/4/22) change to CSV
	// Modified by: MelvinBohince (4/4/22) change to CSV
	$text:=$text+$custName+$t+$brand+$t+Substring:C12(<>aFGKey{$i}; 7)+$t+String:C10(<>aQty_BH{$i})+$t+String:C10(<>aQty_FG{$i})+$t+String:C10(<>aQty_CC{$i})+$t+String:C10(<>aQty_EX{$i})+$t+String:C10(<>aQty_OH{$i})+$t
	$numJIC:=qryJIC(""; <>aFGKey{$i})
	If ($numJIC>0)
		// Modified by Mel Bohince on 2/28/07 at 16:31:44 : don't cost r&d and proofs
		// Modified by Mel Bohince on 4/5/07 at 14:56:19 : revised so it doesn't make determination on oldest job
		SELECTION TO ARRAY:C260([Job_Forms_Items_Costs:92]Jobit:3; $aJITjobit)
		$isCosted:=False:C215
		For ($jobform; 1; Size of array:C274($aJITjobit))
			$isCosted:=JIC_isCosted($aJITjobit{$jobform})
			If ($isCosted)
				$jobform:=9999999  //bail if any production jobs
			End if 
		End for 
		
		If ($isCosted)
			$costQty:=Sum:C1([Job_Forms_Items_Costs:92]RemainingQuantity:15)
			$text:=$text+String:C10($costQty)+$t
			$excess:=<>aQty_OH{$i}-$costQty
			If ($excess<0)
				$excess:=0
			End if 
			$text:=$text+String:C10($excess)+$t+String:C10(Sum:C1([Job_Forms_Items_Costs:92]RemainingTotal:12))+$t+String:C10(Sum:C1([Job_Forms_Items_Costs:92]RemainingMaterial:9))+$t+String:C10(Sum:C1([Job_Forms_Items_Costs:92]RemainingLabor:10))+$t+String:C10(Sum:C1([Job_Forms_Items_Costs:92]RemainingBurden:11))+$t
			
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				FIRST RECORD:C50([Job_Forms_Items_Costs:92])  //•121099  mlb begin
				$matl:=0
				$labor:=0
				$burden:=0
				
				For ($j; 1; $numJIC)
					$numJMI:=qryJMI([Job_Forms_Items_Costs:92]Jobit:3)
					If ($numJMI>0)  //([JobMakesItem]FormClosed)
						//utl_Trace 
						$qty:=[Job_Forms_Items_Costs:92]RemainingQuantity:15/1000
						$matl:=$matl+($qty*[Job_Forms_Items:44]Cost_Mat:12)
						$labor:=$labor+($qty*[Job_Forms_Items:44]Cost_LAB:13)
						$burden:=$burden+($qty*[Job_Forms_Items:44]Cost_Burd:14)
						//Else 
						//$matl:=$matl+[JobItemCosts]RemainingMaterial
						//$labor:=$labor+[JobItemCosts]RemainingLabor
						//$burden:=$burden+[JobItemCosts]RemainingBurden
					End if 
					NEXT RECORD:C51([Job_Forms_Items_Costs:92])
				End for 
				
			Else 
				
				$matl:=0
				$labor:=0
				$burden:=0
				
				ARRAY TEXT:C222($_Jobit; 0)
				ARRAY LONGINT:C221($_RemainingQuantity; 0)
				
				SELECTION TO ARRAY:C260([Job_Forms_Items_Costs:92]Jobit:3; $_Jobit; [Job_Forms_Items_Costs:92]RemainingQuantity:15; $_RemainingQuantity)
				
				For ($j; 1; $numJIC)
					$numJMI:=qryJMI($_Jobit{$j})
					If ($numJMI>0)
						$qty:=$_RemainingQuantity{$j}/1000
						$matl:=$matl+($qty*[Job_Forms_Items:44]Cost_Mat:12)
						$labor:=$labor+($qty*[Job_Forms_Items:44]Cost_LAB:13)
						$burden:=$burden+($qty*[Job_Forms_Items:44]Cost_Burd:14)
					End if 
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			$text:=$text+String:C10($matl)+$t+String:C10($labor)+$t+String:C10($burden)+$t  //•121099  mlb  end
			
		Else 
			$text:=$text+$t+"0"+$t+"0"+$t+"R&D and Proofs are not costed"+$t+""+$t+""+$t+""+$t+""+$t+""+$t
		End if 
		
	Else 
		If (<>IgnorObsoleteAndOld)  // Modified by: Mel Bohince (3/21/14) 
			$excess:=<>aQty_OH{$i}
			$text:=$text+"0"+$t+String:C10($excess)+$t+((">9MTHS"+$t)*7)  //•121099  mlb
		Else 
			$text:=$text+(("ERROR"+$t)*9)
		End if 
	End if 
	
	$unitPrice:=0  // Modified by: Mel Bohince (1/6/17) hang on to the lastest price
	$unitPrice:=FG_getLastPrice(<>aFGKey{$i})
	USE SET:C118("openOrders")
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=(Substring:C12(<>aFGKey{$i}; 7)); *)
	QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=(Substring:C12(<>aFGKey{$i}; 1; 5)))
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOrdLine; [Customers_Order_Lines:41]Qty_Open:11; $aOpenOrd; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice)
		SORT ARRAY:C229($aOrdLine; $aOpenOrd; $aPrice; >)
		$openDemand:=0
		$valued:=0
		utl_Trace
		$qtyToConsume:=<>aQty_OH{$i}
		For ($j; 1; Size of array:C274($aOpenOrd))  //fifo the sales
			$unitPrice:=$aPrice{$j}  // Modified by: Mel Bohince (1/6/17) hang on to the lastest price
			$openDemand:=$openDemand+$aOpenOrd{$j}
			If ($aOpenOrd{$j}<=$qtyToConsume)
				$valued:=$valued+($aOpenOrd{$j}/1000*$aPrice{$j})
				$qtyToConsume:=$qtyToConsume-$aOpenOrd{$j}
			Else 
				$valued:=$valued+($qtyToConsume/1000*$aPrice{$j})
				$qtyToConsume:=0
			End if 
		End for 
		ARRAY LONGINT:C221($aOpenOrd; 0)
		ARRAY REAL:C219($aPrice; 0)
		
		$text:=$text+String:C10($openDemand)+$t
		If ($openDemand><>aQty_OH{$i})
			$openDemand:=<>aQty_OH{$i}  //valued qty up to amt onhand
		End if 
		$text:=$text+String:C10($openDemand)+$t+String:C10($valued)+$t+String:C10($unitPrice)+$r
		
	Else   //no orderlines
		$text:=$text+"0"+$t+"0"+$t+"0"+$t+String:C10($unitPrice)+$r
	End if 
	uThermoUpdate($i)
End for 

SEND PACKET:C103($docRef; $text)
uThermoClose
CLOSE DOCUMENT:C267($docRef)
CLEAR SET:C117("openOrders")

Case of 
	: (Count parameters:C259=2)
		DOCUMENT TO BLOB:C525(docName; $blob)
		DELETE DOCUMENT:C159(docName)  // no reason to leave it around
		EXECUTE ON CLIENT:C651($client_call_back; "FiFo_Inventory_Report"; $docShortName; $blob)
		SET BLOB SIZE:C606($blob; 0)  //clean up
		
	: (Count parameters:C259=1)
		EMAIL_Sender("Inventory at FiFo "+fYYMMDD(Current date:C33); ""; "Advance copy attached"; $distributionList; docName)
		//util_deleteDocument (docName)
		
	Else 
		$err:=util_Launch_External_App(docName)
		zwStatusMsg("FIFO INV RPT"; "Report saved in document: "+docName)
End case 



//◊FgBatchDat:=!00/00/00!
//BatchFGinventor (0)


BEEP:C151