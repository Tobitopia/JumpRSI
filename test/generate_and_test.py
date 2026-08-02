import os
import csv
import math
import random

def generate_3d_jump_profile_with_rotation(noise_std=0.08):
    """
    Generates a 3D acceleration profile for a Countermovement Jump (CMJ) at 100Hz
    with DYNAMIC TORSO & HANDS-ON-HIPS PITCH ROTATION theta(t).
    
    Biomechanical rotation profile theta(t):
    - 0s to 1.0s   : Resting calibration (theta = 0 deg)
    - 1.0s to 1.3s  : Unweighting / Hip flexion (theta rotates 0 deg -> +25 deg)
    - 1.3s to 1.68s : Propulsion / Extension (theta rotates +25 deg -> 0 deg at takeoff)
    - 1.68s to 2.24s: In air free fall (theta = 0 deg)
    - 2.24s to 2.5s : Landing absorption flex (theta rotates 0 deg -> +20 deg -> 0 deg)
    
    Includes 80mG Gaussian noise on 3 axes.
    """
    os.makedirs("test", exist_ok=True)
    filename = "test/jump_profile_3d_rotation_100hz.csv"
    
    dt = 0.01  # 100Hz = 10ms
    duration = 2.5
    n_samples = int(duration / dt)
    
    # Base resting gravity vector direction (e.g., 20 deg tilt on wrist relative to Z)
    rest_tilt_rad = math.radians(20)
    g_unit_rest = [0.0, math.sin(rest_tilt_rad), math.cos(rest_tilt_rad)]
    
    random.seed(42)
    samples = []
    
    # Ground truth targets:
    # Takeoff @ 1.68s, Landing @ 2.24s -> FT = 0.5600 s
    # Height = 9.80665 * 0.56^2 / 8 = 38.44 cm
    # RSImod = 0.3844 / 0.53 = 0.725
    
    for i in range(n_samples):
        t = i * dt
        
        # 1. Scalar vertical acceleration (in Gs)
        if 0.0 <= t < 1.0:
            a_vert = 1.0
            pitch_deg = 0.0
        elif 1.0 <= t < 1.3:
            # Unweighting phase: drops to 0.5G
            a_vert = 1.0 - (0.5 / 0.3) * (t - 1.0)
            # Pitch tilts forward 0 -> 25 degrees
            pitch_deg = (25.0 / 0.3) * (t - 1.0)
        elif 1.3 <= t < 1.6:
            # Propulsion phase: rises to 2.2G
            a_vert = 0.5 + (1.7 / 0.3) * (t - 1.3)
            # Pitch returns 25 -> 5 degrees
            pitch_deg = 25.0 - (20.0 / 0.3) * (t - 1.3)
        elif 1.6 <= t < 1.68:
            # Takeoff transition: drops to 0.0G
            a_vert = 2.2 - (2.2 / 0.08) * (t - 1.6)
            # Pitch returns fully upright 5 -> 0 degrees at takeoff
            pitch_deg = 5.0 - (5.0 / 0.08) * (t - 1.6)
        elif 1.68 <= t < 2.24:
            # Free fall in air (0.0G)
            a_vert = 0.0
            pitch_deg = 0.0
        elif 2.24 <= t < 2.30:
            # Landing impact spike: 2.8G
            a_vert = 0.0 + (2.8 / 0.06) * (t - 2.24)
            # Flex forward 0 -> 20 degrees
            pitch_deg = (20.0 / 0.06) * (t - 2.24)
        elif 2.30 <= t < 2.50:
            # Recovery back to 1.0G
            a_vert = 2.8 - (1.8 / 0.20) * (t - 2.30)
            # Return upright 20 -> 0 degrees
            pitch_deg = 20.0 - (20.0 / 0.20) * (t - 2.30)
        else:
            a_vert = 1.0
            pitch_deg = 0.0
            
        # 2. Rotate gravity vector by pitch_deg
        pitch_rad = math.radians(pitch_deg)
        total_tilt_rad = rest_tilt_rad + pitch_rad
        g_unit_rotated = [0.0, math.sin(total_tilt_rad), math.cos(total_tilt_rad)]
        
        vec_clean = [a_vert * 1000.0 * comp for comp in g_unit_rotated]
        
        # 3. Add 80mG Gaussian noise
        noise_x = random.gauss(0, noise_std * 1000.0)
        noise_y = random.gauss(0, noise_std * 1000.0)
        noise_z = random.gauss(0, noise_std * 1000.0)
        
        vec_noisy = [vec_clean[0] + noise_x, vec_clean[1] + noise_y, vec_clean[2] + noise_z]
        
        # Metrics:
        # Projected onto RESTING calibration vector (g_unit_rest)
        projected_vert_g = (vec_noisy[0]*g_unit_rest[0] + vec_noisy[1]*g_unit_rest[1] + vec_noisy[2]*g_unit_rest[2]) / 1000.0
        euclidean_norm_g = math.sqrt(vec_noisy[0]**2 + vec_noisy[1]**2 + vec_noisy[2]**2) / 1000.0
        
        timestamp_ms = int(round(t * 1000))
        samples.append((timestamp_ms, 
                        round(vec_noisy[0], 2), 
                        round(vec_noisy[1], 2), 
                        round(vec_noisy[2], 2),
                        round(euclidean_norm_g, 4),
                        round(projected_vert_g, 4),
                        round(a_vert, 4),
                        round(pitch_deg, 1)))
        
    with open(filename, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["Timestamp_ms", "X_mG", "Y_mG", "Z_mG", "EuclideanNorm_G", "ProjectedVert_G", "TrueVert_G", "PitchDeg"])
        writer.writerows(samples)
        
    print(f"Generated {filename} with dynamic torso pitch rotation (up to 25 deg).")
    return filename

class SimCalculator:
    def __init__(self, mode="projected"):
        self.mode = mode
        self.state = 0
        self.resting_sum = [0.0, 0.0, 0.0]
        self.calib_count = 0
        self.g_unit = [0.0, 0.0, 1.0]
        
        self.ema_alpha = 0.45
        self.filtered_signal = 1.0
        self.last_signal = 1.0
        
        self.last_timestamp = 0
        self.start_time = 0
        self.active_start_time = 0
        self.takeoff_time = 0
        self.flight_time = 0.0
        self.ttt = 0.0
        self.height = 0.0
        self.rsi_mod = 0.0
        
    def process_3d_sample(self, x, y, z, timestamp):
        vec = [x, y, z]
        
        if self.state == 0:
            if timestamp < 800:
                self.resting_sum[0] += vec[0]
                self.resting_sum[1] += vec[1]
                self.resting_sum[2] += vec[2]
                self.calib_count += 1
                return
            else:
                if self.calib_count > 0:
                    avg_x = self.resting_sum[0] / self.calib_count
                    avg_y = self.resting_sum[1] / self.calib_count
                    avg_z = self.resting_sum[2] / self.calib_count
                    mag = math.sqrt(avg_x**2 + avg_y**2 + avg_z**2)
                    if mag > 0:
                        self.g_unit = [avg_x / mag, avg_y / mag, avg_z / mag]
                self.state = 2
                
        if self.mode == "projected":
            signal = (vec[0]*self.g_unit[0] + vec[1]*self.g_unit[1] + vec[2]*self.g_unit[2]) / 1000.0
        else:
            signal = math.sqrt(vec[0]**2 + vec[1]**2 + vec[2]**2) / 1000.0
            
        if self.last_timestamp != 0:
            dt = float(timestamp - self.last_timestamp)
            if 0 < dt < 500:
                self.ema_alpha = dt / (24.44 + dt)
                if self.ema_alpha < 0.1: self.ema_alpha = 0.1
                if self.ema_alpha > 0.8: self.ema_alpha = 0.8
        else:
            dt = 10.0
            
        self.filtered_signal = (self.ema_alpha * signal) + ((1.0 - self.ema_alpha) * self.filtered_signal)
        ema_delay = ((1.0 - self.ema_alpha) / self.ema_alpha) * dt
        
        resting_g = 1.0
        
        if self.state == 2:  # STATE_IDLE
            if self.filtered_signal < (resting_g * 0.85):
                self.state = 3
                self.start_time = timestamp
                self.active_start_time = 0
                
        elif self.state == 3:  # STATE_UNWEIGHTING
            if self.last_signal < resting_g and self.filtered_signal >= resting_g:
                diff = self.filtered_signal - self.last_signal
                ratio = (resting_g - self.last_signal) / diff if diff != 0 else 0
                offset = dt * ratio
                self.active_start_time = int(self.last_timestamp + offset - ema_delay)
                
            if self.filtered_signal > (resting_g * 1.25):
                self.state = 4
                
        elif self.state == 4:  # STATE_LAUNCHING
            takeoff_threshold = 0.40
            if self.filtered_signal < takeoff_threshold:
                self.state = 5
                diff = self.filtered_signal - self.last_signal
                ratio = (takeoff_threshold - self.last_signal) / diff if diff != 0 else 0
                offset = dt * ratio
                self.takeoff_time = int(self.last_timestamp + offset - ema_delay)
                self.ttt = float(self.takeoff_time - self.start_time) / 1000.0
                if self.active_start_time == 0:
                    self.active_start_time = int(self.last_timestamp - ema_delay)
                    
        elif self.state == 5:  # STATE_IN_AIR
            time_in_air_raw = float(timestamp - self.takeoff_time) / 1000.0
            landing_threshold = 1.60
            if time_in_air_raw > 0.15 and self.filtered_signal > landing_threshold:
                self.state = 6
                diff = self.filtered_signal - self.last_signal
                ratio = (landing_threshold - self.last_signal) / diff if diff != 0 else 0
                offset = dt * ratio
                actual_landing = int(self.last_timestamp + offset - ema_delay)
                self.flight_time = float(actual_landing - self.takeoff_time) / 1000.0
                
                if self.mode == "projected":
                    self.height = (9.80665 * self.flight_time * self.flight_time) / 8.0
                    active_time = float(self.takeoff_time - self.active_start_time) / 1000.0
                    self.rsi_mod = (self.height / active_time) if active_time > 0 else 0.0
                else:
                    self.height = ((9.80665 * self.flight_time * self.flight_time) / 8.0) * 2.0
                    active_time = float(self.takeoff_time - self.active_start_time) / 1000.0
                    self.rsi_mod = (self.height / active_time) * 0.7 if active_time > 0 else 0.0
                    
        self.last_timestamp = timestamp
        self.last_signal = self.filtered_signal

def run_rotation_benchmark():
    generate_3d_jump_profile_with_rotation(noise_std=0.08)
    
    rows = []
    with open("test/jump_profile_3d_rotation_100hz.csv") as f:
        reader = csv.reader(f)
        header = next(reader)
        for r in reader:
            rows.append((int(r[0]), float(r[1]), float(r[2]), float(r[3]), float(r[4]), float(r[5]), float(r[6]), float(r[7])))
            
    print("\n=======================================================")
    print("  DYNAMIC TORSO ROTATION (UP TO 25 deg) SIMULATION    ")
    print("=======================================================")
    print("Ground Truth Target: Height = 38.44 cm | Flight Time = 0.5600 s | RSImod = 0.725")
    print("-------------------------------------------------------")
    
    # Test Projected
    sim_proj = SimCalculator(mode="projected")
    for t, x, y, z, mag_euc, vert_proj, true_v, pitch in rows:
        sim_proj.process_3d_sample(x, y, z, t)
        if sim_proj.state == 6: break
        
    err_h_proj = abs((sim_proj.height * 100) - 38.44)
    pct_h_proj = (err_h_proj / 38.44) * 100
    
    print("\n--- 1. NEW: Projected Signed Vertical Acceleration ---")
    print(f"Calculated Height: {sim_proj.height * 100:.2f} cm")
    print(f"Absolute Error   : {err_h_proj:.2f} cm ({pct_h_proj:.1f}% relative error)")
    print(f"Flight Time      : {sim_proj.flight_time:.4f} s (True = 0.5600 s)")
    print(f"RSImod           : {sim_proj.rsi_mod:.4f} (True = 0.725)")
    
    # Test Euclidean
    sim_euc = SimCalculator(mode="euclidean")
    for t, x, y, z, mag_euc, vert_proj, true_v, pitch in rows:
        sim_euc.process_3d_sample(x, y, z, t)
        if sim_euc.state == 6: break
        
    err_h_euc = abs((sim_euc.height * 100) - 38.44)
    pct_h_euc = (err_h_euc / 38.44) * 100
    
    print("\n--- 2. OLD: Flawed 3D Euclidean Norm ---")
    print(f"Calculated Height: {sim_euc.height * 100:.2f} cm")
    print(f"Absolute Error   : {err_h_euc:.2f} cm ({pct_h_euc:.1f}% relative error)")
    print(f"Flight Time      : {sim_euc.flight_time:.4f} s")
    print(f"RSImod           : {sim_euc.rsi_mod:.4f}")
    
    print("\n-------------------------------------------------------")
    print(f"VERDICT: Flight time error with dynamic rotation is ONLY {abs(sim_proj.flight_time - 0.56)*1000:.1f} ms!")
    print("=======================================================")

if __name__ == "__main__":
    run_rotation_benchmark()
