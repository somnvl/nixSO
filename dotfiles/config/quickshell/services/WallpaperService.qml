pragma Singleton
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel
import QtQuick

Singleton {
    id: root

    property string currentWallpaper: ""
    property string fitMode: "cover"
    property int transitionDuration: 400

    property bool autorotateEnable: false
    property string autorotateFolder: ""
    property int autorotateFrequencyMinutes: 30

    property var rotationQueue: []
    property int queueIndex: 0

    readonly property var validFitModes: ["cover", "contain", "stretch", "tile"]

    FileView {
        id: defaultsFile
        path: Qt.resolvedUrl("../config-defaults/wallpaper.json")
        printErrors: false

        onLoaded: {
            root.fitMode = adapter.fitMode
            root.transitionDuration = adapter.transitionDuration
            root.autorotateEnable = adapter.autorotateEnable
            root.autorotateFolder = adapter.autorotateFolder
            root.autorotateFrequencyMinutes = adapter.autorotateFrequencyMinutes
        }

        adapter: JsonAdapter {
            property string fitMode: "cover"
            property int transitionDuration: 400
            property bool autorotateEnable: false
            property string autorotateFolder: ""
            property int autorotateFrequencyMinutes: 30
        }
    }

    FileView {
        id: stateFile
        path: Quickshell.statePath("wallpaper.json")
        watchChanges: true
        printErrors: false

        onLoaded: {
            if (!adapter.initialized) return
            root.currentWallpaper = adapter.path
            root.fitMode = adapter.fitMode
            root.transitionDuration = adapter.transitionDuration
            root.autorotateEnable = adapter.autorotateEnable
            root.autorotateFolder = adapter.autorotateFolder
            root.autorotateFrequencyMinutes = adapter.autorotateFrequencyMinutes
        }

        adapter: JsonAdapter {
            property bool initialized: false
            property string path: ""
            property string fitMode: "cover"
            property int transitionDuration: 400
            property bool autorotateEnable: false
            property string autorotateFolder: ""
            property int autorotateFrequencyMinutes: 30
        }
    }

    FolderListModel {
        id: rotationFolder
        folder: root.autorotateFolder !== "" ? "file://" + root.autorotateFolder : ""
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp"]
        showDirs: false
    }

    Timer {
        id: rotationTimer
        interval: root.autorotateFrequencyMinutes * 60000
        running: root.autorotateEnable && root.autorotateFolder !== ""
        repeat: true
        triggeredOnStart: false
        onTriggered: root.rotateNow()
    }

    function syncState() {
        stateFile.adapter.initialized = true
        stateFile.adapter.path = root.currentWallpaper
        stateFile.adapter.fitMode = root.fitMode
        stateFile.adapter.transitionDuration = root.transitionDuration
        stateFile.adapter.autorotateEnable = root.autorotateEnable
        stateFile.adapter.autorotateFolder = root.autorotateFolder
        stateFile.adapter.autorotateFrequencyMinutes = root.autorotateFrequencyMinutes
        stateFile.writeAdapter()
    }

    function rebuildQueue() {
        let paths = []
        for (let i = 0; i < rotationFolder.count; i++) {
            paths.push(rotationFolder.get(i, "filePath"))
        }

        for (let i = paths.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1))
            const tmp = paths[i]
            paths[i] = paths[j]
            paths[j] = tmp
        }

        if (paths.length > 1 && paths[0] === root.currentWallpaper) {
            const tmp = paths[0]
            paths[0] = paths[1]
            paths[1] = tmp
        }

        root.rotationQueue = paths
        root.queueIndex = 0
    }

    function rotateNow() {
        if (rotationFolder.count === 0) return
        if (root.rotationQueue.length === 0 || root.queueIndex >= root.rotationQueue.length) {
            rebuildQueue()
        }
        const path = root.rotationQueue[root.queueIndex]
        root.queueIndex++
        root.set(path)
    }

    function set(path) {
        if (path === "") return
        root.currentWallpaper = path
        root.syncState()
    }

    function setFit(mode) {
        if (root.validFitModes.indexOf(mode) === -1) return
        root.fitMode = mode
        root.syncState()
    }

    function setTransition(ms) {
        if (ms < 0) return
        root.transitionDuration = ms
        root.syncState()
    }

    function setAutorotateEnable(enable) {
        root.autorotateEnable = enable
        root.syncState()
    }

    function setAutorotateState(state) {
        root.setAutorotateEnable(state === "on")
    }

    function setAutorotateFolder(folder) {
        root.autorotateFolder = folder
        root.rotationQueue = []
        root.syncState()
    }

    function setAutorotateFrequency(minutes) {
        if (minutes <= 0) return
        root.autorotateFrequencyMinutes = minutes
        rotationTimer.stop()
        rotationTimer.start()
        root.syncState()
    }

    IpcHandler {
        target: "wallpaper"
        function set(path: string): void { root.set(path) }
        function get(): string { return root.currentWallpaper }
        function setFit(mode: string): void { root.setFit(mode) }
        function getFit(): string { return root.fitMode }
        function setTransition(ms: int): void { root.setTransition(ms) }
        function getTransition(): int { return root.transitionDuration }
        function rotateNow(): void { root.rotateNow() }
        function setAutorotateEnable(enable: bool): void { root.setAutorotateEnable(enable) }
        function getAutorotateEnable(): bool { return root.autorotateEnable }
        function setAutorotateState(state: string): void { root.setAutorotateState(state) }
        function setAutorotateFolder(folder: string): void { root.setAutorotateFolder(folder) }
        function getAutorotateFolder(): string { return root.autorotateFolder }
        function setAutorotateFrequency(minutes: int): void { root.setAutorotateFrequency(minutes) }
        function getAutorotateFrequency(): int { return root.autorotateFrequencyMinutes }
    }
}