import Toybox.WatchUi;
import Toybox.Lang;

class RsiGraphDelegate extends WatchUi.BehaviorDelegate {
    private var _view as RsiGraphView;

    function initialize(view as RsiGraphView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Boolean {
        _view.toggleMode();
        return true;
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
