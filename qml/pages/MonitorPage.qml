import QtQuick 2.0
import Felgo 4.0

import "."
import "../components"

AppPage {
  title: qsTr("Heart Rate")

  // Use translucent navigation bar an manually handle top offset of page content
  navigationBarTranslucency: 1
  useSafeArea: false

  rightBarItem: TextButtonBarItem {
    text: "Devices"
    onClicked: {
      devicesModal.open()
    }
  }

  Heart{
    id: heart
    bpm: heartRate.beating ? heartRate.bpm : -1
    y: dp(Theme.navigationBar.height) + Theme.statusBarHeight

    MouseArea {
      anchors.fill: parent
      onClicked: devicesModal.open()
    }
  }

  BpmDisplay {
    anchors.top: heart.bottom
    anchors.topMargin: -dp(50)
    width: parent.width
    visible: true
    bpm: heartRate.bpm
    avg: heartRate.avg
    min: heartRate.min
    max: heartRate.max
    beating: heartRate.beating
  }

  AppButton {
    anchors.horizontalCenter: parent.left
    anchors.verticalCenter: parent.verticalCenter
    text: 'ROJO'
    onClicked: {
      application.txCharacteristic.formatWrite("LED1;255,0,0")
    }
  }

  AppButton {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    text: 'VERDE'
    onClicked: {
      application.txCharacteristic.formatWrite("LED1;0,255,0")
    }
  }

  AppButton {
    anchors.horizontalCenter: parent.right
    anchors.verticalCenter: parent.verticalCenter
    text: 'AZUL'
    onClicked: {
      application.txCharacteristic.formatWrite("LED1;0,0,255")
    }
  }

  DevicesModal {
    id: devicesModal
  }

  Connections {
    target: application
    onConnectedChanged: {
      if(application.connected) {
        devicesModal.close()
      }
    }
  }
}
