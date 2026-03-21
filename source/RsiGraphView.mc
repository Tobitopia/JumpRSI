import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

class RsiGraphView extends WatchUi.View {
    private var _history as Array<Dictionary>;
    private var _showRsi as Boolean = true;

    function initialize() {
        View.initialize();
        var app = Application.getApp() as jumpheightApp;
        _history = app.storageService.getHistory();
    }

    function toggleMode() as Void {
        _showRsi = !_showRsi;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var padding = 30;
        var graphWidth = width - (2 * padding);
        var graphHeight = height / 2;
        var bottom = (height / 2) + (graphHeight / 2);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var title = _showRsi ? "RSI History" : "Height History";
        dc.drawText(width / 2, 20, Graphics.FONT_SMALL, title, Graphics.TEXT_JUSTIFY_CENTER);

        if (_history.size() == 0) {
            dc.drawText(width / 2, height / 2, Graphics.FONT_TINY, "No History Yet", Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }

        // Get last 7
        var startIdx = 0;
        if (_history.size() > 7) {
            startIdx = _history.size() - 7;
        }
        var count = _history.size() - startIdx;
        
        // Find Max for scaling
        var maxVal = 0.01;
        var field = _showRsi ? "rsi" : "height";
        for (var i = startIdx; i < _history.size(); i++) {
            var val = _history[i][field] as Float;
            if (val > maxVal) {
                maxVal = val;
            }
        }

        var barWidth = graphWidth / 7;
        var spacing = 4;

        for (var i = 0; i < count; i++) {
            var val = _history[startIdx + i][field] as Float;
            var barHeight = (val / maxVal) * graphHeight;
            
            var x = padding + (i * barWidth) + spacing;
            var y = bottom - barHeight;
            
            var color = _showRsi ? Graphics.COLOR_BLUE : Graphics.COLOR_ORANGE;
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(x, y, barWidth - (2 * spacing), barHeight);
            
            // Label value
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            var format = _showRsi ? "%.1f" : "%.2f";
            dc.drawText(x + (barWidth / 2), bottom + 5, Graphics.FONT_XTINY, val.format(format), Graphics.TEXT_JUSTIFY_CENTER);
        }

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(padding, bottom, width - padding, bottom);
        
        dc.drawText(width / 2, height - 30, Graphics.FONT_XTINY, "Press START to toggle", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
