//%attributes = {"publishedWeb":true}
//PM: FG_NoticeOfNow90() -> 
//@author mlb - 9/12/02  15:16
//• mlb - 9/18/02  11:55 email to planners

READ ONLY:C145([Customers:16])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])

C_LONGINT:C283($numFGL)
C_TEXT:C284($t; $cr)
C_DATE:C307($nintyDaysAgo)
distributionList:=""

$t:=" "*5  //Char(9)
$cr:=Char:C90(13)
$nintyDaysAgo:=4D_Current_date-90
If (Day number:C114(4D_Current_date)=2)  //monday, do monday and weekend
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33=$nintyDaysAgo; *)
	QUERY:C277([Job_Forms_Items:44];  | ; [Job_Forms_Items:44]Glued:33=($nintyDaysAgo-1); *)  //sun
	QUERY:C277([Job_Forms_Items:44];  | ; [Job_Forms_Items:44]Glued:33=($nintyDaysAgo-2))  //sat
	
Else 
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Glued:33=$nintyDaysAgo)
End if 

If (Records in selection:C76([Job_Forms_Items:44])>0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		util_outerJoin(->[Finished_Goods_Locations:35]Jobit:33; ->[Job_Forms_Items:44]Jobit:4)
		
	Else 
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Locations:35])+" file. Please Wait...")
		ARRAY TEXT:C222($_Jobit; 0)
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			DISTINCT VALUES:C339([Job_Forms_Items:44]Jobit:4; $_Jobit)
			QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]Jobit:33; $_Jobit)
			
		Else 
			
			RELATE MANY SELECTION:C340([Finished_Goods_Locations:35]Jobit:33)
			
		End if   // END 4D Professional Services : January 2019 
		
		zwStatusMsg(""; "")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	$numFGL:=Records in selection:C76([Finished_Goods_Locations:35])
	If ($numFGL>0)
		//*........create report  
		xTitle:="90 Day Old Inventory"  // for planner = "+$planner
		$header:="The following inventory is now over 90 days old:"+Char:C90(13)
		$header:=$header+"PLNR"+$t+txt_Pad("CUSTOMER"; " "; 1; 28)+$t+"PRODUCT CODE        "+$t+"JOB ITEM     "+$t+"QUANTITY"+$t+"DESCRIPTION"+$cr
		//*For each planner   
		ARRAY TEXT:C222($aCust; 0)
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]CustID:16; $aCust; [Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]Jobit:33; $aJMI; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
		ARRAY TEXT:C222($aPln; $numFGL)
		ARRAY TEXT:C222($aCS; $numFGL)
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
			
			If (Length:C16([Customers:16]CustomerService:46)>0)
				$aCS{$i}:=[Customers:16]CustomerService:46
			Else 
				$aCS{$i}:="?C/S"
			End if 
			
			If ([Finished_Goods:26]ProductCode:1#$aCPN{$i})  //• mlb - 9/11/02  09:46
				qryFinishedGood($aCust{$i}; $aCPN{$i})
			End if 
			$aDesc{$i}:=[Finished_Goods:26]CartonDesc:3
			
			$aSortBy{$i}:=$aPln{$i}+$aCust{$i}+$aCPN{$i}+$aJMI{$i}
			$aCust{$i}:=$aCust{$i}+" "+Substring:C12([Customers:16]Name:2; 1; 20)  //• mlb - 9/11/02  09:46
		End for 
		SET QUERY LIMIT:C395(0)
		
		SORT ARRAY:C229($aSortBy; $aPln; $aCust; $aCPN; $aJMI; $aQty; $aDesc; $aCS; >)  //• mlb - 9/11/02  09:46
		ARRAY TEXT:C222($aSortBy; 0)
		
		xText:=$header
		uThermoInit($numFGL; "Saving Report...")
		If (Size of array:C274($aJMI)>0)
			$currPln:=$aPln{1}
			$currCS:=$aCS{1}  //• mlb - 10/2/02  14:38
			$currJobIt:=$aJMI{1}
			$currDesc:=$aDesc{1}
			$qtyJMI:=0  //accumulate by jobit
			$text:=txt_Pad($aPln{1}; " "; 1; 4)+$t+txt_Pad($aCust{1}; " "; 1; 28)+$t+txt_Pad($aCPN{1}; " "; 1; 20)+$t+$aJMI{1}+$t
			For ($i; 1; $numFGL)
				If ($currJobIt#$aJMI{$i})
					xText:=xText+$text+txt_Pad(String:C10($qtyJMI; "##,###,##0"); " "; -1; 10)+$t+$currDesc+$cr
					If ($currPln#$aPln{$i})
						If ($currPln#"?PLN")
							//QUERY([USER];[USER]Initials=$currPln)
							distributionList:=Email_WhoAmI([Users:5]UserName:11; $currPln)
						Else 
							distributionList:=""
						End if 
						
						If ($currCS#"?C/S")  //• mlb - 10/2/02  14:34
							//QUERY([USER];[USER]Initials=$currCS)
							distributionList:=distributionList+$t+Email_WhoAmI([Users:5]UserName:11; $currCS)
						End if 
						
						//distributionList:=distributionList+$t+"Marty Hoops <Marty.Hoops@arkay.com>"+$t+"Mark Drago <mark.drago@arkay.com>"+$t
						distributionList:=distributionList+$t+"brian.hopkins@arkay.com"+$t
						//distributionList:="mel.bohince@arkay.com"  //debug
						QM_Sender(xTitle; ""; xText; distributionList)
						//util_deleteDocument (GetDefaultPath +"inv90.log"+$currPln)
						//rPrintText ("inv90.log"+$currPln)
						$currPln:=$aPln{$i}
						$currCS:=$aCS{$i}
						xText:=$header
					End if   //diffent planner
					
					$currJobIt:=$aJMI{$i}
					$currDesc:=$aDesc{$i}
					$text:=txt_Pad($aPln{$i}; " "; 1; 4)+$t+txt_Pad($aCust{$i}; " "; 1; 28)+$t+txt_Pad($aCPN{$i}; " "; 1; 20)+$t+$aJMI{$i}+$t
					$qtyJMI:=0
				End if 
				$qtyJMI:=$qtyJMI+$aQty{$i}
				uThermoUpdate($i)
			End for 
		End if 
		xText:=xText+$text+txt_Pad(String:C10($qtyJMI; "##,###,##0"); " "; -1; 10)+$t+$currDesc+$cr
		
		If ($currPln#"?PLN")
			//QUERY([USER];[USER]Initials=$currPln)
			distributionList:=Email_WhoAmI([Users:5]UserName:11; $currPln)
		Else 
			distributionList:=""
		End if 
		xText:=xText
		
		If ($currCS#"?C/S")  //• mlb - 10/2/02  14:34
			//QUERY([USER];[USER]Initials=$currCS)
			distributionList:=distributionList+$t+Email_WhoAmI([Users:5]UserName:11; $currCS)
		End if 
		
		//distributionList:=distributionList+$t+"Marty Hoops <Marty.Hoops@arkay.com>"+$t+"Mark Drago <mark.drago@arkay.com>"+$t
		distributionList:=distributionList+$t+"brian.hopkins@arkay.com"+$t  //+"Rick Legler <rick.legler@arkay.com>"+$t
		//distributionList:="mel.bohince@arkay.com"  //debug
		QM_Sender(xTitle; ""; xText; distributionList)
		
		uThermoClose
	End if 
End if 