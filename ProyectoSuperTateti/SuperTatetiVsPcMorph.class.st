Class {
	#name : 'SuperTatetiVsPcMorph',
	#superclass : 'SuperTatetiMorph',
	#instVars : [
		'simboloHumano',
		'simboloPc',
		'estrategiaPc'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'events' }
SuperTatetiVsPcMorph >> despuesDeJugadaHumano [
    (partidaSistema juegoTerminado or: [ partidaSistema relojCorriendo not ]) ifTrue: [
        ^ self
    ].

    (partidaSistema jugadorActual = simboloPc) ifTrue: [
        self jugarTurnoPc
    ]

]

{ #category : 'initialization' }
SuperTatetiVsPcMorph >> initialize [
    super initialize.
    simboloHumano := #x.
    simboloPc := #o.
    estrategiaPc := SuperTatetiPcStrategy new.

]

{ #category : 'game_logic' }
SuperTatetiVsPcMorph >> jugarTurnoPc [
    | mov tIndex cIndex modelo |

    (partidaSistema juegoTerminado) ifTrue: [ ^ self ].
    (partidaSistema jugadorActual = simboloPc) ifFalse: [ ^ self ].
    (partidaSistema relojCorriendo) ifFalse: [ ^ self ].

    modelo := partidaSistema modeloDeJuego.

    mov := estrategiaPc elegirJugadaEn: modelo.
    mov isNil ifTrue: [ ^ self ].

    tIndex := mov first.
    cIndex := mov second.

    partidaSistema
        jugarMovimientoPcEnTablerito: tIndex
        casilla: cIndex

]
