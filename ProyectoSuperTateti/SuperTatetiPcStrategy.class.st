Class {
	#name : 'SuperTatetiPcStrategy',
	#superclass : 'Object',
	#instVars : [
		'Object'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'game_logic' }
SuperTatetiPcStrategy >> elegirJugadaEn: unJuego [
    "Devuelve una jugada válida al azar como {tablerito. casilla},
    o nil si no hay jugadas posibles."

    | jugadasValidas |

    jugadasValidas := OrderedCollection new.

    1 to: 9 do: [:t |
        1 to: 9 do: [:c |
            (unJuego esMovimientoValidoEnTablerito: t casilla: c)
                ifTrue: [ jugadasValidas add: { t. c } ] ] ].

    jugadasValidas isEmpty ifTrue: [ ^ nil ].

    ^ jugadasValidas atRandom

]
