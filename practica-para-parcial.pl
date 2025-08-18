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

descubrimiento(a1, pulpo, caracteristicas(extremidades(8), algo(luminisciencia)), 3400, 07, observado).
descubrimiento(a2, pulpo, caracteristicas(extremidades(8), color(azul)), 3150, 08, observado).
descubrimiento(b1, estrella, caracteristicas(extremidades(5), color(naranja), algo(culona)), 3400, 12, observado).
descubrimiento(c1, pepino_de_mar, caracteristicas(color(violeta)), 1900, 14, observado).
descubrimiento(d1, anemona, caracteristicas(extremidades(30)), 1900, 15, recolectado).
descubrimiento(d2, anemona, caracteristicas(extremidades(35)), 2200, 16, recolectado).
descubrimiento(c2, pepino_pelagico, caracteristicas(color(transparemte), algo(luminisciencia)), 2800, 17, recolectado).
descubrimiento(e1, pez_linterna, caracteristicas(color(rojo), algo(luminisciencia)), 3200, 19, observado).
descubrimiento(a2, pulpo_de_cristal, caracteristicas(color(transparemte), algo(fragil)), 3800, 21, recolectado).
descubrimiento(a3, pulpo_dumbo, caracteristicas(extremidades(10), color(gris)), 3400, 12, observado).


%1 
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


%4
promedioVistas(Promedio):-
    findall(Vista,vistas(_,Vista),Vistas),
    sum_list(Vistas, SumatoriaVistas),
    length(Vistas, Cantidad),
    Promedio is SumatoriaVistas/Cantidad.
    
%5 

variacionProfundidad(Hora1,Hora2,Variacion):-
    descubrimiento(_,_,_,Profundidad1,Hora1,_),
    descubrimiento(_,_,_,Profundidad2,Hora2,_),
    VariacionAux is Profundidad1-Profundidad2,
    abs(VariacionAux, Variacion).

%6
velocidad(Hora1,Hora2,Velocidad):-
    variacionProfundidad(Hora1,Hora2,Variacion),
    rangoEntreHoras(Hora1,Hora2,Diferencia),
    Velocidad is Variacion/Diferencia.

rangoEntreHoras(Hora1,Hora2,Rango):-
    DiferenciaAux is Hora1-Hora2,
    abs(DiferenciaAux,Rango).

descensoMasRapido(RangoDeHoras, VelocidadMax):-
    findall(Velocidad,velocidad(_,_,Velocidad),Velocidades),
    max_list(Velocidades,VelocidadMax),
    velocidad(Hora1,Hora2,VelocidadMax),
    rangoEntreHoras(Hora1,Hora2,RangoDeHoras).

%7

nivelDeNovedad(Descubrimiento, Nivel):-
    descubrimiento()