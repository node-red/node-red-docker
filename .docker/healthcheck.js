var http = require('http');
var https = require('https');
var settings = require('/data/settings.js');
var request;

var options = {
    host : "localhost",
    port : settings.uiPort || 1880,
    timeout : 4000
};

if (settings.hasOwnProperty("https")) {
    request = https.request(options, (res) => {
        //console.log(`STATUS: ${res.statusCode}`);
        if (res.statusCode == 200) { process.exit(0); }
        else { process.exit(1); }
    });
}
else {
    request = http.request(options, (res) => {
        //console.log(`STATUS: ${res.statusCode}`);
        if (res.statusCode == 200) { process.exit(0); }
        else { process.exit(1); }
    });
}

request.on('error', function(err) {
    //console.log('ERROR',err);
    process.exit(1);
});

request.end(); 