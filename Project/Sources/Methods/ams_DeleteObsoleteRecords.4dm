//%attributes = {"publishedWeb":true}
//PM: ams_DeleteObsoleteRecords(tableptr) -> 
//@author mlb - 7/1/02  15:06

READ WRITE:C146($1->)
ALL RECORDS:C47($1->)
If (Records in selection:C76($1->)>0)
	//utl_Logfile ("purge.log";"OBS: Removing "+String(Records in selection($1->))+" from "+Table name($1))
	util_DeleteSelection($1)
End if 