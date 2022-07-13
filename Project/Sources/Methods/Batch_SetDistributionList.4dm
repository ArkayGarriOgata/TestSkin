//%attributes = {}
// -------
// Method: Batch_SetDistributionList   ( ) ->
// By: Mel Bohince @ 10/11/16, 08:38:00
// Description
// make some new distribution lists
// ----------------------------------------------------

READ WRITE:C146([y_batch_distributions:164])
READ WRITE:C146([y_batches:10])

$batch:="QA_MOVE"
CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batch
SAVE RECORD:C53([y_batches:10])
UNLOAD RECORD:C212([y_batches:10])
ARRAY TEXT:C222($aWho; 0)
APPEND TO ARRAY:C911($aWho; "john.sheridan@arkay.com")
APPEND TO ARRAY:C911($aWho; "lisa.dirsa@arkay.com")
APPEND TO ARRAY:C911($aWho; "eliedny.vega@arkay.com")
APPEND TO ARRAY:C911($aWho; "Trisha.Oconnor@arkay.com")
APPEND TO ARRAY:C911($aWho; "heather.webb@arkay.com")
APPEND TO ARRAY:C911($aWho; "rhonda.justice@arkay.com")
APPEND TO ARRAY:C911($aWho; "irma.osornio@arkay.com")
For ($email; 1; Size of array:C274($aWho))
	CREATE RECORD:C68([y_batch_distributions:164])
	[y_batch_distributions:164]BatchName:1:=$batch
	[y_batch_distributions:164]EmailAddress:2:=$aWho{$email}
	SAVE RECORD:C53([y_batch_distributions:164])
	UNLOAD RECORD:C212([y_batch_distributions:164])
End for 

//////////////////////////
//////////////////////////
$batch:="Print Goal"
QUERY:C277([y_batches:10]; [y_batches:10]BatchName:1=$batch)
QUERY:C277([y_batch_distributions:164]; [y_batch_distributions:164]BatchName:1=$batch)
$batch:="Goal Printing"  //the change
APPLY TO SELECTION:C70([y_batch_distributions:164]; [y_batch_distributions:164]BatchName:1:=$batch)
[y_batches:10]BatchName:1:=$batch
SAVE RECORD:C53([y_batches:10])
UNLOAD RECORD:C212([y_batches:10])
UNLOAD RECORD:C212([y_batch_distributions:164])

ARRAY TEXT:C222($aWho; 0)

//////////////////////////
//////////////////////////
$batch:="Goal Blanking"
CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batch
SAVE RECORD:C53([y_batches:10])

ARRAY TEXT:C222($aWho; 0)
APPEND TO ARRAY:C911($aWho; "brian.hopkins@arkay.com")
APPEND TO ARRAY:C911($aWho; "Matt.Shiels2@arkay.com")
APPEND TO ARRAY:C911($aWho; "frank.clark@arkay.com")
APPEND TO ARRAY:C911($aWho; "Kristopher.Koertge@arkay.com")
APPEND TO ARRAY:C911($aWho; "mel.bohince@arkay.com")
APPEND TO ARRAY:C911($aWho; "paul.ladino@arkay.com")
APPEND TO ARRAY:C911($aWho; "Stephen.Viola@arkay.com")
APPEND TO ARRAY:C911($aWho; "wes.reynolds@arkay.com")
APPEND TO ARRAY:C911($aWho; "chris.haymaker@arkay.com")
For ($email; 1; Size of array:C274($aWho))
	CREATE RECORD:C68([y_batch_distributions:164])
	[y_batch_distributions:164]BatchName:1:=$batch
	[y_batch_distributions:164]EmailAddress:2:=$aWho{$email}
	SAVE RECORD:C53([y_batch_distributions:164])
	UNLOAD RECORD:C212([y_batch_distributions:164])
End for 


//////////////////////////
//////////////////////////
$batch:="Goal Stamping"
CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batch
SAVE RECORD:C53([y_batches:10])

ARRAY TEXT:C222($aWho; 0)
APPEND TO ARRAY:C911($aWho; "brian.hopkins@arkay.com")
APPEND TO ARRAY:C911($aWho; "Matt.Shiels2@arkay.com")
APPEND TO ARRAY:C911($aWho; "frank.clark@arkay.com")
APPEND TO ARRAY:C911($aWho; "Kristopher.Koertge@arkay.com")
APPEND TO ARRAY:C911($aWho; "mel.bohince@arkay.com")
APPEND TO ARRAY:C911($aWho; "paul.ladino@arkay.com")
APPEND TO ARRAY:C911($aWho; "Stephen.Viola@arkay.com")
APPEND TO ARRAY:C911($aWho; "wes.reynolds@arkay.com")
APPEND TO ARRAY:C911($aWho; "chris.haymaker@arkay.com")
For ($email; 1; Size of array:C274($aWho))
	CREATE RECORD:C68([y_batch_distributions:164])
	[y_batch_distributions:164]BatchName:1:=$batch
	[y_batch_distributions:164]EmailAddress:2:=$aWho{$email}
	SAVE RECORD:C53([y_batch_distributions:164])
	UNLOAD RECORD:C212([y_batch_distributions:164])
End for 

//////////////////////////
//////////////////////////
$batch:="Daily Shortages"
CREATE RECORD:C68([y_batches:10])
[y_batches:10]BatchName:1:=$batch
SAVE RECORD:C53([y_batches:10])

ARRAY TEXT:C222($aWho; 0)
APPEND TO ARRAY:C911($aWho; "brian.hopkins@arkay.com")
APPEND TO ARRAY:C911($aWho; "jeff.drumheller@arkay.com")
APPEND TO ARRAY:C911($aWho; "Kristopher.Koertge@arkay.com")
APPEND TO ARRAY:C911($aWho; "mel.bohince@arkay.com")
APPEND TO ARRAY:C911($aWho; "mike.sanctuary@arkay.com")
APPEND TO ARRAY:C911($aWho; "john.sheridan@arkay.com")
APPEND TO ARRAY:C911($aWho; "paul.ladino@arkay.com")
APPEND TO ARRAY:C911($aWho; "chris.haymaker@arkay.com")
For ($email; 1; Size of array:C274($aWho))
	CREATE RECORD:C68([y_batch_distributions:164])
	[y_batch_distributions:164]BatchName:1:=$batch
	[y_batch_distributions:164]EmailAddress:2:=$aWho{$email}
	SAVE RECORD:C53([y_batch_distributions:164])
	UNLOAD RECORD:C212([y_batch_distributions:164])
End for 
