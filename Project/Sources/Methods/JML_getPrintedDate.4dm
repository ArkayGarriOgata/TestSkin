//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/25/07, 14:06:46
// ----------------------------------------------------
// Method: JML_getPrintedDate([Finished_Goods_Locations]JobForm)  --> 
// Description
// return the printed date of a job
// ----------------------------------------------------

C_DATE:C307($0)
C_TEXT:C284($1)

SET QUERY LIMIT:C395(1)
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=(Substring:C12($1; 1; 8)))
If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	$0:=[Job_Forms_Master_Schedule:67]Printed:32
Else 
	$0:=!00-00-00!
End if 
SET QUERY LIMIT:C395(0)