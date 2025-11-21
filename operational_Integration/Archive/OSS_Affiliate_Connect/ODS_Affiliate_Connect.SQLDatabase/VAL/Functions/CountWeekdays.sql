CREATE FUNCTION [VAL].[CountWeekdays]
(
    @from DATE,
    @until DATE
)
RETURNS NVARCHAR(255)
AS
BEGIN
    RETURN 'This is a simplified function result'
END

GO

