//%attributes = {"publishedWeb":true}
//uSendPacket(docref;text)
//shortcut for converting indivdual send packets
//to a chunk of text
C_TIME:C306($1)  //ignored
C_TEXT:C284($2)

xText:=xText+$2
//