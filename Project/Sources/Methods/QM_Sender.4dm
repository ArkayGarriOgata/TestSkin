//%attributes = {"publishedWeb":true}
//Procedure: QM_Sender(subject;bodyHdr;body;cc's;enclosure)  091996  mBohince
//based on sample generously provided by:
//<Andy_Farrell@rome.itd.sterling.com>
//•3/22/00  mlb  add attachment code
//•2/28/01  mlb  internet enabled

C_TEXT:C284($bodyHdr; $body; $2; $3; $4; $distribList)
C_TEXT:C284($subject; $attachmentPath; $5; $1)
C_LONGINT:C283($msgId; $connectionId; $params; $tabPos; $len; <>QMerror; $err)

$params:=Count parameters:C259
If (Length:C16(<>EMAIL_STMP_HOST)>0)  //•2/28/01  mlb  
	Case of 
		: ($params=5)
			EMAIL_Sender($1; $2; $3; $4; $5)
		: ($params=4)
			EMAIL_Sender($1; $2; $3; $4)
		: ($params=3)
			EMAIL_Sender($1; $2; $3)
		: ($params=2)
			EMAIL_Sender($1; $2)
		: ($params=1)
			EMAIL_Sender($1)
		Else 
			EMAIL_Sender
	End case 
End if 