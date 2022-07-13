// ----------------------------------------------------
// Form Method: [Jobs].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		READ ONLY:C145([Customers:16])
		READ ONLY:C145([Finished_Goods:26])
		READ ONLY:C145([Job_Forms_Master_Schedule:67])
		
		If (Not:C34(User_AllowedCustomer([Jobs:15]CustID:2; ""; "via JOB:"+String:C10([Jobs:15]JobNo:1))))
			bDone:=1
			CANCEL:C270
		End if 
		
		<>jobform:=String:C10([Jobs:15]JobNo:1)
		
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		SetObjectProperties(""; ->[Jobs:15]Status:4; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		Case of 
			: (iMode=1)
				[Jobs:15]ModDate:8:=4D_Current_date
				[Jobs:15]ModWho:9:=<>zResp
				
			: (iMode=2)
				//OBJECT SET ENABLED(bDelete;True)
				
			: (iMode=3)
				OBJECT SET ENABLED:C1123(bValidate; False:C215)
				
		End case 
		
		
		If (Read only state:C362([Jobs:15]))
			READ ONLY:C145([Job_Forms:42])
		Else 
			READ WRITE:C146([Job_Forms:42])
		End if 
		RELATE MANY:C262([Jobs:15]JobNo:1)
		
		ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]FormNumber:3; >)
		<>jobform:=[Job_Forms:42]JobFormID:5
		UNLOAD RECORD:C212([Job_Forms:42])
		
		If (iMode=2) & (Length:C16(<>jobform)=0) & ([Jobs:15]Status:4="Opened")
			SetObjectProperties(""; ->[Jobs:15]Status:4; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		End if 
		
		If ([Customers:16]ID:1#[Jobs:15]CustID:2)
			
			QUERY:C277([Customers:16]; [Customers:16]ID:1=[Jobs:15]CustID:2)
		End if 
		
		If (Position:C15("Hold"; [Jobs:15]Status:4)#0)
			Core_ObjectSetColor(->[Jobs:15]Status:4; -(3+(256*0)))
		Else 
			Core_ObjectSetColor(->[Jobs:15]Status:4; -(15+(256*0)))
		End if 
		
		If ([Customers_Projects:9]id:1#[Jobs:15]ProjectNumber:18)
			READ ONLY:C145([Customers_Projects:9])
			QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Jobs:15]ProjectNumber:18)
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
	: (Form event code:C388=On Unload:K2:2)
		//◊jobform:=""
		
	: (Form event code:C388=On Validate:K2:3)
		//◊jobform:=""
		uUpdateTrail(->[Jobs:15]ModDate:8; ->[Jobs:15]ModWho:9; ->[Jobs:15]zCount:10)
End case 