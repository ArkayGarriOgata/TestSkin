//%attributes = {"publishedWeb":true}
//uPrintBinLabel
//based on  uPrintLabelRM()  121097  MLB, UPR 237 , based on uPrintLabel
//print driver for CoStar SE250 LableWriter

C_LONGINT:C283($params)
C_TEXT:C284($binName; $1; $2; $binNumber)
C_TEXT:C284($esc; $cr; $t; $ff; $reset; $gs; $lf)

$params:=Count parameters:C259
$esc:=Char:C90(27)
$cr:=Char:C90(13)
$t:=Char:C90(9)
$ff:=Char:C90(12)
$reset:=Char:C90(42)  //*
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
		$binName:=$1
		$binNumber:=$2
		
		//*send spacing and barcode    
		SEND PACKET:C103($gs+"A"+Char:C90(1)+Char:C90(0))  //left margin
		SEND PACKET:C103($gs+"h"+Char:C90(253))  //height of barcode
		SEND PACKET:C103($gs+"k"+Char:C90(11)+Char:C90(0))  //Code 128 Auto
		SEND PACKET:C103("*"+$binNumber+"*")
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103($t+$t+"  "+$binNumber+$lf+$lf+$lf)
		SEND PACKET:C103($gs+"l"+Char:C90(0)+Char:C90(0)+Char:C90(3)+Char:C90(155)+Char:C90(2))  //send a line
		SEND PACKET:C103($esc+"T")
		SEND PACKET:C103($t+$binName+$lf)
		SEND PACKET:C103($ff)  //*print the label
		
End case 