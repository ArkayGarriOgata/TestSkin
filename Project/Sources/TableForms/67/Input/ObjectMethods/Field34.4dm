//OM: GateWayDeadLine() -> 
//@author mlb - 5/3/01  16:09

If ([Job_Forms_Master_Schedule:67]GateWayDeadLine:42=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]GateWayDeadLine:42; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]GateWayDeadLine:42; -(15+(256*12)))  //
End if 