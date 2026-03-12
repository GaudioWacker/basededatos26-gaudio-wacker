-- 1
SELECT * FROM Jugador
WHERE pais = "Argentina"
ORDER BY apellido;

-- 2
SELECT * FROM Videojuego
WHERE edad_minima >= 16;

-- 3
SELECT e.nombre as equipo, j.nombre, j.apellido FROM Equipo e
JOIN JugadorEquipo je ON e.id_equipo = je.id_equipo
JOIN Jugador j ON je.id_jugador = j.id_jugador;

-- 4
SELECT e.nombre AS equipo, t.nombre AS torneo, i.fecha_inscripcion, i.posicion_final FROM Inscripcion i
JOIN Equipo e ON i.id_equipo = e.id_equipo
JOIN Torneo t ON i.id_torneo = t.id_torneo;

-- 5
SELECT pais, COUNT(*) AS cantidad_jugadores FROM Jugador
GROUP BY pais;

-- 8   
SELECT e.nombre FROM Inscripcion i
JOIN Equipo e ON i.id_equipo = e.id_equipo
GROUP BY e.id_equipo 
HAVING COUNT(*) > 5;

-- 11
SELECT v.nombre FROM Videojuego v
JOIN Torneo t ON v.id_videojuego = t.id_videojuego
GROUP BY v.id_videojuego
ORDER BY COUNT(*) DESC 
LIMIT 1;

-- 13
UPDATE Torneo
SET premio = premio * 2
WHERE id_torneo IN (
    SELECT id_torneo FROM Inscripcion
    GROUP BY id_torneo
    HAVING COUNT(id_equipo) < 3
);

-- 16
DELETE FROM Jugador
WHERE id_jugador NOT IN (
    SELECT id_jugador
    FROM JugadorEquipo
);

-- 14
UPDATE Videojuego
SET nombre = CONCAT("[Popular] ", nombre)
WHERE id_videojuego IN (
    SELECT id_videojuego FROM Torneo
    GROUP BY id_videojuego 
    HAVING COUNT(*) > 2
);


--
