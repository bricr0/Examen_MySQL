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
DELIMITER //
CREATE FUNCTION PromedioPrecioPorAlbum(album_id INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE avg_price DECIMAL(10,2);
    
    SELECT AVG(UnitPrice) INTO avg_price
    FROM Track
    WHERE AlbumId = album_id;
    
    RETURN IFNULL(avg_price, 0);
END //
DELIMITER ;
SELECT PromedioPrecioPorAlbum(1);
 --   • DuracionTotalPorGenero(GeneroID): Calcula la duración total de todas las canciones vendidas de un género específico.
 DELIMITER //
CREATE FUNCTION DuracionTotalPorGenero(genero_id INT) 
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_milliseconds INT;
    DECLARE total_minutes INT;

    SELECT SUM(T.Milliseconds) INTO total_milliseconds
    FROM Track T
    WHERE T.GenreId = genero_id;

    SET total_minutes = total_milliseconds / 60000;
    
    RETURN IFNULL(total_minutes, 0);
END //
DELIMITER ;
SELECT DuracionTotalPorGenero(2);
 --   • DescuentoPorFrecuencia(ClienteID): Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.
DELIMITER //
CREATE FUNCTION DescuentoPorFrecuencia(cliente_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE purchase_count INT;
    DECLARE discount DECIMAL(5,2);

    SELECT COUNT(*) INTO purchase_count
    FROM Invoice
    WHERE CustomerId = cliente_id
    AND InvoiceDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR);

    IF purchase_count >= 20 THEN
        SET discount = 15.00; 
    ELSEIF purchase_count >= 10 THEN
        SET discount = 10.00; 
    ELSEIF purchase_count >= 5 THEN
        SET discount = 5.00; 
    ELSE
        SET discount = 0.00; 
    END IF;
    
    RETURN discount;
END //
DELIMITER ;
SELECT DescuentoPorFrecuencia(1);
 --  • VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.
 DELIMITER //
CREATE FUNCTION VerificarClienteVIP(cliente_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_spent DECIMAL(10,2);
    DECLARE es_vip BOOLEAN;

    SELECT SUM(Total) INTO total_spent
    FROM Invoice
    WHERE CustomerId = cliente_id
    AND InvoiceDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR);

    SET es_vip = IF(total_spent >= 1000, TRUE, FALSE);
    
    RETURN es_vip;
END //
DELIMITER ;
SELECT VerificarClienteVIP(1);