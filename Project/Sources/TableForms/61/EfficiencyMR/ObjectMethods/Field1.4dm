//(s) [machineticket]costcenterid
If ([Cost_Centers:27]ID:1#Self:C308->) & ([Cost_Centers:27]EffectivityDate:13<=[Job_Forms_Machine_Tickets:61]DateEntered:5)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=Self:C308->)
		ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
		
		While (Not:C34(End selection:C36([Cost_Centers:27])) & ([Cost_Centers:27]EffectivityDate:13>[Job_Forms_Machine_Tickets:61]DateEntered:5))
			NEXT RECORD:C51([Cost_Centers:27])
		End while 
		
		
	Else 
		
		C_DATE:C307($DateEntered)
		ARRAY DATE:C224($_DateEntered; 0)
		C_LONGINT:C283($position)
		ARRAY LONGINT:C221(Job_Forms_Machine_Tickets; 0)
		$DateEntered:=[Job_Forms_Machine_Tickets:61]DateEntered:5
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=Self:C308->)
		ORDER BY:C49([Cost_Centers:27]; [Cost_Centers:27]EffectivityDate:13; <)
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]; $_Job_Forms_Machine_Tickets; [Job_Forms_Machine_Tickets:61]DateEntered:5; $_DateEntered)
		$position:=Find in array:C230($_DateEntered; $DateEntered)
		
		If ($position>0)
			GOTO SELECTED RECORD:C245([Job_Forms_Machine_Tickets:61]; $_Job_Forms_Machine_Tickets{$position})
		End if 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	ONE RECORD SELECT:C189([Cost_Centers:27])
End if 
//