//OM: JobForm() -> 
//@author mlb - 6/26/01  11:37
If (Length:C16([Raw_Materials_Allocations:58]JobForm:3)=8)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Raw_Materials_Allocations:58]JobForm:3)
	If (Records in selection:C76([Job_Forms:42])=1)
		RELATE ONE:C42([Job_Forms:42]JobNo:2)
		[Raw_Materials_Allocations:58]CustID:2:=[Jobs:15]CustID:2
		CONFIRM:C162("Which material?"; "Board"; "Corrugate")
		If (ok=1)
			$commodity:="01"  //Substring([RM_Allocations]commdityKey;1;2)
		Else 
			$commodity:="06"
		End if 
		
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=($commodity+"@"); *)
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]JobForm:1=[Raw_Materials_Allocations:58]JobForm:3)
		
		If (Records in selection:C76([Job_Forms_Materials:55])>0)  //then get some detials
			Case of 
				: ($commodity="01")
					If (Length:C16([Job_Forms_Materials:55]Raw_Matl_Code:7)>0)  //get the quantity
						[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=[Job_Forms_Materials:55]Raw_Matl_Code:7
						[Raw_Materials_Allocations:58]commdityKey:13:=[Job_Forms_Materials:55]Commodity_Key:12
						$qty:=0  //•082402  mlb  
						$uom:=[Job_Forms_Materials:55]UOM:5
						Case of 
							: ($uom="MSF")
								$qty:=1000*[Job_Forms_Materials:55]Planned_Qty:6/([Job_Forms:42]Width:23/12)
								$uom:="LF"
							: ($uom="LF")
								$qty:=[Job_Forms_Materials:55]Planned_Qty:6
							: ($uom="SHT")
								$qty:=[Job_Forms_Materials:55]Planned_Qty:6
							Else 
								$qty:=[Job_Forms:42]EstGrossSheets:27*([Job_Forms:42]Lenth:24/12)
								$uom:="LF"
						End case 
						[Raw_Materials_Allocations:58]Qty_Allocated:4:=$qty
						[Raw_Materials_Allocations:58]UOM:11:=$uom
						//get the date
						QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Raw_Materials_Allocations:58]JobForm:3)
						If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
							[Raw_Materials_Allocations:58]Date_Allocated:5:=[Job_Forms_Master_Schedule:67]PressDate:25
						End if 
						If ([Raw_Materials_Allocations:58]Date_Allocated:5=!00-00-00!)
							[Raw_Materials_Allocations:58]Date_Allocated:5:=[Job_Forms:42]NeedDate:1
						End if 
						
					End if 
					
				: ($commodity="06")
					QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms_Materials:55]JobForm:1)
					If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0) & ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
						$dateNeeded:=[Job_Forms_Master_Schedule:67]PressDate:25
					Else 
						$dateNeeded:=<>MAGIC_DATE
					End if 
					RM_AllocateCorrugate([Job_Forms_Materials:55]JobForm:1; $dateNeeded)
					
			End case 
			
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41([Raw_Materials_Allocations:58]JobForm:3+" was not found.")
		[Raw_Materials_Allocations:58]JobForm:3:=""
	End if 
	
Else 
	BEEP:C151
	ALERT:C41([Raw_Materials_Allocations:58]JobForm:3+" needs to be in the form 13245.12")
	[Raw_Materials_Allocations:58]JobForm:3:=""
End if 