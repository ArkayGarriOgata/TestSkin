//new login

C_OBJECT:C1216($enRec)

$enRec:=ds:C1482.Customer_Portal_Extracts.new()
$enRec.Name:="UNDEFINED"
$enRec.Username:="name@email.com"
$enRec.Customers:=New object:C1471
$enRec.save()
esLogins:=esLogins.add($enRec)