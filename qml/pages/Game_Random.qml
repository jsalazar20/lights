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
  title: qsTr("Aleatorio") // Page title
  tabBarHidden: true

  // Properties for tracking game state
  property int currentRound: 0
  property int totalRounds: rondas.value
  property string selected_device_name


  property bool running: false
  property int elapsedTime: 0

  MediaPlayer {
    id: end_audio
    audioOutput: AudioOutput {}
    source: "../../assets/beep.mp3"
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


  // Layout for selecting number of rounds
  RowLayout{
      visible: !root.running // Visible when game is not running
      anchors.top: parent.top
      anchors.topMargin: dp(10)
      width: parent.width

      Rectangle {
          color: 'transparent'
          Layout.fillWidth: true
          Layout.minimumWidth: 20
          Layout.preferredWidth: 200
          Layout.preferredHeight: 20
        }

      AppText{
          text: "Rondas"
          Layout.fillWidth: true
          Layout.minimumWidth: 50
          Layout.preferredWidth: 100
          Layout.maximumWidth: 300
          Layout.minimumHeight: 150
          horizontalAlignment: "AlignHCenter"
      }

  AppSlider {
    id: rondas
    from: 1
    value: 10
    to: 50
    Layout.fillWidth: true
    Layout.minimumWidth: 100
    Layout.preferredWidth: 200
    Layout.preferredHeight: 100
  }

  Rectangle {
      color: 'transparent'
      Layout.fillWidth: true
      Layout.minimumWidth: 20
      Layout.preferredWidth: 200
      Layout.preferredHeight: 20
    }
 }



  // Stopwatch display
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

  }

  // Function to format time in hours:minutes:seconds format
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

      // Display for current round
      AppText{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: stopwatch.top
        text: "Ronda: " + currentRound + "/" + totalRounds
        fontSize: dp(40)
        //visible: currentRound > 0 ? true : false
      }

      // Button to start game
      AppButton {
        anchors.horizontalCenter: parent.horizontalCenter

        anchors.top: stopwatch.bottom
        text: 'INICIAR'
        visible: !root.running // Visible when game is not running
        onClicked: {
          resetGame() // If there was a previous game, restart the game variables
          root.running = true
          gameRound() // Start the first round
        }

  }

  // Function to start a new game round
  function gameRound(){
        currentRound++;
        console.log("Round: " + currentRound + "/" + totalRounds)
        turn_off_all()
        // Select a random device
        selected_device_name = getRandomDeviceName()
        var selected_device = application.bleDevice_map.get(selected_device_name)

        // Turn it green
        selected_device.txCharacteristic.formatWrite("LED1;255,0,0")
  }

   // Function to get a random device name from available devices
  function getRandomDeviceName() {
      new_name = selected_device_name
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
        if (device_name === selected_device_name){
            console.log("Correct device pressed!");
            if (currentRound < totalRounds) {
                gameRound();
        }
            else{
                root.running = false
                console.log("Game finished!");
                turn_off_all();
                end_audio.play()
            }
    }
    }


    // Reset the game state
    function resetGame() {
        currentRound = 0; // Reset current round to 0
        running = false; // Set running state to false
        elapsedTime = 0; // Reset elapsed time to 0
        selected_device_name = ""; // Clear selected device name
        turn_off_all(); // Turn off all devices
    }

    Dialog {
      id: gameOverDialog
      autoSize: true
      negativeAction: false
      positiveAction: false
      outsideTouchable: true
      title: "
             Has Perdido :("
    }

   // After generating the page, connect device activation signal (bluetooth message recived) to check_interaction function.
   Component.onCompleted: {
       for (let [name, device] of application.bleDevice_map) {
           device.activated.connect(check_interaction);
       }
   }

}
