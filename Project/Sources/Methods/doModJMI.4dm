//%attributes = {"publishedWeb":true}
//Procedure: doModJMI()  051595  MLB
//modularize

Repeat 
	sAction:="Search"
	t10:="Enter 'search' for JobForm and press Enter to use Search Editor."
	
	QUERY BY EXAMPLE:C292([Job_Forms_Items:44]; *)
	If (OK=1)
		Case of 
			: (Records in selection:C76([Job_Forms_Items:44])>1)
				CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
				ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1; >; [Job_Forms_Items:44]ItemNumber:7; >)
				MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; False:C215; *)
				
			: (Records in selection:C76([Job_Forms_Items:44])=1)
				CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
				MODIFY RECORD:C57([Job_Forms_Items:44]; *)
				
			Else 
				BEEP:C151
				QUERY:C277([Job_Forms_Items:44])
				If (OK=1)
					Case of 
						: (Records in selection:C76([Job_Forms_Items:44])>1)
							ORDER BY:C49([Job_Forms_Items:44])
							CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
							MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; False:C215; *)
							
						: (Records in selection:C76([Job_Forms_Items:44])=1)
							CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
							MODIFY SELECTION:C204(filePtr->; Multiple selection:K50:3; False:C215; *)
							
						Else 
							BEEP:C151
							ALERT:C41("No Job Makes Item records match your criterion.")
							OK:=1
					End case 
					
				End if 
		End case 
		OK:=1
	End if 
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	
Until (OK=0)