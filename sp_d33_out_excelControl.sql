USE master
GO

/*- ================================================================================
-- Author:		SWKim, Actuarial Controlling Dept.
-- Create date: 2012.07.12
-- Description:	Excel controlling spreadsheets via ADODB 
   (http://www.simple-talk.com/sql/t-sql-programming/sql-server-excel-workbench/)
-- ================================================================================= */
IF OBJECT_ID ('[dbo].[sp_d33_out_excelcontrol]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[sp_d33_out_excelcontrol];
GO

CREATE PROCEDURE sp_d33_out_excelcontrol

@DDL VARCHAR(max), 

@DataSource VARCHAR(max), 

@Worksheet VARCHAR(max)=NULL, 

@ConnectionString VARCHAR(255) 

    = 'Provider=Microsoft.Jet.OLEDB.4.0; 

Data Source=%DataSource; 

Extended Properties=Excel 8.0' 

AS 

DECLARE 

    @objExcel INT, 
    @hr INT, 
    @command VARCHAR(max), 
    @strErrorMessage VARCHAR(max), 
    @objErrorObject INT, 
    @objConnection INT, 
    @bucket INT    

set @hr =0 ;

SELECT @ConnectionString 

    =REPLACE (@ConnectionString, '%DataSource', @DataSource) 

IF @Worksheet IS NOT NULL 

    SELECT @DDL=REPLACE(@DDL,'%worksheet',@Worksheet) 

 

SELECT @strErrorMessage='Making ADODB connection ', 

            @objErrorObject=NULL 

EXEC @hr=sp_OACreate 'ADODB.Connection', @objconnection OUT ,5
print('@hr1')    
print(convert(varbinary(4),@HR))
print('@hr1 end')
IF @hr=0 

    SELECT @strErrorMessage='Assigning ConnectionString property "' 

            + @ConnectionString + '"', 

            @objErrorObject=@objconnection 

IF @hr=0 EXEC @hr=sp_OASetProperty @objconnection, 

            'ConnectionString', @ConnectionString 

IF @hr=0 SELECT @strErrorMessage 

        ='Opening Connection to XLS, for file Create or Append' 

IF @hr=0 EXEC @hr=sp_OAMethod @objconnection, 'Open'

IF @hr=0 SELECT @strErrorMessage 

        ='Executing DDL "'+@DDL+'"' 

IF @hr=0 EXEC @hr=sp_OAMethod @objconnection, 'Execute', 

        @Bucket out , @DDL 

IF @hr<>0 

    BEGIN 

    DECLARE 

        @Source VARCHAR(max), 

        @Description VARCHAR(max), 

        @Helpfile VARCHAR(255), 

        @HelpID INT 
    

    EXECUTE sp_OAGetErrorInfo @objErrorObject, @source output, 

        @Description output,@Helpfile output,@HelpID output 

    SELECT @strErrorMessage='Error whilst ' 

        +COALESCE(@strErrorMessage,'doing something')+', Description :' 

        +COALESCE(@Description,'')   
                 
    RAISERROR (@strErrorMessage,16,1) 

    END 
print('@hr2')    
print(convert(varbinary(4),@HR))
print('@hr2 end')
EXEC @hr=sp_OADestroy @objconnection 
go


