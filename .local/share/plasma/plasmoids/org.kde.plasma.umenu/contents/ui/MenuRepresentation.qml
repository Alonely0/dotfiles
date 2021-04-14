import QtQuick 2.4
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.plasma.private.kicker 0.1 as Kicker

Kicker.DashboardWindow {
    id: root

    property bool smallScreen: ((Math.floor(width / units.iconSizes.huge) <= 22) || (Math.floor(height / units.iconSizes.huge) <= 14))

    property int iconSize: smallScreen ? units.iconSizes.large : units.iconSizes.huge
    
    property int cellSize: {
     if (plasmoid.configuration.gridSize == 0) {
         iconSize + theme.mSize(theme.defaultFont).height
         + (2 * units.smallSpacing)
         + (2 * Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                         highlightItemSvg.margins.left + highlightItemSvg.margins.right))
     } else if (plasmoid.configuration.gridSize == 1) {
         iconSize + theme.mSize(theme.defaultFont).height
         + (10 * units.smallSpacing)
         + (2 * Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                         highlightItemSvg.margins.left + highlightItemSvg.margins.right))
     } else {
         iconSize + theme.mSize(theme.defaultFont).height
         + (14 * units.smallSpacing)
         + (2 * Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                         highlightItemSvg.margins.left + highlightItemSvg.margins.right))
     }
    }

    property bool searching: (searchField.text != "")

    keyEventProxy: searchField
    backgroundColor: Qt.rgba(0, 0, 0, 0.6)

    onKeyEscapePressed: {
        if (searching) {
            searchField.clear();
        } else {
            root.toggle();
        }
    }

    onVisibleChanged: {
        if (!visible) {
            reset();
        } else {
            requestActivate();
        }
    }

    onSearchingChanged: {
        if (searching) {
            pageList.model = runnerModel;
            paginationBar.model = runnerModel;
        } else {
            reset();
        }
    }

    function reset() {
        if (!searching) {
            if (filterListScrollArea.visible) {
                filterList.currentIndex = 0;
            } else {
                pageList.model = rootModel.modelForRow(0);
                paginationBar.model = rootModel.modelForRow(0);
            }
        }

        searchField.text = "";

        pageListScrollArea.focus = true;
        pageList.currentIndex = plasmoid.configuration.favoritesFirst ? 0 : 1;
        pageList.currentItem.itemGrid.currentIndex = -1;
    }

    FocusScope {
        anchors.fill: parent

        focus: true

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                root.visible = false;
            }
        }

        PlasmaExtras.Heading {
            id: dummyHeading

            visible: false

            width: 0

            level: 5
        }

        TextMetrics {
            id: headingMetrics

            font: dummyHeading.font
        }

        ActionMenu {
            id: actionMenu

            onActionClicked: visualParent.actionTriggered(actionId, actionArgument)

            onClosed: {
                if (pageList.currentItem) {
                    pageList.currentItem.itemGrid.currentIndex = -1;
                }
            }
        }

        PlasmaComponents3.TextField {
            id: searchField

            anchors.top: parent.top
            anchors.topMargin: units.largeSpacing * 3
            anchors.horizontalCenter: parent.horizontalCenter

            width: cellSize * 4

            font.pointSize: 12

            placeholderText: i18n("Search...")

            onTextChanged: {
                runnerModel.query = text;
            }

            Keys.onPressed: {
                if(event.modifiers & Qt.ControlModifier) {
                        if(event.key === Qt.Key_Tab) {
                            event.accepted = true;
                            pageList.activateNextPrev(true);
                        }
                } else if (event.key == Qt.Key_Down) {
                    event.accepted = true;
                    pageList.currentItem.itemGrid.tryActivate(0, 0);
                } else if (event.key == Qt.Key_Right) {
                    if (cursorPosition == length) {
                        event.accepted = true;

                        if (pageList.currentItem.itemGrid.currentIndex == -1) {
                            pageList.currentItem.itemGrid.tryActivate(0, 0);
                        } else {
                            pageList.currentItem.itemGrid.tryActivate(0, 1);
                        }
                    }
                } else if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                    if (text != "" && pageList.currentItem.itemGrid.count > 0) {
                        event.accepted = true;
                        pageList.currentItem.itemGrid.tryActivate(0, 0);
                        pageList.currentItem.itemGrid.model.trigger(0, "", null);
                        root.visible = false;
                    }
                } else if (event.key == Qt.Key_Tab) {
                    event.accepted = true;
                    pageList.forceActiveFocus();
                }
            }

            function backspace() {
                if (!root.visible) {
                    return;
                }

                focus = true;
                text = text.slice(0, -1);
            }

            function appendText(newText) {
                if (!root.visible) {
                    return;
                }

                focus = true;
                text = text + newText;
            }
        }

        PlasmaExtras.ScrollArea {
            id: pageListScrollArea

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            width: (cellSize * 7 + units.smallSpacing * 2)
            height: (cellSize * 5)

            focus: true

            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            ListView {
                id: pageList

                anchors.fill: parent

                orientation: Qt.Horizontal
                snapMode: ListView.SnapOneItem

                currentIndex: 0

                model: rootModel.modelForRow(0)

                onCurrentIndexChanged: {
                    positionViewAtIndex(currentIndex, ListView.Contain);
                }

                onCurrentItemChanged: {
                    if (!currentItem) {
                        return;
                    }

                    currentItem.itemGrid.focus = true;
                }

                onModelChanged: {
                    if (pageList.model == runnerModel) {
                        currentIndex = 0;
                    } else {
                        currentIndex = plasmoid.configuration.favoritesFirst ? 0 : 1;
                    }
                }

                onFlickingChanged: {
                    if (!flicking) {
                        var pos = mapToItem(contentItem, root.width / 2, root.height / 2);
                        var itemIndex = indexAt(pos.x, pos.y);
                        currentIndex = itemIndex;
                    }
                }

                function cycle() {
                    enabled = false;
                    enabled = true;
                }

                function activateNextPrev(next) {
                    if (next) {
                        var newIndex = pageList.currentIndex + 1;

                        if (newIndex == pageList.count) {
                            newIndex = 0;
                        }

                        pageList.currentIndex = newIndex;
                    } else {
                        var newIndex = pageList.currentIndex - 1;

                        if (newIndex < 0) {
                            newIndex = (pageList.count - 1);
                        }

                        pageList.currentIndex = newIndex;
                    }
                }

                delegate: Item {
                    width: cellSize * 7  + units.smallSpacing * 2
                    height: parent.height

                    property Item itemGrid: gridView

                    ItemGridView {
                        id: gridView

                        anchors.fill: parent

                        cellWidth: cellSize
                        cellHeight: cellSize

                        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    //                    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                        dragEnabled: (index == 0)

                        model: searching ? runnerModel.modelForRow(index) : rootModel.modelForRow(filterListScrollArea.visible ? filterList.currentIndex : 0).modelForRow(index)

                        onCurrentIndexChanged: {
                            if (currentIndex != -1 && !searching) {
                                pageListScrollArea.focus = true;
                                focus = true;
                            }
                        }

                        onCountChanged: {
                            if (searching && index == 0) {
                                currentIndex = 0;
                            }
                        }

                        onKeyNavUp: {
                            currentIndex = -1;
                            searchField.focus = true;
                        }

                        onKeyNavRight: {
                            var newIndex = pageList.currentIndex + 1;
                            var cRow = currentRow();

                            if (newIndex == pageList.count) {
                                newIndex = 0;
                            }

                            pageList.currentIndex = newIndex;
                            pageList.currentItem.itemGrid.tryActivate(cRow, 0);
                        }

                        onKeyNavLeft: {
                            var newIndex = pageList.currentIndex - 1;
                            var cRow = currentRow();

                            if (newIndex < 0) {
                                newIndex = (pageList.count - 1);
                            }

                            pageList.currentIndex = newIndex;
                            pageList.currentItem.itemGrid.tryActivate(cRow, 5);
                        }

                        Keys.onPressed: {
                            if(event.modifiers & Qt.ControlModifier) {
                                if(event.key === Qt.Key_Tab) {
                                    event.accepted = true;
                                    pageList.activateNextPrev(true);
                                }
                            }
                        }
                    }
                }
            }
        }

        ListView {
            id: paginationBar

            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            width: model.count * units.iconSizes.medium
            height: units.iconSizes.medium

            orientation: Qt.Horizontal

            model: rootModel.modelForRow(0)

            delegate: Item {
                width: units.iconSizes.medium
                height: width

                Rectangle {
                    id: pageDelegate

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }

                    width: parent.width / 2
                    height: width

                    property bool isCurrent: (pageList.currentIndex == index)

                    radius: width / 2

                    color: "white"
                    opacity: 0.5

                    Behavior on width { SmoothedAnimation { duration: units.longDuration; velocity: 0.01 } }
                    Behavior on opacity { SmoothedAnimation { duration: units.longDuration; velocity: 0.01 } }

                    states: [
                        State {
                            when: pageDelegate.isCurrent
                            PropertyChanges { target: pageDelegate; width: parent.width - (units.smallSpacing * 2) }
                            PropertyChanges { target: pageDelegate; opacity: 0.8 }
                        }
                    ]
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: pageList.currentIndex = index;

                    property int wheelDelta: 0

                    function scrollByWheel(wheelDelta, eventDelta) {
                        // magic number 120 for common "one click"
                        // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                        wheelDelta += eventDelta;

                        var increment = 0;

                        while (wheelDelta >= 120) {
                            wheelDelta -= 120;
                            increment++;
                        }

                        while (wheelDelta <= -120) {
                            wheelDelta += 120;
                            increment--;
                        }

                        while (increment != 0) {
                            pageList.activateNextPrev(increment < 0);
                            increment += (increment < 0) ? 1 : -1;
                        }

                        return wheelDelta;
                    }

                    onWheel: {
                        wheelDelta = scrollByWheel(wheelDelta, wheel.angleDelta.y);
                    }
                }
            }
        }

        PlasmaExtras.ScrollArea {
            id: filterListScrollArea

            anchors {
                left: pageListScrollArea.right
                leftMargin: units.smallSpacing
                top: searchField.bottom
                topMargin: units.smallSpacing
                bottom: paginationBar.top
                bottomMargin: units.smallSpacing
            }

            property int desiredWidth: 0

            width: plasmoid.configuration.showFilterList ? desiredWidth : 0

            enabled: !searching
            visible: false

            property alias currentIndex: filterList.currentIndex

            opacity: root.visible ? (searching ? 0.30 : 1.0) : 0.3

            Behavior on opacity { SmoothedAnimation { duration: units.longDuration; velocity: 0.01 } }

            verticalScrollBarPolicy: (opacity == 1.0) ? Qt.ScrollBarAsNeeded : Qt.ScrollBarAlwaysOff

            onEnabledChanged: {
                if (!enabled) {
                    filterList.currentIndex = -1;
                }
            }

            ListView {
                id: filterList

                focus: true

                property bool allApps: false
                property int eligibleWidth: width
                property int hItemMargins: highlightItemSvg.margins.left + highlightItemSvg.margins.right
                model: filterListScrollArea.visible ? rootModel : null

                boundsBehavior: Flickable.StopAtBounds
                snapMode: ListView.SnapToItem
                spacing: 0
                keyNavigationWraps: true

                delegate: MouseArea {
                    id: item

                    property int textWidth: label.contentWidth
                    property int mouseCol

                    width: parent.width
                    height: label.paintedHeight + highlightItemSvg.margins.top + highlightItemSvg.margins.bottom

                    Accessible.role: Accessible.MenuItem
                    Accessible.name: model.display

                    acceptedButtons: Qt.LeftButton

                    hoverEnabled: true

                    onContainsMouseChanged: {
                        if (!containsMouse) {
                            updateCurrentItemTimer.stop();
                        }
                    }

                    function updateCurrentItem() {
                        ListView.view.currentIndex = index;
                        ListView.view.eligibleWidth = Math.min(width, mouseCol);
                    }

                    Timer {
                        id: updateCurrentItemTimer

                        interval: 50
                        repeat: false

                        onTriggered: parent.updateCurrentItem()
                    }

                    PlasmaExtras.Heading {
                        id: label

                        anchors {
                            fill: parent
                            leftMargin: highlightItemSvg.margins.left
                            rightMargin: highlightItemSvg.margins.right
                        }

                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                        opacity: 1.0

                        level: 5

                        text: model.display
                    }
                }

                highlight: PlasmaComponents.Highlight {
                    anchors {
                        top: filterList.currentItem ? filterList.currentItem.top : undefined
                        left: filterList.currentItem ? filterList.currentItem.left : undefined
                        bottom: filterList.currentItem ? filterList.currentItem.bottom : undefined
                    }

                    opacity: filterListScrollArea.focus ? 1.0 : 0.7

                    width: (highlightItemSvg.margins.left
                        + filterList.currentItem.textWidth
                        + highlightItemSvg.margins.right
                        + units.smallSpacing)

                    visible: filterList.currentItem
                }

                highlightFollowsCurrentItem: false
                highlightMoveDuration: 0
                highlightResizeDuration: 0

                onCurrentIndexChanged: applyFilter()

                onCountChanged: {
                    var width = 0;

                    for (var i = 0; i < rootModel.count; ++i) {
                        headingMetrics.text = rootModel.labelForRow(i);

                        if (headingMetrics.width > width) {
                            width = headingMetrics.width;
                        }
                    }

                    filterListScrollArea.desiredWidth = width + hItemMargins + units.gridUnit;
                }

                function applyFilter() {
                    if (filterListScrollArea.visible && !searching && currentIndex >= 0) {
                        pageList.model = rootModel.modelForRow(currentIndex);
                        paginationBar.model = pageList.model;
                    }
                }

                Keys.onPressed: {
                    if(event.modifiers & Qt.ControlModifier) {
                        if(event.key === Qt.Key_Tab) {
                            event.accepted = true;
                            pageList.activateNextPrev(true);
                        }
                    } else if (event.key == Qt.Key_left) {
                        event.accepted = true;

                        var currentRow = Math.max(0, Math.ceil(currentItem.y / cellSize) - 1);

                        if (pageList.currentItem) {
                            pageList.currentItem.itemGrid.tryActivate(currentRow, 5);
                        }
                    } else if (event.key == Qt.Key_Tab) {
                        event.accepted = true;
                        searchField.focus = true;
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        kicker.reset.connect(reset);
        dragHelper.dropped.connect(pageList.cycle);
    }
}
