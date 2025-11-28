Class {
	#name : 'SuperTatetiMorph',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'botones',
		'window',
		'mainPanel',
		'app',
		'returnHabilitado'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'instance creation' }
SuperTatetiMorph class >> open [
    ^ self new openInWorld

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarBotonDeTablerito: indiceTablerito casilla: indiceCasilla [
    | btn valor texto |

    btn := (botones at: indiceTablerito) at: indiceCasilla.

    "Valor que tiene esa casilla en el modelo (#x, #o o nil)"
    valor := juego valorEnTablerito: indiceTablerito casilla: indiceCasilla.

    "Limpio cualquier texto viejo que tenga el botón"
    btn submorphs do: [:m | m delete].

    "Fondo blanco siempre"
    btn color: Color white.

    "Si hay X u O, creo un StringMorph y lo centro dentro del botón"
    valor ifNotNil: [
        texto := StringMorph contents: (valor asString asUppercase).
        texto color: Color black.
        btn addMorph: texto.
        texto center: btn center ].

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarVista [
    1 to: 9 do: [:t |
        1 to: 9 do: [:c |
            self actualizarBotonDeTablerito: t casilla: c ] ].

]

{ #category : 'helpers' }
SuperTatetiMorph >> anunciarGanador [
    juego ganador
        ifNil: [
            UIManager default inform:
                'Fin del juego: empate o todos los tableritos cerrados.' ]
        ifNotNil: [
            UIManager default inform:
                'Ganador: ', juego ganador asString asUppercase ].

]

{ #category : 'accessing' }
SuperTatetiMorph >> app [
    ^ app

]

{ #category : 'accessing' }
SuperTatetiMorph >> app: unaApp [
    app := unaApp

]

{ #category : 'building' }
SuperTatetiMorph >> armarLayoutGeneral: unMainPanel board: boardPanel [
    unMainPanel addMorph: boardPanel.
    window addMorph: unMainPanel frame: (0@0 corner: 1@1).

]

{ #category : 'helpers' }
SuperTatetiMorph >> cerrarVentana [
    window delete.

]

{ #category : 'events' }
SuperTatetiMorph >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    Transcript show: 'Click en ', indiceTablerito printString, '-', indiceCasilla printString; cr.

    [ juego jugarEnTablerito: indiceTablerito casilla: indiceCasilla ]
        on: Error
        do: [:ex | UIManager default inform: ex messageText ].

    self actualizarVista.

    (juego juegoTerminado) ifTrue: [
        self anunciarGanador ].

]

{ #category : 'building' }
SuperTatetiMorph >> crearBoardPanel [
    | boardPanel |
    boardPanel := Morph new.
    boardPanel layoutPolicy: TableLayout new.
    boardPanel listDirection: #topToBottom.
    boardPanel hResizing: #shrinkWrap;
               vResizing: #shrinkWrap;
               cellInset: 0.
    boardPanel color: Color veryLightGray.

    self inicializarBotones.

    1 to: 9 do: [:row |
        boardPanel addMorph: (self crearFila: row).
        (#(3 6) includes: row) ifTrue: [
            boardPanel addMorph: self crearGapFila ] ].

    ^ boardPanel
]

{ #category : 'building' }
SuperTatetiMorph >> crearBotonConLabel: label action: selector [
    ^ SimpleButtonMorph new
        label: label;
        extent: 100@40;
        color: Color lightGray;
        borderWidth: 1; borderColor: Color black;
        target: self; actionSelector: selector;
        yourself
]

{ #category : 'building' }
SuperTatetiMorph >> crearBotonEnFila: row columna: col [
 | tIndex cIndex btn |
    tIndex := ((row - 1) // 3) * 3 + ((col - 1) // 3) + 1.
    cIndex := ((row - 1) \\ 3) * 3 + ((col - 1) \\ 3) + 1.

    btn := SimpleButtonMorph new.
    btn extent: 30@30.
    btn hResizing: #rigid; vResizing: #rigid.
    btn color: Color white.
    btn borderWidth: 1; borderColor: Color black.
    btn target: self; actionSelector: #clicEnTablerito:casilla:; arguments: {tIndex. cIndex}.

    (botones at: tIndex) at: cIndex put: btn.
    ^ btn

]

{ #category : 'building' }
SuperTatetiMorph >> crearFila: row [
    | filaMorph |
    filaMorph := Morph new.
    filaMorph layoutPolicy: TableLayout new.
    filaMorph listDirection: #leftToRight.
    filaMorph hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 0.

    1 to: 9 do: [:col |
        filaMorph addMorph: (self crearBotonEnFila: row columna: col).
        (#(3 6) includes: col) ifTrue: [
            filaMorph addMorph: self crearGapColumna ] ].

    ^ filaMorph

]

{ #category : 'building' }
SuperTatetiMorph >> crearGapColumna [
    ^ Morph new
        layoutPolicy: nil;
        hResizing: #rigid;
        vResizing: #rigid;
        extent: 6@30;   "dale un poco más de ancho para que se note"
        color: Color gray;   "color más visible"
        borderWidth: 0;
        yourself
]

{ #category : 'building' }
SuperTatetiMorph >> crearGapFila [
    | ancho |
    "Calculamos el ancho total del tablero: 9 celdas de 30 + 2 gaps de columna"
    ancho := (9 * 30) + (2 * 6).

    ^ Morph new
        layoutPolicy: nil;
        hResizing: #rigid;
        vResizing: #rigid;
        extent: ancho @ 6;   "alto del gap horizontal"
        color: Color gray;   "usa gris para confirmar que aparece"
        borderWidth: 0;
        yourself

]

{ #category : 'building' }
SuperTatetiMorph >> crearMainPanel [
    ^ Morph new
        layoutPolicy: TableLayout new;
        listDirection: #topToBottom;
        hResizing: #spaceFill;
        vResizing: #spaceFill;
        cellInset: 10;
        color: Color veryLightGray;
        "alinear hijos (barra y tablero) a la izquierda"
        listCentering: #left;
        wrapCentering: #left;
        yourself

]

{ #category : 'building' }
SuperTatetiMorph >> crearPanelTiempoConTitulo: titulo color: unColor [
    | panel marcoTiempo etiquetaTiempo etiquetaTitulo |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 5.
    panel color: Color veryLightGray.

    "Rectángulo donde más adelante irá el tiempo"
    marcoTiempo := Morph new.
    marcoTiempo layoutPolicy: TableLayout new.
    marcoTiempo hResizing: #shrinkWrap;
                vResizing: #shrinkWrap.
    marcoTiempo color: unColor.
    marcoTiempo borderWidth: 2;
                borderColor: Color black.

    etiquetaTiempo := StringMorph contents: '00:00'.
    etiquetaTiempo color: Color black.
    marcoTiempo addMorph: etiquetaTiempo.

    "Texto de abajo: time: X / time: O"
    etiquetaTitulo := StringMorph contents: titulo.
    etiquetaTitulo color: Color black.

    panel addMorph: marcoTiempo.
    panel addMorph: etiquetaTitulo.

    ^ panel

]

{ #category : 'building' }
SuperTatetiMorph >> crearPanelTiempos [
    | panel |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #leftToRight.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 40.   "separación horizontal entre X y O"
    panel color: Color veryLightGray.

    panel addMorph: (self crearPanelTiempoConTitulo: 'time: X' color: Color cyan).
    panel addMorph: (self crearPanelTiempoConTitulo: 'time: O' color: Color white).

    ^ panel

]

{ #category : 'helpers' }
SuperTatetiMorph >> crearTableritoEn: panelPrincipal indice: indiceTablerito [
    | panelTablerito botonesTablerito |
    
    panelTablerito := Morph new.
    panelTablerito layoutPolicy: TableLayout new.
    panelTablerito listDirection: #leftToRight.
    panelTablerito wrapCentering: #center.
    panelTablerito cellInset: 1.
    panelTablerito hResizing: #spaceFill;
                   vResizing: #spaceFill.
    panelTablerito borderWidth: 2.
    panelTablerito borderColor: Color black.

    botonesTablerito := (1 to: 9) collect: [:c |
        | btn |
        btn := SimpleButtonMorph new.
        btn extent: 30@30.
        btn label: ' '.
        btn target: self.
        btn actionSelector: #clicEnTablerito:casilla:.
        btn arguments: { indiceTablerito. c }.
        panelTablerito addMorph: btn.
        btn ].

    panelPrincipal addMorph: panelTablerito.
    ^ botonesTablerito

]

{ #category : 'building' }
SuperTatetiMorph >> crearTablero [
    | topBar boardPanel panelTiempos |

    mainPanel := self crearMainPanel.
    panelTiempos := self crearPanelTiempos.
    boardPanel := self crearBoardPanel.
    topBar := self crearTopBarPanel.

    "Orden correcto: barra arriba, tablero en el medio, tiempos abajo"
    mainPanel addMorph: panelTiempos.
    mainPanel addMorph: boardPanel.
    mainPanel addMorph: topBar.


    window addMorph: mainPanel frame: (0@0 corner: 1@1).

]

{ #category : 'building' }
SuperTatetiMorph >> crearTopBarPanel [
    | topPanel botonReturn botonHelp botonStart botonLeave |

    topPanel := Morph new.
    topPanel layoutPolicy: TableLayout new.
    topPanel listDirection: #leftToRight.
    topPanel hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 5.
    topPanel color: Color lightGray.

    botonReturn := self crearBotonConLabel: 'Return'
        action: (returnHabilitado
            ifTrue: [ #returnPresionado ]
            ifFalse: [ #returnDeshabilitado ]).

    "Si está deshabilitado, lo mostramos más apagado"
    returnHabilitado ifFalse: [
        botonReturn color: Color veryLightGray.
        botonReturn borderColor: Color gray ].

    botonHelp   := self crearBotonConLabel: 'Help'   action: #funcionNoImplementada.
    botonStart  := self crearBotonConLabel: 'Start'  action: #funcionNoImplementada.
    botonLeave  := self crearBotonConLabel: 'Leave'  action: #volverAlInicio.

    topPanel
        addMorph: botonLeave;
        addMorph: botonStart;
        addMorph: botonHelp;
        addMorph: botonReturn.

    ^ topPanel

]

{ #category : 'building' }
SuperTatetiMorph >> crearVentana [
    window := SystemWindow labelled: 'Tic Tac Toe'.
    window extent: 425@450.

]

{ #category : 'helpers' }
SuperTatetiMorph >> funcionNoImplementada [
    UIManager default inform: 'Esta función todavía no se implementó.'.

]

{ #category : 'building' }
SuperTatetiMorph >> inicializarBotones [
    botones := Array new: 9.
    1 to: 9 do: [:t | botones at: t put: (Array new: 9) ].
]

{ #category : 'initialization' }
SuperTatetiMorph >> initialize [
    super initialize.
    returnHabilitado := true.   "si lo abren directo con openInWorld, Return está habilitado"

]

{ #category : 'initialization' }
SuperTatetiMorph >> instalarEnVentana: unaVentana [
    juego := SuperTateti new.
    window := unaVentana.
    self crearTablero.
    self actualizarVista

]

{ #category : 'accessing' }
SuperTatetiMorph >> mainPanel [ 
	^ mainPanel 
]

{ #category : 'initialization' }
SuperTatetiMorph >> openInWorld [
    juego := SuperTateti new.
    self crearVentana.
    self crearTablero .
    self actualizarVista.
    window openInWorld.

]

{ #category : 'helpers' }
SuperTatetiMorph >> reiniciarJuego [
    juego reiniciar.
    self actualizarVista.

]

{ #category : 'events' }
SuperTatetiMorph >> returnDeshabilitado [
    UIManager default inform: 'La función Return está deshabilitada para esta partida.'

]

{ #category : 'accessing' }
SuperTatetiMorph >> returnHabilitado [
    ^ returnHabilitado
]

{ #category : 'accessing' }
SuperTatetiMorph >> returnHabilitado: unBooleano [
    returnHabilitado := unBooleano
]

{ #category : 'events' }
SuperTatetiMorph >> returnPresionado [
    [ juego deshacerUltimaJugada ]
        on: Error
        do: [:ex | UIManager default inform: ex messageText ].

    self actualizarVista.

]

{ #category : 'events' }
SuperTatetiMorph >> volverAlInicio [
    app volverAlMenu

]
