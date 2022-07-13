// ----------------------------------------------------
// Form Method: [To_Do_Tasks].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([To_Do_Tasks:100]))
			[To_Do_Tasks:100]AssignedTo:9:=Current user:C182
			SetObjectProperties(""; ->[To_Do_Tasks:100]Jobform:1; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			[To_Do_Tasks:100]Jobform:1:=<>jobform
			[To_Do_Tasks:100]PjtNumber:5:=Pjt_getReferId
			If (Length:C16([To_Do_Tasks:100]Jobform:1)>=5)
				READ ONLY:C145([Jobs:15])
				QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12([To_Do_Tasks:100]Jobform:1; 1; 5))))
				[To_Do_Tasks:100]PjtNumber:5:=[Jobs:15]ProjectNumber:18
				REDUCE SELECTION:C351([Jobs:15]; 0)
			End if 
			
			If (Length:C16(<>jobform)>5) & ([To_Do_Tasks:100]DateDue:10=!00-00-00!)
				READ ONLY:C145([Job_Forms_Master_Schedule:67])
				QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=<>jobform)
				If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
					[To_Do_Tasks:100]DateDue:10:=[Job_Forms_Master_Schedule:67]GateWayDeadLine:42
					REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
				End if 
			End if 
			
			GOTO OBJECT:C206([To_Do_Tasks:100]Jobform:1)
			[To_Do_Tasks:100]CreatedBy:8:=<>zResp
			
		Else 
			SetObjectProperties(""; ->[To_Do_Tasks:100]Jobform:1; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			SetObjectProperties(""; ->[To_Do_Tasks:100]PjtNumber:5; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			If ([To_Do_Tasks:100]Category:2="Prep Work") & (Not:C34([To_Do_Tasks:100]Done:4))
				OBJECT SET ENABLED:C1123(bMod; True:C214)
			Else 
				OBJECT SET ENABLED:C1123(bMod; False:C215)
			End if 
			
			If (Length:C16([To_Do_Tasks:100]Jobform:1)>=8)
				OBJECT SET ENABLED:C1123(bRev; True:C214)
			Else 
				OBJECT SET ENABLED:C1123(bRev; False:C215)
			End if 
		End if 
		
End case 