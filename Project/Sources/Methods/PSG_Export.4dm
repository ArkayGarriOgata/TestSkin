//%attributes = {}

// Method: PSG_Export ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/07/14, 10:14:01
// ----------------------------------------------------
// Description
// export data to excel
//
// ----------------------------------------------------

ARRAY TEXT:C222(arrColNames; 0)
ARRAY TEXT:C222(arrHeaderNames; 0)
ARRAY POINTER:C280(arrColVars; 0)
ARRAY POINTER:C280(arrHeaderVars; 0)
ARRAY BOOLEAN:C223(arrColsVisible; 0)
ARRAY POINTER:C280(arrStyles; 0)

C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)
C_LONGINT:C283($col; $row)
C_TEXT:C284(xTitle; xText; docName)
xTitle:=""
xText:=""
C_TIME:C306($docRef)

docName:=Get window title:C450
docName:=Replace string:C233(docName; " "; "_")
docName:=Replace string:C233(docName; ":"; "")
docName:=docName+"_"+String:C10(TSTimeStamp)+".xls"  //fYYMMDD (4D_Current_date)  //
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	
	
	LISTBOX GET ARRAYS:C832(aGlueListBox; arrColNames; arrHeaderNames; arrColVars; arrHeaderVars; arrColsVisible; arrStyles)
	For ($col; 1; Size of array:C274(arrColNames))
		//If (arrColsVisible{$col})
		xText:=xText+arrColNames{$col}+$t
		//End if 
	End for 
	xText:=xText+$r
	
	For ($row; 1; LISTBOX Get number of rows:C915(aGlueListBox))
		If (Length:C16(xText)>25000)
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
		If (Not:C34(abHidden{$row}))
			For ($col; 1; LISTBOX Get number of columns:C831(aGlueListBox))
				//If (arrColsVisible{$col})
				$ptrArray:=arrColVars{$col}
				If (Is a variable:C294($ptrArray))
					Case of 
						: (Type:C295($ptrArray->{$row})=Is text:K8:3) | (Type:C295($ptrArray->{$row})=Is string var:K8:2)
							xText:=xText+$ptrArray->{$row}+$t
						: (Type:C295($ptrArray->{$row})=Is boolean:K8:9)
							xText:=xText+String:C10(Num:C11($ptrArray->{$row}))+$t
						: (Type:C295($ptrArray->{$row})=Is picture:K8:10)
							xText:=xText+""+$t
						Else 
							xText:=xText+String:C10($ptrArray->{$row})+$t
					End case 
				End if 
				
				//End if 
				//End if 
			End for 
			xText:=xText+$r
			
		End if   //row not hidden
		
	End for 
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
	$err:=util_Launch_External_App(docName)
End if 
