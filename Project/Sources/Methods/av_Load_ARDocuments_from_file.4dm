//%attributes = {}
//  // -------
//  // Method: av_Load_ARDocuments_from_file   ( ) ->
//  // By: Mel Bohince @ 09/27/16, 15:16:14
//  // Description
//  // 
//  // ----------------------------------------------------
//  // based on pattern_ReadTextDocument
//  // ----------------------------------------------------


//C_LONGINT($1;$id)
//C_DATE($today)
//C_TEXT($recordDelimitor)
//C_TIME($docRef)
//C_REAL($cost)
//C_TEXT($rmCode;$desc)


//CONFIRM("Import text as DocumentReference<tab>Document Amount<tab>Doc Amnt Due<cr>?")
//If (OK=1)

//READ WRITE([o_ARDocument])
//CREATE EMPTY SET([Raw_Materials];"modified")
//  //$recordDelimitor:=Char(13)
//$today:=4D_Current_date 
//$docRef:=Open document("")  //open the document
//If (OK=1)
//RECEIVE PACKET($docRef;row;$recordDelimitor)  //read the document
//  //$i:=0
//row:=Replace string(row;Char(34);"")
//While (Length(row)>7)  //(OK=1) &
//$i:=$i+1
//zwStatusMsg ("Row"+String($i);row)

//util_TextParser (3;row)
//CREATE RECORD([o_ARDocument])
//[o_ARDocument]DocumentReference:=util_TextParser (1)
//[o_ARDocument]o_DocumentAmount:=Num(util_TextParser (2))
//[o_ARDocument]o_DocAmntDue:=Num(util_TextParser (3))

//SAVE RECORD([o_ARDocument])
//UNLOAD RECORD([o_ARDocument])

//util_TextParser 

//RECEIVE PACKET($docRef;row;$recordDelimitor)
//row:=Replace string(row;Char(34);"")
//End while 

//CLOSE DOCUMENT($docRef)
//BEEP
//ALERT(String($i)+" records imported.")

//End if   //open file

//End if   //ok
