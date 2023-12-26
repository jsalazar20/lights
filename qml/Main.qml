import Felgo 4.0
import QtQuick 2.13

import "./pages"
import "./model"

App {
  id: app

  onInitTheme: {
    Theme.colors.statusBarStyle = Theme.colors.statusBarStyleWhite

    Theme.colors.tintColor = "#3EA6DE"
    Theme.colors.backgroundColor = "#3a3a3a"
    Theme.colors.secondaryBackgroundColor = "#303030"
    Theme.colors.textColor = "#FFFCF2"

    Theme.navigationBar.backgroundColor = Theme.colors.backgroundColor
    Theme.navigationBar.titleColor = Theme.colors.textColor
    Theme.navigationBar.dividerColor = Theme.navigationBar.backgroundColor
    Theme.navigationTabBar.backgroundColor = Theme.colors.secondaryBackgroundColor
    Theme.navigationTabBar.titleColor = Theme.colors.tintColor
    Theme.navigationTabBar.titleOffColor = Theme.colors.textColor



    Theme.listItem.backgroundColor = "#363636"
    Theme.listItem.selectedBackgroundColor = "#303030"
    Theme.listItem.detailTextColor = "#aaa"
    Theme.listItem.dividerHeight = 0
  }

  // App object models
  property ApplicationModel application: ApplicationModel { }

  Navigation {
    // enable both tabs and drawer for this demo
    // by default, tabs are shown on iOS and a drawer on Android
    navigationMode: navigationModeTabs

    NavigationItem {
      title: "Inicio"
      iconType: IconType.bolt

      NavigationStack {
          id: navigationStack

          //MonitorPage { }
          MenuPage { }
      }
    }

    NavigationItem {
      title: "Dispostivos"
      iconType: IconType.gears

      NavigationStack {
          DevicesModal {}
      }
    }




}



  }
