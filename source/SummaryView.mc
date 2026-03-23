import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

class SummaryView extends WatchUi.View {
    private var _rsi as Float;
    private var _height as Float;
    private var _baseline as Float;
    private var _diff as Float;
    private var _recommendation as String;

    function initialize(rsi as Float, height as Float) {
        View.initialize();
        _rsi = rsi;
        _height = height;
        
        var app = Application.getApp() as jumpheightApp;
        _baseline = app.storageService.getBaseline();
        
        if (_baseline > 0) {
            _diff = ((_rsi - _baseline) / _baseline) * 100.0;
        } else {
            _diff = 0.0;
        }
        
        _recommendation = calculateRecommendation();
    }

    private function calculateRecommendation() as String {
        if (_baseline <= 0) {
            return "Establishing Baseline";
        }
        
        if (_diff > 5.0) {
            return "Peak Performance!";
        } else if (_diff > -5.0) {
            return "Steady - Ready to Go";
        } else if (_diff > -15.0) {
            return "Mild Fatigue - Be Careful";
        } else {
            return "High Fatigue - Rest Recommended";
        }
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height_dc = dc.getHeight();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 35, Graphics.FONT_SMALL, "Session Finished", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.drawText(width / 2, 75, Graphics.FONT_TINY, "Avg Height: " + _height.format("%.2f") + "m", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, 100, Graphics.FONT_TINY, "Avg RSImod: " + _rsi.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER);
        
        if (_baseline > 0) {
            var color = Graphics.COLOR_WHITE;
            if (_diff > 5.0) { color = Graphics.COLOR_GREEN; }
            else if (_diff < -15.0) { color = Graphics.COLOR_RED; }
            else if (_diff < -5.0) { color = Graphics.COLOR_ORANGE; }
            
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            var sign = _diff >= 0 ? "+" : "";
            dc.drawText(width / 2, 135, Graphics.FONT_SMALL, "vs Baseline: " + sign + _diff.format("%.1f") + "%", Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height_dc - 75, Graphics.FONT_XTINY, _recommendation, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height_dc - 50, Graphics.FONT_XTINY, "Press START to Restart", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class SummaryDelegate extends BaseDelegate {
    function initialize() {
        BaseDelegate.initialize();
    }

    function onSelect() as Boolean {
        var app = Application.getApp() as jumpheightApp;
        app.session.reset();
        app.calculator.resetToStart();
        var view = new jumpheightView();
        WatchUi.switchToView(view, new jumpheightDelegate(view), WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onBack() as Boolean {
        return onSelect();
    }
}
