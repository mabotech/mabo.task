"use strict";

/*
*  listen PostgreSQL NOTIFY and take action"
*/
//var nconf = require('nconf');
var winston = require('winston');

//var moment = require('moment');

var log = winston.loggers.add('server', {
    console: {
        //silent:true,
        level: 'debug',
        colorize: 'true',
        label: 'server'
    },
    file: {
        filename: 'logs/pgli.log',
        label: 'server',
        level: 'debug',
        json: false,
        maxsize: 10240000,
        maxFiles: 10
    }
});

var utils = require("./lib/utils");
var actions = require("./lib/actions");


var pg = require('pg');
var con_string = "postgres://mabotech:mabouser@localhost:6432/maboss";
var client = new pg.Client(con_string);

client.connect();

var channel_list = ["job", "q"];

for(var channel in channel_list){
    
    console.log(channel_list[channel]);
    client.query('LISTEN '+ channel_list[channel]);
}
//client.query('LISTEN q');

/*
* parse msg and get action type, name and parameters
* actionType, actionName, Params (in json)
* or {"type":"type"， "name":"name", "params":{...} }
*/


/*
*
*/

var dispatch = function(type, name, params){
    
    switch( type ){
        
        case "mail":
            actions.sendMail(params);
            break;
        case "job":
            actions.createJob(name, params);
            break;
        default:
            log.error("no action", type, name, params)
        }
    

}

/*
* NOTIFY job, '{ "type":"type"， "name":"name", "params":{"val":"2"}}';
*  NOTIFY q, 'queue';
*/

client.on('notification', function(msg) {
    
console.log('msg:', msg);   

    var payload;
    
    var vals = utils.msgParse(msg);
    
    var type = vals[0];
    var name = vals[1];
    var params = vals[2];
    
    log.debug(">>", type, name, params);

    if (type != null){   
    
        
        dispatch(type, name, params);        
        
    }
    else{
        
    }
    
   
    /*
    
msg: { name: 'notification',
  length: 16,
  processId: 25188,
  channel: 'job',
  payload: 'xyz' }
msg: { name: 'notification',
  length: 16,
  processId: 25188,
  channel: 'q',
  payload: 'queue' }
    
    */
});

/*
test

NOTIFY job, '{ "type":"job","name":"job1", "params":{"val":"2"}}';

NOTIFY job, '{ "type":"mail","name":"mail", "params":{"from":"abc@163.com"}}';


*/