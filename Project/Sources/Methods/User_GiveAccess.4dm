//%attributes = {"publishedWeb":true}
//PM:  User_GiveAccessserInitials;tableName;primaryKey;rwd)  2/05/01  mlb
//give access to someone
If (Length:C16($1)>0)
	CREATE RECORD:C68([Users_Record_Accesses:94])
	[Users_Record_Accesses:94]UserInitials:1:=$1
	[Users_Record_Accesses:94]TableName:2:=$2
	[Users_Record_Accesses:94]PrimaryKey:3:=$3
	[Users_Record_Accesses:94]AccessType:4:=$4
	SAVE RECORD:C53([Users_Record_Accesses:94])
End if 