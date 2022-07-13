//%attributes = {}
// _______
// Method: JMI_adaptor   (jobit:text ) -> jobitEntity
// By: MelvinBohince @ 06/10/22, 14:49:50
// Description
// helper for quick reports that need an ORDA value
// example quick report formula:
//      JMI_adaptor([Job_Forms_Items]Jobit).quantityShipped()
// ----------------------------------------------------

var $currentJobit; $1 : Text
var $jobItem_e; $0 : cs:C1710.Job_Forms_ItemsEntity

If (Count parameters:C259>0)
	$currentJobit:=$1
Else 
	$currentJobit:="18175.16.12"
End if 

$jobItem_e:=ds:C1482.Job_Forms_Items.query("Jobit = :1"; $currentJobit).first()

$0:=$jobItem_e

If (Count parameters:C259=0)
	ASSERT:C1129($jobItem_e.quantityShipped()=30240; "Fail")
End if 
