/*
Copyright (c) 2012, The Environmental Council of the States (ECOS)
All rights reserved.
 
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
 
 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 * Neither the name of the ECOS nor the names of its contributors may
   be used to endorse or promote products derived from this software
   without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.GET_LIMIT_SET_MONTHS') AND type = N'FN')
DROP FUNCTION dbo.GET_LIMIT_SET_MONTHS
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.GET_LIMIT_MONTHS') AND type = N'FN')
DROP FUNCTION dbo.GET_LIMIT_MONTHS
GO
/*************************************************************************************************
** ObjectName: GET_LIMIT_MONTHS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This function searches the ics_mn_lmt_applies table and returns a 12-character 
**               string representing the 12 months that a limit is in effect.
**
** Revision History:
** ------------------------------------------------------------------------------------------------
**  Date        Name        Description
** ------------------------------------------------------------------------------------------------
**  12/21/2012  Windsor     Created 
**  12/26/2012  Windsor     Renamed function from GET_LIMIT_SET_MONTHS to GET_LIMIT_MONTHS
**
***************************************************************************************************/
CREATE FUNCTION dbo.GET_LIMIT_MONTHS ( @p_ics_lmt_id VARCHAR(36)) 


RETURNS VARCHAR(12)

AS

BEGIN

DECLARE @List varchar(100)
DECLARE @YNList varchar(12)

SELECT @List = COALESCE(@List + ',', '') + mn_lmt_applies
FROM ics_mn_lmt_applies WHERE ics_lmt_id = @p_ics_lmt_id

SELECT @YNList = CASE 
                     WHEN CHARINDEX('ALL',@List) > 0 THEN 'YYYYYYYYYYYY'
                 ELSE
                     CASE WHEN CHARINDEX('JAN',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('FEB',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('MAR',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('APR',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('MAY',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('JUN',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('JUL',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('AUG',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('SEP',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('OCT',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('NOV',@List) > 0 THEN 'Y' ELSE 'N' END
                   + CASE WHEN CHARINDEX('DEC',@List) > 0 THEN 'Y' ELSE 'N' END
                 END

return @YNList
   
END;