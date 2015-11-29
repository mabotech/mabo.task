

var page = require('webpage').create();

//viewportSize being the actual size of the headless browser
page.viewportSize = { width: 1920, height: 1080 };

//the clipRect is the portion of the page you are taking a screenshot of
page.clipRect = { top:85, left: 18, width: 630, height: 200 };

//the rest of the code is the same as the previous example

var url = "http://127.0.0.1:3000/dashboard/db/last_month"
//'http://127.0.0.1:8080/grid/#/'

page.open(url, function() {

    // waiting for web page rendering
    setInterval(function() {
        
    page.render('pmonth3.png');
    
    phantom.exit();
        
    },1550)

});

