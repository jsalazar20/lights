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
  property int correctButtonIndex: -1
  property int device_idx: 1

  Column{
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter

      AppButton {
        text: 'INICIAR'
        onClicked: {
          startGame()
          //application.txCharacteristic.formatWrite("LED1;255,0,0")
        }
      }



  }

  function startGame(){
        turn_off_all()
        var random_device = getRandomDevice()
        random_device.txCharacteristic.formatWrite("LED1;0,0,255")
  }


  function getRandomDevice() {
      let keys = Array.from(application.bleDevice_map.keys());
      let key = keys[Math.floor(Math.random() * keys.length)];
      return application.bleDevice_map.get(key)
  }



   function turn_off_all(){
       for (let [name, device] of application.bleDevice_map) {
           device.txCharacteristic.formatWrite("LED1;0,0,0");
       }

   }

    function check_interaction(device_name, msg){
        console.debug(device_name + " sent:" + msg)
    }

   Component.onCompleted: {
       for (let [name, device] of application.bleDevice_map) {
           device.activated.connect(check_interaction);
       }
   }

}
