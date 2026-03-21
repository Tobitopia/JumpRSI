import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

const STATE_START = 0;
const STATE_PREPARING = 1;
const STATE_IDLE = 2;
const STATE_UNWEIGHTING = 3;
const STATE_LAUNCHING = 4;
const STATE_IN_AIR = 5;
const STATE_LANDED = 6;

class JumpCalculator {
    private var _state = STATE_START;
    private var _height as Float = 0.0;
    private var _rsiMod as Float = 0.0;
    private var _takeOffTime as Long = 0L;
    private var _flightTime as Float = 0.0;
    private var _ttt as Float = 0.0;

    private var _startTime as Long = 0L;
    private var _lastTimestamp as Long = 0L;
    private var _countdown as Number = 0;

    // Pro Filter & Calibration
    private var _emaAlpha = 0.35f; 
    private var _filteredMag = 1.0f;
    private var _restingG = 1.0f;
    private var _calibCount = 0;

    function initialize() {
    }
    
    function startCountdown() as Void {
        _state = STATE_PREPARING;
        _countdown = 3;
        _filteredMag = 1.0f;
        _restingG = 0.0f;
        _calibCount = 0;
    }

    function tickCountdown() as Boolean {
        if (_state == STATE_PREPARING) {
            _countdown--;
            if (_countdown < 0) {
                if (_calibCount > 0) { _restingG = _restingG / _calibCount; }
                else { _restingG = 1.0f; }
                _state = STATE_IDLE;
                System.println("Calibrated G: " + _restingG);
                return true;
            }
        }
        return false;
    }

    function processSample(accelMagG as Float, timestamp as Long) as Void {
        _filteredMag = (_emaAlpha * accelMagG) + ((1.0f - _emaAlpha) * _filteredMag);

        if (_state == STATE_PREPARING) {
            // Only calibrate during the last 2 seconds (countdown <= 2)
            // to allow user to stabilize after pressing the button
            if (_countdown <= 2) {
                _restingG += _filteredMag;
                _calibCount++;
            }
            return;
        }

        if (_state < STATE_IDLE || _state == STATE_LANDED) {
            _lastTimestamp = timestamp;
            return;
        }

        if (_lastTimestamp == 0L) {
            _lastTimestamp = timestamp;
            return;
        }

        var dt = (timestamp - _lastTimestamp).toFloat() / 1000.0;
        _lastTimestamp = timestamp;
        if (dt <= 0 || dt > 0.5) { return; }

        switch (_state) {
            case STATE_IDLE:
                if (_filteredMag < (_restingG * 0.85)) {
                    _state = STATE_UNWEIGHTING;
                    _startTime = timestamp;
                }
                break;

            case STATE_UNWEIGHTING:
                if (_filteredMag > (_restingG * 1.25)) {
                    _state = STATE_LAUNCHING;
                }
                break;

            case STATE_LAUNCHING:
                if (_filteredMag < 0.25) { 
                    _state = STATE_IN_AIR;
                    _takeOffTime = timestamp;
                    _ttt = (timestamp - _startTime).toFloat() / 1000.0;
                }
                break;

            case STATE_IN_AIR:
                var timeInAir = (timestamp - _takeOffTime).toFloat() / 1000.0;
                if (timeInAir > 0.15 && _filteredMag > 1.8) {
                    _state = STATE_LANDED;
                    _flightTime = timeInAir;
                    calculateResults();
                    System.println("Jump: H=" + _height + " RSI=" + _rsiMod);
                }
                break;
        }
    }

    private function calculateResults() as Void {
        _height = (9.80665 * _flightTime * _flightTime) / 8.0;
        if (_ttt > 0) {
            _rsiMod = _height / _ttt;
        } else {
            _rsiMod = 0.0;
        }
    }

    function getState() { return _state; }
    function getHeight() as Float { return _height; }
    function getRsiMod() as Float { return _rsiMod; }
    function getTtt() as Float { return _ttt; }
    function getCountdown() as Number { return _countdown; }

    function resetToStart() as Void {
        _state = STATE_START;
        _height = 0.0;
        _rsiMod = 0.0;
        _takeOffTime = 0L;
        _flightTime = 0.0;
        _ttt = 0.0;
        _startTime = 0L;
        _lastTimestamp = 0L;
        _filteredMag = 1.0f;
    }
}
