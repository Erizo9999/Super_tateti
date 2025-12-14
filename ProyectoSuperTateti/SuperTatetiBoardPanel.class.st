Class {
	#name : 'SuperTatetiBoardPanel',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'controller',
		'botones',
		'panel'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'updating' }
SuperTatetiBoardPanel >> actualizarBotonDeTablerito: indiceTablerito casilla: indiceCasilla [
    | btn valor texto |

    btn := (botones at: indiceTablerito) at: indiceCasilla.

    "Valor que tiene esa casilla en el modelo (#x, #o o nil) vía el controller"
    valor := controller
        valorEnTablerito: indiceTablerito
        casilla: indiceCasilla.

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
SuperTatetiBoardPanel >> actualizarVista [
    1 to: 9 do: [:t |
        1 to: 9 do: [:c |
            self actualizarBotonDeTablerito: t casilla: c ] ]

]

{ #category : 'updating' }
SuperTatetiBoardPanel >> actualizarVistaConAyuda: unBooleano [
    self actualizarVista

]

{ #category : 'accessing' }
SuperTatetiBoardPanel >> botones [
    ^ botones

]

{ #category : 'accessing' }
SuperTatetiBoardPanel >> controller [
    ^ controller

]

{ #category : 'accessing' }
SuperTatetiBoardPanel >> controller: unController [
    controller := unController

]

{ #category : 'building' }
SuperTatetiBoardPanel >> crearBoardPanel [
    | boardPanelLocal |
    boardPanelLocal := Morph new.
    boardPanelLocal layoutPolicy: TableLayout new.
    boardPanelLocal listDirection: #topToBottom.
    boardPanelLocal hResizing: #shrinkWrap;
                  vResizing: #shrinkWrap;
                  cellInset: 0.
    boardPanelLocal color: Color veryLightGray.

    self inicializarBotones.

    1 to: 9 do: [:row |
        boardPanelLocal addMorph: (self crearFila: row).
        (#(3 6) includes: row) ifTrue: [
            boardPanelLocal addMorph: self crearGapFila ] ].

    panel := boardPanelLocal.
    ^ boardPanelLocal

]

{ #category : 'building' }
SuperTatetiBoardPanel >> crearBotonEnFila: row columna: col [
    | tIndex cIndex btn |
    tIndex := ((row - 1) // 3) * 3 + ((col - 1) // 3) + 1.
    cIndex := ((row - 1) \\ 3) * 3 + ((col - 1) \\ 3) + 1.

    btn := SimpleButtonMorph new.
    btn extent: 30@30.
    btn hResizing: #rigid; vResizing: #rigid.
    btn color: Color white.
    btn borderWidth: 1; borderColor: Color black.

    "El evento va al controller (SuperTatetiMorph)"
    btn
        target: controller;
        actionSelector: #clicEnTablerito:casilla:;
        arguments: { tIndex. cIndex }.

    (botones at: tIndex) at: cIndex put: btn.
    ^ btn

]

{ #category : 'building' }
SuperTatetiBoardPanel >> crearFila: row [
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
SuperTatetiBoardPanel >> crearGapColumna [
    ^ Morph new
        layoutPolicy: nil;
        hResizing: #rigid;
        vResizing: #rigid;
        extent: 6@30;
        color: Color gray;
        borderWidth: 0;
        yourself

]

{ #category : 'building' }
SuperTatetiBoardPanel >> crearGapFila [
    | ancho |
    "Calculamos el ancho total del tablero: 9 celdas de 30 + 2 gaps de columna"
    ancho := (9 * 30) + (2 * 6).

    ^ Morph new
        layoutPolicy: nil;
        hResizing: #rigid;
        vResizing: #rigid;
        extent: ancho @ 6;
        color: Color gray;
        borderWidth: 0;
        yourself

]

{ #category : 'building' }
SuperTatetiBoardPanel >> inicializarBotones [
    botones := Array new: 9.
    1 to: 9 do: [:t | botones at: t put: (Array new: 9) ].

]

{ #category : 'initialization' }
SuperTatetiBoardPanel >> initialize [
    super initialize.
    juego := nil.
    controller := nil.
    botones := nil.
    panel := nil.

]

{ #category : 'accessing' }
SuperTatetiBoardPanel >> panel [
    ^ panel

]

{ #category : 'updating' }
SuperTatetiBoardPanel >> resaltarCasillas: unaColeccion [
    unaColeccion do: [:par |
        | t c btn |
        t := par first.
        c := par second.
        btn := (botones at: t) at: c.
        btn color: Color yellow ]

]
