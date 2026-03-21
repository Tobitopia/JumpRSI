import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

class jumpheightMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        var app = Application.getApp() as jumpheightApp;
        if (item == :item_history) {
            WatchUi.pushView(new RsiGraphView(), new RsiGraphDelegate(), WatchUi.SLIDE_LEFT);
        } else if (item == :item_delete_last) {
            app.storageService.deleteLastJump();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        } else if (item == :item_clear_all) {
            app.storageService.clearHistory();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }

}