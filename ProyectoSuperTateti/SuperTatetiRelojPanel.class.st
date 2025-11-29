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
SuperTatetiRelojPanel >> actualizarTextoTiempo [
    "Actualiza los textos de los relojes de X y O en sus cajas de tiempo."

    | textoX textoO labelX labelO posX posY |

    "Si todavía no hay reloj o cajas, no hacemos nada."
    relojTurnos ifNil: [ ^ self ].
    (cajaTiempoX isNil or: [ cajaTiempoO isNil ]) ifTrue: [ ^ self ].

    "Textos en formato 'MM:SS'."
    textoX := relojTurnos tiempoComoStringPara: #x.
    textoO := relojTurnos tiempoComoStringPara: #o.

    "-------- Caja del jugador X --------"
    cajaTiempoX submorphs do: [:m | m delete].
    labelX := StringMorph contents: textoX.
    labelX color: Color black.
    cajaTiempoX addMorph: labelX.

    posX := (cajaTiempoX extent x - labelX extent x) / 2.
    posY := (cajaTiempoX extent y - labelX extent y) / 2.
    labelX position: posX @ posY.

    "-------- Caja del jugador O --------"
    cajaTiempoO submorphs do: [:m | m delete].
    labelO := StringMorph contents: textoO.
    labelO color: Color black.
    cajaTiempoO addMorph: labelO.

    posX := (cajaTiempoO extent x - labelO extent x) / 2.
    posY := (cajaTiempoO extent y - labelO extent y) / 2.
    labelO position: posX @ posY.

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
    panel := nil.
    cajaTiempoX := nil.
    cajaTiempoO := nil.

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
