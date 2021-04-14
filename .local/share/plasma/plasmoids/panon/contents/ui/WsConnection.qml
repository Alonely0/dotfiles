import QtQuick 2.0
import QtWebSockets 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "utils.js" as Utils
/*
 * This module starts a python back-end client, 
 * and pushs messages from the client to a queue.
 *
 * A queue is required to store new data sent from the 
 * audio back-end. Because if new audio data is used 
 * directly as an image by the shaders, those images 
 * may be used before they are loaded, which will cause 
 * flikering problems.
 */
Item{

    readonly property var cfg:plasmoid.configuration

    property variant queue

    property bool enable_wave_data:false
    property bool enable_spectrum_data:false

    WebSocketServer {
        id: server
        listen: true
        onClientConnected: {
            webSocket.onTextMessageReceived.connect(function(message) {
                queue.push(message)
            });
        }
    }

    readonly property string startBackEnd:{
        var cmd=Utils.chdir_scripts_root()+'exec python3 -m panon.backend.client '
        cmd+=server.port
        var be=['pyaudio','soundcard','fifo'][cfg.backendIndex]
        cmd+=' --backend='+be
        if(be=='soundcard')
            cmd+=' --device-index="'+cfg.pulseaudioDevice+'"'
        if(be=='fifo')
            cmd+=' --fifo-path='+cfg.fifoPath
        cmd+=' --fps='+cfg.fps
        if(cfg.reduceBass)
            cmd+=' --reduce-bass'
        if(cfg.glDFT)
            cmd+=' --gldft'
        if(cfg.debugBackend)
            cmd+=' --debug'
        cmd+=' --bass-resolution-level='+cfg.bassResolutionLevel
        if(cfg.debugBackend){
            console.log('Executing: '+cmd)
            cmd='echo do nothing'
        }
        if(enable_wave_data)
            cmd+=' --enable-wave-data'
        if(enable_spectrum_data)
            cmd+=' --enable-spectrum-data'
        return cmd
    }

    PlasmaCore.DataSource {
        engine: 'executable'
        connectedSources: [startBackEnd]
        onNewData:{
            // Show back-end errors.
            console.log(data.stdout)
            console.log(data.stderr)
        }
    }

}
