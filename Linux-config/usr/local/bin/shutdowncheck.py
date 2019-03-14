#!/usr/bin/python

import RPi.GPIO as GPIO
import signal
import os
import syslog
import time

CMD_PI_SHUTDOWN = 24
PI_IS_RUNNING = 25

SIGNALS_TO_NAMES_DICT = dict((getattr(signal, n), n) \
	for n in dir(signal) if n.startswith('SIG') and '_' not in n)

def cleanup(*args):
	syslog.syslog(syslog.LOG_INFO, 'Exiting on %s (%d). Telling Sleepy Pi system is NOT running on Pin %d.' % (SIGNALS_TO_NAMES_DICT[sig], sig, PI_IS_RUNNING))
	GPIO.output(PI_IS_RUNNING, GPIO.LOW)
	os._exit(0)

syslog.openlog('SleepyPi')
syslog.syslog(syslog.LOG_INFO, 'Telling Sleepy Pi 2 that system is running on pin %d.' % (PI_IS_RUNNING))

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(CMD_PI_SHUTDOWN, GPIO.IN)
GPIO.setup(PI_IS_RUNNING, GPIO.OUT)
GPIO.output(PI_IS_RUNNING, GPIO.HIGH)

while True:
	if (GPIO.input(CMD_PI_SHUTDOWN)):
		syslog.syslog(syslog.LOG_INFO, 'Sleepy Pi 2 is requesting shutdown on %d.' % (CMD_PI_SHUTDOWN))
		os.system('shutdown -h now')
		break

	for sig in (signal.SIGABRT, signal.SIGINT, signal.SIGTERM):
		signal.signal(sig, cleanup)

	time.sleep(0.5)
