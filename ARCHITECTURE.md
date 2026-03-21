# Technical Architecture 🏗️

This document explains the internal logic, state management, and signal processing used in **JumpRSI**.

## 1. Jump Detection State Machine
The core of the app is the `JumpCalculator` class, which implements a robust state machine to detect the different phases of a Countermovement Jump (CMJ) from accelerometer magnitude ($G$).

```mermaid
graph TD
    A[STATE_START] -->|onSelect| B[STATE_PREPARING]
    B -->|3s Countdown Finishes| C[STATE_IDLE]
    C -->|Unweighting: Mag < 0.85G| D[STATE_UNWEIGHTING]
    D -->|Launching: Mag > 1.25G| E[STATE_LAUNCHING]
    E -->|Takeoff: Mag < 0.40G| F[STATE_IN_AIR]
    F -->|Landing: Mag > 1.7G| G[STATE_LANDED]
    G -->|Next Jump| B
    G -->|Session Complete| A
    G -->|onBack| A
```

## 2. Signal Processing & Precision
To achieve sub-millisecond precision with a 50Hz (20ms) sensor rate, we use two key techniques:

### EMA (Exponential Moving Average) Filter
We apply a low-pass EMA filter ($\alpha = 0.45$) to the raw magnitude to reduce sensor noise while maintaining responsiveness:
$$y[n] = \alpha \cdot x[n] + (1 - \alpha) \cdot y[n-1]$$
We also compensate for the filter's phase lag ($\tau$) when calculating timestamps.

### Linear Interpolation
When a threshold is crossed (e.g., the 0.4G takeoff threshold), we don't just use the current sample's timestamp. We interpolate between the current and last sample to find the exact moment the threshold was crossed:
$$t_{precise} = t_{prev} + (t_{curr} - t_{prev}) \cdot \frac{Threshold - mag_{prev}}{mag_{curr} - mag_{prev}}$$

## 3. System Data Flow
The following diagram shows how data flows from the Garmin sensors to persistent storage.

```mermaid
sequenceDiagram
    participant S as SensorService (50Hz)
    participant C as JumpCalculator
    participant JS as JumpSession
    participant SS as StorageService
    
    S->>C: processSample(mag, timestamp)
    C->>C: Update EMA Filter
    alt Jump Phase Changed
        C->>C: Update State
    else State is LANDED
        C->>JS: addJump(height, rsi, ttt)
        alt Jump Count == 3
            JS->>SS: saveTodayJump(avgBestTwoRsi, avgBestTwoHeight)
            SS->>SS: Update RSI/Height History
        end
    end
```

## 4. Class Architecture
The app follows a clean separation of concerns, decoupling the signal processing logic from the UI and storage.

```mermaid
classDiagram
    class jumpheightApp {
        +JumpCalculator calculator
        +JumpSession session
        +SensorService sensorService
        +StorageService storageService
    }
    class JumpCalculator {
        -state
        -emaAlpha
        +processSample(mag, time)
        +startCountdown()
        +resetToStart()
    }
    class JumpSession {
        -jumps Array
        +addJump(h, r, t)
        +isComplete()
        +getAverageBestTwoRsi()
    }
    class StorageService {
        +saveTodayJump(rsi, height)
        +getHistory()
        +deleteLastJump()
    }
    jumpheightApp --> JumpCalculator : owns
    jumpheightApp --> JumpSession : owns
    jumpheightApp --> SensorService : owns
    jumpheightApp --> StorageService : owns
    SensorService ..> JumpCalculator : feeds data
    jumpheightDelegate ..> JumpCalculator : controls
    jumpheightDelegate ..> JumpSession : updates
```
