IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.HASHBYTES_VARCHAR') AND type = N'FN')
  DROP FUNCTION dbo.HASHBYTES_VARCHAR;
GO

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

/******************************************************************************************************************************
** Procedure Name: HASHBYTES_VARCHAR
**
** Description:  This user defined function will generate a data hash based on an inputted hashing algorithm
**               and string value.
**
** Revision History:      
** ----------------------------------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ----------------------------------------------------------------------------------------------------------------------------
** 09/13/2016    Windsor     Baselined from v5.0 function. 
**
******************************************************************************************************************************/
CREATE FUNCTION dbo.HASHBYTES_VARCHAR ( @p_algorithm VARCHAR(04)
                                      , @p_string_input VARCHAR(MAX)) 

RETURNS VARCHAR(100)

AS

BEGIN

  DECLARE @v_output_text AS VARCHAR(200);
  DECLARE @v_hashbytes_binary AS VARBINARY(8000);

  SET @v_hashbytes_binary = HASHBYTES(@p_algorithm,@p_string_input);

  SELECT @v_output_text = CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:column("bin")))', 'VARCHAR(MAX)') 
    FROM ( SELECT @v_hashbytes_binary AS bin ) AS bin_sql_server_temp;
     
  RETURN @v_output_text ; 
   
END;
GO