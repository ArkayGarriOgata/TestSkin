//%attributes = {"publishedWeb":true}
//(p) rNeedArt2Disk.h
//write header for disk report
//process vars setup in calling proc (rPrintNeedArt)
//• 4/28/98 cs created

C_TEXT:C284($Text)

$Text:=String:C10(4D_Current_date)+Char:C90(13)
$Text:=$Text+sAddress+Char:C90(13)
$Text:=$Text+"Re:  "+sBrand+Char:C90(13)
$Text:=$Text+sBuyerName+Char:C90(13)+Char:C90(13)
$Text:=$Text+"Prduct Code"+Char:C90(9)+"Components Needed"+Char:C90(9)+"Drop Dead Date"+Char:C90(9)+"Scheduled Date"+Char:C90(13)
SEND PACKET:C103(vDoc; $Text)