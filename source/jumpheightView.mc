import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class jumpheightView extends WatchUi.View {
    private var _calculator;
    private var _session;

    function initialize() {
        View.initialize();
        var app = Application.getApp() as jumpheightApp;
        _calculator = app.calculator;
        _session = app.session;
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var state = _calculator.getState();
        var width = dc.getWidth();
        var height_dc = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (state == STATE_START) {
            dc.drawText(width / 2, (height_dc * 0.38).toNumber(), Graphics.FONT_MEDIUM, "Jump Tests", Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width / 2, (height_dc * 0.54).toNumber(), Graphics.FONT_XTINY, "Press START", Graphics.TEXT_JUSTIFY_CENTER);
            
            var app = Application.getApp() as jumpheightApp;
            if (app.sensorService.getSampleRate() < 50) {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.drawText(width / 2, (height_dc * 0.66).toNumber(), Graphics.FONT_XTINY, "Low rate (<50Hz)", Graphics.TEXT_JUSTIFY_CENTER);
            }
        } 
        else if (state == STATE_PREPARING) {
            var count = _calculator.getCountdown();
            dc.drawText(width / 2, (height_dc * 0.22).toNumber(), Graphics.FONT_SMALL, "Hands on Hips!", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, (height_dc * 0.34).toNumber(), Graphics.FONT_TINY, "Hold Still...", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, (height_dc * 0.48).toNumber(), Graphics.FONT_NUMBER_THAI_HOT, (count + 1).format("%d"), Graphics.TEXT_JUSTIFY_CENTER);
        } 
        else if (state >= STATE_IDLE && state <= STATE_IN_AIR) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width / 2, (height_dc * 0.45).toNumber(), Graphics.FONT_LARGE, "JUMP!", Graphics.TEXT_JUSTIFY_CENTER);
        } 
        else if (state == STATE_LANDED) {
            var h = _calculator.getHeight();
            var r = _calculator.getRsiMod();
            
            dc.drawText(width / 2, (height_dc * 0.15).toNumber(), Graphics.FONT_TINY, "Result", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, (height_dc * 0.36).toNumber(), Graphics.FONT_MEDIUM, "Height: " + h.format("%.2f") + "m", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, (height_dc * 0.52).toNumber(), Graphics.FONT_MEDIUM, "RSImod: " + r.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER);
            
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            var msg = (_session.getJumpCount() == 2) ? "START: Finish" : "START: Next Jump";
            dc.drawText(width / 2, (height_dc * 0.76).toNumber(), Graphics.FONT_XTINY, msg, Graphics.TEXT_JUSTIFY_CENTER);
        }

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, (height_dc * 0.88).toNumber(), Graphics.FONT_XTINY, "Jump " + (_session.getJumpCount() + 1) + "/3", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Use UIUtils from the module
        if (state == STATE_START) {
            UIUtils.drawPagination(dc, 0, 5);
        }
    }
}
