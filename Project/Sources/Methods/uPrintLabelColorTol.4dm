//%attributes = {"publishedWeb":true}
//Procedure: uPrintLabelColorTol()  062697  MLB
//print driver for CoStar SE250 LableWriter

C_LONGINT:C283($params)
C_TEXT:C284($esc; $cr; $t; $ff; $reset; $gs; $lf)

$params:=Count parameters:C259
$esc:=Char:C90(27)
$cr:=Char:C90(13)
$t:=Char:C90(9)
$ff:=Char:C90(12)
$reset:=Char:C90(42)  //*
$lf:=Char:C90(10)
$gs:=Char:C90(29)
$inverseOn:=$gs+Char:C90(30)
$inverseOff:=$gs+Char:C90(31)

Case of 
	: ($params=0)  //constructor, set up printer        
		//*Init printer
		SET CHANNEL:C77(<>HasLabelPrinter; 19466)  //modemport  9600/8/1/no parity
		SEND PACKET:C103($esc+$reset)  //reset the printer before each print job
		SEND PACKET:C103($gs+"t"+Char:C90(45))  //chars across
		SEND PACKET:C103($gs+"V1")  //203x203 resolutioin
		//SEND PACKET($esc+"X"+Char(0)+Char(0))  `set the left margin
		//SEND PACKET("1234567890123456789012345678901234567890"+$lf)
	: ($params=1)  //destructor, close channel
		SET CHANNEL:C77(11)  //*close print channel
		
	Else 
		//*Get data  
		$jobSeq:=$1
		$type:=$2
		$cwd:=$3
		$cust:=$4
		$line:=$5
		$freeText:=$6
		
		//*send header
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103("Request Id"+$lf)
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103($jobSeq+$t+$t+$cwd+$lf)
		
		
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103("Customer:"+$lf)
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103($cust+$lf)
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103("Project:"+$lf)
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103($line+$lf)
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103("Code:"+$lf)
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103($type+$lf)
		
		SEND PACKET:C103($gs+"l"+Char:C90(0)+Char:C90(0)+Char:C90(1)+Char:C90(100)+Char:C90(3))  //send a line
		SEND PACKET:C103($esc+"S")
		SEND PACKET:C103(2*$lf)
		
		SEND PACKET:C103($esc+"M")
		SEND PACKET:C103(Substring:C12($freeText; 1; 30)+$lf)
		SEND PACKET:C103(Substring:C12($freeText; 31; 30)+$lf)
		SEND PACKET:C103(Substring:C12($freeText; 61; 30)+$lf)
		
		SEND PACKET:C103($ff)  //*print the label
		
End case 