If ([Job_Forms_Master_Schedule:67]DateFinalArtApproved:12=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]DateFinalArtApproved:12; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]DateFinalArtApproved:12; -(15+(256*12)))  //
	[Job_Forms_Master_Schedule:67]DateClosingMet:23:=JML_getGateWayMet([Job_Forms_Master_Schedule:67]JobForm:4)
	
End if 