DELIMITER //
CREATE PROCEDURE CheckBooking (IN dat DATETIME, IN tabNo INT)
BEGIN
	SET @r = NULL;
	SELECT BookingID INTO @r FROM bookings WHERE DATE(BookingDate) = DATE(dat) AND TableNo = tabNo LIMIT 1;
	SELECT 
    IF(ISNULL(@r), CONCAT("Table ", tabNo, " is free"), CONCAT("Table ", tabNo, " is already booked")) AS "Booking Status";
END //
DELIMITER ;