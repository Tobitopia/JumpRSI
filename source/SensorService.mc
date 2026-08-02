import Toybox.Sensor;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;

class SensorService {
    private var _calculator;
    private var _sampleRate as Number = 50; // Default 50Hz for compatibility

    function initialize(calculator) {
        _calculator = calculator;
        detectSampleRate();
    }

    private function detectSampleRate() as Void {
        _sampleRate = 50; // Default starting rate
        
        // Dynamically check device capability
        if (Sensor has :getMaxSampleRateForSensorType) {
            try {
                var maxRate = Sensor.getMaxSampleRateForSensorType(:accelerometer);
                if (maxRate != null && maxRate > 0) {
                    _sampleRate = maxRate;
                }
            } catch (e) {
                _sampleRate = 50;
            }
        }
    }

    function start() as Void {
        var options = {
            :period => 1,
            :accelerometer => {
                :enabled => true,
                :sampleRate => _sampleRate,
                :includeTimestamps => false
            }
        };

        Sensor.registerSensorDataListener(method(:onSensorData), options);
    }

    function stop() as Void {
        Sensor.unregisterSensorDataListener();
    }

    function onSensorData(sensorData as SensorData) as Void {
        if (sensorData != null && sensorData.accelerometerData != null) {
            var accel = sensorData.accelerometerData;
            var x = accel.x;
            var y = accel.y;
            var z = accel.z;
            if (x != null && y != null && z != null) {
                var baseTime = Time.now().value() * 1000L; 
                var msPerSample = 1000.0f / _sampleRate.toFloat();

                for (var i = 0; i < x.size(); i++) {
                    var xF = x[i].toFloat();
                    var yF = y[i].toFloat();
                    var zF = z[i].toFloat();
                    var t = baseTime + (i.toFloat() * msPerSample).toLong();
                    
                    if (_calculator has :processSample3D) {
                        _calculator.processSample3D(xF, yF, zF, t);
                    } else {
                        var magG = Math.sqrt(xF*xF + yF*yF + zF*zF).toFloat() / 1000.0f;
                        _calculator.processSample(magG, t);
                    }
                }
            }
        }
    }

    function getSampleRate() as Number {
        detectSampleRate();
        return _sampleRate;
    }
}

