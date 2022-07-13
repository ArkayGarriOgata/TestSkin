//%attributes = {"publishedWeb":true}
// Method: RM_BatchMake () -> 
// ----------------------------------------------------
// Description:
// roll up components into a new material was sbBuildRM
// Updates:
// • mel (11/18/03, 13:44:21) rewrite
// ----------------------------------------------------

C_TIME:C306($now)
C_TEXT:C284($Company)  // Added by: Mark Zinke (5/22/13)
C_REAL:C285(rReal1)

$now:=4d_Current_time
rReal1:=Num:C11(Request:C163("How many "+[Raw_Materials:21]IssueUOM:10+"'s do you wish to make?"))
If (ok=1) & (rReal1>0)
	C_LONGINT:C283($i; $numComps)
	C_DATE:C307(dDate)
	dDate:=4D_Current_date
	C_TEXT:C284($location)
	If (User in group:C338(Current user:C182; "Roanoke"))
		$location:="Roanoke"
	Else 
		$location:="Hauppauge"
	End if 
	
	//get the recipe
	READ WRITE:C146([Raw_Materials_Components:60])
	QUERY:C277([Raw_Materials_Components:60]; [Raw_Materials_Components:60]Parent_Raw_Matl:1=[Raw_Materials:21]Raw_Matl_Code:1)  //locate components for THis Ink
	ARRAY TEXT:C222($aCompRM; 0)
	ARRAY REAL:C219($aMixPct; 0)
	SELECTION TO ARRAY:C260([Raw_Materials_Components:60]Compnt_Raw_Matl:2; $aCompRM; [Raw_Materials_Components:60]MixPercent:8; $aMixPct)
	$numComps:=Size of array:C274($aCompRM)  //number of components
	ARRAY REAL:C219($aNeed; $numComps)
	
	//test for inventory
	$continue:=True:C214
	READ WRITE:C146([Raw_Materials_Locations:25])
	For ($i; 1; $numComps)  //*Check each component to see if we got some
		$aNeed{$i}:=Round:C94(rReal1*$aMixPct{$i}; 0)
		$inventory:=0
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$aCompRM{$i}; *)
		If (User in group:C338(Current user:C182; "Roanoke"))
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2#"Hauppauge")
		Else 
			QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2="Hauppauge")
		End if 
		If (Records in selection:C76([Raw_Materials_Locations:25])>0)
			$inventory:=Sum:C1([Raw_Materials_Locations:25]QtyOH:9)
			$inventory:=$inventory+Sum:C1([Raw_Materials_Locations:25]ConsignmentQty:26)
			If ($inventory<$aNeed{$i})
				$continue:=False:C215
				BEEP:C151
				ALERT:C41("Component "+$aCompRM{$i}+" doesn't have enough inventory.")
			End if 
			
		Else 
			$inventory:=0
			$continue:=False:C215
			BEEP:C151
			ALERT:C41("Component "+$aCompRM{$i}+" doesn't have any inventory.")
		End if 
	End for 
	
	If ($continue)  //relieve inventory in a fifo style
		$newPO:=PO_setPONumber+"01"
		$newPO:="A"+Substring:C12($newPO; 2)
		$totalCost:=0
		For ($i; 1; $numComps)
			$required:=$aNeed{$i}
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$aCompRM{$i}; *)
			If (User in group:C338(Current user:C182; "Roanoke"))
				QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2#"Hauppauge")
			Else 
				QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2="Hauppauge")
			End if 
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19; >)
				FIRST RECORD:C50([Raw_Materials_Locations:25])
				
			Else 
				
				ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19; >)
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			
			While (($required>0) & (Not:C34(End selection:C36([Raw_Materials_Locations:25]))))
				If (fLockNLoad(->[Raw_Materials_Locations:25]))
					Case of 
						: ([Raw_Materials_Locations:25]QtyOH:9>=$required)  //slam dunk
							$take:=$required
						Else 
							$take:=[Raw_Materials_Locations:25]QtyOH:9
					End case 
					
					$required:=$required-$take
					$totalCost:=$totalCost+($take*[Raw_Materials_Locations:25]ActCost:18)
					
					//make a transaction
					If ($take#0)
						[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9-$take
						[Raw_Materials_Locations:25]ModDate:21:=dDate
						[Raw_Materials_Locations:25]ModWho:22:=<>zResp
						SAVE RECORD:C53([Raw_Materials_Locations:25])
						RM_BatchTransaction($aCompRM{$i}; $newPO; $take)
					End if 
					
				Else 
					BEEP:C151
					ALERT:C41("You must manually relieve RM:"+$aCompRM{$i}+" Bin:"+[Raw_Materials_Locations:25]Location:2+" PO:"+[Raw_Materials_Locations:25]POItemKey:19+" of "+String:C10($take)+" units")
				End if 
				NEXT RECORD:C51([Raw_Materials_Locations:25])
			End while 
			
			FIRST RECORD:C50([Raw_Materials_Locations:25])
			While (($required>0) & (Not:C34(End selection:C36([Raw_Materials_Locations:25]))))
				If (fLockNLoad(->[Raw_Materials_Locations:25]))
					Case of 
						: ([Raw_Materials_Locations:25]ConsignmentQty:26>=$required)  //slam dunk
							$take:=$required
						Else 
							$take:=[Raw_Materials_Locations:25]ConsignmentQty:26
					End case 
					
					$required:=$required-$take
					$totalCost:=$totalCost+($take*[Raw_Materials_Locations:25]ActCost:18)
					If ($take#0)
						[Raw_Materials_Locations:25]ConsignmentQty:26:=[Raw_Materials_Locations:25]ConsignmentQty:26-$take
						[Raw_Materials_Locations:25]ModDate:21:=dDate
						[Raw_Materials_Locations:25]ModWho:22:=<>zResp
						SAVE RECORD:C53([Raw_Materials_Locations:25])
						//make a transaction
						RM_BatchTransaction($aCompRM{$i}; $newPO; $take)
					End if 
					
				Else 
					BEEP:C151
					ALERT:C41("You must manually relieve RM:"+$aCompRM{$i}+" Bin:"+[Raw_Materials_Locations:25]Location:2+" PO:"+[Raw_Materials_Locations:25]POItemKey:19+" of "+String:C10($take)+" units")
				End if 
				NEXT RECORD:C51([Raw_Materials_Locations:25])
			End while 
			
		End for 
		
		//stock the new item
		$unitCost:=Round:C94($totalCost/rReal1; 2)
		CREATE RECORD:C68([Raw_Materials_Locations:25])
		[Raw_Materials_Locations:25]Raw_Matl_Code:1:=[Raw_Materials:21]Raw_Matl_Code:1
		[Raw_Materials_Locations:25]Location:2:=$location
		[Raw_Materials_Locations:25]POItemKey:19:=$newPO  //"BATCH"  11/21/94
		[Raw_Materials_Locations:25]zCount:20:=1
		[Raw_Materials_Locations:25]Commodity_Key:12:=[Raw_Materials:21]Commodity_Key:2  //3/27/95  
		[Raw_Materials_Locations:25]CompanyID:27:=$Company  //•1/16/97 - upr 0235 Use Comapny for Previous bins/xfer 
		[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
		[Raw_Materials_Locations:25]ModWho:22:=<>zResp
		[Raw_Materials_Locations:25]QtyAvailable:13:=rReal1
		[Raw_Materials_Locations:25]ActCost:18:=$unitCost
		[Raw_Materials_Locations:25]QtyOH:9:=rReal1  //11/21/94
		SAVE RECORD:C53([Raw_Materials_Locations:25])
		
		[Raw_Materials:21]ActCost:45:=$unitCost
		[Raw_Materials:21]LastPurDate:44:=dDate
		[Raw_Materials:21]LastPurCost:43:=0  //[RM_BINS]ActCost`•041197  MLB  not purchased
		SAVE RECORD:C53([Raw_Materials:21])
		
		CREATE RECORD:C68([Raw_Materials_Transactions:23])  //the receipt
		[Raw_Materials_Transactions:23]CompanyID:20:=$Company  //•1/16/97 make sure that company is placed into xfer record
		[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials:21]Raw_Matl_Code:1
		[Raw_Materials_Transactions:23]Xfer_Type:2:="BATCH"  //10/28/94, 5/26/95 take off receiving rpt
		[Raw_Materials_Transactions:23]XferDate:3:=dDate
		[Raw_Materials_Transactions:23]XferTime:25:=$now
		[Raw_Materials_Transactions:23]zCount:16:=1
		[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
		[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
		[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials:21]Commodity_Key:2
		[Raw_Materials_Transactions:23]CommodityCode:24:=[Raw_Materials:21]CommodityCode:26
		[Raw_Materials_Transactions:23]POItemKey:4:=$newPO
		[Raw_Materials_Transactions:23]Qty:6:=rReal1
		[Raw_Materials_Transactions:23]UnitPrice:7:=$unitCost
		[Raw_Materials_Transactions:23]ActCost:9:=$unitCost
		
		[Raw_Materials_Transactions:23]POQty:8:=rReal1
		[Raw_Materials_Transactions:23]ActExtCost:10:=Round:C94($unitCost*rReal1; 2)
		[Raw_Materials_Transactions:23]Location:15:=$location
		[Raw_Materials_Transactions:23]viaLocation:11:="components"
		SAVE RECORD:C53([Raw_Materials_Transactions:23])
	End if 
	
	//restore selections
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1)
End if 