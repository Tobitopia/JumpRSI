import Toybox.Sensor;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;

class SensorService {
    private var _calculator;

    function initialize(calculator) {
        _calculator = calculator;
    }

    function start() as Void {
        var options = {
            :period => 1,
            :accelerometer => {
                :enabled => true,
                :sampleRate => 50, // Reverted to 50Hz for stability
                :includeTimestamps => false
            }
        };

        try {
            Sensor.registerSensorDataListener(method(:onSensorData), options);
            System.println("Sens: 50Hz OK");
        } catch (e) {
            System.println("Sens: ERR");
        }
    }

    function stop() as Void {
        Sensor.unregisterSensorDataListener();
    }

    function onSensorData(sensorData as SensorData) as Void {
        if (sensorData == null) { return; }
        
        var accel = sensorData.accelerometerData;
        if (accel != null) {
            var x = accel.x;
            var y = accel.y;
            var z = accel.z;
            if (x == null || y == null || z == null) { return; }
            
            var baseTime = Time.now().value() * 1000L; 
            var msPerSample = 20; // 50Hz = 20ms

            for (var i = 0; i < x.size(); i++) {
                var xF = x[i].toFloat();
                var yF = y[i].toFloat();
                var zF = z[i].toFloat();
                var magG = Math.sqrt(xF*xF + yF*yF + zF*zF).toFloat() / 1000.0f;
                
                var t = baseTime + (i * msPerSample);
                _calculator.processSample(magG, t);
            }
        }
    }
}
