//%attributes = {"publishedWeb":true}
//util_SetWindowPosition(windowname;L;->T;->R;->B)->true or false
//BE SURE NOT TO CALL FROM LOCAL PROCESS!!!

C_TEXT:C284($1; $startTag; $endTag)
C_LONGINT:C283($left; $right; $bottom; $top; $5; $2; $3; $4)

C_BOOLEAN:C305($0)
$0:=False:C215

READ WRITE:C146([Users:5])
QUERY:C277([Users:5]; [Users:5]UserName:11=Current user:C182)
If (Records in selection:C76([Users:5])=1) & (fLockNLoad(->[Users:5]))
	$oldCoordinates:=[Users:5]WindowCoordinates:26
	$startTag:="<"+$1+">"  //"<TIMER>"
	$endTag:="</"+$1+">"
	
	$left:=$2
	$top:=$3
	$right:=$4
	$bottom:=$5
	
	$hit:=Position:C15($startTag; [Users:5]WindowCoordinates:26)  //<artpro>
	If ($hit>0)
		$start:=$hit
		$hit:=Position:C15($endTag; [Users:5]WindowCoordinates:26)
		If ($hit>0)
			$end:=$hit+Length:C16($endTag)-$start
			$coords:=Substring:C12([Users:5]WindowCoordinates:26; $start; $end)
			[Users:5]WindowCoordinates:26:=Replace string:C233([Users:5]WindowCoordinates:26; $coords; "")
		End if 
	End if 
	
	[Users:5]WindowCoordinates:26:=[Users:5]WindowCoordinates:26+$startTag+String:C10($left)+";"+String:C10($top)+";"+String:C10($right)+";"+String:C10($bottom)+$endTag
	If ([Users:5]WindowCoordinates:26#$oldCoordinates)
		SAVE RECORD:C53([Users:5])
	End if 
	$0:=True:C214
End if 
REDUCE SELECTION:C351([Users:5]; 0)