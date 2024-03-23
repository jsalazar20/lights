import Felgo 4.0
import QtQuick 2.0
//import Qt5Compat.GraphicalEffects
//import QtQml.Models 2.1
import "../components"

AppPage {
  id: root
 // navigationBarHidden: true
  useSafeArea: false
  // Use translucent navigation bar an manually handle top offset of page content
//  navigationBarTranslucency: 1
  navigationBarHidden: true


  signal searchRequested(string term)

  AppFlickable {
    id: flickable

    anchors.fill: parent
    anchors.topMargin: Theme.statusBarHeight
    //anchors.bottomMargin: actuallyPlayingOverlay.visible ? actuallyPlayingOverlay.height : 0
    contentHeight: column.height
    contentWidth: parent.width

    Column {
      id: column
      width: parent.width
      spacing: dp(15)

      Item {
        id: titleContainer
        width: parent.width
        height: dp(100)

        AppText {
          text: "Selecciona prueba"
          anchors { horizontalCenter: parent.horizontalCenter ; bottom: parent.bottom ; bottomMargin: dp(20) }
          font.bold: true
          font.pixelSize: sp(30)
        }
      }


/*
      Grid {
        width: parent.width
        columns: 1

        Repeater {
          model: ListModel {
            ListElement {
                tileColor: "#f59a25";
                term: "ALEATORIO"  ;
                pagename: "../pages/Game_Random.qml"
                description: "Las luces se encenderán de forma aleatoria, golpea el número de objetivos indicado en el menor tiempo posible."
            }

            ListElement { tileColor: "#768d9b";
                term: "CONTRARRELOJ" ;
                pagename: "../pages/Game_Time.qml";
                description: "Golpea tantos objetivos como puedas en el tiempo indicado."

            }

            ListElement {
                tileColor: "#4a927e";
                term: "DUELO"
                pagename: "../pages/MonitorPage.qml";
                description: "Cada jugar coge un objetivo. Reacciona cuando se apague la luz antes que tus rivales."
            }

            ListElement {
                tileColor: "#ff6537";
                term: "APÁGALOS TODOS"
                description: "Todos los objetivos se encenderán a la vez. Apágalos lo más rápido que puedas."
            }

            ListElement {
                tileColor: "#f135a3";
                term: "TEST DE LEGER"
                description: "¿Eres capaz de llegar hasta la siguiente luz antes de que se acabe el tiempo? ¡Cada vez va más rápido!"
            }

            ListElement {
                tileColor: "#f14735";
                term: "SIMON DICE"
                description: "Repite los colores en el clásico juego de Simón dice."
            }
            ListElement { tileColor: "#f14735"; term: "SIMON DICE"       }

          }


          MenuButton {
            width: parent.width
            height: dp(150)
            margins: dp(32)
          }
        }
      }
      */
    }
  }


}
