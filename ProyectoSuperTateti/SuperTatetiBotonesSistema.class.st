Class {
	#name : 'SuperTatetiBotonesSistema',
	#superclass : 'Object',
	#instVars : [
		'controller',
		'topBarPanel'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> botonStart [ 
    ^ controller botonStart
]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> botonStart: unBoton [ 
    controller botonStart: unBoton
]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> controller [ 
    ^ controller
]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> controller: unController [ 
    controller := unController
]

{ #category : 'building' }
SuperTatetiBotonesSistema >> crearTopBarPanel [ 
    "Devuelve el morph de la barra superior."
    ^ topBarPanel crearTopBarPanel
]

{ #category : 'initialization' }
SuperTatetiBotonesSistema >> initialize [ 
    super initialize.
    controller := nil.
    topBarPanel := SuperTatetiTopBarPanel new.
    topBarPanel controller: self.   "La barra de botones habla con BotonesSistema"
]

{ #category : 'events' }
SuperTatetiBotonesSistema >> resetPresionado [ 
    controller resetPresionado
]

{ #category : 'events' }
SuperTatetiBotonesSistema >> returnDeshabilitado [ 
    controller returnDeshabilitado

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> returnHabilitado [ 
    ^ controller returnHabilitado
]

{ #category : 'events' }
SuperTatetiBotonesSistema >> returnPresionado [ 
    controller returnPresionado
]

{ #category : 'events' }
SuperTatetiBotonesSistema >> startPresionado [ 
    controller startPresionado

]

{ #category : 'accessing' }
SuperTatetiBotonesSistema >> topBarPanel [ [
    ^ topBarPanel
]
]

{ #category : 'events' }
SuperTatetiBotonesSistema >> volverAlInicio [ 
    controller volverAlInicio
]
