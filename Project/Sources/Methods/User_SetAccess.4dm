//%attributes = {"publishedWeb":true}
//PM:  User_SetAccess>Table;->primaryKey)  3/27/00  mlb
//give one or more uses access to a record in a table

C_POINTER:C301($1; $2)
C_LONGINT:C283($intPrimaryKey; $winRef)
C_TEXT:C284(tblPrimaryKey)
ARRAY TEXT:C222(aUsersInitials; 0)
ARRAY TEXT:C222(aUsersName; 0)

tblName:=Table name:C256($1)
tblPrimaryKey:=$2->

READ WRITE:C146([Users_Record_Accesses:94])
READ ONLY:C145([Users:5])
QUERY:C277([Users:5]; [Users:5]ProjectTeam:20=True:C214; *)  //on the short list
QUERY:C277([Users:5];  & ; [Users:5]UserName:11#"")  //still a user

If (Records in selection:C76([Users:5])=0)
	ALL RECORDS:C47([Users:5])
End if 

$winRef:=OpenSheetWindow(->[Users_Record_Accesses:94]; "SetAccess")
DIALOG:C40([Users_Record_Accesses:94]; "SetAccess")
CLOSE WINDOW:C154  //($winRef)

ARRAY TEXT:C222(asBull; 0)
ARRAY TEXT:C222(aUsersInitials; 0)
ARRAY TEXT:C222(aUsersName; 0)