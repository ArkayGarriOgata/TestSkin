//%attributes = {"publishedWeb":true}
//(p) NanBatcher
//• 4/15/98 cs created

uDialog("NanBatch"; 475; 285)

If (OK=1)
	NaNCheckWork(->aSlcFldPtr; "*")
	CLOSE WINDOW:C154
	CLOSE WINDOW:C154
End if 