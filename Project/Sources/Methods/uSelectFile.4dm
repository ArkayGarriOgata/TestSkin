//%attributes = {"publishedWeb":true}
//(P) uSelectFile: Present dialog to select file

C_BOOLEAN:C305($0)

$winRef:=Open form window:C675([zz_control:1]; "SelectFile")
DIALOG:C40([zz_control:1]; "SelectFile")
$0:=(OK=1)
CLOSE WINDOW:C154($winRef)