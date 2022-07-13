//%attributes = {"publishedWeb":true}
//(p) rEffecMr2Disk
//$1- text - folder path for document
//$2 - string - report division
//print effeciency Make ready report to disk
//• 2/23/98 cs created
//• 3/3/98 cs change wher reports get production data from
// from JMI actuals to [machineticket good units
//•090398  MLB  populating CC arrays fails

C_TEXT:C284(xText; $1)
C_LONGINT:C283($Count; $i)
C_TEXT:C284($T)
C_TEXT:C284($Format; $Dollar)
C_REAL:C285($Var; $Tot; $VarTot; $DolTot; $VarGrand; $DolGrand)
C_TEXT:C284($2)  //report division
C_BOOLEAN:C305($0)

ON EVENT CALL:C190("eCancelPrint")

<>fContinue:=True:C214
$0:=False:C215  //used to indicate that reporting to disk completed
$Format:="###,###,##0.00"
$Dollar:="$#,###,##0.00"
$T:=Char:C90(9)
vDoc:=?00:00:00?
//setup titles
$Count:=Records in selection:C76([Job_Forms_Machine_Tickets:61])
vDoc:=Create document:C266($1+"MR Efficiency "+String:C10(dDateBegin)+"-"+String:C10(dDateEnd))

If (vDoc#?00:00:00?)
	//* setup header
	xText:=String:C10(4D_Current_date)+($t*3)+"MR Efficiency for"+$2+Char:C90(13)+($t*4)+"for Date Range: "+String:C10(dDateBegin)+" to "+String:C10(dDateEnd)+Char:C90(13)+Char:C90(13)
	xText:=xText+"Cost Center"+$t+"Job Form"+$t+"Customer | Line"+$t+"Seq"+$t+"Actual MR"+$t+"Standard MR"+$t+"MR Varience"+$t+"OOP MR"+$t+"Total"+$t+"Effeciency % (Standard/Actual)"+Char:C90(13)
	SEND PACKET:C103(vDoc; xText)
	$CurCC:=""
	uThermoInit($Count; "Printing Make Ready Effeciencies")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; $Count)
			xText:=""
			//* - get cost center data
			//•090398  MLB  this fails
			If ([Cost_Centers:27]ID:1#[Job_Forms_Machine_Tickets:61]CostCenterID:2)  //& ([COST_CENTER]EffectivityDate<=[MachineTicket]DateEntered)
				findCC([Job_Forms_Machine_Tickets:61]CostCenterID:2; !00-00-00!)  //•090398  MLB  get the latest using existing code
				
				//SEARCH([COST_CENTER];[COST_CENTER]ID=[MachineTicket]CostCenterID)
				//SORT SELECTION([COST_CENTER];[COST_CENTER]EffectivityDate;<)
				//  `* locate active cost center data  
				//While (Not(End selection([COST_CENTER])) & ([COST_CENTER
				//«]EffectivityDate>[MachineTicket]DateEntered))
				//NEXT RECORD([COST_CENTER])
				//End while 
				//ONE RECORD SELECT([COST_CENTER])  `make it the only one in memory
			End if 
			
			If ([Job_Forms_Items:44]JobForm:1#[Job_Forms_Machine_Tickets:61]JobForm:1)
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Machine_Tickets:61]JobForm:1)
			End if 
			
			If ([Finished_Goods:26]ProductCode:1#[Job_Forms_Items:44]ProductCode:3)  //* locate product data
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Job_Forms_Items:44]ProductCode:3)
			End if 
			
			If ([Customers:16]ID:1#[Job_Forms_Items:44]CustId:15)  //* locate custoemr data
				QUERY:C277([Customers:16]; [Customers:16]ID:1=[Job_Forms_Items:44]CustId:15)
			End if 
			//* save values for other reports
			aDesc{$i}:=[Cost_Centers:27]Description:3
			ayDown_Bud{$i}:=[Cost_Centers:27]DownBudget:11
			arNum1{$i}:=[Cost_Centers:27]MHRoopSales:7
			aText{$i}:=[Customers:16]Name:2+" | "+[Finished_Goods:26]Line_Brand:15
			//* populate text for send packet  
			If ([Job_Forms_Machine_Tickets:61]CostCenterID:2#$CurCC)
				xText:=[Job_Forms_Machine_Tickets:61]CostCenterID:2+$t
				xText:=xText+[Cost_Centers:27]Description:3+Char:C90(13)
				$CurCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
				SEND PACKET:C103(vDoc; xText)
				xText:=$t
			Else 
				xText:=$t
			End if 
			$Var:=[Job_Forms_Machine_Tickets:61]MR_AdjStd:14-[Job_Forms_Machine_Tickets:61]MR_Act:6  //$varience for this item
			$Tot:=$Var*arNum1{$i}  //tot $ for this item
			xText:=xText+[Job_Forms_Machine_Tickets:61]JobForm:1+$t  //job item
			xText:=xText+aText{$i}+$t  //custoemr/line
			xText:=xText+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3)+$t  //sequence 
			xText:=xText+String:C10([Job_Forms_Machine_Tickets:61]MR_Act:6; $Format)+$t  //actals
			xText:=xText+String:C10([Job_Forms_Machine_Tickets:61]MR_AdjStd:14; $Format)+$t  //budget
			xText:=xText+String:C10($Var; $Format)+$t  //varience
			xText:=xText+String:C10(arNum1{$i}; $Dollar)+$t  //$/hr
			xText:=xText+String:C10(arNum1{$i}*$Var; $Dollar)+$t  //$ value of varience
			xText:=xText+String:C10(([Job_Forms_Machine_Tickets:61]MR_AdjStd:14/[Job_Forms_Machine_Tickets:61]MR_Act:6)*100; $Format)+"%"+Char:C90(13)  //eff
			$VarTot:=$VarTot+$Var
			$DolTot:=$DolTot+$Tot
			SEND PACKET:C103(vDoc; xText)  //*write to disk
			NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
			
			If ($CurCC#[Job_Forms_Machine_Tickets:61]CostCenterID:2) | (End selection:C36([Job_Forms_Machine_Tickets:61]))  //*if the next Cost center is different or endo of records
				xText:=($t*5)+"Total for CC"+$t+String:C10($VarTot; $Format)+$t+$t+String:C10($DolTot; $Dollar)+Char:C90(13)+Char:C90(13)  //print CC totals
				$VarGrand:=$VarGrand+$VarTot  //add to grand totals
				$DolGrand:=$DolGrand+$DolTot
				$DolTot:=0
				$VarTot:=0
				SEND PACKET:C103(vDoc; xText)
				
				If (End selection:C36([Job_Forms_Machine_Tickets:61]))  //if end of records print grand totals for report
					xText:=($t*5)+"Grand Total"+$t+String:C10($VarGrand; $Format)+$t+$t+String:C10($DolGrand; $Dollar)
					SEND PACKET:C103(vDoc; xText)
					CLOSE DOCUMENT:C267(vDoc)
					xText:=""
					$0:=True:C214  //*report completed normally - continue to next report
				End if 
			End if 
			
			If (Not:C34(<>fContinue))  //*user has canceled report
				$i:=$Count+1
				CLOSE DOCUMENT:C267(vDoc)
			End if 
			uThermoUpdate($i)
		End for 
		
		
	Else 
		
		//Laghzaoui see from ligne 181 to 191
		
		ARRAY TEXT:C222($_CostCenterID; 0)
		ARRAY TEXT:C222($_JobForm; 0)
		ARRAY REAL:C219($_MR_AdjStd; 0)
		ARRAY REAL:C219($_MR_Act; 0)
		ARRAY INTEGER:C220($_Sequence; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID; \
			[Job_Forms_Machine_Tickets:61]JobForm:1; $_JobForm; \
			[Job_Forms_Machine_Tickets:61]MR_AdjStd:14; $_MR_AdjStd; \
			[Job_Forms_Machine_Tickets:61]MR_Act:6; $_MR_Act; \
			[Job_Forms_Machine_Tickets:61]Sequence:3; $_Sequence)
		
		For ($i; 1; $Count; 1)
			xText:=""
			
			If ([Cost_Centers:27]ID:1#$_CostCenterID{$i})  //& ([COST_CENTER]EffectivityDate<=[MachineTicket]DateEntered)
				findCC($_CostCenterID{$i}; !00-00-00!)  //•090398  MLB  get the latest using existing code
			End if 
			
			If ([Job_Forms_Items:44]JobForm:1#$_JobForm{$i})
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$_JobForm{$i})
			End if 
			
			If ([Finished_Goods:26]ProductCode:1#[Job_Forms_Items:44]ProductCode:3)  //* locate product data
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Job_Forms_Items:44]ProductCode:3)
			End if 
			
			If ([Customers:16]ID:1#[Job_Forms_Items:44]CustId:15)  //* locate custoemr data
				QUERY:C277([Customers:16]; [Customers:16]ID:1=[Job_Forms_Items:44]CustId:15)
			End if 
			//* save values for other reports
			aDesc{$i}:=[Cost_Centers:27]Description:3
			ayDown_Bud{$i}:=[Cost_Centers:27]DownBudget:11
			arNum1{$i}:=[Cost_Centers:27]MHRoopSales:7
			aText{$i}:=[Customers:16]Name:2+" | "+[Finished_Goods:26]Line_Brand:15
			//* populate text for send packet  
			If ($_CostCenterID{$i}#$CurCC)
				xText:=$_CostCenterID{$i}+$t
				xText:=xText+[Cost_Centers:27]Description:3+Char:C90(13)
				$CurCC:=$_CostCenterID{$i}
				SEND PACKET:C103(vDoc; xText)
				xText:=$t
			Else 
				xText:=$t
			End if 
			$Var:=$_MR_AdjStd{$i}-$_MR_Act{$i}  //$varience for this item
			$Tot:=$Var*arNum1{$i}  //tot $ for this item
			xText:=xText+$_JobForm{$i}+$t  //job item
			xText:=xText+aText{$i}+$t  //custoemr/line
			xText:=xText+String:C10($_Sequence{$i})+$t  //sequence 
			xText:=xText+String:C10($_MR_Act{$i}; $Format)+$t  //actals
			xText:=xText+String:C10($_MR_AdjStd{$i}; $Format)+$t  //budget
			xText:=xText+String:C10($Var; $Format)+$t  //varience
			xText:=xText+String:C10(arNum1{$i}; $Dollar)+$t  //$/hr
			xText:=xText+String:C10(arNum1{$i}*$Var; $Dollar)+$t  //$ value of varience
			xText:=xText+String:C10(($_MR_AdjStd{$i}/$_MR_Act{$i})*100; $Format)+"%"+Char:C90(13)  //eff
			$VarTot:=$VarTot+$Var
			$DolTot:=$DolTot+$Tot
			SEND PACKET:C103(vDoc; xText)  //*write to disk
			
			//Ps Add TO CHECK
			$Iter:=$i
			$Iter:=$Iter+1
			C_TEXT:C284($CostCenterID_4d)
			
			If ($Iter>Size of array:C274($_CostCenterID))
				$CostCenterID_4d:=""
			Else 
				
				$CostCenterID_4d:=$_CostCenterID{$Iter}
				
			End if 
			
			If ($CurCC#$CostCenterID_4d) | ($Iter>Size of array:C274($_CostCenterID))  //*if the next Cost center is different or endo of records
				xText:=($t*5)+"Total for CC"+$t+String:C10($VarTot; $Format)+$t+$t+String:C10($DolTot; $Dollar)+Char:C90(13)+Char:C90(13)  //print CC totals
				$VarGrand:=$VarGrand+$VarTot  //add to grand totals
				$DolGrand:=$DolGrand+$DolTot
				$DolTot:=0
				$VarTot:=0
				SEND PACKET:C103(vDoc; xText)
				
				If ($Iter>Size of array:C274($_CostCenterID))  //if end of records print grand totals for report
					xText:=($t*5)+"Grand Total"+$t+String:C10($VarGrand; $Format)+$t+$t+String:C10($DolGrand; $Dollar)
					SEND PACKET:C103(vDoc; xText)
					CLOSE DOCUMENT:C267(vDoc)
					xText:=""
					$0:=True:C214  //*report completed normally - continue to next report
				End if 
			End if 
			
			If (Not:C34(<>fContinue))  //*user has canceled report
				$i:=$Count+1
				CLOSE DOCUMENT:C267(vDoc)
			End if 
			uThermoUpdate($i)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	uThermoClose
Else 
	ALERT:C41("Disk file could not be created.")
End if 

ON EVENT CALL:C190("")

uClearSelection(->[Cost_Centers:27])
uClearSelection(->[Finished_Goods:26])
uClearSelection(->[Customers:16])