vistas(0, 2500).
vistas(1, 1800).
vistas(2, 1200).
vistas(3, 900).
vistas(4, 750).
vistas(5, 600).
vistas(6, 800).
vistas(7, 1500).
vistas(8, 3200).
vistas(9, 5800).
vistas(10, 8500).
vistas(11, 11200).
vistas(12, 13800).
vistas(13, 15200).
vistas(14, 16800).
vistas(15, 18500).
vistas(16, 10000).
vistas(17, 12000).
vistas(18, 12000).
vistas(19, 12000).
vistas(20, 12000).
vistas(21, 12000).
vistas(22, 12000).
vistas(23, 12000).

descubrimiento(a1, pulpo, [extremidades(8), luminisciencia], 3400, 07, observado).
descubrimiento(a2, pulpo, [extremidades(8), color(azul)], 3150, 08, observado).
descubrimiento(b1, estrella, [extremidades(5), color(naranja), culona], 3400, 12, observado).
descubrimiento(c1, pepino_de_mar, [color(violeta)], 1900, 14, observado).
descubrimiento(d1, anemona, [extremidades(30)], 1900, 15, recolectado).
descubrimiento(d2, anemona, [extremidades(35)], 2200, 16, recolectado).
descubrimiento(c2, pepino_pelagico, [transparente, luminisciencia], 2800, 17, recolectado).
descubrimiento(e1, pez_linterna, [luminisciencia, color(rojo)], 3200, 19, observado).
descubrimiento(a3, pulpo_de_cristal, [transparente, fragil], 3800, 21, recolectado).
descubrimiento(a4, pulpo_dumbo, [extremidades(10), color(gris)], 3900, 23, observado).

%1 
zona(zonaFotica).
zona(zonaAbisal).
zona(zonaBatial).
zona(zonaHadal).

zonaOceanica(Profundidad,ZonaOceanica):-
    ZonaOceanica = zonaFotica,
    Profundidad =< 610.
zonaOceanica(Profundidad,ZonaOceanica):-
    ZonaOceanica = zonaBatial,
    Profundidad >= 1000,
    Profundidad < 4000.
zonaOceanica(Profundidad,ZonaOceanica):-
    ZonaOceanica = zonaAbisal,
    Profundidad >= 4000,
    Profundidad < 6000.
zonaOceanica(Profundidad,ZonaOceanica):-
    ZonaOceanica = zonaHadal,
    Profundidad >= 6000.
    
%2
favorita(Especie,HoraMasVista,Numero):-
    findall(Vista,vistas(_,Vista),Vistas),
    max_list(Vistas,Max),
    vistas(HoraMasVista,Max),
    descubrimiento(Numero,Especie,_,_,HoraMasVista,_).

%3
zonaDeHallazgo(Especie,ZonaOceanica):-
    descubrimiento(_,Especie,_,Profundidad,_,_),
    zonaOceanica(Profundidad,ZonaOceanica).

cantidadDeDescubrimientosPorZona(ZonaOceanica,Cantidad):-
    zona(ZonaOceanica),
    findall(ZonaOceanica,zonaDeHallazgo(_,ZonaOceanica),Lista),
    length(Lista,Cantidad).

zonaDeMasHallazgos(ZonaOceanica):-
    cantidadDeDescubrimientosPorZona(ZonaOceanica,CantidadMax),
    forall(
        (cantidadDeDescubrimientosPorZona(OtroZonaOceanica,OtraCantidad),ZonaOceanica\=OtroZonaOceanica),
        CantidadMax > OtraCantidad
        ).


%4
promedioVistas(Promedio):-
    findall(Vista,vistas(_,Vista),Vistas),
    sum_list(Vistas, SumatoriaVistas),
    length(Vistas, Cantidad),
    Promedio is SumatoriaVistas/Cantidad.
    
%5 

variacionProfundidad(HoraInicial,HoraFinal,Variacion):-
    descubrimiento(_,_,_,Profundidad1,HoraInicial,_),
    descubrimiento(_,_,_,Profundidad2,HoraFinal,_),
    HoraFinal > HoraInicial,
    Variacion is Profundidad2 - Profundidad1.

%6
velocidad(Hora1,Hora2,Velocidad):-
    variacionProfundidad(Hora1,Hora2,Variacion),
    Diferencia is Hora2 -Hora1,
    Velocidad is Variacion/Diferencia.

descensoMasRapido(HoraInicial,HoraFinal,VelocidadMax):-
    velocidad(HoraInicial,HoraFinal,VelocidadMax),
    forall(
        (velocidad(OtraHoraIncial,OtraHoraFinal,OtraVelocidad),(OtraHoraIncial,OtraHoraFinal)\=(HoraInicial,HoraFinal)),
        VelocidadMax>=OtraVelocidad
    ).

%7
formaDeRecoleccion(observado,1).
formaDeRecoleccion(recolectado,1.5).

conocimientoR(5,luminisciencia).
conocimientoR(Cantidad,extremidades(Cantidad)).
conocimientoR(5,color(Color)):-
    indicaPeligro(Color).
conocimientoR(3,color(Color)):-
    not(indicaPeligro(Color)).

indicaPeligro(rojo).
indicaPeligro(amarrillo).

conocimiento(Conocimiento,Caracteristica):-
    conocimientoR(Conocimiento,Caracteristica).

conocimiento(10,Caracteristica):-
    not(conocimientoR(_,Caracteristica)).

nivelDeNovedad(Descubrimiento, Nivel):-
    descubrimiento(Descubrimiento,_,Caracteristicas,_,_,FormaDeRecoleccion),
    formaDeRecoleccion(FormaDeRecoleccion,Aumento),
    listaDeConocimientos(Descubrimiento,UnidadesDeConocimiento),
    sum_list(UnidadesDeConocimiento,NivelAux),
    Nivel is NivelAux*Aumento.

listaDeConocimientos(Descubrimiento,UnidadesDeConocimiento):-
    descubrimiento(Descubrimiento,_,Caracteristicas,_,_,_),
    findall(UnidadDeConocimiento,(member(Caracteristica,Caracteristicas),conocimiento(UnidadDeConocimiento,Caracteristica)),UnidadesDeConocimiento).





    