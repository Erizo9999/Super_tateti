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
    | juego reloj |

    "Obtenemos los sistemas a través de PartidaSistema."
    juego := partidaSistema juegoSistema.
    reloj := partidaSistema relojSistema.

    "Si el juego terminó o el reloj está pausado, no hace nada."
    (juego juegoTerminado or: [ reloj corriendo not ]) ifTrue: [
        ^ self
    ].

    "Si ahora es el turno de la PC, dejamos que juegue."
    (juego jugadorActual = simboloPc) ifTrue: [
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
    "Hace que la PC juegue una jugada válida al azar usando una estrategia."

    | juego reloj mov tIndex cIndex modelo |

    "Obtenemos los sistemas a través de PartidaSistema."
    juego := partidaSistema juegoSistema.
    reloj := partidaSistema relojSistema.

    (juego juegoTerminado) ifTrue: [ ^ self ].
    (juego jugadorActual = simboloPc) ifFalse: [ ^ self ].
    (reloj corriendo) ifFalse: [ ^ self ].

    "Obtenemos el modelo SuperTateti desde el sistema de juego."
    modelo := juego juego.

    mov := estrategiaPc elegirJugadaEn: modelo.
    mov isNil ifTrue: [ ^ self ].

    tIndex := mov first.
    cIndex := mov second.

    "Usamos la misma lógica de jugada que un clic normal,
    pero como movimiento de PC (sin volver a llamar al hook de humano)."
    partidaSistema
        jugarMovimientoPcEnTablerito: tIndex
        casilla: cIndex

]
