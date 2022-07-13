If (Position:C15(Substring:C12([Job_Forms:42]JobType:33; 1; 1); " 2 5 6 ")>0)
	[Job_Forms:42]JobTypeDescription:88:=Request:C163("Enter a description"; [Job_Forms:42]JobTypeDescription:88; "Ok"; "Help")
End if 
