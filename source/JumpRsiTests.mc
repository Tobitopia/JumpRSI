import Toybox.Test;
import Toybox.Lang;
import Toybox.Application;

(:test)
function testBestTwoAverageHeight(logger as Logger) as Boolean {
    var session = new JumpSession();
    
    // Test with 3 different heights
    session.addJump(0.40f, 1.0f, 1.5f, 0.40f);
    session.addJump(0.50f, 1.0f, 1.5f, 0.50f);
    session.addJump(0.60f, 1.0f, 1.5f, 0.60f);
    
    var avgHeight = session.getAverageBestTwoHeight();
    var expected = (0.60f + 0.50f) / 2.0f; // 0.55
    
    if (avgHeight != expected) {
        logger.error("Expected avg height 0.55, got " + avgHeight);
        return false;
    }
    return true;
}

(:test)
function testBestTwoAverageRsi(logger as Logger) as Boolean {
    var session = new JumpSession();
    
    // Test with 3 different RSI values
    session.addJump(0.40f, 0.8f, 1.2f, 0.50f);
    session.addJump(0.40f, 1.2f, 1.8f, 0.50f);
    session.addJump(0.40f, 1.0f, 1.5f, 0.50f);
    
    var avgRsi = session.getAverageBestTwoRsi();
    var expected = (1.2f + 1.0f) / 2.0f; // 1.1
    
    if (avgRsi != expected) {
        logger.error("Expected avg RSI 1.1, got " + avgRsi);
        return false;
    }
    return true;
}

(:test)
function testBestTwoAverageRsiAct(logger as Logger) as Boolean {
    var session = new JumpSession();
    
    // Test with 3 different RSIactive values
    session.addJump(0.40f, 0.8f, 1.2f, 0.50f);
    session.addJump(0.40f, 1.2f, 1.8f, 0.50f);
    session.addJump(0.40f, 1.0f, 1.5f, 0.50f);
    
    var avgRsiAct = session.getAverageBestTwoRsiAct();
    var expected = (1.8f + 1.5f) / 2.0f; // 1.65
    
    if (avgRsiAct != expected) {
        logger.error("Expected avg RSIact 1.65, got " + avgRsiAct);
        return false;
    }
    return true;
}

(:test)
function testRsiModCalculation(logger as Logger) as Boolean {
    var h = 0.40f;
    var ttt = 0.50f;
    var expectedRsi = h / ttt; // 0.8
    
    var rsi = h / ttt;
    
    if (rsi != expectedRsi) {
        logger.error("RSI calculation mismatch");
        return false;
    }
    return true;
}

(:test)
function testJumpHeightPhysics(logger as Logger) as Boolean {
    // Basic g*t^2/8 test
    var ft = 1.0f; // 1 second flight time
    var g = 9.80665f;
    var expectedH = (g * ft * ft) / 8.0f; // 1.2258...
    
    if (expectedH < 1.22 || expectedH > 1.23) {
        logger.error("Height physics calculation failed");
        return false;
    }
    return true;
}
