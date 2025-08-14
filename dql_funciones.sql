 --   • TotalGastoCliente(ClienteID, Anio): Calcula el gasto total de un cliente en un año específico. 
DELIMITER //
CREATE FUNCTION fn_TotalGastoCliente(ClienteID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC 
BEGIN 	 
	 
	 DECLARE Precio DECIMAL(10,2);
	
 	 SELECT SUM(total) INTO Precio
 	 FROM Invoice i
 	 WHERE CustomerId = ClienteID;
 	
 	RETURN (Precio);
END //
DELIMITER ;
SELECT fn_TotalGastoCliente(1) as GastoTotal;
 --   • PromedioPrecioPorAlbum(AlbumID): Retorna el precio promedio de las canciones de un álbum.
 --   • DuracionTotalPorGenero(GeneroID): Calcula la duración total de todas las canciones vendidas de un género específico.
 --   • DescuentoPorFrecuencia(ClienteID): Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.
 --  • VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.