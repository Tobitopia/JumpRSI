import Toybox.WatchUi;
import Toybox.Lang;

class RsiGraphDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onNextPage() as Boolean {
        var view = new jumpheightView();
        WatchUi.switchToView(view, new jumpheightDelegate(view), WatchUi.SLIDE_DOWN);
        return true;
    }

    function onPreviousPage() as Boolean {
        return onNextPage();
    }
}
