
t1:="Att: "+[Vendors:7]DefaultAttn:17+Char:C90(13)
t1:=t1+[Vendors:7]Name:2+Char:C90(13)
t1:=t1+[Vendors:7]Address1:4+Char:C90(13)
t1:=t1+[Vendors:7]Address2:5+Char:C90(13)
t1:=t1+[Vendors:7]City:7+", "+[Vendors:7]State:8+"  "
t1:=t1+[Vendors:7]Zip:9+"  "+(Num:C11([Vendors:7]Country:10#"USA")*[Vendors:7]Country:10)
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
t1:=Replace string:C233(t1; (Char:C90(13)+Char:C90(13)); Char:C90(13))
SET TEXT TO PASTEBOARD:C523(t1)

t1:=t1+Char:C90(13)+Char:C90(13)+"(this address is now in your Clipboard)"

$winRef:=Open form window:C675([zz_control:1]; "text_dio"; Sheet form window:K39:12)
DIALOG:C40([zz_control:1]; "text_dio")
CLOSE WINDOW:C154($winRef)

