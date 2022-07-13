//%attributes = {"publishedWeb":true}
//PM: pattern_Collection(msg;numeric;text) -> 
//@author mlb - 8/27/02  16:20

C_TEXT:C284($msg; $1)
C_LONGINT:C283($0; $2)
C_TEXT:C284($3)

$msg:=$1

Case of 
	: ($msg="new")
		$0:=pattern_CollectionFacade("size"; 0)
		
	: ($msg="add")
		INSERT IN ARRAY:C227(aRecordNumber; 1; 1)
		INSERT IN ARRAY:C227(aCollection; 1; 1)
		$0:=Size of array:C274(aCollection)
		CREATE RECORD:C68([zz_control:1])
		SAVE RECORD:C53([zz_control:1])
		aRecordNumber{1}:=Record number:C243([zz_control:1])
		
	: ($msg="dispose")
		$0:=pattern_CollectionFacade("size"; 0)
		CLEAR NAMED SELECTION:C333("inMemory")
		
	: ($msg="delete")
		GOTO RECORD:C242([zz_control:1]; aRecordNumber{$2})
		DELETE RECORD:C58([zz_control:1])
		DELETE FROM ARRAY:C228(aRecordNumber; $2)
		DELETE FROM ARRAY:C228(aCollection; $2)
		$0:=Size of array:C274(aCollection)
		
	: ($msg="size")
		ARRAY LONGINT:C221(aRecordNumber; $2)
		ARRAY LONGINT:C221(aCollection; $2)
		$0:=Size of array:C274(aCollection)
		
	: ($msg="sizeOf")
		$0:=Size of array:C274(aCollection)
		
	: ($msg="sort")
		Case of 
			: ($2=1)
				SORT ARRAY:C229(aCollection; aRecordNumber; >)
				$0:=$2
			Else 
				$0:=-1
		End case 
		
	: ($msg="load")
		READ WRITE:C146([zz_control:1])
		ALL RECORDS:C47([zz_control:1])
		SELECTION TO ARRAY:C260([zz_control:1]; aRecordNumber; [zz_control:1]StopBits:30; aCollection)
		COPY NAMED SELECTION:C331([zz_control:1]; "inMemory")
		REDUCE SELECTION:C351([zz_control:1]; 0)
		$0:=Size of array:C274(aCollection)
		
	: ($msg="store")
		READ WRITE:C146([zz_control:1])
		USE NAMED SELECTION:C332("inMemory")
		ARRAY TO SELECTION:C261(aCollection; [zz_control:1]StopBits:30)
		REDUCE SELECTION:C351([zz_control:1]; 0)
		$0:=Size of array:C274(aCollection)
		
	: ($msg="find")
		Case of 
			: ($3="test")
				$0:=Find in array:C230(aCollection; $2)
			Else 
				$0:=No current record:K29:2
		End case 
		
End case 