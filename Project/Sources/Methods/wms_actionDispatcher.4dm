//%attributes = {"publishedWeb":true}
//PM: wms_actionDispatcher() -> 
//@author Mel - 5/9/03  17:08


//action_dispatcher({command;params})
If (Count parameters:C259=0)  //read them in from a document
	$docRef:=Open document:C264("")
	If (ok=1)
		Repeat 
			RECEIVE PACKET:C104($docRef; $transaction; Char:C90(13))
			If (ok=1)
				$command:=Replace string:C233(Substring:C12($transaction; 1; 20); " "; "")
				If (wms_actionExists($command))
					$params:="("+Replace string:C233(Substring:C12($transaction; 21); " "; "")+")"
					EXECUTE FORMULA:C63("wms_action"+$command+$params)
					If (actionPerformed)
						//action_save($command;$params)
					End if 
				End if 
			End if 
		Until (ok=0)
		CLOSE DOCUMENT:C267($docRef)
	End if 
	
Else 
	$command:=$1
	$params:="("+$2+")"  //they need to be quoted
	If (wms_actionExists($command))
		EXECUTE FORMULA:C63("wms_action"+$command+$params)
		If (actionPerformed)
			//wms_actionPut 
			//wms_actionTake 
			//wms_actionMove 
			//wms_actionExists 
			//wms_actionDispatcher 
			
			//action_save($command;$params)
		End if 
	End if 
End if 
