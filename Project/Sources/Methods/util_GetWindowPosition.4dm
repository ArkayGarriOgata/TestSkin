//%attributes = {"publishedWeb":true}
//util_GetWindowPosition(windowname;->L;->T;->R;->B)->true or false
C_TEXT:C284($1; $startTag; $endTag)
C_POINTER:C301($2; $3; $4; $5; $L; $T; $R; $B)
$L:=$2
$T:=$3
$R:=$4
$B:=$5
$L->:=0
$T->:=0
$R->:=0
$B->:=0
C_BOOLEAN:C305($0; $didSearch)
$0:=False:C215
$didSearch:=False:C215

If ([Users:5]UserName:11#Current user:C182)
	READ ONLY:C145([Users:5])
	QUERY:C277([Users:5]; [Users:5]UserName:11=Current user:C182)
	$didSearch:=True:C214
End if 
If (Records in selection:C76([Users:5])=1)
	$startTag:="<"+$1+">"  //"<TIMER>"
	$endTag:="</"+$1+">"
	
	$hit:=Position:C15($startTag; [Users:5]WindowCoordinates:26)  //<artpro>
	If ($hit>0)
		$start:=$hit+(Length:C16($startTag))
		$hit:=Position:C15($endTag; [Users:5]WindowCoordinates:26)
		If ($hit>0)
			$end:=$hit-$start
			$coords:=Substring:C12([Users:5]WindowCoordinates:26; $start; $end)
			$end:=Position:C15(";"; $coords)
			$L->:=Num:C11(Substring:C12($coords; 1; $end-1))
			$coords:=Substring:C12($coords; $end+1)
			$end:=Position:C15(";"; $coords)
			$T->:=Num:C11(Substring:C12($coords; 1; $end-1))
			$coords:=Substring:C12($coords; $end+1)
			$end:=Position:C15(";"; $coords)
			$R->:=Num:C11(Substring:C12($coords; 1; $end-1))
			$coords:=Substring:C12($coords; $end+1)
			$B->:=Num:C11(Substring:C12($coords; 1))
			$0:=True:C214
		End if 
	End if 
End if 

If ($didSearch)
	REDUCE SELECTION:C351([Users:5]; 0)
End if 