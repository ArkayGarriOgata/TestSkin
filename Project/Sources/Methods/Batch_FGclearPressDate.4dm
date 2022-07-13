//%attributes = {"publishedWeb":true}
//PM: Batch_FGclearPressDate() -> 
//@author mlb - 2/28/03  10:36
//clear defunct press dates from f/g records.

READ ONLY:C145([Job_Forms_Master_Schedule:67])

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)  //not yet printed
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)  //but has a press date set

If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25; >)  //what is the earliest press date?
	
	READ WRITE:C146([Finished_Goods:26])
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]PressDate:64#!00-00-00!; *)  //are there any obsolete press dates?
	
	QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]PressDate:64<[Job_Forms_Master_Schedule:67]PressDate:25)
	APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]PressDate:64:=!00-00-00!)  //if so, clear them
	
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
End if 