 DELIMITER //
CREATE PROCEDURE CancelBooking (IN id INT)
BEGIN
	START TRANSACTION;
    SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE BookingID = id;
    IF ISNULL(@r) THEN
    	SELECT CONCAT("Booking  ", id, " does not exist") AS "Result";
	ELSE
    	DELETE FROM bookings
        WHERE BookingID = id;
        COMMIT;
        SELECT CONCAT("Booking ", id, " calcelled") AS "Confirmation";
    END IF;
END //
DELIMITER ;