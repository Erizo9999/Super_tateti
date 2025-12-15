Class {
	#name : 'SuperTatetiRelojPanel',
	#superclass : 'Object',
	#instVars : [
		'relojTurnos',
		'cajaTiempoX',
		'cajaTiempoO',
		'panel'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'updating' }
SuperTatetiRelojPanel >> actualizarCaja: unaCaja conTexto: unString [
	| label posX posY |
	unaCaja submorphs do: [:m | m delete ].

	label := StringMorph contents: unString.
	label color: Color black.
	unaCaja addMorph: label.

	posX := (unaCaja extent x - label extent x) / 2.
	posY := (unaCaja extent y - label extent y) / 2.
	label position: posX @ posY

]

{ #category : 'updating' }
SuperTatetiRelojPanel >> actualizarTextoTiempo [
	| textoX textoO |

	relojTurnos ifNil: [ ^ self ].
	(cajaTiempoX isNil or: [ cajaTiempoO isNil ]) ifTrue: [ ^ self ].

	textoX := relojTurnos tiempoComoStringPara: #x.
	textoO := relojTurnos tiempoComoStringPara: #o.

	self actualizarCaja: cajaTiempoX conTexto: textoX.
	self actualizarCaja: cajaTiempoO conTexto: textoO

]

{ #category : 'building' }
SuperTatetiRelojPanel >> crearPanelTiempoO [
    "Crea el panel de tiempo para el jugador O (caja + etiqueta 'time: O')."
    | panelO etiqueta |

    panelO := Morph new.
    panelO layoutPolicy: TableLayout new.
    panelO listDirection: #topToBottom.
    panelO hResizing: #shrinkWrap;
            vResizing: #shrinkWrap;
            cellInset: 5.
    panelO color: Color veryLightGray.

    "Caja donde se dibuja el tiempo de O (guardamos referencia)."
    cajaTiempoO := Morph new.
    cajaTiempoO layoutPolicy: TableLayout new.
    cajaTiempoO hResizing: #shrinkWrap;
                vResizing: #shrinkWrap.
    cajaTiempoO extent: 120@40.
    cajaTiempoO color: Color white.
    cajaTiempoO borderWidth: 2;
               borderColor: Color black.

    "Etiqueta 'time: O' debajo de la caja."
    etiqueta := StringMorph contents: 'time: O'.
    etiqueta color: Color black.

    panelO addMorph: cajaTiempoO.
    panelO addMorph: etiqueta.

    ^ panelO

]

{ #category : 'building' }
SuperTatetiRelojPanel >> crearPanelTiempoX [
    "Crea el panel de tiempo para el jugador X (caja + etiqueta 'time: X')."
    | panelX etiqueta |

    panelX := Morph new.
    panelX layoutPolicy: TableLayout new.
    panelX listDirection: #topToBottom.
    panelX hResizing: #shrinkWrap;
            vResizing: #shrinkWrap;
            cellInset: 5.
    panelX color: Color veryLightGray.

    "Caja donde se dibuja el tiempo de X (guardamos referencia)."
    cajaTiempoX := Morph new.
    cajaTiempoX layoutPolicy: TableLayout new.
    cajaTiempoX hResizing: #shrinkWrap;
                vResizing: #shrinkWrap.
    cajaTiempoX extent: 120@40.
    cajaTiempoX color: Color cyan.
    cajaTiempoX borderWidth: 2;
               borderColor: Color black.

    "Etiqueta 'time: X' debajo de la caja."
    etiqueta := StringMorph contents: 'time: X'.
    etiqueta color: Color black.

    panelX addMorph: cajaTiempoX.
    panelX addMorph: etiqueta.

    ^ panelX

]

{ #category : 'building' }
SuperTatetiRelojPanel >> crearPanelTiemposJugadores [
    "Crea el panel horizontal que contiene los tiempos de X y O."
    | panelLocal |

    panelLocal := Morph new.
    panelLocal layoutPolicy: TableLayout new.
    panelLocal listDirection: #leftToRight.
    panelLocal hResizing: #shrinkWrap;
              vResizing: #shrinkWrap;
              cellInset: 40.
    panelLocal color: Color veryLightGray.

    panelLocal addMorph: self crearPanelTiempoX.
    panelLocal addMorph: self crearPanelTiempoO.

    panel := panelLocal.

    "Actualizamos los textos iniciales de los relojes."
    self actualizarTextoTiempo.

    ^ panelLocal

]

{ #category : 'initialization' }
SuperTatetiRelojPanel >> initialize [
    super initialize.

]

{ #category : 'accessing' }
SuperTatetiRelojPanel >> panel [
    ^ panel

]

{ #category : 'accessing' }
SuperTatetiRelojPanel >> relojTurnos [
    ^ relojTurnos

]

{ #category : 'accessing' }
SuperTatetiRelojPanel >> relojTurnos: unRelojTurnos [
    relojTurnos := unRelojTurnos

]
