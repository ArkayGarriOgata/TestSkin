//%attributes = {}
// _______
// Method: EMAIL_Test   ( ) ->
// By: Mel Bohince @ 03/09/20, 09:24:28
// Description
// test if new smtp creds make a difference
// ----------------------------------------------------

//CONFIRM("Which host?";"New";"Old")
//If (ok=1)
//<>EMAIL_STMP_HOST:="smtp.office365.com"
//Else 
//<>EMAIL_STMP_HOST:="199.233.220.37"
//End if 

//EMAIL_Sender ("TEST 0 SMTP";"";"Please reply if you receive this";"mel.bohince@arkay.com")//no good without a from

//EMAIL_Sender ("TEST 1 SMTP";"";"This is only a test";"mel.bohince@arkay.com";"";"";"mel.bohince@arkay.com")  //works!

//EMAIL_Sender ("TEST 1b SMTP";"";"This is only a test";"mel.bohince@arkay.com";"";"";"John.Schoettl@arkay.com")  //not!


//EMAIL_Sender ("TEST 2 SMTP";"";"This is only a test, no from";"John.Schoettl@arkay.com,mel.bohince@arkay.com")

//EMAIL_Sender ("TEST 3 SMTP";"";"This is only a test";"John.Schoettl@arkay.com,mel.bohince@arkay.com";"";"";"John.Schoettl@arkay.com")

//EMAIL_Sender ("TEST 4 SMTP";"";"This is only a test";"mel.bohince@arkay.com";"";"";"virtual.factory@arkay.com")  //not

//EMAIL_Sender ("TEST 5 SMTP";"";"Please reply if you get this. ";"mel.bohince@arkay.com,John.Schoettl@arkay.com";"";"";"administrator@arkay.com")  //worked

//EMAIL_Sender ("TEST 6 SMTP";"";"Please reply if you get this. using admin creds ";"mel.bohince@arkay.com,John.Schoettl@arkay.com,greg.panolfi@arkay.com")

EMAIL_Sender("TEST 9 SMTP"; ""; "Please reply if you get this. using v.f creds "; "mel.bohince@arkay.com,John.Schoettl@arkay.com,greg.pandolfi@arkay.com")