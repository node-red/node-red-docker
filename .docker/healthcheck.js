var http = require('http');
var https = require('https');

var options = {
    host : "bf3a15f6.ngrok.io",
    port : "443",
    timeout : 10000
};

var fail = false;

var request = http.request(options, (res) => {
    //console.log(`STATUS: ${res.statusCode}`);
    if (res.statusCode == 200) {
        process.exit(0);
    }
    else {
        fail = true;
    }
});

var requests = https.request(options, (res) => {
    //console.log(`STATUSS: ${res.statusCode}`);
    if (res.statusCode == 200) {
        process.exit(0);
    }
    else {
        fail = true;
    }
});

request.on('error', function(err) {
    //console.log('ERROR',err);
});

requests.on('error', function(err) {
    //console.log('ERRORS',err);
});

setTimeout(function() {
    if (fail) { process.exit(1); }
    else { process.exit(0); }  // should never get here :-)
},5000)

request.end(); 
requests.end(); 
