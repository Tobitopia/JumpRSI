import Toybox.Lang;

class JumpSession {
    private var _jumps as Array<JumpData> = [];
    private var _maxJumps as Number = 3;

    function initialize() {
    }

    function addJump(height as Float, rsiMod as Float, ttt as Float) as Void {
        if (_jumps.size() < _maxJumps) {
            _jumps.add(new JumpData(height, rsiMod, ttt));
        }
    }

    function getAverageBestTwoRsi() as Float {
        if (_jumps.size() < 2) {
            return 0.0;
        }

        var rsiValues = [] as Array<Float>;
        for (var i = 0; i < _jumps.size(); i++) {
            rsiValues.add(_jumps[i].rsiMod);
        }

        // Sort descending
        sortDescending(rsiValues);

        return (rsiValues[0] + rsiValues[1]) / 2.0;
    }

    function getAverageBestTwoHeight() as Float {
        if (_jumps.size() < 2) {
            return 0.0;
        }

        var heights = [] as Array<Float>;
        for (var i = 0; i < _jumps.size(); i++) {
            heights.add(_jumps[i].height);
        }

        sortDescending(heights);

        return (heights[0] + heights[1]) / 2.0;
    }

    private function sortDescending(arr as Array<Float>) as Void {
        var n = arr.size();
        for (var i = 0; i < n; i++) {
            for (var j = 0; j < n - i - 1; j++) {
                if (arr[j] < arr[j + 1]) {
                    var temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
    }

    function isComplete() as Boolean {
        return _jumps.size() >= _maxJumps;
    }

    function getJumpCount() as Number {
        return _jumps.size();
    }

    function reset() as Void {
        _jumps = [];
    }
}

class JumpData {
    var height as Float;
    var rsiMod as Float;
    var ttt as Float;

    function initialize(h as Float, r as Float, t as Float) {
        height = h;
        rsiMod = r;
        ttt = t;
    }
}
