//%attributes = {}
C_OBJECT:C1216($rel_e; $rel_es; $s)
$rel_e:=ds:C1482.Customers_ReleaseSchedules.query("CustomerRefer = :1"; "4502096806@").first()

If ($rel_e.Milestones=Null:C1517)
	$rel_e.Milestones:=New object:C1471("OPN"; "waiting")
Else 
	$rel_e.Milestones.OPN:=Current date:C33
	$rel_e.Milestones.ASN:=Current date:C33+3  //will save as iso
	$rel_e.Milestones.BKC:=String:C10(Current date:C33+5; Internal date short special:K1:4)
End if 
$s:=$rel_e.save()

//$x:=$rel_e.Milestones.ASN-$rel_e.Milestones.OPN

C_DATE:C307($date)
$date:=Date:C102($rel_e.Milestones.OPN)

$rel_es:=ds:C1482.Customers_ReleaseSchedules.all()
$rel_es:=ds:C1482.Customers_ReleaseSchedules.query("Milestones.OPN = :1"; String:C10(Current date:C33; Internal date short special:K1:4))