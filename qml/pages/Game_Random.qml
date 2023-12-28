import QtQuick 2.0
import Felgo 4.0
import QtQuick.Layouts
import QtQml


import "."
import "../"

AppPage {
  title: qsTr("Juego 1")
  tabBarHidden: true

  property int currentRound: 1
  property int totalRounds: 5
  property string selected_device_name

  Column{
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter

      AppButton {
        text: 'INICIAR'
        onClicked: {
          gameRound()
          //application.txCharacteristic.formatWrite("LED1;255,0,0")
        }
      }



  }

  function gameRound(){
        console.log("Round: " + currentRound + "/" + totalRounds)
        turn_off_all()
        selected_device_name = getRandomDeviceName()
        var selected_device = application.bleDevice_map.get(selected_device_name)
        selected_device.txCharacteristic.formatWrite("LED1;255,0,0")
  }


  function getRandomDeviceName() {
      let keys = Array.from(application.bleDevice_map.keys());
      return keys[Math.floor(Math.random() * keys.length)];
  }



   function turn_off_all(){
       for (let [name, device] of application.bleDevice_map) {
           device.txCharacteristic.formatWrite("LED1;0,0,0");
       }

   }

    function check_interaction(device_name, msg){
        console.debug(device_name + " sent:" + msg)
        if (device_name === selected_device_name){
            console.log("Correct device pressed!");
            if (currentRound < totalRounds) {
                currentRound++;
                gameRound();
        }
            else{
                console.log("Game finished!");
                turn_off_all();
            }
    } else{
            console.log("Wrong button pressed. Try again!");
        }
    }

   Component.onCompleted: {
       for (let [name, device] of application.bleDevice_map) {
           device.activated.connect(check_interaction);
       }
   }

}
