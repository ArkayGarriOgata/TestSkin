
t1:="Att: "+[Contacts:51]Salutation:29+" "+[Contacts:51]FirstName:27+" "+[Contacts:51]LastName:26+Char:C90(13)
// t1:=t1+[CONTACTS]Name+Char(13)
t1:=t1+[Contacts:51]Company:3+Char:C90(13)
t1:=t1+[Contacts:51]Address2:4+Char:C90(13)
t1:=t1+[Contacts:51]Address3:5+Char:C90(13)
t1:=t1+[Contacts:51]Address4:35+Char:C90(13)
t1:=t1+[Contacts:51]City:6+", "+[Contacts:51]State:7+"  "
t1:=t1+[Contacts:51]Zip:8+"  "+(Num:C11([Contacts:51]Country:9#"USA")*[Contacts:51]Country:9)
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
SET TEXT TO PASTEBOARD:C523(t1)

t1:=t1+Char:C90(13)+Char:C90(13)+"(this address is now in your Clipboard)"

$winRef:=Open form window:C675([zz_control:1]; "text_dio"; Sheet form window:K39:12)
DIALOG:C40([zz_control:1]; "text_dio")
CLOSE WINDOW:C154($winRef)

