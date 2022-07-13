//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_get_empty_bins - Created v0.1.0-JJG (05/09/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//moved here from wms_api_get_empty_bins


//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	
	
	$sql:="select bin_id from bins where location_type_code = 'FG' "
	$sql:=$sql+"and bin_id like 'BNV-%-%-%' "
	$sql:=$sql+"and bin_id not in "
	$sql:=$sql+"(select distinct bin_id from cases)  "
	$sql:=$sql+"order by bin_id"
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$row_count:=MySQL Get Row Count ($row_set)
	$0:=$row_count
	
	If ($row_count>0)
		
		C_TEXT:C284($t; $r)
		C_TEXT:C284(xTitle; xText; docName)
		C_TIME:C306($docRef)
		
		$t:=Char:C90(9)
		$r:=Char:C90(13)
		xTitle:=""
		xText:=""
		docName:="EmptyBins_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".txt"
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			ARRAY TEXT:C222($abin_id; 0)
			
			//MySQL Column To Array ($row_set;"";1;$aBin_id)
			//simple list
			//For ($i;1;$row_count)
			//utl_LogIt (txt_Pad ($aBin_id{$i};" ";1;20))
			//End for 
			
			$t:=Char:C90(9)
			$line:=""
			$bin:=1
			$across:=1
			While ($bin<=$row_count)
				$line:=$line+$aBin_id{$bin}+$t
				$bin:=$bin+1
				$across:=$across+1
				If ($across>5)
					$across:=1
					xText:=xText+$line+$r
					$line:=""
					
					If (Length:C16(xText)>25000)
						SEND PACKET:C103($docRef; xText)
						xText:=""
					End if 
					
				End if 
			End while 
			xText:=xText+$line
			xText:=xText+$r+"Total Empty = "+String:C10($row_count)+$r
			
			SEND PACKET:C103($docRef; xText)
			SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
			CLOSE DOCUMENT:C267($docRef)
			$err:=util_Launch_External_App(docName)
			
		End if   //doc opened
		
	End if   //row count
	
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	BEEP:C151
	
Else 
	uConfirm("Could not connect to WMS database."; "OK"; "Help")
End if 