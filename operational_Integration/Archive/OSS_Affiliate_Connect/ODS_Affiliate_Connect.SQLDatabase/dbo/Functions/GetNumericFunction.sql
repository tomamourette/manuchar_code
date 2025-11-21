
CREATE FUNCTION [dbo].[GetNumericFunction]
(@Data VARCHAR(100))

Returns VARCHAR(100)

AS BEGIN

      DECLARE @Letter INT

      SET @Letter =PATINDEX('%[^0-Z]%',@Data)

      BEGIN

      WHILE @Letter>0

      BEGIN

      SET @Data =STUFF(@Data,@Letter,1,'')

      SET @Letter =PATINDEX('%[^0-Z]%',@Data)

      END

      END

      RETURN @Data

END

GO

