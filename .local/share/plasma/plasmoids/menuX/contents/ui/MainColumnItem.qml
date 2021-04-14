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


import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0

//
//import QtQuick 2.0
import QtQuick 2.4
import QtGraphicalEffects 1.0
//import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kwindowsystem 1.0
import org.kde.plasma.private.shell 2.0
import org.kde.plasma.private.kicker 0.1 as Kicker
import QtQuick.Layouts 1.0
import org.kde.kcoreaddons 1.0 as KCoreAddons

import "code/tools.js" as Tools

Item {
    id: item

    width:  allColumn.width + tileColumn.width
    height: root.height
    property int iconSize: units.iconSizes.smallMedium
    property int cellSize: iconSize + theme.mSize(theme.defaultFont).height
                           + (2 * units.smallSpacing)
                           + (2 * Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                                           highlightItemSvg.margins.left + highlightItemSvg.margins.right))
    property bool searching: (searchField.text != "")
    property int tileSide: 64 + 30
    onSearchingChanged: {
        if (!searching) {
            reset();
        }
    }

    Connections {
        target: plasmoid

        onExpandedChanged: {
            if (expanded) {
                playAllGrid.start()
            }else
            {
                searchField.opacity = 0
            }
        }
    }
    SequentialAnimation {
        id: playAllGrid
        running: false
        NumberAnimation { target: allColumn ; property: "y"; from: 100; to: 0; duration: 500; easing.type: Easing.InOutQuad}
        NumberAnimation { target: searchField ; property: "opacity"; from: 0.5; to: 1; duration: 300; easing.type: Easing.InOutQuad}
    }

    function reset() {
        mainColumn.visibleGrid = allAppsGrid
        searchField.clear();
        searchField.focus = true
        allAppsGrid.tryActivate(0,0);
    }

    function reload(){
        searchField.opacity = 0
        allColumn.visible = false
        tileColumn.visible = false
        allAppsGrid.model = null
        documentsFavoritesGrid.model = null
        preloadAllAppsTime.done = false
        preloadAllAppsTime.defer()
    }

    KWindowSystem {
        id: kwindowsystem
    }
    KCoreAddons.KUser {   id: kuser  }
    Row{
        anchors.fill: parent
        spacing: units.iconSizes.small

        Item {
            id: allColumn

            width:  250
            height: parent.height

            MouseArea {

                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                LayoutMirroring.enabled: Qt.application.layoutDirection == Qt.RightToLeft
                LayoutMirroring.childrenInherit: true


                PlasmaComponents.Menu {
                    id: contextMenu

                    PlasmaComponents.MenuItem {
                        action: plasmoid.action("configure")
                    }
                }

                PlasmaExtras.Heading {
                    id: dummyHeading

                    visible: false
                    width: 0
                    level: 1
                }

                TextMetrics {
                    id: headingMetrics
                    font: dummyHeading.font
                }

                Timer {
                    id: preloadAllAppsTime
                    property bool done: false
                    interval: 1000
                    repeat: false
                    onTriggered: {
                        if (done) {
                            return;
                        }
                        for (var i = 0; i < rootModel.count; ++i) {
                            var model = rootModel.modelForRow(i);
                            if (model.description === "KICKER_ALL_MODEL") {
                                allAppsGrid.model = model;
                                documentsFavoritesGrid.model = rootModel.modelForRow(1);
                                done = true;
                                allColumn.visible =  true
                                tileColumn.visible = true
                                playAllGrid.start()
                                break;
                            }
                        }
                    }
                    function defer() {
                        if (!running && !done) {
                            restart();
                        }
                    }
                }

                Kicker.ContainmentInterface {
                    id: containmentInterface
                }


                Item {

                    id: mainColumn
                    anchors.top: parent.top
                    anchors.topMargin: units.smallSpacing
                    width:  parent.width
                    anchors.bottom: searchField.top
                    anchors.bottomMargin: units.smallSpacing * 2
                    property Item visibleGrid: allAppsGrid

                    function tryActivate(row, col) {
                        if (visibleGrid) {
                            visibleGrid.tryActivate(row, col);
                        }
                    }

                    ItemMultiGridView {
                        id: allAppsGrid
                        anchors.top: parent.top
                        z: (opacity == 1.0) ? 1 : 0
                        width:  parent.width
                        height: parent.height
                        enabled: (opacity == 1.0) ? 1 : 0
                        opacity: searching ? 0 : 1
                        model: rootModel.modelForRow(2);
                        onOpacityChanged: {
                            if (opacity == 1.0) {
                                allAppsGrid.flickableItem.contentY = 0;
                                mainColumn.visibleGrid = allAppsGrid;
                            }
                        }
                        onKeyNavRight: globalFavoritesGrid.tryActivate(0,0)
                    }

                    ItemMultiGridView {
                        id: runnerGrid
                        anchors.top: parent.top
                        z: (opacity == 1.0) ? 1 : 0
                        width:  parent.width
                        height: Math.min(implicitHeight, parent.height)
                        enabled: (opacity == 1.0) ? 1 : 0
                        model: runnerModel
                        grabFocus: true
                        opacity: searching ? 1.0 : 0.0
                        onOpacityChanged: {
                            if (opacity == 1.0) {
                                mainColumn.visibleGrid = runnerGrid;
                            }
                        }
                        onKeyNavRight: globalFavoritesGrid.tryActivate(0,0)
                    }



                    Keys.onPressed: {
                        console.log(event.key)
                        if (event.key == Qt.Key_Tab) {
                            event.accepted = true;
                            globalFavoritesGrid.tryActivate(0,0)
                        } else if (event.key == Qt.Key_Backspace) {
                            event.accepted = true;
                            if(searching)
                                searchField.backspace();
                            else
                                searchField.focus = true
                        } else if (event.key == Qt.Key_Escape) {
                            event.accepted = true;
                            if(searching){
                                searchField.clear()
                            } else {
                                root.toggle()
                            }
                        } else if (event.text != "") {
                            event.accepted = true;
                            searchField.appendText(event.text);
                        }
                    }

                }


                PlasmaComponents.TextField {
                    id: searchField
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: units.smallSpacing
                    focus: true
                    height: units.iconSizes.medium
                    width:  parent.width
                    visible: true
                    opacity: 0
                    onTextChanged: {
                        runnerModel.query = text;
                    }
                    function clear() {
                        text = "";
                    }
                    function backspace() {
                        if(searching){
                            text = text.slice(0, -1);
                        }
                        focus = true;
                    }
                    function appendText(newText) {
                        if (!root.visible) {
                            return;
                        }
                        focus = true;
                        text = text + newText;
                    }
                    Keys.onPressed: {
                        if (event.key == Qt.Key_Space) {
                            event.accepted = true;
                        } else if (event.key == Qt.Key_Down) {
                            event.accepted = true;
                            mainColumn.tryActivate(0,0)
                        } else if (event.key == Qt.Key_Tab || event.key == Qt.Key_Up) {
                            event.accepted = true;
                            mainColumn.tryActivate(0,0)
                        } else if (event.key == Qt.Key_Backspace) {
                            event.accepted = true;
                            if(searching)
                                searchField.backspace();
                            else
                                searchField.focus = true
                        } else if (event.key == Qt.Key_Escape) {
                            event.accepted = true;
                            if(searching){
                                clear()
                            } else {
                                root.toggle()
                            }
                        }
                    }
                }


                onPressed: {
                    if (mouse.button == Qt.RightButton) {
                        contextMenu.open(mouse.x, mouse.y);
                    }
                }

                onClicked: {
                    if (mouse.button == Qt.LeftButton) {
                    }
                }
            }

        }

        Item {
            id: tileColumn
            width:  tileSide * 3.5
            height: root.height

            property int iconSize: units.iconSizes.large

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                LayoutMirroring.enabled: Qt.application.layoutDirection == Qt.RightToLeft
                LayoutMirroring.childrenInherit: true

                Connections {
                    target: kicker

                    onReset: {

                    }

                    onDragSourceChanged: {
                        if (!dragSource) {
                            // FIXME TODO HACK: Reset all views post-DND to work around
                            // mouse grab bug despite QQuickWindow::mouseGrabberItem==0x0.
                            // Needs a more involved hunt through Qt Quick sources later since
                            // it's not happening with near-identical code in the menu repr.
                            rootModel.refresh();
                        }
                    }
                }

                Column {
                    id: middleRow

                    width: parent.width
                    height: parent.height
                    spacing: units.smallSpacing

                    //                    PlasmaExtras.Heading {
                    //                        anchors.horizontalCenter: parent.horizontalCenter
                    ////                        anchors.right: icon.left
                    ////                        anchors.rightMargin: units.largeSpacing
                    //                        elide: Text.ElideRight
                    //                        wrapMode: Text.NoWrap
                    //                        color: theme.textColor
                    //                        level: 2
                    //                        //font.bold: true
                    //                        //font.weight: Font.Bold
                    //                        text: i18n("Hello") + " " + kuser.fullName + "!"
                    //                        //Behavior on opacity { SmoothedAnimation { duration: units.longDuration; velocity: 0.01 } }
                    //                    }


                    PlasmaExtras.Heading {
                        id: favoritesColumnLabel

                        x: units.smallSpacing
                        width: parent.width - x
                        //anchors.topMargin: units.smallSpacing
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap

                        color: theme.textColor

                        level: 5
                        font.bold: true
                        font.weight: Font.Bold

                        text: i18n("Favorites")

                        opacity: (enabled ? 1.0 : 0.3)

                        Behavior on opacity { SmoothedAnimation { duration: units.longDuration; velocity: 0.01 } }
                    }


                    ItemGridView {
                        id: globalFavoritesGrid

                        property int rows: 2

                        width:  parent.width
                        height: rows * tileSide

                        cellWidth:  tileSide
                        cellHeight: tileSide
                        iconSize:   root.iconSize
                        square: true

                        model: globalFavorites

                        dropEnabled: true
                        usesPlasmaTheme: false

                        opacity: (enabled ? 1.0 : 0.3)


                        onCurrentIndexChanged: {
                            //                        preloadAllAppsTimer.defer();
                        }

                        onKeyNavRight: {
                            //                        mainColumn.tryActivate(currentRow(), 0);
                        }
                        onKeyNavLeft: {
                            mainColumn.visibleGrid.tryActivate(0,0);

                        }

                        onKeyNavDown: {
                            documentsFavoritesGrid.tryActivate(0,0)
                        }


                        Keys.onPressed: {
                            if (event.key == Qt.Key_Tab) {
                                event.accepted = true;
                                documentsFavoritesGrid.tryActivate(0,0)
                            } else if (event.key == Qt.Key_Backspace) {
                                event.accepted = true;
                                if(searching)
                                    searchField.backspace();
                                else
                                    searchField.focus = true
                            } else if (event.key == Qt.Key_Escape) {
                                event.accepted = true;
                                if(searching){
                                    searchField.clear()
                                } else {
                                    root.toggle()
                                }
                            } else if (event.text != "") {
                                event.accepted = true;
                                searchField.appendText(event.text);
                            }
                        }

                        Binding {
                            target: globalFavorites
                            property: "iconSize"
                            value: root.iconSize
                        }
                    }

                    PlasmaExtras.Heading {
                        x: units.smallSpacing
                        width: parent.width - x

                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap

                        color: theme.textColor

                        level: 5
                        font.bold: true
                        font.weight: Font.Bold

                        text: i18n("Recent")

                        opacity: (enabled ? 1.0 : 0.3)

                    }


                    ItemGridView {
                        id: documentsFavoritesGrid
                        property int rows: 3

                        width:  parent.width
                        height: rows * tileSide

                        cellWidth:   tileSide
                        cellHeight:  tileSide
                        iconSize:  iconSize
                        square: true

                        model: rootModel.modelForRow(1);

                        dropEnabled: true
                        usesPlasmaTheme: false

                        opacity: (enabled ? 1.0 : 0.3)
                        onCurrentIndexChanged: {
                        }

                        onKeyNavLeft: {
                            mainColumn.visibleGrid.tryActivate(0,0);
                        }

                        onKeyNavUp: {
                            globalFavoritesGrid.tryActivate(0,0);
                        }

                        Keys.onPressed: {
                            if (event.key == Qt.Key_Tab) {
                                event.accepted = true;
                                mainColumn.visibleGrid.tryActivate(0,0)
                            }  else if (event.key == Qt.Key_Backspace) {
                                event.accepted = true;
                                if(searching)
                                    searchField.backspace();
                                else
                                    searchField.focus = true
                            } else if (event.key == Qt.Key_Escape) {
                                event.accepted = true;
                                if(searching){
                                    searchField.clear()
                                } else {
                                    root.toggle()
                                }
                            } else if (event.text != "") {
                                event.accepted = true;
                                searchField.appendText(event.text);
                            }

                        }
                    }






                }


                onPressed: {
                    if (mouse.button == Qt.RightButton) {
                        contextMenu.open(mouse.x, mouse.y);
                    }
                }

                onClicked: {
                    if (mouse.button == Qt.LeftButton) {
                        root.toggle();
                    }
                }
            }

        }

    }
    Component.onCompleted: {
        searchField.focus = true
    }
}

