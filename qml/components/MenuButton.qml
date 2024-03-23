import Felgo 4.0
import QtQuick 2.0

Item {
  id: root

  property real margins: 0
  signal selected()

  AppPaper {
    id: appPaper

    property real elevatedPadding: elevated ? dp(2) : 0

    anchors {
      left: parent.left
      leftMargin: root.margins/2 + elevatedPadding
      top: parent.top
      topMargin: elevatedPadding
    }

    width: parent.width - margins  - elevatedPadding * 2
    height: parent.height - margins - elevatedPadding * 2
    clip: true

    background.color: tileColor
    elevated: mouseArea.pressed
    radius: dp(5)

    AppText {
      id: name
      width: parent.width
      anchors { top: parent.top; topMargin: dp(15); left: parent.left; leftMargin: dp(10)   }
      font.pixelSize: sp(20)
      text: term
      font.bold: true
      wrapMode: Text.WordWrap
    }

    AppText {
      id: id_description
      width: parent.width
      anchors { top: name.bottom; topMargin: dp(5);left: parent.left; leftMargin: dp(10) ; right: parent.right ; rightMargin: dp(10) }
      font.pixelSize: sp(15)
      text: description
      wrapMode: Text.WordWrap
    }


    MouseArea {
      id: mouseArea
      anchors.fill: parent
      onClicked: navigationStack.push(Qt.resolvedUrl(pagename))
    }
  }
}
