//%attributes = {"publishedWeb":true}
//(p) NanCheckWork
//$1 pointer to pointer array of field(s) to check/fix
//$2 - string anything flag fix automagically
//• 4/10/98 cs created

C_POINTER:C301($1; $FieldPtr; $PtrArray; $File)
C_TEXT:C284($2)
C_LONGINT:C283($MaxInt)
C_LONGINT:C283($MaxLongInt)

$MaxLongInt:=2147483647  //*  maximum long int value - can be inserted by div by zero
$MaxInt:=32767  //*  maximum int value - can be inserted by div by zero

$PtrArray:=$1
<>fContinue:=True:C214
ON EVENT CALL:C190("eCancelPrint")
NewWindow(100; 20; 2; -720)
MESSAGE:C88("<Esc> to stop.")
NewWindow(250; 40; 0; -720)

For ($i; 1; Size of array:C274($PtrArray->))  //* for each field to process
	$FieldPtr:=$PtrArray->{$i}  //get pointer to field from pointer to aray of pointers
	$File:=Table:C252(Table:C252($FieldPtr))  //get pointer to file to work with from field
	
	Case of 
		: (Type:C295($FieldPtr->)=1)  //real - insure that it is the correct type
			MESSAGE:C88(Char:C90(13)+"Searching field: "+Field name:C257($FieldPtr))
			QUERY BY FORMULA:C48($File->; (Character code:C91(String:C10($FieldPtr->))<40) | (Character code:C91(String:C10($FieldPtr->))>57) | (Length:C16(String:C10($FieldPtr->))=0))
			
		: (Type:C295($FieldPtr->)=9)  //long int
			MESSAGE:C88(Char:C90(13)+"Searching field: "+Field name:C257($FieldPtr))
			QUERY BY FORMULA:C48($File->; Abs:C99($FieldPtr->)>=$MaxLongInt)
			
		: (Type:C295($FieldPtr->)=8)  //int fields
			MESSAGE:C88(Char:C90(13)+"Searching field: "+Field name:C257($FieldPtr))
			QUERY BY FORMULA:C48($File->; Abs:C99($FieldPtr->)>=$MaxInt)
			
		Else 
			uClearSelection($File)
	End case 
	CREATE SET:C116($File->; "Fix")  //* insure that table is read write          
	READ WRITE:C146($File->)
	USE SET:C118("Fix")
	CLEAR SET:C117("Fix")
	
	If (Records in selection:C76($File->)>0)
		If (Size of array:C274($PtrArray->)=1) & (Count parameters:C259=1)
			uConfirm("There were NaNs found, do you want to Fix them?")
		Else 
			OK:=1
		End if 
		
		If (OK=1)  //* OK to fix
			Repeat   //* repeat fix attempt until all records in field are fixed
				MESSAGE:C88(Char:C90(13)+"  Repairing field: "+Field name:C257($FieldPtr))
				APPLY TO SELECTION:C70($File->; $FieldPtr->:=NaNtoZero($FieldPtr->))
			Until (uChkLockedSet($File))  //uses the locked set if there are any
		End if   //OK=1
	End if   //NANs found
	
	If (Not:C34(<>fContinue))
		$i:=Size of array:C274($PtrArray->)+1
	End if 
End for 