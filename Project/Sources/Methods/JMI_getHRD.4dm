//%attributes = {}
// _______
// Method: JMI_getHRD   ( ) ->
// By: Mel Bohince @ 06/12/20, 11:56:25
// Description
// rtn the next have ready date for a productcode in [Job_Forms_Items]
// ----------------------------------------------------
C_TEXT:C284($1; $cpn)
C_DATE:C307($0; $hrd)
C_OBJECT:C1216($jmi_es)
$hrd:=!00-00-00!

If (Count parameters:C259=0)  //testing
	$cpn:="EM42-01-0111"
Else 
	$cpn:=$1
End if 

$jmi_es:=ds:C1482.Job_Forms_Items.query("ProductCode = :1 and Completed = :2 and MAD > :3"; $cpn; !00-00-00!; !00-00-00!).orderBy("MAD asc")
If ($jmi_es.length>0)
	$hrd:=$jmi_es.first().MAD
End if 

$0:=$hrd
