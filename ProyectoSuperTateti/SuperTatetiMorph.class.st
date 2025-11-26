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
SuperTatetiMorph >> actualizarTituloVentana [
    | titulo |
    titulo := juego ganador
        ifNil: [
            'Super Tateti - turno: ', juego jugadorActual asString asUppercase ]
        ifNotNil: [:g |
            'Super Tateti - GANADOR: ', g asString asUppercase ].
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
    Transcript show: 'Click en ', indiceTablerito printString, '-', indiceCasilla printString; cr.

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
    | mainPanel boardPanel bottomPanel
      botonNew botonExit filas columnas cellSize
      filaMorph btn tIndex cIndex gap gapMorph rowGap |

    filas := 9.
    columnas := 9.
    cellSize := 30.   "tamaño de cada casilla"
    gap := 4.         "separación entre tableritos 3x3"

    "===== Panel principal (columna) ====="
    mainPanel := Morph new.
    mainPanel layoutPolicy: TableLayout new.
    mainPanel listDirection: #topToBottom.
    mainPanel hResizing: #spaceFill;
              vResizing: #spaceFill;
              cellInset: 10.
    mainPanel color: Color veryLightGray.

    "===== Panel del tablero 9x9 ====="
    boardPanel := Morph new.
    boardPanel layoutPolicy: TableLayout new.
    boardPanel listDirection: #topToBottom.
    boardPanel hResizing: #shrinkWrap;
               vResizing: #shrinkWrap;
               cellInset: 0.
    boardPanel color: Color veryLightGray.

    "inicializamos la ivar botones"
    botones := Array new: 9.
    1 to: 9 do: [:t | botones at: t put: (Array new: 9) ].

    1 to: filas do: [:row |
        filaMorph := Morph new.
        filaMorph layoutPolicy: TableLayout new.
        filaMorph listDirection: #leftToRight.
        filaMorph hResizing: #shrinkWrap;
                  vResizing: #shrinkWrap;
                  cellInset: 0.

        1 to: columnas do: [:col |
            "tablerito (1..9) y casilla (1..9)"
            tIndex := ((row - 1) // 3) * 3 + ((col - 1) // 3) + 1.
            cIndex := ((row - 1) \\ 3) * 3 + ((col - 1) \\ 3) + 1.

            btn := SimpleButtonMorph new.
            btn extent: cellSize @ cellSize.
            btn layoutPolicy: nil.
            btn hResizing: #rigid;
                vResizing: #rigid.
            btn color: Color white.
            btn borderWidth: 1.
            btn borderColor: Color black.

            btn target: self.
            btn actionSelector: #clicEnTablerito:casilla:.
            btn arguments: { tIndex. cIndex }.

            (botones at: tIndex) at: cIndex put: btn.
            filaMorph addMorph: btn.

            "después de las columnas 3 y 6, agregamos una columna de espacio"
            (#(3 6) includes: col) ifTrue: [
                gapMorph := Morph new.
                gapMorph extent: gap @ cellSize.
                gapMorph color: boardPanel color.
                gapMorph borderWidth: 0.
                filaMorph addMorph: gapMorph ] ].

        boardPanel addMorph: filaMorph.

        "después de las filas 3 y 6, agregamos una fila de espacio"
        (#(3 6) includes: row) ifTrue: [
            rowGap := Morph new.
            rowGap layoutPolicy: nil.
            rowGap extent: filaMorph fullBounds width @ gap.
            rowGap color: boardPanel color.
            rowGap borderWidth: 0.
            boardPanel addMorph: rowGap ] ].

    "===== Barra inferior con Exit / New ====="
    bottomPanel := Morph new.
    bottomPanel layoutPolicy: TableLayout new.
    bottomPanel listDirection: #leftToRight.
    bottomPanel hResizing: #shrinkWrap;
                 vResizing: #shrinkWrap;
                 cellInset: 0.
    bottomPanel color: Color lightGray.

    botonExit := SimpleButtonMorph new.
    botonExit label: 'Exit'.
    botonExit extent: 100@40.
    botonExit color: Color lightGray.
    botonExit borderWidth: 1.
    botonExit borderColor: Color black.
    botonExit target: self.
    botonExit actionSelector: #cerrarVentana.

    botonNew := SimpleButtonMorph new.
    botonNew label: 'New'.
    botonNew extent: 100@40.
    botonNew color: Color lightGray.
    botonNew borderWidth: 1.
    botonNew borderColor: Color black.
    botonNew target: self.
    botonNew actionSelector: #reiniciarJuego.

    bottomPanel addMorph: botonExit.
    bottomPanel addMorph: botonNew.

    "===== Armar layout general ====="
    mainPanel addMorph: boardPanel.
    mainPanel addMorph: bottomPanel.

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
