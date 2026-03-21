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
            "Uses the RSImod metric,",
            "scientifically proven to",
            "measure neuromuscular",
            "readiness and power.",
            "Higher RSI means better",
            "recovery & explosive force.",
            "Use daily to optimize",
            "training intensity."
        ];
        
        var y = 62;
        for (var i = 0; i < lines.size(); i++) {
            dc.drawText(width / 2, y, Graphics.FONT_XTINY, lines[i], Graphics.TEXT_JUSTIFY_CENTER);
            y += 20;
        }
        
        UIUtils.drawPagination(dc, 3, 4);
    }
}

class InfoDelegate extends BaseDelegate {

    function initialize() {
        BaseDelegate.initialize();
    }


    function onNextPage() as Boolean {
        var view = new jumpheightView();
        WatchUi.switchToView(view, new jumpheightDelegate(view), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage() as Boolean {
        var view = new HeightGraphView();
        WatchUi.switchToView(view, new HeightGraphDelegate(), WatchUi.SLIDE_DOWN);
        return true;
    }
}
