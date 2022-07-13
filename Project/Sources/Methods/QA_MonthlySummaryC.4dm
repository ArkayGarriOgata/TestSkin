//%attributes = {"publishedWeb":true}
//PM: QA_MonthlySummaryC() -> 
//@author mlb - 9/28/01  13:20
//get a range of fg transactions

zwStatusMsg("QA SUM"; "Monthly Summary C")

C_DATE:C307($1; $2; dDateEnd; dDateBegin)
C_LONGINT:C283($i; $numFGX; $j)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:="Month Quality Summary C"
xText:=""

MESSAGES OFF:C175
//*Find the transactions to report
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)

If (Count parameters:C259>=2)
	dDateBegin:=$1
	dDateEnd:=$2
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
		If (Count parameters:C259=3)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$3)
		End if 
		
		
	Else 
		
		
		If (Count parameters:C259=3)
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$3; *)
		End if 
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
		
	End if   // END 4D Professional Services : January 2019 query selection
	OK:=1
	$numFGX:=Records in selection:C76([Finished_Goods_Transactions:33])
Else 
	$numFGX:=qryByDateRange(->[Finished_Goods_Transactions:33]XactionDate:3; "Date Range of FG Transactions")
	If ($numFGX>-1)
		OK:=1
	Else 
		OK:=0
	End if 
End if   //params

If (OK=1)
	If ($numFGX>0)
		xTitle:="QA by Customer for "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+$cr
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Ship")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Adjust")
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Return")
			CREATE SET:C116([Finished_Goods_Transactions:33]; "periodFGX")
			
		Else 
			
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Ship"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Adjust"; *)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2#"Return")
			CREATE SET:C116([Finished_Goods_Transactions:33]; "periodFGX")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		docName:="QA_by_cust"+fYYMMDD(dDateEnd)
		$docRef:=util_putFileName(->docName)
		
		SEND PACKET:C103($docRef; xTitle+$cr+$cr)
		xText:=xText+"Custid"+$t+"Customer"+$t+"To FG"+$t+"To EX"+$t+"% Examined"+$t+"To Scrap"+$t+"% Scrapped"+$cr
		
		ARRAY TEXT:C222($aCustid; 0)
		DISTINCT VALUES:C339([Finished_Goods_Transactions:33]CustID:12; $aCustid)
		$numCust:=Size of array:C274($aCustid)
		//ARRAY TEXT($aCustName;$numCust)
		uThermoInit($numCust; "QA by cust, Tallying Customers")
		$qtyEXt:=0
		$qtyFGt:=0
		$qtySCt:=0
		$qtyTt:=0
		For ($i; 1; $numCust)
			uThermoUpdate($i)
			QUERY:C277([Customers:16]; [Customers:16]ID:1=$aCustid{$i})
			$qtyEX:=0
			$qtyFG:=0
			$qtySC:=0
			$qtyT:=0
			If (Length:C16(xText)>28000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
				
				USE SET:C118("periodFGX")
				$from:="CC:@"
				$to:="FG:@"
				
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
				//QUERY SELECTION([FG_Transactions]; | ;[FG_Transactions]viaLocation="XC:@";*)
				QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to; *)
				QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=$aCustid{$i})
				
				
				
				$qtyFG:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
				
				USE SET:C118("periodFGX")
				$from:="@"
				$to:="EX:@"
				
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
				QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to; *)
				QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=$aCustid{$i})
				
				
				$qtyEX:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
				
				USE SET:C118("periodFGX")
				$from:="@"
				$to:="SC:@"
				
				QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
				QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to; *)
				QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=$aCustid{$i})
				
				
				
				$qtySC:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
				
			Else 
				
				USE SET:C118("periodFGX")
				ARRAY TEXT:C222($_from; 3)
				ARRAY TEXT:C222($_to; 3)
				ARRAY TEXT:C222($_viaLocation; 0)
				ARRAY TEXT:C222($_Location; 0)
				ARRAY LONGINT:C221($_Qty; 0)
				
				$_from{1}:="CC:@"
				$_to{1}:="FG:@"
				$_from{2}:="@"
				$_to{2}:="EX:@"
				$_from{3}:="@"
				$_to{3}:="SC:@"
				
				QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=$aCustid{$i})
				QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Transactions:33]viaLocation:11; $_from)
				QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Transactions:33]Location:9; $_to)
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]viaLocation:11; $_viaLocation; \
					[Finished_Goods_Transactions:33]Location:9; $_Location; \
					[Finished_Goods_Transactions:33]Qty:6; $_Qty)
				
				For ($Iter; 1; Size of array:C274($_Location); 1)
					
					Case of 
						: (($_viaLocation{$Iter}="CC:@") & ($_Location{$Iter}="FG:@"))
							
							$qtyFG:=$qtyFG+$_Qty{$Iter}
							
						: (($_viaLocation{$Iter}="@") & ($_Location{$Iter}="EX:@"))
							
							$qtyEX:=$qtyEX+$_Qty{$Iter}
							
						: (($_viaLocation{$Iter}="@") & ($_Location{$Iter}="SC:@"))
							$qtySC:=$qtySC+$_Qty{$Iter}
							
					End case 
					
				End for 
				
				
				
			End if   // END 4D Professional Services : January 2019
			
			
			$qtyT:=$qtyEX+$qtyFG
			If (($qtyT+$qtySC)>0)
				If ($qtyT#0)
					xText:=xText+$aCustid{$i}+$t+[Customers:16]Name:2+$t+String:C10($qtyFG)+$t+String:C10($qtyEX)+$t+String:C10($qtyEX/$qtyT*100)+$t+String:C10($qtySC)+$t+String:C10($qtySC/$qtyT*100)+$cr
				Else 
					xText:=xText+$aCustid{$i}+$t+[Customers:16]Name:2+$t+String:C10($qtyFG)+$t+String:C10($qtyEX)+$t+"0"+$t+String:C10($qtySC)+$t+"0"+$cr
				End if 
				$qtyEXt:=$qtyEXt+$qtyEX
				$qtyFGt:=$qtyFGt+$qtyFG
				$qtySCt:=$qtySCt+$qtySC
				$qtyTt:=$qtyTt+$qtyT
			End if 
		End for 
		xText:=xText+$t+"Total"+$t+String:C10($qtyFGt)+$t+String:C10($qtyEXt)+$t+String:C10($qtyEXt/$qtyTt*100)+$t+String:C10($qtySCt)+$t+String:C10($qtySCt/$qtyTt*100)+$cr
		
		uThermoClose
		CLEAR SET:C117("periodFGX")
		SEND PACKET:C103($docRef; xText)
		CLOSE DOCUMENT:C267($docRef)
		BEEP:C151
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		$err:=util_Launch_External_App(docName)
		
		xText:=""
	End if   //$numJF>0    
End if   //ok
zwStatusMsg("QA RPT"; "QA by Customer finished")