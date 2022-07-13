//%attributes = {"publishedWeb":true}
//PM:  JIC_IncrementalRegen  071902  mlb
//find fg items which had inventory balance activity
//and regenerate them
//mlb 072403 pickup any items recently closed 
// Modified by Mel Bohince on 12/12/06 at 15:46:00 : iBeginAt not used cause xfernum nolonger serial

C_TEXT:C284($1)
C_LONGINT:C283($numFG; $item; $cursor; $trans; iBeginAt)
C_DATE:C307(dDateBegin)

$err:=Batch_RunDate("Get"; "JIC_Increment"; ->dDateBegin; ->iBeginAt)
If (dDateBegin=!00-00-00!)  //first time code
	dDateBegin:=!2000-07-20!
	iBeginAt:=478619  //this is a tranaction number at the bdgining of july
	$err:=Batch_RunDate("Set"; "JIC_Increment"; ->dDateBegin; ->iBeginAt)
End if 

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5#"@.sb"; *)  //dont want special billings
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2#"MOVE"; *)  //don't want move transactions
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]JobForm:5#"Price@"; *)  //don't want price changes
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin)  //not the day before
//QUERY([Finished_Goods_Transactions]; & ;[Finished_Goods_Transactions]XactionNum>iBeginAt)

$numFG:=Records in selection:C76([Finished_Goods_Transactions:33])
ARRAY TEXT:C222($aFGKey; $numFG)
$cursor:=0

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($trans; 1; $numFG)
		$fg:=[Finished_Goods_Transactions:33]CustID:12+":"+[Finished_Goods_Transactions:33]ProductCode:1
		$hit:=Find in array:C230($aFGKey; $fg)
		If ($hit=-1)
			$cursor:=$cursor+1
			$aFGKey{$cursor}:=$fg
		End if 
		NEXT RECORD:C51([Finished_Goods_Transactions:33])
	End for 
	
Else 
	
	ARRAY TEXT:C222($_CustID; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]CustID:12; $_CustID; [Finished_Goods_Transactions:33]ProductCode:1; $_ProductCode)
	
	For ($trans; 1; Size of array:C274($_CustID); 1)
		$fg:=$_CustID{$trans}+":"+$_ProductCode{$trans}
		$hit:=Find in array:C230($aFGKey; $fg)
		If ($hit=-1)
			$cursor:=$cursor+1
			$aFGKey{$cursor}:=$fg
		End if 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 query selection

dDateBegin:=Current date:C33-3
$err:=Batch_RunDate("Set"; "JIC_Increment"; ->dDateBegin; ->iBeginAt)

//pickup any items recently closed mlb 072403
CREATE EMPTY SET:C140([Job_Forms_Items:44]; "closedJMIs")
$foundSet:=util_SetSaver("restore"; Table:C252(->[Job_Forms_Items:44]); "closedJMIs"; 0)
While ($foundSet=1)
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			FIRST RECORD:C50([Job_Forms_Items:44])
			While (Not:C34(End selection:C36([Job_Forms_Items:44])))
				$fg:=[Job_Forms_Items:44]CustId:15+":"+[Job_Forms_Items:44]ProductCode:3
				$hit:=Find in array:C230($aFGKey; $fg)
				If ($hit=-1)
					$cursor:=$cursor+1
					If ($cursor>Size of array:C274($aFGKey))  //grow the array
						ARRAY TEXT:C222($aFGKey; (Size of array:C274($aFGKey)+10))
					End if 
					$aFGKey{$cursor}:=$fg
				End if 
				NEXT RECORD:C51([Job_Forms_Items:44])
			End while 
			
		Else 
			
			ARRAY TEXT:C222($_CustId; 0)
			ARRAY TEXT:C222($_ProductCode; 0)
			
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]CustId:15; $_CustId; [Job_Forms_Items:44]ProductCode:3; $_ProductCode)
			
			For ($Iter; 1; Size of array:C274($_ProductCode); 1)
				$fg:=$_CustId{$Iter}+":"+$_ProductCode{$Iter}
				$hit:=Find in array:C230($aFGKey; $fg)
				If ($hit=-1)
					$cursor:=$cursor+1
					If ($cursor>Size of array:C274($aFGKey))  //grow the array
						ARRAY TEXT:C222($aFGKey; (Size of array:C274($aFGKey)+10))
					End if 
					$aFGKey{$cursor}:=$fg
				End if 
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End if 
	
	$foundSet:=util_SetSaver("restore"; Table:C252(->[Job_Forms_Items:44]); "closedJMIs"; 0)
End while 
CLEAR SET:C117("closedJMIs")

ARRAY TEXT:C222($aFGKey; $cursor)

$numFG:=$cursor
xText:=String:C10($numFG)+" F/G items to regenerate FIFO costs"+<>CR

NewWindow(170; 50; 0; 1)
GOTO XY:C161(1; 1)
MESSAGE:C88("FIFO Regeneration")
For ($item; 1; $numFG)
	$doingFG:=Change string:C234((" "*30); $aFGKey{$item}; 3)
	GOTO XY:C161(3; 2)
	MESSAGE:C88(String:C10($item; "^^^,^^^")+" of "+String:C10($numFG)+$doingFG)
	xText:=xText+$aFGKey{$item}+<>CR
	JIC_Regenerate($aFGKey{$item})
End for 
CLOSE WINDOW:C154
FLUSH CACHE:C297
xTitle:="FIFO Incremental Change"
xText:=""
xTitle:=""