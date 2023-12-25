import QtQuick 2.0
import Felgo 4.0

AppModal {
  id: modal
  pushBackContent: navigationStack

  NavigationStack {
    navigationBar.titleAlignLeft: false

    AppPage {
      title: qsTr("Devices")

      leftBarItem: TextButtonBarItem {
        text: "Close"
        onClicked: {
          if(application.bleManager.discoveryRunning) {
            application.bleManager.discoveryRunning = false
          }
          modal.close()
        }
      }

      rightBarItem: TextButtonBarItem {
        id: searchButton
        visible: !application.connected
        text: application.bleManager.discoveryRunning ? qsTr("Stop") : qsTr("Search")

        onClicked: {
          application.bleManager.discoveryRunning = !application.bleManager.discoveryRunning
        }

        AppActivityIndicator {
          animating: application.bleManager.discoveryRunning
          hidesWhenStopped: true
          anchors.verticalCenter: parent.verticalCenter
          anchors.right: parent.left
          anchors.rightMargin: -dp(15)
          iconSize: dp(16)
        }
      }

      AppListView {
        id: devicesListView
        anchors.fill: parent
        model: application.filteredDevices

        Behavior on opacity {
          NumberAnimation {
            duration: 150
          }
        }

        delegate: AppListItem {
          text: model.name !== "" ? model.name : qsTr("Unknown")
          detailText: qsTr("Available")
          showDisclosure: false
          rightItem: AppIcon {
            iconType: "\uf294"
            anchors.verticalCenter: parent.verticalCenter
            width: dp(26)
          }

          onSelected: index => {
            NativeDialog.confirm(qsTr("Connect"), qsTr("Connect to %1?").arg(text), function(accepted) {
              if(accepted) {
                // Get the unmodified model data
                application.connectToDevice(application.filteredDevices.get(index))
              }
            })
          }
        }
      }

//      AppCard {
//        id: deviceCard
//        enabled: opacity == 1
//        opacity: 0
//        width: parent.width
//        margin: dp(15)
//        paper.radius: dp(5)

//        paper.background.color: Theme.listItem.backgroundColor

//        Behavior on opacity {
//          NumberAnimation {
//            duration: 300
//          }
//        }

//        content: AppText {
//          width: parent.width
//          leftPadding: dp(Theme.contentPadding)
//          topPadding: dp(Theme.contentPadding)
//          text: application.bleDevice.name !== "" ? application.bleDevice.name : qsTr("Unkown device")
//        }

//        actions: Row {
//          AppButton {
//            text: qsTr("Disconnect")
//            flat: false
//            horizontalMargin: dp(Theme.contentPadding)
//            verticalMargin: dp(Theme.contentPadding)
//            onClicked: {
//              NativeDialog.confirm(qsTr("Disconnect"), qsTr("Disconnect this device?"), function(accepted) {
//                if(accepted) {
//                  application.bleDevice.disconnect()
//                }
//              })
//            }
//          }
//        }
//      }
    }
  }
}
