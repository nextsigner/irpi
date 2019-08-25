import QtQuick 2.0
import QtQuick.Controls 2.0
ApplicationWindow{
    id: app
    visible: true
    visibility:"Maximized"
    color: '#333'
    property int rpmActual: 0
    property int msGlobal: 0
    property int uMs: 0
    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        Text{
            text:'<b>RPM</b>'+app.rpmActual
            color: 'white'
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30
        }
        Text {
            id: log
            text: 'Log...'
            color: 'white'
            font.pixelSize: 16
        }
    }
    MouseArea{
        anchors.fill: parent
        onDoubleClicked: Qt.quit()
    }
    Column{
        spacing: 10
        Row{
            spacing: 10
            Button{
                text: timerRPMVirtual.running?'Emulando RPM':'Emular RPM'
                onPressed: {
                    timerRPMVirtual.running=!timerRPMVirtual.running
                }
            }
            SpinBox{
                id:spinBoxMsRPMVirtual
                from: 10
                value: 100
                to: 100
                stepSize: 5
                onValueChanged: {
                    timerRPMVirtual.stop()
                    timerRPMVirtual.interval=value
                    timerRPMVirtual.start()
                }
            }
        }
        Row{
            Text {
                id: txtMsGlobal
                text: 'MSG: '+app.msGlobal
                color: 'white'
                width: 100
            }
            Text {
                id: txtMsDif
                text: 'MSDif: -1'
                color: 'white'
            }
        }
    }
    Timer{
        id: timerRPMVirtual
        running: false
        repeat: true
        interval: 1000
        onTriggered: {
            if(unik.pinIsHigh(21)){
                unik.writePinHigh(21)
            }else{
                unik.writePinLow(21)
            }

        }
    }
    Timer{
        id: timerMSG
        running: true
        repeat: true
        interval: 1
        onTriggered: {
            app.msGlobal++

        }
    }
    Timer{
        id: timerCheckRPM
        running: true
        repeat: true
        interval: 15
        property int chequeo: 0
        property int ciclo: 1
        onTriggered: {
            chequeo++
            log.text='Ciclo '+ciclo+' Chequeo '+chequeo+': Pin 21 en '+unik.readPin(21)+' \n'
            if(chequeo>100){
                chequeo=0
                ciclo++
            }
            if(unik.readPin(21===1)){
                app.uMs=app.msGlobal
            }
            compararIntervalo()
        }
    }
    function compararIntervalo(){
        var dif=6000/(app.msGlobal-uMs)
        txtMsDif.text='MSDif: '+dif
        app.rpmActual=parseInt(dif)
    }
    Component.onCompleted:{
        /* void initRpiGpio();
         void setPinType(int pin, int type);
         void setPinState(int pin, int state);
         unsigned int readPin(unsigned int pin);
         void writePinHigh(unsigned int pinnum);
         void writePinLow(unsigned int pinnum);
         bool pinIsHigh(int pin);*/
        unik.initRpiGpio()
        unik.setPinType(21, 0) //1 para probar luego va a 0


    }
}
