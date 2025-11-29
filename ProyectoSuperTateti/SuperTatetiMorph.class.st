Class {
	#name : 'SuperTatetiMorph',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'botones',
		'window',
		'mainPanel',
		'app',
		'returnHabilitado',
		'ayudaActiva',
		'juegoIniciado',
		'relojTurnos',
		'procesoReloj',
		'panelTiempos',
		'botonStart'
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

{ #category : 'helpers' }
SuperTatetiMorph >> actualizarTextoTiempo [
    "Actualiza los textos de los relojes de X y O en las cajas del panelTiempos."
    | textoX textoO panelX panelO cajaX cajaO label |

    "Si aún no se creó el panel de tiempos, no hacemos nada."
    panelTiempos ifNil: [ ^ self ].

    textoX := relojTurnos tiempoComoStringPara: #x.
    textoO := relojTurnos tiempoComoStringPara: #o.

    "El panelTiempos tiene dos submorphs: panel de X y panel de O."
    panelX := panelTiempos submorphs first.
    panelO := panelTiempos submorphs second.

    "En cada panel, la PRIMER submorph es la caja donde va el tiempo."
    cajaX := panelX submorphs first.
    cajaO := panelO submorphs first.

    "Actualizamos la caja de X."
    cajaX submorphs do: [:m | m delete].
    label := StringMorph contents: textoX.
    label color: Color black.
    cajaX addMorph: label.
    label center: cajaX center.

    "Actualizamos la caja de O."
    cajaO submorphs do: [:m | m delete].
    label := StringMorph contents: textoO.
    label color: Color black.
    cajaO addMorph: label.
    label center: cajaO center.

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarVista [
    "Redibuja todo el tablero según el estado actual del modelo y, si corresponde, la ayuda."

    "Actualizamos todos los botones de las 9x9 casillas con X, O o vacío."
    1 to: 9 do: [:t |
        1 to: 9 do: [:c |
            self actualizarBotonDeTablerito: t casilla: c ] ].

    "Si la ayuda está activada, resaltamos las casillas donde se puede jugar."
    (ayudaActiva == true) ifTrue: [
        self resaltarMovimientosValidos ].

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

{ #category : 'events' }
SuperTatetiMorph >> cambiarDuracionTiempo [
    "Cambia la duración del reloj (1 → 2 → 5 → 10 minutos) solo si el juego aún no empezó."
    juegoIniciado ifTrue: [
        "Si el juego ya empezó, no permitimos cambiar la duración."
        ^ self
    ].

    "Pasamos a la siguiente duración en el modelo de reloj."
    reloj siguienteDuracion.
    "Reseteamos el tiempo restante a la nueva duración."
    reloj resetear.
    "Refrescamos el texto del botón de tiempo."
    self actualizarTextoTiempo.

]

{ #category : 'events' }
SuperTatetiMorph >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    "Maneja el clic en una casilla del tablero y alterna los relojes de turno."

    juegoIniciado ifFalse: [
        ^ self informarQueDebeIniciar
    ].

    [ juego jugarEnTablerito: indiceTablerito casilla: indiceCasilla ]
        on: Error
        do: [:ex | ^ UIManager default inform: ex messageText ].

    self actualizarVista.

    juego juegoTerminado ifTrue: [
        self detenerReloj.
        juegoIniciado := false.
        botonStart ifNotNil: [ botonStart label: 'Start' ].
        ^ self anunciarGanador
    ].

    "Si el juego sigue, alternamos el jugador activo del reloj."
    relojTurnos alternarJugador.

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
    "Crea un botón de la barra superior (Return, Help, Start, Leave) con tamaño fijo."
    ^ SimpleButtonMorph new
        label: label;
        extent: 100@40;          "Tamaño fijo para que no cambie al modificar el texto"
        hResizing: #rigid;
        vResizing: #rigid;
        color: Color lightGray;
        borderWidth: 1;
        borderColor: Color black;
        target: self;
        actionSelector: selector;
        yourself.

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
SuperTatetiMorph >> crearPanelTiempo [
    "Crea el panel donde va el botón de tiempo y su título."
    | panel titulo |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 5.
    panel color: Color veryLightGray.

    "Botón de tiempo (el texto lo actualizamos en actualizarTextoTiempo)."
    botonTiempo := self crearBotonConLabel: ' ' action: #cambiarDuracionTiempo.
    botonTiempo color: Color white.

    self actualizarTextoTiempo.

    titulo := StringMorph contents: 'Time'.
    titulo color: Color black.

    panel addMorph: botonTiempo.
    panel addMorph: titulo.

    ^ panel.

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
SuperTatetiMorph >> crearPanelTiempoO [
    "Crea el panel de tiempo para el jugador O (caja + etiqueta 'time: O')."
    | panel caja etiqueta |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 5.
    panel color: Color veryLightGray.

    "Caja donde se dibuja el tiempo de O."
    caja := Morph new.
    caja layoutPolicy: TableLayout new.
    caja hResizing: #shrinkWrap;
          vResizing: #shrinkWrap.
    caja extent: 120@40.
    caja color: Color white.
    caja borderWidth: 2;
         borderColor: Color black.

    "Etiqueta 'time: O' debajo de la caja."
    etiqueta := StringMorph contents: 'time: O'.
    etiqueta color: Color black.

    panel addMorph: caja.
    panel addMorph: etiqueta.

    ^ panel.

]

{ #category : 'building' }
SuperTatetiMorph >> crearPanelTiempoX [
    "Crea el panel de tiempo para el jugador X (caja + etiqueta 'time: X')."
    | panel caja etiqueta |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 5.
    panel color: Color veryLightGray.

    "Caja donde se dibuja el tiempo de X."
    caja := Morph new.
    caja layoutPolicy: TableLayout new.
    caja hResizing: #shrinkWrap;
          vResizing: #shrinkWrap.
    caja extent: 120@40.
    caja color: Color cyan.
    caja borderWidth: 2;
         borderColor: Color black.

    "Etiqueta 'time: X' debajo de la caja."
    etiqueta := StringMorph contents: 'time: X'.
    etiqueta color: Color black.

    panel addMorph: caja.
    panel addMorph: etiqueta.

    ^ panel.

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

{ #category : 'building' }
SuperTatetiMorph >> crearPanelTiemposJugadores [
    "Crea el panel horizontal que contiene los tiempos de X y O."
    | panel |

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #leftToRight.
    panel hResizing: #shrinkWrap;
           vResizing: #shrinkWrap;
           cellInset: 40.
    panel color: Color veryLightGray.

    panel addMorph: self crearPanelTiempoX.
    panel addMorph: self crearPanelTiempoO.

    "Guardamos el contenedor de los tiempos (una sola instVar para ambos)."
    panelTiempos := panel.

    "Actualizamos los textos iniciales de los relojes."
    self actualizarTextoTiempo.

    ^ panel.

]

{ #category : 'building' }
SuperTatetiMorph >> crearTablero [
    "Arma el layout principal del juego: barra arriba, tablero al centro y tiempos abajo."
    | topBar boardPanel panelTiemposLocal |

    mainPanel := self crearMainPanel.
    topBar := self crearTopBarPanel.
    boardPanel := self crearBoardPanel.
    panelTiemposLocal := self crearPanelTiemposJugadores.

    mainPanel addMorph: topBar.
    mainPanel addMorph: boardPanel.
    mainPanel addMorph: panelTiemposLocal.

    window addMorph: mainPanel frame: (0@0 corner: 1@1).

]

{ #category : 'building' }
SuperTatetiMorph >> crearTopBarPanel [
    "Crea la barra superior con los botones Leave, Start, Help y Return."
    | topPanel botonReturn botonHelp botonLeave |

    topPanel := Morph new.
    topPanel layoutPolicy: TableLayout new.
    topPanel listDirection: #leftToRight.
    topPanel hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 5.
    topPanel color: Color lightGray.

    "Botón Return (puede estar habilitado o no)."
    botonReturn := self crearBotonConLabel: 'Return'
        action: (returnHabilitado
            ifTrue: [ #returnPresionado ]
            ifFalse: [ #returnDeshabilitado ]).

    "Botón Help."
    botonHelp := self crearBotonConLabel: 'Help' action: #helpPresionado.

    "Botón Start/Stop: guardamos referencia en la instVar."
    botonStart := self crearBotonConLabel: 'Start' action: #startPresionado.

    "Botón Leave (vuelve al menú)."
    botonLeave := self crearBotonConLabel: 'Leave' action: #volverAlInicio.

    "Orden de los botones en la barra."
    topPanel
        addMorph: botonLeave;
        addMorph: botonStart;
        addMorph: botonHelp;
        addMorph: botonReturn.

    ^ topPanel.

]

{ #category : 'building' }
SuperTatetiMorph >> crearVentana [
    window := SystemWindow labelled: 'Tic Tac Toe'.
    window extent: 425@450.

]

{ #category : 'helpers' }
SuperTatetiMorph >> detenerReloj [
    "Detiene el proceso del reloj (si existe) y pausa los relojes de turno."
    procesoReloj ifNotNil: [
        procesoReloj terminate.
        procesoReloj := nil ].
    relojTurnos detener.

]

{ #category : 'helpers' }
SuperTatetiMorph >> funcionNoImplementada [
    UIManager default inform: 'Esta función todavía no se implementó.'.

]

{ #category : 'events' }
SuperTatetiMorph >> helpPresionado [
    (juego juegoTerminado) ifTrue: [
        UIManager default inform: 'El juego ya terminó.'.
        ^ self
    ].

    "Toggle de la bandera"
    ayudaActiva := ayudaActiva not.

    "Redibujamos todo según el nuevo estado de la ayuda"
    self actualizarVista.

]

{ #category : 'helpers' }
SuperTatetiMorph >> informarQueDebeIniciar [
    "Muestra un mensaje indicando que hay que presionar Start antes de jugar."
    UIManager default inform: 'Debes presionar Start para comenzar el juego.'.

]

{ #category : 'building' }
SuperTatetiMorph >> inicializarBotones [
    botones := Array new: 9.
    1 to: 9 do: [:t | botones at: t put: (Array new: 9) ].
]

{ #category : 'helpers' }
SuperTatetiMorph >> iniciarReloj [
    "Crea el proceso que descuenta tiempo cada segundo mientras el reloj esté corriendo."
    self detenerReloj.

    relojTurnos iniciar.

    procesoReloj := [
        [ relojTurnos corriendo and: [ juego juegoTerminado not ] ] whileTrue: [
            (Delay forSeconds: 1) wait.
            self ticRelojes.
        ].
    ] fork.

]

{ #category : 'initialization' }
SuperTatetiMorph >> initialize [
    "Inicializa el morph del juego y el sistema de relojes de turnos."
    super initialize.
    "Configuración general de la interfaz."
    returnHabilitado := true.
    ayudaActiva := false.
    juegoIniciado := false.

    "Un solo objeto que maneja los dos relojes (X y O)."
    relojTurnos := RelojTurnos new.

    "Todavía no hay proceso de reloj corriendo."
    procesoReloj := nil.

    "Estos morphs se asignan cuando se arma el tablero."
    panelTiempos := nil.
    botonStart := nil.

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
SuperTatetiMorph >> resaltarMovimientosValidos [
    1 to: 9 do: [:t |
        1 to: 9 do: [:c |
            (juego esMovimientoValidoEnTablerito: t casilla: c) ifTrue: [
                | btn |
                btn := (botones at: t) at: c.
                btn color: Color yellow ] ] ].

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
SuperTatetiMorph >> startPresionado [
    "Maneja el botón Start/Stop para el sistema de relojes de turnos."

    "Si el reloj ya está corriendo → lo pausamos (Stop)."
    relojTurnos corriendo ifTrue: [
        self detenerReloj.
        botonStart ifNotNil: [ botonStart label: 'Start' ].
        ^ self
    ].

    "Si aún no se inició el juego, reseteamos los relojes y marcamos que está iniciado."
    juegoIniciado ifFalse: [
        juegoIniciado := true.
        relojTurnos resetearAmbos.
        self actualizarTextoTiempo
    ].

    "Aseguramos que el jugador activo del reloj coincida con el jugador del juego."
    relojTurnos jugadorActivo: juego jugadorActual.

    "Arrancamos el proceso de tiempo y ponemos el botón en Stop."
    botonStart ifNotNil: [ botonStart label: 'Stop' ].
    self iniciarReloj.

]

{ #category : 'helpers' }
SuperTatetiMorph >> ticRelojes [
    "Pide al RelojTurnos que reste un segundo al jugador activo y
    actualiza la interfaz. Si alguien se queda sin tiempo, detiene el juego."

    | quienPerdio |

    quienPerdio := relojTurnos tic.
    self actualizarTextoTiempo.

    quienPerdio ifNotNil: [
        self detenerReloj.
        juegoIniciado := false.
        botonStart ifNotNil: [ botonStart label: 'Start' ].
        UIManager default inform:
            'Se terminó el tiempo de ', quienPerdio asString asUppercase.
    ].

]

{ #category : 'events' }
SuperTatetiMorph >> volverAlInicio [
    "Vuelve al menú principal deteniendo relojes y reseteando flags."
    self detenerReloj.
    juegoIniciado := false.
    botonStart ifNotNil: [ botonStart label: 'Start' ].
    app volverAlMenu.

]
