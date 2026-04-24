 DELIMITER //
CREATE PROCEDURE UpdateBooking (IN id INT, IN dat DATETIME)
BEGIN
	START TRANSACTION;
    SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE BookingID = id;
    IF ISNULL(@r) THEN
    	SELECT CONCAT("Booking  ", id, " does not exist") AS "Result";
	ELSE
    	UPDATE bookings
        SET BookingDate = dat
        WHERE BookingID = id;
        COMMIT;
        SELECT "Booking updated" AS "Confirmation";
    END IF;
END //
DELIMITER ;
