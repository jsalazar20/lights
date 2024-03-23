import QtQuick 2.0
import Felgo 4.0
import QtQuick.Layouts
import QtQml
import QtMultimedia


import "."
import "../"
import "../components"

AppPage {
  id: root
  title: qsTr("DRUMSET") // Page title
  tabBarHidden: true


  property string selected_device_name


  SoundEffect {
    id: bombo
    source: "../../assets/bombo.wav"
  }


  // Background Rectangle with gradient
  Rectangle {
    anchors.fill: parent

    gradient: Gradient {
      GradientStop {
        position: 0
        color: "#4D4855"
      }
      GradientStop {
        position: 1
        color: "#000000"
      }
    }
  }


   // Function to get a random device name from available devices
  function getRandomDeviceName() {
      let new_name = selected_device_name
      while (new_name === selected_device_name){
        let keys = Array.from(application.bleDevice_map.keys());
        new_name = keys[Math.floor(Math.random() * keys.length)];
      }
      return new_name;
  }


    // Turn off all the devices
   function turn_off_all(){
       for (let [name, device] of application.bleDevice_map) {
           device.txCharacteristic.formatWrite("LED1;0,0,0");
       }

   }

    // Function to check interaction with devices
    function check_interaction(device_name, msg){
        console.debug(device_name + " sent:" + msg)

        //if (device_name === selected_device_name){}

    }



   // After generating the page, connect device activation signal (bluetooth message recived) to check_interaction function.
   Component.onCompleted: {
       for (let [name, device] of application.bleDevice_map) {
           device.activated.connect(check_interaction);
       }
   }

}
