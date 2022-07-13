// _______
// Method: [Job_Forms].GroupClose.verify   ( ) ->
// By: Mel Bohince @ 02/23/00, 09:10:34
// Description
// verify if prerequisites have been met
// ----------------------------------------------------
//1) complete date
//2) machine tickets
//3) issue tickets
//4) glue items
//5) no cc or ex bins

// Modified by: Mel Bohince (4/24/18)  skip direct purchase dies
// Modified by: Mel Bohince (10/8/21) any cf is ok, esspecially butt rolls, and skip plates

Est_LogIt("init")
Est_LogIt("Begin prerequisit verification at "+TS2String(TSTimeStamp); 0)
MESSAGES OFF:C175
READ ONLY:C145([Job_Forms:42])
C_LONGINT:C283($comKey; $i; $countIssues)
C_BOOLEAN:C305($ready)

uThermoInit(Size of array:C274(aRpt); "Verifing Prerequisites")

For ($i; 1; Size of array:C274(aRpt))  //*for each job, print jobclosout,waste and save jobclosesummary record.
	uThermoUpdate($i; 2)
	If (aRpt{$i}="√")  //selected to be reported
		$ready:=True:C214
		//1) complete date
		
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=aJFID{$i})
		// Modified by: Mel Bohince (6/21/17) 
		//skip some jobtypes
		Case of 
			: ([Job_Forms:42]JobType:33="6 R & D")
				aCustName{$i}:=[Job_Forms:42]JobType:33+" "+aCustName{$i}
			: ([Job_Forms:42]JobType:33="5 Line Trial")
				aCustName{$i}:=[Job_Forms:42]JobType:33+" "+aCustName{$i}
			: ([Job_Forms:42]JobType:33="2 Proof")
				aCustName{$i}:=[Job_Forms:42]JobType:33+" "+aCustName{$i}
			Else 
				//verify
				Est_LogIt(aJFID{$i}+" - "+[Job_Forms:42]JobType:33+" - "+[Job_Forms:42]Status:6+":"; 0)
				RELATE MANY:C262([Job_Forms:42]JobFormID:5)
				DISTINCT VALUES:C339([Job_Forms_Materials:55]Commodity_Key:12; $aComKeysBudgeted)
				
				If ([Job_Forms:42]Completed:18=!00-00-00!)
					Est_LogIt("         No complete date"; 0)
					$ready:=False:C215
				End if 
				
				//2) machine tickets
				If (Records in selection:C76([Job_Forms_Machines:43])>Records in selection:C76([Job_Forms_Machine_Tickets:61]))
					Est_LogIt("         Machine tickets appear to be missing"; 0)
					$ready:=False:C215
				End if 
				
				//3) issue tickets
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="issue")
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				CREATE SET:C116([Raw_Materials_Transactions:23]; "rm_issues")
				// Modified by: Mel Bohince (6/10/17) check against budget
				SET QUERY DESTINATION:C396(Into variable:K19:4; $countIssues)
				For ($comKey; 1; Size of array:C274($aComKeysBudgeted))
					USE SET:C118("rm_issues")
					$countIssues:=0
					$commodity:=Substring:C12($aComKeysBudgeted{$comKey}; 1; 2)
					
					Case of 
						: ($commodity="01") | ($commodity="20")
							// ******* Verified  - 4D PS - January  2019 ********
							
							QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24=1; *)
							QUERY SELECTION:C341([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]CommodityCode:24=20)
							
							
							// ******* Verified  - 4D PS - January 2019 (end) *********
							If ($countIssues=0)
								Est_LogIt("         "+$aComKeysBudgeted{$comKey}+" issue tickets appear to be missing"; 0)
								$ready:=False:C215
							End if 
							
						: (Position:C15($commodity; " 02 03 06 ")>1)  //auto issues
							//skip
							
						: (Position:C15($commodity; " 07 13 04 ")>1)  //// Modified by: Mel Bohince (4/24/18)  skip direct purchase dies, // Modified by: Mel Bohince (10/8/21) skip plates
							//skip
							
						: (Position:C15($commodity; " 09 ")>1)
							QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Commodity_Key:22="09@")  // Modified by: Mel Bohince (10/8/21) any cf is ok, esspecially butt rolls
							
							If ($countIssues=0)
								Est_LogIt("         "+$aComKeysBudgeted{$comKey}+" issue tickets appear to be missing"; 0)
								$ready:=False:C215
							End if 
							
						Else 
							
							QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Commodity_Key:22=$aComKeysBudgeted{$comKey})
							
							If ($countIssues=0)
								Est_LogIt("         "+$aComKeysBudgeted{$comKey}+" issue tickets appear to be missing"; 0)
								$ready:=False:C215
							End if 
							
					End case 
					
				End for 
				
				CLEAR SET:C117("rm_issues")
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				
				
				//4) glue items
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11=0)
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				If (Records in selection:C76([Job_Forms_Items:44])>0)
					Est_LogIt("         some items appear to have not been glued"; 0)
					$ready:=False:C215
				End if 
				
				//5) no cc or ex bins
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="CC@"; *)
				QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="EX@"; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]JobForm:19=aJFID{$i})
				If (Records in selection:C76([Finished_Goods_Locations:35])>0)
					Est_LogIt("         some items appear to still be in QA"; 0)
					$ready:=False:C215
				End if 
				
		End case 
		
		If (Not:C34($ready))
			aRpt{$i}:="!"
			vSel:=vSel-1
		End if 
	End if 
End for 
uThermoClose
Est_LogIt("show")
//