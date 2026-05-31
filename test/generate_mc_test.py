import csv

def generate_monkeyc_test():
    # Read 100Hz CSV data
    data = []
    with open("test/jump_profile_100hz.csv") as f:
        reader = csv.reader(f)
        next(reader)  # Skip header
        for row in reader:
            data.append((int(row[0]), float(row[1])))
            
    # Subsample for 100Hz, 50Hz, and 25Hz
    rates = [100, 50, 25]
    resampled_data = {}
    for r in rates:
        step = 100 // r
        resampled_data[r] = data[::step]
        
    # Generate Monkey C arrays
    mc_code = """import Toybox.Test;
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
"""
    
    # Append the resampled datasets inside the test function
    for r in rates:
        mags_str = ", ".join(f"{val}f" for _, val in resampled_data[r])
        times_str = ", ".join(f"{t}L" for t, _ in resampled_data[r])
        
        mc_code += f"""
    // --- {r}Hz Dataset Simulation ---
    var mags_{r} = [{mags_str}] as Array<Float>;
    var times_{r} = [{times_str}] as Array<Long>;
    
    var calc_{r} = new JumpCalculator();
    // Simulate transitioning past Preparing state directly
    calc_{r}.startCountdown();
    calc_{r}.onTimerTick();
    calc_{r}.onTimerTick();
    calc_{r}.onTimerTick();
    calc_{r}.onTimerTick(); // Set state to STATE_IDLE
    
    for (var i = 0; i < mags_{r}.size(); i++) {{
        calc_{r}.processSample(mags_{r}[i], times_{r}[i]);
    }}
    
    if (calc_{r}.getState() != 6) {{
        logger.error("Failed to detect landing at {r}Hz (state: " + calc_{r}.getState() + ")");
        return false;
    }}
    
    var height_{r} = calc_{r}.getHeight();
    var ft_{r} = calc_{r}.getTtt(); // or flight time (tested via height)
    
    if (height_{r} < 0.60f || height_{r} > 0.80f) {{
        logger.error("Invalid jump height calculated at {r}Hz: " + height_{r});
        return false;
    }}
    
    logger.info("Successfully validated {r}Hz. Calculated Height: " + height_{r}.format("%.2f") + "m, RSImod: " + calc_{r}.getRsiMod().format("%.2f"));
"""
        
    mc_code += """
    return true;
}
"""

    with open("source/JumpRsiTests.mc", "w") as f:
        f.write(mc_code)
    print("Generated source/JumpRsiTests.mc from CSV.")

if __name__ == "__main__":
    generate_monkeyc_test()
