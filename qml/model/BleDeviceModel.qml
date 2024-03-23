import QtQuick
import Felgo


  BluetoothLeDevice {
    property alias txCharacteristic: txCharacteristic
    property alias rxCharacteristic: rxCharacteristic
    id:root_device

    signal activated(string name, string value);

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
            root_device.activated(root_device.name, value)
            //console.debug("Received: " + value + root_device.name)
          }

      }


    }


  }

