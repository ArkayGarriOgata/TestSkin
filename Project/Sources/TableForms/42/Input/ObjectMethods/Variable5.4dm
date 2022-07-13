If (<>aPopAlloc#0)
	<>jobform:=[Job_Forms:42]JobFormID:5
	If (<>aPopAlloc=1)
		ViewSetter(<>aPopAlloc; ->[Job_MakeVsBuy:97])
	Else 
		READ ONLY:C145([Job_MakeVsBuy:97])
		QUERY:C277([Job_MakeVsBuy:97]; [Job_MakeVsBuy:97]JobFormId:2=[Job_Forms:42]JobFormID:5)
		If (Records in selection:C76([Job_MakeVsBuy:97])>0)
			pattern_PassThru(->[Job_MakeVsBuy:97])
		End if 
		ViewSetter(<>aPopAlloc; ->[Job_MakeVsBuy:97])
		
	End if 
	<>aPopAlloc:=0
End if 