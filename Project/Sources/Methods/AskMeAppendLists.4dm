//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/18/12, 12:17:28
// ----------------------------------------------------
// Method: AskMeAppendLists
// Description:
// Append the already created sublists to their parents.
// ----------------------------------------------------

C_LONGINT:C283(xlAskMeList)
C_TEXT:C284($tDoWhat; $1)

$tDoWhat:=$1

Case of 
	: ((Is a list:C621(xlAskMeList)) & ($tDoWhat="Clear"))
		CLEAR LIST:C377(xlAskMeList; *)
		
	: ($tDoWhat="All")  //This only runs the first time.
		xlAskMeList:=New list:C375
		If (xlToday>0)
			APPEND TO LIST:C376(xlAskMeList; "Today"; 1; xlSublistRef1; True:C214)
		End if 
		If (xlYesterday>0)
			APPEND TO LIST:C376(xlAskMeList; "Yesterday"; 2; xlSublistRef2; True:C214)
		End if 
		If (xlThisWeek>0)
			APPEND TO LIST:C376(xlAskMeList; "This Week"; 3; xlSublistRef3; True:C214)
		End if 
		If (xlLastWeek>0)
			APPEND TO LIST:C376(xlAskMeList; "Last Week"; 4; xlSublistRef4; True:C214)
		End if 
		If (xlThisMonth>0)
			APPEND TO LIST:C376(xlAskMeList; "This Month"; 5; xlSublistRef5; True:C214)
		End if 
		If (xlOlder>0)
			APPEND TO LIST:C376(xlAskMeList; "Older"; 6; xlSublistRef6; True:C214)
		End if 
End case 