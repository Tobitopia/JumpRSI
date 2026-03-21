import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

class HeightGraphView extends WatchUi.View {
    private var _history as Array<Dictionary>;

    function initialize() {
        View.initialize();
        var app = Application.getApp() as jumpheightApp;
        _history = app.storageService.getHistory();
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var padding = 30;
        var graphWidth = width - (2 * padding);
        var graphHeight = height / 2;
        var bottom = (height / 2) + (graphHeight / 2) - 10;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 25, Graphics.FONT_SMALL, "Height History", Graphics.TEXT_JUSTIFY_CENTER);

        if (_history.size() == 0) {
            dc.drawText(width / 2, height / 2, Graphics.FONT_TINY, "No History Yet", Graphics.TEXT_JUSTIFY_CENTER);
            UIUtils.drawPagination(dc, 2, 4);
            return;
        }

        var startIdx = 0;
        if (_history.size() > 7) {
            startIdx = _history.size() - 7;
        }
        var count = _history.size() - startIdx;
        
        var maxVal = 0.01;
        for (var i = startIdx; i < _history.size(); i++) {
            var val = _history[i]["height"] as Float;
            if (val > maxVal) {
                maxVal = val;
            }
        }

        var barWidth = graphWidth / 7;
        var spacing = 4;

        for (var i = 0; i < count; i++) {
            var val = _history[startIdx + i]["height"] as Float;
            var barHeight = (val / maxVal) * graphHeight;
            
            var x = padding + (i * barWidth) + spacing;
            var y = bottom - barHeight;
            
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(x, y, barWidth - (2 * spacing), barHeight);
            
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(x + (barWidth / 2), bottom + 5, Graphics.FONT_XTINY, val.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER);
        }

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(padding, bottom, width - padding, bottom);
        
        UIUtils.drawPagination(dc, 2, 4);
    }
}

class HeightGraphDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onNextPage() as Boolean {
        var view = new InfoView();
        WatchUi.switchToView(view, new InfoDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage() as Boolean {
        var view = new RsiGraphView();
        WatchUi.switchToView(view, new RsiGraphDelegate(), WatchUi.SLIDE_DOWN);
        return true;
    }
}
