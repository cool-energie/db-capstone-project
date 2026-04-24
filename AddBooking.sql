DELIMITER //
CREATE PROCEDURE AddBooking (IN id INT, IN customer_id INT, IN tabNO INT, IN dat DATETIME)
BEGIN
	START TRANSACTION;
    SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE BookingID = id;
    IF ISNULL(@r) THEN
    	INSERT INTO bookings (BookingID, CustomerID, TableNo, BookingDate)
        VALUES (id, customer_id, tabNo, dat);
        COMMIT;
        SELECT "New booking added" AS "Confirmation";
	ELSE
    	SELECT CONCAT("Booking  ", id, " already exist - booking cancelled") AS "Booking Status";
    END IF;
END //
DELIMITER ;
