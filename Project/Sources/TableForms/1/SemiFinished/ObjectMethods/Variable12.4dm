//(S) [CONTROL]RMTransfer'bPost
//upr 1255 10/26/94
//1/10/95 [rmbin]comkey & [rmxf]comcode added
//Upr 0235 -Cs- 12/3/96 - chargecode conversion
//• 2/21/97 cs modification to get charge code to assign correctly to rm_xfer & bi
// based on initial rm_xfer record for starting Rawmaterial
//•082997  MLB loosing selection afteran apply formula & tidy up a bit
//• 4/9/98 cs nan checking/removal
//•061499  mlb  guard against over 100% removal

C_TEXT:C284($sDiv; $sDept; $sExpen)
C_REAL:C285($percent; $machCost; $matlCost; $ActualCost)
C_BOOLEAN:C305($Actuals)
C_LONGINT:C283($i; $Company; $Depart; $Expense)
C_TEXT:C284($ChargeCode)

$Company:=1  //•2/21/97 declaer and assing local for parseing chrgcode
$Depart:=2
$Expense:=3
$ChargeCode:=tText  //•082997  MLB  get this from the dialog
$sDiv:=ChrgCodeParse($ChargeCode; $Company)  //•082997  MLB  just assign these values once
$sDept:=ChrgCodeParse($ChargeCode; $Depart)  //•082997  MLB  just assign these values once
$sExpen:=ChrgCodeParse($ChargeCode; $Expense)  //•082997  MLB  just assign these values once
//*Validate input
Case of 
	: (sCriterion1="") | (sCriterion1="00000.00")
		BEEP:C151
		ALERT:C41("A job form number is required to proceed.")
		GOTO OBJECT:C206(sCriterion1)
	: (Num:C11(sCriterion2)=0)
		BEEP:C151
		ALERT:C41("A sequence number is required to proceed.")
		GOTO OBJECT:C206(sCriterion2)
	: (sCriterion3="")
		BEEP:C151
		ALERT:C41("A commodity code is required to proceed.")
		GOTO OBJECT:C206(sCriterion3)
	: (sCriterion4="")
		BEEP:C151
		ALERT:C41("A commodity subgroup is  required to proceed.")
		GOTO OBJECT:C206(sCriterion4)
	: (sCriterion5="") | (sCriterion5="Type.CalWthLth.Style")
		BEEP:C151
		ALERT:C41("A part description {r/m code} is required to proceed.")
		GOTO OBJECT:C206(sCriterion5)
	: (sCriterion6="")
		BEEP:C151
		ALERT:C41("A location is required to proceed.")
		GOTO OBJECT:C206(sCriterion6)
	: (t2="")
		BEEP:C151
		ALERT:C41("A Unit of Measure is required to proceed.")
		GOTO OBJECT:C206(sCriterion6)
	: (rReal1=0)
		BEEP:C151
		ALERT:C41("A quantity is required to proceed.")
	: (Length:C16($ChargeCode)#11) | ($ChargeCode="0-0000-0000")
		BEEP:C151
		ALERT:C41("An 11 character Charge Code is required to proceed."+Char:C90(13)+"(Div-Dept-Expense as in 1-4270-1126)"+Char:C90(13)+"not "+$ChargeCode)
		GOTO OBJECT:C206(tText)
	: (Num:C11($sDiv)>3) | (Num:C11($sDiv)<1)
		ALERT:C41("Company ID portion of Chargecode entered is Invalid, Must be a value between 1 "+"and 3")
	: (Length:C16($sDept)#4)  //correct number of characters for department
		ALERT:C41("Department portion of Chargecode entered is Invalid, 4 Characters required")
	: (Character code:C91($sDept[[1]])<48) | (Character code:C91($sDept[[1]])>57)  //character is not a number
		ALERT:C41("Department portion of Chargecode entered is Invalid, All Characters must"+" be Numbers")
	: (Character code:C91($sDept[[2]])<48) | (Character code:C91($sDept[[2]])>57)  //character is not a number
		ALERT:C41("Department portion of Chargecode entered is Invalid, All Characters must"+" be Numbers")
	: (Character code:C91($sDept[[3]])<48) | (Character code:C91($sDept[[3]])>57)  //character is not a number
		ALERT:C41("Department portion of Chargecode entered is Invalid, All Characters must"+" be Numbers")
	: (Character code:C91($sDept[[4]])<48) | (Character code:C91($sDept[[4]])>57)  //character is not a number    
		ALERT:C41("Department portion of Chargecode entered is Invalid, All Characters must"+" be Numbers")
		
	Else   //restock the subassembly
		
		MESSAGES OFF:C175
		
		
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=sCriterion1; *)  //*  Get the job sequences
			QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5<=Num:C11(sCriterion2))
			CREATE SET:C116([Job_Forms_Machines:43]; "hold")  //•082997  MLB
			
			ARRAY INTEGER:C220($aSeq; 0)
			SELECTION TO ARRAY:C260([Job_Forms_Machines:43]Sequence:5; $aSeq)
			$i:=Find in array:C230($aSeq; (Num:C11(sCriterion2)))
			ARRAY INTEGER:C220($aSeq; 0)
			
		Else 
			ARRAY LONGINT:C221($_hold; 0)
			
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=sCriterion1; *)  //*  Get the job sequences
			QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5<=Num:C11(sCriterion2))
			LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Machines:43]; $_hold)
			
			SET QUERY LIMIT:C395(1)
			SET QUERY DESTINATION:C396(Into variable:K19:4; $i)
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=sCriterion1; *)  //*  Get the job sequences
			QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=Num:C11(sCriterion2))
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			SET QUERY LIMIT:C395(0)
			
			
		End if   // END 4D Professional Services : January 2019 
		
		If ($i<0)
			BEEP:C151
			ALERT:C41("Sequence "+sCriterion2+" not found on job "+sCriterion1)
			
		Else 
			//NewWindow (250;40;6;5;"Posting Semi-Finished")
			zwStatusMsg("RESTOCK"; " Posting. Please Wait...")
			
			fCnclTrn:=False:C215
			zwStatusMsg("RESTOCK"; " updating machince actuals")
			APPLY TO SELECTION:C70([Job_Forms_Machines:43]; uGetActMachData)  //*   update the actuals in Machine_Job
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
				
				USE SET:C118("hold")  //•082997  MLB 
				CLEAR SET:C117("hold")  //•082997  MLB  
				
			Else 
				
				CREATE SELECTION FROM ARRAY:C640([Job_Forms_Machines:43]; $_hold)
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
				//test for actuals
				$Actuals:=True:C214
				$machCost:=0
				FIRST RECORD:C50([Job_Forms_Machines:43])
				
				For ($i; 1; Records in selection:C76([Job_Forms_Machines:43]))
					If ([Job_Forms_Machines:43]Actual_Qty:19=0)
						$Actuals:=False:C215
					Else 
						$percent:=rReal1/[Job_Forms_Machines:43]Actual_Qty:19
					End if 
					$machCost:=$machCost+[Job_Forms_Machines:43]Actual_Labor:22+[Job_Forms_Machines:43]Actual_OH:23+[Job_Forms_Machines:43]Actual_SE_Cost:25
					NEXT RECORD:C51([Job_Forms_Machines:43])
				End for 
				
			Else 
				
				$Actuals:=True:C214
				$machCost:=0
				
				ARRAY INTEGER:C220($_Sequence; 0)
				ARRAY REAL:C219($_Actual_Qty; 0)
				ARRAY REAL:C219($_Actual_Labor; 0)
				ARRAY REAL:C219($_Actual_OH; 0)
				ARRAY REAL:C219($_Actual_SE_Cost; 0)
				
				SELECTION TO ARRAY:C260([Job_Forms_Machines:43]Sequence:5; $_Sequence; [Job_Forms_Machines:43]Actual_Qty:19; $_Actual_Qty; [Job_Forms_Machines:43]Actual_Labor:22; $_Actual_Labor; [Job_Forms_Machines:43]Actual_OH:23; $_Actual_OH; [Job_Forms_Machines:43]Actual_SE_Cost:25; $_Actual_SE_Cost)
				
				SORT ARRAY:C229($_Sequence; $_Actual_Qty; $_Actual_Labor; $_Actual_OH; $_Actual_SE_Cost; >)
				
				
				For ($i; 1; Size of array:C274($_Sequence); 1)
					If ($_Actual_Qty{$i}=0)
						$Actuals:=False:C215
					Else 
						$percent:=rReal1/$_Actual_Qty{$i}
					End if 
					$machCost:=$machCost+$_Actual_Labor{$i}+$_Actual_OH{$i}+$_Actual_SE_Cost{$i}
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			If ($percent=0)  //*    See if any actual quantities have been recorded
				BEEP:C151
				ALERT:C41("No actual quantities were found to calculate the portion of restock.")
				fCnclTrn:=True:C214
			Else 
				
				If ($percent>1)  //•061499  mlb  
					fCnclTrn:=True:C214
					BEEP:C151
					ALERT:C41(String:C10(rReal1)+" units are more than 100% of the job. Try a smaller amount or get more machtics.")
				End if 
				
				If (Not:C34($Actuals))  //*    See if any actual quantities have not been recorded
					BEEP:C151
					CONFIRM:C162("WARNING: All of the Machine Tickets have not been recorded. Continue?")
					If (ok=0)
						fCnclTrn:=True:C214
					End if 
				End if 
			End if 
			
			If (Not:C34(fCnclTrn))
				zwStatusMsg("RESTOCK"; " updating material actuals")
				//SEARCH([Material_Job];[Material_Job]JobForm=sCriterion1;*)  
				//*Get the mat'l sequences
				//SEARCH([Material_Job]; & [Material_Job]Sequence<=Num(sCriterion2))
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=sCriterion1; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Sequence:13<=(Num:C11(sCriterion2)); *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Sequence:13#0)
				If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
					//CREATE SET([Material_Job];"hold")  `•082997  MLB 
					//APPLY TO SELECTION([Material_Job];uGetActMatlData )
					//USE SET("hold")  `•082997  MLB 
					//CLEAR SET("hold")  `•082997  MLB  
					$matlCost:=(Sum:C1([Raw_Materials_Transactions:23]ActExtCost:10)*-1)
				Else 
					$matlCost:=0
				End if 
				
				If ($matlCost<=0)
					BEEP:C151
					CONFIRM:C162("WARNING: Material Cost equal zero. Continue?")
					If (ok=0)
						fCnclTrn:=True:C214
					End if 
				End if   //no material costs    
			Else 
				$matlCost:=0
			End if 
		End if 
		
		If (Not:C34(fCnclTrn))
			$ActualCost:=($matlCost+$machCost)*$percent
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=String:C10(Num:C11(sCriterion3); "00")+"-"+sCriterion4)  //to get type
			If (Records in selection:C76([Raw_Materials_Groups:22])=0)
				CREATE RECORD:C68([Raw_Materials_Groups:22])
				[Raw_Materials_Groups:22]Commodity_Code:1:=Num:C11(sCriterion3)
				[Raw_Materials_Groups:22]Commodity_Key:3:=String:C10(Num:C11(sCriterion3); "00")+"-"+sCriterion4
				[Raw_Materials_Groups:22]zCount:5:=1
				[Raw_Materials_Groups:22]ModDate:6:=4D_Current_date
				[Raw_Materials_Groups:22]ModWho:7:=<>zResp
				[Raw_Materials_Groups:22]SubGroup:10:=sCriterion4
				[Raw_Materials_Groups:22]ReceiptType:13:=1
				[Raw_Materials_Groups:22]ChargeCode:11:=$ChargeCode
				[Raw_Materials_Groups:22]CompanyID:21:=$sDiv
				[Raw_Materials_Groups:22]DepartmentID:22:=$sDept
				//[Raw_Materials_Groups]ExpenseCode:=$sExpen
				[Raw_Materials_Groups:22]GL_Expense_Code:25:=$sExpen
				[Raw_Materials_Groups:22]UOM:8:=t2
				SAVE RECORD:C53([Raw_Materials_Groups:22])
			End if 
			REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
			//• 2/21/97 locate transfer record for orignial raw material get charge code
			If (False:C215)  //•082997  MLB  use the users input
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=sCriterion1; *)
				QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Sequence:13=Num:C11(sCriterion2))
				$Chargecode:=[Raw_Materials_Transactions:23]CompanyID:20+[Raw_Materials_Transactions:23]DepartmentID:21+[Raw_Materials_Transactions:23]ExpenseCode:26
			End if 
			//end 2/21/97
			
			READ WRITE:C146([Raw_Materials:21])
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sCriterion5)
			If (Records in selection:C76([Raw_Materials:21])=1)
				If ([Raw_Materials:21]Commodity_Key:2#(String:C10(Num:C11(sCriterion3); "00")+"-"+sCriterion4))  //we must rename it and make another r/m rec
					$i:=0
					Repeat 
						$i:=$i+1
						If (Length:C16(sCriterion5)<20)
							sCriterion5:=sCriterion5+"!"
						Else 
							$i:=$i+1
							sCriterion5:=Substring:C12(sCriterion5; 1; 18)+String:C10($i; "00")
						End if 
						QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sCriterion5)
					Until (Records in selection:C76([Raw_Materials:21])=0)
					BEEP:C151
					ALERT:C41("The item will be renamed: "+sCriterion5)
				End if 
			End if   //one found
			
			If (Records in selection:C76([Raw_Materials:21])=0)  //never found or new name required
				CREATE RECORD:C68([Raw_Materials:21])
				[Raw_Materials:21]Raw_Matl_Code:1:=sCriterion5
				[Raw_Materials:21]Commodity_Key:2:=String:C10(Num:C11(sCriterion3); "00")+"-"+sCriterion4
				[Raw_Materials:21]Description:4:="Semi-Finished Goods, originally from job "+sCriterion1
				[Raw_Materials:21]ReceiptUOM:9:=t2
				[Raw_Materials:21]IssueUOM:10:=t2
				
				//Upr 0235
				//[RAW_MATERIALS]ChargeCode:=[RM_GROUP]ChargeCode
				[Raw_Materials:21]CompanyID:27:=$sDiv
				[Raw_Materials:21]DepartmentID:28:=$sDept
				[Raw_Materials:21]Obsolete_ExpCode:29:=$sExpen
				//end upr 0235
				
				[Raw_Materials:21]CommodityCode:26:=Num:C11(sCriterion3)
				[Raw_Materials:21]SubGroup:31:=sCriterion4
				[Raw_Materials:21]ActCost:45:=uNANCheck($ActualCost/rReal1)
				[Raw_Materials:21]ModDate:47:=4D_Current_date
				[Raw_Materials:21]ModWho:48:=<>zResp
				SAVE RECORD:C53([Raw_Materials:21])
			End if 
			REDUCE SELECTION:C351([Raw_Materials:21]; 0)
			
			READ WRITE:C146([Raw_Materials_Locations:25])
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sCriterion5; *)
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sCriterion6; *)
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19="A"+sCriterion1)  //this will be the jobform prefixed with an A
			
			If (Records in selection:C76([Raw_Materials_Locations:25])=0) | (Locked:C147([Raw_Materials_Locations:25]))
				zwStatusMsg("RESTOCK"; " creating a r/m location")
				CREATE RECORD:C68([Raw_Materials_Locations:25])
				[Raw_Materials_Locations:25]Raw_Matl_Code:1:=sCriterion5
				[Raw_Materials_Locations:25]Location:2:=sCriterion6
				[Raw_Materials_Locations:25]POItemKey:19:="A"+sCriterion1
				[Raw_Materials_Locations:25]QtyOH:9:=rReal1
				[Raw_Materials_Locations:25]QtyAvailable:13:=rReal1
				[Raw_Materials_Locations:25]ActCost:18:=uNANCheck($ActualCost/rReal1)
				[Raw_Materials_Locations:25]zCount:20:=1
				[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
				[Raw_Materials_Locations:25]ModWho:22:=<>zResp
				[Raw_Materials_Locations:25]Commodity_Key:12:=String:C10(Num:C11(sCriterion3); "00")+"-"+sCriterion4
				[Raw_Materials_Locations:25]CompanyID:27:=$sDiv
			Else 
				zwStatusMsg("RESTOCK"; " updating a r/m location")
				[Raw_Materials_Locations:25]ActCost:18:=uNANCheck(($ActualCost+([Raw_Materials_Locations:25]QtyOH:9*[Raw_Materials_Locations:25]ActCost:18))/(rReal1+[Raw_Materials_Locations:25]QtyOH:9))
				[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+rReal1
				[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13+rReal1
			End if 
			SAVE RECORD:C53([Raw_Materials_Locations:25])
			REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
			
			//commented out below on 3/6/08, viewed as unnecessary receipt transaction
			//zwStatusMsg ("RESTOCK";" creating a r/m xfers")
			//CREATE RECORD([Raw_Materials_Transactions])  `put back into inventory
			//[Raw_Materials_Transactions]Raw_Matl_Code:=sCriterion5
			//[Raw_Materials_Transactions]Xfer_Type:="Receipt"
			//[Raw_Materials_Transactions]XferDate:=4D_Current_date
			//[Raw_Materials_Transactions]POItemKey:="A"+sCriterion1
			//[Raw_Materials_Transactions]JobForm:=sCriterion1
			//[Raw_Materials_Transactions]Sequence:=Num(sCriterion2)+1
			//[Raw_Materials_Transactions]ReferenceNo:="Semifinished"
			//[Raw_Materials_Transactions]ActCost:=uNANCheck ($ActualCost/rReal1)
			//[Raw_Materials_Transactions]viaLocation:="WIP"  `10/26/94
			//[Raw_Materials_Transactions]Location:=sCriterion6
			//[Raw_Materials_Transactions]Qty:=rReal1
			//[Raw_Materials_Transactions]ActExtCost:=uNANCheck (Round($ActualCost;2))
			//[Raw_Materials_Transactions]Count:=1
			//[Raw_Materials_Transactions]ModDate:=4D_Current_date
			//[Raw_Materials_Transactions]ModWho:=◊zResp
			//[Raw_Materials_Transactions]Commodity_Key:=String(Num(sCriterion3);"00")+"-"+sCriterion4
			//[Raw_Materials_Transactions]CommodityCode:=Num(sCriterion3)
			//
			//  `•2/21/97 company id not being properly assigned
			//[Raw_Materials_Transactions]ExpenseCode:=$sExpen
			//[Raw_Materials_Transactions]DepartmentID:=$sDept
			//[Raw_Materials_Transactions]CompanyID:=$sDiv
			//  `end 2/21/97        
			//SAVE RECORD([Raw_Materials_Transactions])
			
			CREATE RECORD:C68([Raw_Materials_Transactions:23])  //take out of wip
			[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=sCriterion5
			[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
			[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
			[Raw_Materials_Transactions:23]POItemKey:4:="A"+sCriterion1
			[Raw_Materials_Transactions:23]JobForm:12:=sCriterion1
			[Raw_Materials_Transactions:23]Sequence:13:=Num:C11(sCriterion2)+1
			[Raw_Materials_Transactions:23]ReferenceNo:14:="Semifinished"
			[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck($ActualCost/rReal1)
			[Raw_Materials_Transactions:23]viaLocation:11:=sCriterion1  //"  `sCriterion6
			[Raw_Materials_Transactions:23]Location:15:=sCriterion6  //"WIP"
			[Raw_Materials_Transactions:23]Qty:6:=rReal1  //*(-1)
			[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94($ActualCost; 2))
			[Raw_Materials_Transactions:23]zCount:16:=1
			[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
			[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
			[Raw_Materials_Transactions:23]Commodity_Key:22:=String:C10(Num:C11(sCriterion3); "00")+"-"+sCriterion4
			[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(sCriterion3)
			
			[Raw_Materials_Transactions:23]Reason:5:="Semifinished"
			[Raw_Materials_Transactions:23]consignment:27:=False:C215
			
			//•2/21/97 company id not being properly assigned
			[Raw_Materials_Transactions:23]ExpenseCode:26:=$sExpen
			[Raw_Materials_Transactions:23]DepartmentID:21:=$sDept
			[Raw_Materials_Transactions:23]CompanyID:20:=$sDiv
			//end 2/21/97        
			SAVE RECORD:C53([Raw_Materials_Transactions:23])
			REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
			
			zwStatusMsg("RESTOCK"; " updating budget")
			QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=sCriterion1; *)
			QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]CostCenterID:4="SFM"; *)
			QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=(Num:C11(sCriterion2)+1))
			If (Records in selection:C76([Job_Forms_Machines:43])=0)
				CREATE RECORD:C68([Job_Forms_Machines:43])
				[Job_Forms_Machines:43]JobForm:1:=sCriterion1
				[Job_Forms_Machines:43]CostCenterID:4:="SFM"
				[Job_Forms_Machines:43]Sequence:5:=Num:C11(sCriterion2)+1
				[Job_Forms_Machines:43]Comment:2:="Semifinished Material Removed"
				[Job_Forms_Machines:43]ModDate:32:=4D_Current_date
				[Job_Forms_Machines:43]ModWho:33:=<>zResp
			End if 
			[Job_Forms_Machines:43]Actual_Qty:19:=[Job_Forms_Machines:43]Actual_Qty:19+(-1*rReal1)  //•090297  MLB  
			SAVE RECORD:C53([Job_Forms_Machines:43])
			REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
			
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=sCriterion1; *)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]CostCenterID:2="SFM"; *)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Sequence:3=(Num:C11(sCriterion2)+1); *)
			QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Raw_Matl_Code:7=sCriterion5)
			If (Records in selection:C76([Job_Forms_Materials:55])=0)
				CREATE RECORD:C68([Job_Forms_Materials:55])
				[Job_Forms_Materials:55]JobForm:1:=sCriterion1
				[Job_Forms_Materials:55]Sequence:3:=Num:C11(sCriterion2)+1
				[Job_Forms_Materials:55]CostCenterID:2:="SFM"
				[Job_Forms_Materials:55]UOM:5:=t2
				[Job_Forms_Materials:55]Raw_Matl_Code:7:=sCriterion5
				[Job_Forms_Materials:55]Commodity_Key:12:=String:C10(Num:C11(sCriterion3); "00")+"-"+sCriterion4
				
				//Upr 0235
				// [Material_Job]ChargeCode:=[RM_GROUP]ChargeCode
				[Job_Forms_Materials:55]CompanyId:23:=$sDiv
				[Job_Forms_Materials:55]DepartmentID:24:=$sDept
				[Job_Forms_Materials:55]ExpenseCode:25:=$sExpen
				//end upr 0235          
				
				[Job_Forms_Materials:55]Comments:4:="Semifinished Material Removed"
			End if 
			[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
			[Job_Forms_Materials:55]ModWho:11:=<>zResp
			[Job_Forms_Materials:55]Actual_Qty:14:=uNANCheck([Job_Forms_Materials:55]Actual_Qty:14+(-1*rReal1))  //•090297  MLB  make negative
			[Job_Forms_Materials:55]Actual_Price:15:=uNANCheck([Job_Forms_Materials:55]Actual_Price:15+Round:C94($ActualCost; 2))
			
			SAVE RECORD:C53([Job_Forms_Materials:55])
			REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
			
			CREATE RECORD:C68([Job_Forms_Machine_Tickets:61])
			[Job_Forms_Machine_Tickets:61]JobForm:1:=sCriterion1
			[Job_Forms_Machine_Tickets:61]CostCenterID:2:="SFM"
			[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4:=0
			[Job_Forms_Machine_Tickets:61]Sequence:3:=Num:C11(sCriterion2)
			[Job_Forms_Machine_Tickets:61]DateEntered:5:=4D_Current_date
			[Job_Forms_Machine_Tickets:61]MR_Act:6:=0
			[Job_Forms_Machine_Tickets:61]Run_Act:7:=0
			[Job_Forms_Machine_Tickets:61]Run_AdjStd:15:=0
			[Job_Forms_Machine_Tickets:61]Good_Units:8:=-1*rReal1
			[Job_Forms_Machine_Tickets:61]Waste_Units:9:=0
			[Job_Forms_Machine_Tickets:61]P_C:10:="S"
			[Job_Forms_Machine_Tickets:61]BudRunSpeed:13:=0
			[Job_Forms_Machine_Tickets:61]DownHrs:11:=0
			[Job_Forms_Machine_Tickets:61]DownHrsCat:12:=""
			[Job_Forms_Machine_Tickets:61]Shift:18:=0
			[Job_Forms_Machine_Tickets:61]TimeStampEntered:17:=TSTimeStamp
			[Job_Forms_Machine_Tickets:61]MRcode:19:=""
			SAVE RECORD:C53([Job_Forms_Machine_Tickets:61])
		End if 
		
		//    End if   `not cancel
		CLOSE WINDOW:C154
		
End case   //there is a sequence match    
MESSAGES ON:C181

sCriterion1:="00000.00"
sCriterion2:="00"
//sCriterion3:="1"
//sCriterion4:="Semi-Finished"
sCriterion5:="Type.CalWthLth.Style"
sCriterion6:="Arkay"
rReal1:=0
// tText:="0-0000-0000"
REDUCE SELECTION:C351([Job_Forms_Materials:55]; 0)
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)

GOTO OBJECT:C206(sCriterion1)