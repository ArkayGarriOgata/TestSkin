[edi_Outbox:155]ContentText:10:=Replace string:C233([edi_Outbox:155]ContentText:10; "'"+Char:C90(13); "'")
SET BLOB SIZE:C606([edi_Outbox:155]Content:3; 0)
TEXT TO BLOB:C554([edi_Outbox:155]ContentText:10; [edi_Outbox:155]Content:3; UTF8 text without length:K22:17)
[edi_Outbox:155]SentTimeStamp:4:=0

