import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

class jumpheightMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_history) {
            var view = new RsiGraphView();
            WatchUi.pushView(view, new RsiGraphDelegate(view), WatchUi.SLIDE_LEFT);
        }
    }

}