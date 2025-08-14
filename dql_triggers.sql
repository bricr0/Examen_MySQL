-- Triggers
--   • ActualizarTotalVentasEmpleado: Al realizar una venta, actualiza el total de ventas acumuladas por el empleado correspondiente.
DELIMITER //
CREATE TRIGGER ActualizarTotalVentasEmpleado
AFTER INSERT ON `Invoice`
FOR EACH ROW
BEGIN
    DECLARE empleado_id INT;

    SELECT SupportRepId INTO empleado_id FROM Customer WHERE CustomerId = NEW.CustomerId;

    IF empleado_id IS NOT NULL THEN
        UPDATE Employee 
        SET Title = CONCAT('Ventas totales: $', 
                          IFNULL((
                            SELECT SUM(Total) 
                            FROM Invoice 
                            WHERE CustomerId IN (
                              SELECT CustomerId 
                              FROM Customer 
                              WHERE SupportRepId = empleado_id
                            )
                          ), 0))
        WHERE EmployeeId = empleado_id;
    END IF;
END //
DELIMITER ;
--    • AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.
DELIMITER //
CREATE TRIGGER AuditarActualizacionCliente
AFTER UPDATE ON `Customer`
FOR EACH ROW
BEGIN
    IF OLD.FirstName != NEW.FirstName OR OLD.LastName != NEW.LastName OR OLD.Email != NEW.Email THEN
        UPDATE Customer 
        SET Company = CONCAT(IFNULL(Company, ''), 
                   ' | Modificado: ', NOW(), 
                   ' por ', USER(), 
                   ' (Antes: ', OLD.FirstName, ' ', OLD.LastName, ' ', OLD.Email, ')')
        WHERE CustomerId = NEW.CustomerId;
    END IF;
END //
DELIMITER ;
--    • RegistrarHistorialPrecioCancion: Guarda el historial de cambios en el precio de las canciones.
DELIMITER //
CREATE TRIGGER RegistrarHistorialPrecioCancion
AFTER UPDATE ON `Track`
FOR EACH ROW
BEGIN
    IF OLD.UnitPrice != NEW.UnitPrice THEN
        UPDATE Track 
        SET Composer = CONCAT(IFNULL(Composer, ''), 
                             ' | Precio cambiado de ', OLD.UnitPrice, 
                             ' a ', NEW.UnitPrice, ' el ', NOW())
        WHERE TrackId = NEW.TrackId;
    END IF;
END //
DELIMITER ;
--    • NotificarCancelacionVenta: Registra una notificación cuando se elimina un registro de venta.
DELIMITER //
CREATE TRIGGER NotificarCancelacionVenta
AFTER DELETE ON `Invoice`
FOR EACH ROW
BEGIN
    -- Registrar la notificación en la tabla Employee (usando el campo Fax como ejemplo)
    DECLARE empleado_id INT;
    
    SELECT SupportRepId INTO empleado_id FROM Customer WHERE CustomerId = OLD.CustomerId;
    
    IF empleado_id IS NOT NULL THEN
        UPDATE Employee
        SET Fax = CONCAT(IFNULL(Fax, ''), 
                  ' | Venta cancelada: ', OLD.InvoiceId, 
                  ' por $', OLD.Total, ' el ', NOW())
        WHERE EmployeeId = empleado_id;
    END IF;
END //
DELIMITER ;
--    • RestringirCompraConSaldoDeudor: Evita que un cliente con saldo deudor realice nuevas compras.
DELIMITER //
CREATE TRIGGER RestringirCompraConSaldoDeudor
BEFORE INSERT ON `Invoice`
FOR EACH ROW
BEGIN
    DECLARE total_deuda NUMERIC(10,2);

    SELECT SUM(Total) INTO total_deuda 
    FROM Invoice 
    WHERE CustomerId = NEW.CustomerId AND Total > 0;

    IF total_deuda > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente tiene saldo deudor y no puede realizar nuevas compras';
    END IF;
END //
DELIMITER ;