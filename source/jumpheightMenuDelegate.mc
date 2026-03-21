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
            WatchUi.pushView(new RsiGraphView(), new RsiGraphDelegate(), WatchUi.SLIDE_LEFT);
        }
    }

}