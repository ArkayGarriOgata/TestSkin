// this does nothing right now because of the illegal use of cross-domain access
// All calls using fourDWebRequest use the same domain as the site
var globalIPAddress = 'localhost';
var globalPort = '7010';

var oUserInfo = {};
var sessionObject = {};




$(document).ready(function () {
// Init here


});



// FUNCTIONS


function getAllUrlParams(url) {

    // get query string from url (optional) or window
    var queryString = url ? url.split('?')[1] : window.location.search.slice(1);
  
    // we'll store the parameters here
    var obj = {};
  
    // if query string exists
    if (queryString) {
  
      // stuff after # is not part of query string, so get rid of it
      queryString = queryString.split('#')[0];
  
      // split our query string into its component parts
      var arr = queryString.split('&');
  
      for (var i = 0; i < arr.length; i++) {
        // separate the keys and the values
        var a = arr[i].split('=');
  
        // set parameter name and value (use 'true' if empty)
        var paramName = a[0];
        var paramValue = typeof (a[1]) === 'undefined' ? true : a[1];
  
        // (optional) keep case consistent
        paramName = paramName.toLowerCase();
        if (typeof paramValue === 'string') paramValue = paramValue.toLowerCase();
  
        // if the paramName ends with square brackets, e.g. colors[] or colors[2]
        if (paramName.match(/\[(\d+)?\]$/)) {
  
          // create key if it doesn't exist
          var key = paramName.replace(/\[(\d+)?\]/, '');
          if (!obj[key]) obj[key] = [];
  
          // if it's an indexed array e.g. colors[2]
          if (paramName.match(/\[\d+\]$/)) {
            // get the index value and add the entry at the appropriate position
            var index = /\[(\d+)\]/.exec(paramName)[1];
            obj[key][index] = paramValue;
          } else {
            // otherwise add the value to the end of the array
            obj[key].push(paramValue);
          }
        } else {
          // we're dealing with a string
          if (!obj[paramName]) {
            // if it doesn't exist, create property
            obj[paramName] = paramValue;
          } else if (obj[paramName] && typeof obj[paramName] === 'string'){
            // if property does exist and it's a string, convert it to an array
            obj[paramName] = [obj[paramName]];
            obj[paramName].push(paramValue);
          } else {
            // otherwise add the property
            obj[paramName].push(paramValue);
          }
        }
      }
    }
  
    return obj;
};



function loadSessionData(fOnSuccess){


    oUserInfo = {};

	var theRequest = new FourDWebRequest();
	theRequest.initWithAddress("", "","customer_Portal");
	theRequest.addParameter('Action', "GetSessionObject");

	theRequest.sendRequest(true, function() {
										   var ttResponse = this.fourDResponse;
										   if(ttResponse.length >0){
												var obReturn = JSON.parse(ttResponse);
												sessionObject = obReturn.SessionObject;


												if ( sessionObject.hasOwnProperty('userRecord') ) {
													oUserInfo = sessionObject.userRecord;
												}	


												if(isLoggedIn()){
													$("#wrapper").show(); // Show the Screen now they we are logged in

                                                    fOnSuccess.call();// Call the function if loaded

												}else{
													window.location.href = 'login.html';

													//$("#WorkoutListScreenDiv").hide();
													//$("#LoginScreenDiv").show();
													// Hide main, show login screen
												}
											
																						
										   } else {
											   alert("An error occurred, the request cannot be processed.");
										   }
										}, 
										function()
										{
											alert('error: '+this.fourDError)
										}
							);


};





function doLogin(){

	$("#loginError").hide();

	var theRequest = new FourDWebRequest();
	theRequest.initWithAddress("", "","customer_Portal");
	theRequest.addParameter('Action', "doLogin");
	
	theRequest.addParameter('Username', $("#UserNameField").val() );
	theRequest.addParameter('Password', $("#PasswordField").val() );


	theRequest.sendRequest(true, function() {
										var ttResponse = this.fourDResponse;
										if(ttResponse.length >0){
											var obReturn = JSON.parse(ttResponse);

											if (obReturn.success == true){

												window.location.href = 'productCode.html';

											}else{
												$("#loginError").html(obReturn.errorText);
												$("#loginError").show();
											}
											
																						
										} else {
											alert("An error occurred, the request cannot be processed.");
										}
										}, 
										function()
										{
											alert('error: '+this.fourDError)
										}
							);



}





function initSummaryEntry(){
    var ttID = getAllUrlParams().wid;
	$("#selectedWorkoutID").val(ttID);
	
	summarizeWorkout();
};


function isLoggedIn(){
	var fReturn = false;
	
	if ( sessionObject.hasOwnProperty('IsLoggedIn') ) {
		fReturn = sessionObject.IsLoggedIn;
	}	

	return fReturn;
};








function logout(){
	var theRequest = new FourDWebRequest();
	theRequest.initWithAddress("", "","customer_Portal");
	theRequest.addParameter('Action', "logout");

	theRequest.sendRequest(true, function() {
										var ttResponse = this.fourDResponse;
										if(ttResponse.length >0){
											var obReturn = JSON.parse(ttResponse);

											if (obReturn.success == true){

												
												window.location.href = "login.html";
												
											}
											
																						
										} else {
											alert("An error occurred, the request cannot be processed.");
										}
										}, 
										function()
										{
											alert('error: '+this.fourDError)
										}
							);

}






function openPopup(ttID){

	$( ttID ).popup( "open" )
}

function closePopup(ttID){

	$( ttID ).popup( "close" )
}


