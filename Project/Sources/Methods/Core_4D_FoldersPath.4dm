//%attributes = {}
//Method:  Core_4D_FoldersPath
//Description:  This method will create a document where all the 4D folders are located

If (True:C214)  //Initialize
	
	ARRAY TEXT:C222($atFolderName; 0)
	ARRAY TEXT:C222($atFolderPath; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	APPEND TO ARRAY:C911($apColumn; ->$atFolderName)
	APPEND TO ARRAY:C911($apColumn; ->$atFolderPath)
	
End if   //Done initialize

APPEND TO ARRAY:C911($atFolderName; "4D Client database folder")
APPEND TO ARRAY:C911($atFolderName; "Active 4D Folder")
APPEND TO ARRAY:C911($atFolderName; "Current resources folder")
APPEND TO ARRAY:C911($atFolderName; "Data folder")
APPEND TO ARRAY:C911($atFolderName; "Database folder")
APPEND TO ARRAY:C911($atFolderName; "Database folder UNIX syntax")
APPEND TO ARRAY:C911($atFolderName; "HTML Root folder")
APPEND TO ARRAY:C911($atFolderName; "Licenses folder")

APPEND TO ARRAY:C911($atFolderPath; Get 4D folder:C485(4D Client database folder:K5:13))
APPEND TO ARRAY:C911($atFolderPath; Get 4D folder:C485(Active 4D Folder:K5:10))
APPEND TO ARRAY:C911($atFolderPath; Get 4D folder:C485(Current resources folder:K5:16))
APPEND TO ARRAY:C911($atFolderPath; Get 4D folder:C485(Data folder:K5:33))
APPEND TO ARRAY:C911($atFolderPath; Get 4D folder:C485(Database folder:K5:14))
APPEND TO ARRAY:C911($atFolderPath; Get 4D folder:C485(Database folder UNIX syntax:K5:15))
APPEND TO ARRAY:C911($atFolderPath; Get 4D folder:C485(HTML Root folder:K5:20))
APPEND TO ARRAY:C911($atFolderPath; Get 4D folder:C485(Licenses folder:K5:11))

Core_Array_ToDocument(->$apColumn)
