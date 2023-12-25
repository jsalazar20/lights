import QtQuick 2.0
import Felgo 4.0

import "."

AppPage {
  title: qsTr("Menu")

  // Use translucent navigation bar an manually handle top offset of page content
  navigationBarTranslucency: 1
  useSafeArea: false

  rightBarItem: TextButtonBarItem {
    text: "Devices"
    onClicked: {
      devicesModal.open()
    }
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

        for (var i = 0; i < application.bleDevice_list.length; ++i) {

            var device = application.bleDevice_list[i].txCharacteristic;
            console.debug(Object.getOwnPropertyNames(device))
            device.formatWrite("LED1;0,255,0")
        }

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

}
