//%attributes = {"publishedWeb":true}
//Method: bitGet(test longint;position) ->longint 010999  MLB
//test bit, for back compatibility to old ACI_Pack

C_LONGINT:C283($1; $2; $0)

$0:=Num:C11($1 ?? $2)