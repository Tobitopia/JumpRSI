# JumpDiagnostics Wearable: Garmin Implementation (Monkey C) ⌚🛰️

This document outlines how to port the JumpDiagnostics logic to a Garmin watch using the **Monkey C** language.

## 1. Hardware Constraints & Efficiency
Unlike a smartphone, a Garmin watch has very limited RAM (often 64KB - 128KB).
- **Optimization:** Avoid creating new objects inside the sensor callback. Reuse variables for magnitude and velocity.
- **Data Types:** Use `Float` instead of `Double` where possible to save memory.

## 2. Sensor Handling (`Toybox.Sensor`)
Register for high-frequency data.
```monkeyc
// Example: Registering for 25Hz or 50Hz data
Sensor.registerSensorDataListener(method(:onSensorData), {
    :period => 1, // Every sample
    :accelerometer => {
        :enabled => true,
        :sampleRate => 25 // or 50 if supported
    }
});
```
**Hint:** Use `SensorData.accelerometerData` to get arrays of X, Y, Z.

## 3. The Ported State Machine
Port the `JumpCalculator` logic. Since Monkey C is Object-Oriented, the structure will be similar to our Dart implementation.
- **Stillness Check:** Mandatory 2-second calibration to find the watch's specific "at-rest" magnitude.
- **Peak Detection:** Watches are lighter than phones; the landing "spike" might be sharper but shorter. Ensure your landing threshold is robust.

## 4. Storage API (`Toybox.Application.Storage`)
Garmin uses a persistent key-value store.
- **Daily Key:** Store your data using a key like `"RSI_2023_10_27"`. 
- **Aggregation:** Before saving, use `Storage.getValue(key)` to check if today's jump already exists. If so, prompt the user via a `WatchUi.Confirmation` dialog.

## 5. UI/UX: The "Glance" Factor
- **View:** Use `WatchUi.View` for the main dashboard.
- **Graphing:** You can't use `fl_chart`. You must use `dc.drawLine()` or `dc.fillPolygon()` to manually draw your trend line on the screen.
- **Haptics:** Use `Attention.vibrate()` for the countdown.

---

## 🚀 Architectural Advice:
Keep your **Logic** (State Machine) in a separate class from your **View**. This will make it much easier to unit test your code using the Garmin simulator's test framework.

**Question:** In our Dart code, we used `StreamZip` to fuse sensors. Garmin doesn't have `StreamZip`. How can you manually sync Accelerometer and Gyroscope data if both arrays come in the same callback? (Hint: Check the `sampleRate` and array lengths).
