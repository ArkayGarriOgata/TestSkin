

If (asBull{ListBox1}="")
	asBull{ListBox1}:="•"
	OBJECT SET ENABLED:C1123(bPick; True:C214)
Else 
	asBull{ListBox1}:=""
	$i:=Find in array:C230(asBull; "•")
	If ($i=-1)
		OBJECT SET ENABLED:C1123(bPick; False:C215)
	Else 
		OBJECT SET ENABLED:C1123(bPick; True:C214)
	End if 
End if 

asBull:=0
asDiff:=0
ListBox1:=0
