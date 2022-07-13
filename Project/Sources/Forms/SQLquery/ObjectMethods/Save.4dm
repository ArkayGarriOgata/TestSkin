// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/22/10, 11:18:11
// ----------------------------------------------------
// Method: SQLquery.Save   ( ) ->
// Description
// save the results in the list box
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (1/16/19) handle data types better in compiled mode
// Modified by: Mel Bohince (2/12/20) change from .xls to .csv
// Modified by: Mel Bohince (4/13/20) quote text columns (too many Company, Inc.'s)
ARRAY TEXT:C222(arrColNames; 0)
ARRAY TEXT:C222(arrHeaderNames; 0)
ARRAY POINTER:C280(arrColVars; 0)
ARRAY POINTER:C280(arrHeaderVars; 0)
ARRAY BOOLEAN:C223(arrColsVisible; 0)
ARRAY POINTER:C280(arrStyles; 0)
C_REAL:C285($x)
C_TEXT:C284($t; $r)
$t:=","  //Char(9)
//$t:=Char(9)
$r:=Char:C90(13)
C_LONGINT:C283($col; $row)
$sql:=tText  //going to do a destructive parse
C_TEXT:C284(xTitle; xText; docName)
xTitle:=""
xText:=""
C_TIME:C306($docRef)
// Modified by: Mel Bohince (1/16/19) handle data types better in compiled mode //for type conversion:
C_LONGINT:C283($long)
C_REAL:C285($real)
C_DATE:C307($date)
C_BOOLEAN:C305($boolean)
C_TEXT:C284($text)


docName:="SQL_Query_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $sql+$r+$r)
	$sql:=Replace string:C233($sql; Char:C90(13); " ")
	$sql:=Replace string:C233($sql; "select "; "")
	$fromClause:=Position:C15(" from"; $sql)
	If ($fromClause=0)
		$fromClause:=Position:C15("from"; $sql)
	End if 
	$sql:=Substring:C12($sql; 1; ($fromClause-1))
	$sql:=$sql+","
	
	//try to improve the column titles
	$sql:=Replace string:C233($sql; "CAST("; "")
	$sql:=Replace string:C233($sql; " AS VARCHAR)"; "")
	$sql:=Replace string:C233($sql; " AS INT)"; "")
	$txt_numCol:=util_TextParser(5; $sql; Character code:C91(","); 13)
	
	LISTBOX GET ARRAYS:C832(Box1; arrColNames; arrHeaderNames; arrColVars; arrHeaderVars; arrColsVisible; arrStyles)
	//column names
	For ($col; 1; Size of array:C274(arrHeaderNames))
		If (arrColsVisible{$col})
			$name:=util_TextParser($col)
			$as:=Position:C15(" as "; $name)
			If ($as>1)
				$name:=Substring:C12($name; ($as+4))
			End if 
			xText:=xText+$name+$t
		End if 
	End for 
	
	xText:=xText+$r
	//data grid
	For ($row; 1; LISTBOX Get number of rows:C915(Box1))
		
		For ($col; 1; LISTBOX Get number of columns:C831(Box1))
			If (arrColsVisible{$col})
				$ptrArray:=arrColVars{$col}
				If (Is a variable:C294($ptrArray))
					// Modified by: Mel Bohince (1/16/19) handle data types better in compiled mode //for type conversion:
					Case of 
						: (Type:C295($ptrArray->{$row})=Is text:K8:3) | (Type:C295($ptrArray->{$row})=Is string var:K8:2)
							If (Position:C15(","; $ptrArray->{$row})=0)
								xText:=xText+$ptrArray->{$row}+$t
							Else   // Modified by: Mel Bohince (4/13/20) quote text columns (too many Company, Inc.'s)
								xText:=xText+txt_quote($ptrArray->{$row})+$t
							End if 
						: (Type:C295($ptrArray->{$row})=Is boolean:K8:9)
							$boolean:=$ptrArray->{$row}
							xText:=xText+String:C10(Num:C11($boolean))+$t
						: (Type:C295($ptrArray->{$row})=Is date:K8:7)
							$date:=$ptrArray->{$row}
							xText:=xText+String:C10($date; Internal date short special:K1:4)+$t
						: (Type:C295($ptrArray->{$row})=Is real:K8:4)
							$real:=$ptrArray->{$row}
							xText:=xText+String:C10($real)+$t
						: (Type:C295($ptrArray->{$row})=Is longint:K8:6)
							$long:=$ptrArray->{$row}
							xText:=xText+String:C10($long)+$t
						: (Type:C295($ptrArray->{$row})=Is integer 64 bits:K8:25)  // this is a mother fucker, work around using CAST( ) in the sql stmt
							$long:=$ptrArray->{$row}
							xText:=xText+String:C10($long)+$t
						Else   //fails on WMS query, iinvalid use of pointer
							$x:=$ptrArray->{$row}
							xText:=xText+"USE CAST FUNCTION"+$t
					End case 
				End if 
				
			End if 
			
		End for 
		xText:=xText+$r
	End for 
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	$err:=util_Launch_External_App(docName)
End if 
