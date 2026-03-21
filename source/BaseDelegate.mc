import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Lang;

class BaseDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        var confirm = new WatchUi.Confirmation("Clear History?");
        WatchUi.pushView(confirm, new ClearHistoryConfirmationDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}

class ClearHistoryConfirmationDelegate extends WatchUi.ConfirmationDelegate {
    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(response) as Boolean {
        if (response == WatchUi.CONFIRM_YES) {
            var app = Application.getApp() as jumpheightApp;
            app.storageService.clearHistory();
        }
        return true;
    }
}
