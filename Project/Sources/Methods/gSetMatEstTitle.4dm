//%attributes = {"publishedWeb":true}
//(p) gSetMatEstTitle
//$1 comm key value
//3/2/95 add a param

C_LONGINT:C283($2)  //# of matl records 

If (Count parameters:C259#2)
	BEEP:C151
	ALERT:C41("wrong number of parameter to gSetMatEstTitle")
End if 

sMatLabel1:=""
sMatLabel2:=""
sMatLabel3:=""
sMatLabel4:=""
sMatLabel5:=""
sMatLabel6:=""
$comm:=Num:C11(Substring:C12($1; 1; 2))

If ($2>1)
	Case of 
		: ($comm=2) | ($Comm=3) | ($Comm=9)
			sMatLabel1:="% Coverage:"
			sMatLabel2:="Rotation:"
		Else 
			sMatLabel1:="Flex1"
			sMatLabel2:="Flex2"
			sMatLabel3:="Flex3"
			sMatLabel4:="Flex4"
			sMatLabel5:="Flex5"
			sMatLabel6:="Flex6"
	End case 
	
Else 
	Case of 
		: ($comm=1)
			If (Position:C15("Special"; $1)#0)
				sMatLabel1:="lbs/MSF:"
				sMatLabel2:="$cost/MSF:"
			End if 
			
		: ($comm=2) | ($Comm=3) | ($Comm=9)
			sMatLabel1:="% Coverage:"
			sMatLabel2:="Rotation:"
			
		: ($comm=4)
			sMatLabel1:="# of Film:"
			sMatLabel2:="# of Dycril:"
			sMatLabel3:="# of Wet:"
			
		: ($comm=5)
			sMatLabel1:="Steps:"
			sMatLabel2:="Rows (ref):"
			sMatLabel3:="Total Width'':"
			sMatLabel4:="Pull Length'':"
			If (Position:C15("Special"; $1)#0)
				sMatLabel5:="Cost/ROLL:"
				sMatLabel6:="Roll  L' x W'':"
			End if 
			
		: ($comm=6)
			sMatLabel1:="Want Qty:"
			sMatLabel2:="Packing Qty:"
			sMatLabel3:="Yield Qty:"
			
		: ($comm=7)
			sMatLabel1:="% Embossed:"
			
		: ($comm=8)
			If (Position:C15("Special"; $1)#0)
				sMatLabel1:="Cost/LF:"
			End if 
			
		: ($comm=13)
			sMatLabel1:="Unit Cost:"
			sMatLabel2:="Qty:"
			
		: ($comm=17)
			sMatLabel1:="Width'' (ref):"
			sMatLabel2:="Patch Length'':"
			
		: ($comm=51)
			sMatLabel1:="# of Cartons:"
			sMatLabel2:="# @ Yield:"
			
		: ($comm=71)
			sMatLabel1:="Die $(opt):"
			sMatLabel2:="Counter $(opt):"
			
	End case 
	
End if   //only one material