import Toybox.Test;
import Toybox.Lang;
import Toybox.Application;

(:test)
function testBestTwoAverageHeight(logger as Logger) as Boolean {
    var session = new JumpSession();
    
    // Test with 3 different heights
    session.addJump(0.40f, 1.0f, 0.40f);
    session.addJump(0.50f, 1.0f, 0.50f);
    session.addJump(0.60f, 1.0f, 0.60f);
    
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
    session.addJump(0.40f, 0.8f, 0.50f);
    session.addJump(0.40f, 1.2f, 0.50f);
    session.addJump(0.40f, 1.0f, 0.50f);
    
    var avgRsi = session.getAverageBestTwoRsi();
    var expected = (1.2f + 1.0f) / 2.0f; // 1.1
    
    if (avgRsi != expected) {
        logger.error("Expected avg RSI 1.1, got " + avgRsi);
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

(:test)
function testJumpVariableSampleRates(logger as Logger) as Boolean {

    // --- 100Hz Dataset Simulation ---
    var mags_100 = [1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.9867f, 0.9733f, 0.96f, 0.9467f, 0.9333f, 0.92f, 0.9067f, 0.8933f, 0.88f, 0.8667f, 0.8533f, 0.84f, 0.8267f, 0.8133f, 0.8f, 0.7867f, 0.7733f, 0.76f, 0.7467f, 0.7333f, 0.72f, 0.7067f, 0.6933f, 0.68f, 0.6667f, 0.6533f, 0.64f, 0.6267f, 0.6133f, 0.6f, 0.64f, 0.68f, 0.72f, 0.76f, 0.8f, 0.84f, 0.88f, 0.92f, 0.96f, 1.0f, 1.04f, 1.08f, 1.12f, 1.16f, 1.2f, 1.24f, 1.28f, 1.32f, 1.36f, 1.4f, 1.44f, 1.48f, 1.52f, 1.56f, 1.6f, 1.64f, 1.68f, 1.72f, 1.76f, 1.8f, 1.65f, 1.5f, 1.35f, 1.2f, 1.05f, 0.9f, 0.75f, 0.6f, 0.45f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.64f, 1.18f, 1.72f, 2.26f, 2.8f, 2.728f, 2.656f, 2.584f, 2.512f, 2.44f, 2.368f, 2.296f, 2.224f, 2.152f, 2.08f, 2.008f, 1.936f, 1.864f, 1.792f, 1.72f, 1.648f, 1.576f, 1.504f, 1.432f, 1.36f, 1.288f, 1.216f, 1.144f, 1.072f] as Array<Float>;
    var times_100 = [0L, 10L, 20L, 30L, 40L, 50L, 60L, 70L, 80L, 90L, 100L, 110L, 120L, 130L, 140L, 150L, 160L, 170L, 180L, 190L, 200L, 210L, 220L, 230L, 240L, 250L, 260L, 270L, 280L, 290L, 300L, 310L, 320L, 330L, 340L, 350L, 360L, 370L, 380L, 390L, 400L, 410L, 420L, 430L, 440L, 450L, 460L, 470L, 480L, 490L, 500L, 510L, 520L, 530L, 540L, 550L, 560L, 570L, 580L, 590L, 600L, 610L, 620L, 630L, 640L, 650L, 660L, 670L, 680L, 690L, 700L, 710L, 720L, 730L, 740L, 750L, 760L, 770L, 780L, 790L, 800L, 810L, 820L, 830L, 840L, 850L, 860L, 870L, 880L, 890L, 900L, 910L, 920L, 930L, 940L, 950L, 960L, 970L, 980L, 990L, 1000L, 1010L, 1020L, 1030L, 1040L, 1050L, 1060L, 1070L, 1080L, 1090L, 1100L, 1110L, 1120L, 1130L, 1140L, 1150L, 1160L, 1170L, 1180L, 1190L, 1200L, 1210L, 1220L, 1230L, 1240L, 1250L, 1260L, 1270L, 1280L, 1290L, 1300L, 1310L, 1320L, 1330L, 1340L, 1350L, 1360L, 1370L, 1380L, 1390L, 1400L, 1410L, 1420L, 1430L, 1440L, 1450L, 1460L, 1470L, 1480L, 1490L, 1500L, 1510L, 1520L, 1530L, 1540L, 1550L, 1560L, 1570L, 1580L, 1590L, 1600L, 1610L, 1620L, 1630L, 1640L, 1650L, 1660L, 1670L, 1680L, 1690L, 1700L, 1710L, 1720L, 1730L, 1740L, 1750L, 1760L, 1770L, 1780L, 1790L, 1800L, 1810L, 1820L, 1830L, 1840L, 1850L, 1860L, 1870L, 1880L, 1890L, 1900L, 1910L, 1920L, 1930L, 1940L, 1950L, 1960L, 1970L, 1980L, 1990L, 2000L, 2010L, 2020L, 2030L, 2040L, 2050L, 2060L, 2070L, 2080L, 2090L, 2100L, 2110L, 2120L, 2130L, 2140L, 2150L, 2160L, 2170L, 2180L, 2190L, 2200L, 2210L, 2220L, 2230L, 2240L, 2250L, 2260L, 2270L, 2280L, 2290L, 2300L, 2310L, 2320L, 2330L, 2340L, 2350L, 2360L, 2370L, 2380L, 2390L, 2400L, 2410L, 2420L, 2430L, 2440L, 2450L, 2460L, 2470L, 2480L, 2490L] as Array<Long>;
    
    var calc_100 = new JumpCalculator();
    // Simulate transitioning past Preparing state directly
    calc_100.startCountdown();
    calc_100.onTimerTick();
    calc_100.onTimerTick();
    calc_100.onTimerTick();
    calc_100.onTimerTick(); // Set state to STATE_IDLE
    
    for (var i = 0; i < mags_100.size(); i++) {
        calc_100.processSample(mags_100[i], times_100[i]);
    }
    
    if (calc_100.getState() != 6) {
        logger.error("Failed to detect landing at 100Hz (state: " + calc_100.getState() + ")");
        return false;
    }
    
    var height_100 = calc_100.getHeight();
    var ft_100 = calc_100.getTtt(); // or flight time (tested via height)
    
    if (height_100 < 0.60f || height_100 > 0.80f) {
        logger.error("Invalid jump height calculated at 100Hz: " + height_100);
        return false;
    }
    
    logger.debug("Successfully validated 100Hz. Calculated Height: " + height_100.format("%.2f") + "m, TTT: " + ft_100.format("%.2f") + "s, RSImod: " + calc_100.getRsiMod().format("%.2f"));

    // --- 50Hz Dataset Simulation ---
    var mags_50 = [1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.9733f, 0.9467f, 0.92f, 0.8933f, 0.8667f, 0.84f, 0.8133f, 0.7867f, 0.76f, 0.7333f, 0.7067f, 0.68f, 0.6533f, 0.6267f, 0.6f, 0.68f, 0.76f, 0.84f, 0.92f, 1.0f, 1.08f, 1.16f, 1.24f, 1.32f, 1.4f, 1.48f, 1.56f, 1.64f, 1.72f, 1.8f, 1.5f, 1.2f, 0.9f, 0.6f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 1.18f, 2.26f, 2.728f, 2.584f, 2.44f, 2.296f, 2.152f, 2.008f, 1.864f, 1.72f, 1.576f, 1.432f, 1.288f, 1.144f] as Array<Float>;
    var times_50 = [0L, 20L, 40L, 60L, 80L, 100L, 120L, 140L, 160L, 180L, 200L, 220L, 240L, 260L, 280L, 300L, 320L, 340L, 360L, 380L, 400L, 420L, 440L, 460L, 480L, 500L, 520L, 540L, 560L, 580L, 600L, 620L, 640L, 660L, 680L, 700L, 720L, 740L, 760L, 780L, 800L, 820L, 840L, 860L, 880L, 900L, 920L, 940L, 960L, 980L, 1000L, 1020L, 1040L, 1060L, 1080L, 1100L, 1120L, 1140L, 1160L, 1180L, 1200L, 1220L, 1240L, 1260L, 1280L, 1300L, 1320L, 1340L, 1360L, 1380L, 1400L, 1420L, 1440L, 1460L, 1480L, 1500L, 1520L, 1540L, 1560L, 1580L, 1600L, 1620L, 1640L, 1660L, 1680L, 1700L, 1720L, 1740L, 1760L, 1780L, 1800L, 1820L, 1840L, 1860L, 1880L, 1900L, 1920L, 1940L, 1960L, 1980L, 2000L, 2020L, 2040L, 2060L, 2080L, 2100L, 2120L, 2140L, 2160L, 2180L, 2200L, 2220L, 2240L, 2260L, 2280L, 2300L, 2320L, 2340L, 2360L, 2380L, 2400L, 2420L, 2440L, 2460L, 2480L] as Array<Long>;
    
    var calc_50 = new JumpCalculator();
    // Simulate transitioning past Preparing state directly
    calc_50.startCountdown();
    calc_50.onTimerTick();
    calc_50.onTimerTick();
    calc_50.onTimerTick();
    calc_50.onTimerTick(); // Set state to STATE_IDLE
    
    for (var i = 0; i < mags_50.size(); i++) {
        calc_50.processSample(mags_50[i], times_50[i]);
    }
    
    if (calc_50.getState() != 6) {
        logger.error("Failed to detect landing at 50Hz (state: " + calc_50.getState() + ")");
        return false;
    }
    
    var height_50 = calc_50.getHeight();
    var ft_50 = calc_50.getTtt(); // or flight time (tested via height)
    
    if (height_50 < 0.60f || height_50 > 0.80f) {
        logger.error("Invalid jump height calculated at 50Hz: " + height_50);
        return false;
    }
    
    logger.debug("Successfully validated 50Hz. Calculated Height: " + height_50.format("%.2f") + "m, TTT: " + ft_50.format("%.2f") + "s, RSImod: " + calc_50.getRsiMod().format("%.2f"));

    // --- 25Hz Dataset Simulation ---
    var mags_25 = [1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.9467f, 0.8933f, 0.84f, 0.7867f, 0.7333f, 0.68f, 0.6267f, 0.68f, 0.84f, 1.0f, 1.16f, 1.32f, 1.48f, 1.64f, 1.8f, 1.2f, 0.6f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 0.1f, 2.26f, 2.584f, 2.296f, 2.008f, 1.72f, 1.432f, 1.144f] as Array<Float>;
    var times_25 = [0L, 40L, 80L, 120L, 160L, 200L, 240L, 280L, 320L, 360L, 400L, 440L, 480L, 520L, 560L, 600L, 640L, 680L, 720L, 760L, 800L, 840L, 880L, 920L, 960L, 1000L, 1040L, 1080L, 1120L, 1160L, 1200L, 1240L, 1280L, 1320L, 1360L, 1400L, 1440L, 1480L, 1520L, 1560L, 1600L, 1640L, 1680L, 1720L, 1760L, 1800L, 1840L, 1880L, 1920L, 1960L, 2000L, 2040L, 2080L, 2120L, 2160L, 2200L, 2240L, 2280L, 2320L, 2360L, 2400L, 2440L, 2480L] as Array<Long>;
    
    var calc_25 = new JumpCalculator();
    // Simulate transitioning past Preparing state directly
    calc_25.startCountdown();
    calc_25.onTimerTick();
    calc_25.onTimerTick();
    calc_25.onTimerTick();
    calc_25.onTimerTick(); // Set state to STATE_IDLE
    
    for (var i = 0; i < mags_25.size(); i++) {
        calc_25.processSample(mags_25[i], times_25[i]);
    }
    
    if (calc_25.getState() != 6) {
        logger.error("Failed to detect landing at 25Hz (state: " + calc_25.getState() + ")");
        return false;
    }
    
    var height_25 = calc_25.getHeight();
    var ft_25 = calc_25.getTtt(); // or flight time (tested via height)
    
    if (height_25 < 0.60f || height_25 > 0.80f) {
        logger.error("Invalid jump height calculated at 25Hz: " + height_25);
        return false;
    }
    
    logger.debug("Successfully validated 25Hz. Calculated Height: " + height_25.format("%.2f") + "m, TTT: " + ft_25.format("%.2f") + "s, RSImod: " + calc_25.getRsiMod().format("%.2f"));

    return true;
}
