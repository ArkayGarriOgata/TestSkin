//%attributes = {"publishedWeb":true}
//PM: Job_getMaterialIssues() -> 
//@author mlb - 1/31/03  10:34

READ ONLY:C145([Jobs:15])
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Raw_Materials_Transactions:23])

QUERY:C277([Jobs:15])
RELATE MANY SELECTION:C340([Job_Forms:42]JobNo:2)

CONFIRM:C162("Query the forms too?"; "No"; "Query")
If (OK=0)
	QUERY SELECTION:C341([Job_Forms:42])
End if 

If (Records in selection:C76([Job_Forms:42])>0)
	RELATE MANY SELECTION:C340([Raw_Materials_Transactions:23]JobForm:12)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
		CONFIRM:C162("Which materials?"; "Board"; "Query")
		If (OK=1)
			QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24=1)
		Else 
			QUERY SELECTION:C341([Raw_Materials_Transactions:23])
		End if 
		
	Else 
		
		QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
		CONFIRM:C162("Which materials?"; "Board"; "Query")
		If (OK=1)
			QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24=1)
		Else 
			QUERY SELECTION:C341([Raw_Materials_Transactions:23])
		End if 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	QR REPORT:C197([Raw_Materials_Transactions:23]; "x")
Else 
	BEEP:C151
	ALERT:C41("No Jobforms found.")
End if 