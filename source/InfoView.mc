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
            "measure power & fatigue.",
            "",
            "Full research, source",
            "& scientific background",
            "available on GitHub:",
            "github.com/tobitopia/",
            "JumpDiagnosticsGarmin"
        ];
        
        var y = 62;
        for (var i = 0; i < lines.size(); i++) {
            dc.drawText(width / 2, y, Graphics.FONT_XTINY, lines[i], Graphics.TEXT_JUSTIFY_CENTER);
            y += 18;
        }
        
        UIUtils.drawPagination(dc, 4, 5);
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
        var view = new SupportView();
        WatchUi.switchToView(view, new SupportDelegate(), WatchUi.SLIDE_DOWN);
        return true;
    }
}
