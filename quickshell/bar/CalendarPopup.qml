import Quickshell
import QtQuick

PopupWindow {
  id: calendar

  required property var theme
  required property string fontFamily
  required property date today
  required property bool triggerHovered
  property int displayedYear: today.getFullYear()
  property bool popupHovered: false

  anchor.edges: Edges.Bottom
  anchor.gravity: Edges.Bottom
  anchor.adjustment: PopupAdjustment.Flip | PopupAdjustment.Slide
  implicitWidth: 540
  implicitHeight: 704
  color: theme.bgBase
  visible: false

  onTriggerHoveredChanged: {
    if (triggerHovered) {
      closeTimer.stop()
      if (!visible) displayedYear = today.getFullYear()
      visible = true
    } else {
      closeTimer.restart()
    }
  }
  onPopupHoveredChanged: {
    if (popupHovered) closeTimer.stop()
    else closeTimer.restart()
  }

  Timer {
    id: closeTimer
    interval: 300
    onTriggered: {
      if (!calendar.triggerHovered && !calendar.popupHovered) calendar.visible = false
    }
  }

  Rectangle {
    anchors.fill: parent
    color: calendar.theme.bgBase
    border.color: calendar.theme.bgBorder
    radius: 8

    HoverHandler { onHoveredChanged: calendar.popupHovered = hovered }

    Row {
      id: header
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.topMargin: 10
      spacing: 18

      Repeater {
        model: ["‹", "year", "›"]
        delegate: Rectangle {
          required property string modelData
          width: modelData === "year" ? 70 : 32
          height: 30
          radius: 6
          color: buttonHover.hovered && modelData !== "year" ? calendar.theme.bgHover : "transparent"
          Accessible.role: modelData === "year" ? Accessible.StaticText : Accessible.Button
          Accessible.name: modelData === "year" ? String(calendar.displayedYear) : (modelData === "‹" ? "Previous year" : "Next year")

          Text {
            anchors.centerIn: parent
            text: parent.modelData === "year" ? calendar.displayedYear : parent.modelData
            color: calendar.theme.textPrimary
            font.family: calendar.fontFamily
            font.pixelSize: 16
            font.bold: parent.modelData === "year"
          }
          HoverHandler { id: buttonHover }
          TapHandler {
            enabled: parent.modelData !== "year"
            onTapped: calendar.displayedYear += parent.modelData === "‹" ? -1 : 1
          }
        }
      }
    }

    Grid {
      anchors.top: header.bottom
      anchors.topMargin: 8
      anchors.horizontalCenter: parent.horizontalCenter
      columns: 3
      columnSpacing: 14
      rowSpacing: 8

      Repeater {
        model: 12
        delegate: Column {
          id: month
          required property int index
          readonly property int firstDay: new Date(calendar.displayedYear, index, 1).getDay()
          readonly property int daysInMonth: new Date(calendar.displayedYear, index + 1, 0).getDate()
          width: 164
          spacing: 2

          Text {
            width: parent.width
            height: 22
            horizontalAlignment: Text.AlignHCenter
            text: Qt.locale().standaloneMonthName(month.index, Locale.LongFormat)
            color: calendar.theme.textPrimary
            font.family: calendar.fontFamily
            font.pixelSize: 13
            font.bold: true
          }

          Grid {
            columns: 7
            Repeater {
              model: 7
              delegate: Text {
                required property int index
                width: 23
                height: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: Qt.locale().standaloneDayName(index === 0 ? 7 : index, Locale.NarrowFormat)
                color: calendar.theme.textMuted
                font.family: calendar.fontFamily
                font.pixelSize: 11
              }
            }
          }

          Grid {
            columns: 7
            Repeater {
              model: 42
              delegate: Rectangle {
                required property int index
                readonly property int day: index - month.firstDay + 1
                readonly property bool validDay: day > 0 && day <= month.daysInMonth
                readonly property bool isToday: validDay && calendar.displayedYear === calendar.today.getFullYear()
                  && month.index === calendar.today.getMonth() && day === calendar.today.getDate()
                width: 23
                height: 19
                radius: 9
                color: isToday ? calendar.theme.accentPrimary : "transparent"

                Text {
                  anchors.centerIn: parent
                  text: parent.validDay ? parent.day : ""
                  color: parent.isToday ? calendar.theme.bgBase : calendar.theme.textPrimary
                  font.family: calendar.fontFamily
                  font.pixelSize: 11
                  font.bold: parent.isToday
                }
              }
            }
          }
        }
      }
    }
  }
}
