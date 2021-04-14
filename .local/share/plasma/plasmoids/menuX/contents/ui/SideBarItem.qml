/***************************************************************************
 *   Copyright (C) 2013-2015 by Eike Hein <hein@kde.org>                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0
import QtQuick.Layouts 1.1
//
import QtGraphicalEffects 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kwindowsystem 1.0
import org.kde.plasma.private.shell 2.0
import org.kde.plasma.private.kicker 0.1 as Kicker

import org.kde.kcoreaddons 1.0 as KCoreAddons // kuser
import org.kde.plasma.private.sessions 2.0 as Sessions
import org.kde.plasma.private.quicklaunch 1.0
import QtQuick.Dialogs 1.2


import "code/tools.js" as Tools

Item {
    id: item

    height: root.height

    property int iconSize: units.iconSizes.smallMedium
    width:  iconSize + 8

    Logic {   id: logic }

    PlasmaCore.DataSource {
        id: pmEngine
        engine: "powermanagement"
        connectedSources: ["PowerDevil", "Sleep States"]
        function performOperation(what) {
            var service = serviceForSource("PowerDevil")
            var operation = service.operationDescription(what)
            service.startOperationCall(operation)
        }
    }
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }

    KCoreAddons.KUser {   id: kuser  }

    Sessions.SessionsModel {
        id: sessionsModel
        includeUnusedSessions: false
    }

    PlasmaComponents.Highlight {
        id: delegateHighlight
        visible: false
        z: -1 // otherwise it shows ontop of the icon/label and tints them slightly
    }
    FileDialog {
        id: folderDialog
        visible: false
        folder: shortcuts.pictures

        function getPath(val){
            if(val == 1)
                return shortcuts.pictures
            else if (val == 2)
                return shortcuts.documents
            else if (val == 3)
                return shortcuts.music
            else if (val == 4)
                return shortcuts.home
        }
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        spacing: 4
        ListDelegate {
            id: aButtonsss
            text: "About This System"
            highlight: delegateHighlight
            icon: "bookmarks"
            size: iconSize
            onClicked: logic.openUrl("file:///usr/share/applications/org.kde.kinfocenter.desktop")
        }

        ListDelegate {
            text: "System Monitor"
            highlight: delegateHighlight
            icon: "utilities-system-monitor"
            size: iconSize
            onClicked: logic.openUrl("file:///usr/share/applications/org.kde.ksysguard.desktop")
        }

        Item{
            Layout.fillHeight: true
        }

        //        PlasmaCore.IconItem {
        //            id: icon
        //            height: units.iconSizes.medium
        //            width:  units.iconSizes.medium
        //            Layout.preferredWidth: units.iconSizes.medium
        //            source: visible ? (kuser.faceIconUrl.toString() || "user-identity") : ""
        //            visible: root.showFace
        //            usesPlasmaTheme: false
        //            anchors.right: parent.right
        //            anchors.rightMargin: units.smallSpacing
        //        }
        ListDelegate {
            id: currentUserItem
            text: ""
            //subText: i18n("Current user")
            icon: kuser.faceIconUrl.toString() || "user-identity"
            interactive: false
            size: iconSize
            interactiveIcon: KCMShell.authorize("user_manager.desktop").length > 0
            onIconClicked: KCMShell.open("user_manager")
            usesPlasmaTheme: false
        }

        ListDelegate {
            text: "Pictures"
            highlight: delegateHighlight
            icon: "folder-pictures"
            size: iconSize
            onClicked: executable.exec("dolphin --new-window "+folderDialog.getPath(1))
        }

        ListDelegate {
            text: "Documents"
            highlight: delegateHighlight
            icon: "folder-documents"
            size: iconSize
            onClicked: executable.exec("dolphin --new-window "+folderDialog.getPath(2))
        }

        ListDelegate {
            text: "Music"
            highlight: delegateHighlight
            icon: "folder-music"
            size: iconSize
            onClicked: executable.exec("dolphin --new-window "+folderDialog.getPath(3))
        }


        ListDelegate {
            text: "Music"
            highlight: delegateHighlight
            icon: "user-home"
            size: iconSize
            onClicked: executable.exec("dolphin --new-window "+folderDialog.getPath(4))
        }




        ListDelegate {
            text: "System Preferences"
            highlight: delegateHighlight
            icon: "configure"
            size: iconSize
            onClicked: logic.openUrl("file:///usr/share/applications/systemsettings.desktop")
        }

        ListDelegate {
            text: i18nc("@action", "Lock Screen")
            icon: "system-lock-screen"
            highlight: delegateHighlight
            enabled: pmEngine.data["Sleep States"]["LockScreen"]
            size: iconSize
            onClicked: pmEngine.performOperation("lockScreen")
        }
        ListDelegate {
            text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Leave ... ")
            //text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Log Out ") + kuser.fullName
            highlight: delegateHighlight
            icon: "system-log-out"
            size: iconSize
            //onClicked: //root.logoutRequested()//pmEngine.performOperation("requestShutDown")
            onClicked: pmEngine.performOperation("requestShutDown")
        }
        Item {
            height: 4
        }

    }
}


