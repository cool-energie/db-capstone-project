DELIMITER //
CREATE PROCEDURE AddValidBooking (IN tabNo INT, IN dat DATETIME)
BEGIN
	START TRANSACTION;
    SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE DATE(BookingDate) = DATE(dat) AND TableNo = tabNo LIMIT 1;
    IF ISNULL(@r) THEN
    	INSERT INTO bookings (TableNo, BookingDate)
        VALUES (tabNo, dat);
        COMMIT;
        SELECT CONCAT("Booked saved on table No ", tabNo) AS "Booking Status";
	ELSE
    	SELECT CONCAT("Table ", tabNo, " is already booked - booking cancelled") AS "Booking Status";
    END IF;
END //
DELIMITER ;
