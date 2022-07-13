//%attributes = {}
// _______
// Method: _version20200504   ( ) ->
// By: Mel Bohince @ 05/04/20, 10:24:42
// Description
// populate [y_batch_distributions] for changes made to Batch_GetDistributionList
// ----------------------------------------------------


READ WRITE:C146([Addresses:30])
QUERY:C277([Addresses:30]; [Addresses:30]Country:9="U.S.A."; *)
QUERY:C277([Addresses:30];  | ; [Addresses:30]Country:9="U.S.A"; *)
QUERY:C277([Addresses:30];  | ; [Addresses:30]Country:9="United States"; *)
QUERY:C277([Addresses:30];  | ; [Addresses:30]Country:9=""; *)
QUERY:C277([Addresses:30];  | ; [Addresses:30]Country:9="USA")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Country:9:="US")

QUERY:C277([Addresses:30]; [Addresses:30]Country:9="U.K."; *)
QUERY:C277([Addresses:30];  | ; [Addresses:30]Country:9="UK"; *)
QUERY:C277([Addresses:30];  | ; [Addresses:30]Country:9="England"; *)
QUERY:C277([Addresses:30];  | ; [Addresses:30]Country:9="United Kingdom")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Country:9:="GB")

QUERY:C277([Addresses:30]; [Addresses:30]Country:9="canada")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Country:9:="CA")

QUERY:C277([Addresses:30]; [Addresses:30]Country:9="France")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Country:9:="FR")

QUERY:C277([Addresses:30]; [Addresses:30]Country:9="china")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Country:9:="CN")

QUERY:C277([Addresses:30]; [Addresses:30]Country:9="germany")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Country:9:="DE")

QUERY:C277([Addresses:30]; [Addresses:30]Country:9="italy")
QUERY:C277([Addresses:30];  | ; [Addresses:30]Country:9="ITALIA")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Country:9:="IT")

QUERY:C277([Addresses:30]; [Addresses:30]Country:9="Switzerland")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Country:9:="CH")

QUERY:C277([Addresses:30]; [Addresses:30]Country:9="Belgium")
APPLY TO SELECTION:C70([Addresses:30]; [Addresses:30]Country:9:="BE")

REDUCE SELECTION:C351([Addresses:30]; 0)

//###############--------------------
//add new distrobution
$batchName:="ACCTG"

CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batchName
[y_batches:10]Monthly:7:=False:C215
[y_batches:10]Description:2:="Membership to the Accounting Department."
[y_batches:10]sort_order:3:=889
SAVE RECORD:C53([y_batches:10])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="lynn.carden@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="jill.cook@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="laura.allbritton@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])
//###############
//###############
//###############

//###############--------------------
//add new distrobution
$batchName:="A/R"

CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batchName
[y_batches:10]Monthly:7:=False:C215
[y_batches:10]Description:2:="Receivables function in the Accounting Department."
[y_batches:10]sort_order:3:=889
SAVE RECORD:C53([y_batches:10])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="lynn.carden@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="jill.cook@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="laura.allbritton@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="debra.mckibbin@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])
//###############
//###############
//###############

//###############--------------------
//add new distrobution
$batchName:="A/P"

CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batchName
[y_batches:10]Monthly:7:=False:C215
[y_batches:10]Description:2:="Payables function in the Accounting Department."
[y_batches:10]sort_order:3:=889
SAVE RECORD:C53([y_batches:10])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="lynn.carden@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="jill.cook@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="Laura.Gader@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])
//###############
//###############
//###############

//###############--------------------
//add new distrobution
$batchName:="RM_AGING"

CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batchName
[y_batches:10]Monthly:7:=False:C215
[y_batches:10]Description:2:="Concerns with old raw material inventories."
[y_batches:10]sort_order:3:=889
SAVE RECORD:C53([y_batches:10])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="lynn.carden@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="jill.cook@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="brian.hopkins@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="kristopher.koertge@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="sean.mckiernan@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="eric.simon@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])
//###############
//###############
//###############

//###############--------------------
//add new distrobution
$batchName:="ACCPLN"

CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batchName
[y_batches:10]Monthly:7:=False:C215
[y_batches:10]Description:2:="Accounting and Planning departments."
[y_batches:10]sort_order:3:=889
SAVE RECORD:C53([y_batches:10])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="lynn.carden@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="jill.cook@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="kristopher.koertge@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])
//###############
//###############
//###############

//###############--------------------
//add new distrobution
$batchName:="PROD"

CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batchName
[y_batches:10]Monthly:7:=False:C215
[y_batches:10]Description:2:="Production Concerns"
[y_batches:10]sort_order:3:=889
SAVE RECORD:C53([y_batches:10])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="lynn.carden@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="frank.clark@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="kristopher.koertge@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="john.sheridan@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])
//###############
//###############
//###############

//###############--------------------
//add new distrobution
$batchName:="PREPRESS"

CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batchName
[y_batches:10]Monthly:7:=False:C215
[y_batches:10]Description:2:="Prepress,imaging/construction Concerns"
[y_batches:10]sort_order:3:=889
SAVE RECORD:C53([y_batches:10])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="lynn.carden@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="brian.hopkins@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="jerry.duckett@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])
//###############
//###############
//###############

//###############--------------------
//add new distrobution
$batchName:="ADD_SHEET"

CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batchName
[y_batches:10]Monthly:7:=False:C215
[y_batches:10]Description:2:="Additional Sheets added to a job."
[y_batches:10]sort_order:3:=889
SAVE RECORD:C53([y_batches:10])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="lynn.carden@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="jill.cook@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="brian.hopkins@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="kristopher.koertge@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="eric.simon@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="Walter.Shiels@arkay.comm"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="sean.mckiernan@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mitchell.kaneff@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])
//###############
//###############
//###############

//###############--------------------
//add new distrobution
$batchName:="RAMA"

CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batchName
[y_batches:10]Monthly:7:=False:C215
[y_batches:10]Description:2:="P&G's RAMA plant concerns - obsolete"
[y_batches:10]sort_order:3:=889
SAVE RECORD:C53([y_batches:10])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="mel.bohince@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="kristopher.koertge@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])

CREATE RECORD:C68([y_batch_distributions:164])
[y_batch_distributions:164]BatchName:1:=$batchName
[y_batch_distributions:164]EmailAddress:2:="Walter.Shiels@arkay.com"
SAVE RECORD:C53([y_batch_distributions:164])
//###############
//###############
//###############


REDUCE SELECTION:C351([y_batches:10]; 0)
REDUCE SELECTION:C351([y_batch_distributions:164]; 0)





