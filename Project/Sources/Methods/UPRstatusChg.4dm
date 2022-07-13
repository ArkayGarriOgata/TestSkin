//%attributes = {"publishedWeb":true}
//Procedure: UPRstatusChg()  051795  MLB
//control input layout based on status
//• 4/17/97 cs make layout entry change when status is set to 
//  returned by a designer/admin
//• 5/22/97 cs made it so that designers have complete editing freedom

Case of 
	: (User in group:C338(Current user:C182; "Design"))  //• 5/22/97 cs 
		uSetEntStatus(->[Usage_Problem_Reports:84]; True:C214)
	: ([Usage_Problem_Reports:84]Status:20="New")
		//OBJECT SET ENABLED(bSend;False)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Description:13; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Example:14; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Subject:12; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Created:2; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Author:6; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Subsystem:10; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Module:11; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]NewDesign:15; True:C214; ""; False:C215)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]UsageInfo:16; True:C214; ""; False:C215)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Changes:17; True:C214; ""; False:C215)
		
	: ([Usage_Problem_Reports:84]Status:20="Reviewed")
		//OBJECT SET ENABLED(bSend;True)
		uSetEntStatus(->[Usage_Problem_Reports:84]; False:C215)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Status:20; True:C214; ""; True:C214)
		
	: ([Usage_Problem_Reports:84]Status:20="Sent")
		//OBJECT SET ENABLED(bSend;False)
		uSetEntStatus(->[Usage_Problem_Reports:84]; False:C215)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Status:20; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]PriorityClass:18; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]PriorityNumber:19; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Subsystem:10; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Module:11; True:C214; ""; True:C214)
		
	: ([Usage_Problem_Reports:84]Status:20="Prioritized")
		//OBJECT SET ENABLED(bSend;True)
		uSetEntStatus(->[Usage_Problem_Reports:84]; False:C215)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Status:20; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]NewDesign:15; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]UsageInfo:16; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Changes:17; True:C214; ""; True:C214)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]VersionRelease:24; True:C214; ""; True:C214)
		
	: ([Usage_Problem_Reports:84]Status:20="Returned") | ([Usage_Problem_Reports:84]Status:20="#Returned")
		If (Not:C34(User in group:C338(Current user:C182; "Administration")))
			//OBJECT SET ENABLED(bSend;True)
			uSetEntStatus(->[Usage_Problem_Reports:84]; False:C215)
			sAction:="Review"
		Else   //• 4/17/97 cs added so that we do not need to save to get this effect
			uSetEntStatus(->[Usage_Problem_Reports:84]; True:C214)
			//OBJECT SET ENABLED(bSend;True)
			sAction:="Modify"
		End if 
		
		
	: ([Usage_Problem_Reports:84]Status:20="Hold")
		//OBJECT SET ENABLED(bSend;False)
		uSetEntStatus(->[Usage_Problem_Reports:84]; False:C215)
		SetObjectProperties(""; ->[Usage_Problem_Reports:84]Status:20; True:C214; ""; True:C214)
		
	Else 
		//OBJECT SET ENABLED(bSend;False)
		BEEP:C151
		ALERT:C41("Invalid UPR status.")
		
End case 