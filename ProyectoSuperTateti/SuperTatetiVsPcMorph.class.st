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
SuperTatetiVsPcMorph >> clicEnTablerito: indiceTablerito casilla: indiceCasilla [
    "Primero procesamos el clic como en el modo 1 vs 1."
    super clicEnTablerito: indiceTablerito casilla: indiceCasilla.

    "Si el juego terminó o el reloj está pausado, no hacemos nada más."
    (juegoSistema juegoTerminado or: [ relojSistema corriendo not ]) ifTrue: [ ^ self ].

    "Si ahora es el turno de la PC, dejamos que juegue."
    (juegoSistema jugadorActual = simboloPc) ifTrue: [
        self jugarTurnoPc
    ].

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

    | mov tIndex cIndex modelo |

    (juegoSistema juegoTerminado) ifTrue: [ ^ self ].
    (juegoSistema jugadorActual = simboloPc) ifFalse: [ ^ self ].

    "Obtenemos el modelo SuperTateti desde el sistema de juego."
    modelo := juegoSistema juego.

    mov := estrategiaPc elegirJugadaEn: modelo.
    mov isNil ifTrue: [ ^ self ].

    tIndex := mov first.
    cIndex := mov second.

    "Usamos la misma lógica de jugada que un clic normal."
    super clicEnTablerito: tIndex casilla: cIndex.

]
