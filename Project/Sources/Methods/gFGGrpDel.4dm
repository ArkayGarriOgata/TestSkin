//%attributes = {"publishedWeb":true}
//gFGGrpDel: Deletion for file [FG_Class_n_Acct]

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ClassOrType:28=[Finished_Goods_Classifications:45]Class:1)
If (Records in selection:C76([Finished_Goods:26])>0)
	ALERT:C41("FG Class is listed in Finished Goods record.  FG record must be deleted first.")
Else 
	gDeleteRecord(->[Finished_Goods_Classifications:45])
End if 