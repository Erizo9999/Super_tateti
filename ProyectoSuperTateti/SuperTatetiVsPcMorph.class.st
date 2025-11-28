Class {
	#name : 'SuperTatetiVsPcMorph',
	#superclass : 'Object',
	#instVars : [
		'window',
		'mainPanel',
		'app'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'instance creation' }
SuperTatetiVsPcMorph class >> open [
    ^ self new openInWorld

]

{ #category : 'accessing' }
SuperTatetiVsPcMorph >> app [
    ^ app

]

{ #category : 'accessing' }
SuperTatetiVsPcMorph >> app: unaApp [
    app := unaApp

]

{ #category : 'building' }
SuperTatetiVsPcMorph >> construirInterfaz [
    | panelXO panelOpciones panelReady espacioSuperior espacioCentral espacioInferior espacioEntreXOyOpciones |

    mainPanel := self crearMainPanel.
    panelXO := self crearPanelXO.
    panelOpciones := self crearPanelOpciones.
    panelReady := self crearPanelReady.

    "Espacio fijo arriba para que X/O no quede pegado al borde superior"
    espacioSuperior := Morph new.
    espacioSuperior layoutPolicy: nil.
    espacioSuperior
        hResizing: #spaceFill;
        vResizing: #rigid;
        extent: 0@30.
    espacioSuperior color: Color veryLightGray.

    "Espacio fijo entre el panel X/O y las opciones (Return/Help/time)"
    espacioEntreXOyOpciones := Morph new.
    espacioEntreXOyOpciones layoutPolicy: nil.
    espacioEntreXOyOpciones
        hResizing: #spaceFill;
        vResizing: #rigid;
        extent: 0@15.   "aumentá o bajá este valor si querés más/menos distancia"
    espacioEntreXOyOpciones color: Color veryLightGray.

    "Espacio flexible en el medio para empujar los botones hacia abajo"
    espacioCentral := Morph new.
    espacioCentral layoutPolicy: nil.
    espacioCentral
        hResizing: #spaceFill;
        vResizing: #spaceFill.
    espacioCentral color: Color veryLightGray.

    "Espacio fijo abajo para que Ready/Leave no peguen contra el borde inferior"
    espacioInferior := Morph new.
    espacioInferior layoutPolicy: nil.
    espacioInferior
        hResizing: #spaceFill;
        vResizing: #rigid;
        extent: 0@20.
    espacioInferior color: Color veryLightGray.

    "Orden: margen sup, X/O, espacio extra, opciones, espacio flex, botones, margen inf"
    mainPanel
        addMorph: espacioInferior;
        addMorph: panelReady;
        addMorph: espacioCentral;
        addMorph: panelOpciones;
        addMorph: espacioEntreXOyOpciones;
        addMorph: panelXO;
        addMorph: espacioSuperior.

    window addMorph: mainPanel frame: (0@0 corner: 1@1).

]

{ #category : 'building' }
SuperTatetiVsPcMorph >> crearMainPanel [
    | panel |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel
        listCentering: #center;    "centra horizontalmente los hijos"
        wrapCentering: #center.
    panel
        hResizing: #spaceFill;
        vResizing: #spaceFill;
        cellInset: 15.
    panel color: Color veryLightGray.

    ^ panel

]

{ #category : 'building' }
SuperTatetiVsPcMorph >> crearPanelOpciones [
    | panel filaReturn filaHelp filaTime lbl btnReturn btnHelp marcoTiempo lblTiempo |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 10.
    panel color: Color veryLightGray.

    "===== Return: [ X ] ====="
    filaReturn := Morph new.
    filaReturn layoutPolicy: TableLayout new.
    filaReturn listDirection: #leftToRight.
    filaReturn hResizing: #shrinkWrap; vResizing: #shrinkWrap.
    filaReturn color: Color veryLightGray.

    lbl := StringMorph contents: 'Return:'.
    lbl color: Color black.

    btnReturn := SimpleButtonMorph new.
    btnReturn label: 'X'.
    btnReturn extent: 40@30.
    btnReturn target: self; actionSelector: #opcionNoImplementada.

    "Primero el cuadrado, luego el texto"
    filaReturn addMorph: btnReturn.
    filaReturn addMorph: lbl.

    "===== Help: [ ] ====="
    filaHelp := Morph new.
    filaHelp layoutPolicy: TableLayout new.
    filaHelp listDirection: #leftToRight.
    filaHelp hResizing: #shrinkWrap; vResizing: #shrinkWrap.
    filaHelp color: Color veryLightGray.

    lbl := StringMorph contents: 'Help:'.
    lbl color: Color black.

    btnHelp := SimpleButtonMorph new.
    btnHelp label: ' '.
    btnHelp extent: 40@30.
    btnHelp target: self; actionSelector: #opcionNoImplementada.

    "Primero el cuadrado, luego el texto"
    filaHelp addMorph: btnHelp.
    filaHelp addMorph: lbl.

    "===== time: [ 02:00 ] ====="
    filaTime := Morph new.
    filaTime layoutPolicy: TableLayout new.
    filaTime listDirection: #leftToRight.
    filaTime hResizing: #shrinkWrap; vResizing: #shrinkWrap.
    filaTime color: Color veryLightGray.

    lbl := StringMorph contents: 'time:'.
    lbl color: Color black.

    marcoTiempo := Morph new.
    marcoTiempo layoutPolicy: TableLayout new.
    marcoTiempo color: Color lightGray.
    marcoTiempo borderWidth: 2; borderColor: Color black.
    marcoTiempo hResizing: #shrinkWrap; vResizing: #shrinkWrap.

    lblTiempo := StringMorph contents: '02:00'.
    lblTiempo color: Color black.
    marcoTiempo addMorph: lblTiempo.

    filaTime addMorph: marcoTiempo.
    filaTime addMorph: lbl.

    panel addMorph: filaTime.
    panel addMorph: filaHelp.
    panel addMorph: filaReturn.

    ^ panel

]

{ #category : 'building' }
SuperTatetiVsPcMorph >> crearPanelReady [
    | panel botonLeave botonReady |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #leftToRight.
    panel
        hResizing: #shrinkWrap;
        vResizing: #shrinkWrap;
        cellInset: 80.        "separación horizontal entre los botones"
    panel color: Color veryLightGray.

    botonLeave := SimpleButtonMorph new.
    botonLeave label: 'Leave'.
    botonLeave extent: 150@50.
    botonLeave color: Color lightGray.
    botonLeave borderWidth: 2; borderColor: Color black.
    botonLeave target: self; actionSelector: #volverAlInicio.

    botonReady := SimpleButtonMorph new.
    botonReady label: 'Ready'.
    botonReady extent: 150@50.
    botonReady color: Color lightGray.
    botonReady borderWidth: 2; borderColor: Color black.
    botonReady target: self; actionSelector: #opcionNoImplementada.

    panel addMorph: botonLeave.
    panel addMorph: botonReady.

    ^ panel

]

{ #category : 'building' }
SuperTatetiVsPcMorph >> crearPanelXO [
    | panel botonX botonO |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #leftToRight.
    panel
        hResizing: #shrinkWrap;   "se ajusta al tamaño de los botones"
        vResizing: #shrinkWrap;
        cellInset: 0.
    panel color: Color veryLightGray.
    panel borderWidth: 3;
           borderColor: Color black.

    botonX := SimpleButtonMorph new.
    botonX label: 'X'.
    botonX extent: 180@80.
    botonX color: Color veryLightGray.
    botonX borderWidth: 1; borderColor: Color black.
    botonX target: self; actionSelector: #opcionNoImplementada.

    botonO := SimpleButtonMorph new.
    botonO label: 'O'.
    botonO extent: 180@80.
    botonO color: Color veryLightGray.
    botonO borderWidth: 1; borderColor: Color black.
    botonO target: self; actionSelector: #opcionNoImplementada.

    panel addMorph: botonX.
    panel addMorph: botonO.

    ^ panel

]

{ #category : 'building' }
SuperTatetiVsPcMorph >> crearVentana [
    window := SystemWindow labelled: 'Tic Tac Toe'.
    window extent: 425@450.

]

{ #category : 'initialization' }
SuperTatetiVsPcMorph >> initialize [
    super initialize.

]

{ #category : 'initialization' }
SuperTatetiVsPcMorph >> instalarEnVentana: unaVentana [
    window := unaVentana.
    self construirInterfaz

]

{ #category : 'accessing' }
SuperTatetiVsPcMorph >> mainPanel [ 
	^ mainPanel 
]

{ #category : 'events' }
SuperTatetiVsPcMorph >> opcionNoImplementada [
    UIManager default inform: 'Todavía no se implementó esta opción.'.

]

{ #category : 'initialization' }
SuperTatetiVsPcMorph >> openInWorld [
    self crearVentana.
    self construirInterfaz.
    window openInWorld.

]

{ #category : 'events' }
SuperTatetiVsPcMorph >> volverAlInicio [
    app volverAlMenu

]
