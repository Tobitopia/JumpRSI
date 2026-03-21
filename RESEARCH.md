# Scientific Background: RSImod 🔬

**JumpRSI** utilizes the **Reactive Strength Index Modified (RSImod)** as its core performance metric. This document explains why this metric is used and how it is calculated.

## 1. What is RSImod?
RSImod is a measure of "explosiveness" specifically designed for the **Countermovement Jump (CMJ)**. Unlike the traditional Reactive Strength Index (RSI), which is measured during a drop jump and focuses on "fast" stretch-shortening cycle (SSC) performance (<250ms), RSImod evaluates the "slow" SSC (>250ms).

## 2. Calculation Formula
The app uses the following formula to calculate RSImod:

$$RSImod = \frac{Jump Height (JH)}{Time to Take-off (TTT)}$$

### Jump Height ($JH$)
Calculated from **Flight Time ($t_{flight}$)** using the kinematics of projectile motion:
$$JH = \frac{g \times t_{flight}^2}{8}$$
*Where $g \approx 9.80665 m/s^2$.*

### Time to Take-off ($TTT$)
The duration from the initiation of the countermovement (unweighting phase) until the feet leave the ground.

## 3. Why RSImod Matters
- **Strategy vs. Outcome:** Two athletes may jump the same height, but the one with a higher RSImod achieved that height in less time. This indicates superior explosive power and movement efficiency.
- **Neuromuscular Readiness:** RSImod is highly sensitive to fatigue. A drop in RSImod below an athlete's baseline—even if jump height remains stable—often indicates that the athlete is using a "sluggish" strategy to compensate for neuromuscular fatigue.
- **Daily Monitoring:** By tracking the **average of the best two of three jumps**, the app provides a reliable baseline for an athlete's daily readiness, helping to optimize training intensity and prevent overtraining.

## 4. Normal Values
In athletic populations, RSImod typically ranges from **0.35 to 0.70**.
- **< 0.40:** Might indicate fatigue or a force-dominant but slow movement strategy.
- **0.50 - 0.60:** Good explosive performance.
- **> 0.70:** Elite-level explosive power.

## 📚 References
- *Ebben, W. P., & Petushek, E. J. (2010). Using the reactive strength index-modified to evaluate explosive power. Journal of Strength and Conditioning Research.*
- *Stratton, M. T., et al. (2020). The Reactive Strength Index Modified as a Measure of Neuromuscular Fatigue.*
