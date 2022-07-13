Case of 
	: ([Job_Forms:42]Status:6="Closed")
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(Dark brown:K11:11+(256*White:K11:1)); True:C214)
		
	: ([Job_Forms:42]Status:6="Complete")
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(Brown:K11:14+(256*White:K11:1)); True:C214)
		
	: ([Job_Forms:42]Status:6="Opened") | ([Job_Forms:42]Status:6="Planned")
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(Light blue:K11:8+(256*White:K11:1)); True:C214)
		
	: ([Job_Forms:42]Status:6="Revised")
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(Dark green:K11:10+(256*White:K11:1)); True:C214)
		
	: ([Job_Forms:42]Status:6="Released")
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(Green:K11:9+(256*White:K11:1)); True:C214)
		
	: ([Job_Forms:42]Status:6="Kill")
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(Purple:K11:5+(256*White:K11:1)); True:C214)
		
	: ([Job_Forms:42]Status:6="Hold")
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(Red:K11:4+(256*White:K11:1)); True:C214)
		
	: ([Job_Forms:42]Status:6="WIP")
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(Dark blue:K11:6+(256*White:K11:1)); True:C214)
		
	Else 
		Core_ObjectSetColor(->[Job_Forms:42]Status:6; -(Black:K11:16+(256*White:K11:1)); True:C214)
End case 