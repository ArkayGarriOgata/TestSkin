//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getEmptyBins_Write - Created v0.1.0-JJG (05/10/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_POINTER:C301($1; $psttEmptyBinIds)
C_TIME:C306($hRef)
C_TEXT:C284($ttLine)
C_LONGINT:C283($i; $xlErr)
$psttEmptyBinIds:=$1

If (Size of array:C274($psttEmptyBinIds->)>0)
	docName:="EmptyBins_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".txt"
	$hRef:=util_putFileName(->docName)
	
	If ($hRef#?00:00:00?)
		
		$ttLine:=""
		For ($i; 1; Size of array:C274($psttEmptyBinIds->))
			$ttLine:=$ttLine+$psttEmptyBinIds->{$i}+Char:C90(Tab:K15:37)
			If (($i%5)=0)
				$ttLine:=$ttLine+Char:C90(Carriage return:K15:38)
				SEND PACKET:C103($hRef; $ttLine)
				$ttLine:=""
			End if 
		End for 
		
		$ttLine:=$ttLine+Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38)+"------ END OF FILE ------"
		SEND PACKET:C103($hRef; $ttLine)
		CLOSE DOCUMENT:C267($hRef)
		$xlErr:=util_Launch_External_App(docName)
		
	End if 
End if 
