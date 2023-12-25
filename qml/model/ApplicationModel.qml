import Felgo 4.0
import QtQuick 2.0
import "./"

QtObject {
  id: appModel

  //property alias connected: bleHeartMonitorDevice.connected
  property  list<BleDeviceModel> bleDevice_list

  property BluetoothLeManager bleManager : BluetoothLeManager {
    discoveryTimeout: 30000
    discoveryRunning: false


    onDeviceDiscovered: device => {
      // Match device with service UUID
      if (device.services.indexOf('{6e400001-b5a3-f393-e0a9-e50e24dcca9e}') > -1) {
        console.debug("Device ", JSON.stringify(device))
      }
    }
  }

  property JsonListModel devicesListModel: JsonListModel {
    source: bleManager.discoveredDevices
  }

  property SortFilterProxyModel filteredDevices: SortFilterProxyModel {
    sourceModel: devicesListModel

    filters: [
      ExpressionFilter {
       expression: !!model.services && (model.services.indexOf('{6e400001-b5a3-f393-e0a9-e50e24dcca9e}') > -1)
      }
    ]
  }

  function connectToDevice(bleDevice) {
    var component = Qt.createComponent("BleDeviceModel.qml");
    var newDevice = component.createObject();
    newDevice.setDevice(bleDevice, true)
    bleDevice_list.push(newDevice)
  }




}
