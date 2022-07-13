//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 09/12/12, 17:49:02
// ----------------------------------------------------
// Method: JML_CanThisJobBeMarkedComplete
// Description
// prevent setting the complete date if the items are still flat packed in Rama
// ----------------------------------------------------
//no more rama gluing // Modified by: Mel Bohince (6/30/15) 
//RAMA_PROJECT:=CUST_isRamaProject
C_BOOLEAN:C305($0)
If (True:C214)  //no more rama gluing // Modified by: Mel Bohince (6/30/15) 
	$0:=True:C214
	
Else 
	
	If ([Job_Forms_Master_Schedule:67]Customer:2=CUST_getName("00199"))  //look deeper
		//look for a gaylord style pallet label on any inventory for this job
		//when they are converted the pallet id is removed, see Rama_Inventory_Button
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19=[Job_Forms_Master_Schedule:67]JobForm:4; *)
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9>0; *)  //they stick around until deleted at the current time
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]skid_number:43="000@")  //gaylord designation
		If (Records in selection:C76([Finished_Goods_Locations:35])=0)  //none found
			$0:=True:C214
		Else   //an un-empty gaylord was found.
			$0:=False:C215
		End if 
		
	Else 
		$0:=True:C214
	End if 
	
End if   //true