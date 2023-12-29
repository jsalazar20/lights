import QtQuick 2.0
import Felgo 4.0
import QtQuick.Layouts
import QtQml


import "."
import "../"

AppPage {
  id: root
  title: qsTr("Aleatorio")
  tabBarHidden: true

  property int currentRound: 0
  property int totalRounds: rondas.value
  property string selected_device_name


  property bool running: false
  property int elapsedTime: 0

  Rectangle {
    anchors.fill: parent

    gradient: Gradient {
      GradientStop {
        position: 0
        color: "#009FFF"
      }
      GradientStop {
        position: 1
        color: "#ec2F4B"
      }
    }
  }


  RowLayout{
      visible: !root.running
      anchors.top: parent.top
      anchors.topMargin: dp(50)
      AppText{
          text: "Rondas"
      }

  AppSlider {
    id: rondas
    from: 1
    value: 10
    to: 50
  }

  }

  AppText {
    id: stopwatch
    text: formatTime(elapsedTime)
    font.pixelSize: sp(80)
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    Timer {
        interval: 10; running: root.running; repeat: true
        onTriggered: elapsedTime+=10
    }

    function formatTime(milliseconds) {
        var seconds = Math.floor(milliseconds / 1000);
        var minutes = Math.floor(seconds / 60);
        var hours = Math.floor(minutes / 60);

        var formattedMilliseconds = Math.floor((milliseconds % 1000) / 10);
        seconds %= 60;
        minutes %= 60;

        var formattedTime = (hours > 0 ? hours + ":" : "") +
                            (minutes < 10 ? "0" : "") + minutes + ":" +
                            (seconds < 10 ? "0" : "") + seconds + "." +
                            (formattedMilliseconds < 10 ? "0" : "") + formattedMilliseconds;

        return formattedTime;
    }

  }



      AppText{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: stopwatch.top
        text: "Ronda: " + currentRound + "/" + totalRounds
        fontSize: dp(40)
        //visible: currentRound > 0 ? true : false
      }

      AppButton {
        anchors.horizontalCenter: parent.horizontalCenter

        anchors.top: stopwatch.bottom
        text: 'INICIAR'
        visible: !root.running
        onClicked: {
          root.running = true
          gameRound()
        }

  }

  function gameRound(){
        currentRound++;
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
                gameRound();
        }
            else{
                root.running = false
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
