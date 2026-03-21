# JumpRSI ⌚🚀

JumpRSI is a high-performance diagnostic tool for Garmin watches designed to measure and track the **Reactive Strength Index Modified (RSImod)** during Countermovement Jumps (CMJ).

It helps athletes monitor their neuromuscular readiness and explosive power daily, ensuring optimal training intensity.

## ✨ Features
- **Precise Measurement:** High-frequency (50Hz) sensor sampling for accurate takeoff and landing detection.
- **RSImod Metric:** Scientifically proven ratio of Jump Height / Time to Take-off.
- **Session Average:** Records the average of your **best two jumps** out of three for consistent data.
- **On-Device History:** View trends of your RSI and Jump Height directly on your watch.
- **Clean UI:** Optimized for Garmin round and square displays with intuitive pagination.

## 🏃 How to Use
1. **Calibrate:** Stand still for 3 seconds after pressing START.
2. **Jump:** Hands on hips, perform a Countermovement Jump when prompted "JUMP!".
3. **Repeat:** Complete 3 jumps per session.
4. **Summary:** View your best-of-two average results.
5. **Analyze:** Swipe up/down to see your 7-day history graphs.

## 🔬 Scientific Background
The app is based on the **Reactive Strength Index Modified (RSImod)**, a key metric for "Slow" Stretch-Shortening Cycle (SSC) performance.
For a detailed breakdown of the physics and research, see [RESEARCH.md](./RESEARCH.md).

## 🏗️ Technical Architecture
JumpRSI uses a complex state machine for jump detection and EMA signal filtering for high precision.
For detailed technical documentation including **Mermaid diagrams**, see [ARCHITECTURE.md](./ARCHITECTURE.md).

## 🎨 Design & UI
The app follows a 5-page navigation cycle designed for quick daily check-ins.
Learn more about the UI architecture in [DESIGN.md](./DESIGN.md).

## 💖 Support & Contribute
JumpRSI is **fully open-source**. If you find it useful, consider supporting the developer:
- **Support (1€):** [paypal.me/tobitopia](https://paypal.me/tobitopia)
- **Contribute:** Open issues or pull requests at [github.com/tobitopia/JumpDiagnosticsGarmin](https://github.com/tobitopia/JumpDiagnosticsGarmin)

## ⚖️ License
MIT License. See [LICENSE](./LICENSE) for details.
