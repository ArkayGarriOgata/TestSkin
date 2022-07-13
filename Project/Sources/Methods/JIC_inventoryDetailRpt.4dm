//%attributes = {"publishedWeb":true}
//PM:  JIC_inventoryDetailRpt  121499  mlb
//show the supporting detail to the JIC_inventoryRpt
//•2/28/00  mlb suppress lines with zero costed and onhand
// • mel (5/21/04, 11:25:10) add last selling price
// Modified by Mel Bohince on 2/28/07 at 16:31:44 : don't cost r&d and proofs
// Modified by: Mel Bohince (4/4/14) Retrofit server execution and pass back to client
// Modified by: Mel Bohince (12/2/15) undo the server execution

C_TEXT:C284($1; $client_call_back; $docShortName; docName; $distributionList)
C_LONGINT:C283($doneJobCursor)
Case of 
	: (Count parameters:C259=2)  //FiFo_Inventory_Report_Detail
		$client_call_back:=$1
		docName:=$2
		
	: (Count parameters:C259=1)
		$client_call_back:=""
		docName:="INVEN_DTL@FIFO_"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
		$distributionList:=$1
		
	Else 
		$client_call_back:=""
		docName:="INVEN_DTL@FIFO_"+fYYMMDD($today)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
End case 

$docShortName:=docName  //capture before path is prepended
C_TIME:C306($docRef)
$docRef:=util_putFileName(->docName)
C_BLOB:C604($blob)
SET BLOB SIZE:C606($blob; 0)

C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)

MESSAGES OFF:C175

ARRAY TEXT:C222($aDoneJobits; Records in table:C83([Job_Forms_Items_Costs:92]))


zwStatusMsg("FIFO INV DETAIL RPT"; "Loading Bins")
//◊FgBatchDat:=!00/00/00!
BatchFGinventor  //consolidate bins by cpn
SORT ARRAY:C229(<>aFGKey; <>aQty_CC; <>aQty_FG; <>aQty_EX; <>aQty_BH; <>aQty_OH; >)

$text:="CUSTOMER"+$t+"CUSTOMER_LINE"+$t+"CPN"+$t+"Jobit"+$t+"BH"+$t+"FG"+$t+"CC"+$t+"EX"+$t+"ONHAND_QTY"+$t+"COSTED_QTY"+$t
$text:=$text+"EXCESS_QTY"+$t+"@COST$"+$t+"$MATL"+$t+"$LABOR"+$t+"$BURDEN"+$t+"CLOSED"+$t+"$ACTMATL"+$t+"$ACTLABOR"+$t+"$ACTBURDEN"+$t
$text:=$text+"PlnMatl_M"+$t+"PlnLabor_M"+$t+"PlnBurden_M"+$t+"PlnTotal_M"+$t+"ActMatl_M"+$t+"ActLabor_M"+$t+"ActBurden_M"+$t+"ActTotal_M"+$t
$text:=$text+"LastPrice_M"+$t+"ExtendPrice"+$t
$text:=$text+$r
uThermoInit(Size of array:C274(<>aFGKey); "Saving Inventory @ FIFO to disk")
For ($i; 1; Size of array:C274(<>aFGKey))
	If (Length:C16($text)>20000)
		SEND PACKET:C103($docRef; $text)
		$text:=""
	End if 
	
	$numJIC:=qryJIC(""; <>aFGKey{$i})
	If ($numJIC>0)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; >)
			FIRST RECORD:C50([Job_Forms_Items_Costs:92])  //•121099  mlb begin
			
			
		Else 
			
			ORDER BY:C49([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]Jobit:3; >)
			
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		$matl:=0
		$labor:=0
		$burden:=0
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($jobit; 1; $numJIC)
				ARRAY TEXT:C222($aLocation; 0)
				ARRAY LONGINT:C221($aBinQty; 0)
				$hit:=Find in array:C230($aDoneJobits; [Job_Forms_Items_Costs:92]Jobit:3)
				If ($hit=-1)  //haven't done the inventory on this item--subform porblem
					$doneJobCursor:=$doneJobCursor+1
					$aDoneJobits{$doneJobCursor}:=[Job_Forms_Items_Costs:92]Jobit:3
					//*Get the inventory onhand for this jobit      
					$numBins:=qryFGbins(""; ""; 0; [Job_Forms_Items_Costs:92]Jobit:3)
					SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aLocation; [Finished_Goods_Locations:35]QtyOH:9; $aBinQty)
				Else 
					BEEP:C151
					TRACE:C157
				End if 
				$qty_OH:=0
				$qty_FG:=0
				$qty_CC:=0
				$qty_BH:=0
				$qty_EX:=0
				$matl:=0
				$labor:=0
				$burden:=0
				//*    tally the inventory by location
				For ($bin; 1; $numBins)
					$binType:=Substring:C12($aLocation{$bin}; 1; 2)
					Case of 
						: ($binType="FG")
							$qty_FG:=$qty_FG+$aBinQty{$bin}
							$qty_OH:=$qty_OH+$aBinQty{$bin}
						: ($binType="CC")
							$qty_CC:=$qty_CC+$aBinQty{$bin}
							$qty_OH:=$qty_OH+$aBinQty{$bin}
						: ($binType="XC")
							$qty_CC:=$qty_CC+$aBinQty{$bin}
							$qty_OH:=$qty_OH+$aBinQty{$bin}
						: ($binType="BH")
							$qty_BH:=$qty_BH+$aBinQty{$bin}
						Else   //treat as examining
							$qty_EX:=$qty_EX+$aBinQty{$bin}
							$qty_OH:=$qty_OH+$aBinQty{$bin}
					End case 
				End for 
				
				
				$costQty:=[Job_Forms_Items_Costs:92]RemainingQuantity:15
				
				
				If ($costQty#0) | ($qty_OH#0) | ($qty_BH#0)
					// Modified by Mel Bohince on 2/28/07 at 16:31:44 : don't cost r&d and proofs
					If (JIC_isCosted([Job_Forms_Items_Costs:92]Jobit:3))
						$excess:=$qty_OH-$costQty
						//If ($excess<0)`this is not valid assertion for an individual jobit!!!
						//$excess:=0
						//End if 
						$text:=$text+Substring:C12(<>aFGKey{$i}; 1; 5)+$t+FG_getLine(Substring:C12(<>aFGKey{$i}; 7))+$t+Substring:C12(<>aFGKey{$i}; 7)+$t+[Job_Forms_Items_Costs:92]Jobit:3+$t+String:C10($qty_BH)+$t+String:C10($qty_FG)+$t+String:C10($qty_CC)+$t+String:C10($qty_EX)+$t+String:C10($qty_OH)+$t+String:C10($costQty)+$t
						$text:=$text+String:C10($excess)+$t+String:C10([Job_Forms_Items_Costs:92]RemainingTotal:12)+$t+String:C10([Job_Forms_Items_Costs:92]RemainingMaterial:9)+$t+String:C10([Job_Forms_Items_Costs:92]RemainingLabor:10)+$t+String:C10([Job_Forms_Items_Costs:92]RemainingBurden:11)+$t
						
						$numJMI:=qryJMI([Job_Forms_Items_Costs:92]Jobit:3)
						If ($numJMI>0)
							$qty:=[Job_Forms_Items_Costs:92]RemainingQuantity:15/1000
							$matl:=$matl+($qty*[Job_Forms_Items:44]Cost_Mat:12)
							$labor:=$labor+($qty*[Job_Forms_Items:44]Cost_LAB:13)
							$burden:=$burden+($qty*[Job_Forms_Items:44]Cost_Burd:14)
							If ([Job_Forms_Items:44]FormClosed:5)
								$text:=$text+""+$t
							Else 
								$text:=$text+"NO"+$t
								//$matl:=$matl+[JobItemCosts]RemainingMaterial
								//$labor:=$labor+[JobItemCosts]RemainingLabor
								//$burden:=$burden+[JobItemCosts]RemainingBurden
							End if 
						Else 
							$text:=$text+">9MTHS"+$t
						End if 
						$text:=$text+String:C10($matl)+$t+String:C10($labor)+$t+String:C10($burden)+$t  //+$r  `•121099  mlb  end  
						
						$text:=$text+String:C10([Job_Forms_Items:44]PldCostMatl:17)+$t+String:C10([Job_Forms_Items:44]PldCostLab:18)+$t+String:C10([Job_Forms_Items:44]PldCostOvhd:19)+$t+String:C10([Job_Forms_Items:44]PldCostTotal:21)+$t
						$text:=$text+String:C10([Job_Forms_Items:44]Cost_Mat:12)+$t+String:C10([Job_Forms_Items:44]Cost_LAB:13)+$t+String:C10([Job_Forms_Items:44]Cost_Burd:14)+$t+String:C10([Job_Forms_Items:44]ActCost_M:27)+$t
						$lastPrice:=FG_getLastPrice(<>aFGKey{$i})  // • mel (5/21/04, 11:25:10)
						$text:=$text+String:C10($lastPrice)+$t+String:C10($lastPrice*$costQty/1000)+$t
						$text:=$text+$r
						
					Else 
						$text:=$text+Substring:C12(<>aFGKey{$i}; 1; 5)+$t+Substring:C12(<>aFGKey{$i}; 7)+$t+[Job_Forms_Items_Costs:92]Jobit:3+$t+"R&D and Proofs are not costed"+$r
					End if 
					
				End if   //zero onhand
				
				NEXT RECORD:C51([Job_Forms_Items_Costs:92])
			End for 
			
		Else 
			SELECTION TO ARRAY:C260([Job_Forms_Items_Costs:92]Jobit:3; $_Jobit; \
				[Job_Forms_Items_Costs:92]RemainingQuantity:15; $_RemainingQuantity; \
				[Job_Forms_Items_Costs:92]RemainingTotal:12; $_RemainingTotal; \
				[Job_Forms_Items_Costs:92]RemainingMaterial:9; $_RemainingMaterial; \
				[Job_Forms_Items_Costs:92]RemainingLabor:10; $_RemainingLabor; \
				[Job_Forms_Items_Costs:92]RemainingBurden:11; $_RemainingBurden)
			
			For ($jobit; 1; $numJIC)
				ARRAY TEXT:C222($aLocation; 0)
				ARRAY LONGINT:C221($aBinQty; 0)
				$hit:=Find in array:C230($aDoneJobits; $_Jobit{$jobit})
				If ($hit=-1)  //haven't done the inventory on this item--subform porblem
					$doneJobCursor:=$doneJobCursor+1
					$aDoneJobits{$doneJobCursor}:=$_Jobit{$jobit}
					//*Get the inventory onhand for this jobit      
					$numBins:=qryFGbins(""; ""; 0; $_Jobit{$jobit})
					SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $aLocation; [Finished_Goods_Locations:35]QtyOH:9; $aBinQty)
				Else 
					BEEP:C151
					TRACE:C157
				End if 
				$qty_OH:=0
				$qty_FG:=0
				$qty_CC:=0
				$qty_BH:=0
				$qty_EX:=0
				$matl:=0
				$labor:=0
				$burden:=0
				//*    tally the inventory by location
				For ($bin; 1; $numBins)
					$binType:=Substring:C12($aLocation{$bin}; 1; 2)
					Case of 
						: ($binType="FG")
							$qty_FG:=$qty_FG+$aBinQty{$bin}
							$qty_OH:=$qty_OH+$aBinQty{$bin}
						: ($binType="CC")
							$qty_CC:=$qty_CC+$aBinQty{$bin}
							$qty_OH:=$qty_OH+$aBinQty{$bin}
						: ($binType="XC")
							$qty_CC:=$qty_CC+$aBinQty{$bin}
							$qty_OH:=$qty_OH+$aBinQty{$bin}
						: ($binType="BH")
							$qty_BH:=$qty_BH+$aBinQty{$bin}
						Else   //treat as examining
							$qty_EX:=$qty_EX+$aBinQty{$bin}
							$qty_OH:=$qty_OH+$aBinQty{$bin}
					End case 
				End for 
				
				
				$costQty:=$_RemainingQuantity{$jobit}
				
				
				If ($costQty#0) | ($qty_OH#0) | ($qty_BH#0)
					// Modified by Mel Bohince on 2/28/07 at 16:31:44 : don't cost r&d and proofs
					If (JIC_isCosted($_Jobit{$jobit}))
						$excess:=$qty_OH-$costQty
						$text:=$text+Substring:C12(<>aFGKey{$i}; 1; 5)+$t+FG_getLine(Substring:C12(<>aFGKey{$i}; 7))+$t+Substring:C12(<>aFGKey{$i}; 7)+$t+$_Jobit{$jobit}+$t+String:C10($qty_BH)+$t+String:C10($qty_FG)+$t+String:C10($qty_CC)+$t+String:C10($qty_EX)+$t+String:C10($qty_OH)+$t+String:C10($costQty)+$t
						$text:=$text+String:C10($excess)+$t+String:C10($_RemainingTotal{$jobit})+$t+String:C10($_RemainingMaterial{$jobit})+$t+String:C10($_RemainingLabor{$jobit})+$t+String:C10($_RemainingBurden{$jobit})+$t
						
						$numJMI:=qryJMI($_Jobit{$jobit})
						If ($numJMI>0)
							$qty:=$_RemainingQuantity{$jobit}/1000
							$matl:=$matl+($qty*[Job_Forms_Items:44]Cost_Mat:12)
							$labor:=$labor+($qty*[Job_Forms_Items:44]Cost_LAB:13)
							$burden:=$burden+($qty*[Job_Forms_Items:44]Cost_Burd:14)
							If ([Job_Forms_Items:44]FormClosed:5)
								$text:=$text+""+$t
							Else 
								$text:=$text+"NO"+$t
								//$matl:=$matl+[JobItemCosts]RemainingMaterial
								//$labor:=$labor+[JobItemCosts]RemainingLabor
								//$burden:=$burden+[JobItemCosts]RemainingBurden
							End if 
						Else 
							$text:=$text+">9MTHS"+$t
						End if 
						$text:=$text+String:C10($matl)+$t+String:C10($labor)+$t+String:C10($burden)+$t  //+$r  `•121099  mlb  end  
						
						$text:=$text+String:C10([Job_Forms_Items:44]PldCostMatl:17)+$t+String:C10([Job_Forms_Items:44]PldCostLab:18)+$t+String:C10([Job_Forms_Items:44]PldCostOvhd:19)+$t+String:C10([Job_Forms_Items:44]PldCostTotal:21)+$t
						$text:=$text+String:C10([Job_Forms_Items:44]Cost_Mat:12)+$t+String:C10([Job_Forms_Items:44]Cost_LAB:13)+$t+String:C10([Job_Forms_Items:44]Cost_Burd:14)+$t+String:C10([Job_Forms_Items:44]ActCost_M:27)+$t
						$lastPrice:=FG_getLastPrice(<>aFGKey{$i})  // • mel (5/21/04, 11:25:10)
						$text:=$text+String:C10($lastPrice)+$t+String:C10($lastPrice*$costQty/1000)+$t
						$text:=$text+$r
						
					Else 
						$text:=$text+Substring:C12(<>aFGKey{$i}; 1; 5)+$t+Substring:C12(<>aFGKey{$i}; 7)+$t+$_Jobit{$jobit}+$t+"R&D and Proofs are not costed"+$r
					End if 
					
				End if   //zero onhand
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 
		
	Else 
		BEEP:C151
		$text:=$text+Substring:C12(<>aFGKey{$i}; 1; 5)+$t+Substring:C12(<>aFGKey{$i}; 7)+$t+"NO JIC COST RECORD, CHECK GLUE DATE"+$t+String:C10(<>aQty_BH{$i})+$t+String:C10(<>aQty_FG{$i})+$t+String:C10(<>aQty_CC{$i})+$t+String:C10(<>aQty_EX{$i})+$t+String:C10(<>aQty_OH{$i})+$t+"ERROR"+$t
		$text:=$text+">9MTHS"+$t+">9MTHS"+$t+">9MTHS"+$t+">9MTHS"+$t+">9MTHS"+$r
	End if 
	
	uThermoUpdate($i)
End for 

SEND PACKET:C103($docRef; $text)
uThermoClose
CLOSE DOCUMENT:C267($docRef)
CLEAR SET:C117("openOrders")

//◊FgBatchDat:=!00/00/00!
//BatchFGinventor (0)


Case of 
	: (Count parameters:C259=2)  //$client_requesting:=clientRegistered_as
		DOCUMENT TO BLOB:C525(docName; $blob)
		DELETE DOCUMENT:C159(docName)  // no reason to leave it around
		EXECUTE ON CLIENT:C651($client_call_back; "FiFo_Inventory_Report_Detail"; $docShortName; $blob)
		SET BLOB SIZE:C606($blob; 0)  //clean up
		
	: (Count parameters:C259=1)
		EMAIL_Sender("FIFO Detail Monthly "+fYYMMDD(Current date:C33); ""; "Advance copy attached"; $distributionList; docName)
		
	Else 
		$err:=util_Launch_External_App(docName)
		zwStatusMsg("FIFO INV DETL RPT"; "Report saved in document: "+docName)
End case 


BEEP:C151