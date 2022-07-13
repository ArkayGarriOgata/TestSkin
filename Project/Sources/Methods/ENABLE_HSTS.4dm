//%attributes = {"executedOnServer":true}
// _______
// Method: ENABLE_HSTS   ( ) ->
// By: Mel Bohince @ 03/17/20, 16:28:45
// Description
// HSTS stands for HTTP Strict Transport Security, it essentially redirects any HTTP request to an HTTPS request.
// ----------------------------------------------------
//this is executed on the server

WEB SET OPTION:C1210(Web HSTS enabled:K73:26; 1)