//%attributes = {"publishedWeb":true}
//(p) Notifier
//procedure reads the user preferences, and 
//displays a list of pending items to handle such as PO to approve,
//POs to order, etc
//6/24/97 cs created
//• cs 9/9/97 adjust wind top point 

C_BOOLEAN:C305(<>fWindowOpen)

<>fWindowOpen:=False:C215

If (Not:C34(<>fWindowOpen))
	//• cs 9/9/97 adjust wind top point by windlist wind ht + 10 (window title)+ 2 sp
	If (Size of array:C274(<>aPrcsName)>0)  //this means that the window list is open
		NewWindow(120; 100; 3; -722; "Pending Items"; "NotifyWinClose"; 144)  //uPrcsLstClose     
	Else   //no window list    
		NewWindow(120; 100; 3; -722; "Pending Items"; "NotifyWinClose")
	End if 
	//• cs 9/9/97 
	
	<>fWindowOpen:=True:C214
	DIALOG:C40([zz_control:1]; "NotifyWindow")
End if 