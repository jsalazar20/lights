import QtQuick 2.0
import Felgo 4.0
import QtQuick.Layouts

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
        var random_device = pick_random_device().txCharacteristic
        random_device.formatWrite("LED1;0,0,255")


  }

   function pick_random_device(){
       var random_device = application.bleDevice_list[Math.floor(Math.random() * application.bleDevice_list.length)];
       return random_device;
   }

   function turn_off_all(){
       for (var i = 0; i < application.bleDevice_list.length; ++i) {

           var device = application.bleDevice_list[i].txCharacteristic;
           device.formatWrite("LED1;0,0,0")
       }

   }

//   function check_interaction(interaction){
//       if(interaction == random_device.tapped):
//           if (currentRound < totalRounds) {
//               currentRound++;
//               startGame();
//           }
//           else {
//               console.log("game finished")
//           }

//   }

}
