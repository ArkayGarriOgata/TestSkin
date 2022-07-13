//%attributes = {"publishedWeb":true}
//PM:  sChkVendorId  081702  mlb
//make sure items have vendor id

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([Purchase_Orders_Items:12]; "chkingvendorid")
	
Else 
	
	ARRAY LONGINT:C221($_chkingvendorid; 0)
	LONGINT ARRAY FROM SELECTION:C647([Purchase_Orders_Items:12]; $_chkingvendorid)
	
End if   // END 4D Professional Services : January 2019 

QUERY SELECTION:C341([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]VendorID:39="")
If (Records in selection:C76([Purchase_Orders_Items:12])>0)
	SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]VendorID:39; $aVendid)
	For ($i; 1; Size of array:C274($aVendid))
		$aVendid{$i}:=[Purchase_Orders:11]VendorID:2
	End for 
	ARRAY TO SELECTION:C261($aVendid; [Purchase_Orders_Items:12]VendorID:39)
End if 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	USE NAMED SELECTION:C332("chkingvendorid")
	CLEAR NAMED SELECTION:C333("chkingvendorid")
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Purchase_Orders_Items:12]; $_chkingvendorid)
	
End if   // END 4D Professional Services : January 2019 

