//%attributes = {"publishedWeb":true}
//(p) notifyPrefParse
//parse user preferences for User preference settting dialog
//preferences are list items packd into a text field seperated by ','
//the interval ime is packed at the end and is seprated from the preferences by';'
//6/24/97 cs created

ARRAY TEXT:C222(aBullet; Size of array:C274(<>aUserPrefs))  //setup bullet array

xText:=[Users:5]Preference:14  //get user preference to parse, user record found before in search

If (xText#"")  //if there are user preferences - mark the ones already set
	$Time:=uParseString(xText; 2; "•")  //get the refresh time
	
	Repeat 
		$Pref:=uParseString(xText; 1; ";"; ->xText)  //get preference,
		
		If (Length:C16(xText)=0)  //if this is the last one it will include a '•' remove the '•'
			$Pref:=uParseString($Pref; 1; "•")
		End if 
		$Loc:=Find in array:C230(<>aUserPrefs; $Pref)
		
		If ($Loc>0)  //mark the bullet array 
			aBullet{$Loc}:="√"
		End if 
	Until (Length:C16(xText)=0)
	iMinutes:=Num:C11($Time)  //set time
Else   //else time is 0
	iMinutes:=0
End if 