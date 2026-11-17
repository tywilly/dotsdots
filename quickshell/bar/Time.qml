pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  readonly property date date: clock.date

  readonly property string timeString: {
    return Qt.formatDateTime(clock.date, "hh:mm")
  }

  readonly property string dateString: {
    return Qt.formatDateTime(clock.date, "ddd MMM d")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
