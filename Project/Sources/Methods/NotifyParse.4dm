//%attributes = {"publishedWeb":true}
//(p) NotifyParse
//parses the user prefences - places results into an
//array of strings/flags to indicate what operations to do
//returns size of array of preferences
//6/24/97 cs created

C_TEXT:C284($1; t1)
ARRAY TEXT:C222(aPreference; 10)  //100 is an arbitray number to make an array which is large enough

t1:=$1
$Count:=1

If (t1#"")
	Repeat 
		$Pref:=uParseString(t1; 1; ";"; ->t1)
		
		If (Length:C16(t1)=0)
			$Pref:=uParseString($Pref; 1; "•")
		End if 
		aPreference{$Count}:=$Pref
		$Count:=$Count+1
	Until (Length:C16(t1)=0)
	$Count:=$Count-1
	
	If ($Count>0)
		ARRAY TEXT:C222(aPreference; $Count)
	Else 
		$Count:=0
		ARRAY TEXT:C222(aPreference; 0)
	End if 
Else 
	$Count:=0
	ARRAY TEXT:C222(aPreference; 0)
End if 

$0:=$Count