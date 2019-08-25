import QtQuick 2.0
import QtQuick.Controls 2.0
ApplicationWindow{
	id: app
	visible:true
	visibility: "Maximized"
	property int ms:0
	Text{
		id: txt
		font.pixelSize:30
		anchors.centerIn: parent
	}
	Timer{
		id:t1
		running: false
		repeat: true
		interval: 5
		property int v:0
		property int v2:0
		onTriggered:{
			var d=Date.now()
			txt.text='Segundos:'+v
			if(v2===19){
				v2=0
				v++
			}else{
				v2++
			}
			//v++
		}
	
	}
	Component.onCompleted:{
		//var d= Date.now()
		//app.ms=d.getTime()
		
		t1.start()
	}
}
