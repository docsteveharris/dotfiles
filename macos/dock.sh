#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Bear.app"
dockutil --no-restart --add "/Applications/NotePlan.app"
dockutil --no-restart --add "/Applications/Things3.app"
dockutil --no-restart --add "/System/Applications/Calendar.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Brave Browser.app"
dockutil --no-restart --add "/Applications/Zed.app"
dockutil --no-restart --add "/Applications/Utilities/Terminal.app"
dockutil --no-restart --add "/System/Applications/System Settings.app"

killall Dock
