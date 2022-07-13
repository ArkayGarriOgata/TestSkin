// _______
// Method: [Job_Forms_Master_Schedule].List.SearchPicker   ( ) ->
// Description
// live contains search on job,cust,line,salemen for open jobs
// ----------------------------------------------------
// Modified by: Mel Bohince (4/20/21) added Line and dateComplete=0
// Modified by: Mel Bohince (7/14/21) remove line and dateComplete=0

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284(vSearch)
		vSearch:=""
		C_BOOLEAN:C305(useFindWidget)
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "job cust line salesrep")
		
	: (Form event code:C388=On Data Change:K2:15)
		Case of 
			: (Not:C34(useFindWidget))
				useFindWidget:=True:C214  //toggle, coming from legacy [zz_control];"Select_dio"
				
			: (Length:C16(vSearch)>0)
				$criterian:="@"+vSearch+"@"
				QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$criterian; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  | ; [Job_Forms_Master_Schedule:67]Customer:2=$criterian; *)
				QUERY:C277([Job_Forms_Master_Schedule:67];  | ; [Job_Forms_Master_Schedule:67]Line:5=$criterian; *)  // Modified by: Mel Bohince (4/20/21) 
				QUERY:C277([Job_Forms_Master_Schedule:67];  | ; [Job_Forms_Master_Schedule:67]Salesman:1=$criterian)
				// Modified by: Mel Bohince (7/14/21) remove next lines so completed jobs can be found
				//QUERY([Job_Forms_Master_Schedule]; & ;[Job_Forms_Master_Schedule]DateComplete=!00-00-00!)  // Modified by: Mel Bohince (4/20/21) 
				
			Else 
				QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
		End case 
		
		ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4; >)
		
End case 
