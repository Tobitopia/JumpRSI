import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class jumpheightApp extends Application.AppBase {
    var calculator;
    var session;
    var sensorService;
    var storageService;
    var timer;

    function initialize() {
        AppBase.initialize();
        calculator = new JumpCalculator();
        session = new JumpSession();
        sensorService = new SensorService(calculator);
        storageService = new StorageService();
    }

    function onStart(state) as Void {
        sensorService.start();
        timer = new Timer.Timer();
        timer.start(method(:onTimer), 1000, true);
    }

    function onStop(state) as Void {
        sensorService.stop();
        if (timer != null) {
            timer.stop();
        }
    }

    function onTimer() as Void {
        if (calculator.getState() == STATE_PREPARING) {
            calculator.tickCountdown();
        }
        WatchUi.requestUpdate();
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
