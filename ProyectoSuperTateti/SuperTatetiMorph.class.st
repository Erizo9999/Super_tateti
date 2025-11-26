Class {
	#name : 'SuperTatetiMorph',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'botones',
		'window'
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
    | btn valor tam origen |
    btn := (botones at: indiceTablerito) at: indiceCasilla.

    tam := btn valueOfProperty: #cellSize ifAbsent: [ btn bounds width ].
    origen := btn bounds origin.

    valor := juego valorEnTablerito: indiceTablerito casilla: indiceCasilla.
    btn label: (valor
        ifNil: [ ' ' ]
        ifNotNil: [ valor asString asUppercase ]).

    btn bounds: (origen extent: tam @ tam).
    btn color: Color white.

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarTituloVentana [
    | titulo |
    titulo := 'Super Tateti'.

    juego ganador
        ifNil: [
            titulo := titulo , ' - turno: ',
                juego jugadorActual asString asUppercase ]
        ifNotNil: [
            titulo := titulo , ' - GANADOR: ',
                juego ganador asString asUppercase ].

    window setLabel: titulo.

]

{ #category : 'updating' }
SuperTatetiMorph >> actualizarVista [
    1 to: 9 do: [:t |
        1 to: 9 do: [:c |
            self actualizarBotonDeTablerito: t casilla: c ] ].

    self actualizarTituloVentana.

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

{ #category : 'helpers' }
SuperTatetiMorph >> cerrarVentana [
    window delete.

]

{ #category : 'events' }
SuperTatetiMorph >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    [ juego jugarEnTablerito: indiceTablerito casilla: indiceCasilla ]
        on: Error
        do: [:ex | UIManager default inform: ex messageText ].

    self actualizarVista.

    (juego juegoTerminado) ifTrue: [
        self anunciarGanador ].

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
    | mainPanel topPanel boardContainer boardPanel
      botonNew botonExit filas columnas totalWidth cellSize boardWidth
      tIndex cIndex btn origenX x y |

    filas := 9.
    columnas := 9.

    "===== Panel principal (columna) ====="
    mainPanel := Morph new.
    mainPanel layoutPolicy: TableLayout new.
    mainPanel listDirection: #topToBottom.
    mainPanel hResizing: #spaceFill;
              vResizing: #spaceFill;
              cellInset: 10.
    mainPanel color: Color veryLightGray.

    "===== Barra superior con New / Exit ====="
    topPanel := Morph new.
    topPanel layoutPolicy: TableLayout new.
    topPanel listDirection: #leftToRight.
    topPanel hResizing: #shrinkWrap;
             vResizing: #shrinkWrap;
             cellInset: 0.
    topPanel color: Color lightGray.

    botonExit := SimpleButtonMorph new.
    botonExit label: 'Exit'.
    botonExit extent: 99@40.
    botonExit color: Color lightGray.
    botonExit borderWidth: 1.
    botonExit borderColor: Color black.
    botonExit target: self.
    botonExit actionSelector: #cerrarVentana.

    botonNew := SimpleButtonMorph new.
    botonNew label: 'New'.
    botonNew extent: 99@40.
    botonNew color: Color lightGray.
    botonNew borderWidth: 1.
    botonNew borderColor: Color black.
    botonNew target: self.
    botonNew actionSelector: #reiniciarJuego.

    topPanel addMorph: botonExit.
    topPanel addMorph: botonNew.

    "ancho total del tablero = ancho de New + Exit (99+99 = 198)"
    totalWidth := botonNew width + botonExit width.

    "tamaño ENTERO de cada casilla"
    cellSize := totalWidth // columnas.      "198 // 9 = 22"
    boardWidth := cellSize * columnas.      "22 * 9 = 198"

    "arrancar pegado a la izquierda"
    origenX := 0.

    "===== Contenedor del tablero ====="
    boardContainer := Morph new.
    boardContainer layoutPolicy: nil.
    boardContainer color: Color veryLightGray.

    boardPanel := Morph new.
    boardPanel layoutPolicy: nil.
    boardPanel color: Color veryLightGray.
    boardPanel bounds: (0@0 extent: boardWidth @ (cellSize * filas)).

    botones := (1 to: 9) collect: [:i | Array new: 9 ].

    "===== Dibujar las 81 casillas ====="
    0 to: filas - 1 do: [:rowIndex |
        0 to: columnas - 1 do: [:colIndex |
            x := origenX + (colIndex * cellSize).
            y := rowIndex * cellSize.

            "tablerito y casilla (1..9)"
            tIndex := (rowIndex // 3) * 3 + (colIndex // 3) + 1.
            cIndex := (rowIndex \\ 3) * 3 + (colIndex \\ 3) + 1.

            btn := SimpleButtonMorph new.
            btn bounds: ((x @ y) extent: cellSize @ cellSize).
            btn label: ' '.
            btn layoutPolicy: nil.
            btn hResizing: #rigid.
            btn vResizing: #rigid.
            btn color: Color white.
            btn borderWidth: 1.
            btn borderColor: Color black.

            "guardamos el tamaño de la casilla para mantenerlo luego"
            btn setProperty: #cellSize toValue: cellSize.

            btn target: self.
            btn actionSelector: #clicEnTablerito:casilla:.
            btn arguments: { tIndex. cIndex }.

            (botones at: tIndex) at: cIndex put: btn.
            boardPanel addMorph: btn ] ].

    "===== Marcos 3x3 para cada tablerito (forma de tateti) ====="
    1 to: 3 do: [:bigRow |
        1 to: 3 do: [:bigCol |
            | baseRow baseCol frameX frameY marco |
            baseRow := (bigRow - 1) * 3.
            baseCol := (bigCol - 1) * 3.
            frameX := origenX + (baseCol * cellSize).
            frameY := baseRow * cellSize.

            marco := Morph new.
            marco bounds: (frameX @ frameY
                            extent: (cellSize * 3) @ (cellSize * 3)).
            marco color: Color transparent.   "o veryLightGray si no hay transparente"
            marco borderWidth: 2.
            marco borderColor: Color gray.

            boardPanel addMorph: marco ] ].

    boardContainer bounds: boardPanel bounds.
    boardContainer addMorph: boardPanel.

    "===== Agregar barra + tablero al panel principal ====="
    mainPanel addMorph: topPanel.
    mainPanel addMorph: boardContainer.

    window addMorph: mainPanel frame: (0@0 corner: 1@1).

]

{ #category : 'building' }
SuperTatetiMorph >> crearVentana [
    window := SystemWindow labelled: 'Super Tateti'.
    window extent: 450@450.

]

{ #category : 'initialization' }
SuperTatetiMorph >> initialize [
    super initialize.

]

{ #category : 'initialization' }
SuperTatetiMorph >> openInWorld [
    juego := SuperTateti new.
    self crearVentana.
    self crearTablero.
    self actualizarVista.
    window openInWorld.

]

{ #category : 'helpers' }
SuperTatetiMorph >> reiniciarJuego [
    juego reiniciar.
    self actualizarVista.

]
