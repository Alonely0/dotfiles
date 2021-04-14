import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import "lib"

GroupBox {
	id: tileEditorRectField
	title: "Label"
	implicitWidth: parent.implicitWidth
	Layout.fillWidth: true

	// readonly property int xLeft: tileGrid.columns - (appObj.tileX + appObj.tileW)

	style: GroupBoxStyle {}

	RowLayout {
		anchors.fill: parent

		ColumnLayout {
			Layout.fillWidth: true

			RowLayout {
				PlasmaComponents.Label { text: "x:" }
				TileEditorSpinBox {
					key: 'x'
					minimumValue: 0
					// maximumValue: tileGrid.columns - (appObj.tile && appObj.tile.w-1 || 0)
					// maximumValue: appObj.tileX + tileEditorRectField.xLeft
				}
			}
			RowLayout {
				PlasmaComponents.Label { text: "y:" }
				TileEditorSpinBox {
					key: 'y'
					minimumValue: 0
				}
			}
			RowLayout {
				PlasmaComponents.Label { text: "w:" }
				TileEditorSpinBox {
					key: 'w'
					minimumValue: 1
					// maximumValue: tileGrid.columns - (appObj.tile && appObj.tile.x || 0)
					// maximumValue: appObj.tileW + tileEditorRectField.xLeft
				}
			}
			RowLayout {
				PlasmaComponents.Label { text: "h:" }
				TileEditorSpinBox {
					key: 'h'
					minimumValue: 1
				}
			}
		}

		GridLayout {
			id: resizeGrid
			Layout.fillWidth: true
			rows: 4
			columns: 4

			Repeater {
				model: resizeGrid.rows * resizeGrid.columns
				
				PlasmaComponents.Button {
					Layout.fillWidth: true
					implicitWidth: 20
					property int w: (modelData % resizeGrid.columns) + 1
					property int h: Math.floor(modelData / resizeGrid.columns) + 1
					text: '' + w + 'x' + h
					checked: w <= appObj.tileW && h <= appObj.tileH
					// enabled: w - appObj.tileW <= tileEditorRectField.xLeft
					onClicked: {
						appObj.tile.w = w
						appObj.tile.h = h
						appObj.tileChanged()
						tileGrid.tileModelChanged()
					}
				}
			}
		}
	}
}
