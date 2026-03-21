import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Lang;

class BaseDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new jumpheightMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}
