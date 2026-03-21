# Scientific Background: Vertical Jump Analysis & RSImod 🔬

**JumpRSI** is built on the foundation of contemporary sports science, specifically the use of **Countermovement Jumps (CMJ)** and the **Reactive Strength Index Modified (RSImod)** to monitor internal training response and Neuromuscular Fatigue (NMF).

## 1. Biomechanical Differentiation
The choice of jump determines which component of the neuromuscular system is evaluated.
- **Countermovement Jump (CMJ):** The gold standard for monitoring neuromuscular readiness, preferred by over 54% of practitioners [1]. It involves a "slow" Stretch-Shortening Cycle (SSC) (>500ms) [3]. The eccentric phase stores elastic energy in the muscle-tendon complexes, which is then released during propulsion.
- **Squat Jump (SJ):** Isolates purely concentric power [8]. By holding a static squat (approx. 90°) for 2-3 seconds, elastic energy is dissipated [3][9]. 
- **Protocol isolation:** JumpRSI requires **hands on hips** to isolate lower-body power. While an arm swing (Abalakov jump) can increase height by >10%, it introduces koordinative noise that can mask neuromuscular deficits [3].

## 2. RSImod: Strategy vs. Outcome
The human body is remarkably resourceful. Even when fatigued, an athlete can often maintain their "Output" (Jump Height) by changing their "Strategy" (Input) [27].

$$RSImod = \frac{Jump Height (JH)}{Time to Take-off (TTT)}$$

- **The Strategy Shift:** Research shows that two jumps with identical heights (e.g., 29.1 cm) can have drastically different efficiencies. A 50% increase in contraction time (650 ms vs. 998 ms) reduces RSImod from **0.45 m/s to 0.29 m/s** [27].
- **Sensitivity:** Jump height might change by only 1%, while RSImod can drop by **15-20%** under the same fatigue stimulus, acting as a much more sensitive "early warning" system for the athlete.

## 3. IMU Validity (Watch vs. Force Plates)
Inertial Measurement Units (IMUs) have bridged the gap between lab diagnostics and field application [4].
- **Precision:** Single-sensor systems have shown excellent agreement with gold-standard force plates, with Pearson correlations of **$r \geq 0.983$** for jump height and RSI [5].
- **Calculation:** JumpRSI uses the **Take-off Velocity (TOV)** method [4][35], integrating the vertical acceleration signal—a more precise method than simple flight-time which can be artificially inflated by landing with tucked knees [3].

## 4. Statistical Framework & Autoregulation
To distinguish real "Signal" (fatigue) from "Noise" (measurement error), we use individual baselines and statistical thresholds [21].

| Metric | Reliability (ICC) | CV (%) | Sensitivity (SNR) |
| :--- | :--- | :--- | :--- |
| **CMJ Height** | 0.93 - 0.98 | 3.5 - 5.0 % | Good [19] |
| **RSImod** | 0.87 - 0.97 | 5.5 - 6.5 % | **Excellent [28]** |
| **Peak Power** | 0.97 - 0.98 | 1.3 - 2.0 % | Very High [31] |

### Practical Autoregulation Thresholds
- **Decline < 3%:** Normal fluctuation. Proceed as planned.
- **Decline 3% to 5%:** Early NMF. Training should be critically questioned or volume slightly reduced [12].
- **Decline > 5% (or > SWC*):** Clear evidence of significant fatigue. Pivot to recovery or coordination drills to prevent overtraining [12][19].
*\*SWC: Smallest Worthwhile Change.*

## 5. Recovery Kinetics
Neuromuscular function often follows a **bimodal recovery pattern** after intense stimuli (e.g., matches or eccentric lifting) [29][2]:
1. **Acute Phase (0-2h):** Immediate performance drop.
2. **Delayed Phase (24-48h):** A second, deeper "trough" in RSImod and braking efficiency occurs.
3. **Recovery (48-72h):** Return to baseline. 

If RSImod remains suppressed after 72 hours, it is a strong indicator of **Non-Functional Overreaching** or the onset of **Overtraining Syndrome (OTS)** [6][2].

## 📚 References
1. [Reliability of Vertical Jump Force-Time Metrics...](https://pmc.ncbi.nlm.nih.gov/articles/PMC12733763/)
2. [Trends Assessing Neuromuscular Fatigue in Team Sports...](https://pmc.ncbi.nlm.nih.gov/articles/PMC8950744/)
3. [Understanding the Countermovement Jump - VALD](https://valdperformance.com/news/understanding-the-countermovement-jump)
4. [Effects of IMU Location on Validity of Vertical Acceleration...](https://www.mdpi.com/2624-6120/6/1/11)
5. [Validity and reliability of an IMU to assess jump performance](https://25970650.fs1.hubspotusercontent-eu1.net/hubfs/25970650/Validation%20Docs/Validity%20and%20reliability%20of%20an%20inertial%20measurement%20unit%20to%20assess%20jump%20performance%2C%202026.pdf)
6. [Monitoring Recovery of Vertical Jump Performance...](https://pmc.ncbi.nlm.nih.gov/articles/PMC12194014/)
8. [THE BASICS OF THE 3 ASSESSMENT JUMPS - Kinvent](https://kinvent.com/wp-content/uploads/2025/11/Jump_eBook_Physio_v002.pdf)
12. [Case Report: Monitoring NMF through jump...](https://www.frontiersin.org/journals/sports-and-active-living/articles/10.3389/fspor.2025.1558020/pdf)
13. [Assessment of Countermovement Jump: What Should We Report?](https://pmc.ncbi.nlm.nih.gov/articles/PMC9865236/)
19. [Vertical Jump As a Measure of Neuromuscular Fatigue - Xsens](https://www.xsens.com/resources/blog/neuromuscular-fatigue)
21. [Reliability & Meaningful Change of the Drop-Jump RSI](https://www.researchgate.net/publication/283479348_Establishing_the_Reliability_Meaningful_Change_of_the_Drop-Jump_Reactive-Strength_Index)
27. [RSI-Mod Made Simple - VALD](https://valdperformance.com/news/rsi-mod-made-simple)
28. [Reliability of and Relationship between FT:CT and RSImod](https://pmc.ncbi.nlm.nih.gov/articles/PMC6162366/)
29. [Effect of Neuromuscular Fatigue on CMJ Characteristics](https://www.researchgate.net/publication/375027513_Effect_of_Neuromuscular_Fatigue_on_the_Countermovement_Jump_Characteristics_Basketball-Related_High-Intensity_Exercises)
31. [RELIABILITY AND SENSITIVITY OF CMJ VARIABLES... - SciELO](https://www.scielo.br/j/jpe/a/cSwsDcWkpzdkGKnHQjBxZYC/?lang=en)
35. [Effects of IMU Sensor Location and Number...](https://digitalcommons.usu.edu/cgi/viewcontent.cgi?article=2691&context=gradreports)
36. [Accuracy of IMUs Applied to the CMJ](https://www.mdpi.com/1424-8220/22/19/7186)
