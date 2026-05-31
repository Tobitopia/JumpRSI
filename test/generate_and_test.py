import os
import csv
import math

def generate_jump_profile():
    os.makedirs("test", exist_ok=True)
    filename = "test/jump_profile_100hz.csv"
    
    # Generate 100Hz data (10ms steps)
    dt = 0.01  # 10ms
    duration = 2.5  # 2.5 seconds
    n_samples = int(duration / dt)
    
    samples = []
    for i in range(n_samples):
        t = i * dt
        mag = 1.0
        
        if 0.0 <= t < 1.0:
            # Resting phase
            mag = 1.0
        elif 1.0 <= t < 1.3:
            # Unweighting phase: drops to 0.6G
            # Linear interpolation from 1.0G at 1.0s to 0.6G at 1.3s
            mag = 1.0 - (0.4 / 0.3) * (t - 1.0)
        elif 1.3 <= t < 1.6:
            # Drive phase: rises to 1.8G
            # Linear interpolation from 0.6G at 1.3s to 1.8G at 1.6s
            mag = 0.6 + (1.2 / 0.3) * (t - 1.3)
        elif 1.6 <= t < 1.7:
            # Extension/takeoff phase: drops to 0.3G
            # Linear interpolation from 1.8G at 1.6s to 0.3G at 1.7s
            mag = 1.8 - (1.5 / 0.1) * (t - 1.6)
        elif 1.7 <= t < 2.2:
            # In air (free fall): 0.1G
            mag = 0.1
        elif 2.2 <= t < 2.25:
            # Landing impact: spikes to 2.8G
            # Linear interpolation from 0.1G at 2.2s to 2.8G at 2.25s
            mag = 0.1 + (2.7 / 0.05) * (t - 2.2)
        elif 2.25 <= t < 2.5:
            # Recovery/Stabilization: returns to 1.0G
            # Linear interpolation from 2.8G at 2.25s to 1.0G at 2.5s
            mag = 2.8 - (1.8 / 0.25) * (t - 2.25)
            
        samples.append((int(t * 1000), round(mag, 4)))
        
    with open(filename, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["Timestamp_ms", "Magnitude_G"])
        writer.writerows(samples)
    print(f"Generated {filename} with {len(samples)} samples.")

class SimCalculator:
    def __init__(self, sample_rate):
        self.sample_rate = sample_rate
        self.state = 0  # STATE_START
        self.resting_g = 1.0
        self.ema_alpha = 0.45
        self.filtered_mag = 1.0
        self.last_mag = 1.0
        
        self.last_timestamp = 0
        self.start_time = 0
        self.active_start_time = 0
        self.takeoff_time = 0
        self.flight_time = 0.0
        self.ttt = 0.0
        self.height = 0.0
        self.rsi_mod = 0.0
        
    def process_sample(self, mag, timestamp):
        # Dynamically adjust EMA alpha based on actual sample interval
        if self.last_timestamp != 0:
            dt = float(timestamp - self.last_timestamp)
            if 0 < dt < 500:
                self.ema_alpha = dt / (24.44 + dt)
                if self.ema_alpha < 0.1: self.ema_alpha = 0.1
                if self.ema_alpha > 0.8: self.ema_alpha = 0.8
        else:
            dt = 1000.0 / self.sample_rate
            
        self.filtered_mag = (self.ema_alpha * mag) + ((1.0 - self.ema_alpha) * self.filtered_mag)
        
        # Calculate EMA delay (phase lag compensation)
        ema_delay = ((1.0 - self.ema_alpha) / self.ema_alpha) * dt
        
        if self.state == 0:  # STATE_START -> Simulate transition to IDLE (skip countdown calibration for test simplicity)
            self.state = 2  # STATE_IDLE
            self.resting_g = 1.0
            
        if self.state == 2:  # STATE_IDLE
            if self.filtered_mag < (self.resting_g * 0.85):
                self.state = 3  # STATE_UNWEIGHTING
                self.start_time = timestamp
                self.active_start_time = 0
                
        elif self.state == 3:  # STATE_UNWEIGHTING
            if self.last_mag < self.resting_g and self.filtered_mag >= self.resting_g:
                diff = self.filtered_mag - self.last_mag
                ratio = (self.resting_g - self.last_mag) / diff if diff != 0 else 0
                offset = dt * ratio
                self.active_start_time = int(self.last_timestamp + offset - ema_delay)
                
            if self.filtered_mag > (self.resting_g * 1.25):
                self.state = 4  # STATE_LAUNCHING
                
        elif self.state == 4:  # STATE_LAUNCHING
            takeoff_threshold = 0.40
            if self.filtered_mag < takeoff_threshold:
                self.state = 5  # STATE_IN_AIR
                diff = self.filtered_mag - self.last_mag
                ratio = (takeoff_threshold - self.last_mag) / diff if diff != 0 else 0
                offset = dt * ratio
                self.takeoff_time = int(self.last_timestamp + offset - ema_delay)
                self.ttt = float(self.takeoff_time - self.start_time) / 1000.0
                if self.active_start_time == 0:
                    self.active_start_time = int(self.last_timestamp - ema_delay)
                    
        elif self.state == 5:  # STATE_IN_AIR
            time_in_air_raw = float(timestamp - self.takeoff_time) / 1000.0
            landing_threshold = 1.7
            if time_in_air_raw > 0.15 and self.filtered_mag > landing_threshold:
                self.state = 6  # STATE_LANDED
                diff = self.filtered_mag - self.last_mag
                ratio = (landing_threshold - self.last_mag) / diff if diff != 0 else 0
                offset = dt * ratio
                actual_landing = int(self.last_timestamp + offset - ema_delay)
                self.flight_time = float(actual_landing - self.takeoff_time) / 1000.0
                
                # Height calculation: g * t^2 / 8 * 2.0
                self.height = ((9.80665 * self.flight_time * self.flight_time) / 8.0) * 2.0
                active_time = float(self.takeoff_time - self.active_start_time) / 1000.0
                if active_time > 0:
                    self.rsi_mod = (self.height / active_time) * 0.7
                else:
                    self.rsi_mod = 0.0
                    
        self.last_timestamp = timestamp
        self.last_mag = self.filtered_mag

def run_simulations():
    # Load 100Hz profile
    data = []
    with open("test/jump_profile_100hz.csv") as f:
        reader = csv.reader(f)
        header = next(reader)
        for row in reader:
            data.append((int(row[0]), float(row[1])))
            
    # Test frequencies: 100Hz, 50Hz, 25Hz
    for freq in [100, 50, 25]:
        step = 100 // freq
        sub_data = data[::step]
        
        sim = SimCalculator(freq)
        for t, mag in sub_data:
            sim.process_sample(mag, t)
            if sim.state == 6:
                break
                
        print(f"\n--- Simulation at {freq} Hz ---")
        print(f"Final State: {sim.state} (6 = Landed)")
        print(f"Takeoff Time: {sim.takeoff_time} ms")
        print(f"Flight Time: {sim.flight_time:.4f} s")
        print(f"TTT: {sim.ttt:.4f} s")
        print(f"Jump Height: {sim.height:.4f} m")
        print(f"RSImod: {sim.rsi_mod:.4f}")

if __name__ == "__main__":
    generate_jump_profile()
    run_simulations()
