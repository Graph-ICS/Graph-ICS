pragma Singleton

import QtQuick 2.15
import QtCharts 2.15

import Global 1.0

// Constants for the theming of the application
QtObject {
    readonly property bool darkMode: Global.themeSettings.darkModeEnabled
    readonly property bool accentEnabled: Global.themeSettings.accentEnabled

    readonly property color background: darkMode ? "#212121" : "#ffffff"
    readonly property color onbackground: darkMode ? "#ffffff" : "#111111"

    readonly property color surface: darkMode ? "#303030" : "#eceff1"
    readonly property color onsurface: darkMode ? "#ffffff" : "#111111"

    readonly property color primary: darkMode ? "#40556b" : "#64b5f6"
    readonly property color onprimary: darkMode ? "#ffffff" : "#111111"

    readonly property color primaryLight: darkMode ? "#6c8199" : "#9be7ff"
    readonly property color onprimaryLight: darkMode ? "#111111" : "#111111"

    readonly property color primaryDark: darkMode ? "#152c40" : "#2286c3"
    readonly property color onprimaryDark: darkMode ? "#ffffff" : "#111111"

    readonly property color secondary: darkMode ? "#ffb74d" : "#ff9800"
    readonly property color onsecondary: darkMode ? "#111111" : "#111111"

    readonly property color secondaryLight: darkMode ? "#ffe97d" : "#ffc947"
    readonly property color onsecondaryLight: darkMode ? "#111111" : "#111111"

    readonly property color secondaryDark: darkMode ? "#c88719" : "#c66900"
    readonly property color onsecondaryDark: darkMode ? "#111111" : "#111111"

    readonly property var opacity: QtObject {
        // overlay
        readonly property double hover: 0.04
        readonly property double pressed: 0.12
        // control
        readonly property double disabled: 0.38
        readonly property double normal: 1.0
    }

    readonly property int baseHeight: 28
    readonly property int smallHeight: 24
    readonly property int mediumHeight: 32
    readonly property int largeHeight: 40

    readonly property int smallSpacing: 4
    readonly property int largeSpacing: 8

    readonly property int marginWidth: 10

    readonly property var font: QtObject {
        // Lato
        readonly property font h1: Qt.font({
                                               "pixelSize": 101,
                                               "family": latoLight.name,
                                               "letterSpacing": -1.5,
                                               "capitalization": Font.MixedCase
                                           })
        readonly property font h2: Qt.font({
                                               "pixelSize": 63,
                                               "family": latoLight.name,
                                               "letterSpacing": -0.5,
                                               "capitalization": Font.MixedCase
                                           })
        readonly property font h3: Qt.font({
                                               "pixelSize": 50,
                                               "family": latoRegular.name,
                                               "letterSpacing": 0,
                                               "capitalization": Font.MixedCase
                                           })
        readonly property font h4: Qt.font({
                                               "pixelSize": 36,
                                               "family": latoRegular.name,
                                               "letterSpacing": 0.25,
                                               "capitalization": Font.MixedCase
                                           })
        readonly property font h5: Qt.font({
                                               "pixelSize": 25,
                                               "family": latoRegular.name,
                                               "letterSpacing": 0,
                                               "capitalization": Font.MixedCase
                                           })
        readonly property font h6: Qt.font({
                                               "pixelSize": 21,
                                               "family": latoRegular.name,
                                               "letterSpacing": 0.15,
                                               "capitalization": Font.MixedCase
                                           })
        readonly property font subtitle1: Qt.font({
                                                      "pixelSize": 17,
                                                      "family": latoRegular.name,
                                                      "letterSpacing": 0.15,
                                                      "capitalization": Font.MixedCase
                                                  })
        readonly property font subtitle2: Qt.font({
                                                      "pixelSize": 15,
                                                      "family": latoRegular.name,
                                                      "letterSpacing": 0.1,
                                                      "capitalization": Font.MixedCase
                                                  })
        // Roboto
        readonly property font body1: Qt.font({
                                                  "pixelSize": 16,
                                                  "family": robotoRegular.name,
                                                  "letterSpacing": 0.5,
                                                  "capitalization": Font.MixedCase
                                              })
        readonly property font body2: Qt.font({
                                                  "pixelSize": 14,
                                                  "family": robotoRegular.name,
                                                  "letterSpacing": 0.25,
                                                  "capitalization": Font.MixedCase
                                              })
        readonly property font button: Qt.font({
                                                   "pixelSize": 14,
                                                   "family": robotoMedium.name,
                                                   "letterSpacing": 1.25,
                                                   "capitalization": Font.AllUppercase
                                               })
        readonly property font caption: Qt.font({
                                                    "pixelSize": 12,
                                                    "family": robotoRegular.name,
                                                    "letterSpacing": 0.4,
                                                    "capitalization": Font.MixedCase
                                                })
        readonly property font overline: Qt.font({
                                                     "pixelSize": 10,
                                                     "family": robotoRegular.name,
                                                     "letterSpacing": 1.5,
                                                     "capitalization": Font.AllUppercase
                                                 })
    }

    readonly property FontLoader latoRegular: FontLoader {
        source: "qrc:/Lato/Lato-Regular.ttf"
    }

    readonly property FontLoader latoLight: FontLoader {
        source: "qrc:/Lato/Lato-Light.ttf"
    }

    readonly property FontLoader robotoRegular: FontLoader {
        source: "qrc:/Roboto/Roboto-Regular.ttf"
    }
    readonly property FontLoader robotoMedium: FontLoader {
        source: "qrc:/Roboto/Roboto-Medium.ttf"
    }

    readonly property var icon: QtObject {
        readonly property url play: darkMode ? "qrc:/play_arrow_black_24dp" : "qrc:/play_arrow_white_24dp"
        readonly property url pause: darkMode ? "qrc:/pause_black_24dp" : "qrc:/pause_white_24dp"
        readonly property url stop: darkMode ? "qrc:/stop_black_24dp" : "qrc:/stop_white_24dp"
        readonly property url edit: darkMode ? "qrc:/edit_black_24dp" : "qrc:/edit_white_24dp"
        readonly property url undo: darkMode ? "qrc:/undo_black_24dp" : "qrc:/undo_white_24dp"
        readonly property url redo: darkMode ? "qrc:/redo_black_24dp" : "qrc:/redo_white_24dp"
        readonly property url videocam: darkMode ? "qrc:/videocam_black_24dp" : "qrc:/videocam_white_24dp"
        readonly property url videocam_off: darkMode ? "qrc:/videocam_off_black_24dp" : "qrc:/videocam_off_white_24dp"
        readonly property url image: "qrc:/image_black_24dp"
        readonly property url data: "qrc:/assessment_black_24dp"
        readonly property url cloud_upload: darkMode ? "qrc:/cloud_upload_black_24dp" : "qrc:/cloud_upload_white_24dp"
        readonly property url trash: darkMode ? "qrc:/delete_black_24dp" : "qrc:/delete_white_24dp"
        readonly property url file: darkMode ? "qrc:/insert_drive_file_black_24dp" : "qrc:/insert_drive_file_white_24dp"
        readonly property url record: darkMode ? "qrc:/radio_button_checked_black_24dp" : "qrc:/radio_button_checked_white_24dp"
        readonly property url record_off: darkMode ? "qrc:/radio_button_unchecked_black_24dp" : "qrc:/radio_button_unchecked_white_24dp"
        readonly property url clear: darkMode ? "qrc:/clear_black_24dp" : "qrc:/clear_white_24dp"
        readonly property url cut: darkMode ? "qrc:/content_cut_black_24dp" : "qrc:/content_cut_white_24dp"
        readonly property url copy: darkMode ? "qrc:/content_copy_black_24dp" : "qrc:/content_copy_white_24dp"
        readonly property url paste: darkMode ? "qrc:/content_paste_go_black_24dp" : "qrc:/content_paste_go_white_24dp"
        readonly property url add: darkMode ? "qrc:/add_circle_black_24dp" : "qrc:/add_circle_white_24dp"
        readonly property url remove: darkMode ? "qrc:/remove_circle_black_24dp" : "qrc:/remove_circle_white_24dp"
        readonly property url cancel: darkMode ? "qrc:/cancel_black_24dp" : "qrc:/cancel_white_24dp"
        readonly property url swapVert: darkMode ? "qrc:/swap_vert_black_24dp" : "qrc:/swap_vert_white_24dp"
        readonly property url saveAs: "qrc:/save_as_FILL1_wght400_GRAD0_opsz48.svg"
    }

    // ViewArea colors
    readonly property var viewArea: QtObject {
        readonly property var colors: ["dodgerblue", "deeppink", "slateblue", "greenyellow", "springgreen", "gold", "coral", "deepskyblue", "crimson", "olivedrab"]
    }
}
