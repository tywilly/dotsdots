import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Scope {
  id: root
  required property var theme
  required property string fontFamily
  property var bindings: []
  property string status: ""
  readonly property var filteredBindings: {
    const query = search.text.trim().toLowerCase()
    return bindings.filter(binding => (binding.keys + " " + binding.action + " " + binding.submap).toLowerCase().includes(query))
  }

  function open() {
    search.text = ""
    bindings = []
    status = "Loading keybindings…"
    panel.visible = true
    search.forceActiveFocus()
    if (!bindingsProcess.running) bindingsProcess.running = true
  }

  function keyNames(binding) {
    const mask = binding.modmask || 0
    const parts = []
    for (const mod of [[64, "Super"], [4, "Ctrl"], [8, "Alt"], [1, "Shift"], [2, "Caps"], [16, "Mod2"], [32, "Mod3"], [128, "Mod5"]])
      if (mask & mod[0]) parts.push(mod[1])
    parts.push(binding.key || (binding.keycode ? "Code " + binding.keycode : "Unknown key"))
    return parts.join(" + ")
  }

  IpcHandler {
    target: "help"
    function toggle(): void { if (panel.visible) panel.visible = false; else root.open() }
    function show(): void { root.open() }
    function hide(): void { panel.visible = false }
  }

  Process {
    id: bindingsProcess
    command: ["hyprctl", "-j", "binds"]
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const data = JSON.parse(text)
          if (!Array.isArray(data)) throw new Error("Unexpected response")
          root.bindings = data.map(binding => ({
            keys: root.keyNames(binding),
            action: binding.description || [binding.dispatcher, binding.arg].filter(Boolean).join(" ") || "No description",
            submap: binding.submap || ""
          }))
          root.status = root.bindings.length ? "" : "No keybindings reported by Hyprland."
        } catch (error) {
          root.status = "Could not load keybindings from Hyprland."
        }
      }
    }
  }

  PanelWindow {
    id: panel
    visible: false
    focusable: true
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: "quickshell-keybinding-help"
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea {
      anchors.fill: parent
      onClicked: panel.visible = false
      Rectangle { anchors.fill: parent; color: root.theme.bgOverlay }
    }

    Rectangle {
      anchors.centerIn: parent
      width: Math.min(820, parent.width - 32)
      height: Math.min(700, parent.height - 32)
      radius: 16
      color: root.theme.bgBase
      border.color: root.theme.bgBorder

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        RowLayout {
          Layout.fillWidth: true
          Text {
            Layout.fillWidth: true
            text: "Hyprland keybindings"
            color: root.theme.accentPrimary
            font.family: root.fontFamily
            font.pixelSize: 18
            font.bold: true
          }
          Text {
            text: "Esc to close"
            color: root.theme.textMuted
            font.family: root.fontFamily
            font.pixelSize: 12
          }
        }

        Rectangle {
          Layout.fillWidth: true
          implicitHeight: 42
          radius: 8
          color: root.theme.bgSurface
          border.color: search.activeFocus ? root.theme.accentPrimary : root.theme.bgBorder
          TextInput {
            id: search
            anchors.fill: parent
            anchors.margins: 10
            verticalAlignment: TextInput.AlignVCenter
            color: root.theme.textPrimary
            selectionColor: root.theme.accentPrimary
            font.family: root.fontFamily
            font.pixelSize: 14
            clip: true
            Accessible.name: "Search keybindings"
            Keys.onEscapePressed: panel.visible = false
            Text {
              visible: !search.text
              text: "Search keys or actions…"
              color: root.theme.textMuted
              font: search.font
            }
          }
        }

        ListView {
          id: list
          Layout.fillWidth: true
          Layout.fillHeight: true
          model: root.filteredBindings
          clip: true
          spacing: 4
          ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

          delegate: Rectangle {
            required property var modelData
            width: list.width
            height: Math.max(38, actionText.implicitHeight + 16)
            radius: 6
            color: root.theme.bgSurface
            RowLayout {
              anchors.fill: parent
              anchors.leftMargin: 12
              anchors.rightMargin: 12
              spacing: 12
              Text {
                Layout.preferredWidth: Math.min(250, list.width * 0.35)
                text: modelData.keys
                color: root.theme.accentPrimary
                font.family: root.fontFamily
                font.pixelSize: 12
                wrapMode: Text.Wrap
              }
              Text {
                id: actionText
                Layout.fillWidth: true
                text: modelData.action + (modelData.submap ? "  [" + modelData.submap + "]" : "")
                color: root.theme.textPrimary
                font.family: root.fontFamily
                font.pixelSize: 12
                wrapMode: Text.WrapAnywhere
              }
            }
          }

          Text {
            anchors.centerIn: parent
            visible: list.count === 0
            text: root.status || "No matching keybindings."
            color: root.theme.textMuted
            font.family: root.fontFamily
            font.pixelSize: 13
          }
        }
      }
    }
  }
}
