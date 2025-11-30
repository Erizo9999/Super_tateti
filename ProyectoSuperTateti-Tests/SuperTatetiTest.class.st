Class {
	#name : 'SuperTatetiTest',
	#superclass : 'TestCase',
	#instVars : [
		'juego'
	],
	#category : 'ProyectoSuperTateti-Tests',
	#package : 'ProyectoSuperTateti-Tests'
}

{ #category : 'running' }
SuperTatetiTest >> setUp [
	super setUp.
juego := SuperTateti new
	"Put here a common initialization logic for tests"
]

{ #category : 'tests' }
SuperTatetiTest >> testDeshacer [ 
   juego jugarEnTablerito: 1 casilla: 3.
   juego deshacerUltimaJugada.
   self assert: (juego valorEnTablerito: 1 casilla: 3) isNil.
   self assert: juego proximoTablerito isNil.

]

{ #category : 'tests' }
SuperTatetiTest >> testMovimientoInvalido [ 
   juego jugarEnTablerito: 1 casilla: 3.
   self should: [ juego jugarEnTablerito: 1 casilla: 2 ] raise: Error.

]

{ #category : 'tests' }
SuperTatetiTest >> testPrimerMovimiento [ 
   juego jugarEnTablerito: 1 casilla: 3.
   self assert: (juego estadoDeTablerito: 1) = #enJuego.
   self assert: juego proximoTablerito = 3.
   self assert: juego jugadorActual = #o.

]

{ #category : 'tests' }
SuperTatetiTest >> testVictoriaGlobal [ 
   | t1 t2 t3 |
   t1 := juego tableritoEnIndice: 1.
   t2 := juego tableritoEnIndice: 2.
   t3 := juego tableritoEnIndice: 3.

   t1 ponerSimbolo: #x enCasilla: 1; ponerSimbolo: #x enCasilla: 2; ponerSimbolo: #x enCasilla: 3.
   t2 ponerSimbolo: #x enCasilla: 1; ponerSimbolo: #x enCasilla: 2; ponerSimbolo: #x enCasilla: 3.
   t3 ponerSimbolo: #x enCasilla: 1; ponerSimbolo: #x enCasilla: 2; ponerSimbolo: #x enCasilla: 3.

   juego actualizarGanadorGeneral.

   self assert: juego ganador = #x.

]

{ #category : 'tests' }
SuperTatetiTest >> testVictoriaLocal [ 
   | tablero |
   tablero := juego tableritoEnIndice: 1.
   tablero ponerSimbolo: #x enCasilla: 1.
   tablero ponerSimbolo: #x enCasilla: 2.
   tablero ponerSimbolo: #x enCasilla: 3.

   self assert: tablero ganador = #x.
   self assert: tablero estado = #x.

]
