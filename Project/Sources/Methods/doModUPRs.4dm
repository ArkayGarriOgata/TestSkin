//%attributes = {"publishedWeb":true}
//Procedure: doModUPRs()  051595  MLB
//modularize

SET WINDOW TITLE:C213("UPR's Updating")

bInclude:=0
bExclude:=0

Repeat 
	If (bInclude=0) & (bExclude=0)
		sAction:="Search"
		t10:="Enter 'search' for the SUBJECT and press Enter to use search editor."
		QUERY BY EXAMPLE:C292([Usage_Problem_Reports:84]; *)
		CREATE SET:C116([Usage_Problem_Reports:84]; "◊LastSelection84")
	Else 
		USE SET:C118("CurrentSet")
		OK:=1
		bInclude:=0
		bExclude:=0
	End if 
	
	If (OK=1)
		SET WINDOW TITLE:C213(fNameWindow(filePtr)+" Updating")
		Case of 
			: (Records in selection:C76([Usage_Problem_Reports:84])>1)
				ORDER BY:C49([Usage_Problem_Reports:84]; [Usage_Problem_Reports:84]PriorityNumber:19; >)
				MODIFY SELECTION:C204([Usage_Problem_Reports:84]; Multiple selection:K50:3; False:C215; *)
				
			: (Records in selection:C76([Usage_Problem_Reports:84])=1)
				MODIFY RECORD:C57([Usage_Problem_Reports:84]; *)
				
			Else 
				BEEP:C151
				QUERY:C277([Usage_Problem_Reports:84])
				CREATE SET:C116([Usage_Problem_Reports:84]; "◊LastSelection84")
				If (OK=1)
					SET WINDOW TITLE:C213(fNameWindow(filePtr)+" Updating")
					Case of 
						: (Records in selection:C76([Usage_Problem_Reports:84])>1)
							ORDER BY:C49([Usage_Problem_Reports:84])
							MODIFY SELECTION:C204([Usage_Problem_Reports:84]; *)
							
						: (Records in selection:C76([Usage_Problem_Reports:84])=1)
							MODIFY RECORD:C57([Usage_Problem_Reports:84]; *)
							
						Else 
							BEEP:C151
							ALERT:C41("No UPR records match your criterion.")
							OK:=1
					End case 
					
				End if 
		End case 
		OK:=1
	End if 
	
	REDUCE SELECTION:C351([Usage_Problem_Reports:84]; 0)
Until (OK=0)