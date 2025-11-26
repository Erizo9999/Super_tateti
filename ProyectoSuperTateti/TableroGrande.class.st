Class {
	#name : 'TableroGrande',
	#superclass : 'TableroTatetiAbstracto',
	#instVars : [
		'proximoTablero'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'game-logic' }
TableroGrande >> actualizarProximoTableroConFila: fila columna: columna [
    | siguiente |
    siguiente := self tableroEnFila: fila columna: columna.
    siguiente estaTerminado
        ifTrue: [ proximoTablero := nil ]    "si está lleno/terminado, el próximo puede ser cualquiera"
        ifFalse: [ proximoTablero := { fila . columna } ].

]

{ #category : 'initialization' }
TableroGrande >> inicializarCeldas [
    "Crea una grilla 3x3 de TableroChico."
    | lado matriz |
    lado := self tamano.       "3"
    matriz := (1 to: lado) collect: [:f |
        (1 to: lado) collect: [:c | TableroChico new ] ].
    celdas := matriz.

]

{ #category : 'initialization' }
TableroGrande >> initialize [
    super initialize.          "crea celdas, tamano, ganador := nil"
    proximoTablero := nil.     "al inicio se puede jugar en cualquier tablerito"

]

{ #category : 'game-logic' }
TableroGrande >> jugarSimbolo: unSimbolo
    enTableroFila: filaTablero
    columna: colTablero
    filaChica: filaChica
    columnaChica: colChica [

    | subTablero ganadorAntes ganoSubTablero |
    (self puedeJugarEnTableroFila: filaTablero columna: colTablero) ifFalse: [
        self error: 'No se puede jugar en ese tablerito segun las reglas.' ].

    subTablero := self tableroEnFila: filaTablero columna: colTablero.

    ganadorAntes := subTablero ganador.
    subTablero colocar: unSimbolo fila: filaChica columna: colChica.
    ganoSubTablero := ganadorAntes isNil and: [ subTablero ganador notNil ].

    self actualizarGanador.
    self actualizarProximoTableroConFila: filaChica columna: colChica.

    ^ ganoSubTablero   "true si en esta jugada se ganó ese tablerito"

]

{ #category : 'accessing' }
TableroGrande >> proximoTablero [
    ^ proximoTablero.

]

{ #category : 'accessing' }
TableroGrande >> proximoTablero: unaCoordenada [
    proximoTablero := unaCoordenada.

]

{ #category : 'game-logic' }
TableroGrande >> puedeJugarEnTableroFila: fila columna: columna [
    "True si, según la regla del juego, se puede jugar en ese tablerito."

    proximoTablero isNil ifTrue: [
        "Al inicio (o cuando el tablerito obligado ya terminó)
        se puede jugar en cualquier tablerito que NO esté terminado."
        ^ (self tableroEnFila: fila columna: columna) estaTerminado not
    ].

    "Si hay un tablerito obligado, solo se puede jugar ahí
    y además debe no estar terminado."
    ^ (proximoTablero first = fila
        and: [ proximoTablero second = columna ])
        and: [ (self tableroEnFila: fila columna: columna) estaTerminado not ].

]

{ #category : 'accessing' }
TableroGrande >> tableroEnFila: fila columna: columna [
    ^ self celdaEnFila: fila columna: columna.

]
