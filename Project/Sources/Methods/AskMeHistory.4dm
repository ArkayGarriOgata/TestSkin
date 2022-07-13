//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/12/12, 10:18:05
// ----------------------------------------------------
// Method: AskMeHistory
// Description:
// Stores the AskMe history in the table [UserPrefs].
// Orginizes it by time, Today, This Week, This Month, This Year.
// Saved for each user.
// [UserPrefs]UserType = "AskMeProduct"
// [UserPrefs]TextField = fgKey

// Loads using the list AskMeCodes as the base.
// Today
// Yesterday
// This Week
// Last Week
// This Month
// Older

// $1 = Save:True, or Load:False
// $2 = fgKey, Text (Optional)
// ----------------------------------------------------

C_TEXT:C284($tDoWhat; $1; $tKey; $2; $tItemText)
C_DATE:C307($dDate)
C_BOOLEAN:C305($bIsList)
C_LONGINT:C283($xlListRef; $xlRef; $xlCount)
C_LONGINT:C283(xlSublistRef1; xlSublistRef2; xlSublistRef3; xlSublistRef4; xlSublistRef5; xlSublistRef6; xlSublistRef7)
ARRAY DATE:C224($adDates; 0)
ARRAY TEXT:C222($atText; 0)

xlToday:=0
xlYesterday:=0
xlThisWeek:=0
xlLastWeek:=0
xlThisMonth:=0
xlOlder:=0
$dDate:=Current date:C33  // Added by: Mark Zinke (3/6/13)

$tDoWhat:=$1
If (Count parameters:C259=2)
	$tKey:=$2
End if 

Case of 
	: ($tDoWhat="Save")
		QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2=Current user:C182; *)
		QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]PrefType:4="AskMeProduct"; *)
		QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]TextField:5=$tKey)
		If (Records in selection:C76([UserPrefs:184])=0)
			CREATE RECORD:C68([UserPrefs:184])
		End if 
		[UserPrefs:184]UserName:2:=Current user:C182
		[UserPrefs:184]PrefType:4:="AskMeProduct"
		[UserPrefs:184]TextField:5:=$tKey
		[UserPrefs:184]DateField:9:=Current date:C33
		[UserPrefs:184]TimeField:10:=Current time:C178
		SAVE RECORD:C53([UserPrefs:184])
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([UserPrefs:184])
			
			
		Else 
			
			// you gona use call this methode with query
			
			
		End if   // END 4D Professional Services : January 2019 
		AskMeHistory("Today")  //Redraw the list for the new entry
		
	: ($tDoWhat="Today")  // Added by: Mark Zinke (3/6/13) Only reloads "Today".
		QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2=Current user:C182; *)
		QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]DateField:9=Current date:C33; *)
		QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]PrefType:4="AskMeProduct")
		$xlCount:=Records in selection:C76([UserPrefs:184])
		If ($xlCount>0)
			SELECTION TO ARRAY:C260([UserPrefs:184]DateField:9; $adDates; [UserPrefs:184]TextField:5; $atText)
			If (Not:C34(Is a list:C621(xlSublistref1)))
				xlSublistRef1:=New list:C375
			End if 
			For ($i; 1; $xlCount)
				If (Find in list:C952(xlSublistRef1; $atText{$i}; 0)=0)  //Don't add duplicates
					AskMeGetItemRef($adDates{$i}; $atText{$i}; $dDate)  //Modified my: Mark Zinke (3/13/13)
				End if 
			End for 
			AskMeCountListItems  //Added my: Mark Zinke (3/13/13)
			AskMeAppendLists("All")  //Added my: Mark Zinke (3/13/13)
		End if 
		OBJECT SET ENABLED:C1123(xlAskMeList; True:C214)
		
	: ($tDoWhat="LoadAll")  //This if for the first AskMe, loads all the hlists.
		ClearCreateLists("All")  // Added by: Mark Zinke (3/6/13)
		
		QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2=Current user:C182; *)
		QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]PrefType:4="AskMeProduct")
		$xlCount:=Records in selection:C76([UserPrefs:184])  // Added by: Mark Zinke (3/6/13)
		If ($xlCount>0)
			SELECTION TO ARRAY:C260([UserPrefs:184]DateField:9; $adDates; [UserPrefs:184]TextField:5; $atText)
			//SORT ARRAY($adDates;$atText;<)  // Added by: Mark Zinke (3/6/13)
			MULTI SORT ARRAY:C718($adDates; <; $atText; >)  // Added by: Garri Ogata (12/18/20) 
			
			For ($i; 1; $xlCount)
				AskMeGetItemRef($adDates{$i}; $atText{$i}; $dDate)
			End for 
		End if 
		AskMeAppendLists("All")
		OBJECT SET ENABLED:C1123(xlAskMeList; True:C214)
		
	Else   //Clear the list
		AskMeAppendLists("Clear")
		
End case 
REDUCE SELECTION:C351([UserPrefs:184]; 0)