var doLog = 0;

var checkScenarios = func {
    var scenario = getprop("/sim/ai/scenario");
    var scenariosEnabled = scenario != nil and scenario != "";
    doLog = scenariosEnabled ? 1 : 0;
    # print("AI scenarios " ~ (doLog ? "enabled." : "not enabled."));
};

var getSafeValue = func(nodePath) {
    var node = props.globals.getNode(nodePath, 1);
    return node != nil ? node.getValue() : 0;
};

var logAITraffic = func {
    checkScenarios();
    if (doLog) {
        foreach( var tanker; props.globals.getNode("/ai/models",1).getChildren("ship") ) {
            var lat = getSafeValue(tanker.getPath() ~ "/position/latitude-deg");
            var lon = getSafeValue(tanker.getPath() ~ "/position/longitude-deg");
            if (lat != 0 and lon != 0) {
                var alt = geo.elevation(lat, lon);
                setprop("/ai/log", lat ~ "," ~ lon ~ "," ~ alt);
            }
        }
    }
    settimer(logAITraffic, 0.1); 
};

setlistener("/sim/ai/scenario", checkScenarios);
logAITraffic(); 
