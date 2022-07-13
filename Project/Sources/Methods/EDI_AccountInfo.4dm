//%attributes = {}
//Method: EDI_AccountInfo()  102998  MLB
//load the information about our trading partners

C_TEXT:C284($1; $2)
C_LONGINT:C283($i; $j; $equals; $end)
C_TEXT:C284($pref)
C_TEXT:C284($theText; $0)

$0:=<>NULL
OK:=0

Case of 
	: ($1="init")
		READ ONLY:C145([edi_Preferences:157])
		QUERY:C277([edi_Preferences:157]; [edi_Preferences:157]PrefName:2="EDI_ACCOUNT")
		ARRAY TEXT:C222(edi_aAcctName; 0)
		ARRAY TEXT:C222($edi_aAccInfo; 0)
		ARRAY TEXT:C222(edi_aAcctId; 0)
		ARRAY TEXT:C222(edi_aAcctQual; 0)
		ARRAY TEXT:C222(edi_aAcctACK; 0)
		ARRAY INTEGER:C220(edi_aAcctEleDelim; 0)
		ARRAY INTEGER:C220(edi_aAcctSegDelim; 0)
		ARRAY INTEGER:C220(edi_aAcctSubDelim; 0)
		ARRAY TEXT:C222(ediaAccountStdsVers; 0)
		ARRAY TEXT:C222(ediaInternational; 0)
		ARRAY TEXT:C222(edi_alias_name; 0)
		ARRAY TEXT:C222(edi_sellerID; 0)
		
		SELECTION TO ARRAY:C260([edi_Preferences:157]UserName:1; edi_aAcctName; [edi_Preferences:157]Prefs:3; $edi_aAccInfo)
		REDUCE SELECTION:C351([edi_Preferences:157]; 0)
		$numAccts:=Size of array:C274(edi_aAcctName)
		ARRAY TEXT:C222(edi_aAcctId; $numAccts)
		ARRAY TEXT:C222(edi_aAcctQual; $numAccts)
		ARRAY TEXT:C222(edi_aAcctACK; $numAccts)
		ARRAY INTEGER:C220(edi_aAcctEleDelim; $numAccts)
		ARRAY INTEGER:C220(edi_aAcctSegDelim; $numAccts)
		ARRAY INTEGER:C220(edi_aAcctSubDelim; $numAccts)
		ARRAY TEXT:C222(ediaAccountStdsVers; $numAccts)
		ARRAY TEXT:C222(ediaInternational; $numAccts)
		ARRAY TEXT:C222(edi_alias_name; $numAccts)
		ARRAY TEXT:C222(edi_sellerID; $numAccts)
		
		For ($i; 1; $numAccts)
			$theText:=Replace string:C233($edi_aAccInfo{$i}; Char:C90(13); "")
			For ($j; 1; 10)
				$equals:=Position:C15("="; $theText)
				$pref:=Substring:C12($theText; 1; $equals-1)
				$theText:=Substring:C12($theText; $equals+1)
				$end:=Position:C15("&"; $theText)
				Case of 
					: (Position:C15("ACCOUNT"; $pref)>0)
						edi_aAcctId{$i}:=Substring:C12($theText; 1; $end-1)
					: (Position:C15("QUALIFIER"; $pref)>0)
						edi_aAcctQual{$i}:=Substring:C12($theText; 1; $end-1)
					: (Position:C15("ELEMENT_DELIMITER"; $pref)>0)
						edi_aAcctEleDelim{$i}:=Num:C11(Substring:C12($theText; 1; $end-1))
					: (Position:C15("SEGMENT_DELIMITER"; $pref)>0)
						edi_aAcctSegDelim{$i}:=Num:C11(Substring:C12($theText; 1; $end-1))
					: (Position:C15("SUBELE_DELIMITER"; $pref)>0)
						edi_aAcctSubDelim{$i}:=Num:C11(Substring:C12($theText; 1; $end-1))
					: (Position:C15("ACKNOWLEDGE"; $pref)>0)
						edi_aAcctACK{$i}:=Substring:C12($theText; 1; $end-1)
					: (Position:C15("NAME"; $pref)>0)
						edi_alias_name{$i}:=Substring:C12($theText; 1; $end-1)
					: (Position:C15("STD_VERSION"; $pref)>0)
						ediaAccountStdsVers{$i}:=Substring:C12($theText; 1; $end-1)
					: (Position:C15("INTERNATIONAL"; $pref)>0)
						ediaInternational{$i}:=Substring:C12($theText; 1; $end-1)
					: (Position:C15("SELLER"; $pref)>0)
						edi_sellerID{$i}:=Substring:C12($theText; 1; $end-1)
				End case 
				$theText:=Substring:C12($theText; $end+1)
			End for 
		End for 
		If ($numAccts>0)
			$0:="OK"
			OK:=1
		End if 
		
	: ($1="getAcctID")
		$i:=Find in array:C230(edi_aAcctName; $2)
		If ($i>-1)
			$0:=edi_aAcctId{$i}
			OK:=1
		End if 
		
	: ($1="getAcctName")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			$0:=edi_aAcctName{$i}
			OK:=1
		End if 
		
	: ($1="getAlias")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			$0:=edi_alias_name{$i}
			OK:=1
		End if 
		
	: ($1="getQualifier")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			$0:=edi_aAcctQual{$i}
			OK:=1
		End if 
		
	: ($1="getEleDelim")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			$0:=String:C10(edi_aAcctEleDelim{$i})
			OK:=1
		End if 
		
	: ($1="getSegDelim")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			$0:=String:C10(edi_aAcctSegDelim{$i})
			OK:=1
		End if 
		
	: ($1="getSubDelim")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			$0:=String:C10(edi_aAcctSubDelim{$i})
			OK:=1
		End if 
		
	: ($1="getACK")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			If (Position:C15("YES"; edi_aAcctACK{$i})>0)
				// Modified by: Mel Bohince (4/27/20) add two ++
				$0:="+++1"  //$test_indicator
			Else 
				$0:=""
			End if 
			OK:=1
		Else 
			$0:=""
		End if 
		
	: ($1="getSTD_VER")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			$0:=ediaAccountStdsVers{$i}
			OK:=1
		End if 
		
	: ($1="getIntl")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			$0:=ediaInternational{$i}
			OK:=1
		End if 
		
	: ($1="getSellerCode")
		$i:=Find in array:C230(edi_aAcctId; $2)
		If ($i>-1)
			$0:=edi_sellerID{$i}
			OK:=1
		End if 
End case 