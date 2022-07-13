//%attributes = {}
// Method: util_FindAndHighlight (ptrField1{;ptrFieldn...}) -> # records found
// ----------------------------------------------------
// by: mel: 10/29/04, 14:59:42
// ----------------------------------------------------
// Description:
// find a record(s) *in* a selection and highlight it, 
//parameter 1 is required pointer to primary search field
//optional other pointers to other fields to search
// ----------------------------------------------------
// don't treat text as date Modified by: Mel Bohince (5/31/13)

C_LONGINT:C283($0; $numFound)
$0:=-1
C_POINTER:C301(${1}; $ptrTable; $ptrField)
C_TEXT:C284($table; $field; $findThis; $criterian; $options)

$options:=""
For ($param; 1; Count parameters:C259)
	$ptrField:=${$param}
	$options:=$options+Field name:C257($ptrField)+" "
End for 

zwStatusMsg("FIND"; "enter value for "+$options+" ; optional  =  #  <  >  <=  >=  prefix")
$findThis:=Request:C163("What are you looking for?"; "="+$field; "Find"; "Cancel")

If (ok=1)
	If (Length:C16($findThis)>0)
		
		Case of 
			: (Position:C15(Substring:C12($findThis; 2; 1); "=#<>")>0)
				$op:=Substring:C12($findThis; 1; 2)
				$findThis:=Substring:C12($findThis; 3)
			: (Position:C15(Substring:C12($findThis; 1; 1); "=#<>")>0)
				$op:=Substring:C12($findThis; 1; 1)
				$findThis:=Substring:C12($findThis; 2)
			Else 
				$op:="="
		End case 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "HiliteThese")
		
		For ($param; 1; Count parameters:C259)
			$ptrField:=${$param}
			$ptrTable:=Table:C252(Table:C252($ptrField))
			$table:="["+Table name:C256($ptrTable)+"]"
			$field:=$table+Field name:C257($ptrField)
			$criterian:=$findThis
			
			Case of 
				: (Type:C295($ptrField->)=Is longint:K8:6) | (Type:C295($ptrField)=Is integer:K8:5) | (Type:C295($ptrField)=Is real:K8:4)
					$criterian:="(Num("+util_Quote($findThis)+"))"
				: (Type:C295($ptrField->)=Is date:K8:7)
					If (util_isNumeric($findThis))  // don't treat text as date Modified by: Mel Bohince (5/31/13)
						$criterian:="!"+$findThis+"!"
					Else 
						$criterian:="!"+"01/01/1990"+"!"  // find nothing using a pre-sys date
					End if 
				: (Type:C295($ptrField->)=Is boolean:K8:9)
					$criterian:="("+util_Quote($findThis)+"="+util_Quote("True")+")"
				Else   //Is Alpha Field 
					$criterian:=util_Quote($findThis)
			End case 
			
			$command:=Command name:C538(341)+"("+$table+";"+$field+$op+$criterian+")"
			
			zwStatusMsg("FIND USING"; $command)
			EXECUTE FORMULA:C63($command)
			
			$numFound:=Records in set:C195("HiliteThese")
			If ($numFound>0)
				zwStatusMsg("FIND"; $field+$op+$criterian+" has been highlighted.")
				$param:=$param+999  //break
			End if 
			
		End for 
		
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		If ($numFound>0)
			$0:=$numFound
		Else 
			$0:=$numFound
			CREATE EMPTY SET:C140($ptrTable->; "HiliteThese")
			zwStatusMsg("FIND"; $criterian+" not found in "+$options+".")
		End if 
		COPY SET:C600("HiliteThese"; "UserSet")
		CLEAR SET:C117("HiliteThese")
		HIGHLIGHT RECORDS:C656
		
	End if   //find value entered
End if   //ok