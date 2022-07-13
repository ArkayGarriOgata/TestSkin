//%attributes = {}
//rRptJobMAD

//upr 1330

//•072695  MLB   allow search by job

C_TEXT:C284($1)

Case of 
	: (Count parameters:C259=2)  //via jobbag
		
		$rec:=Record number:C243([Job_Forms:42])
		t2:="NEED TO MANUFACTURE BY RELEASE DATE"
		t3:=[Job_Forms:42]JobFormID:5
		CUT NAMED SELECTION:C334([Job_Forms:42]; "holdJF")
		GOTO RECORD:C242([Job_Forms:42]; $rec)
		
	: (Count parameters:C259=0)
		dDateBegin:=4D_Current_date
		dDateEnd:=4D_Current_date+7
		DIALOG:C40([zz_control:1]; "DateRange2")
		If (ok=1)
			
			If (bSearch=0)
				SET WINDOW TITLE:C213("Jobs by M.A.D. from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1))
				ERASE WINDOW:C160
				
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]NeedDate:1<=dDateEnd; *)
				QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]NeedDate:1>=dDateBegin; *)
				QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Completed:18=!00-00-00!)
				MESSAGES OFF:C175
				ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; >)
				t2:="NEED TO MANUFACTURE BY MUTUALLY AGREED DATE"
				t3:="from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1)
				
			Else 
				SET WINDOW TITLE:C213("Jobs by M.A.D. from (Custom Search)")
				ERASE WINDOW:C160
				
				QUERY:C277([Job_Forms:42])
				MESSAGES OFF:C175
				ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; >)
				t2:="NEED TO MANUFACTURE BY MUTUALLY AGREED DATE"
				t3:="(Custom Search)"
			End if 
		Else 
			uClearSelection(->[Job_Forms:42])
		End if 
		
	Else   //•072695  MLB 
		
		MESSAGES OFF:C175
		C_TEXT:C284($form)
		C_TEXT:C284($soFar)
		$soFar:=""
		ARRAY TEXT:C222($job; 0)
		$i:=0
		
		Repeat 
			$form:=Request:C163("JobForm#:"+$soFar; ""; "More"; "Print")  //•070299  mlb don't use uRequest
			
			$soFar:=$soFar+","+$form
			If (ok=1) & ($form#"")
				$i:=$i+1
				ARRAY TEXT:C222($job; $i)
				$job{$i}:=$form
				$form:=""
			Else 
				ok:=0
			End if 
		Until (ok=0)
		
		If (Size of array:C274($job)>0)
			SET WINDOW TITLE:C213("Need to Mfg by forms")
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				CREATE EMPTY SET:C140([Job_Forms:42]; "jobs")
				For ($i; 1; Size of array:C274($job))
					QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$job{$i})
					CREATE SET:C116([Job_Forms:42]; "add")  //•070299  mlb change to multi record capable
					
					UNION:C120("jobs"; "add"; "jobs")
					CLEAR SET:C117("add")
				End for 
				USE SET:C118("jobs")
				CLEAR SET:C117("jobs")
				
				
			Else 
				
				QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; $job)
				
				
			End if   // END 4D Professional Services : January 2019 
			
			ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; >)
			t2:="NEED TO MANUFACTURE BY JOB FORM NUMBER"
			t3:=$soFar
		Else 
			uClearSelection(->[Job_Forms:42])
		End if 
		MESSAGES ON:C181
End case 


If (Records in selection:C76([Job_Forms:42])>0)
	//BREAK LEVEL(1)
	
	//ACCUMULATE([OrderLines]Qty_Open;r2;r3)
	
	
	util_PAGE_SETUP(->[Job_Forms:42]; "JobMAD")
	//PRINT SETTINGS
	
	PDF_setUp("jobMAD"+[Job_Forms:42]JobFormID:5+".pdf")
	FORM SET OUTPUT:C54([Job_Forms:42]; "JobMAD")  //([ReleaseSchedule];"Need2MFG")
	
	
	t2b:="Sorted by Job Form"
	r1:=0  //•070299  mlb job total rev
	
	r2:=0  //•070299  mlb rpt total rev
	
	r4:=0
	xText:=""
	ACCUMULATE:C303(r4)
	BREAK LEVEL:C302(1)
	PRINT SELECTION:C60([Job_Forms:42]; *)
	MESSAGES ON:C181
	FORM SET OUTPUT:C54([Job_Forms:42]; "List")
	If (Count parameters:C259=2)  //via jobbag    
		
		USE NAMED SELECTION:C332("holdJF")
	End if 
Else 
	BEEP:C151
	ALERT:C41("No Jobs met that criterion.")
End if 
//
