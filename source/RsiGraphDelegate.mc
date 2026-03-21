import Toybox.WatchUi;
import Toybox.Lang;

class RsiGraphDelegate extends WatchUi.BehaviorDelegate {
    private var _view as RsiGraphView;

    function initialize(view as RsiGraphView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Boolean {
        // Toggle feature removed as requested, now using separate views
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
