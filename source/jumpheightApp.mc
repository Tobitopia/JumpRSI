import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class jumpheightApp extends Application.AppBase {
    var calculator;
    var session;
    var sensorService;
    var storageService;

    function initialize() {
        AppBase.initialize();
        calculator = new JumpCalculator();
        session = new JumpSession();
        sensorService = new SensorService(calculator);
        storageService = new StorageService();
    }

    function onStart(state) as Void {
        // Optimization: Don't start sensor or timer here
    }

    function onStop(state) as Void {
        sensorService.stop();
        calculator.stopTimer();
    }

    function getInitialView() {
        var view = new jumpheightView();
        var delegate = new jumpheightDelegate(view);
        return [ view, delegate ];
    }
}

function getApp() as jumpheightApp {
    return Application.getApp() as jumpheightApp;
}
