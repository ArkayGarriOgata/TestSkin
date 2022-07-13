// ----------------------------------------------------
// User name (OS): cs
// Date: 4/28/97
// ----------------------------------------------------
// Form Method: [Usage_Problem_Reports].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (User in group:C338(Current user:C182; "Administration"))
			OBJECT SET ENABLED:C1123(bDelete; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bDelete; False:C215)
		End if 
		
		sAction:="Modify"
		t10:=""
		
		Core_ObjectSetColor(->sAction; -(((16*5)+1)+(256*250)))
		Core_ObjectSetColor(->t10; -(15+(256*12)))
		If (Record number:C243([Usage_Problem_Reports:84])=-3)  //new upr
			//[UPRs]Id:=Seq444uence number([UPRs])+◊aOffSet{File(»[UPRs])}
			C_TEXT:C284($server)
			$server:="?"
			If (Not:C34(app_getNextID(Table:C252(->[Usage_Problem_Reports:84]); ->$server; ->[Usage_Problem_Reports:84]Id:1)))
				CANCEL:C270
			End if 
			
			[Usage_Problem_Reports:84]Created:2:=4D_Current_date
			[Usage_Problem_Reports:84]AMSversion:5:=<>sVERSION
			[Usage_Problem_Reports:84]Author:6:=<>zResp
			[Usage_Problem_Reports:84]Status:20:="New"
			iMode:=1
			
		Else 
			iMode:=2
		End if 
		sAction:=fGetMode(iMode)
		
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]AMSversion:5; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Created:2; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Submitted:3; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Returned:4; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Id:1; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
		UPRstatusChg
		
	: (Form event code:C388=On Validate:K2:3)
		[Usage_Problem_Reports:84]ModTimeStamp:25:=TSTimeStamp  //• 4/28/97 cs  new timestamping
End case 