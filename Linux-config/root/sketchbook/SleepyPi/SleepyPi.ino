// 
// This sketch merges functionality from:
// https://github.com/SpellFoundry/SleepyPi2/blob/master/examples/ButtonOnOff2/ButtonOnOff2.ino and
// https://github.com/SpellFoundry/SleepyPi2/blob/master/examples/LowVoltageShutdown/LowVoltageShutdown.ino and
// https://github.com/SpellFoundry/SleepyPi2/blob/master/examples/ButtonOnOff3/ButtonOnOff3.ino
// by Spell Foundry (https://spellfoundry.com/) to create an example that
// implements a low voltage disconnect function like a UPS. When the supply
// voltage falls below the low threshold for 30 seconds, the Arduino signals
// the RPi to shutdown. When the voltage recovers to above the power-on
// threshold, the RPi boots.
//
// If the RPi shuts down or reboots, it idles after shutdown at a value around
// 109mA. We can then detect this current and decide that the RPi is in a
// reboot, or that it has reached the shutdown state and the Sleepy Pi can
// safely remove power and go to sleep itself.
//
// The low voltage shutdown can be overridden by pressing the button. The RPi
// will wake on button press and stay powered for one hour. Extend the time to
// one hour again by pressing the button. The override is ignored when voltage
// is below the force-off voltage.
//
// To shutdown the RPi, hold the User Button for 2-8 seconds. If the button is
// held down more than 8 seconds the Sleepy Pi will cut the power to the RPi
// regardless of any handshaking.
// 
// While powered, the state, supply voltage, and current prints to the serial
// monitor twice per second.
//


// **** INCLUDES *****
#include "SleepyPi2.h"
#include <Time.h>
#include <LowPower.h>
#include <PCF8523.h>
#include <Wire.h>


// Constants
#define kBUTTON_POWEROFF_TIME_MS  2000                // 2 seconds
#define kBUTTON_FORCEOFF_TIME_MS  8000                // 8 seconds

#define kPI_CURRENT_THRESHOLD_MA  120

#define POWER_ON_VOLTAGE          99.9
#define POWER_OFF_VOLTAGE         11.4
#define FORCE_OFF_VOLTAGE         9.3

#define LOW_VOLTAGE_TIME_MS       30000               // 30 seconds
#define OVERRIDE_TIME_MS          3600000             // 1 hour

const int LED_PIN = 13;


// States
typedef enum {
  eWAIT = 0,
  eBUTTON_PRESSED,
  eBUTTON_WAIT_ON_RELEASE,
  eBUTTON_HELD,
  eBUTTON_RELEASED
}ebutton_state;
String ebutton_map[] = { "eWAIT", "eBUTTON_PRESSED", "eBUTTON_WAIT_ON_RELEASE", "eBUTTON_HELD", "eBUTTON_RELEASED" };

typedef enum {
  ePI_OFF = 0,
  ePI_BOOTING,
  ePI_ON,
  ePI_SHUTTING_DOWN
}epi_state;
String epi_map[] = { "ePI_OFF", "ePI_BOOTING", "ePI_ON", "ePI_SHUTTING_DOWN" };

volatile bool  buttonPressed = false;
ebutton_state  button_state = eWAIT;
epi_state      pi_state = ePI_OFF;
bool           pi_reboot = false;
unsigned long  time = 0,
               timePress = 0,
               timeLow = 0,
               timeVeryLow = 0;
float          min_pi_current = 9999;

// Setup the Periodic Timer.
// Use one of eTB_SECOND or eTB_MINUTE or eTB_HOUR.
eTIMER_TIMEBASE PeriodicTimer_Timebase = eTB_SECOND;  // timebase set to seconds
uint8_t         PeriodicTimer_Value= 5;               // timer interval in units of timebase (e.g. 5 seconds)


void button_isr() {
  // A handler for the Button interrupt.
  buttonPressed = true;
}

void alarm_isr() {
  // A handler for the Alarm interrupt.
}

void setup() {
  SleepyPi.simulationMode = false;                    // disable simulation mode

  // Configure "standard" LED pin.
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);                         // turn off LED

  SleepyPi.enablePiPower(false);
  SleepyPi.enableExtPower(false);

  // Allow wake-up triggered by button press.
  attachInterrupt(1, button_isr, LOW);                // button pin

  SleepyPi.rtcInit(true);

  // Initialize serial communication.
  Serial.begin(9600);
  Serial.println("Setup() complete...");
  delay(50);
}

void loop() {
  bool pi_handshake;
  bool pi_running;
  unsigned long buttonTime;
  float supply_voltage;
  float pi_current;

  // Enter power-down state with ADC and BOD module disabled.
  // Wake up when wake button is pressed.
  // Once button is pressed, stay awake - this allows the timer to keep running.

  time = millis();
  // Check for time rollover.
  if((time < timeLow) || (time < timeVeryLow) || (time < timePress)) {
    timeLow = time;
    timeVeryLow = time;
    timePress = 0;
  }

  switch(button_state) {
    case eWAIT:
      SleepyPi.rtcClearInterrupts();  

      // Allow wake up alarm to trigger interrupt on falling edge.
      attachInterrupt(0, alarm_isr, FALLING);         // alarm pin

      // Set the Periodic Timer
      SleepyPi.setTimer1(PeriodicTimer_Timebase, PeriodicTimer_Value);

      // Enter power down state with ADC and BOD module disabled.
      // Wake up when wake up pin is low or Alarm fired.
      SleepyPi.powerDown(SLEEP_FOREVER, ADC_OFF, BOD_OFF); 
      // GO TO SLEEP....
      // ....
      // ....
      // I'm awake !!!  
      digitalWrite(LED_PIN, HIGH);                     // turn on LED
      // What woke me up? Was it a button press or a scheduled wake?
      // Check on button press.
      if(buttonPressed == false) {        
        // Woken by an alarm interrupt.
        // Do some general housekeeping.
        // ...Check on our RPi.
        pi_handshake = SleepyPi.checkPiStatus(false);
        pi_running = SleepyPi.checkPiStatus(kPI_CURRENT_THRESHOLD_MA, false);
        switch(pi_state) {           
          case ePI_BOOTING:
            // Check if we have finished booting.
            if(pi_handshake == false) {
              if(pi_running == false) {
                // Shock, horror! it's not running!!
                // Assume it has been manually shutdown, so let's cut the power.
                Serial.println("Pi not running, forcing power off...");
                SleepyPi.enablePiPower(false);
                SleepyPi.enableExtPower(false);
                pi_state = ePI_OFF;
              }
              else {
                // Still not completed booting so let's carry on waiting...
                pi_state = ePI_BOOTING;
              }
            }
            else {
              // We have booted up!
              pi_state = ePI_ON;
              pi_reboot = false;
              Serial.println("Pi boot process complete.");
            }
            break;
          case ePI_ON:
            // Check if it is still on?
            if(pi_handshake == false) {
              if(pi_running == false) {
                // Shock, horror! it's not running!!
                // Assume it has been manually shutdown, so let's cut the power.
                Serial.println("Pi not running, forcing power off...");
                SleepyPi.enablePiPower(false);
                SleepyPi.enableExtPower(false);
                pi_state = ePI_OFF;
              }
              else {
                // Handshake is down, but it's still drawing power above the idle threshold.
                // Assume reboot or shutdown initiated manually.
                Serial.println("Handshake dropped while Pi running, transitioning to shutdown state.");
                pi_state = ePI_SHUTTING_DOWN;
              }
            }
            else {
              // Still on, all's well. Keep this state.
              pi_state = ePI_ON;
              pi_reboot = false;
            }
            break;
          case ePI_SHUTTING_DOWN:
            // Is it still shutting down?
            if(pi_handshake == false) {
              if(pi_running == false) {
                // Finished a shutdown, force the power off.
                Serial.println("Pi finished shutdown, powering off...");
                SleepyPi.enablePiPower(false);
                SleepyPi.enableExtPower(false);
                pi_state = ePI_OFF;
                pi_reboot = false;
              }
              else {
                // Handshake is down, but it's still drawing power above the idle threshold.
                Serial.println("Handshake dropped while Pi shutting down, waiting for reboot or shutdown.");
                pi_reboot = true;
              }
            }
            else {
              if(pi_reboot == true) {
                // Handshake re-asserted during shutdown without Pi going idle, assume reboot initiated manually.
                Serial.println("Pi hardware handshake re-asserted while shutting down, transitioning to booting state.");
                pi_state = ePI_BOOTING;
                pi_reboot = false;
              }
              else {
                // Still shutting down. Keep this state.
                pi_state = ePI_SHUTTING_DOWN;
              }
            }
            break;
          case ePI_OFF:
            if(pi_handshake) {
              Serial.println("Pi hardware handshake asserted, transitioning to running state.");
              SleepyPi.enablePiPower(true);
              SleepyPi.enableExtPower(true);
              pi_state = ePI_ON;
              pi_reboot = false;
            }
            else if (pi_running) {
              // Handshake is down, but it's still drawing power above the idle threshold.
              Serial.println("Handshake dropped while Pi shutting down, waiting for reboot or shutdown.");
              SleepyPi.enablePiPower(true);
              SleepyPi.enableExtPower(true);
              pi_state = ePI_SHUTTING_DOWN;
              pi_reboot = true;
            }
            break;
          default:                                    // intentional drop-thru
            // RPi off, so we'll continue to wait for a button press to tell us to switch it on.
            delay(10);
            pi_state = ePI_OFF;
            break;
        }
        button_state = eWAIT;                         // set state to loop back around and go to sleep again

        // Disable external pin interrupt on wake-up pin.
        detachInterrupt(0);
        SleepyPi.ackTimer1();
      }
      else {
        Serial.println("Button press event...");
        // This was a button press so change the button state (and stay awake).
        buttonPressed = false;
        // Disable the alarm interrupt.
        detachInterrupt(0);
        // Disable external pin interrupt on wake-up pin.
        detachInterrupt(1);
        button_state = eBUTTON_PRESSED;
      }
      break;
    case eBUTTON_PRESSED:
      buttonPressed = false;
      timePress = millis();                           // log press time
      pi_handshake = SleepyPi.checkPiStatus(false);
      if(pi_handshake == false) {
        Serial.println("Pi not running, powering on...");
        // Switch on the Pi.
        SleepyPi.enablePiPower(true);
        SleepyPi.enableExtPower(true);
        pi_state = ePI_BOOTING;
      }
      button_state = eBUTTON_WAIT_ON_RELEASE;
      digitalWrite(LED_PIN, HIGH);                    // turn on LED
      attachInterrupt(1, button_isr, HIGH);           // will go high on release
      break;
    case eBUTTON_WAIT_ON_RELEASE:
      if(buttonPressed == true) {
        detachInterrupt(1);
        buttonPressed = false;
        time = millis();                              // log release time
        button_state = eBUTTON_RELEASED;
      }
      else {
        // Carry on waiting.
        button_state = eBUTTON_WAIT_ON_RELEASE;
      }
      break;
    case eBUTTON_RELEASED:
      pi_handshake = SleepyPi.checkPiStatus(false);
      if(pi_handshake == true) {
        // Check how long we have held button for.
        buttonTime = time - timePress;
        if(buttonTime > kBUTTON_FORCEOFF_TIME_MS) {
          Serial.println("Button long-pressed, forcing power off...");
          // Force Pi off.
          SleepyPi.enablePiPower(false);
          SleepyPi.enableExtPower(false);
          pi_state = ePI_OFF;
        }
        else if (buttonTime > kBUTTON_POWEROFF_TIME_MS) {
          Serial.println("Button pressed, starting shutdown...");
          // Start a shutdown.
          pi_state = ePI_SHUTTING_DOWN;
          SleepyPi.piShutdown();
          SleepyPi.enableExtPower(false);
        }
        else {
          // Button not held long enough, do nothing.
          Serial.println("Button released, no action taken...");
        }
      }
      else {
        // Pi not running.
      }
      attachInterrupt(1, button_isr, LOW);            // button pin
      button_state = eWAIT;
      break;
    default:
      break;
  }

  // Diagnostics logging.
  Serial.print("St: " + epi_map[pi_state] +
    ", Rb: " + String(pi_reboot ? "true" : "false") +
    ", PiH: " + String(pi_handshake ? "true" : "false") +
    ", PiR: " + String(pi_running ? "true" : "false") +
    ", B: " + ebutton_map[button_state]);
  delay(10);                                          // voltage reading is artificially high if we don't delay first
  supply_voltage = SleepyPi.supplyVoltage();
  pi_current = SleepyPi.rpiCurrent();
  if(pi_current < min_pi_current) {
    min_pi_current = pi_current;
  }
  Serial.print("; Input: ");
  Serial.print(supply_voltage);
  Serial.print(" V (");
  if(supply_voltage > POWER_OFF_VOLTAGE) {
    Serial.print("normal");
  }
  else if(supply_voltage > FORCE_OFF_VOLTAGE) {
    Serial.print("below power-off");
  }
  else {
    Serial.print("below force-off");
  }
  Serial.print("), ");
  Serial.print(pi_current);
  Serial.println(" mA");
  Serial.print(" (min: ");
  Serial.print(min_pi_current);
  Serial.println(" mA)");

  if((button_state == eWAIT) || (button_state == eBUTTON_RELEASED)) {
    digitalWrite(LED_PIN, LOW);                         // turn off LED
  }

  // Boot or shutdown based on supply voltage.
  if((pi_running == true) || (pi_handshake == true)) {
    if(supply_voltage > POWER_OFF_VOLTAGE) {
      // Voltage is normal. Reset the low voltage counter.
      timeLow = time;
    }
    if(supply_voltage > FORCE_OFF_VOLTAGE) {
      timeVeryLow = time;
    }
    // Check for low voltage.
    // Allow override with the button during low voltage state, but not during very low voltage/force-off state.
    if((time - timeVeryLow > LOW_VOLTAGE_TIME_MS) ||
      ((time - timeLow > LOW_VOLTAGE_TIME_MS) && (timePress == 0 || (time - timePress > OVERRIDE_TIME_MS)))) {
      Serial.println("Voltage shutdown point reached, starting shutdown...");
      // Start a shutdown.
      pi_state = ePI_SHUTTING_DOWN;
      SleepyPi.piShutdown();
      SleepyPi.enableExtPower(false);
    }
  }
  else {
    // Check for voltage recovery.
    if(supply_voltage >= POWER_ON_VOLTAGE) {
      Serial.println("Recovery voltage reached, powering on...");
      // Switch on the Pi.
      SleepyPi.enablePiPower(true);
      SleepyPi.enableExtPower(true);
      pi_state = ePI_BOOTING;
    }
  }

  // Don't overload the serial buffer.
  delay(500);
}
