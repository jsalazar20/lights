import Felgo 4.0
import QtQuick 2.0
import QtQuick.Layouts

Item {
    RowLayout{
        visible: !root.running // Visible when game is not running
        anchors.top: parent.top
        anchors.topMargin: dp(10)
        width: parent.width

        Rectangle {
            color: 'transparent'
            Layout.fillWidth: true
            Layout.minimumWidth: 20
            Layout.preferredWidth: 200
            Layout.preferredHeight: 20
          }

        AppText{
            text: "Rondas"
            Layout.fillWidth: true
            Layout.minimumWidth: 50
            Layout.preferredWidth: 100
            Layout.maximumWidth: 300
            Layout.minimumHeight: 150
            horizontalAlignment: "AlignHCenter"
        }

    AppSlider {
      id: rondas
      from: 1
      value: 10
      to: 50
      Layout.fillWidth: true
      Layout.minimumWidth: 100
      Layout.preferredWidth: 200
      Layout.preferredHeight: 100
    }

    Rectangle {
        color: 'transparent'
        Layout.fillWidth: true
        Layout.minimumWidth: 20
        Layout.preferredWidth: 200
        Layout.preferredHeight: 20
      }
   }
}
