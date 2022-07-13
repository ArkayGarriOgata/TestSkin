//%attributes = {"publishedWeb":true}
//Procedure: BatchRMwarning()  100898  mlb UPR 1989 over issue warning
//notify interested parties when the budget has be exceed or shorted
//by doing a quick check of jobs which had activity
//•022299  MLB chg array sizeing parameter

C_REAL:C285($tolerance)
C_LONGINT:C283($i; $j; $cursor; $hit; $numBudget; $numIssues)
C_TEXT:C284(xTitle; xText)
C_DATE:C307(dDate)

$tolerance:=0.1  // start with 5%

xText:=""
//*Get todays issues into an array
If (Count parameters:C259>0)
	dDate:=$1
Else 
	dDate:=4D_Current_date-1
End if 

READ ONLY:C145([Raw_Materials_Transactions:23])
If (Day number:C114(dDate)=1)  //monday, do friday and weekend
	dDate:=dDate-2
	xTitle:="R/M "+Substring:C12(String:C10(dDate; <>MIDDATE); 1; 5)+"+"+String:C10($tolerance*100)+"%Over (& >$100)"
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=dDate; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=(dDate+2); *)
Else 
	xTitle:="R/M "+Substring:C12(String:C10(dDate; <>MIDDATE); 1; 5)+" "+String:C10($tolerance*100)+"%Over (& >$100)"
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3=dDate; *)
End if 

QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="ISSUE")

ARRAY TEXT:C222($aissJobForm; 0)
SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]JobForm:12; $aissJobForm)
$numIssues:=Size of array:C274($aissJobForm)
SORT ARRAY:C229($aissJobForm; >)

$lastJob:=""
zCursorMgr("beachBallOff")
zCursorMgr("watch")
For ($i; 1; $numIssues)  //*For each issue
	If ($lastJob#$aissJobForm{$i})  //*   analyze each job once        
		//*      Get the budget
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=$aissJobForm{$i})
		//*         consolidate to Commodity
		ARRAY TEXT:C222($aJobComKey; 0)
		ARRAY REAL:C219($aJobBudQty; 0)
		SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Commodity_Key:12; $aJobComKey; [Job_Forms_Materials:55]Planned_Cost:8; $aJobBudQty)
		$numBudget:=Size of array:C274($aJobComKey)
		
		ARRAY INTEGER:C220($aJobCommNum; 0)
		ARRAY INTEGER:C220($aJobCommNum; $numBudget)
		ARRAY REAL:C219($aConsolQty; 0)
		ARRAY REAL:C219($aConsolQty; $numBudget)
		$cursor:=0
		$j:=1
		While ($j<=$numBudget)
			$iCommID:=Num:C11(Substring:C12($aJobComKey{$j}; 1; 2))  //get the commodity number frome the key
			$hit:=Find in array:C230($aJobCommNum; $iCommID)
			If ($hit<0)  //make it
				$cursor:=$cursor+1
				$aJobCommNum{$cursor}:=$iCommID
				$hit:=$cursor
			End if 
			$aConsolQty{$hit}:=$aConsolQty{$hit}+$aJobBudQty{$j}  //consolidate the qty
			$j:=$j+1
		End while 
		ARRAY INTEGER:C220($aJobCommNum; $cursor)  //shink to fit
		ARRAY REAL:C219($aConsolQty; $cursor)  //shink to fit
		ARRAY REAL:C219($aJobActQty; 0)  //container for the actuals
		ARRAY REAL:C219($aJobActQty; $cursor)
		
		//*      Get the Issues
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]JobForm:12=$aissJobForm{$i})
		ARRAY INTEGER:C220($aRXcomCode; 0)
		ARRAY REAL:C219($aRXqty; 0)
		SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]CommodityCode:24; $aRXcomCode; [Raw_Materials_Transactions:23]ActExtCost:10; $aRXqty)
		For ($j; 1; Size of array:C274($aRXcomCode))
			$hit:=Find in array:C230($aJobCommNum; $aRXcomCode{$j})
			If ($hit<0)  //make an unbudgeted item
				$cursor:=$cursor+1
				$hit:=$cursor
				ARRAY INTEGER:C220($aJobCommNum; $hit)
				ARRAY REAL:C219($aConsolQty; $cursor)  //•022299  MLB  
				ARRAY REAL:C219($aJobActQty; $cursor)
				$aJobCommNum{$hit}:=$aRXcomCode{$j}
				$aConsolQty{$hit}:=0
			End if 
			$aJobActQty{$hit}:=$aJobActQty{$hit}+(-1*$aRXqty{$j})
		End for 
		
		//*      Compare
		SORT ARRAY:C229($aJobCommNum; $aJobActQty; $aConsolQty; >)
		$exceptions:=""
		For ($j; 1; $cursor)
			$difference:=Round:C94(($aJobActQty{$j}-$aConsolQty{$j}); 2)
			$allowed:=Round:C94(($tolerance*$aConsolQty{$j}); 2)
			Case of 
				: ($difference>0)
					If ($difference>$allowed)
						If ($difference>100)
							$exceptions:=$exceptions+Char:C90(13)+"Commodity "+String:C10($aJobCommNum{$j}; "^^")+" was over issued by $"+String:C10($difference; "^,^^^,^^0.00")
						End if 
					End if 
				: ($difference<0)
					If (Abs:C99($difference)>$allowed)
						//$exceptions:=$exceptions+Char(13)+"Commodity "+String
						//«($aJobCommNum{$j})+" was under issued by "+String(Abs($difference))
					End if 
			End case 
		End for 
		If (Length:C16($exceptions)>0)
			xText:=xText+Char:C90(13)+$aissJobForm{$i}+$exceptions+Char:C90(13)
		End if 
		
		$lastJob:=$aissJobForm{$i}
	End if 
End for 

//*Email if problems
If (Length:C16(xText)>0)
	//QM_Sender (xTitle;"";xText)
	QM_Sender(xTitle; ""; xText; distributionList)
	//rPrintText ("RMoverIssue.LOG")
End if 