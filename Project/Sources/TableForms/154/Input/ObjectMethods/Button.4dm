//util_FloatingAlert (Replace string([edi_Inbox]Content_Text;"'";"'\r"))
utl_LogIt("init")
utl_LogIt(Replace string:C233([edi_Inbox:154]Content_Text:10; "'"; "'\r"))
utl_LogIt("show")