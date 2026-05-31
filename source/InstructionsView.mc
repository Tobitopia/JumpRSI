import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

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
        dc.drawText(width / 2, 20, Graphics.FONT_SMALL, "Instructions", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        var spacing = 18;
        var startY = 48;
        dc.drawText(width / 2, startY, Graphics.FONT_XTINY, "1. Arms to hips", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, startY + spacing, Graphics.FONT_XTINY, "2. Stand still for 3s", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, startY + (spacing * 2), Graphics.FONT_XTINY, "3. Perform CM jump", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, startY + (spacing * 3) + 2, Graphics.FONT_XTINY, "Saves avg. of best 2 of 3", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, startY + (spacing * 4) + 6, Graphics.FONT_XTINY, "Scroll down for example", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height - 35, Graphics.FONT_XTINY, "Press START to begin", Graphics.TEXT_JUSTIFY_CENTER);
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

    function onNextPage() as Boolean {
        WatchUi.switchToView(new ExampleView(), new ExampleDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.switchToView(new jumpheightView(), new jumpheightDelegate(new jumpheightView()), WatchUi.SLIDE_RIGHT);
        return true;
    }
}

class ExampleView extends WatchUi.View {
    private var _image;

    function initialize() {
        View.initialize();
    }

    function onShow() as Void {
        _image = WatchUi.loadResource(Rez.Drawables.CMJ_Example);
    }

    function onHide() as Void {
        _image = null;
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        if (_image != null) {
            var imgWidth = _image.getWidth();
            var imgHeight = _image.getHeight();
            var x = (width - imgWidth) / 2;
            var y = (height - imgHeight) / 2;
            dc.drawBitmap(x, y, _image);
        }
    }
}

class ExampleDelegate extends BaseDelegate {
    function initialize() {
        BaseDelegate.initialize();
    }

    function onSelect() as Boolean {
        var app = Application.getApp() as jumpheightApp;
        app.calculator.startCountdown();
        WatchUi.switchToView(new jumpheightView(), new jumpheightDelegate(new jumpheightView()), WatchUi.SLIDE_LEFT);
        return true;
    }

    function onPreviousPage() as Boolean {
        WatchUi.switchToView(new InstructionsView(), new InstructionsDelegate(), WatchUi.SLIDE_DOWN);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.switchToView(new jumpheightView(), new jumpheightDelegate(new jumpheightView()), WatchUi.SLIDE_RIGHT);
        return true;
    }
}

