var eb, ctp = 3; //0 - WEB, 1 - PC, 2 - Mobile(ANDROID), 3 - Mobile(IOS), 4 - Table(ANDROID), 5 - (IOS)
    var sessionkey = "";
    var url_ = "";
    var connectStatus = 0;
    var languageType_ = 1;
    var clienthandler = function (err, msg) {
        var jsonResult = new Object();
        jsonResult["api"] = "push";
        jsonResult["result"] = msg;
        window.webkit.messageHandlers.send.postMessage(String(JSON.stringify(jsonResult)));
    };

    function disconnect(){
        alert("websocket.disconnect");
        connectStatus = 0;
        eb.sockJSConn.close();
    }
    function reConnect(url, uuid, languageType){
        disconnect();
        languageType_ = languageType==null?1:languageType;
        if(connectStatus != 0) return;
        url_ = url;
        connectStatus = 1;
        eb = new EventBus(url);
        eb.onopen = function() {
            connectStatus = 2;
//            window.webkit.messageHandlers.send.postMessage("open");
            alert("eventbus.onopen");

            var jsonHeader = new Object();
            jsonHeader["client"] = ctp;
            jsonHeader["languageType"] = 1;
            jsonHeader["UUID"] = uuid;


            var jsonBody = new Object();

            eb.send("websocket.apiauth", jsonBody, jsonHeader, function(err, msg){
                //Android.setSession(msg.body);
                connectStatus = 3;
                if(msg.body != "fail"){
                    sessionkey = msg.body;
                    var jsonHeader = new Object();
                    jsonHeader["client"] = ctp;
                    jsonHeader["UUID"] = sessionkey;
                    eb.registerHandler("client.api."+msg.body, jsonHeader, clienthandler);
                    connectStatus = 4;
                }

                var jsonResult = new Object();
                jsonResult["api"] = "auth";
                jsonResult["result"] = msg;
                window.webkit.messageHandlers.send.postMessage(String(JSON.stringify(jsonResult)));
            });

        };
        eb.onclose = function() {
//            connectStatus = 0;
//            if(connectStatus > 0){
//                window.webkit.messageHandlers.send.postMessage("close");
                alert("eventbus.onclose");
//            }
        };
    }
    function connect(url, uuid, languageType){
        alert("connect script");
        url_ = url;
        languageType_ = languageType==null?1:languageType;
        try {
            if(!eb && sessionkey != uuid && uuid.indexOf("/eventbus") == -1) {
                alert("eventbus first");
               openConn(url, uuid, languageType);
            }else{
                alert("eventbus second");
               openConn(url, uuid, languageType);
            }
        }catch(e){
//            alert("eventbus.onclose");
            alert("eventbus.connecterror");
        }
    }

    function openConn(url, uuid, languageType){
        languageType_ = languageType==null?1:languageType;
        alert("openConn");
        ebConnEvent(url);
        connEvent(uuid);
    }

    function ebConnEvent(url) {
        alert("ebConnEvent");
        alert(eb);
        if (eb == undefined || eb.state == EventBus.CLOSED) {

            if(connectStatus != 0) {
                alert(connectStatus);
                return;
            }
            connectStatus = 1;
            eb = new EventBus(url);
        }else{
            disconnect();
            connectStatus = 1;
            eb = new EventBus(url);
        }
    }

    function connEvent(uuid) {
        alert("connEvent");
        eb.onopen = function() {
            connectStatus = 2;
//            window.webkit.messageHandlers.send.postMessage("open");
            alert("eventbus.onopen");

            var jsonHeader = new Object();
            jsonHeader["client"] = ctp;
            jsonHeader["languageType"] = languageType_;

            var jsonBody = new Object();
            jsonBody["sessionkey"] = uuid;

            eb.send("websocket.apiauth", jsonBody, jsonHeader, function(err, msg){
                connectStatus = 3;
                if(msg.body != "fail"){
                    sessionkey = msg.body;
                    var jsonHeader = new Object();
                    jsonHeader["client"] = ctp;
                    jsonHeader["UUID"] = sessionkey;
                    eb.registerHandler("client.api."+msg.body, jsonHeader, clienthandler);
                    connectStatus = 4;
                }

                var jsonResult = new Object();
                jsonResult["api"] = "auth";
                jsonResult["result"] = msg;
                window.webkit.messageHandlers.send.postMessage(String(JSON.stringify(jsonResult)));
            });

        };
        eb.onclose = function() {
//            connectStatus = 0;
//            if(connectStatus > 0){
//                window.webkit.messageHandlers.send.postMessage("close");
                alert("eventbus.onclose");
//            }
        };
    }

    function send(address, headerString, bodyString, tag) {
        
        let saveTag = tag;
        
        if(connectStatus != 4) return false;
        var jsonHeader = new Object();
        jsonHeader["client"] = ctp;
        jsonHeader["UUID"] = sessionkey;
        jsonHeader["languageType"] = languageType_;

        if(headerString != ''){
            var header = JSON.parse(headerString);
//             alert("jsonHeader="+JSON.stringify(jsonHeader));
//             alert("headString="+headerString);
            for (var headerName in header) {
                if (header.hasOwnProperty(headerName)) {
                    if (typeof jsonHeader[headerName] === 'undefined') {
                        jsonHeader[headerName] = header[headerName];
                    }
                }
            }
//             alert("jsonHeader="+JSON.stringify(jsonHeader));
        }

        var jsonBody = new Object();

        if(bodyString != ''){
            var body = JSON.parse(bodyString.replace(/&#39;/g, "\'"));
//             alert("jsonBody="+JSON.stringify(jsonBody));
//             alert("bodyString="+bodyString);
            for (var bodyName in body) {
                if (body.hasOwnProperty(bodyName)) {
                    if (typeof jsonBody[bodyName] === 'undefined') {
                        jsonBody[bodyName] = body[bodyName];
                    }
                }
            }
//             alert("jsonBody="+JSON.stringify(jsonBody));
        }
        
        if(!eb) {
             alert("connect refused !!!");
            reConnect(url_, sessionkey);
        }else if((eb.state == EventBus.CONNECTING) || (eb.state == EventBus.CLOSED)) {
             alert("connect CLOSED !!!");
            reConnect(url_, sessionkey);
        }else{
//            alert(eb);
            
            eb.send(address, jsonBody, jsonHeader, function (err, msg) {
                var jsonResult = new Object();
                jsonResult["api"] = address;
                jsonResult["result"] = msg;
                jsonResult["bodyString"] = jsonBody;
                jsonResult["tag"] = saveTag;
                window.webkit.messageHandlers.send.postMessage(String(JSON.stringify(jsonResult)));
            });
        }
    }
    
    function isConnect(){
        alert("isConnect");
        alert("eventbus.connectStatus = " + connectStatus);
        if(connectStatus != 4){
            if(!eb) {
                alert("eventbus.false");
            }else if((eb.state == EventBus.CONNECTING) || (eb.state == EventBus.CLOSED)) {
                alert("eventbus.false");
            }else{
                if(connectStatus > 0) alert("eventbus.true");
                else alert("eventbus.false");
            }
        }else{
            alert("eventbus.true");
        }
    }

    function register(address, headerString) {
        if(connectStatus != 4) return false;
//         alert("[register]");
        var jsonHeader = new Object();
        jsonHeader["client"] = ctp;
        jsonHeader["UUID"] = sessionkey;
        jsonHeader["languageType"] = languageType_;

        if(headerString != ''){
            var header = JSON.parse(headerString);
// //             alert("jsonHeader="+JSON.stringify(jsonHeader));
//             alert("headString="+headString);
            for (var headerName in header) {
                if (header.hasOwnProperty(headerName)) {
                    if (typeof jsonHeader[headerName] === 'undefined') {
                        jsonHeader[headerName] = header[headerName];
                    }
                }
            }
//             alert("jsonHeader="+JSON.stringify(jsonHeader));
        }

        eb.registerHandler(address, jsonHeader, function (err, msg) {
            var jsonResult = new Object();
            jsonResult["api"] = address;
            jsonResult["result"] = msg;
            window.webkit.messageHandlers.send.postMessage(String(JSON.stringify(jsonResult)));
        });
    }

    function unregister(address, headerString){
        if(connectStatus != 4) return false;
//         alert("[unregister]");
        var jsonHeader = new Object();
        jsonHeader["client"] = ctp;
        jsonHeader["UUID"] = sessionkey;
        jsonHeader["languageType"] = languageType_;

        if(headerString != ''){
            var header = JSON.parse(headerString);
//             alert("jsonHeader="+JSON.stringify(jsonHeader));
//             alert("headString="+headString);
            for (var headerName in header) {
                if (header.hasOwnProperty(headerName)) {
                    if (typeof jsonHeader[headerName] === 'undefined') {
                        jsonHeader[headerName] = header[headerName];
                    }
                }
            }
//             alert("jsonHeader="+JSON.stringify(jsonHeader));
        }
        eb.unregisterHandler(address, jsonHeader, function (err, msg) {
            var jsonResult = new Object();
            jsonResult["api"] = address;
            jsonResult["result"] = msg;
            window.webkit.messageHandlers.send.postMessage(String(JSON.stringify(jsonResult)));
        });
    }