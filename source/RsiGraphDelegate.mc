import Toybox.WatchUi;
import Toybox.Lang;

class RsiGraphDelegate extends BaseDelegate {

    function initialize() {
        BaseDelegate.initialize();
    }

    function onSelect() as Boolean {
        return true;
    }

    function onNextPage() as Boolean {
        var view = new HeightGraphView();
        WatchUi.switchToView(view, new HeightGraphDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage() as Boolean {
        var view = new jumpheightView();
        WatchUi.switchToView(view, new jumpheightDelegate(view), WatchUi.SLIDE_DOWN);
        return true;
    }
}
