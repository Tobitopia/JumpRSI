import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class InfoView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 25, Graphics.FONT_SMALL, "About JumpRSI", Graphics.TEXT_JUSTIFY_CENTER);
        
        var lines = [
            "JumpRSI uses RSIactive",
            "(active-phase RSI) to",
            "monitor readiness via",
            "the 1g upward crossing.",
            "",
            "This metric is more",
            "stable than RSImod for",
            "identifying fatigue",
            "on 50Hz wearable sensors."
        ];
        
        var y = 62;
        for (var i = 0; i < lines.size(); i++) {
            dc.drawText(width / 2, y, Graphics.FONT_XTINY, lines[i], Graphics.TEXT_JUSTIFY_CENTER);
            y += 18;
        }
        
        UIUtils.drawPagination(dc, 3, 5);
    }
}

class InfoDelegate extends BaseDelegate {

    function initialize() {
        BaseDelegate.initialize();
    }

    function onNextPage() as Boolean {
        var view = new SupportView();
        WatchUi.switchToView(view, new SupportDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage() as Boolean {
        var view = new HeightGraphView();
        WatchUi.switchToView(view, new HeightGraphDelegate(), WatchUi.SLIDE_DOWN);
        return true;
    }
}
