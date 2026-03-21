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
        if (item == :item_delete_last) {
            app.storageService.deleteLastJump();
            app.calculator.resetToStart();
            var view = new jumpheightView();
            WatchUi.switchToView(view, new jumpheightDelegate(view), WatchUi.SLIDE_IMMEDIATE);
        } else if (item == :item_clear_all) {
            app.storageService.clearHistory();
            app.calculator.resetToStart();
            var view = new jumpheightView();
            WatchUi.switchToView(view, new jumpheightDelegate(view), WatchUi.SLIDE_IMMEDIATE);
        }
    }

}