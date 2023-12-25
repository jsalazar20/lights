import Felgo 4.0
import QtQuick 2.0

QtObject {
  id: appModel

  property alias connected: bleHeartMonitorDevice.connected
  property alias bleDevice: bleHeartMonitorDevice
  property alias txCharacteristic: txCharacteristic

  property BluetoothLeManager bleManager : BluetoothLeManager {
    discoveryTimeout: 30000
    discoveryRunning: false

    BluetoothLeDevice {
      id: bleHeartMonitorDevice

      BluetoothLeService {
        uuid: '{6e400001-b5a3-f393-e0a9-e50e24dcca9e}'


        BluetoothLeCharacteristic {
          id: txCharacteristic
          uuid: '{6e400002-b5a3-f393-e0a9-e50e24dcca9e}' // Value
          dataFormat: 0x19 //string utf-8

          function formatWrite(text) {
            let data = new Uint8Array(text.length)
            for (var i = 0; i < text.length; i++) {
                data[i] = text.charCodeAt(i)
            }
            write(data.buffer)
          }

        }


        BluetoothLeCharacteristic {
          id: rxCharacteristic
          uuid: '{6e400003-b5a3-f393-e0a9-e50e24dcca9e}' // Value
          dataFormat: 0x19 //string utf-8

            onValueChanged: value => {
              console.debug("Received: " + value)
            }

        }

      }
    }

    onDeviceDiscovered: device => {
      // Match device with service UUID
      if (device.services.indexOf('{6e400001-b5a3-f393-e0a9-e50e24dcca9e}') > -1) {
        //bleHeartMonitorDevice.setDevice(device, true)
        //discoveryRunning = false
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
    bleHeartMonitorDevice.setDevice(bleDevice, true)
    bleManager.discoveryRunning = false
  }

}
