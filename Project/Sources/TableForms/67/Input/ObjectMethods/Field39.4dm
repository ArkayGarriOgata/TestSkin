If ([Job_Forms_Master_Schedule:67]FirstReleaseDat:13=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]FirstReleaseDat:13; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]FirstReleaseDat:13; -(15+(256*12)))  //
End if 