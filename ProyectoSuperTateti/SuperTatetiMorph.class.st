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
    | btn valor |
    btn := (botones at: indiceTablerito) at: indiceCasilla.

    valor := juego valorEnTablerito: indiceTablerito casilla: indiceCasilla.
    btn label: (valor
        ifNil: [ ' ' ]
        ifNotNil: [ valor asString asUppercase ]).

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
    | panel tamanio filas columnas |

    tamanio := 50.
    filas := 9.
    columnas := 9.

    panel := Morph new.
    panel layoutPolicy: TableLayout new.
    panel listDirection: #topToBottom.
    panel hResizing: #spaceFill;
          vResizing: #spaceFill;
          cellInset: 2.
    panel color: Color veryLightGray.

    botones := Array new: 9.
    1 to: 9 do: [:t |
        botones at: t put: (Array new: 9) ].

    1 to: filas do: [:row |
        | fila |
        fila := Morph new.
        fila layoutPolicy: TableLayout new.
        fila listDirection: #leftToRight.
        fila hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 2.

        1 to: columnas do: [:col |
            | tIndex cIndex btn |

            "tablerito (1..9) y casilla (1..9)"
            tIndex := ((row - 1) // 3) * 3 + ((col - 1) // 3) + 1.
            cIndex := ((row - 1) \\ 3) * 3 + ((col - 1) \\ 3) + 1.

            btn := SimpleButtonMorph new.
            btn extent: tamanio @ tamanio.
            btn label: ' '.
            btn borderWidth: 1.
            btn borderColor: Color black.
            btn color: Color white.
            btn target: self.
            btn actionSelector: #clicEnTablerito:casilla:.
            btn arguments: { tIndex. cIndex }.

            (botones at: tIndex) at: cIndex put: btn.

            "Opcional: engrosar bordes donde se separan los 3x3"
            (row = 3 or: [ row = 6 ]) ifTrue: [ btn borderWidth: 2 ].
            (col = 3 or: [ col = 6 ]) ifTrue: [ btn borderWidth: 2 ].

            fila addMorph: btn ].

        panel addMorph: fila ].

    window addMorph: panel frame: (0@0 corner: 1@1).

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
