//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: afterFG
// ----------------------------------------------------

If ([Finished_Goods:26]Status:14#"Final")  //•042999  MLB  UPR 2024
	If ([Finished_Goods:26]Status:14="")
		[Finished_Goods:26]Status:14:="New"
		//CONFIRM("Protect your entries by setting Status to 'Final'?";"Final";"Cancel")
	Else 
		//CONFIRM("Protect your entries by setting Status to 'Final'?";"Make Final";"Leave as "+[Finished_Goods]Status)
	End if 
	//If (OK=1)
	//[Finished_Goods]Status:="Final"
	//End if 
End if 

If (Old:C35([Finished_Goods:26]Line_Brand:15)#[Finished_Goods:26]Line_Brand:15)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=[Finished_Goods:26]CustID:2)
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15)
	End if 
	
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerLine:42:=[Finished_Goods:26]Line_Brand:15)
	End if 
End if 

If (sFGAction="NEW")
	//API_FGTrans ("NEW")
Else 
	If ([Finished_Goods:26]ModFlag:31)
		//API_FGTrans ("MOD")
	End if 
End if 

If ([Finished_Goods:26]ClassOrType:28#Old:C35([Finished_Goods:26]ClassOrType:28))
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Classification:29:=[Finished_Goods:26]ClassOrType:28)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
		
		UNLOAD RECORD:C212([Customers_Order_Lines:41])
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		
		
	Else 
		
		
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		
		
	End if   // END 4D Professional Services : January 2019 
End if 
//
If ([Finished_Goods:26]DateLaunchApproved:85#Old:C35([Finished_Goods:26]DateLaunchApproved:85)) | ([Finished_Goods:26]DateLaunchSubmitted:93#Old:C35([Finished_Goods:26]DateLaunchSubmitted:93)) | ([Finished_Goods:26]DateLaunchReceived:84#Old:C35([Finished_Goods:26]DateLaunchReceived:84)) | ([Finished_Goods:26]OriginalOrRepeat:71#Old:C35([Finished_Goods:26]OriginalOrRepeat:71))
	//would like the server side cache to update, need to wait for loop interval
	FG_LaunchItemInit("die!")
End if 