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
    | mainPanel panelXO panelOpciones panelReady |

    mainPanel := self crearMainPanel.
    panelXO := self crearPanelXO.
    panelOpciones := self crearPanelOpciones.
    panelReady := self crearPanelReady.

    mainPanel addMorph: panelXO.
    mainPanel addMorph: panelOpciones.
    mainPanel addMorph: panelReady.

    window addMorph: mainPanel frame: (0@0 corner: 1@1).

]

{ #category : 'building' }
SuperTatetiVsPcMorph >> crearMainPanel [
    | mainPanel |

    mainPanel := Morph new.
    mainPanel layoutPolicy: TableLayout new.
    mainPanel listDirection: #topToBottom.
    mainPanel hResizing: #spaceFill;
              vResizing: #spaceFill;
              cellInset: 15.
    mainPanel color: Color veryLightGray.

    ^ mainPanel

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

    filaReturn addMorph: lbl.
    filaReturn addMorph: btnReturn.

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

    filaHelp addMorph: lbl.
    filaHelp addMorph: btnHelp.

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

    filaTime addMorph: lbl.
    filaTime addMorph: marcoTiempo.

    panel addMorph: filaReturn.
    panel addMorph: filaHelp.
    panel addMorph: filaTime.

    ^ panel

]

{ #category : 'building' }
SuperTatetiVsPcMorph >> crearPanelReady [
    | panel boton |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap.
    panel color: Color veryLightGray.

    boton := SimpleButtonMorph new.
    boton label: 'Ready'.
    boton extent: 200@50.
    boton color: Color lightGray.
    boton borderWidth: 2; borderColor: Color black.
    boton target: self; actionSelector: #opcionNoImplementada.

    panel addMorph: boton.

    ^ panel

]

{ #category : 'building' }
SuperTatetiVsPcMorph >> crearPanelXO [
    | panel botonX botonO |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #leftToRight.
    panel hResizing: #shrinkWrap;
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
