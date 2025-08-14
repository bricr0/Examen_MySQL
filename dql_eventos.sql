
--     • ReporteVentasMensual: Genera un informe mensual de ventas y lo almacena automáticamente.
--    • ActualizarSaldosCliente: Actualiza los saldos de cuenta de clientes al final de cada mes.
--    • AlertaAlbumNoVendidoAnual: Envía una alerta cuando un álbum no ha registrado ventas en el último año.
DELIMITER //
CREATE EVENT AlertaAlbumNoVendidoAnual
ON SCHEDULE EVERY 1 YEAR
STARTS TIMESTAMP(DATE_FORMAT(DATE_ADD(CURRENT_DATE(), INTERVAL 1 YEAR))
DO
BEGIN
    UPDATE Album a
    SET a.Title = CONCAT(a.Title, ' [SIN VENTAS RECIENTES]')
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Track t
        JOIN InvoiceLine il ON t.TrackId = il.TrackId
        JOIN Invoice i ON il.InvoiceId = i.InvoiceId
        WHERE t.AlbumId = a.AlbumId
        AND i.InvoiceDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
    );
    UPDATE Employee
    SET Fax = CONCAT(IFNULL(Fax, ''), ' | Alertas: ',
                    (SELECT COUNT(*) 
                     FROM Album a
                     WHERE NOT EXISTS (
                         SELECT 1 
                         FROM Track t
                         JOIN InvoiceLine il ON t.TrackId = il.TrackId
                         JOIN Invoice i ON il.InvoiceId = i.InvoiceId
                         WHERE t.AlbumId = a.AlbumId
                         AND i.InvoiceDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
                     )),
                    ' álbumes sin ventas en el último año. Verificar.')
    WHERE Title LIKE '%Manager%' OR Title LIKE '%Supervisor%';
END //
DELIMITER ;
--    • LimpiarAuditoriaCada6Meses: Borra los registros antiguos de auditoría cada seis meses.
DELIMITER //
CREATE EVENT LimpiarAuditoriaCada6Meses
ON SCHEDULE EVERY 6 MONTH
STARTS TIMESTAMP(DATE_FORMAT(DATE_ADD(CURRENT_DATE(), INTERVAL 6 MONTH))
DO
BEGIN
    UPDATE Customer
    SET Company = NULL
    WHERE Company LIKE '%Modificado%'
    AND CustomerId IN (
        SELECT CustomerId 
        FROM Invoice 
        GROUP BY CustomerId
        HAVING MAX(InvoiceDate) < DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
    );
    UPDATE Track
    SET Composer = REGEXP_REPLACE(Composer, '\\| Precio cambiado.*', '')
    WHERE Composer LIKE '%Precio cambiado%';
END //
DELIMITER ;
--    • ActualizarListaDeGenerosPopulares: Actualiza la lista de géneros más vendidos al final de cada mes.
DELIMITER //
CREATE EVENT ev_ReporteVentasMensual 
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
	 	SELECT g.Name as 'Genero', SUM(UniPrice) as 'Vendidos'
 		FROM Genre g
 		JOIN Track t on t.GenreId = g.GenreId
 		GROUP BY Genero
 		ORDER BY Vendidos DESC;
END //
DELIMITER ;