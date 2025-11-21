

create function [dbo].[fnSprintf] (@s varchar(8000), @params varchar(8000), @separator char(1) = ',')
returns varchar(8000)
as
begin
declare @p varchar(8000)

set @params = @params + @separator
while not @params = ''
begin
    set @p = left(@params+@separator, charindex(@separator, @params)-1)
    set @s = STUFF(@s, charindex('%s', @s), 2, @p)
    set @params = substring(@params, len(@p)+2, 8000)
end
return @s
end

GO

