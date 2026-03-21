import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class SupportView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 25, Graphics.FONT_SMALL, "Support & Help", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 65, Graphics.FONT_XTINY, "Support Developer (1€)", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 85, Graphics.FONT_XTINY, "paypal.me/tobitopia", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 125, Graphics.FONT_XTINY, "Contribute / Issues", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 145, Graphics.FONT_XTINY, "github.com/tobitopia/", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, 160, Graphics.FONT_XTINY, "JumpDiagnosticsGarmin", Graphics.TEXT_JUSTIFY_CENTER);
        
        UIUtils.drawPagination(dc, 3, 5);
    }
}

class SupportDelegate extends BaseDelegate {
    function initialize() {
        BaseDelegate.initialize();
    }

    function onNextPage() as Boolean {
        var view = new InfoView();
        WatchUi.switchToView(view, new InfoDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage() as Boolean {
        var view = new HeightGraphView();
        WatchUi.switchToView(view, new HeightGraphDelegate(), WatchUi.SLIDE_DOWN);
        return true;
    }
}
