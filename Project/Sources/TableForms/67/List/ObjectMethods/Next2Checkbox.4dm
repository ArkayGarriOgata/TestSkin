// Method: [Job_Forms_Master_Schedule].Next2Checkbox
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/24/15, 16:00:03
// ----------------------------------------------------
// Description
// 

// Filters the listing to show only jobs for the next
//  two weeks that haven't been released.
// ----------------------------------------------------
// Modified by: Mel Bohince (11/25/15) include the past closing dates also


If (Self:C308->=1)
	C_DATE:C307($dTwoWeeks)
	$dTwoWeeks:=Add to date:C393(4D_Current_date; 0; 0; 14)
	
	QUERY BY FORMULA:C48([Job_Forms_Master_Schedule:67]; \
		(\
		([Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!) & \
		([Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!) & \
		([Job_Forms_Master_Schedule:67]GateWayDeadLine:42>!00-00-00!) & \
		([Job_Forms_Master_Schedule:67]GateWayDeadLine:42<=$dTwoWeeks))\
		 & \
		([Job_Forms:42]PlnnerReleased:59=!00-00-00!)\
		)
	
	
	ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]GateWayDeadLine:42; >)
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "◊LastSelection"+String:C10(fileNum))
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "CurrentSet")
	SET WINDOW TITLE:C213(fNameWindow(->[Job_Forms_Master_Schedule:67]))
	
	
Else 
	Case of 
		: (b1=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]MAD:21
		: (b2=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]JobForm:4
		: (b3=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]Line:5
		: (b4=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]PressDate:25
		: (b5=1)
			$orderBy:=->[Job_Forms_Master_Schedule:67]GateWayDeadLine:42
		Else 
			$orderBy:=->[Job_Forms_Master_Schedule:67]JobForm:4
	End case 
	JML_setView(1; $orderBy)
End if 
