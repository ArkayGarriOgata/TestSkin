//%attributes = {"publishedWeb":true}
//(S)sAskMeCPN("cpn";{refreash flag})  mod 2.22.94
//mod 6/8/94
//upr 1326 2/14/95
//2/15/95
//•060195  MLB  UPR 187 don't show closed orders or releases of closed orders
//•060995  MLB  UPR 1642 alway show unshiped releases
//•020896  MLB  try to streamline alittle
//•031297  mBohince  change button text if notes are available
// SetObjectProperties, Mark Zinke (5/15/13)

ARRAY TEXT:C222(aAskMeMulti; 0)
C_TEXT:C284($1)
C_LONGINT:C283($2)  //refreash flag`•020896  MLB 

MESSAGES OFF:C175

If (Count parameters:C259=2)  //*Refresh from a new or edit btn (2params)
	USE SET:C118("oneLoaded")  //("displayOrders")  `*   use sets
	USE SET:C118("twoLoaded")  //("displayRels")
	USE SET:C118("threeLoaded")
	USE SET:C118("fourLoaded")
	
	ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13; >)  //switch to fg_key
	If (True:C214)  //(Current user#"Cathy Falk")
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)  //switch to fg_key
	Else 
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >)  //requested by cathy
	End if 
	ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33; >; [Finished_Goods_Locations:35]Location:2; >)  //
	ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >)  //switch to fg_key
	
	GOTO OBJECT:C206(sCPN)
	HIGHLIGHT TEXT:C210(sCPN; 20; 20)
	
Else   //*ELSE Init this CPNless than two parameters 
	sAlias:=""
	sBrand:=""
	sDesc:=""
	sCustName:=""
	sOutlineNum:=""
	iBillAndHoldQty:=0
	iLiability:=0
	totalDemand:=0
	totalSupply:=0
	totalStatus:=0
	totalStatOR:=0
	i3:=0
	iitotal1:=0
	iitotal2:=0
	iitotal3:=0
	iitotal4:=0
	
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)  //•020896  MLB  
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	//*Make sure the sets are init'd in case of a no find
	CREATE EMPTY SET:C140([Customers_Order_Lines:41]; "displayOrders")  //•021596  mBohince  
	CREATE EMPTY SET:C140([Customers_Order_Lines:41]; "oneLoaded")
	CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "displayRels")
	CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "twoLoaded")
	CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "threeLoaded")
	CREATE EMPTY SET:C140([Job_Forms_Items:44]; "fourLoaded")
	
	If (Count parameters:C259=1)
		If ($1#"")  //= ◊AskMeFG
			sCPN:=$1
		End if 
	End if 
	
	If (Length:C16(sCPN)>0) & (Length:C16(sCPN)<21)
		SET WINDOW TITLE:C213(sCPN+" Supply & Demand")
		sAskMeButtons(1)
		
		If (Length:C16(sCustID)=5)  //*    Load the FG record
			$numRecs:=qryFinishedGood(sCustID; sCPN)
			If ($numRecs=0)
				sCustID:=""
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=sCPN)
				$numRecs:=Records in selection:C76([Finished_Goods:26])
			End if 
		Else 
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=sCPN)
			$numRecs:=Records in selection:C76([Finished_Goods:26])
		End if 
		
		Case of 
			: ($numRecs>1)  //*       Warn if more than one
				BEEP:C151
				sCustName:=String:C10($numRecs)+" found, customers share this CPN."
				sCPN:=[Finished_Goods:26]ProductCode:1
				C_TEXT:C284(sAlias)
				sAlias:=""
				sCustID:=""
				sBrand:=[Finished_Goods:26]Line_Brand:15
				sDesc:=[Finished_Goods:26]CartonDesc:3
				sOutlineNum:=[Finished_Goods:26]OutLine_Num:4
				iBillAndHoldQty:=[Finished_Goods:26]Bill_and_Hold_Qty:108
				iLiability:=[Finished_Goods:26]InventoryLiability:111
				SELECTION TO ARRAY:C260([Finished_Goods:26]FG_KEY:47; aAskMeMulti)
				SORT ARRAY:C229(aAskMeMulti; >)
				
				If ([Finished_Goods:26]ArtWorkNotes:60#"")  //•031297  mBohince  
					SetObjectProperties(""; ->bFgNotes; True:C214; "View Notes")
				Else 
					SetObjectProperties(""; ->bFgNotes; True:C214; "New Note")
				End if 
				If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
					
					UNLOAD RECORD:C212([Finished_Goods:26])
					
				Else 
					// see line 100
					
					
				End if   // END 4D Professional Services : January 2019 
				
			: ($numRecs=0)  //*       Warn if none
				BEEP:C151
				If (sCustID#"")
					ALERT:C41(sCPN+" is not a product of customer "+sCustId)
				Else 
					ALERT:C41(sCPN+" was not found.")
				End if 
				
			Else   //*       ELSE Grap some info and unload
				sCPN:=[Finished_Goods:26]ProductCode:1
				sAlias:=[Finished_Goods:26]AliasCPN:106
				sCustID:=[Finished_Goods:26]CustID:2
				sBrand:=[Finished_Goods:26]Line_Brand:15
				sDesc:=[Finished_Goods:26]CartonDesc:3
				sOutlineNum:=[Finished_Goods:26]OutLine_Num:4
				iBillAndHoldQty:=[Finished_Goods:26]Bill_and_Hold_Qty:108
				iLiability:=[Finished_Goods:26]InventoryLiability:111
				If ([Finished_Goods:26]ArtWorkNotes:60#"")  //•031297  mBohince  
					SetObjectProperties(""; ->bFgNotes; True:C214; "View Notes")
				Else 
					SetObjectProperties(""; ->bFgNotes; True:C214; "New Note")
				End if 
				If ([Customers:16]ID:1#sCustID)
					QUERY:C277([Customers:16]; [Customers:16]ID:1=sCustID)
				End if 
				sCustName:=[Customers:16]Name:2
				UNLOAD RECORD:C212([Customers:16])
				UNLOAD RECORD:C212([Finished_Goods:26])
				
		End case   //search ressults
		
		If ($numRecs#0)  //*Valid CPN found, so load the quads
			$fgKey:=sCustID+":"+sCPN
			$hit:=Find in array:C230(<>aAskMeHistory; $fgKey)
			AskMeHistory("Save"; $fgKey)  // Added by: Mark Zinke (12/12/12)
			If ($hit=-1)
				INSERT IN ARRAY:C227(<>aAskMeHistory; 1; 1)
				<>aAskMeHistory{1}:=$fgKey
			End if 
			
			If (bCache=0)  //*    either without cached sets
				If (sCustID="")
					sAskMeLoadwo(sCPN)
					//sAskMeLoadTest (sCPN)
				Else   //include custid in search
					sAskMeLoadwith(sCPN; sCustID)
				End if   //customer id supplied
				
			Else   //*    or with cached sets
				$error:=sAskMeLoadsets(sCPN)
				If ($error#"")
					$temp:=sDesc
					sDesc:=$error
					sAskMeLoadwo(sCPN)
					sDesc:=$temp
				End if 
			End if   //use cache   
			
			//*All the quadrants are loaded        
			sAskMeTotals  //*    Get the totals
			//*    Sort the quads
			ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13; >)  //switch to fg_key
			If (True:C214)  // (Current user#"Cathy Falk")
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)  //switch to fg_key
			Else 
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3; >; [Customers_ReleaseSchedules:46]Sched_Date:5; >)  //requested by cathy
			End if 
			
			ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33; >; [Finished_Goods_Locations:35]Location:2; >)  //switch to fg_key
			//ORDER BY([Job_Forms_Items];[Job_Forms_Items]PlnnrDate;>)  // Modified by: Mel Bohince (5/25/18) 
			ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >; [Job_Forms_Items:44]SubFormNumber:32; >)  // Modified by: Mel Bohince (6/5/18) 
			GOTO OBJECT:C206(sCPN)
			HIGHLIGHT TEXT:C210(sCPN; 20; 20)
			
		Else   //no fg records found
			SetObjectProperties(""; ->bFgNotes; True:C214; "")
			GOTO OBJECT:C206(sCPN)
		End if   //no fg recs
		
	Else   //no cpn entered
		SET WINDOW TITLE:C213("Finished Goods"+" Supply & Demand")
		SetObjectProperties(""; ->bFgNotes; True:C214; "")
		sAskMeButtons(0)
		BEEP:C151
		sDesc:="Product code must be entered. (1 to 20 characters)"
		GOTO OBJECT:C206(sCPN)
	End if 
End if 