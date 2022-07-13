If ([Job_Forms_Master_Schedule:67]ActualFirstShip:19=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]ActualFirstShip:19; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]ActualFirstShip:19; -(15+(256*12)))  //
End if 