//%attributes = {"publishedWeb":true}
//(p) doPurgeFgsWork
//$1 Longint - number of days before current to archive
//$2 string - transaction type
//$3 (optional) - string set name to exclude (optional)
//$4 (optional) actual date to use
//• 12/18/97 cs fixed text message to reference correct file name
//• 7/19/98 cs rewrite for new limts on Fg transactions - Fred
//•092899  mlb  switch to jobform instead of bin
//•092899  mlb  switch to set minipulations

C_LONGINT:C283($i; $Recs; $Hit)
C_DATE:C307($2)
C_TEXT:C284($Cr)
C_TEXT:C284($1)

$Cr:=Char:C90(13)

FIRST RECORD:C50([Finished_Goods_Transactions:33])
$Recs:=Records in selection:C76([Finished_Goods_Transactions:33])
uThermoInit($recs; "Purging "+$1+" from FG_Transactions records.")
For ($i; 1; $Recs)
	SEND RECORD:C78([Finished_Goods_Transactions:33])
	NEXT RECORD:C51([Finished_Goods_Transactions:33])
	uThermoUpdate($i)
End for 

MESSAGE:C88(Char:C90(13)+"Deleting..."+Char:C90(13))
xText:=xText+$CR+"Search was for Transaction type "+$1+" before "+String:C10($2; <>SHORTDATE)
xText:=xText+$Cr+String:C10($Recs; "^^^,^^^,^^0 ")+" FG_Transactions deleted and exported to FGX_"+fYYMMDD(4D_Current_date)  //• 12/18/97 cs corrected file name
DELETE SELECTION:C66([Finished_Goods_Transactions:33])
FLUSH CACHE:C297
uThermoClose