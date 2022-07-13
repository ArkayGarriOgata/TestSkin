// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/18/12, 15:20:52
// ----------------------------------------------------
// Method: [Finished_Goods].AskMe.Clear List
// Description:
// Deletes all the records associated with this user.
// ----------------------------------------------------

C_TEXT:C284(tMsg)
C_LONGINT:C283(xlKeep; $i)

xlKeep:=0

tMsg:="Are you sure you want to modify the list?"+<>CR
tMsg:=tMsg+"You can enter any number under 40 to keep that many history items."+<>CR
tMsg:=tMsg+"Enter 0 to clear the list."

CenterWindow(385; 150)
DIALOG:C40([Finished_Goods:26]; "AskMeHistoryKeep")

If (OK=1)
	QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2=Current user:C182; *)
	QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]PrefType:4="AskMeProduct")
	
	Case of 
		: (xlKeep=0)  //Delete them all
			If (Records in selection:C76([UserPrefs:184])>0)
				DELETE SELECTION:C66([UserPrefs:184])
				AskMeHistory("Clear")  //Redraw the list to empty it.
			End if 
			OBJECT SET ENABLED:C1123(xlAskMeList; False:C215)
			
		: (xlKeep>0)  //User chose to keep some items.
			ORDER BY:C49([UserPrefs:184]; [UserPrefs:184]DateField:9; <; [UserPrefs:184]TimeField:10; <)
			$i:=Records in selection:C76([UserPrefs:184])
			If ($i>xlKeep)
				Repeat 
					GOTO SELECTED RECORD:C245([UserPrefs:184]; $i)
					DELETE RECORD:C58([UserPrefs:184])
					$i:=$i-1
				Until ($i=xlKeep)
			End if 
			AskMeHistory("LoadAll")  // Modified by: Mark Zinke (3/6/13) Was "Load"
			
		Else   //User entered a negative number... duah
			ALERT:C41("Please enter a positive number.")
			
	End case 
End if 