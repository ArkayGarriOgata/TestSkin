//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/10/08, 10:50:05
// ----------------------------------------------------
// Method: wms_api_SendJobitsInInventory
// Description
// 
//
// Parameters
// ----------------------------------------------------
ALL RECORDS:C47([Finished_Goods_Locations:35])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aJobits)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	
	READ WRITE:C146([Job_Forms_Items:44])
	QUERY WITH ARRAY:C644([Job_Forms_Items:44]Jobit:4; $aJobits)
	
	
Else 
	
	READ WRITE:C146([Job_Forms_Items:44])
	RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Job_Forms_Items:44])
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	
	
End if   // END 4D Professional Services : January 2019 

wms_api_SendJobits

