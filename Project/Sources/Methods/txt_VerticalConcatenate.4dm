//%attributes = {"publishedWeb":true}
//PM:  txt_VerticalConcatenate 
//formerly  `(P) uVertConcat: Vertically concatenates text and removes excess carr

C_TEXT:C284($0; $1)

$0:=$1
Repeat 
	$0:=Replace string:C233($0; <>sCR*2; <>sCR)
Until (Position:C15(Char:C90(13)*2; $0)=0)