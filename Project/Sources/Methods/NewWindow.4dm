//%attributes = {"publishedWeb":true}
//NewWindow(width;height;position;type;name;close proc;Vertical Offset)
//position:
//0=Center, 1=Stacked, 2=Upper left, 3 = Upper right, 4=Lower left, 5=Lower right
//6=1/3 from top and centered
//• 11/13/97 cs  added code to install close window boxes on all correct window ty
//  also set up default close window procedure
//•052699  mlb  remove default close procedure

C_LONGINT:C283($1; $2; $3; $4; $7; $sh; $sw; $x1; $y1; $x2; $y2; $0)

$sh:=Screen height:C188
$sw:=Screen width:C187

Case of 
	: ($3=0)  //Centered
		$sh:=$sh\2
		$sw:=$sw\2
		$x1:=$sw-($1/2)
		$y1:=$sh-($2/2)
		$x2:=$sw+($1/2)
		$y2:=$sh+($2/2)
		
	: ($3=1)  //Stacked
		If (($1+<>winX)>Screen width:C187) | (($2+<>winY)>Screen height:C188)
			//the window would open off screen, so reset to the upper left
			<>winX:=2
			<>winY:=80
		End if 
		$x1:=<>winX
		$y1:=<>winY
		$x2:=$1+<>winX
		$y2:=$2+<>winY
		//increment the tiling coordinates
		<>winX:=<>winX+20
		<>winY:=<>winY+20
		
	: ($3=2)  //Upper left corner
		$x1:=2
		$y1:=43
		$x2:=$x1+$1
		$y2:=$y1+$2
		
	: ($3=3)  //Upper right corner
		$x1:=$sw-$1-10
		$y1:=43
		$x2:=$x1+$1
		$y2:=$y1+$2
		
	: ($3=4)  //Lower left corner
		$x1:=10
		$y1:=$sh-$2-10
		$x2:=$x1+$1
		$y2:=$y1+$2
		
	: ($3=5)  //Lower right corner
		$x1:=$sw-$1-10
		$y1:=$sh-$2-10
		$x2:=$x1+$1
		$y2:=$y1+$2
		
	: ($3=6)  //1/3 from top & centered (courtesy of Vance Miller)
		$sh:=$sh\3
		$sw:=$sw\2
		$x1:=$sw-($1\2)
		$y1:=$sh-($2\2)+40
		$x2:=$sw+($1\2)
		$y2:=$sh+($2\2)+40
		
End case 
$pars:=Count parameters:C259

//• 11/13/97 cs install close window boxes
$CloseProc:=""  //"uCloseWindow"

If ($Pars>=4)
	If ($4=0) | ($4=4) | ($4=5) | ($4=8) | (Abs:C99($4)=720) | (Abs:C99($4)=724)
		$CloseProc:=""  //"uCloseWindow"
	Else 
		$CloseProc:=""
	End if 
	
	If ($Pars>=6)
		If ($6#"")
			$CloseProc:=$6
		End if 
	End if 
End if 
//• 11/13/97 cs end

If (Count parameters:C259>4)
	WindowPositionGet($5; ->$x1; ->$y1; ->$x2; ->$y2)  // Added by: Mark Zinke (12/20/12)
End if 

Case of 
	: ($pars=3)
		$0:=Open window:C153($x1; $y1; $x2; $y2)
	: ($pars=4)
		$0:=Open window:C153($x1; $y1; $x2; $y2; $4; ""; $CloseProc)  //pass empty title
	: ($pars=5)
		$0:=Open window:C153($x1; $y1; $x2; $y2; $4; $5; $CloseProc)
	: ($pars=6)
		$0:=Open window:C153($x1; $y1; $x2; $y2; $4; $5; $CloseProc)
	: ($Pars=7)
		$0:=Open window:C153($x1; $y1+$7; $x2; $y2+$7; $4; $5; $CloseProc)
End case 