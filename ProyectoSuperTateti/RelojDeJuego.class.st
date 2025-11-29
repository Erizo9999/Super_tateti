Class {
	#name : 'RelojDeJuego',
	#superclass : 'Object',
	#instVars : [
		'duraciones',
		'indiceActual',
		'duracionActual',
		'tiempoRestante'
	],
	#category : 'ProyectoSuperTateti',
	#package : 'ProyectoSuperTateti'
}

{ #category : 'updating' }
RelojDeJuego >> decrementarUnSegundo [
    "Resta un segundo al tiempo restante, siempre que sea mayor a 0."
    tiempoRestante > 0 ifTrue: [
        tiempoRestante := tiempoRestante - 1 ].

]

{ #category : 'accessing' }
RelojDeJuego >> duracionActual [ 
    ^ duracionActual
]

{ #category : 'accessing' }
RelojDeJuego >> duracionActual: unNumero [
    "Cambia la duración total actual del reloj y resetea el tiempo restante."
    duracionActual := unNumero.
    tiempoRestante := unNumero.

]

{ #category : 'accessing' }
RelojDeJuego >> duraciones [
    "Devuelve la colección de duraciones posibles del reloj."
    ^ duraciones.

]

{ #category : 'accessing' }
RelojDeJuego >> duraciones: unaColeccion [
    "Permite cambiar la lista de duraciones posibles."
    duraciones := unaColeccion.

]

{ #category : 'accessing' }
RelojDeJuego >> indiceActual [
    "Devuelve el índice actual dentro de la lista de duraciones."
    ^ indiceActual.

]

{ #category : 'accessing' }
RelojDeJuego >> indiceActual: unIndice [
    "Permite cambiar el índice actual dentro de la lista de duraciones."
    indiceActual := unIndice.

]

{ #category : 'initialization' }
RelojDeJuego >> initialize [
    "Inicializa el reloj con una lista de duraciones posibles y lo deja en 1 minuto por defecto."
    super initialize.
    "Duraciones en segundos: 60s (1min), 120s (2min), 300s (5min), 600s (10min)."
    duraciones := #(60 120 300 600).
    "Empezamos en la primera duración (1 minuto)."
    indiceActual := 1.
    "Duración actual según el índice seleccionado."
    duracionActual := duraciones at: indiceActual.
    "Al inicio, el tiempo restante es igual a la duración completa."
    tiempoRestante := duracionActual.

]

{ #category : 'updating' }
RelojDeJuego >> resetear [
    "Vuelve el tiempo restante a la duración completa actual del reloj."
    tiempoRestante := duracionActual.

]

{ #category : 'updating' }
RelojDeJuego >> restarSegundos: unNumero [
    "Resta unNumero segundos al tiempo restante, sin bajar de 0."
    tiempoRestante := tiempoRestante - unNumero.
    tiempoRestante < 0 ifTrue: [
        tiempoRestante := 0 ].

]

{ #category : 'updating' }
RelojDeJuego >> siguienteDuracion [
    "Pasa a la siguiente duración de la lista (1 → 2 → 5 → 10 minutos y vuelve a 1)."
    indiceActual := indiceActual + 1.
    indiceActual > duraciones size ifTrue: [
        "Si nos pasamos del final de la lista, volvemos al primero."
        indiceActual := 1 ].
    "Actualizamos la duración actual según el nuevo índice."
    duracionActual := duraciones at: indiceActual.
    "Y reseteamos el tiempo restante a la nueva duración."
    tiempoRestante := duracionActual.

]

{ #category : 'testing' }
RelojDeJuego >> termino [
    "Responde true si ya no queda tiempo (0 o menos segundos)."
    ^ tiempoRestante <= 0.

]

{ #category : 'printing' }
RelojDeJuego >> tiempoComoString [
    "Devuelve el tiempo restante en formato 'MM:SS', por ejemplo '01:00', '02:35'."
    | mins secs minsStr secsStr |
    "Calculamos minutos y segundos enteros a partir del total de segundos."
    mins := tiempoRestante // 60.
    secs := tiempoRestante \\ 60.
    "Convertimos a strings de 2 dígitos, rellenando con 0 a la izquierda si hace falta."
    minsStr := (mins printString) padLeftTo: 2 with: $0.
    secsStr := (secs printString) padLeftTo: 2 with: $0.
    "Juntamos 'MM' ':' 'SS'."
    ^ minsStr , ':' , secsStr.

]

{ #category : 'accessing' }
RelojDeJuego >> tiempoRestante [
    "Devuelve el tiempo restante actual (en segundos)."
    ^ tiempoRestante.

]

{ #category : 'accessing' }
RelojDeJuego >> tiempoRestante: unNumero [
    "Permite fijar directamente el tiempo restante (en segundos)."
    tiempoRestante := unNumero.

]
