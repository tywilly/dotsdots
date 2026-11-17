pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property string cpuUsage: "–"
  property var cpuCores: []
  property string cpuLoad: "–"
  property var previousCpuSamples: ({})
  property string memoryUsage: "0%"
  property string networkInfo: "Disconnected"
  property string networkType: "disconnected"
  property bool batteryPresent: false
  property int batteryLevelRaw: 0
  property string batteryLevel: "0%"
  property string batteryIcon: "󰂎"
  property bool batteryCharging: false
  property string temperature: "0°C"
  property var temperatureSensors: []

  // CPU Usage
  Process {
    id: cpuProc
    command: ["sh", "-c", "cat /proc/stat /proc/loadavg"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const previous = root.previousCpuSamples
        const next = {}
        const cores = []
        for (const line of text.trim().split("\n")) {
          const fields = line.trim().split(/\s+/)
          if (/^cpu\d*$/.test(fields[0]) && fields.length >= 5) {
            const values = fields.slice(1, 9).map(Number)
            const total = values.reduce((sum, value) => sum + value, 0)
            const idle = values[3] + (values[4] || 0)
            const old = previous[fields[0]]
            next[fields[0]] = { total: total, idle: idle }
            let usage = null
            if (old && total > old.total) {
              usage = Math.max(0, Math.min(100, 100 * (1 - (idle - old.idle) / (total - old.total))))
            }
            if (fields[0] === "cpu") root.cpuUsage = usage === null ? "–" : Math.round(usage) + "%"
            else cores.push({ name: fields[0].slice(3), usage: usage })
          } else if (/^\d+\.\d+$/.test(fields[0]) && fields.length >= 3) {
            root.cpuLoad = fields.slice(0, 3).join("  ")
          }
        }
        root.previousCpuSamples = next
        root.cpuCores = cores
      }
    }
  }

  // Memory Usage
  Process {
    id: memProc
    command: ["sh", "-c", "free | grep Mem | awk '{printf \"%.1f%%\", ($3/$2) * 100.0}'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        root.memoryUsage = text.trim()
      }
    }
  }

  // Network Info (ethernet takes priority over wifi)
  Process {
    id: netProc
    command: ["sh", "-c", "devices=$(nmcli -t -e no -f TYPE,STATE,DEVICE device status 2>/dev/null); selected=$(printf '%s\\n' \"$devices\" | awk -F: '$1 == \"ethernet\" && $2 == \"connected\" {print; exit}'); [ -n \"$selected\" ] || selected=$(printf '%s\\n' \"$devices\" | awk -F: '$1 == \"wifi\" && $2 == \"connected\" {print; exit}'); if [ -z \"$selected\" ]; then printf 'disconnected\\n'; exit; fi; type=${selected%%:*}; device=${selected##*:}; address=$(nmcli -e no -g IP4.ADDRESS device show \"$device\" 2>/dev/null | head -n 1 | cut -d/ -f1); [ -n \"$address\" ] || address=$(nmcli -e no -g IP6.ADDRESS device show \"$device\" 2>/dev/null | head -n 1 | cut -d/ -f1); [ -n \"$address\" ] || address='No IP'; if [ \"$type\" = wifi ]; then ssid=$(nmcli -t -e no -f IN-USE,SSID device wifi list ifname \"$device\" --rescan no 2>/dev/null | sed -n 's/^\\*://p' | head -n 1); [ -n \"$ssid\" ] && address=\"$ssid · $address\"; fi; printf '%s\\n%s\\n' \"$type\" \"$address\""]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        root.networkType = lines[0] || "disconnected"
        root.networkInfo = lines[1] || "Disconnected"
      }
    }
  }

  // Battery
  Process {
    id: batteryProc
    command: ["sh", "-c", "for battery in /sys/class/power_supply/*; do [ \"$(cat \"$battery/type\" 2>/dev/null)\" = Battery ] || continue; [ \"$(cat \"$battery/present\" 2>/dev/null)\" != 0 ] || continue; cat \"$battery/capacity\" 2>/dev/null || continue; cat \"$battery/status\" 2>/dev/null; break; done"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        const level = parseInt(lines[0])
        root.batteryPresent = !isNaN(level)
        if (!root.batteryPresent) return
        const status = (lines[1] || "Discharging").trim()

        root.batteryLevelRaw = level
        root.batteryLevel = level + "%"
        root.batteryCharging = status === "Charging"

        if (root.batteryCharging) root.batteryIcon = ""
        else if (level >= 90) root.batteryIcon = "󰁹"
        else if (level >= 80) root.batteryIcon = "󰂂"
        else if (level >= 70) root.batteryIcon = "󰂁"
        else if (level >= 60) root.batteryIcon = "󰂀"
        else if (level >= 50) root.batteryIcon = "󰁿"
        else if (level >= 40) root.batteryIcon = "󰁾"
        else if (level >= 30) root.batteryIcon = "󰁽"
        else if (level >= 20) root.batteryIcon = "󰁼"
        else if (level >= 10) root.batteryIcon = "󰁻"
        else root.batteryIcon = "󰁺"
      }
    }
  }

  // Temperature
  Process {
    id: tempProc
    command: ["sensors", "-j"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const readings = []
        try {
          const chips = JSON.parse(text)
          for (const chip in chips) {
            for (const label in chips[chip]) {
              const feature = chips[chip][label]
              if (!feature || typeof feature !== "object") continue
              for (const key in feature) {
                if (/^temp\d+_input$/.test(key) && typeof feature[key] === "number")
                  readings.push({ chip: chip, label: label, value: feature[key] })
              }
            }
          }
        } catch (e) {
          // sensors may be unavailable or report no readable devices.
        }
        root.temperatureSensors = readings
        const primary = readings.find(r => r.label === "Package id 0" || r.label === "Tctl") || readings[0]
        root.temperature = primary ? primary.value.toFixed(1) + "°C" : "N/A"
      }
    }
  }

  // Update timer
  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      cpuProc.running = true
      memProc.running = true
      netProc.running = true
      batteryProc.running = true
      tempProc.running = true
    }
  }
}
