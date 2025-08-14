
--     • ReporteVentasMensual: Genera un informe mensual de ventas y lo almacena automáticamente.
--    • ActualizarSaldosCliente: Actualiza los saldos de cuenta de clientes al final de cada mes.
--    • AlertaAlbumNoVendidoAnual: Envía una alerta cuando un álbum no ha registrado ventas en el último año.
--    • LimpiarAuditoriaCada6Meses: Borra los registros antiguos de auditoría cada seis meses.
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