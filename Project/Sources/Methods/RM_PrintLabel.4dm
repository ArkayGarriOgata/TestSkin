//%attributes = {"publishedWeb":true}
//Procedure: uPrintLabelRM()  121097  MLB, UPR 237 , based on uPrintLabel
//print driver for CoStar SE250 LableWriter
//•122297  MLB  UPR 237 change the layout alittle
//•010698  MLB  UPR 237 change the layout alittle more
//• 8/6/98 cs try to get labels NOT to run on

C_LONGINT:C283($params)
C_TEXT:C284($esc; $cr; $t; $ff; $reset; $gs; $lf)

$params:=Count parameters:C259
$esc:=Char:C90(27)
$cr:=Char:C90(13)
$t:=Char:C90(9)
$ff:=Char:C90(12)
$reset:=Char:C90(42)
$lf:=Char:C90(10)
$gs:=Char:C90(29)

Case of 
	: ($params=0)  //constructor, set up printer        
		//*Init printer
		SET CHANNEL:C77(<>HasLabelPrinter; 19466)  //modemport  9600/8/1/no parity
		SEND PACKET:C103($esc+$reset)  //reset the printer before each print job
		SEND PACKET:C103($gs+"T"+Char:C90(1))
		SEND PACKET:C103($gs+"t"+Char:C90(45))
		SEND PACKET:C103($gs+"V1")  //203x203 resolutioin
		//SEND PACKET($esc+"X"+Char(0)+Char(0))  `set the left margin
		//SEND PACKET("1234567890123456789012345678901234567890"+$lf)
	: ($params=1)  //destructor, close channel
		SET CHANNEL:C77(11)  //*close print channel
		
	Else 
		//*Get data  
		$po:=$1
		$rm:=$2
		$desc:=Substring:C12(Replace string:C233($3; Char:C90(13); "*"); 1; 40)  //• 8/6/98 cs try to get labels NOT to run on
		$vend:=$4
		$uom:=$5
		$dept:=$6
		
		//*send spacing and barcode    
		SEND PACKET:C103($gs+"A"+Char:C90(1)+Char:C90(0))  //left margin
		SEND PACKET:C103($gs+"h"+Char:C90(152))  //height of barcode
		SEND PACKET:C103($gs+"k"+Char:C90(11)+Char:C90(0))  //Code 128 Auto
		SEND PACKET:C103("*"+$po+"*")
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103($t+$t+"  "+$po+$lf)
		
		//*send details
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103($lf)
		SEND PACKET:C103($gs+"l"+Char:C90(0)+Char:C90(0)+Char:C90(3)+Char:C90(155)+Char:C90(2))  //send a line
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103("R/M Code:  "+$lf)
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103($t+$rm+$lf)
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103("Vend:  "+$lf)
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103($t+$vend+$lf)
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103("UOM:"+$t+$t+$t+$t+"Dept:"+$lf)
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103($t+$uom+$t+$t+$dept+$lf)
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103("Desc:  "+$lf)
		SEND PACKET:C103($esc+"P")
		SEND PACKET:C103($desc+$lf)
		SEND PACKET:C103($ff)  //*print the label
		
End case 