//%attributes = {"publishedWeb":true}
//Procedure: fInsertBR()  120797  MLB
//change CR's to <BR>+CR for html
C_TEXT:C284($1; $0)
C_TEXT:C284($cr; $br)
$cr:=Char:C90(13)
$br:="<BR>"+$cr
$0:=Replace string:C233($1; $cr; $br)
//