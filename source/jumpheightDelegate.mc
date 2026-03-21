import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application;

class jumpheightDelegate extends WatchUi.BehaviorDelegate {

    function initialize(view as jumpheightView) {
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        var app = Application.getApp() as jumpheightApp;
        var state = app.calculator.getState();

        if (state == STATE_START) {
            app.calculator.startCountdown();
        } 
        else if (state == STATE_LANDED) {
            var h = app.calculator.getHeight();
            var r = app.calculator.getRsiMod();
            var t = app.calculator.getTtt();
            
            app.session.addJump(h, r, t);
            
            if (app.session.isComplete()) {
                var avgRsi = app.session.getAverageBestTwoRsi();
                var avgHeight = app.session.getAverageBestTwoHeight();
                app.storageService.saveTodayJump(avgRsi, avgHeight);
                
                // Switch to SummaryView instead of resetting immediately
                WatchUi.switchToView(new SummaryView(avgRsi, avgHeight), new SummaryDelegate(), WatchUi.SLIDE_LEFT);
            } else {
                app.calculator.resetToStart();
            }
        }
        
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage() as Boolean {
        var view = new RsiGraphView();
        WatchUi.switchToView(view, new RsiGraphDelegate(view), WatchUi.SLIDE_UP);
        return true;
    }

    function onPreviousPage() as Boolean {
        var view = new InfoView();
        WatchUi.switchToView(view, new InfoDelegate(), WatchUi.SLIDE_DOWN);
        return true;
    }

    function onBack() as Boolean {
        var app = Application.getApp() as jumpheightApp;
        var state = app.calculator.getState();
        
        if (state == STATE_START) {
            // Allow default back behavior (exit app) if at start
            return false;
        }
        
        // Otherwise reset to start
        app.session.reset();
        app.calculator.resetToStart();
        WatchUi.requestUpdate();
        return true;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new jumpheightMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}
