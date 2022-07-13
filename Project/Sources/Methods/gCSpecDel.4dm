//%attributes = {"publishedWeb":true}
//gCSPecDel: Deletion of file [CARTON_SPEC]

QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]Carton:1=[Estimates_Carton_Specs:19]CartonSpecKey:7)
If (Records in selection:C76([Estimates_FormCartons:48])>0)
	ALERT:C41("Forms have been created for this Carton Spec. Forms must be deleted first.")
Else 
	gDeleteRecord(->[Estimates_Carton_Specs:19])
End if 