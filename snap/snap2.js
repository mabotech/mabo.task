

var page = require('webpage').create();

//viewportSize being the actual size of the headless browser
page.viewportSize = { width: 1024, height: 768 };

//the clipRect is the portion of the page you are taking a screenshot of
page.clipRect = { top:145, left: 80, width: 1300, height: 360 };

//the rest of the code is the same as the previous example

var url1 = "http://127.0.0.1:3000/dashboard/db/tems"
//'http://127.0.0.1:8080/grid/#/'

page.open(url1, function() {

    // waiting for web page rendering
    setInterval(function() {
        
    page.render('equipments.png');
    
    phantom.exit();
        
    },1550)

});

