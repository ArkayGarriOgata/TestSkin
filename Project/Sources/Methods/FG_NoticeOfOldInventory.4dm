//%attributes = {"publishedWeb":true}
//PM: FG_NoticeOfOldInventory({days;planner}) -> 
//@author mlb - 8/21/02  11:12
//find inventory older than x days and send emai alert to planner
//• mlb - 9/11/02  09:40 add 1yr limiter, add custname and cpn desc

READ ONLY:C145([Customers:16])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])

C_LONGINT:C283($days; $1; $3)
C_BOOLEAN:C305($email)  //output style
C_DATE:C307($cutoff; $lowerBoundary)
C_TEXT:C284($planner; $2)
C_TEXT:C284($t; $cr)
C_TEXT:C284($header; xText; xTitle)
ARRAY TEXT:C222($aPLANNERS; 0)

$days:=90
$email:=True:C214
$lowerBoundary:=!2001-09-11!  //the day of the atrosity
//*Option to use other than 90 days
If (Count parameters:C259=1)
	$days:=$1
End if 
$cutoff:=4D_Current_date-$days

//*Option to use specific planner
If (Count parameters:C259>=2)
	ARRAY TEXT:C222($aPLANNERS; 1)
	$aPLANNERS{1}:=$2
Else 
	ALL RECORDS:C47([Customers:16])
	DISTINCT VALUES:C339([Customers:16]PlannerID:5; $aPLANNERS)
End if 

If (Count parameters:C259=3)
	$email:=False:C215
End if 

$t:=" "*5  //Char(9)
$cr:=Char:C90(13)
$header:="The following inventory is over "+String:C10($days)+" days old:"+Char:C90(13)
$header:=$header+"PLNR"+$t+txt_Pad("CUSTOMER"; " "; 1; 28)+$t+"PRODUCT CODE        "+$t+"JOB ITEM     "+$t+"QUANTITY"+$t+"DESCRIPTION"+$cr
//*For each planner
For ($j; 1; Size of array:C274($aPLANNERS))
	$planner:=$aPLANNERS{$j}
	//*....get their customers 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		QUERY:C277([Customers:16]; [Customers:16]PlannerID:5=$planner)
		//*........get all customers' inventory (not B&H) 
		util_outerJoin(->[Finished_Goods_Locations:35]CustID:16; ->[Customers:16]ID:1)
		QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH@")
		
		
	Else 
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Locations:35])+" file. Please Wait...")
		QUERY:C277([Finished_Goods_Locations:35]; [Customers:16]PlannerID:5=$planner; *)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH@")
		zwStatusMsg(""; "")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	$numFGL:=Records in selection:C76([Finished_Goods_Locations:35])
	
	If ($numFGL>0)  //only look for age qualifing jobits
		//*........find the glue dates older than 90, that is still onhand (!00/00/00)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			util_outerJoin(->[Job_Forms_Items:44]Jobit:4; ->[Finished_Goods_Locations:35]Jobit:33)  //get all jobits with inventory
			QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33<$cutoff; *)  //eliminate new ones
			QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Glued:33>$lowerBoundary)  //eliminate the very old
			
		Else 
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items:44])+" file. Please Wait...")
			QUERY:C277([Job_Forms_Items:44]; [Customers:16]PlannerID:5=$planner; *)
			QUERY:C277([Job_Forms_Items:44]; [Finished_Goods_Locations:35]Location:2#"BH@"; *)
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33<$cutoff; *)  //eliminate new ones
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33>$lowerBoundary)  //eliminate the very old
			zwStatusMsg(""; "")
		End if   // END 4D Professional Services : January 2019 query selection
		
		$numJMI:=Records in selection:C76([Job_Forms_Items:44])
		If ($numJMI>0)
			//*........get just old inventory (not B&H) 
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				util_outerJoin(->[Finished_Goods_Locations:35]Jobit:33; ->[Job_Forms_Items:44]Jobit:4)  //get the inventory of the old jobits
				QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH@")
				
			Else 
				
				ARRAY TEXT:C222($_Jobit; 0)
				zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Locations:35])+" file. Please Wait...")
				If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
					DISTINCT VALUES:C339([Job_Forms_Items:44]Jobit:4; $_Jobit)
					QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]Jobit:33; $_Jobit)
					QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH@")
					
				Else 
					
					
					RELATE MANY SELECTION:C340([Finished_Goods_Locations:35]Jobit:33)
					QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH@")
					
				End if   // END 4D Professional Services : January 2019 
				zwStatusMsg(""; "")
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			$numFGL:=Records in selection:C76([Finished_Goods_Locations:35])
			If ($numFGL>0)  //only look for age qualifing jobits
				//*........create report     
				ARRAY TEXT:C222($aCust; 0)
				SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]CustID:16; $aCust; [Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]Jobit:33; $aJMI; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
				ARRAY TEXT:C222($aPln; $numFGL)
				ARRAY TEXT:C222($aSortBy; $numFGL)
				ARRAY TEXT:C222($aDesc; $numFGL)
				SORT ARRAY:C229($aCust; $aCPN; $aJMI; $aQty; >)
				SET QUERY LIMIT:C395(1)  //for customer search
				For ($i; 1; $numFGL)
					If ([Customers:16]ID:1#$aCust{$i})
						QUERY:C277([Customers:16]; [Customers:16]ID:1=$aCust{$i})
					End if 
					
					If (Length:C16([Customers:16]PlannerID:5)>0)
						$aPln{$i}:=[Customers:16]PlannerID:5
					Else 
						$aPln{$i}:="?PLN"
					End if 
					
					If ([Finished_Goods:26]ProductCode:1#$aCPN{$i})  //• mlb - 9/11/02  09:46
						qryFinishedGood($aCust{$i}; $aCPN{$i})
					End if 
					$aDesc{$i}:=[Finished_Goods:26]CartonDesc:3
					
					$aSortBy{$i}:=$aPln{$i}+$aCust{$i}+$aCPN{$i}+$aJMI{$i}
					$aCust{$i}:=$aCust{$i}+" "+Substring:C12([Customers:16]Name:2; 1; 20)  //• mlb - 9/11/02  09:46
				End for 
				SET QUERY LIMIT:C395(0)
				
				SORT ARRAY:C229($aSortBy; $aPln; $aCust; $aCPN; $aJMI; $aQty; $aDesc; >)  //• mlb - 9/11/02  09:46
				ARRAY TEXT:C222($aSortBy; 0)
				
				xText:=$header
				uThermoInit($numFGL; "Saving Report...")
				If (Size of array:C274($aJMI)>0)
					
					$currJobIt:=$aJMI{1}
					$currDesc:=$aDesc{1}
					$qtyJMI:=0  //accumulate by jobit
					$text:=txt_Pad($aPln{1}; " "; 1; 4)+$t+txt_Pad($aCust{1}; " "; 1; 28)+$t+txt_Pad($aCPN{1}; " "; 1; 20)+$t+$aJMI{1}+$t
					For ($i; 1; $numFGL)
						If ($currJobIt#$aJMI{$i})
							xText:=xText+$text+String:C10($qtyJMI; "^^,^^^,^^0")+$t+$currDesc+$cr
							
							$currJobIt:=$aJMI{$i}
							$currDesc:=$aDesc{$i}
							$text:=txt_Pad($aPln{$i}; " "; 1; 4)+$t+txt_Pad($aCust{$i}; " "; 1; 28)+$t+txt_Pad($aCPN{$i}; " "; 1; 20)+$t+$aJMI{$i}+$t
							$qtyJMI:=0
						End if 
						$qtyJMI:=$qtyJMI+$aQty{$i}
						uThermoUpdate($i)
					End for 
				End if 
				xText:=xText+$text+String:C10($qtyJMI; "^^,^^^,^^0")+$t+$currDesc+$cr
				xText:=xText
				
				uThermoClose
				xTitle:="Old Inventory for planner = "+$planner
				//
				If ($email)
					If ($planner#"?PLN")
						distributionList:=Email_WhoAmI(""; $planner)
					Else 
						distributionList:=""
					End if 
					
					//distributionList:=distributionList+$t+"Marty Hoops <Marty.Hoops@arkay.com>"+$t
					distributionList:=distributionList+$t+"Brian Hopkins <brian.hopkins@arkay.com>"+$t
					QM_Sender(xTitle; ""; xText; distributionList)
				Else 
					
					util_deleteDocument(GetDefaultPath+"inv.log."+$planner)
					rPrintText("inv.log."+$planner)
				End if 
				
			Else 
				BEEP:C151
				zwStatusMsg("Alert"; "No non-Bill&Hold inventory found: "+String:C10($days)+"days and planner = "+$planner)
			End if 
		Else 
			BEEP:C151
			zwStatusMsg("ALERT"; "No Jobits older than "+String:C10($days)+"days and planner = "+$planner)
		End if 
		
	Else 
		BEEP:C151
		zwStatusMsg("ALERT"; "No Finished Good inventory for  planner = "+$planner)
	End if 
End for 

BEEP:C151
BEEP:C151