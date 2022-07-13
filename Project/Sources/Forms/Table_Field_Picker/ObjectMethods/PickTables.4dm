
Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(<>axFiles; 0)
		ARRAY INTEGER:C220(<>axFileNums; 0)
		ARRAY TEXT:C222(aFieldNames; 0)
		ARRAY LONGINT:C221(aFieldNums; 0)
		
		ARRAY BOOLEAN:C223(Box4; 0)
		Box4:=0
		ARRAY BOOLEAN:C223(Box3; 0)
		Box3:=0
		
		ams_get_tables  //<>axFiles and <>axFileNums
		<>axFiles:=0
		<>axFileNums:=0
		aFieldNames:=0
		aFieldNums:=0
		
		
	: (Form event code:C388=On Clicked:K2:4)
		//ams_get_fields (<>axFileNums{Box4})
		ARRAY TEXT:C222(aFieldNames; 0)
		ARRAY LONGINT:C221(aFieldNums; 0)
		C_LONGINT:C283($i; $numFields)
		$numFields:=Get last field number:C255(<>axFileNums{<>axFileNums})
		
		For ($i; 1; $numFields)
			APPEND TO ARRAY:C911(aFieldNames; Field name:C257(<>axFileNums{<>axFileNums}; $i))
			APPEND TO ARRAY:C911(aFieldNums; $i)
		End for 
		SORT ARRAY:C229(aFieldNames; aFieldNums; >)
End case 
