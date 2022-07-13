//Layout Proc.: List()  051795  MLB
//set color based on status
If (Form event code:C388=On Display Detail:K2:22)
	Core_ObjectSetColor(->[Usage_Problem_Reports:84]Subject:12; -(15+(256*(0))))  // white  
	Case of 
			//: (true)
			//do nothing, kludge for fax printing
			
		: ([Usage_Problem_Reports:84]PriorityClass:18="A")
			Core_ObjectSetColor(->[Usage_Problem_Reports:84]PriorityClass:18; -1*(15+(256*((8*16)+4))))
			
		: ([Usage_Problem_Reports:84]PriorityClass:18="B")
			Core_ObjectSetColor(->[Usage_Problem_Reports:84]PriorityClass:18; -1*(15+(256*((6*15)+0))))
			
		: ([Usage_Problem_Reports:84]PriorityClass:18="C")
			Core_ObjectSetColor(->[Usage_Problem_Reports:84]PriorityClass:18; -1*(15+(256*((14*15)+1))))
			
		: (Position:C15("H"; [Usage_Problem_Reports:84]PriorityClass:18)#0)
			Core_ObjectSetColor(->[Usage_Problem_Reports:84]PriorityClass:18; -(15+(256*(14))))
			Core_ObjectSetColor(->[Usage_Problem_Reports:84]Subject:12; -(15+(256*(14))))
		Else 
			Core_ObjectSetColor(->[Usage_Problem_Reports:84]PriorityClass:18; -(15+(256*(0))))
	End case 
	
End if 
//