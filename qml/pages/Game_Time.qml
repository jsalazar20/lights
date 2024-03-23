import QtQuick 2.0
import Felgo 4.0
import QtQuick.Layouts
import QtQml
import QtMultimedia

import "."
import "../"



AppPage {
  id: root
  title: qsTr("Contrarreloj") // Page title
  tabBarHidden: true

  // Properties for tracking game state
  property int currentRound: 0
  property int totalTime: tiempo.value
  property string selected_device_name
  property int pod_index: 0


  enum GameStates {
      Stopped,
      Prerunning,
      Running
  }

  property int gameState: Game_Time.GameStates.Stopped


  property int remainingTime: tiempo.value
  property int remainingDelay: delay.value

  MediaPlayer {
    id: end_audio
    audioOutput: AudioOutput {}
    source: "../../assets/finish.mp3"
  }

  MediaPlayer {
    id: start_audio
    audioOutput: AudioOutput {}
    source: "../../assets/start.mp3"

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




  RowLayout{
      visible: gameState === Game_Time.GameStates.Stopped // Visible when game is not running
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
          text: "Tiempo"
          Layout.fillWidth: true
          Layout.minimumWidth: 50
          Layout.preferredWidth: 100
          Layout.maximumWidth: 300
          Layout.minimumHeight: 150
          horizontalAlignment: "AlignHCenter"
      }

  AppSlider {
    id: tiempo
    from: 1
    value: 1000*60
    to: 1000*60*10
    stepSize: 10000
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


  // Start delay slider
  RowLayout{
      visible: gameState === Game_Time.GameStates.Stopped // Visible when game is not running
      anchors.top: parent.top
      anchors.topMargin: dp(70)
      width: parent.width

      Rectangle {
          color: 'transparent'
          Layout.fillWidth: true
          Layout.minimumWidth: 20
          Layout.preferredWidth: 200
          Layout.preferredHeight: 20
        }

      AppText{
          text: "Delay inicial"
          Layout.fillWidth: true
          Layout.minimumWidth: 50
          Layout.preferredWidth: 100
          Layout.maximumWidth: 300
          Layout.minimumHeight: 150
          horizontalAlignment: "AlignHCenter"
      }

  AppSlider {
    id: delay
    from: 0
    value: 1000*5
    to: 1000*60
    stepSize: 5000
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

  // Sequential
  RowLayout{
      visible: gameState === Game_Time.GameStates.Stopped // Visible when game is not running
      anchors.top: parent.top
      anchors.topMargin: dp(130)
      width: parent.width

      Rectangle {
          color: 'transparent'
          Layout.fillWidth: true
          Layout.minimumWidth: 20
          Layout.preferredWidth: 100
          Layout.preferredHeight: 20
        }

      AppText{
          text: "Secuencial"
          Layout.fillWidth: true
          Layout.minimumWidth: 50
          Layout.preferredWidth: 100
          Layout.maximumWidth: 300
          Layout.minimumHeight: 150
          horizontalAlignment: "AlignHCenter"
      }

  AppSwitch {
      id: secuencial

  }

  Rectangle {

      color: 'transparent'
      Layout.fillWidth: true
      Layout.minimumWidth: 20
      Layout.preferredWidth: secuencial.checked? dp(50) : 0
      Layout.preferredHeight: 20
    }

  AppButton {

    text: 'Identificar ' + (pod_index + 1)
    visible: secuencial.checked // Visible when game is not running
    Layout.fillWidth: true
    Layout.minimumWidth: 20
    Layout.preferredWidth: 50
    Layout.preferredHeight: 20
    onClicked: {
      indentifyPod()
    }
  }

  Rectangle {

      color: 'transparent'
      Layout.fillWidth: true
      Layout.minimumWidth: 20
      Layout.preferredWidth: secuencial.checked? 148 : 200
      Layout.preferredHeight: 20
    }
 }

  function indentifyPod(){

        let keys = Array.from(application.bleDevice_map.keys());
        selected_device_name = keys[pod_index]
        pod_index = (pod_index + 1) % keys.length;
        var selected_device = application.bleDevice_map.get(selected_device_name)

        turn_off_all()
        // Turn it red
        selected_device.txCharacteristic.formatWrite("LED1;255,0,0")
  }



  // Stopwatch display
  AppText {
    id: stopwatch
    text: formatTime(remainingTime)
    font.pixelSize: sp(80)
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    Timer {
        interval: 10; running: gameState === Game_Time.GameStates.Running; repeat: true
        onTriggered: {
            remainingTime-=10
            check_time_finish();
        }
    }
  }

    //Delay time display
  AppText{
      text: formatTime(remainingDelay)
      Layout.fillWidth: true
      Layout.minimumWidth: 50
      Layout.preferredWidth: 100
      Layout.maximumWidth: 300
      Layout.minimumHeight: 150
      horizontalAlignment: "AlignHCenter"
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.bottom
      anchors.verticalCenterOffset: -dp(100)

      Timer {
          interval: 10; running: gameState === Game_Time.GameStates.Prerunning; repeat: true
          onTriggered: {
              remainingDelay-=10
              check_prerunning_finish();

          }
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

  function check_time_finish(){
  if (remainingTime <= 0){
      gameState = Game_Time.GameStates.Stopped // Stop the game if time's up
      turn_off_all();
      remainingTime = 0;
      console.log("Game finished!");
      end_audio.play()
    }
  }

  function check_prerunning_finish(){
  if (remainingDelay > 1 && remainingDelay <= 2400 && start_audio.playbackState === MediaPlayer.StoppedState){
    start_audio.play()
  }

  if (remainingDelay <= 0){
      gameState = Game_Time.GameStates.Running // Stop the game if time's up
      remainingDelay = 0;
    }
  }


      // Display for current round
      AppText{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: stopwatch.top
        text: "Ronda: " + currentRound
        fontSize: dp(40)
        //visible: currentRound > 0 ? true : false
      }

      // Button to start game
      AppButton {
        anchors.horizontalCenter: parent.horizontalCenter

        anchors.top: stopwatch.bottom
        text: 'INICIAR'
        visible: gameState === Game_Time.GameStates.Stopped // Visible when game is not running
        onClicked: {
          resetGame() // If there was a previous game, restart the game variables
          gameState = Game_Time.GameStates.Prerunning
          gameRound() // Start the first round
        }

  }

  // Function to start a new game round
  function gameRound(){
        currentRound++;
        console.log("Round: " + currentRound)
        turn_off_all()
        // Select a  device
        selected_device_name = secuencial.checked ? getNextDevice() : getRandomDeviceName()
        var selected_device = application.bleDevice_map.get(selected_device_name)

        // Turn it green
        selected_device.txCharacteristic.formatWrite("LED1;255,0,0")
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


  function getNextDevice(){
      let keys = Array.from(application.bleDevice_map.keys());
      selected_device_name = keys[pod_index]
      pod_index = (pod_index + 1) % keys.length;
      return selected_device_name
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
        if (device_name === selected_device_name && gameState === Game_Time.GameStates.Running){
            console.log("Correct device pressed!");
            gameRound();
    }
    }


    // Reset the game state
    function resetGame() {
        currentRound = 0; // Reset current round to 0
        gameState = Game_Time.GameStates.Stopped
        remainingTime = tiempo.value; // Reset elapsed time to 0
        remainingDelay = delay.value;
        selected_device_name = ""; // Clear selected device name
        pod_index = 0;
        turn_off_all(); // Turn off all devices
    }


   // After generating the page, connect device activation signal (bluetooth message recived) to check_interaction function.
   Component.onCompleted: {
       for (let [name, device] of application.bleDevice_map) {
           device.activated.connect(check_interaction);
       }
   }

}
