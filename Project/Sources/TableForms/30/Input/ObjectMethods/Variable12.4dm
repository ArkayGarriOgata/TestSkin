t1:="Att: "+[Addresses:30]AttentionOf:14+Char:C90(13)
t1:=t1+[Addresses:30]Name:2+Char:C90(13)
t1:=t1+[Addresses:30]Address1:3+Char:C90(13)
t1:=t1+[Addresses:30]Address2:4+Char:C90(13)
t1:=t1+[Addresses:30]Address3:5+Char:C90(13)
t1:=t1+[Addresses:30]City:6+", "+[Addresses:30]State:7+"  "
t1:=t1+[Addresses:30]Zip:8+"  "+(Num:C11([Addresses:30]Country:9#"USA")*[Addresses:30]Country:9)
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
SET TEXT TO PASTEBOARD:C523(t1)

t1:=t1+Char:C90(13)+Char:C90(13)+"(this address is now in your Clipboard)"


$winRef:=Open form window:C675([zz_control:1]; "text_dio"; Sheet form window:K39:12)
DIALOG:C40([zz_control:1]; "text_dio")
CLOSE WINDOW:C154($winRef)