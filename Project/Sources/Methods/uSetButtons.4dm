//%attributes = {"publishedWeb":true}
OBJECT SET ENABLED:C1123(bDummy; False:C215)  // uSetButtons
Case of 
	: (iMode=1)
		OBJECT SET ENABLED:C1123(bTrash; False:C215)
	: (iMode=3)
		// OBJECT SET ENABLED(bAcceptRec;False)
		OBJECT SET ENABLED:C1123(bTrash; False:C215)
End case 