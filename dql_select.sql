 --  1 • Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.
 		SELECT e.FirstName as 'Empleado', SUM(total) as 'Mayor Cantidad'
 		FROM Employee e
 		JOIN Customer c on e.EmployeeId = c.SupportRepId
 		JOIN Invoice i on c.CustomerId = i.CustomerId
 		GROUP BY Empleado
 		LIMIT 1;
 -- 2  • Lista los cinco artistas con más canciones vendidas en el último año.
 		SELECT a.Name as 'Artista', SUM(UnitPrice) as Vendidas
 		FROM Artist a
 		JOIN Album a2 on a.ArtistId = a2.ArtistId
 		JOIN Track t on t.AlbumId = a2.AlbumId
 		GROUP BY Artista
 		ORDER BY Vendidas DESC
		LIMIT 5;
 --  3 • Obtén el total de ventas y la cantidad de canciones vendidas por país.
		SELECT i.BillingCountry  as 'Ciudad', SUM(total) as TotaldeVentas ,SUM(UnitPrice) as CancionesVendidas
 		FROM Invoice i
 		JOIN InvoiceLine il on il.InvoiceId = i.InvoiceId
 		GROUP BY Ciudad;
 --  4 • Calcula el número total de clientes que realizaron compras por cada género en un mes específico.
 		SELECT g.Name as 'Genero', SUM(CustomerId) as 'Clientes'
 		FROM Genre g
 		JOIN Track t on t.GenreId = g.GenreId
 		JOIN InvoiceLine il on il.TrackId = t.TrackId 
 		JOIN Invoice i on i.InvoiceId = il.InvoiceId 
 		GROUP BY Genero
 		ORDER BY Clientes DESC;
--   5 • Encuentra a los clientes que han comprado todas las canciones de un mismo álbum.
 --  6 • Lista los tres países con mayores ventas durante el último semestre.
 		SELECT i.BillingCountry  as 'Ciudad', SUM(total) as TotaldeVentas
 		FROM Invoice i
 		JOIN InvoiceLine il on il.InvoiceId = i.InvoiceId
 		GROUP BY Ciudad
 		LIMIT 3;
 -- 7  • Muestra los cinco géneros menos vendidos en el último año.
 		SELECT g.Name as 'Genero', SUM(UnitPrice) as 'Vendidos'
 		FROM Genre g
 		JOIN Track t on t.GenreId = g.GenreId
 		GROUP BY Genero
 		ORDER BY Vendidos ASC
 		LIMIT 5;
  -- 8 • Calcula el promedio de edad de los clientes al momento de su primera compra.		
 --  9 • Encuentra los cinco empleados que realizaron más ventas de Rock.
 		SELECT e.FirstName as 'Empleados', SUM(c.CustomerId) as 'Clientes'
 		FROM Genre g
 		JOIN Track t on t.GenreId = g.GenreId
 		JOIN InvoiceLine il on il.TrackId = t.TrackId 
 		JOIN Invoice i on i.InvoiceId = il.InvoiceId 
 		JOIN Customer c on c.CustomerId = i.CustomerId
 		JOIN Employee e on e.EmployeeId = c.SupportRepId
  		WHERE g.Name = 'Rock'
 		GROUP BY Empleados
 		ORDER BY Clientes DESC;
 -- 10  • Genera un informe de los clientes con más compras recurrentes. 
 --  11 • Calcula el precio promedio de venta por género.
 		SELECT g.Name as 'Genero', SUM(UnitPrice) as 'Vendidos'
 		FROM Genre g
 		JOIN Track t on t.GenreId = g.GenreId
 		GROUP BY Genero
 		ORDER BY Vendidos DESC;
 --  12 • Lista las cinco canciones más largas vendidas en el último año.
 	SELECT t.Name as 'Cancion', t.Milliseconds as 'Duracion'
 	FROM Track t
 	ORDER BY Duracion DESC
 	LIMIT 5;
 	
 --  13 • Muestra los clientes que compraron más canciones de Jazz.
  		SELECT g.Name as 'Genero', SUM(CustomerId) as 'Clientes'
 		FROM Genre g
 		JOIN Track t on t.GenreId = g.GenreId
 		JOIN InvoiceLine il on il.TrackId = t.TrackId 
 		JOIN Invoice i on i.InvoiceId = il.InvoiceId 
 		WHERE g.Name = 'Jazz'
 		GROUP BY Genero
 		ORDER BY Clientes DESC;
 --  14 • Encuentra la cantidad total de minutos comprados por cada cliente en el último mes.
 --  15 • Muestra el número de ventas diarias de canciones en cada mes del último trimestre.
 --  16 • Calcula el total de ventas por cada vendedor en el último semestre.
 	 	SELECT e.FirstName as 'Empleado', SUM(total) as 'Mayor Cantidad'
 		FROM Employee e
 		JOIN Customer c on e.EmployeeId = c.SupportRepId
 		JOIN Invoice i on c.CustomerId = i.CustomerId
 		GROUP BY Empleado;
 --  17 • Encuentra el cliente que ha realizado la compra más cara en el último año.
 	SELECT c.FirstName as 'Cliente', SUM(total) as 'Precio'    
 	FROM Customer c
 	JOIN Invoice i on c.CustomerId = i.InvoiceId
 	GROUP BY Cliente
 	ORDER BY Precio DESC
 	LIMIT 1;
 -- 18 • Lista los cinco álbumes con más canciones vendidas durante los últimos tres meses.
 --  19 • Obtén la cantidad de canciones vendidas por cada género en el último mes.