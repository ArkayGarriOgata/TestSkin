//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 09/18/13, 15:24:46
// ----------------------------------------------------
// Method: PSG_Transaction
// ----------------------------------------------------
// Modified by: Mel Bohince (2/28/14) fix the abserd, re-rite


C_LONGINT:C283($i; $xlSize; $xlPosition; xlTotal)
C_DATE:C307($dYesterday)
ARRAY TEXT:C222(atProdCode; 0)
ARRAY LONGINT:C221(axlQty; 0)

$dYesterday:=Add to date:C393(Current date:C33; 0; 0; -1)
//$dYesterday:=!02/21/2014!
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	zwStatusMsg("Pls wait"; "Looking for FG Receipts from yesterday...")
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=$dYesterday; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Jobit:31; $aFGT_jobits)
	zwStatusMsg("Pls wait"; "Looking for Jobits for those transactions that were completed...")
	QUERY WITH ARRAY:C644([Job_Forms_Items:44]Jobit:4; $aFGT_jobits)
	QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=$dYesterday)
	
Else 
	
	zwStatusMsg("Pls wait"; "Looking for FG Receipts from yesterday...")
	
	QUERY BY FORMULA:C48([Job_Forms_Items:44]; \
		([Job_Forms_Items:44]Completed:39=$dYesterday)\
		 & ([Job_Forms_Items:44]Jobit:4=[Finished_Goods_Transactions:33]Jobit:31)\
		 & ([Finished_Goods_Transactions:33]XactionType:2="Receipt")\
		 & ([Finished_Goods_Transactions:33]XactionDate:3>=$dYesterday)\
		)
	
	zwStatusMsg("Pls wait"; "Looking for Jobits for those transactions that were completed...")
	
End if   // END 4D Professional Services : January 2019 query selection

zwStatusMsg("Done"; "Found "+String:C10(Records in selection:C76([Job_Forms_Items:44])))

pattern_PassThru(->[Job_Forms_Items:44])
ViewSetter(3; ->[Job_Forms_Items:44])

// MARK'S CODE:
//
//$xlSize:=Records in selection([Finished_Goods_Transactions])
//xlTotal:=0
//
//If ($xlSize>0)
//ORDER BY([Finished_Goods_Transactions];[Finished_Goods_Transactions]ProductCode;>)
//uThermoInit ($xlSize;"Processing Array")
//For ($i;1;$xlSize)
//GOTO RECORD([Finished_Goods_Transactions];$i)
//$xlPosition:=Find in array(atProdCode;[Finished_Goods_Transactions]ProductCode)
//If ($xlPosition=-1)
//APPEND TO ARRAY(atProdCode;[Finished_Goods_Transactions]ProductCode)
//APPEND TO ARRAY(axlQty;[Finished_Goods_Transactions]Qty)
//xlTotal:=xlTotal+[Finished_Goods_Transactions]Qty
//Else 
//axlQty{$xlPosition}:=axlQty{$xlPosition}+[Finished_Goods_Transactions]Qty
//xlTotal:=xlTotal+axlQty{$xlPosition}
//End if 
//uThermoUpdate ($i)
//End for 
//uThermoClose 
//
//SORT ARRAY(atProdCode;axlQty;>)
//
//t1:="Transaction Report for "+String($dYesterday)+<>CR+<>CR+<>CR  // Modified by: Mel Bohince (2/28/14) use the rite date
//t1:=t1+"Product Code"+<>TB+"Quantity"+<>CR
//For ($i;1;Size of array(atProdCode))
//t1:=t1+atProdCode{$i}+<>TB+String(axlQty{$i};"###,###,###")+<>CR
//End for 
//t1:=t1+<>CR+"Total:"+<>TB+<>TB+String(xlTotal;"###,###,###,###")+<>CR+<>CR
//t1:=t1+"Transactions in Report: "+String($xlSize;"###,###,###")
//
//CenterWindow (725;480;0;"Roanoke WIP Report "+String($dYesterday))// Modified by: Mel Bohince (2/28/14) use the rite date
//DIALOG([zz_control];"text2_dio")
//CLOSE WINDOW
//
//Else 
//ALERT("No transactions to report.")
//End if 