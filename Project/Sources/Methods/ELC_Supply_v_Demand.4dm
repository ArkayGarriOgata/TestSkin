//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/14/09, 10:51:18
// ----------------------------------------------------
// Method: ELC_Supply_v_Demand
// Description
// look of supplies exceeding demand
//   supply = onhand(less b&h) + wip
//   demand = open releases
// ----------------------------------------------------

C_DATE:C307($planningFence)

$planningFence:=Add to date:C393(4D_Current_date; 0; 3; 0)
$planningFence:=Date:C102(Request:C163("Use Commit Zone date of:"; String:C10($planningFence); "Continue"; "Cancel"))
If (OK=1) & ($planningFence>Current date:C33)
	uConfirm("Limit report to Excesses?"; "Excess"; "All")
	If (OK=1)
		$limit:=True:C214
	Else 
		$limit:=False:C215
	End if 
	
	//load data into arrays unique by cpn
	ARRAY TEXT:C222($aFG_cpn; 0)
	ARRAY TEXT:C222($aFG_line; 0)
	ARRAY LONGINT:C221($aFG_onhand; 0)
	ARRAY LONGINT:C221($aFG_BillHold; 0)
	ARRAY LONGINT:C221($aFG_WIP; 0)
	ARRAY LONGINT:C221($aFG_Demand; 0)
	
	//find on-hand
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numBins:=ELC_query(->[Finished_Goods_Locations:35]CustID:16)
		
		
	Else 
		$criteria:=ELC_getName
		READ ONLY:C145([Finished_Goods_Locations:35])
		QUERY BY FORMULA:C48([Finished_Goods_Locations:35]; \
			([Finished_Goods_Locations:35]CustID:16=[Customers:16]ID:1)\
			 & ([Customers:16]ParentCorp:19=$criteria)\
			)
		$numBins:=Records in selection:C76([Finished_Goods_Locations:35])
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	
	ARRAY TEXT:C222($aBinFG; 0)
	ARRAY LONGINT:C221($aBinQty; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]ProductCode:1; $aBinFG; [Finished_Goods_Locations:35]QtyOH:9; $aBinQty)
	For ($bin; 1; $numBins)
		$hit:=Find in array:C230($aFG_cpn; $aBinFG{$bin})
		If ($hit=-1)  //create element for bucket
			APPEND TO ARRAY:C911($aFG_cpn; $aBinFG{$bin})
			APPEND TO ARRAY:C911($aFG_line; FG_getLine($aBinFG{$bin}))
			APPEND TO ARRAY:C911($aFG_onhand; $aBinQty{$bin})
			APPEND TO ARRAY:C911($aFG_BillHold; 0)
			APPEND TO ARRAY:C911($aFG_WIP; 0)
			APPEND TO ARRAY:C911($aFG_Demand; 0)
		Else 
			$aFG_onhand{$hit}:=$aFG_onhand{$hit}+$aBinQty{$bin}
		End if 
	End for 
	
	//grab the current bill&held qty
	ARRAY TEXT:C222($aBH_fg; 0)
	ARRAY LONGINT:C221($aBHqty; 0)
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Bill_and_Hold_Qty:108>0)
	SELECTION TO ARRAY:C260([Finished_Goods:26]ProductCode:1; $aBH_fg; [Finished_Goods:26]Bill_and_Hold_Qty:108; $aBHqty)
	For ($fg; 1; Size of array:C274($aBH_fg))
		$hit:=Find in array:C230($aFG_cpn; $aBH_fg{$fg})
		If ($hit>-1)
			$aFG_BillHold{$hit}:=$aBHqty{$fg}
		End if 
	End for 
	
	//grab the open production
	ARRAY TEXT:C222($aJob_fg; 0)
	ARRAY LONGINT:C221($aJob_qty; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numBins:=ELC_query(->[Job_Forms_Items:44]CustId:15)
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
		
		
	Else 
		
		READ ONLY:C145([Job_Forms_Items:44])
		$Critiria:=ELC_getName
		QUERY:C277([Job_Forms_Items:44]; [Customers:16]ParentCorp:19=$Critiria; *)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
		$numBins:=Records in selection:C76([Job_Forms_Items:44])
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aJob_fg; [Job_Forms_Items:44]Qty_Yield:9; $aJob_qty; [Job_Forms_Items:44]Qty_Actual:11; $aJob_act)
	For ($job; 1; Size of array:C274($aJob_fg))
		
		$openProduction:=$aJob_qty{$job}-$aJob_act{$job}
		If ($openProduction>0)
			
			$hit:=Find in array:C230($aFG_cpn; $aJob_fg{$job})
			If ($hit=-1)  //create element for bucket
				APPEND TO ARRAY:C911($aFG_cpn; $aJob_fg{$job})
				APPEND TO ARRAY:C911($aFG_line; FG_getLine($aJob_fg{$job}))
				APPEND TO ARRAY:C911($aFG_onhand; 0)
				APPEND TO ARRAY:C911($aFG_BillHold; 0)
				APPEND TO ARRAY:C911($aFG_WIP; $openProduction)
				APPEND TO ARRAY:C911($aFG_Demand; 0)
			Else 
				$aFG_WIP{$hit}:=$aFG_WIP{$hit}+$openProduction
			End if 
			
		End if 
	End for 
	
	//grab the open demand (based on releases)
	ARRAY TEXT:C222($aRel_fg; 0)
	ARRAY LONGINT:C221($aRel_qty; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numBins:=ELC_query(->[Customers_ReleaseSchedules:46]CustID:12)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$planningFence)
		
	Else 
		
		READ ONLY:C145([Customers_ReleaseSchedules:46])
		$Critiria:=ELC_getName
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$Critiria; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=$planningFence)
		$numBins:=Records in selection:C76([Customers_ReleaseSchedules:46])
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ProductCode:11; $aRel_fg; [Customers_ReleaseSchedules:46]OpenQty:16; $aRel_qty)
	For ($rel; 1; Size of array:C274($aRel_fg))
		
		$hit:=Find in array:C230($aFG_cpn; $aRel_fg{$rel})
		If ($hit=-1)  //create element for bucket
			APPEND TO ARRAY:C911($aFG_cpn; $aRel_fg{$rel})
			APPEND TO ARRAY:C911($aFG_line; FG_getLine($aRel_fg{$rel}))
			APPEND TO ARRAY:C911($aFG_onhand; 0)
			APPEND TO ARRAY:C911($aFG_BillHold; 0)
			APPEND TO ARRAY:C911($aFG_WIP; 0)
			APPEND TO ARRAY:C911($aFG_Demand; $aRel_qty{$rel})
		Else 
			$aFG_Demand{$hit}:=$aFG_Demand{$hit}+$aRel_qty{$rel}
		End if 
		
	End for 
	
	//wrap up and print report
	docName:="ELC_Supply_v_Demand_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->docName)
	If (OK=1)
		$r:=Char:C90(13)
		$t:=Char:C90(9)
		
		xTitle:="Supply v Demand - as of "+fYYMMDD(4D_Current_date)+" consuming demand to "+String:C10($planningFence)+$r
		SEND PACKET:C103($docRef; xTitle)
		xText:="Line"+$t+"CPN"+$t+"Qty_OH"+$t+"Qty_BH"+$t+"Open_WIP"+$t+"Supply"+$t+"Demand"+$t+"Excess(Short)"+$r
		
		For ($fg; 1; Size of array:C274($aFG_cpn))
			$supply:=$aFG_WIP{$fg}+($aFG_onhand{$fg}-$aFG_BillHold{$fg})
			$excess:=$supply-$aFG_Demand{$fg}
			If ($limit)
				If ($excess>0)  //we may have a problem, so report it
					xText:=xText+$aFG_line{$fg}+$t+$aFG_cpn{$fg}+$t+String:C10($aFG_onhand{$fg})+$t+String:C10($aFG_BillHold{$fg})+$t+String:C10($aFG_WIP{$fg})+$t+String:C10($supply)+$t+String:C10($aFG_Demand{$fg})+$t+String:C10($excess)+$r
				End if 
			Else   //show anything
				xText:=xText+$aFG_line{$fg}+$t+$aFG_cpn{$fg}+$t+String:C10($aFG_onhand{$fg})+$t+String:C10($aFG_BillHold{$fg})+$t+String:C10($aFG_WIP{$fg})+$t+String:C10($supply)+$t+String:C10($aFG_Demand{$fg})+$t+String:C10($excess)+$r
			End if 
			
			If (Length:C16(xText)>20000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
		End for 
		
		SEND PACKET:C103($docRef; xText)
		CLOSE DOCUMENT:C267($docRef)
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		$err:=util_Launch_External_App(docName)
		BEEP:C151
		
	Else 
		BEEP:C151
		ALERT:C41("Couldn't save "+docName)
	End if 
	
Else 
	BEEP:C151
End if   //planningfence