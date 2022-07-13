//%attributes = {"publishedWeb":true}
//(p) VenSUm2Disk
//print vendor sumary report to disk
//$1 string - 2 characters, "VD" - vend detail, CH - commodity header
//  CD - Commodity detail, TD - grand total line, MH - main header
C_TEXT:C284($1)
C_TEXT:C284($Text)
$Format:="###,###,##0"
$Tab:=Char:C90(9)

Case of 
	: ($1="MH")
		$Text:=Char:C90(13)+Char:C90(13)+String:C10(dDate)+$Tab+String:C10(tTime)+$Tab+t2+Char:C90(13)
		$Text:=$Text+($tab*2)+t2b+Char:C90(13)+($Tab*2)+t3+Char:C90(13)+Char:C90(3)
		$Text:=$Text+$Tab+"Month to Date $"+$Tab+"Month to Date Qty"+$Tab+"Quarter to Date $"+$Tab+"Quarter to Date Qty"+$Tab
		$Text:=$Text+"Year to Date $"+$Tab+"Year to Date Qty"+$Tab+"Prev Year Total $"+$Tab+"Prev Year Total Qty"+$Tab+"20% Difference Marker"+Char:C90(13)+Char:C90(13)
		
	: ($1="CH")
		$Text:="Commodity:"+String:C10(iCommcode)+$Tab+[Raw_Materials_Groups:22]Description:2+Char:C90(13)
		
	: ($1="VD")
		$Text:=[Vendors:7]Name:2+$Tab+String:C10(Round:C94(real1; 0))+$Tab+String:C10(Round:C94(real2; 0))+$Tab+String:C10(Round:C94(real5; 0))+$Tab+String:C10(Round:C94(real6; 0))+$Tab+String:C10(Round:C94(real9; 0))+$Tab+String:C10(Round:C94(real10; 0))+Char:C90(13)
		$Text:=$Text+$Tab+String:C10(Round:C94(real3; 0))+$Tab+String:C10(Round:C94(real4; 0))+$Tab+String:C10(Round:C94(real7; 0))+$Tab+String:C10(Round:C94(real8; 0))+$Tab+String:C10(Round:C94(real11; 0))+$Tab+String:C10(Round:C94(real12; 0))+$Tab+String:C10(Round:C94(real13; 0))+$Tab+String:C10(Round:C94(real14; 0))+$Tab+xText+Char:C90(13)
		
	: ($1="CD")
		$Text:=Char:C90(13)+"Total for Commodity"+String:C10(Round:C94(iCommCode; 0))+$Tab+String:C10(Round:C94(real1; 0))+$Tab+String:C10(Round:C94(real2; 0))+$Tab+String:C10(Round:C94(real5; 0))+$Tab+String:C10(Round:C94(real6; 0))+$Tab+String:C10(Round:C94(real9; 0))+$Tab+String:C10(Round:C94(real10; 0))+Char:C90(13)
		$Text:=$Text+$tab+String:C10(Round:C94(real3; 0))+$Tab+String:C10(Round:C94(real4; 0))+$Tab+String:C10(Round:C94(real7; 0))+$Tab+String:C10(Round:C94(real8; 0))+$Tab+String:C10(Round:C94(real11; 0))+$Tab+String:C10(Round:C94(real12; 0))+$Tab+String:C10(Round:C94(real13; 0))+$Tab+String:C10(Round:C94(real14; 0))+Char:C90(13)
		
	: ($1="TD")
		$Text:=Char:C90(13)+Char:C90(13)+"Grand Total "+$Tab+String:C10(Round:C94(real1; 0))+$Tab+String:C10(Round:C94(real2; 0))+$Tab+String:C10(Round:C94(real5; 0))+$Tab+String:C10(Round:C94(real6; 0))+$Tab+String:C10(Round:C94(real9; 0))+$Tab+String:C10(Round:C94(real10; 0))+Char:C90(13)
		$Text:=$Text+$Tab+String:C10(Round:C94(real3; 0))+$Tab+String:C10(Round:C94(real4; 0))+$Tab+String:C10(Round:C94(real7; 0))+$Tab+String:C10(Round:C94(real8; 0))+$Tab+String:C10(Round:C94(real11; 0))+$Tab+String:C10(Round:C94(real12; 0))+$Tab+String:C10(Round:C94(real13; 0))+$Tab+String:C10(Round:C94(real14; 0))+Char:C90(13)
		
End case 
SEND PACKET:C103(vDoc; $Text)
//