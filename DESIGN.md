# Design & UI Preview 🎨

**JumpRSI** is designed for high-stakes athletes who need clear, actionable data with minimal interaction. This document previews the app's user interface and design logic.

## 1. UI Principles
- **Clarity First:** Large fonts for core metrics (RSI, Jump Height).
- **Color Coding:** 
  - **Blue:** RSI-related metrics (RSI Graph, RSI Results).
  - **Orange:** Height-related metrics (Height Graph, Height Results).
  - **Green:** Success or action states ("JUMP!").
  - **Yellow:** Prompts or secondary information ("Press START").
- **Minimal Interaction:** Most of the session is automated once the first jump begins.

## 2. Navigation Flow
The app uses a 5-page vertical navigation cycle (accessible via swipe up/down or buttons):

```text
[0] Perform Test (Main)
       ▲ | ▼
[1] RSI History (Bar Graph)
       ▲ | ▼
[2] Height History (Bar Graph)
       ▲ | ▼
[3] Support & Help (PayPal/GitHub)
       ▲ | ▼
[4] About JumpRSI (Scientific Background)
```

## 3. Session Logic
To ensure data quality, the app implements a specific measurement protocol:
- **Best-of-Two Average:** The app records 3 jumps per session but only uses the **best two** to calculate the final average. This filters out outliers caused by technical errors during a single jump.
- **High-Frequency Sampling:** Sensors are sampled at **50Hz (20ms)** for sub-millisecond precision in takeoff and landing detection.

## 4. Visual Assets
The app uses platform-native primitives and custom SVGs:
- **Launcher Icon:** `launcher_icon.svg`
- **History Graphs:** Dynamic bar charts drawn using the Monkey C `Dc` (Device Context) API.

## 5. Pagination
Users are always oriented via pagination dots on the left side of the screen, ensuring they know exactly where they are in the app's ecosystem.
