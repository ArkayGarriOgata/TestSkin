//%attributes = {"publishedWeb":true}
//(p) rNeedArt2Disk.d
//write detail section for disk report
//process vars setup in calling proc (rPrintNeedArt)
//• 4/28/98 cs created

C_TEXT:C284($Text)

For ($i; 1; Size of array:C274(aCpn))
	$Text:=aCpn{$i}+Char:C90(9)+aText{$i}+Char:C90(9)+aLine{$i}+Char:C90(9)+aCharts{$i}+Char:C90(13)
	SEND PACKET:C103(vDoc; $Text)
End for 