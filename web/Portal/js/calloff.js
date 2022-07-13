// Globals
var columnDefs = [];
var gridOptions = {};

$(document).ready(function () {


		var ttQueryType = getAllUrlParams().mode;


		$( "#navbar" ).load( "navbar.html"); // Load Top Navbar
		// Next, load side bar menu
	
		$( "#sidebar" ).load( "sidbar.html", function() {
			$("#"+ttQueryType).addClass("active");

		});
	
		initProductCodeScreen();

	
	


});

function initProductCodeScreen(){

    loadSessionData(function (){
		if ( sessionObject.hasOwnProperty('callOffSubject') ) {
			$("#subject").val(sessionObject.callOffSubject);
		}	
		if ( sessionObject.hasOwnProperty('callOffBody') ) {
			$("#body").val(sessionObject.callOffBody);
		}	

});
 
};




    





function fillGrid(ttQueryType, queryValue) {


	// lookup the container we want the Grid to use
	document.getElementById('myGrid').innerHTML = ''; // Force refreshing of grid
	var eGridDiv = document.querySelector('#myGrid');

	// create the grid passing in the div to use together with the columns & data we want to use
	new agGrid.Grid(eGridDiv, gridOptions);

	//Call to the API

	url = "/portal/portal?portal=customer_Portal&action=" + ttQueryType + "&queryString=" + queryValue ;

	fetch(url).then(function (response) {
		var ttResponse = response.json();
		return ttResponse;
	}).then(function (resp) {
		gridOptions.api.setRowData(resp.data);
	});

};





