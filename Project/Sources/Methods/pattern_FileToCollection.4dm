//%attributes = {}
// _______
// Method: pattern_FileToCollection   ( ) ->
// By: MelvinBohince @ 05/09/22, 11:55:09
// Description
// read a tab delimited text document and parse to rows and columns
// ----------------------------------------------------

C_TEXT:C284($filePath; $data; $delimitorRow; $delimitorColumn; $primaryKey)
C_OBJECT:C1216($milageSourceDocument_f)
C_COLLECTION:C1488($rows_c; $columns_c)
C_TIME:C306($docRef)

//read a tab delimited document 
//drag the file from Finder to the $filePath
//$filePath:="MacBook22:Users:mel:Desktop:YTD_Billings_220506_1328.txt"
//or
//$files_c:=Folder(fk desktop folder).files()

//$filePath:="/Users/mel/Desktop/YTD_Billings_220506_1328.txt"
//$milageSourceDocument_f:=File($filePath;fk posix path)

$docRef:=Open document:C264(""; "TEXT"; Read mode:K24:5)
If (ok=1)
	$filePath:=Document
	CLOSE DOCUMENT:C267($docRef)
End if 

$milageSourceDocument_f:=File:C1566($filePath; fk platform path:K87:2)

$data:=$milageSourceDocument_f.getText()

$delimitorRow:="\r"
$delimitorColumn:="\t"

$rows_c:=New collection:C1472
$rows_c:=Split string:C1554($data; $delimitorRow; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
$columns_c:=New collection:C1472

For each ($row; $rows_c)
	$columns_c:=Split string:C1554($row; $delimitorColumn; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
	$primaryKey:=String:C10(Num:C11($columns_c[0]); "00000")
	//do a query( ) or something with that key
	//...snip...
	
End for each 
