import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class InstructionsView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 30, Graphics.FONT_MEDIUM, "Instructions", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        var spacing = 22;
        var startY = 65;
        dc.drawText(width / 2, startY, Graphics.FONT_XTINY, "1. Arms to hips", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, startY + spacing, Graphics.FONT_XTINY, "2. Stand still during", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, startY + spacing + 12, Graphics.FONT_XTINY, "countdown", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, startY + (spacing * 2) + 12, Graphics.FONT_XTINY, "3. Perform CM jump", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, startY + (spacing * 3) + 20, Graphics.FONT_XTINY, "Takes 3 jumps, saves", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, startY + (spacing * 3) + 34, Graphics.FONT_XTINY, "avg. of best two", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height - 55, Graphics.FONT_XTINY, "Press START to begin", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class InstructionsDelegate extends BaseDelegate {
    function initialize() {
        BaseDelegate.initialize();
    }

    function onSelect() as Boolean {
        var app = Application.getApp() as jumpheightApp;
        app.calculator.startCountdown();
        WatchUi.switchToView(new jumpheightView(), new jumpheightDelegate(new jumpheightView()), WatchUi.SLIDE_LEFT);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.switchToView(new jumpheightView(), new jumpheightDelegate(new jumpheightView()), WatchUi.SLIDE_RIGHT);
        return true;
    }
}
