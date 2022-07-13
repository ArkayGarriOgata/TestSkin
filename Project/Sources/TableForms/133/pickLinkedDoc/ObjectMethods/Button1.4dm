C_LONGINT:C283($recNum)
$recNum:=DOC_makeLink(LinkKey)
If ($recNum>=0)
	READ ONLY:C145([x_linked_documents:133])
	GOTO RECORD:C242([x_linked_documents:133]; $recNum)
	INSERT IN ARRAY:C227(aPath; 1; 1)
	aPath{1}:=[x_linked_documents:133]DocPath:3
	REDUCE SELECTION:C351([x_linked_documents:133]; 0)
	aPath:=1
	
	INSERT IN ARRAY:C227(aRecNum; 1; 1)
	aRecNum{1}:=$recNum
	aRecNum:=1
	OBJECT SET ENABLED:C1123(*; "selected@"; True:C214)
End if 