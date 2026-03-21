import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

class StorageService {
    private const KEY_BASELINE = "baseline_rsi";
    private const KEY_JUMP_HISTORY = "jump_history";

    function initialize() {
    }

    function deleteLastJump() as Void {
        var history = Storage.getValue(KEY_JUMP_HISTORY) as Array?;
        if (history != null && history.size() > 0) {
            history = history.slice(0, history.size() - 1);
            Storage.setValue(KEY_JUMP_HISTORY, history);
            
            if (history.size() > 0) {
                var sum = 0.0;
                for (var i = 0; i < history.size(); i++) {
                    var item = history[i] as Dictionary;
                    sum += item["rsi"] as Float;
                }
                saveBaseline(sum / history.size());
            } else {
                Storage.deleteValue(KEY_BASELINE);
            }
        }
    }

    function saveBaseline(rsi as Float) as Void {
        Storage.setValue(KEY_BASELINE, rsi);
    }

    function getBaseline() as Float {
        var val = Storage.getValue(KEY_BASELINE);
        if (val == null) { return 0.0; }
        return val as Float;
    }

    function saveTodayJump(rsi as Float, height as Float) as Void {
        var history = Storage.getValue(KEY_JUMP_HISTORY) as Array?;
        if (history == null) { history = [] as Array; }

        // Use a safer way to get the time value
        var now = Time.now();
        var timeValue = 0;
        if (now has :value) {
            timeValue = now.value();
        }

        var today = {
            "date" => timeValue,
            "rsi" => rsi,
            "height" => height
        } as Dictionary;

        history.add(today);
        
        if (history.size() > 10) {
            history = history.slice(history.size() - 10, null);
        }

        Storage.setValue(KEY_JUMP_HISTORY, history);
        
        var sum = 0.0;
        for (var i = 0; i < history.size(); i++) {
            var item = history[i] as Dictionary;
            sum += item["rsi"] as Float;
        }
        saveBaseline(sum / history.size());
    }

    function getHistory() as Array {
        var history = Storage.getValue(KEY_JUMP_HISTORY) as Array?;
        if (history == null) { return [] as Array; }
        return history;
    }

    function clearHistory() as Void {
        Storage.deleteValue(KEY_JUMP_HISTORY);
        Storage.deleteValue(KEY_BASELINE);
    }
}
