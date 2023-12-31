USE [master]
GO
/****** Object:  Database [ISEE_DEV2]    Script Date: 21/09/2566 22:51:02 ******/
CREATE DATABASE [ISEE_DEV2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ISEE', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ISEE.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ISEE_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ISEE_log.ldf' , SIZE = 139264KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ISEE_DEV2] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ISEE_DEV2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ISEE_DEV2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET ARITHABORT OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ISEE_DEV2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ISEE_DEV2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ISEE_DEV2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ISEE_DEV2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ISEE_DEV2] SET  MULTI_USER 
GO
ALTER DATABASE [ISEE_DEV2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ISEE_DEV2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ISEE_DEV2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ISEE_DEV2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ISEE_DEV2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ISEE_DEV2] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [ISEE_DEV2] SET QUERY_STORE = OFF
GO
USE [ISEE_DEV2]
GO
USE [ISEE_DEV2]
GO
/****** Object:  Sequence [dbo].[image_id]    Script Date: 21/09/2566 22:51:03 ******/
CREATE SEQUENCE [dbo].[image_id] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO
/****** Object:  UserDefinedFunction [dbo].[fn_cleansep]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_cleansep] 
(
	@value VARCHAR(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @max_emp INT
    SELECT @max_emp=MAX(user_id) FROM tbm_employee
	SET @value=REPLACE(REPLACE(REPLACE(@value,'.','|'),'/','|'),',','|')
	DECLARE @result VARCHAR(50)
	IF (ISNUMERIC(@value)=1)
			IF  (@value>@max_emp)
			BEGIN
				DECLARE @i INT=1
				WHILE(@i<=LEN(@value))
				BEGIN
					IF @i=LEN(@value)
						SET @result=CONCAT(@result,SUBSTRING(@value,@i,1))
					ELSE                
						SET @result=CONCAT(@result,SUBSTRING(@value,@i,1),',')
				
					SET @i=@i+1
				END
			END
			ELSE
				SET @result=@value
	ELSE
			SET @result=@value
 
 
 RETURN @result 
END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_countholiday]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[fn_countholiday]
(
		@date1 date,
		@date2 date
)
RETURNS  int
AS
BEGIN

	DECLARE @result int
	select @result=COUNT(1) from tbm_holiday  
	where [DATE] between @date1 and @date2

	RETURN @result

END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_adjustpart]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION  [dbo].[fn_get_adjustpart] 
(
	@part_id INT,
	@adj_id int
)
RETURNS int
AS
BEGIN
		DECLARE @adj_value INT
        SELECT @adj_value=ISNULL(SUM(adj_part_value),0)
		FROM tbt_adj_sparepart 
		WHERE part_id=@part_id AND adj_id=@adj_id


		RETURN ISNULL(@adj_value,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_baht_thai]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_get_baht_thai] (@dec_Baht decimal(14,4))
RETURNS varchar(1000)
AS
BEGIN
			
	        DECLARE @RoundBaht varchar(1000)
	        SET @RoundBaht = CONVERT(varchar(20),ROUND(@dec_Baht,2))
	        SET @RoundBaht = LEFT(@RoundBaht,LEN(@RoundBaht)-2)
            DECLARE @str_Baht varchar(1000)
            SET @str_Baht = REPLACE(@RoundBaht,',','');
            IF (@str_Baht = '0.00')
            BEGIN
				return 'ศูนย์บาทศูนย์สตางค์'
            END
            ELSE
            BEGIN
				DECLARE @dot_pos int
				SET @dot_pos = CHARINDEX('.',@str_Baht)
				DECLARE @arr_BahtNo0 varchar(1000)
				SET @arr_BahtNo0 = SUBSTRING(@str_Baht,1,@dot_pos-1)
				DECLARE @arr_BahtNo1 varchar(1000)
				SET @arr_BahtNo1 = SUBSTRING(@str_Baht,@dot_pos+1,LEN(@str_Baht)-@dot_pos)
				
				IF (@arr_BahtNo0 <> '')
				BEGIN
					SET @str_Baht = dbo.fn_initial_money(@arr_BahtNo0) + 'บาท';
				END
			
				IF (@arr_BahtNo1 <> '')
				BEGIN
					IF (@arr_BahtNo1 = '00')
					BEGIN
						SET @str_Baht = @str_Baht + 'ถ้วน'
					END
					ELSE
					BEGIN
						IF (SUBSTRING(@arr_BahtNo1,1,1) = '0') SET @arr_BahtNo1 = RIGHT(@arr_BahtNo1,1)
						SET @str_Baht = @str_Baht + dbo.fn_initial_money(@arr_BahtNo1) + 'สตางค์';
					END
				END
            END	
			
	RETURN @str_Baht

END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_baht_thai_unit]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fn_get_baht_thai_unit] 
(
	@valpos INT
)
RETURNS varchar(500)
AS
BEGIN
	DECLARE @val VARCHAR(500)
	SET @val = ''

	IF (@valpos = 2) SET @val = 'สิบ'
	ELSE IF (@valpos = 3) SET @val = 'ร้อย'
	ELSE IF (@valpos = 4) SET @val = 'พัน'
	ELSE IF (@valpos = 5) SET @val = 'หมื่น'
	ELSE IF (@valpos = 6) SET @val = 'แสน'
	
	RETURN @val
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_baht_thai_value]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fn_get_baht_thai_value] 
(
	@valInt int
	,@valpos int
	,@valLen int
)
RETURNS VARCHAR(500)
AS
BEGIN
	DECLARE @val VARCHAR(500)
	SET @val = ''

	IF (@valInt = 1)
	BEGIN
		IF (@valpos = 1 AND @valLen > 1) SET @val = 'เอ็ด'
		ELSE IF (@valpos = 2) SET @val = ''
		ELSE SET @val = 'หนึ่ง'
	END
	ELSE IF (@valInt = 2)
	BEGIN
		IF (@valpos = 2) SET @val = 'ยี่'
		ELSE SET @val = 'สอง'
	END
	ELSE IF (@valInt = 3) SET @val = 'สาม'
	ELSE IF (@valInt = 4) SET @val = 'สี่'
	ELSE IF (@valInt = 5) SET @val = 'ห้า'
	ELSE IF (@valInt = 6) SET @val = 'หก'
	ELSE IF (@valInt = 7) SET @val = 'เจ็ด'
	ELSE IF (@valInt = 8) SET @val = 'แปด'
	ELSE IF (@valInt = 9) SET @val = 'เก้า'

	RETURN @val
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_leave_data]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_leave_data]
(
	@user_id INT,
	@start_date DATETIME=NULL,
	@stop_date	DATETIME=NULL,
	@leave_type VARCHAR(2)=NULL
)
RETURNS DECIMAL(10,1)
AS
BEGIN
			DECLARE @nol DECIMAL(10,1)
			SELECT 
				 @nol=SUM(CASE WHEN leave_path<>0 THEN 
					CONVERT(DECIMAL(10,1),(DATEDIFF(DAY,leave_date_from,leave_date_to)+1))-0.5 
				 ELSE
					CONVERT(DECIMAL(10,1),(DATEDIFF(DAY,leave_date_from,leave_date_to)+1))
				 END
                 )-SUM(dbo.fn_CountHoliday(leave_date_from,leave_date_to))
			FROM tbt_leave
			WHERE emp_id = @user_id
				  AND (
						  (
							  @start_date IS  NULL
							  OR leave_date_from >= @start_date
						  )
						  AND (
								  @stop_date IS  NULL
								  OR leave_date_to <= @stop_date
							  )
					  ) AND cancel_date IS  NULL
			AND (@leave_type IS NULL OR leave_type=@leave_type)
RETURN ISNULL(@nol,0.0)
END

---select dbo.fn_get_leave_data(1,'2022-12-01','2022-12-31',null)







GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_onhand]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_get_onhand]
(
      @part_id INT
	  ,@job_id VARCHAR(10)=NULL
)
RETURNS int
AS
BEGIN
declare @onhand int=0
declare @t_part int=0
DECLARE @last_log DATETIME=NULL
declare @onhand_log int=0

-----หาจากสูตร log ตัวสุดท้าย -------
declare @log_data table 
(
	log_id bigint,
	part_id int,
	parent_id int, 
	part_value_old int,
	part_value_new int, 
	parent_value_old int, 
	parent_value_new int, 
	typelog int, 
	onhand int,
	type_name varchar(50),
	user_id int,
	create_date datetime,
	part_id_to int,
	change_value int,
	remain_onhand int,
	part_no varchar(50)

)
INSERT INTO @log_data
SELECT 
				l.log_id, 
				l.part_id, 
				l.parent_id, 
				l.part_value_old, 
				l.part_value_new, 
				l.parent_value_old, 
				l.parent_value_new, 
				l.typelog, 
				l.onhand, 
				--l.remark, 
				tl.type_name,
				l.user_id, 
				l.create_date, 
				l.part_id_to, 
				--isnull(l.part_value_new,0)-isnull(l.part_value_old,0) AS change_value, 
				--l.onhand+(isnull(l.part_value_new,0)-isnull(l.part_value_old,0)) 'remain_onhand',
				case when (l.part_value_old<0 and l.part_value_new>=0)  then  isnull(l.part_value_new,0)-isnull(l.part_value_old,0)-1 else  isnull(l.part_value_new,0)-isnull(l.part_value_old,0) end  AS change_value,
				(case when (l.part_value_old<0 and l.part_value_new>=0) then isnull(l.part_value_new,0)-isnull(l.part_value_old,0)-1 else  isnull(l.part_value_new,0)-isnull(l.part_value_old,0) end) + l.onhand as 'remain_onhand',

				sp.part_no
		FROM tbt_log_part l
			 LEFT JOIN tbm_sparepart sp ON sp.part_id=l.part_id
			 LEFT JOIN tbm_log_type tl ON tl.type_id=l.typelog
		where l.part_id=@part_id

if exists(select log_id from @log_data)
BEGIN

	select TOP 1 
			@onhand_log=remain_onhand,
			@last_log=create_date 
	FROM @log_data 
	ORDER by log_id DESC
END

;WITH 
  ADJ AS (
		SELECT part_id,SUM(adj_part_value) adj_part_value 
		FROM tbt_adj_sparepart
		GROUP BY part_id
),JOB AS (
		SELECT part_id,SUM(total) total 
		FROM tbt_job_part
		WHERE status=1 AND (@job_id IS NULL OR pjob_id NOT IN (@job_id))
		GROUP BY part_id
	)
,TFM AS (
	SELECT part_id,SUM(ABS(part_value_old-part_value_new)) total 
	FROM tbt_log_part l
	WHERE typelog=1
	GROUP BY part_id
	)
,TTM AS (
	SELECT parent_id,SUM(ABS(part_value_old-part_value_new)) total 
	FROM tbt_log_part l
	WHERE typelog=2
	GROUP BY parent_id
	)
,UPS AS (
SELECT part_id,SUM(part_value_new-part_value_old) total 
	FROM tbt_log_part l
	WHERE typelog=0
	GROUP BY part_id
),
Time_adj as (
	select part_id,max(create_date) 'Max_adj_time'
	from tbt_adj_sparepart 
	group by part_id
	having part_id=@part_id
),
Time_TFM as (
	SELECT part_id,max(create_date) 'Max_TFM_time' 
	FROM tbt_log_part l
	WHERE typelog=1
	GROUP BY part_id
	having part_id=@part_id
)
SELECT 
@onhand=(ISNULL(ups.total,0)+ISNULL(sp.part_value,0)+isnull(adj.adj_part_value,0))-ISNULL(jp.total,0),
--@t_part=(ISNULL(TFM.total,0)-ISNULL(TTM.total,0))
@t_part=CASE WHEN (T_adj.Max_adj_time>T_tfm.Max_TFM_time) THEN 0 
		ELSE (ISNULL(TFM.total,0)-ISNULL(TTM.total,0)) 
		END
--ISNULL(ups.total,0) 'update_stock',
--ISNULL(sp.part_value,0) 'จำนวนพาร์ท',
--ISNULL(adj.adj_part_value,0) 'ปรับ stock',
--ISNULL(jp.total,0),
--ISNULL(TFM.total,0) 'ย้ายจาก main',
--ISNULL(TTM.total,0) 'ย้ายกลับ main'
FROM tbm_sparepart sp
left join JOB jp on sp.part_id=jp.part_id 
left join ADJ adj on adj.part_id=sp.part_id
LEFT JOIN TTM ON sp.part_id=TTM.parent_id
LEFT JOIN TFM ON sp.part_id=TFM.part_id
LEFT JOIN UPS ON UPS.part_id=sp.part_id
LEFT JOIN Time_adj T_adj on T_adj.part_id=sp.part_id
LEFT JOIN Time_TFM T_tfm on T_tfm.part_id=sp.part_id

where sp.part_id=@part_id;

-- UPS(update spare part)  คือการ update stock เช่น fix ค่ามาตรงๆเรย โดยเช็คจาก tb_log where typelog=0 โดยเอา part(new) ลบ part(old) สัมพันธ์กับ adjust_type=0
-- TTM (transfer to main) คือการโยกอะไหล่จาก van กลับไปยัง mainstore โดยเช็คจาก tb_log where where typelog=1
-- TFM (transfer form main) คือการโยกอะไหล่จาก van กลับไปยัง mainstore โดยเช็คจาก tb_log where where typelog=2
-- ADJ_P(adjust part) คือการปรับค่า part ตรงๆ เช่น ปรับค่าเป็นเพิ่ม 1,ลด 1 ,เท่ารัยก็ได้ แบ่งประเภทตาม adj_type ถ้าเป็น 0 ควรจะมี log เกิดด้วย log_type=0
-- JOB (Job part) คืออะไหล่ที่มีการตัด job งานออกไป

---ถ้า adjust stock time (stockadj,stockin,stockout,stockfix) มากกว่า เวลา transfer part ต้องยึดตาม adjustime นั้นๆ
---@t_part คือจำนวนการโยกไปมาระหว่าง mainstore,van ต่างๆ 
---@on_hand คือจำนวน



IF (@onhand_log>=(@onhand-@t_part))
	SET @onhand=@onhand_log

if exists(select log_id from @log_data where typelog=0)
	set @onhand=@onhand_log

RETURN ISNULL(@onhand,0)


END





GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_orginal]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_orginal]
(
	@part_id int
)
RETURNS INT
AS
BEGIN
	DECLARE @location_id VARCHAR(3)=NULL
	DECLARE @to_main INT=NULL,@from_main INT=NULL,@org_main INT=NULL

SELECT @location_id=location_id,@org_main=part_value 
FROM tbm_sparepart WHERE part_id=@part_id

DECLARE @result INT =NULL
IF @location_id<>'L01'
BEGIN
		SELECT 
			@to_main=parent_value_new
		FROM tbt_log_part 
		WHERE part_id=@part_id AND typelog=2

		SELECT 
			@from_main=abs(part_value_old -part_value_new)
		FROM tbt_log_part 
		WHERE part_id_to=@part_id AND typelog=1
		
		SET @result=COALESCE(@from_main,@to_main,@org_main)
END
ELSE
BEGIN
		SELECT 
			@to_main=parent_value_new
		FROM tbt_log_part 
		WHERE part_id_to=@part_id AND typelog=2

		SELECT TOP 1
			@from_main=abs(part_value_old)
		FROM tbt_log_part 
		WHERE part_id=@part_id AND typelog=1
		ORDER BY log_id ASC
	
        SET @result=COALESCE(@to_main,@from_main,@org_main)

END
		
			RETURN @result
END





		
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_parent_part]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_parent_part] 
(
		@part_id int
)
RETURNS int
AS
BEGIN
	DECLARE @pp INT =NULL
	SELECT @pp=parent_id FROM tbm_sparepart WHERE part_id=@part_id
	RETURN @pp
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_price_item_on_job]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [dbo].[fn_get_price_item_on_job] 
(
	@job_id VARCHAR(10),
	@price_type INT=0
)
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE @price DECIMAL(10,2)

	SELECT  
		@price=ISNULL(jp.total,0) * ISNULL(CASE WHEN @price_type=0 THEN sp.sale_price ELSE sp.cost_price END,0.00)
	
	FROM tbt_job_part jp
	LEFT JOIN tbm_sparepart sp ON sp.part_id=jp.part_id
	WHERE jp.status=1 AND jp.pjob_id=@job_id
	RETURN ISNULL(@price,0.00)
END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_stockin]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_stockin]
(
	@part_id INT,
	@adj_id int
)
RETURNS int
AS
BEGIN
	DECLARE @stock_in INT=NULL
		SELECT @stock_in=SUM(ISNULL(adj_part_value,0)) 
		FROM tbt_adj_sparepart 
		WHERE adj_type=1 
		AND part_id=@part_id AND adj_id=@adj_id

		RETURN ISNULL(@stock_in,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_stockout]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_stockout]
(
	@part_id INT,
	@adj_id int
)
RETURNS int
AS
BEGIN
	DECLARE @stock_out INT=NULL,@job_stock_out INT=NULL
		SELECT @stock_out=SUM(ISNULL(adj_part_value,0)) 
		FROM tbt_adj_sparepart 
		WHERE adj_type=-1
		AND part_id=@part_id AND adj_id=@adj_id

		IF (@adj_id IS NULL) 
			 SET @stock_out=0

		SELECT @job_stock_out=SUM(ISNULL(total,0)) 
		FROM tbt_job_part 
		WHERE part_id=@part_id

		RETURN (ABS(@stock_out)+ISNULL(@job_stock_out,0))
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_initial_money]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_initial_money] 
(
	@value VARCHAR(1000)
)
RETURNS varchar(1000)
AS
BEGIN
			DECLARE @GenBahtToThai varchar(1000)
			DECLARE @_val varchar(1000)
			DECLARE @_len int
			DECLARE @i int
			SET @GenBahtToThai = ''
			SET @_len = LEN(@value)
			SET @i = 1
			WHILE @i <= LEN(@value)
			BEGIN
				IF (@_len > 0)
				BEGIN
					IF (@i = 7) 
					BEGIN
						SET @value = LEFT(@value,LEN(@value) - 6)
						SET @i  = 1
						SET @GenBahtToThai = 'ล้าน' + @GenBahtToThai
					END

					SET @_val = SUBSTRING(@value,@_len,1)
					IF (@_val <> '0')
					BEGIN
						SET @GenBahtToThai = dbo.fn_get_baht_thai_value(CONVERT(INT,@_val), @i, LEN(@value)) + dbo.fn_get_baht_thai_unit(@i) + @GenBahtToThai;
					END
				END

				SET @_len = @_len - 1
				SET @i = @i + 1
			END

	RETURN @GenBahtToThai

END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_pad_left]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_pad_left]
(
	@str_scr nvarchar(255) = ''
	, @number_pad int = 0
	, @chr_pad nvarchar(1) = '0'
)
RETURNS nvarchar(255)
AS
BEGIN
	
	-- Modify by Teerayut S. on 2012-03-21
	
	DECLARE @result_var nvarchar(255)
	
	IF LEN(@str_scr) > @number_pad
		SET @result_var = @str_scr;
	ELSE
		SET @result_var = REPLICATE(@chr_pad, @number_pad - len(@str_scr)) + @str_scr;
		
	RETURN @result_var;
	
	--##########################################
	--## Comment by Teerayut S. on 2012-03-21
	--##########################################
	--DECLARE @result_var nvarchar(255)
	--set @result_var = @str_scr
	
	--declare @len_scr int
	--set @len_scr = len(@str_scr)
	
	--while @len_scr < @number_pad
	--begin
		
	--	set @result_var = @chr_pad + @result_var
		
	--	set @len_scr = @len_scr + 1
	--end
	
	--RETURN @result_var

END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_pad_right]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_pad_right]
(
	@str_scr nvarchar(255) = ''
	, @number_pad int = 0
	, @chr_pad nvarchar(1) = '0'
)
RETURNS nvarchar(255)
AS
BEGIN
	
	-- Modify by Teerayut S. on 2012-03-21
	
	DECLARE @result_var nvarchar(255)
	
	IF LEN(@str_scr) > @number_pad
		SET @result_var = @str_scr;
	ELSE
		SET @result_var = @str_scr + REPLICATE(@chr_pad, @number_pad - len(@str_scr));
		
	RETURN @result_var;
	
	--##########################################
	--## Comment by Teerayut S. on 2012-03-21
	--##########################################	
	
	--DECLARE @result_var nvarchar(255)
	--set @result_var = @str_scr
	
	--declare @len_scr int
	--set @len_scr = len(@str_scr)
	
	--while @len_scr < @number_pad
	--begin
		
	--	set @result_var = @result_var + @chr_pad
		
	--	set @len_scr = @len_scr + 1
	--end
	
	--RETURN @result_var

END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Putarapong T.
-- Create date: 20101214 1100
-- Description:	Split string to table
-- =============================================
--DROP FUNCTION [dbo].[fn_Split]
create FUNCTION [dbo].[fn_Split] (@sep char(1), @string varchar(8000))
RETURNS @List TABLE (pn int, data VARCHAR(8000))
AS
BEGIN

DECLARE @pn int = 0
DECLARE @sItem VARCHAR(8000)

WHILE CHARINDEX(@sep,@string,0) <> 0

 BEGIN

 SELECT
  @pn = @pn + 1,
  
  @sItem=RTRIM(LTRIM(SUBSTRING(@string,1,CHARINDEX(@sep,@string,0)-1))),

  @string=RTRIM(LTRIM(SUBSTRING(@string,CHARINDEX(@sep,@string,0)+LEN(@sep),LEN(@string))))

 IF LEN(@sItem) > 0

  INSERT INTO @List SELECT @pn, @sItem

 END


IF LEN(@string) > 0

 INSERT INTO @List SELECT @pn+1, @string -- Put the last item in

RETURN;

END
GO
/****** Object:  Table [dbo].[tbt_adj_sparepart]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_adj_sparepart](
	[adj_id] [bigint] IDENTITY(1,1) NOT NULL,
	[part_id] [bigint] NULL,
	[part_no] [varchar](50) NULL,
	[adj_part_value] [int] NULL,
	[remark] [text] NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL,
	[cancel_date] [datetime] NULL,
	[cancel_by] [int] NULL,
	[cancel_reason] [varchar](500) NULL,
	[adj_type] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_sparepart]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_sparepart](
	[part_id] [bigint] IDENTITY(1,1) NOT NULL,
	[part_no] [varchar](50) NULL,
	[part_name] [varchar](100) NULL,
	[part_desc] [varchar](max) NULL,
	[part_type] [varchar](2) NULL,
	[cost_price] [decimal](10, 2) NULL,
	[sale_price] [decimal](10, 2) NULL,
	[unit_code] [varchar](50) NULL,
	[part_value] [int] NULL,
	[part_weight] [int] NULL,
	[minimum_value] [int] NULL,
	[maximum_value] [int] NULL,
	[location_id] [varchar](3) NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[cancel_date] [datetime] NULL,
	[cancel_by] [int] NULL,
	[cancel_reason] [varchar](500) NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL,
	[parent_id] [int] NULL,
	[ref_group] [varchar](50) NULL,
	[ref_other] [varchar](50) NULL,
 CONSTRAINT [PK_tbm_sparepart] PRIMARY KEY CLUSTERED 
(
	[part_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_log_part]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_log_part](
	[log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[part_id] [int] NULL,
	[parent_id] [int] NULL,
	[part_value_old] [int] NULL,
	[part_value_new] [int] NULL,
	[parent_value_old] [int] NULL,
	[parent_value_new] [int] NULL,
	[typelog] [int] NULL,
	[onhand] [int] NULL,
	[remark] [varchar](2000) NULL,
	[user_id] [int] NULL,
	[create_date] [datetime] NULL,
	[part_id_to] [int] NULL,
	[adj_id] [int] NULL,
 CONSTRAINT [PK_tbt_log] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_log_type]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_log_type](
	[type_id] [int] NULL,
	[type_name] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_employee]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_employee](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [varchar](20) NULL,
	[password] [varchar](500) NULL,
	[fullname] [varchar](255) NULL,
	[lastname] [varchar](255) NULL,
	[idcard] [varchar](13) NULL,
	[position] [varchar](2) NULL,
	[status] [int] NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL,
	[showstock] [int] NULL,
	[img_path] [varchar](500) NULL,
	[technician_code] [int] NULL,
	[sign_img] [image] NULL,
 CONSTRAINT [PK_tbm_employee] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_stock_type]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_stock_type](
	[type_id] [int] NULL,
	[type_name] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_movement]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_movement] 
(	
		@part_id int
)
RETURNS TABLE 
AS
RETURN 
(

				SELECT	adj.part_id,
							sp.part_no,
							sp.part_name,
							lt.type_name 'log_type',
							cfg.type_name AS Stock_type,
							l.onhand as onhand_prev,
							l.onhand+l.part_value_new as onhand_now,
							abs(l.part_value_new) total,							
							CONVERT(VARCHAR(10),adj.create_date,103) create_date,
							e.fullname, 
							ISNULL(adj.remark,'-') AS 'Job_number',
							sp.location_id,
							adj.create_date AS create_date_ord
					FROM tbt_adj_sparepart adj
					LEFT JOIN tbm_sparepart sp ON adj.part_id=sp.part_id
					LEFT JOIN tbm_stock_type cfg ON cfg.type_id=adj.adj_type
					LEFT JOIN tbm_employee e ON e.user_id=adj.create_by
					left join tbt_log_part l on l.adj_id=adj.adj_id
					left join tbm_log_type lt on lt.type_id=l.typelog
					WHERE sp.part_id=@part_id


---select * from fn_get_movement(337)
)
GO
/****** Object:  Table [dbo].[tbm_application_center]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_application_center](
	[application_id] [bigint] IDENTITY(1,1) NOT NULL,
	[application_code] [nvarchar](max) NULL,
	[application_description] [nvarchar](max) NULL,
	[application_link] [nvarchar](max) NULL,
	[application_method] [nvarchar](max) NULL,
	[application_status] [nvarchar](50) NULL,
	[create_id] [nvarchar](max) NULL,
	[create_dt] [datetime] NULL,
	[update_dt] [datetime] NULL,
	[application_image] [varbinary](max) NULL,
 CONSTRAINT [PK_tbm_application_center] PRIMARY KEY CLUSTERED 
(
	[application_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_brand]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_brand](
	[brand_id] [int] IDENTITY(1,1) NOT NULL,
	[brand_code] [varchar](10) NULL,
	[brand_name_tha] [varchar](200) NULL,
	[brand_name_eng] [varchar](200) NULL,
	[active_flag] [int] NULL,
	[create_by] [int] NULL,
	[update_by] [int] NULL,
	[create_date] [datetime] NOT NULL,
	[update_date] [datetime] NOT NULL,
 CONSTRAINT [PK_tbm_brand] PRIMARY KEY CLUSTERED 
(
	[brand_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_checklist]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_checklist](
	[ch_id] [int] NULL,
	[check_name_E] [varchar](50) NULL,
	[check_name_T] [varchar](100) NULL,
	[status] [int] NULL,
	[show_in_rpt] [int] NULL,
	[check_group_id] [int] NULL,
	[create_date] [date] NULL,
	[create_by] [int] NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_checklist_group]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_checklist_group](
	[ch_group_id] [int] NULL,
	[check_group_name] [varchar](50) NULL,
	[status] [int] NULL,
	[create_date] [date] NULL,
	[create_by] [int] NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_config]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_config](
	[config_id] [bigint] IDENTITY(1,1) NOT NULL,
	[config_key] [varchar](max) NULL,
	[config_value] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_contract_type]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_contract_type](
	[contract_type_id] [int] NOT NULL,
	[contract_type_name] [varchar](50) NULL,
 CONSTRAINT [PK_tbm_contract_type] PRIMARY KEY CLUSTERED 
(
	[contract_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_customer]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_customer](
	[customer_id] [int] IDENTITY(1,1) NOT NULL,
	[id_card] [varchar](13) NULL,
	[cust_type] [varchar](2) NULL,
	[fname] [varchar](255) NULL,
	[lname] [varchar](255) NULL,
	[address] [varchar](max) NULL,
	[sub_district_no] [varchar](255) NULL,
	[district_code] [varchar](255) NULL,
	[province_code] [varchar](255) NULL,
	[zip_code] [varchar](5) NULL,
	[phone_no] [varchar](500) NULL,
	[Email] [varchar](100) NULL,
	[status] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_district]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_district](
	[district_code] [varchar](4) NULL,
	[district_name_tha] [varchar](200) NULL,
	[province_code] [varchar](2) NULL,
	[zip_code] [varchar](5) NULL,
	[status] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_email_code_name]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_email_code_name](
	[email_name_id] [bigint] IDENTITY(1,1) NOT NULL,
	[email_code] [nchar](10) NULL,
	[email_description] [nvarchar](max) NULL,
	[active_flg] [nchar](10) NULL,
 CONSTRAINT [PK_tbm_email_code_name] PRIMARY KEY CLUSTERED 
(
	[email_name_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_employee_position]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_employee_position](
	[tep_id] [int] NOT NULL,
	[position_code] [varchar](2) NULL,
	[position_description] [varchar](50) NULL,
	[status] [int] NULL,
	[security_level] [numeric](18, 0) NULL,
 CONSTRAINT [PK_tbm_employee_position] PRIMARY KEY CLUSTERED 
(
	[tep_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_holiday]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_holiday](
	[date] [datetime] NOT NULL,
	[description] [varchar](500) NULL,
	[type] [int] NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_image_type]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_image_type](
	[image_type_id] [int] NOT NULL,
	[image_code] [varchar](3) NULL,
	[image_description] [varchar](max) NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_tbm_image_type] PRIMARY KEY CLUSTERED 
(
	[image_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_job_status]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_job_status](
	[job_status_code] [varchar](1) NULL,
	[job_status_desc] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_jobtype]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_jobtype](
	[tj_id] [int] NOT NULL,
	[jobcode] [varchar](2) NULL,
	[jobdescription] [varchar](200) NULL,
	[status] [int] NULL,
	[running_type] [int] NULL,
 CONSTRAINT [PK_tbm_jobtype] PRIMARY KEY CLUSTERED 
(
	[tj_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_location_store]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_location_store](
	[location_id] [varchar](3) NULL,
	[location_name] [varchar](200) NULL,
	[owner_id] [int] NULL,
	[create_by] [int] NULL,
	[create_date] [datetime] NULL,
	[update_by] [int] NULL,
	[update_date] [datetime] NULL,
	[status] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_menu]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_menu](
	[menu_id] [int] NOT NULL,
	[menu_description] [varchar](max) NULL,
	[status] [int] NULL,
	[icon] [varchar](max) NULL,
	[menu_controller] [varchar](max) NULL,
 CONSTRAINT [PK_tbm_menu] PRIMARY KEY CLUSTERED 
(
	[menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_message_type]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_message_type](
	[message_type_id] [int] IDENTITY(1,1) NOT NULL,
	[message_type_code] [varchar](2) NULL,
	[message_desc] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL,
 CONSTRAINT [PK_tbm_message_type] PRIMARY KEY CLUSTERED 
(
	[message_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_misc_data]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_misc_data](
	[misc_type] [varchar](50) NOT NULL,
	[misc_code] [varchar](10) NOT NULL,
	[value1] [varchar](500) NULL,
	[value2] [varchar](500) NULL,
	[value3] [varchar](500) NULL,
	[value4] [int] NULL,
	[value5] [int] NULL,
	[value6] [varchar](500) NULL,
	[active_flag] [int] NOT NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL,
 CONSTRAINT [PK__tbm_misc__49A9523C5C6CB6D7] PRIMARY KEY CLUSTERED 
(
	[misc_type] ASC,
	[misc_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_permission]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_permission](
	[emp_menu_id] [int] IDENTITY(1,1) NOT NULL,
	[menu_id] [int] NULL,
	[tep_id] [int] NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_tbm_permission] PRIMARY KEY CLUSTERED 
(
	[emp_menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_province]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_province](
	[province_code] [varchar](2) NULL,
	[province_name_tha] [nvarchar](200) NULL,
	[status] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_report_center]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_report_center](
	[rpt_id] [bigint] IDENTITY(1,1) NOT NULL,
	[rpt_code] [nchar](10) NULL,
	[rpt_name] [nvarchar](max) NULL,
	[rpt_store] [nvarchar](max) NULL,
	[active_flg] [nchar](10) NULL,
	[create_dt] [datetime] NULL,
	[create_by] [nchar](10) NULL,
	[upd_dt] [datetime] NULL,
	[upd_by] [nchar](10) NULL,
 CONSTRAINT [PK_tbm_report_center] PRIMARY KEY CLUSTERED 
(
	[rpt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_report_centerparameter]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_report_centerparameter](
	[rptp_id] [bigint] NOT NULL,
	[rpt_id] [bigint] NULL,
	[parameter_name] [nvarchar](max) NULL,
	[active_flg] [nchar](10) NULL,
	[create_dt] [datetime] NULL,
	[create_by] [nchar](10) NULL,
 CONSTRAINT [PK_tbm_report_centerparameter] PRIMARY KEY CLUSTERED 
(
	[rptp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_report_excel]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_report_excel](
	[report_id] [int] IDENTITY(1,1) NOT NULL,
	[report_name] [varchar](100) NULL,
	[report_store] [varchar](200) NULL,
	[report_param] [varchar](500) NULL,
	[active_flag] [int] NULL,
 CONSTRAINT [PK_tbm_report_excel] PRIMARY KEY CLUSTERED 
(
	[report_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_running_no]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_running_no](
	[running_type] [int] NOT NULL,
	[period] [datetime] NOT NULL,
	[prefix] [varchar](50) NULL,
	[affix] [varchar](200) NULL,
	[running_no] [int] NOT NULL,
	[length] [int] NULL,
 CONSTRAINT [PK_tbm_running_no_1] PRIMARY KEY CLUSTERED 
(
	[running_type] ASC,
	[period] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_running_no_prefix]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_running_no_prefix](
	[running_type] [int] NOT NULL,
	[prefix] [varchar](20) NULL,
	[description] [varchar](200) NULL,
	[affix] [varchar](50) NULL,
	[length] [int] NULL,
 CONSTRAINT [PK_tbm_running_no_prefix] PRIMARY KEY CLUSTERED 
(
	[running_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_services]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_services](
	[services_no] [varchar](4) NULL,
	[services_name] [varchar](50) NULL,
	[period_year] [int] NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL,
	[status] [int] NULL,
	[jobcode] [varchar](2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_sparepart_bak29032023]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_sparepart_bak29032023](
	[part_id] [bigint] IDENTITY(1,1) NOT NULL,
	[part_no] [varchar](50) NULL,
	[part_name] [varchar](100) NULL,
	[part_desc] [varchar](max) NULL,
	[part_type] [varchar](2) NULL,
	[cost_price] [decimal](10, 2) NULL,
	[sale_price] [decimal](10, 2) NULL,
	[unit_code] [varchar](50) NULL,
	[part_value] [int] NULL,
	[part_weight] [int] NULL,
	[minimum_value] [int] NULL,
	[maximum_value] [int] NULL,
	[location_id] [varchar](3) NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[cancel_date] [datetime] NULL,
	[cancel_by] [int] NULL,
	[cancel_reason] [varchar](500) NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL,
	[parent_id] [int] NULL,
	[ref_group] [varchar](50) NULL,
	[ref_other] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_sub_district]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_sub_district](
	[sub_district_code] [varchar](5) NULL,
	[sub_district_name_tha] [varchar](200) NULL,
	[district_code] [varchar](4) NULL,
	[status] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_unit]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_unit](
	[unit_code] [varchar](3) NULL,
	[unit_name] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbm_vehicle]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbm_vehicle](
	[license_no] [varchar](20) NULL,
	[seq] [int] NULL,
	[brand_no] [varchar](50) NULL,
	[model_no] [varchar](50) NULL,
	[chassis_no] [varchar](50) NULL,
	[Color] [text] NULL,
	[effective_date] [datetime] NULL,
	[expire_date] [datetime] NULL,
	[service_price] [decimal](12, 2) NULL,
	[service_no] [varchar](4) NULL,
	[contract_no] [varchar](20) NULL,
	[customer_id] [int] NULL,
	[contract_type] [int] NULL,
	[std_pmp] [decimal](10, 2) NULL,
	[employee_id] [int] NULL,
	[active_flag] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_application_role]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_application_role](
	[user_id] [bigint] NULL,
	[application_id] [bigint] NULL,
	[active_flg] [nchar](10) NULL,
	[create_dt] [datetime] NULL,
	[create_by] [nchar](10) NULL,
	[upd_dt] [nchar](10) NULL,
	[upd_id] [nchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_email_history]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_email_history](
	[email_id] [bigint] IDENTITY(1,1) NOT NULL,
	[email_code] [varchar](50) NULL,
	[job_id] [varchar](50) NULL,
	[customer_id] [bigint] NULL,
	[email_address] [nvarchar](max) NULL,
	[send_dt] [datetime] NULL,
	[send_by] [nvarchar](50) NULL,
	[active_flg] [nchar](10) NULL,
	[license_no] [nvarchar](max) NULL,
 CONSTRAINT [PK_tbt_email_history] PRIMARY KEY CLUSTERED 
(
	[email_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_job_checklist]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_job_checklist](
	[ckjob_id] [varchar](10) NULL,
	[ck_id] [int] NULL,
	[description] [varchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_job_detail]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_job_detail](
	[bjob_id] [varchar](10) NULL,
	[B1_model] [varchar](50) NULL,
	[B1_serial] [varchar](50) NULL,
	[B1_amp_hrs] [varchar](10) NULL,
	[B1_date_code] [varchar](20) NULL,
	[B1_spec_gravity] [decimal](12, 2) NULL,
	[B1_volt_static] [decimal](12, 2) NULL,
	[B1_volt_load] [decimal](12, 2) NULL,
	[B2_model] [varchar](50) NULL,
	[B2_serial] [varchar](50) NULL,
	[B2_amp_hrs] [varchar](10) NULL,
	[B2_date_code] [varchar](20) NULL,
	[B2_spec_gravity] [decimal](12, 2) NULL,
	[B2_volt_static] [decimal](12, 2) NULL,
	[B2_volt_load] [decimal](12, 2) NULL,
	[CD_manufact] [varchar](50) NULL,
	[CD_model] [varchar](50) NULL,
	[CD_serial] [varchar](50) NULL,
	[CD_tag_date] [datetime] NULL,
	[H_meter] [int] NULL,
	[V_service_mane] [nvarchar](50) NULL,
	[V_labour] [decimal](12, 2) NULL,
	[V_travel] [decimal](12, 2) NULL,
	[V_total] [decimal](12, 2) NULL,
	[failure_code] [varchar](20) NULL,
	[fair_wear] [varchar](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_job_header]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_job_header](
	[job_id] [varchar](10) NULL,
	[license_no] [varchar](20) NULL,
	[customer_id] [int] NULL,
	[summary] [varchar](max) NULL,
	[action] [varchar](max) NULL,
	[result] [varchar](max) NULL,
	[transfer_to] [int] NULL,
	[fix_date] [datetime] NULL,
	[close_date] [datetime] NULL,
	[email_customer] [varchar](500) NULL,
	[invoice_no] [varchar](20) NULL,
	[owner_id] [int] NULL,
	[create_by] [int] NULL,
	[create_date] [datetime] NULL,
	[update_by] [int] NULL,
	[update_date] [datetime] NULL,
	[ref_hjob_id] [varchar](10) NULL,
	[status] [int] NULL,
	[type_job] [varchar](2) NULL,
	[job_status] [varchar](1) NULL,
	[receive_date] [datetime] NULL,
	[travel_date] [datetime] NULL,
	[job_date] [datetime] NULL,
	[qt_id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_job_image]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_job_image](
	[ijob_id] [varchar](10) NULL,
	[seq] [int] NULL,
	[img_name] [varchar](500) NULL,
	[img_path] [varchar](max) NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[status] [int] NULL,
	[image_type] [varchar](3) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_job_part]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_job_part](
	[pjob_id] [varchar](10) NULL,
	[seq] [int] NULL,
	[part_no] [varchar](20) NULL,
	[total] [decimal](12, 2) NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[status] [int] NULL,
	[part_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_leave]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_leave](
	[leave_id] [int] IDENTITY(1,1) NOT NULL,
	[leave_type] [varchar](2) NULL,
	[emp_id] [int] NULL,
	[leave_date_from] [datetime] NULL,
	[leave_date_to] [datetime] NULL,
	[leave_path] [int] NULL,
	[approve_date] [datetime] NULL,
	[approve_by] [int] NULL,
	[cancel_date] [datetime] NULL,
	[cancel_by] [int] NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
 CONSTRAINT [PK_tbt_leave] PRIMARY KEY CLUSTERED 
(
	[leave_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_message]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_message](
	[message_id] [int] IDENTITY(1,1) NOT NULL,
	[message_type_code] [varchar](2) NULL,
	[license_no] [varchar](20) NULL,
	[services_no] [varchar](4) NULL,
	[period] [int] NULL,
	[job_id] [varchar](10) NULL,
	[location_id] [varchar](2) NULL,
	[marked] [int] NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[update_date] [datetime] NULL,
	[update_by] [int] NULL,
 CONSTRAINT [PK_tbt_message] PRIMARY KEY CLUSTERED 
(
	[message_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_noti_email]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_noti_email](
	[noti_email_id] [bigint] IDENTITY(1,1) NOT NULL,
	[noti_email_address] [nvarchar](max) NULL,
	[noti_email_status] [nchar](10) NULL,
	[noti_email_send] [datetime] NOT NULL,
	[noti_email_message] [nvarchar](max) NULL,
	[file_image_id] [bigint] NULL,
	[active_flg] [nchar](10) NULL,
	[create_dt] [datetime] NULL,
	[create_by] [nchar](10) NULL,
	[customer_id] [bigint] NULL,
 CONSTRAINT [PK_tbt_noti_email] PRIMARY KEY CLUSTERED 
(
	[noti_email_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_quotation]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_quotation](
	[qt_id] [varchar](11) NOT NULL,
	[qt_name] [varchar](100) NULL,
	[customer_name] [varchar](500) NULL,
	[customer_address] [varchar](500) NULL,
	[customer_tax] [varchar](13) NULL,
	[contact_name] [varchar](100) NULL,
	[contract_phone] [varchar](50) NULL,
	[owner_id] [int] NULL,
	[qt_due] [int] NULL,
	[discount_amt_vat] [decimal](12, 2) NULL,
	[discount_amt_in_vat] [decimal](12, 2) NULL,
	[total_amt_vat] [decimal](12, 2) NULL,
	[total_amt_in_vat] [decimal](12, 2) NULL,
	[create_by] [int] NULL,
	[create_date] [datetime] NULL,
	[update_by] [int] NULL,
	[update_date] [datetime] NULL,
	[active_flag] [int] NULL,
 CONSTRAINT [PK_tbt_quotation] PRIMARY KEY CLUSTERED 
(
	[qt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_quotaton_detail]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_quotaton_detail](
	[qt_id] [varchar](11) NOT NULL,
	[seq] [int] NOT NULL,
	[detail] [varchar](500) NULL,
	[qty] [int] NULL,
	[amt_ex_vat] [decimal](12, 2) NULL,
	[amt_vat] [decimal](12, 2) NULL,
	[amt_in_vat] [decimal](12, 2) NULL,
	[discount_vat] [decimal](12, 2) NULL,
	[discount_in_vat] [decimal](12, 2) NULL,
	[active_flag] [int] NULL,
	[create_date] [datetime] NULL,
	[create_by] [int] NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_tbt_quotaton_detail] PRIMARY KEY CLUSTERED 
(
	[qt_id] ASC,
	[seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbt_reminder]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbt_reminder](
	[license_no] [varchar](20) NULL,
	[seq] [int] NULL,
	[NT] [int] NULL,
	[AllDates] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temp_part]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp_part](
	[No] [float] NULL,
	[Parts_Number] [nvarchar](255) NULL,
	[Parts_desc] [nvarchar](255) NULL,
	[Qty] [float] NULL,
	[Type] [nvarchar](255) NULL,
	[Bin Location] [nvarchar](255) NULL,
	[Cost_Price] [float] NULL,
	[Sales_Price] [float] NULL,
	[Location] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbm_employee] ADD  DEFAULT (NULL) FOR [showstock]
GO
ALTER TABLE [dbo].[tbm_employee] ADD  DEFAULT (NULL) FOR [img_path]
GO
ALTER TABLE [dbo].[tbm_vehicle] ADD  CONSTRAINT [DF_tbm_vehicle_active_flag]  DEFAULT ((1)) FOR [active_flag]
GO
/****** Object:  StoredProcedure [dbo].[CheckPermissionAdmin]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckPermissionAdmin] @UserId int
AS
BEGIN
	SELECT emp.* FROM dbo.tbm_employee emp
	INNER JOIN dbo.tbm_employee_position pos ON emp.position =pos.position_code
	WHERE pos.position_code IN ('CK','MG') AND emp.user_id =@UserId;
END


GO
/****** Object:  StoredProcedure [dbo].[CounterDetail]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CounterDetail] 
		@CustomerID int,
		@license_no varchar(20)
AS
BEGIN
--รายละเอียดลูกค้า
	SELECT cus.customer_id,
		cus.cust_type,
		cus.address,
		(select td.district_name_tha from dbo.tbm_district  td where cus.district_code =td.district_code and td.status =1) as district_name_tha,
		(select std.sub_district_name_tha from dbo.tbm_sub_district std where std.sub_district_code = cus.sub_district_no and std.status=1) as sub_district_name_tha,
	    (select pr.province_name_tha from dbo.tbm_province pr where  pr.province_code =cus.province_code and pr.status =1) as province_name_tha,
		cus.zip_code,
		cus.phone_no,
		cus.Email
        FROM [dbo].[tbm_customer] cus
        WHERE customer_id = @CustomerID
        AND cus.status =1 ;
--รายละเอียดรถ
		SELECT 
	   [license_no]
      ,[seq]
      ,[brand_no]
      ,[model_no]
      ,[chassis_no]
      ,[Color]
      ,[effective_date]
      ,[expire_date]
      ,[service_price]
      ,[service_no]
      ,[contract_no]
      ,[customer_id]
      ,[contract_type]
      ,[std_pmp]
      ,[employee_id]
      ,[active_flag]
  FROM [dbo].[tbm_vehicle]
  WHERE active_flag =1
  AND license_no =@license_no;
  -- รายละเอียด Job
SELECT [job_id]
      ,[license_no]
      ,[customer_id]
      ,[summary]
      ,[action]
      ,[result]
      ,[transfer_to]
      ,[fix_date]
      ,[close_date]
      ,[email_customer]
      ,[invoice_no]
      ,[owner_id]
      ,[create_by]
      ,[create_date]
      ,[update_by]
      ,[update_date]
      ,[ref_hjob_id]
      ,[status]
      ,[type_job]
      ,[job_status]
      ,[receive_date]
      ,[travel_date]
      ,[job_date]
      ,[qt_id]
  FROM [dbo].[tbt_job_header]
  WHERE status =1
  AND [license_no] =@license_no
  AND [customer_id] =@CustomerID;

  --รายละเอียดการส่งอีเมล
  SELECT 
	   [email_id]
      ,h.[email_code]
      ,[job_id]
      ,[customer_id]
      ,[email_address]
      ,[send_dt]
      ,[send_by]
      ,h.[active_flg]
	  ,h.[license_no]
  FROM [dbo].[tbt_email_history] h
  INNER JOIN dbo.tbm_email_code_name c on h.email_code =c.email_code and c.active_flg =1
where h.active_flg =1
AND customer_id =@CustomerID
AND license_no =@license_no;
--รายละเอียดทะเบียนรถ
SELECT @CustomerID,
		license_no
from dbo.tbm_vehicle
WHERE active_flag=1
AND customer_id =@CustomerID;

--รายละเอียดการแจ้งเตือน
SELECT  [noti_email_id]
      ,[noti_email_address]
      ,[noti_email_status]
      ,[noti_email_send]
      ,[noti_email_message]
      ,[file_image_id]
      ,[active_flg]
      ,[create_dt]
      ,[create_by]
  FROM [dbo].[tbt_noti_email]
  WHERE active_flg =1
  AND customer_id =@CustomerID;

END


GO
/****** Object:  StoredProcedure [dbo].[sp_approve_leave_data]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_approve_leave_data]
	@leave_id INT,
	@emp_id INT   
AS
BEGIN
SET NOCOUNT OFF	

			UPDATE tbt_leave
			SET approve_by=@emp_id
				,approve_date=GETDATE()
			WHERE leave_id=@leave_id


SELECT @@ROWCOUNT
		
END


--DELETE FROM tbt_leave WHERE leave_id=4
GO
/****** Object:  StoredProcedure [dbo].[sp_cancel_leave_data]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_cancel_leave_data]
	@leave_id INT,
	@emp_id INT   
AS
BEGIN
SET NOCOUNT OFF	

			UPDATE tbt_leave
			SET cancel_by=@emp_id
				,cancel_date=GETDATE()
			WHERE leave_id=@leave_id


SELECT @@ROWCOUNT
		
END


--DELETE FROM tbt_leave WHERE leave_id=4
GO
/****** Object:  StoredProcedure [dbo].[sp_check_abnormal_data_store]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_abnormal_data_store] 
	AS
BEGIN
	UPDATE tbm_sparepart
	SET part_weight=0
	WHERE part_weight IS NULL

	UPDATE tbm_sparepart
	SET part_value=0
	WHERE part_value IS NULL

	UPDATE tbm_sparepart
	SET cost_price=0
	WHERE cost_price IS NULL


	UPDATE tbm_sparepart
	SET sale_price=0
	WHERE sale_price IS NULL


	UPDATE tbm_sparepart
	SET minimum_value=0
	WHERE minimum_value IS NULL

	UPDATE tbm_sparepart
	SET maximum_value=0
	WHERE maximum_value IS NULL


	UPDATE tbm_sparepart
	SET create_by=1
	WHERE create_by IS NULL

	--DECLARE @msg NVARCHAR(400)
	--SET @msg=CONCAT('ระบบตรวจและปรับข้อมูล Stock เรียบร้อย !!! [',cast( getdate() as varchar) ,']')
	--EXEC dbo.sp_sendmsg_line @msg


	--INSERT INTO [dbo].[tbm_misc_data]
 --          ([misc_type]
 --          ,[misc_code]
 --          ,[value1]
 --          ,[value2]
 --          ,[value3]
 --          ,[value4]
 --          ,[value5]
 --          ,[value6]
 --          ,[active_flag]
 --          ,[create_date]
 --          ,[create_by]
 --          ,[update_date]
 --          ,[update_by])
 --    VALUES
 --          ('Part_type'
 --          ,'01'
 --          ,'Dummy Part (ช่างกำหนด)'
 --          ,NULL
 --          ,NULL
 --          ,NULL
 --          ,NULL
 --          ,NULL
 --          ,1
 --          ,GETDATE()
 --          ,1
 --          ,NULL
 --          ,1
	--	   )





END


GO
/****** Object:  StoredProcedure [dbo].[sp_check_nagative_part]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_nagative_part]

AS
BEGIN
		 SELECT 
		part_id,
		part_name,
		dbo.fn_get_onhand(part_id,null) FROM tbm_sparepart
		WHERE dbo.fn_get_onhand(part_id,null)<0
END
GO
/****** Object:  StoredProcedure [dbo].[sp_check_onhand]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_check_onhand]
	@part_id INT,
	@job_id VARCHAR(10)=NULL
AS
BEGIN
DECLARE @onhand int=0

;WITH adj_part AS (
		SELECT part_id,SUM(adj_part_value) adj_part_value 
		FROM tbt_adj_sparepart
		GROUP BY part_id
),job_part AS (
		SELECT part_id,CONVERT(INT,SUM(total)) total 
		FROM tbt_job_part
		WHERE status=1 AND (@job_id IS NULL OR pjob_id NOT IN (@job_id))
		GROUP BY part_id
	)
,TFM AS (
	SELECT part_id,SUM(ABS(part_value_old-part_value_new)) total 
	FROM tbt_log_part l
	WHERE typelog=1
	GROUP BY part_id
	)
,TTM AS (
	SELECT parent_id,SUM(ABS(part_value_old-part_value_new)) total 
	FROM tbt_log_part l
	WHERE typelog=2
	GROUP BY parent_id
	)
,UPS AS (
SELECT part_id,SUM(part_value_new-part_value_old) total 
	FROM tbt_log_part l
	WHERE typelog=0
	GROUP BY part_id
)

select sp.part_value,
		ISNULL(jp.total,0) AS 'ตัด stock ด้วย job',
		ISNULL(adj.adj_part_value,0) AS 'ปรับค่า stock adjust',
		ISNULL(TTM.total,0) AS 'Van->Mainstore',
		ISNULL(TFM.total,0) AS 'Mainstore->Van',
		ISNULL(UPS.total,0) AS 'Updatestore'  
from tbm_sparepart sp
left join job_part jp on sp.part_id=jp.part_id 
left join adj_part adj on adj.part_id=sp.part_id
LEFT JOIN TTM ON sp.part_id=TTM.parent_id
LEFT JOIN TFM ON sp.part_id=TFM.part_id
LEFT JOIN UPS ON UPS.part_id=sp.part_id

where sp.part_id=@part_id



SELECT dbo.fn_get_onhand(@part_id,@job_id) AS 'OnHand'

EXEC  dbo.sp_get_movement_sparepart @part_id

EXEC sp_check_onlog @part_id

SELECT  part_id,
		part_no,
		location_id,
		dbo.fn_get_onhand(part_id,NULL) on_hand
FROM tbm_sparepart WHERE part_no IN (
SELECT part_no FROM tbm_sparepart 
WHERE part_id=@part_id)


END
GO
/****** Object:  StoredProcedure [dbo].[sp_check_onlog]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_onlog]
	@part_id INT=NULL
AS
BEGIN
		SELECT 
				l.log_id, 
				l.part_id, 
				l.parent_id, 
				l.part_value_old, 
				l.part_value_new, 
				l.parent_value_old, 
				l.parent_value_new, 
				l.typelog, 
				l.onhand, 
				--l.remark, 
				tl.type_name,
				l.user_id, 
				l.create_date, 
				l.part_id_to, 
				--l.part_value_new-l.part_value_old AS change_value,
				case when (l.part_value_old<0 and l.part_value_new>=0) then (l.part_value_new-l.part_value_old-1) else  l.part_value_new-l.part_value_old end AS change_value,
				--l.onhand+(l.part_value_new-l.part_value_old) 'remain_onhand',
				(case when(l.part_value_old<0 and l.part_value_new>=0) then (l.part_value_new-l.part_value_old-1) else  l.part_value_new-l.part_value_old end) + l.onhand as 'remain_onhand',
				sp.part_no,
				l.adj_id,
				adj.remark ref_no
		FROM tbt_log_part l
			 LEFT JOIN tbm_sparepart sp ON sp.part_id=l.part_id
			 LEFT JOIN tbm_log_type tl ON tl.type_id=l.typelog
			 left join tbt_adj_sparepart adj on adj.adj_id=l.adj_id
		WHERE (@part_id IS NULL OR l.part_id=@part_id)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_DEP801_send_api]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DEP801_send_api]
	@URL VARCHAR(MAX),
	@BODY VARCHAR(8000),
	@RESULT VARCHAR(8000) OUTPUT
AS
BEGIN
	-------------------------------------------------------------------------------
	EXEC sp_configure 'show advanced options', 1      
  	RECONFIGURE      
  	EXEC sp_configure 'xp_cmdshell', 1      
  	RECONFIGURE 
	-------------------------------------------------------------------------------
	DECLARE @Object AS INT;
	DECLARE @ResponseText AS VARCHAR(8000);
--	SET @BODY ='
--{
--    "ref_id": "34484113000182",
--    "public_note": "ประวัติสินเชื่อไม่ผ่านหลักเกณฑ์ของบริษัท (แดง)(OR By CBO)",
--    "channel": "Credit",
--    "public_note_user": "SIIS_UPD",
--    "status_code": "R",
--    "status_desc": "Send SMS"
--}'
	EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
	EXEC sp_OAMethod @Object, 'open', NULL, 'post',
					 @URL,
					 'false'
	EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'
	EXEC sp_OAMethod @Object, 'send', null, @body
	EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
	IF CHARINDEX('false',(SELECT @ResponseText)) > 0
	begin

	 SET @RESULT=@ResponseText
	end
	ELSE
	  SET @RESULT=@ResponseText
	
	EXEC sp_OADestroy @Object

END



 

GO
/****** Object:  StoredProcedure [dbo].[sp_gen_countsheet_Email]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_countsheet_Email] 
AS
BEGIN
	SELECT part_desc AS 'Bin Location',
	part_no,
	part_name,
	ls.location_name 'location',
	0 AS 'total_count'
	FROM  tbm_sparepart sp
	LEFT JOIN tbm_location_store ls ON ls.location_id=sp.location_id

END
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_countsheet_Excel]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_countsheet_Excel] 
AS
BEGIN
	SELECT part_desc AS 'Bin_Location',
	part_no,
	part_name,
	ls.location_name 'location',
	0 AS 'total_count'
	FROM  tbm_sparepart sp
	LEFT JOIN tbm_location_store ls ON ls.location_id=sp.location_id

END
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_order_part]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_order_part]

AS
BEGIN
		SELECT 
		part_No,
		part_name,
		dbo.fn_get_onhand(part_Id,null) parts_quanity,
		minimum_value,
		maximum_value,
		CASE WHEN ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(part_Id,null),0)<=0 THEN 0 ELSE ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(part_Id,null),0) end order_quanlity,
		cost_price,
		cost_price*CASE WHEN ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(part_Id,null),0)<=0 THEN 0 ELSE ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(part_Id,null),0) end  total_cost_price,
		ls.location_name AS location
	FROM tbm_sparepart sp
	LEFT JOIN tbm_location_store ls ON ls.location_id=sp.location_id
	WHERE
			CASE WHEN ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(part_Id,null),0)<=0 THEN 0 ELSE ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(part_Id,null),0) end >0
			AND ls.location_id='L01'
	ORDER BY part_no,ls.location_name




	



END
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_order_part_Email]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_order_part_Email]

AS
BEGIN
DECLARE @tb TABLE  
		(
			part_no varchar(50),
			part_name varchar(500),
			parts_quantity INT,
			minimum_value INT,
			maximum_value INT,
			order_quanlity INT,
			cost_price DECIMAL(10,2),
			total_cost_price DECIMAL(10,2),
			location VARCHAR(100)

		)
		INSERT @tb
		EXEC sp_gen_order_part
	
DECLARE @mess VARCHAR(MAX)
SELECT @mess=(SELECT
			(SELECT 'Order Part Report' FOR XML PATH(''),TYPE) AS 'caption',
			(SELECT		'part_no' AS th,
						'part_name' AS th,
						'parts_quanity' AS th, 
						'minimum_value' AS th, 
						'maximum_value' AS th, 
						'order_quanlity' AS th, 
						'cost_price' AS th, 
						'total_cost_price' AS th, 
						'location' AS th 
						FOR XML RAW('tr'), ELEMENTS, TYPE) AS thead,
			(SELECT 
					part_no AS td,
					part_name AS td,
					parts_quantity AS td,
					minimum_value AS td,
					maximum_value AS td,
					order_quanlity AS td,
					cost_price AS td, 
					total_cost_price AS td,
					location AS td 
				FROM @tb
				FOR XML RAW('tr'), ELEMENTS, TYPE
			) 
			AS 'tbody'

			FOR XML PATH(''), ROOT('table')
			) 
SET @mess=CONCAT(REPLACE(@mess,'<table>','<table border=1 width=600px>'),'</br>')
SET @mess=REPLACE(@mess,'<th>','<th bgcolor=gray>')
	--PRINT @mess
DECLARE @to_email VARCHAR(1000)
SELECT @to_email=config_value FROM tbm_config WHERE config_id=11  --delay
SELECT @mess AS 'message',@to_email AS 'tomail'



END
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_order_part_Excel]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_order_part_Excel]

AS
BEGIN
		
		DECLARE @tb TABLE  
		(
			part_no varchar(50),
			part_name varchar(500),
			parts_quantity INT,
			minimum_value INT,
			maximum_value INT,
			order_quanlity INT,
			cost_price DECIMAL(10,2),
			total_cost_price DECIMAL(10,2),
			location VARCHAR(100)

		)
		INSERT @tb
		EXEC sp_gen_order_part

		SELECT * FROM @tb
END
---exec sp_gen_order_part_Email
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_remind_job_delay_Email]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_remind_job_delay_Email]
AS
BEGIN

DECLARE @mess VARCHAR(MAX)


SELECT @mess=(SELECT
			(SELECT 'Job Delay..' FOR XML PATH(''),TYPE) AS 'caption',
			(SELECT 'Job_No' AS th, 'Delay(HR)' AS th,'Delay(Day)' as th,'CustomerName' AS th,'Owner' as th FOR XML RAW('tr'), ELEMENTS, TYPE) AS thead,
			(SELECT job_id AS td,
					DATEDIFF(HOUR,j.create_date,GETDATE()) AS td,
					CONVERT(decimal(10,2),DATEDIFF(HOUR,j.create_date,GETDATE())/24.0) AS td,
					c.fname+' '+c.lname AS td,e.fullname as td
				FROM tbt_job_header j
				LEFT JOIN tbm_customer c ON c.customer_id=j.customer_id
				LEFT JOIN tbm_employee e ON e.user_Id=COALESCE(j.transfer_to,j.owner_id)
				WHERE fix_date IS NULL  
				AND DATEDIFF(HOUR,j.create_date,GETDATE())<=24
				FOR XML RAW('tr'), ELEMENTS, TYPE
			) 
			AS 'tbody',
			(SELECT job_id AS tdx,
					DATEDIFF(HOUR,j.create_date,GETDATE()) AS tdx,
					CONVERT(decimal(10,2),DATEDIFF(HOUR,j.create_date,GETDATE())/24.0) AS tdx,
					c.fname+' '+c.lname AS tdx,e.fullname as tdx
				FROM tbt_job_header j
				LEFT JOIN tbm_customer c ON c.customer_id=j.customer_id
				LEFT JOIN tbm_employee e ON e.user_Id=COALESCE(j.transfer_to,j.owner_id)
				WHERE fix_date IS NULL  
				AND DATEDIFF(HOUR,j.create_date,GETDATE())>24
				FOR XML RAW('tr'), ELEMENTS, TYPE
			) 
			AS 'tbody'

			FOR XML PATH(''), ROOT('table')
			) 
SET @mess=CONCAT(REPLACE(@mess,'<table>','<table border=1 width=450px>'),'</br>')
SET @mess=REPLACE(@mess,'<th>','<th bgcolor=gray>')
set @mess=REPLACE(@mess,'<tdx>','<td><font color=red>')
set @mess=REPLACE(@mess,'</tdx>','</font></td>')

	--PRINT @mess
DECLARE @to_email VARCHAR(1000)
SELECT @to_email=config_value FROM tbm_config WHERE config_id=11  --delay
SELECT @mess AS 'message',@to_email AS 'tomail'

END

	




--EXEC [sp_gen_remind_job_delay_Email]
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_remind_job_delay_Excel]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_gen_remind_job_delay_Excel]
AS
BEGIN

DECLARE @mess VARCHAR(MAX)


SELECT job_id AS 'Job_No',
		DATEDIFF(HOUR,j.create_date,GETDATE()) AS 'Delay(HR)',
					CONVERT(decimal(10,2),DATEDIFF(HOUR,j.create_date,GETDATE())/24.0) AS 'Delay(Day)',
					c.fname+' '+c.lname AS 'CustomerName',
					e.fullname as 'Owner'
				FROM tbt_job_header j
				LEFT JOIN tbm_customer c ON c.customer_id=j.customer_id
				LEFT JOIN tbm_employee e ON e.user_Id=COALESCE(j.transfer_to,j.owner_id)
				WHERE fix_date IS NULL  


END

	




--EXEC [sp_gen_remind_job_delay_excel]
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_remind_job_delay_line]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_remind_job_delay_line]
AS
BEGIN

DECLARE @mess VARCHAR(MAX)
SELECT @mess=STUFF
(
    (
		SELECT ' , ' + CONCAT('[',j.job_id,'] = ', DATEDIFF(HOUR,create_date,GETDATE()), ' Hr.')
		FROM tbt_job_header j
		LEFT JOIN tbm_customer c ON c.customer_id=j.customer_id
		WHERE fix_date IS NULL  AND DATEDIFF(HOUR,create_date,GETDATE())>24
		FOR XML PATH('')
		
    ),
     1, 1, ''
) 
	SET @mess=CONCAT('Warning Job Delay more than [24 Hour]',@mess)
	PRINT @mess
	DECLARE @token VARCHAR(1000)='WwffLgfoEnLkP0ahspONOmqNhfy1CopGzAZxt3WpAJD'
	EXEC sp_sendmsg_line @mess,@token

END

	




--EXEC sp_gen_remind_job_delay
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_remind_job_expire_email]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_remind_job_expire_email]
AS
BEGIN

DECLARE @mess VARCHAR(MAX)

;WITH cte AS (
SELECT ROW_NUMBER() OVER (PARTITION BY license_no ORDER BY seq desc) ord,license_no,expire_date,customer_id,contract_type
FROM 
tbm_vehicle)
 




SELECT @mess=(SELECT
			(SELECT 'Warning contract expire coming soon' FOR XML PATH(''),TYPE) AS 'caption',
			(SELECT 'Job_no' AS th, 'total(day)' AS th FOR XML RAW('tr'), ELEMENTS, TYPE) AS thead,
			(	
				SELECT CONCAT(SUBSTRING(c.fname,0,15),'..',' [',cte.license_no,']') AS td, DATEDIFF(DAY,GETDATE(),expire_date) AS td
				FROM cte 
				LEFT JOIN tbm_customer c ON c.customer_id=cte.customer_id
				WHERE ord=1 
				AND ISNULL(cte.contract_type,0)<>0
				AND (DATEDIFF(DAY,GETDATE(),expire_date)>0 AND DATEDIFF(DAY,GETDATE(),expire_date)<=120) 
				FOR XML RAW('tr'), ELEMENTS, TYPE
			) 
			AS 'tbody'

			FOR XML PATH(''), ROOT('table')
			) 

SET @mess=CONCAT(REPLACE(@mess,'<table>','<table border=1 width=500px>'),'</br>')
SET @mess=REPLACE(@mess,'<th>','<th bgcolor=gray>')
	PRINT @mess
DECLARE @to_email VARCHAR(1000)
SELECT @to_email=config_value FROM tbm_config WHERE config_id=10
SELECT @mess AS 'message',@to_email AS 'tomail'



END

--EXEC sp_gen_remind_job_expire_email




GO
/****** Object:  StoredProcedure [dbo].[sp_gen_remind_job_expire_line]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_remind_job_expire_line]
AS
BEGIN

DECLARE @mess VARCHAR(MAX)

;WITH cte AS (
SELECT ROW_NUMBER() OVER (PARTITION BY license_no ORDER BY seq desc) ord,license_no,expire_date,customer_id,contract_type
FROM 
tbm_vehicle)
SELECT @mess=STUFF
(
(
SELECT  
' , ' + CONCAT(SUBSTRING(c.fname,0,15),'..',' [',cte.license_no,'] = ', DATEDIFF(DAY,GETDATE(),expire_date) , 'd')
FROM cte 
LEFT JOIN tbm_customer c ON c.customer_id=cte.customer_id
WHERE ord=1 
AND ISNULL(cte.contract_type,0)<>0
AND (DATEDIFF(DAY,GETDATE(),expire_date)>0 AND DATEDIFF(DAY,GETDATE(),expire_date)<=120)
FOR XML PATH('')
),
1,1,'')

	SET @mess=CONCAT('Warning Job Expire coming soon',@mess)
	PRINT @mess
	DECLARE @token VARCHAR(1000)='m3dNJOqKOn65dJ5Vs3umWIZegQG5x7M12JPCBMFHRx7'
	EXEC sp_sendmsg_line @mess,@token

END






--EXEC sp_gen_remind_job_expire_line
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_remind_stock_email]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE	 PROCEDURE [dbo].[sp_gen_remind_stock_email]
AS
BEGIN

SELECT 
		ROW_NUMBER() OVER (ORDER BY l.location_id ASC) ord,
		l.location_id,
		l.location_name 
		INTO #temp
FROM tbm_sparepart s
inner JOIN tbm_location_store l ON l.location_id=s.location_id
GROUP BY l.location_id,l.location_name

DECLARE @i INT=1
DECLARE @row INT =NULL

SELECT @row=MAX(ord) FROM #temp
DECLARE @msend NVARCHAR(MAX)
WHILE (@i<=@row)
BEGIN
DECLARE @mess NVARCHAR(MAX)
	
SELECT @mess=(SELECT
			(SELECT CONCAT('Warning low spare part = ',(SELECT location_name FROM #temp WHERE ord=@i)) FOR XML PATH(''),TYPE) AS 'caption',
			(SELECT 'part_no' AS th, 'total' AS th FOR XML RAW('tr'), ELEMENTS, TYPE) AS thead,
			(	
				SELECT part_no AS td,s.maximum_value-dbo.fn_get_onhand(s.part_id,NULL) AS td
				FROM tbm_sparepart s
				INNER JOIN #temp t ON s.location_id=t.location_id AND ord=@i
				WHERE (dbo.fn_get_onhand(part_id,null)<=minimum_value) AND s.maximum_value>0  
				FOR XML RAW('tr'), ELEMENTS, TYPE
			) 
			AS 'tbody'

			FOR XML PATH(''), ROOT('table')
			) 
SET @mess=CONCAT(REPLACE(@mess,'<table>','<table border=1 width=300px>'),'</br>')
SET @mess=REPLACE(@mess,'<th>','<th bgcolor=gray>')
SET @msend=CONCAT(@msend,@mess)
	SET @i=@i+1
END
DROP TABLE #temp
DECLARE @to_email VARCHAR(1000)
SELECT @to_email=config_value FROM tbm_config WHERE config_id=9

SELECT @msend AS 'message',@to_email AS 'tomail'
END


--EXEC sp_gen_remind_stock_email


		




GO
/****** Object:  StoredProcedure [dbo].[sp_gen_remind_stock_line]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_remind_stock_line]
AS
BEGIN
		--SELECT	
		--		--part_id,
		--		part_no
		--		--dbo.fn_get_onhand(part_id,null) 'part_value',
		--		--minimum_value,
		--		--maximum_value
		--FROM tbm_sparepart
		--WHERE dbo.fn_get_onhand(part_id,null)<>0
		--AND (dbo.fn_get_onhand(part_id,null)<=minimum_value)


SELECT 
		ROW_NUMBER() OVER (ORDER BY l.location_id ASC) ord,
		l.location_id,
		l.location_name 
		INTO #temp
FROM tbm_sparepart s
inner JOIN tbm_location_store l ON l.location_id=s.location_id
GROUP BY l.location_id,l.location_name

DECLARE @i INT=1
DECLARE @row INT =NULL

SELECT @row=MAX(ord) FROM #temp

WHILE (@i<=@row)
BEGIN
DECLARE @mess VARCHAR(300)
SELECT @mess=STUFF
(
    (
        SELECT ' , ' + CONCAT(part_no,'=',s.maximum_value-dbo.fn_get_onhand(s.part_id,NULL),' ')
        FROM tbm_sparepart s
		INNER JOIN #temp t ON s.location_id=t.location_id AND ord=@i
        WHERE (dbo.fn_get_onhand(part_id,null)<=minimum_value) AND s.maximum_value>0  
		 FOR XML PATH('')
		
    ),
     1, 1, ''
) 
	SET @mess=CONCAT('Warning low spare part ,[',(SELECT location_name FROM #temp where ord=@i),']',@mess)
	PRINT @mess
	DECLARE @token VARCHAR(1000)='934NW0lwdz0qTqiZxrOgYDAvBQOqTrdCfJp1MAKq86S'
	EXEC sp_sendmsg_line @mess,@token
	SET @i=@i+1
END
DROP TABLE #temp
		

END


--EXEC [sp_gen_remind_stock]
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_remind_table]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_remind_table]
	@license_no VARCHAR(20)=NULL
AS
BEGIN
SET NOCOUNT ON

DECLARE @mess NVARCHAR(500)
SELECT 
		ROW_NUMBER() OVER (ORDER BY v.license_no) 'No',
		v.license_no,
       v.seq,
       v.effective_date,
       v.expire_date,
	   s.period_year,
	   s.services_no
	   INTO #temp
FROM tbm_vehicle v
    LEFT JOIN
    (SELECT license_no, seq FROM tbm_vehicle GROUP BY license_no, seq) vg
        ON vg.license_no = v.license_no
           AND vg.seq = v.seq  
	LEFT JOIN tbm_services s ON s.services_no=v.service_no AND s.status=1
WHERE LEFT(v.service_no,2)='PM'
AND (
          @license_no IS NULL
          OR v.license_no = @license_no
      )
DECLARE @row_start INT=1
DECLARE @row_count INT=0
SELECT @row_count=COUNT(1) FROM #temp


---------------crete remider table -------------
IF OBJECT_ID('tbt_reminder') IS NULL 
BEGIN
	CREATE TABLE tbt_reminder
(
    license_no VARCHAR(20),
	seq INT,
	NT INT,
	AllDates datetime
)
END------------------------------------------------



WHILE (@row_start<=@row_count)
BEGIN
	DECLARE @npy INT=0 -- จำนวนครังต่อปี
	DECLARE @range_date INT =0
	DECLARE @lic VARCHAR(20),@seq INT,@period_y INT	
	DECLARE @StartDate DATE, @EndDate DATE
	DECLARE @service_no VARCHAR(10)=NULL
	SELECT @StartDate = effective_date,
		   @EndDate = expire_date,
		   @lic = Rtrim(LTRIM(license_no)),
		   @seq = seq,
		   @range_date=DATEDIFF(MONTH,effective_date,expire_date)+1,
		   @npy=CEILING(((DATEDIFF(MONTH,effective_date,expire_date)+1)*period_year)/12.0),
		   @period_y=period_year,
		   @service_no=services_no
	FROM #temp
	WHERE No = @row_start;

	SELECT @StartDate AS StartDate,@EndDate AS EndDate,@lic AS license_no,@seq seq,@range_date AS range_month,@npy AS NumPerYear,@period_y AS period_year,@service_no  AS service_no

	IF (@service_no IS NULL OR @npy IS NULL OR @period_y IS NULL)
	BEGIN
			PRINT concat('ERROR License_no = ',@lic)
			CONTINUE --next loop
	end


		DELETE FROM tbt_reminder 
		WHERE RTRIM(LTRIM(license_no))=@lic AND seq=@seq;


		DECLARE @tablePMP AS TABLE
        (
			check_date_var varchar(6),
			NT int
		)
	

		DECLARE @iloop INT=1
		WHILE(@iloop<=@range_date)
		BEGIN
			DECLARE @check_date datetime =DATEADD(MONTH,@iloop-1,@StartDate)
			DECLARE @check_date_var VARCHAR(6)=CONVERT(VARCHAR(6),@check_date,112)
			INSERT @tablePMP VALUES(@check_date_var,NULL)
		SET @iloop=@iloop+1
		END
		

	;WITH ud AS (
		SELECT *,NTILE(@npy) OVER (ORDER BY check_date_var) ord
		FROM @tablePMP
		)
		UPDATE @tablePMP
		SET NT=ud.ord
		FROM ud
		LEFT JOIN @tablePMP t ON t.check_date_var=ud.check_date_var
		;WITH ListDates(AllDates) AS
		(    SELECT @StartDate AS DATE
			UNION ALL
			SELECT DATEADD(DAY,1,AllDates)
			FROM ListDates 
			WHERE AllDates < @EndDate)
		INSERT INTO tbt_reminder
		SELECT @lic AS License_No,@seq AS seq,p.NT 'NT',AllDates
		FROM ListDates
		LEFT join @tablePMP p ON p.check_date_var=CONVERT(VARCHAR(6),ListDates.AllDates,112)
		OPTION (MAXRECURSION 1000)

		
 SET @row_start=@row_start+1

-- SELECT x.license_no, x.NT, x.start_range, x.stop_range
--  FROM (
--SELECT license_no,
--           NT,
--           MIN(alldates) AS start_range,
--           MAX(alldates) AS stop_range
--    FROM tbt_reminder
--    GROUP BY license_no,seq,nt
--			 HAVING LTRIM(license_no)=@lic AND seq=@seq
--)x  ORDER BY license_no,nt



END
DROP TABLE #temp


	SET @mess=CONCAT('ระบบ generate remind data เรียบร้อย !!! [',cast( getdate() as varchar) ,']')
	IF (@license_no IS NOT NULL AND DB_NAME()='ISEE')
	bEGIN
			DECLARE @token VARCHAR(1000)='WwffLgfoEnLkP0ahspONOmqNhfy1CopGzAZxt3WpAJD'
			EXEC sp_sendmsg_line @mess,@token
	END

	 



END

GO
/****** Object:  StoredProcedure [dbo].[sp_gen_replenishment_stock_email]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_replenishment_stock_email]
AS
BEGIN

SELECT 
		ROW_NUMBER() OVER (ORDER BY l.location_id ASC) ord,
		l.location_id,
		l.location_name 
		INTO #temp
FROM tbm_sparepart s
inner JOIN tbm_location_store l ON l.location_id=s.location_id
GROUP BY l.location_id,l.location_name





DECLARE @i INT=1
DECLARE @row INT =NULL

SELECT @row=MAX(ord) FROM #temp
DECLARE @msend NVARCHAR(MAX)
WHILE (@i<=@row)
BEGIN

--SELECT		part_no AS td,
--							part_name AS td,
--							dbo.fn_get_onhand(s.part_id,NULL) AS td,
--							part_desc AS td,
--							minimum_value AS td,
--							maximum_value AS td,
--							ISNULL(maximum_value,0)-ISNULL(minimum_value,0)-ISNULL(dbo.fn_get_onhand(s.part_id,NULL),0) AS td, 
--							ls.location_name AS td
--				FROM tbm_sparepart s
--				INNER JOIN #temp t ON s.location_id=t.location_id AND ord=@i
--				LEFT JOIN tbm_location_store ls ON ls.location_id=s.location_id
--				WHERE (dbo.fn_get_onhand(part_id,null)<=minimum_value) AND s.maximum_value>0  


DECLARE @mess NVARCHAR(MAX)
	
SELECT @mess=(SELECT
			(SELECT CONCAT('Report :: Replenishment parts = ',(SELECT location_name FROM #temp WHERE ord=@i)) FOR XML PATH(''),TYPE) AS 'caption',
			(SELECT 
					'part no' AS th,
					'part name' AS th,
					'parts quanlity' AS th,
					'Bin location' AS th,
					'min' AS th,
					'max' AS th,
					'replenishment qty' AS th,
					'location' AS th FOR XML RAW('tr'), ELEMENTS, TYPE) AS thead,
			(	
				SELECT		part_no AS td,
							part_name AS td,
							dbo.fn_get_onhand(s.part_id,NULL) AS td,
							part_desc AS td,
							minimum_value AS td,
							maximum_value AS td,
							CASE WHEN ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(s.part_id,NULL),0)>=ISNULL(minimum_value,0) THEN 
								ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(s.part_id,NULL),0)
							ELSE
								0
							end AS td, 

							--ISNULL(minimum_value,0)
							ls.location_name AS td
				FROM tbm_sparepart s
				INNER JOIN #temp t ON s.location_id=t.location_id AND ord=@i
				LEFT JOIN tbm_location_store ls ON ls.location_id=s.location_id
				WHERE (dbo.fn_get_onhand(part_id,null)<=minimum_value) AND s.maximum_value>0  
				FOR XML RAW('tr'), ELEMENTS, TYPE
			) 
			AS 'tbody'

			FOR XML PATH(''), ROOT('table')
			) 
SET @mess=CONCAT(REPLACE(@mess,'<table>','<table border=1 width=900px cellspacing="2">'),'</br>')
SET @mess=REPLACE(@mess,'<th>','<th bgcolor=gray>')
SET @msend=CONCAT(@msend,@mess)
	SET @i=@i+1
END
DROP TABLE #temp
DECLARE @to_email VARCHAR(1000)
SELECT @to_email=config_value FROM tbm_config WHERE config_id=9

SELECT @msend AS 'message',@to_email AS 'tomail'
END


--EXEC  [dbo].[sp_gen_Replenishment_stock_email]





		




GO
/****** Object:  StoredProcedure [dbo].[sp_gen_replenishment_stock_Excel]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_replenishment_stock_Excel]
AS
BEGIN

SELECT 
		ROW_NUMBER() OVER (ORDER BY l.location_id ASC) ord,
		l.location_id,
		l.location_name 
		INTO #temp
FROM tbm_sparepart s
inner JOIN tbm_location_store l ON l.location_id=s.location_id
GROUP BY l.location_id,l.location_name


DECLARE @i INT=1
DECLARE @row INT =NULL

SELECT @row=MAX(ord) FROM #temp

DECLARE @TB TABLE
(	part_no varchar(50), 
	part_name varchar(200),
	parts_quanlity int,
	part_desc varchar(500), 
	minimum_value int,
	maximum_value int,
	replenishment_qty int,
	location_name varchar(20)
)

WHILE (@i<=@row)
BEGIN
				insert into @TB
				SELECT		part_no,
							part_name,
							dbo.fn_get_onhand(s.part_id,NULL) AS parts_quanlity,
							part_desc AS Bin_location,
							minimum_value,
							maximum_value,
							CASE WHEN ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(s.part_id,NULL),0)>=ISNULL(minimum_value,0) THEN 
								ISNULL(maximum_value,0)-ISNULL(dbo.fn_get_onhand(s.part_id,NULL),0)
							ELSE
								0
							end AS minimum_value, 
							ls.location_name
				FROM tbm_sparepart s
				INNER JOIN #temp t ON s.location_id=t.location_id AND ord=@i
				LEFT JOIN tbm_location_store ls ON ls.location_id=s.location_id
				WHERE (dbo.fn_get_onhand(part_id,null)<=minimum_value) AND s.maximum_value>0 
				
		set @i=@i+1 
				
END
select * from @tb

END


--EXEC  sp_gen_replenishment_stock_Excel





		




GO
/****** Object:  StoredProcedure [dbo].[sp_gen_summary_job_onhand_Email]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_summary_job_onhand_Email]
AS
BEGIN
DECLARE @date_value DATE=GETDATE();

WITH job AS (SELECT CONVERT(VARCHAR(7), create_date, 120) cdate,
 COALESCE(transfer_to, owner_id) emp_id, type_job, SUM( CASE WHEN ISNULL(job_status, '')='' THEN 1 
														ELSE 0 
														END) 'WIM', 
												  SUM (CASE WHEN job_status='C' THEN 1
														ELSE 0
														END) 'CIM',
												 SUM (CASE WHEN job_status='C' AND CONVERT(DATE,close_date)=DATEADD(DAY,-1,@date_value) THEN 1 ----ลบ 1 วัน
														ELSE 0
														END) 'CID'

             FROM tbt_job_header
			 WHERE	COALESCE(transfer_to, owner_id)<>1
             GROUP BY CONVERT(VARCHAR(7), create_date, 120), COALESCE(transfer_to, owner_id), type_job)

SELECT j.cdate,
		LEFT(cdate, 4) 'YY', 
		FORMAT(DATEFROMPARTS(LEFT(cdate, 4), CONVERT(INT, RIGHT(j.cdate, 2)), 1), 'MMM', 'en-US') 'MM',
		j.WIM, 
		j.CIM, 
		j.CID,
		DATEDIFF(DAY,DATEADD(DAY,1,EOMONTH(DATEADD(M,-1,@date_value))),@date_value)+1 workday,
		[dbo].[fn_CountHoliday](DATEADD(DAY,1,EOMONTH(DATEADD(M,-1,@date_value))),@date_value)  holiday,
		[dbo].[fn_get_leave_data] (j.emp_id,DATEADD(DAY,1,EOMONTH(DATEADD(M,-1,@date_value))),@date_value,null) leaveday,
		j.type_job, 
		e.fullname,
		DENSE_RANK() OVER (ORDER BY fullname) ord
		INTO #temp
FROM job j
     left JOIN tbm_employee e ON e.user_Id=j.emp_id 
WHERE j.cdate=CONVERT(VARCHAR(7), @date_value, 120) --- comment for all ,uncomment for cuurent month
ORDER BY emp_id


--SELECT 
--ord,
--yy,
--MM,
--cdate,
--fullname,
--type_job,
--CIM AS closed_in_month,
--WIM AS Job_pending,
--CID AS closed_in_day,
--CONVERT(DECIMAL(10,3),CASE WHEN cim<=0 THEN 0 ELSE (cim/(workday-holiday-leaveday)) END) Wrate,
--workday,holiday,leaveday,
--workday-holiday-leaveday AS worked_day
--FROM #temp

--return;



SELECT 	ord,
		fullname,
		CONVERT(DECIMAL(10,1),SUM(cim)) cim,
		CONVERT(decimal(10,1),sum(wim)) wim,
		CONVERT(DECIMAL(10,1),SUM(cid)) cid,
		CONVERT(DECIMAL(10,1),AVG(workday-holiday-leaveday)) wday,
		CONVERT(DECIMAL(10,2),SUM(cid/1.00)) wd_rate,
		--CONVERT(DECIMAL(10,2),AVG(CASE WHEN cim<=0 THEN 0 ELSE (cim/(workday-holiday-leaveday)) END)) wm_rate
		CONVERT(DECIMAL(10,2),(SUM(cim))/AVG(workday-holiday-leaveday)) wm_rate
		INTO #temp_sum
FROM #temp
GROUP BY ord,fullname



--SELECT 
--	   ord,
--       cim,
--       wim,
--       cid,	   
--       wd_rate,
--       wm_rate,
--	   wday 
--FROM #temp_sum


DECLARE @mess VARCHAR(MAX)=''
DECLARE @i INT=1
WHILE (@i<=(SELECT MAX(ord) FROM #temp))
begin
DECLARE @temp VARCHAR(MAX)
SELECT @temp=(SELECT 
		(SELECT TOP 1 'Teachnician : '+fullname FROM #temp WHERE ord=@i FOR XML PATH(''),TYPE) AS 'b',
		(SELECT 'YYYY:MM' AS th,'job type' AS th,'worked day'AS th, 'closed in month ' AS th,'job pending' AS th, 'closed in day'AS th,'daily job rate' AS th,'monthly job rate' AS th FOR XML RAW('tr'), ELEMENTS, TYPE) AS thead,
		(SELECT 
				cdate AS td,
				type_job AS td,
  				(workday-holiday-leaveday) AS td,
				CiM AS td,
				WiM AS td, 
				CID	 AS td, 
				(CID) AS td,
				CONVERT(DECIMAL(10,2),CASE WHEN cim<=0 THEN 0 ELSE (cim/(workday-holiday-leaveday)) END) AS td
				FROM #temp WHERE ord=@i ORDER BY cdate,type_job asc
				FOR XML RAW('tr'), ELEMENTS, TYPE)
				 AS 'tbody',
				(SELECT 
				'Total' AS td,
  				wday AS td,
				cim AS td,
				wim AS td, 
				cid AS td, 
				wd_rate AS td,
				wm_rate AS td
				FROM #temp_sum WHERE ord=@i 
				FOR XML RAW('tr'), ELEMENTS, TYPE)
				 AS 'tbody'
				FOR XML PATH(''), ROOT('table'))
----------------------------------------------------------------------------------------------





		
		SET @temp=CONCAT(REPLACE(@temp,'<table>','<table border=1 width=750px cellspacing="2">'),'</br>')
		SET @temp=REPLACE(@temp,'<th>','<th bgcolor=gray>')
		SET @temp=REPLACE(@temp,'<tr>','<tr align=center>')
		SET @temp=REPLACE(@temp,'<td>Total</td>','<td colspan=2><b>Total</b></td>')


	SET @i=@i+1
	SET @mess=concat(@mess,'<p>',@temp,'</p>')
end		
DECLARE @temp2 VARCHAR(MAX)
SET @temp2=(SELECT 
		(SELECT 'Summary of Job' FOR XML PATH(''),TYPE) AS 'b',
		(SELECT 
			'Technician' AS th,
			'worked day'AS th, 
			'closed in month ' AS th,
			'job pending' AS th, 
			'closed in day'AS th,
			'daily job rate' AS th,
			'monthly job rate' AS th 
			FOR XML RAW('tr'), ELEMENTS, TYPE) AS thead,
		(SELECT 
				fullname AS td,
				wday AS td,
               cim AS td,
               wim AS td,
               cid AS td,
               wd_rate AS td,
               wm_rate AS td
			   FROM #temp_sum s
			   FOR XML RAW('tr'), ELEMENTS, TYPE) AS tbody,
		(SELECT 
				'-Total-' AS td,
               SUM(cim) AS td,
               SUM(wim) AS td,
               SUM(cid) AS td,
               (SELECT CONVERT(DECIMAL(10,2),SUM(cid/1.00)) FROM #temp) AS td,
			   --(SELECT CONVERT(DECIMAL(10,2),(SUM(cim))/SUM(workday-holiday-leaveday))FROM #temp)AS td
			   (SELECT CONVERT(DECIMAL(10,2),(SUM(cim)/SUM(wday))) FROM #temp_sum)AS td
			   FROM #temp_sum s
			   FOR XML RAW('tr'), ELEMENTS, TYPE) AS tbody


			   FOR XML PATH(''), ROOT('table'))
			SET @temp2=CONCAT(REPLACE(@temp2,'<table>','<table border=1 width=750px cellspacing="2">'),'</br>')
		SET @temp2=REPLACE(@temp2,'<th>','<th bgcolor=gray>')
		SET @temp2=REPLACE(@temp2,'<tr>','<tr align=center>')
		SET @temp2=REPLACE(@temp2,'<td>Total</td>','<td colspan=2><b>Total</b></td>')	
		SET @temp2=REPLACE(@temp2,'<b>Summary of Job</b>','<u><b>Sumary of job</b></u>')
		SET @temp2=REPLACE(@temp2,'<td>-Total-</td>','<td colspan=2><b>-Total-</b></td>')
	   

SET @mess=CONCAT(@mess,'<p>',@temp2,'</p>')

DECLARE @to_email VARCHAR(1000)
SELECT @to_email=config_value FROM tbm_config WHERE config_id=12  --delay
SELECT @mess AS 'message',@to_email AS 'tomail'





DROP TABLE #temp
DROP TABLE #temp_sum



END


--EXEC [sp_gen_summary_job_onhand_Email]
GO
/****** Object:  StoredProcedure [dbo].[sp_gen_summary_job_onhand_line]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_gen_summary_job_onhand_line]

AS
BEGIN
DECLARE @date_value DATE=GETDATE();
WITH job AS (SELECT CONVERT(VARCHAR(7), create_date, 120) cdate, COALESCE(transfer_to, owner_id) emp_id, type_job, SUM(CASE WHEN ISNULL(job_status, '')='' THEN 1 ELSE 0 END) 'W', SUM(1) 'A'
             FROM tbt_job_header
             GROUP BY CONVERT(VARCHAR(7), create_date, 120), COALESCE(transfer_to, owner_id), type_job)
SELECT 
		LEFT(cdate, 4) 'YY', 
		FORMAT(DATEFROMPARTS(LEFT(cdate, 4), CONVERT(INT, RIGHT(j.cdate, 2)), 1), 'MMMM', 'en-US') 'MM',
		j.W, 
		j.A, 
		j.type_job, 
		e.fullname
FROM job j
     LEFT JOIN tbm_employee e ON e.user_Id=j.emp_id
WHERE j.cdate=CONVERT(VARCHAR(7), @date_value, 120)
ORDER BY emp_id;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_approve_leave_data]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_approve_leave_data]
	@emp_id INT = NULL
AS
BEGIN


		--SELECT value1 AS 'ประเภทการลา/ปี',
		--	   value4 AS 'จำนวน',
		--	   dbo.fn_get_leave_data(@emp_id, '2023-01-01', '2023-12-31', misc_code) AS 'ใช้แล้ว',
		--	   value4-dbo.fn_get_leave_data(@emp_id, '2023-01-01', '2023-12-31', misc_code) AS 'คงเหลือ'
		--FROM tbm_misc_data
		--WHERE misc_type = 'leave_type';
	IF (@emp_id=0)
		SET @emp_id=NULL


	
	SELECT	l.leave_id,
			m.value1 AS leave_type,
			--l.emp_id,
			e.fullname+' '+e.lastname 'emp_name',
			l.leave_date_from,
			l.leave_date_to,
			CASE WHEN leave_path=1 THEN 'ลาครึ่งวันแรก'
				 WHEN leave_path=2 THEN  'ลาครึ่งวันหลัง'
				 ELSE 'ลาเต็มวัน'
			END AS leave_path,
			l.approve_date,
			l.create_date,
			l.cancel_date,
			CASE WHEN l.cancel_date IS NULL THEN [dbo].[fn_get_leave_data](l.emp_id,l.leave_date_from,l.leave_date_to,l.leave_type) ELSE 0 END 'จำนวนวันลา'


	FROM tbt_leave l
	INNER JOIN tbm_employee e ON e.user_id=l.emp_id
	LEFT JOIN tbm_misc_data m ON m.misc_code=l.leave_type AND m.misc_type='leave_type'
	WHERE (@emp_id IS NULL OR l.emp_id=@emp_id)
	AND l.approve_date IS NULL
	AND (@emp_id IS NULL OR l.emp_id=@emp_id)
	ORDER BY l.create_by desc
	
END

--EXEC sp_get_approve_data 1
--SELECT dbo.fn_get_leave_data(1,'2023-01-01','2023-12-31',1)

GO
/****** Object:  StoredProcedure [dbo].[sp_get_leave_data]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_leave_data]
	@emp_id INT = NULL
AS
BEGIN


		SELECT value1 AS 'ประเภทการลา/ปี',
			   value4 AS 'จำนวน',
			   dbo.fn_get_leave_data(@emp_id, '2023-01-01', '2023-12-31', misc_code) AS 'ใช้แล้ว',
			   value4-dbo.fn_get_leave_data(@emp_id, '2023-01-01', '2023-12-31', misc_code) AS 'คงเหลือ'
		FROM tbm_misc_data
		WHERE misc_type = 'leave_type';



	
	SELECT	l.leave_id,
			m.value1 AS leave_type,
			--l.emp_id,
			e.fullname+' '+e.lastname 'emp_name',
			l.leave_date_from,
			l.leave_date_to,
			CASE WHEN leave_path=1 THEN 'ลาครึ่งวันแรก'
				 WHEN leave_path=2 THEN  'ลาครึ่งวันหลัง'
				 ELSE 'ลาเต็มวัน'
			END AS leave_path,
			l.approve_date,
			l.create_date,
			l.cancel_date,
			CASE WHEN l.cancel_date IS NULL THEN [dbo].[fn_get_leave_data](l.emp_id,l.leave_date_from,l.leave_date_to,l.leave_type) ELSE 0 END 'จำนวนวันลา'


	FROM tbt_leave l
	INNER JOIN tbm_employee e ON e.user_id=l.emp_id
	LEFT JOIN tbm_misc_data m ON m.misc_code=l.leave_type AND m.misc_type='leave_type'
	WHERE (@emp_id IS NULL OR l.emp_id=@emp_id)
	AND cancel_by IS NULL
	ORDER BY l.create_by desc
	
END

--EXEC sp_get_leave_data 1
--SELECT dbo.fn_get_leave_data(1,'2023-01-01','2023-12-31',1)

GO
/****** Object:  StoredProcedure [dbo].[sp_get_leaveType]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_leaveType]

AS
BEGIN
	SELECT 
		misc_code
		,value1 
		FROM tbm_misc_data
	WHERE misc_type='leave_type'
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_movement_sparepart]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[sp_get_movement_sparepart]
	@part_id INT=NULL
AS
BEGIN

IF @part_id IS NOT NULL
	SELECT * FROM dbo.fn_get_movement(@part_id) 
	ORDER BY create_date_ord ASC
ELSE 

BEGIN

		DECLARE @table AS TABLE
		(
			part_id INT,
			part_no VARCHAR(500),
			part_name VARCHAR(500),
			total DECIMAL(12,2),
			create_date VARCHAR(10),
			Stock_type VARCHAR(100),
			fullname VARCHAR(500),
			Job_number VARCHAR(50),
			location_id VARCHAR(3)

		)

		SELECT part_id,ROW_NUMBER() OVER (ORDER BY part_id ASC) ord INTO #temp FROM tbm_sparepart
		DECLARE @row INT=1
		WHILE(@row<=(SELECT MAX(ord) FROM #temp))
		BEGIN
						DECLARE @pid INT =NULL
						SELECT @pid=part_id FROM #temp WHERE ord=@row

			INSERT INTO @table 
			SELECT 
				part_id,
				part_no,
				part_name,
				total,
				create_date,
				Stock_type,
				fullname,
				Job_number,
				location_id			 
			FROM dbo.fn_get_movement(@pid) 
			SET @row=@row+1
		END
		DROP TABLE #temp
		SELECT * FROM @table
END

		
 
 	
END



--exec [sp_get_movement_sparepart] 390





GO
/****** Object:  StoredProcedure [dbo].[sp_get_part_type]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_part_type]

AS
BEGIN
		declare @part_type table
		(
			part_type_name varchar(50),
			part_type_value varchar(2)
		)

		insert @part_type
		select 'Normal Part','00'

		insert @part_type
		select 'Dummy Part','01'

		select * from @part_type
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_report_export]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_report_export]
	@id INT =NULL
AS
BEGIN
		SELECT report_id,report_name,report_store,report_param 
		FROM [dbo].[tbm_report_excel] 
		WHERE active_flag=1
		AND (@id IS NULL OR report_id=@id)
END
--exec sp_get_report_export 1
GO
/****** Object:  StoredProcedure [dbo].[sp_get_running_no]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_running_no]
	@running_type INT,
	@running_no VARCHAR(30) OUTPUT
AS
BEGIN
	DECLARE @gen_doc_no			[VARCHAR](50)	
	DECLARE @prefix				[VARCHAR](50);
	DECLARE @affix				[VARCHAR](50);
	DECLARE @length				[INT];
	DECLARE @max_running		[BIGINT];
	DECLARE @period				[DATETIME]	= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 
	DECLARE @description		[VARCHAR](1000)

	SELECT	@prefix			= prefix
			,@affix			= affix
			,@length		= [length]
			,@description	= [description]
	FROM	tbm_running_no_prefix
	WHERE	running_type = @running_type;

	IF NOT EXISTS(SELECT * FROM tbm_running_no WHERE running_type=@running_type AND period=@period)		
		INSERT INTO tbm_running_no(running_type,[period], prefix,affix,running_no,[length])  
		SELECT  
		running_type	AS running_type
		, @period		AS [period]
		, prefix		AS prefix
		, affix			AS affix
		, 0				AS running_no
		, [length]		AS [length]	
		FROM tbm_running_no_prefix   
		WHERE running_type = @running_type  

		SELECT @max_running = ISNULL(MAX(running_no),0)+1 FROM tbm_running_no WHERE running_type = @running_type AND period = @period
		SET @prefix=REPLACE(@prefix,'yy',RIGHT(YEAR( GETDATE()),2))
		SET @prefix=REPLACE(@prefix,'mm',RIGHT('0'+ CONVERT(VARCHAR,MONTH( GETDATE())),2))
		--PRINT @prefix
		SET @prefix=@prefix+FORMAT(@max_running,REPLICATE('0',@length))

		UPDATE tbm_running_no
		SET running_no=@max_running
		WHERE running_type=@running_type AND period=@period;

		SELECT @running_no=@prefix;
END





GO
/****** Object:  StoredProcedure [dbo].[sp_get_tbm_employee_data]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_tbm_employee_data]

AS
BEGIN
	SELECT 0 AS emp_id,'ALL' AS emp_name,'ALL' AS position_description
	UNION ALL
	SELECT USER_ID AS emp_id,fullname+' '+lastname AS emp_name,ep.position_description
	FROM tbm_employee e
	LEFT JOIN tbm_employee_position ep ON e.position=ep.position_code
	WHERE e.STATUS=1 AND ep.status=1
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_tbm_job_data]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_tbm_job_data]
	@owner_id INT=NULL
AS
BEGIN
	IF (@owner_id IS NOT NULL)
	begin
		IF EXISTS(SELECT user_id FROM tbm_employee WHERE user_id=@owner_id AND position IN ('CK','MG'))
			SET @owner_id=NULL
        
	END

       	SELECT					[job_id]
                                ,type_job
                                ,jh.[license_no]
                                ,jh.[customer_id]
	                            ,CONCAT(cus.fname,' ',cus.lname)AS cus_fullname
                                ,[summary]
                                ,[action]
                                ,[result]
                                ,[transfer_to]
                                ,[fix_date]
                                ,[close_date]
                                ,[email_customer]
                                ,[invoice_no]
                                ,[owner_id]
	                            ,CONCAT(emp.fullname,' ',emp.lastname) AS emp_fullname
                                ,jh.[create_by]
                                ,jh.[create_date]
                                ,jh.[update_by]
                                ,jh.[update_date]
                                ,[ref_hjob_id]
                FROM [dbo].[tbt_job_header] jh
                INNER JOIN [dbo].[tbm_customer] cus ON jh.customer_id =cus.customer_id
                INNER JOIN [dbo].[tbm_employee] emp ON emp.user_id= COALESCE(jh.transfer_to,jh.owner_id) 
                WHERE (jh.status =1 AND close_date IS NULL)
				AND (@owner_id IS NULL OR COALESCE(transfer_to,owner_id)=@owner_id)   ---- ถ้าเป็น admin,manager owner_id=NULL
				AND  ((fix_date IS NULL AND @owner_id IS NOT NULL) OR (@owner_id IS NULL)) ----ถ้า close แล้วช่างไม่เห็น

END


--EXEC [dbo].[sp_get_tbm_job_data] null
GO
/****** Object:  StoredProcedure [dbo].[sp_get_tbm_job_data_close]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_tbm_job_data_close]
	@owner_id INT=NULL
AS
BEGIN
	IF (@owner_id IS NOT NULL)
	begin
		IF EXISTS(SELECT user_id FROM tbm_employee WHERE user_id=@owner_id AND position IN ('CK','MG'))
			SET @owner_id=NULL
        
	END

       	SELECT					[job_id]
                                ,type_job
                                ,jh.[license_no]
                                ,jh.[customer_id]
	                            ,CONCAT(cus.fname,' ',cus.lname)AS cus_fullname
                                ,[summary]
                                ,[action]
                                ,[result]
                                ,[transfer_to]
                                ,[fix_date]
                                ,[close_date]
                                ,[email_customer]
                                ,[invoice_no]
                                ,[owner_id]
	                            ,CONCAT(emp.fullname,' ',emp.lastname) AS emp_fullname
                                ,jh.[create_by]
                                ,jh.[create_date]
                                ,jh.[update_by]
                                ,jh.[update_date]
                                ,[ref_hjob_id]
                FROM [dbo].[tbt_job_header] jh
                INNER JOIN [dbo].[tbm_customer] cus ON jh.customer_id =cus.customer_id
                INNER JOIN [dbo].[tbm_employee] emp ON emp.user_id= COALESCE(jh.transfer_to,jh.owner_id) 
                --WHERE jh.status =1
				 WHERE (jh.status =1 AND jh.close_date IS NOT NULL)
				AND (@owner_id IS NULL OR COALESCE(transfer_to,owner_id)=@owner_id)   ---- ถ้าเป็น admin,manager owner_id=NULL
				AND  ((fix_date IS NULL AND @owner_id IS NOT NULL) OR (@owner_id IS NULL)) ----ถ้า close แล้วช่างไม่เห็น
				

END


GO
/****** Object:  StoredProcedure [dbo].[sp_get_tbm_job_data_detail]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_tbm_job_data_detail]
		@job_id VARCHAR(10) 
AS
BEGIN
	SET NOCOUNT ON;
	--=======================Header====================--
;with l as (
	select license_no,model_no,row_number() over (partition by license_no order by seq desc) ord 
	from tbm_vehicle
 )
	SELECT  [job_id],type_job,hd.job_status
      ,hd.license_no
      ,hd.customer_id
	  ,concat(tc.fname,' ',tc.lname) customer_name
      ,[summary]
      ,[action]
      ,[result]
      ,[transfer_to]
      ,[fix_date]
      ,[close_date]
      ,[email_customer]
      ,[invoice_no]
      ,[owner_id]
	  ,CONCAT(te.fullname,' ',te.lastname) owner_name
      ,hd.create_by
      ,hd.create_date
      ,hd.update_by
      ,hd.update_date
      ,[ref_hjob_id]
      ,hd.status
	  ,hd.receive_date
	  ,hd.travel_date
	  ,hd.job_date
	  ,l.model_no
 FROM [tbt_job_header] hd
 INNER JOIN [tbm_customer] tc on hd.customer_id =tc.customer_id 
 INNER JOIN[tbm_employee] te on hd.owner_id =te.user_id
 LEFT  JOIN l on l.license_no=hd.license_no and l.ord=1
 where job_id =@job_id 
 AND hd.STATUS =1
 --=======================Job Detail====================--
 SELECT [bjob_id]
      ,[B1_model]
      ,[B1_serial]
      ,[B1_amp_hrs]
      ,[B1_date_code]
      ,[B1_spec_gravity]
      ,[B1_volt_static]
      ,[B1_volt_load]
      ,[B2_model]
      ,[B2_serial]
      ,[B2_amp_hrs]
      ,[B2_date_code]
      ,[B2_spec_gravity]
      ,[B2_volt_static]
      ,[B2_volt_load]
      ,[CD_manufact]
      ,[CD_model]
      ,[CD_serial]
      ,Case
	  WHEN CD_tag_date is null THEN
	  ''
	  ELSE
	  concat( convert(varchar(2), FORMAT(CD_tag_date,'dd')),'/',convert(varchar(2), FORMAT(CD_tag_date,'MM') ),'/',convert(varchar, year(CD_tag_date) +543)) 
		END AS CD_tag_date
      ,[H_meter]
      ,[V_service_mane]
      ,[V_labour]
      ,[V_travel]
      ,[V_total]
      ,[failure_code]
      ,[fair_wear]
       FROM [dbo].[tbt_job_detail]
       where bjob_id =@job_id
 --=======================Check List====================--

	    SELECT	[ckjob_id]
				,[ck_id]
				,[description]
				,'Y' AS check_list
        FROM [dbo].[tbt_job_checklist]
        where ckjob_id =@job_id
 --=======================job part====================--
		SELECT  [pjob_id]
			  ,[seq]
			  ,spar.[part_no]
			  ,jpar.part_id
			  ,[part_name]
			  ,[part_desc]
			  ,[part_type]
			  ,m.value1 part_type_desc
			  ,[total]
			  ,jpar.[create_date]
			  ,jpar.[create_by]
			  ,jpar.[status]
			  ,ls.location_name
		  FROM [dbo].[tbt_job_part] jpar
		  INNER JOIN [dbo].[tbm_sparepart] spar on jpar.part_id =spar.part_id
		  LEFT JOIN tbm_misc_data m on m.misc_code=spar.part_type AND m.misc_type='part_type'
		  LEFT JOIN tbm_location_store ls ON ls.location_id=spar.location_id
		  WHERE jpar.status =1
		  AND jpar.pjob_id =@job_id

--=======================job images====================--
		SELECT [ijob_id]
      ,[seq]
      ,[img_name]
	  ,imt.image_description
      ,[img_path]
      ,[create_date]
      ,[create_by]
      ,im.[status]
      ,[image_type]
  FROM [dbo].[tbt_job_image] im
  INNER JOIN  [dbo].tbm_image_type imt ON im.image_type =imt.image_code
  WHERE imt.status= 1
  AND im.status= 1
  and im.ijob_id =@job_id

--EXEC sp_get_tbm_job_data_detail 'BD2290004'


END


GO
/****** Object:  StoredProcedure [dbo].[sp_get_tbm_sparepart]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_tbm_sparepart] 
	@P_part_no VARCHAR(100)=NULL,
	@P_location_id VARCHAR(3)=NULL,
	@P_job_id VARCHAR(10)=NULL
	WITH RECOMPILE
AS
BEGIN
SELECT [part_id],
       [part_no],
       [part_name],
       [part_desc],
       [part_type],
	   m.value1 AS part_type_desc,
       p.[cost_price],
       p.[sale_price],
       p.unit_code,
	   u.unit_name,
	   p.part_weight,
       dbo.fn_get_onhand(part_id,@P_job_id) part_value,
       [minimum_value],
       [maximum_value],
       p.[location_id],
	   lo.location_name,
	   CASE WHEN p.parent_id IS NULL THEN NULL ELSE p.ref_group END ref_group,
	   CASE WHEN p.parent_id IS NULL THEN NULL ELSE p.ref_other END ref_other,
       p.[create_date],
       p.[create_by],
       [cancel_date],
       [cancel_by],
       [cancel_reason],
       p.[update_date],
       p.[update_by]
FROM [dbo].[tbm_sparepart] p
LEFT JOIN tbm_location_store lo ON p.location_id=lo.location_id AND status=1 
LEFT JOIN tbm_unit u ON u.unit_code=p.unit_code
LEFT JOIN tbm_misc_data m ON m.misc_code=p.part_type AND m.misc_type='part_type'
WHERE   (
          @P_part_no IS NULL
          OR CONCAT([part_no],'(',part_id,')') LIKE '%'+LTRIM(RTRIM(@P_part_no)) +'%')
AND ( @P_location_id IS NULL  OR p.location_id LIKE '%'+LTRIM(RTRIM(@P_location_id))+'%')
AND (cancel_date IS NULL)
ORDER BY part_no ASC,p.location_id 


--exec sp_get_tbm_sparepart @P_location_id='L01'


END


GO
/****** Object:  StoredProcedure [dbo].[sp_get_tbm_sparepart_detail]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_get_tbm_sparepart_detail] 
	@P_part_id int
AS
BEGIN
		SELECT 
		part_no,
		part_name ,
		 dbo.fn_get_onhand(part_id,NULL) part_value ,
		part_desc,
		minimum_value ,
		maximum_value ,
		cost_price		,
		sale_price		,
		unit_code	,
		ISNULL(part_weight,0) AS part_weight,
		location_id,
		CONCAT((SELECT config_value FROM [tbm_config] WHERE config_key='path_image'),part_no,'.png') AS path_image		
		FROM tbm_sparepart
		WHERE part_id=@P_part_id

		--exec sp_tbm_sparepart_detail 3
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_tbm_vehicle]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_tbm_vehicle]

		@license_no varchar(20)=NULL,
		@seq int=NULL,
		@brand_no varchar(50)=NULL,
		@model_no varchar(50)=NULL,
		@chassis_no varchar(50)=NULL,
		@Color varchar(50)=NULL,
		@seffective_date datetime=NULL,
		@eeffective_date datetime=NULL,
		@sexpire_date datetime=NULL,
		@eexpire_date datetime=NULL,
		@service_price decimal(12,2)=NULL,
		@service_no varchar(4)=NULL,
		@contract_no varchar(20)=NULL,
		@customer_name VARCHAR(50)=NULL,
		@Customer_id INT=NULL ---- เด๋วค่อยเอาออกตอนแก้เส็ดแล้ววว เปลี่ยนเป็น customer_name แทน
AS
BEGIN
		with v as 
		(
			SELECT  
				ROW_NUMBER() over (partition by license_no order by seq desc) ord
			  ,license_no
			  ,seq
			  ,brand_no
			  ,br.brand_name_tha
			  ,model_no
			  ,chassis_no
			  ,Color
			  ,effective_date
			  ,expire_date
			  ,service_price
			  ,v.service_no
			  ,s.services_name
			  ,contract_no
			  ,cus.customer_id
			  ,CONCAT(cus.fname,' ',cus.lname) customer_name
			  ,v.contract_type
			  ,ct.contract_type_name
			  ,v.std_pmp
			  ,v.employee_id
		  FROM [dbo].[tbm_vehicle] v
		  INNER JOIN [dbo].[tbm_services] s on s.services_no =v.service_no
		  INNER JOIN [dbo].[tbm_customer] cus on cus.customer_id =v.customer_id
		  LEFT JOIN  [dbo].[tbm_brand] br on br.brand_code =v.brand_no 
		  LEFT JOIN [dbo].[tbm_contract_type] ct on ct.contract_type_id =v.contract_type
		  WHERE s.status =1
		  and v.active_flag=1
		  )
		  select 
			license_no,
			seq,
			brand_no,
			brand_name_tha,
			model_no,
			chassis_no,
			Color,
			concat( convert(varchar(2), FORMAT(effective_date,'dd')),'/',convert(varchar(2), FORMAT(effective_date,'MM') ),'/',convert(varchar, year(effective_date) +543)) effective_date,
			concat( convert(varchar(2), FORMAT(expire_date,'dd')),'/',convert(varchar(2), FORMAT(expire_date,'MM') ),'/',convert(varchar, year(expire_date) +543)) expire_date,
			service_price,
			service_no,
			services_name,
			contract_no,
			contract_type,
			contract_type_name,
			customer_id,
			std_pmp,
			employee_id,
			v.customer_name
			 from v where 
			 ord=1
			 and (@license_no is null or v.license_no LIKE '%'+@license_no+'%')
			 and (@seq is null or v.seq=@seq)
			 and (@brand_no is null or v.brand_no=@brand_no)
			 and (@model_no is null or v.model_no=@model_no)
			 and (@chassis_no is null or v.chassis_no=@chassis_no)
			 and (@Color is null or lower(convert(varchar,v.Color))=lower(@Color))
			 and (@service_no is null or v.service_no=@service_no)
			 and (@contract_no is null or v.contract_no=@contract_no)
			 and (@customer_name is null or v.customer_name LIKE '%'+@customer_name+'%')
			 and (@service_price is null or v.service_price=@service_price)
			 and (
					(@seffective_date is null or v.effective_date between @seffective_date AND @eeffective_date )
					and
					(@sexpire_date is null or v.expire_date between @sexpire_date AND @eexpire_date)
				)

		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_tbt_adj_sparepart]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_tbt_adj_sparepart]
	@P_part_no VARCHAR(100)=NULL,
	@P_adj_type INT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT  sp.[part_id]    
      ,sp.[part_no]
      ,[part_name]
      ,[part_desc]
	  ,ISNULL(sp.part_value,0) part_value
	  ,SUM([adj_part_value]) AS adj_part_value
	  ,(select top 1 create_date from [tbt_adj_sparepart] where  part_id = sp.[part_id] AND @P_adj_Type IS NULL OR adj_type=@P_adj_Type
	  )create_date
	 , (
		 select TOP 1 CONCAT(e.fullname,' ', e.lastname) from [tbt_adj_sparepart] m
		 INNER JOIN dbo.tbm_employee e on e.user_id =m.create_by
		 where  part_id =sp.[part_id]		
	  )create_by
  FROM [tbm_sparepart] sp
  INNER join [tbt_adj_sparepart] adj
  ON adj.part_id =sp.part_id
  WHERE (@P_part_no IS NULL OR  sp.part_no LIKE '%'+ @P_part_no +'%') 
		AND
		(@P_adj_Type IS NULL OR adj_type=@P_adj_Type)
  GROUP BY  sp.[part_id]
      ,sp.[part_no]
      ,[part_name]
      ,[part_desc]
	  ,sp.part_value
END




GO
/****** Object:  StoredProcedure [dbo].[sp_get_tbt_adj_sparepart_detail]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_tbt_adj_sparepart_detail]
		@part_id INT=NULL,
		@adj_part INT=NULL
AS
BEGIN
	WITH dt AS (
	SELECT ROW_NUMBER() OVER (PARTITION BY p.part_id ORDER BY adj.create_date ASC) ord,
			adj.adj_id,
			p.part_name,
			p.part_desc,
			p.part_value,
			adj_part_value,
			adj.create_by,
			adj.create_date,
			adj.cancel_by,
			adj.cancel_date,
			p.part_id,
			p.part_no,
			CASE WHEN adj.adj_type=1 THEN CONCAT('STI : ',ISNULL(adj.remark,'')) 
				 WHEN adj.adj_type=-1 THEN CONCAT('STO : ',ISNULL(adj.remark,'')) 
				 ELSE CONCAT('ADJ : ',ISNULL(adj.remark,''))
			END AS remark
	FROM tbt_adj_sparepart adj
	LEFT JOIN tbm_sparepart p ON p.part_id=adj.part_id
	WHERE adj.cancel_date IS NULL
    AND (@part_id IS NULL OR p.part_id=@part_id)
	)
	SELECT 
		dt.ord,
		dt.adj_id,
		dt.part_name,
		dt.part_desc,
		ISNULL(dt.part_value,0)+ISNULL((SELECT SUM(adj_part_value) FROM dt WHERE ord<=dt2.ord AND dt.cancel_date IS NULL AND part_id=dt2.part_id),0)-ISNULL(dt.adj_part_value,0) 'part_value',
		ISNULL(dt.part_value,0)+ISNULL((SELECT SUM(adj_part_value) FROM dt WHERE ord<=dt2.ord AND dt.cancel_date IS NULL AND part_id=dt2.part_id),0) 'Total',
		dt.adj_part_value,
		dt.create_date,
		dt.part_id,
		dt.part_no,
		dt.remark
	FROM dt 
	LEFT JOIN dt dt2 ON dt2.ord=dt.ord AND dt.part_id=dt2.part_id
	AND (@part_id IS NULL OR dt.part_id=@part_id)
	


END


GO
/****** Object:  StoredProcedure [dbo].[sp_get_unit]    Script Date: 21/09/2566 22:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_unit]

AS
BEGIN
	select unit_name,unit_code
	 from tbm_unit
END
GO
/****** Object:  StoredProcedure [dbo].[sp_getReportDownTime]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_getReportDownTime]
(
	@createfrm		DATETIME=NULL,
	@createto		DATETIME=NULL,
	@fix_datefrm	DATETIME=NULL,
	@fix_dateto		DATETIME=NULL,
	@closefrom		DATETIME=NULL,
	@closeto		DATETIME=NULL,
	@license_no	VARCHAR(100)=NULL,
	@type_job		VARCHAR(2)=NULL,
	@Teachnicial	INT=NULL,
	@customer_name	VARCHAR(100)=NULL
)
AS
BEGIN
	SELECT 
	cus.fname AS Customer_name,
	cus.address AS Customer_Address,
	jh.job_id 'Serv_call',
	jh.license_no 'Serial_Num',
	'' AS fleet,
	jt.jobdescription,
	jh.summary AS job_description,
	ISNULL(jd.fair_wear,'-') AS 'Fairware',
	jh.create_date log_date,
	jh.fix_date AS complete_date,
	ISNULL(CONVERT(DECIMAL(10,2),(DATEDIFF(HOUR,jh.create_date,jh.fix_date)/24.0)),0.0) 'Total_downtime_day',
	ISNULL(CONVERT(DECIMAL(10,2),(DATEDIFF(MINUTE,jh.create_date,jh.fix_date)/60.0)),0.0) 'Total_downtime_hour',
	e2.user_name AS Tech ,
	e1.user_name AS FSM ,	
	'' AS Note
	FROM tbm_customer cus
	INNER JOIN tbt_job_header jh ON jh.customer_id=cus.customer_id
	INNER JOIN tbt_job_detail jd ON jd.bjob_id=jh.job_id
	LEFT JOIN  tbm_jobtype jt ON jobcode=jh.type_job
	LEFT JOIN  tbm_employee e1 ON e1.user_id=jh.create_by AND e1.status=1
	LEFT JOIN  tbm_employee e2 ON e2.user_id=COALESCE(jh.transfer_to,jh.owner_id) AND e2.status=1
	WHERE jh.job_id IS NOT NULL
    and
	((@createfrm IS NULL OR jh.create_date>=@createfrm) AND (@createto IS NULL OR jh.create_date<=@createto))
	 and
	(@fix_datefrm IS NULL OR CONVERT(DATE,JH.fix_date)>=@fix_datefrm) AND (@fix_dateto IS NULL OR CONVERT(DATE,JH.fix_date)<=@fix_dateto)
	AND
    (@type_job IS NULL OR jh.type_job=@type_job)

		DECLARE @msg VARCHAR(1000)=NULL
	SET @msg=CONCAT('ระบบพบการเรียก Report DownTime !!! [',cast( getdate() as varchar) ,']')
	IF (DB_NAME()='ISEE')
	begin
		DECLARE @token VARCHAR(1000)='WwffLgfoEnLkP0ahspONOmqNhfy1CopGzAZxt3WpAJD'
		EXEC sp_sendmsg_line @msg,@token
	end

END

---exec sp_getReportDownTime @createfrm='2022-09-01',@createto='2022-09-30',@type_job='PM'
GO
/****** Object:  StoredProcedure [dbo].[sp_getReportJob]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_getReportJob]
	@createfrm		DATETIME=NULL,
	@createto		DATETIME=NULL,
	@fix_datefrm	DATETIME=NULL,
	@fix_dateto		DATETIME=NULL,
	@closefrom		DATETIME=NULL,
	@closeto		DATETIME=NULL,
	@license_no	VARCHAR(100)=NULL,
	@type_job		varchar(2)=NULL,
	@Teachnicial	INT=NULL,
	@customer_name	VARCHAR(100)=NULL
AS
BEGIN
	SELECT JH.job_id
	  ,JH.[create_date]
	  ,jH.receive_date AS 'receive_date_time'
	  ,jh.travel_date AS 'start_travel_date_time'
	  ,jh.job_date AS 'start_job_date_time'
	  ,ISNULL(CONVERT(DECIMAL(10,2),(DATEDIFF(HOUR,jh.create_date,jh.receive_date)/24.0)),0.0) 'reponse_day'
	  ,ISNULL(CONVERT(DECIMAL(10,2),(DATEDIFF(MINUTE,jh.create_date,jh.receive_date)/24.0)),0.0) 'reponse_hour'
	  ,ISNULL(CONVERT(DECIMAL(10,2),(DATEDIFF(HOUR,jh.travel_date,jh.job_date)/24.0)),0.0) 'travel_day'
	  ,ISNULL(CONVERT(DECIMAL(10,2),(DATEDIFF(MINUTE,jh.travel_date,jh.job_date)/24.0)),0.0) 'travel_hour'
      ,JH.[license_no]
	  ,(select CONCAT(fullname,' ',lastname) from [ISEE_DEV].[dbo].[tbm_employee] where user_id = JH.[create_by]) as [create_by]
      ,CONCAT(emp.fullname,' ',emp.lastname)AS employeename
      ,JH.[summary]
	  ,JH.[fix_date]
	  ,JH.[close_date]
	  ,CONCAT(cus.fname,' ',cus.lname) customername
	  ,ISNULL([invoice_no],'N/A') invoice_no
	  ,Jt.jobdescription
	  ,(select CONCAT(fullname,' ',lastname) from [dbo].[tbm_employee] where user_id = COALESCE(JH.transfer_to,JH.[owner_id])) AS owner_id
	  ,JH.type_job
	  ,CONVERT(DECIMAL(10,2),(DATEDIFF(HOUR,jh.create_date,jh.fix_date)/24.0)) 'downtime_day'
	  ,CONVERT(DECIMAL(10,2),(DATEDIFF(MINUTE,jh.create_date,jh.fix_date)/60.0)) 'downtime_hour'
      , (select top 1 seq from [dbo].[tbt_job_image] where status =1 and image_type ='rpt') seq
  FROM [dbo].[tbt_job_header] JH
  INNER JOIN [dbo].[tbm_employee] emp ON emp.user_id = COALESCE(JH.transfer_to,JH.[owner_id])
  INNER JOIN .[dbo].[tbm_customer] cus ON CUS.customer_id =JH.customer_id
  INNER JOIN [dbo].[tbm_jobtype] Jt ON JT.jobcode =jh.type_job 
 -- INNER JOIN [ISEE_DEV].[dbo].[tbt_job_image] img ON img.ijob_id =JH.job_id 
WHERE (@createfrm IS NULL OR CONVERT(DATE,JH.create_date)>=@createfrm) AND (@createto IS NULL OR CONVERT(DATE,JH.create_date)<=@createto)
	  AND
     (@fix_datefrm IS NULL OR CONVERT(DATE,JH.fix_date)>=@fix_datefrm) AND (@fix_dateto IS NULL OR CONVERT(DATE,JH.fix_date)<=@fix_dateto)
	  AND
     (@closefrom IS NULL OR CONVERT(DATE,JH.close_date)>=@closefrom) AND (@closeto IS NULL OR CONVERT(DATE,JH.close_date)<=@closeto)
	 AND 
	 (@customer_name IS NULL OR CONCAT(cus.fname,' ',cus.lname) LIKE '%'+@customer_name +'%')
	 AND (@type_job IS NULL OR JH.type_job=@type_job)

	 
END

--exec sp_getReportJob @customer_name='park'

GO
/****** Object:  StoredProcedure [dbo].[sp_getReportPMP]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_getReportPMP] 
	@date_from DATETIME=NULL,
	@date_to	DATETIME=NULL,
	@customer_id	INT=NULL,
	@license_no VARCHAR(50)=NULL
AS
BEGIN

DECLARE @yy INT=YEAR(GETDATE())
			   
;WITH pmp
AS (SELECT license_no,
           NT,
           MIN(alldates) AS start_range,
           MAX(alldates) AS stop_range
    FROM tbt_reminder
    GROUP BY license_no,
             nt
   )
,veh AS 
(
			SELECT license_no,service_price ,MAX(seq) seq
			FROM tbm_vehicle
			WHERE LEFT(service_no,2)='PM'
			GROUP BY license_no,service_price

)
,job AS 
(
	SELECT 
			ROW_NUMBER() OVER (PARTITION BY jh.license_no ORDER BY jh.create_date) rowx,
			jh.license_no,
			CONVERT(DATE,jh.create_date) create_date ,	
			CONVERT(DATE,jh.close_date) close_date,	
			jh.job_id,	
			CONVERT(DATE,jh.fix_date) fix_date,
			jh.invoice_no,
			jd.*,
			e.fullname+' ' + e.lastname AS 'emp_name'
	FROM tbt_job_header jh
	LEFT JOIN tbt_job_detail jd ON jh.job_id=jd.bjob_id
	LEFT JOIN tbm_employee e ON e.user_id=jh.owner_id
	WHERE  jh.type_job IN ('PM')
),cust AS 
(
	SELECT	c.customer_id,
			c.fname,
			c.lname,
			c.address,
			sd.sub_district_name_tha,
			d.district_name_tha,
			p.province_name_tha,
			c.zip_code
	FROM tbm_customer c
		LEFT JOIN tbm_sub_district sd
			ON sd.sub_district_code = c.sub_district_no
			   AND sd.district_code = c.district_code
		LEFT JOIN tbm_district d
			ON d.district_code = c.district_code
			   AND d.province_code = c.province_code
		LEFT JOIN tbm_province p
			ON p.province_code = c.province_code
			   AND p.status = 1
)
,p_pivot_count AS (
SELECT	veh.license_no,
		DATENAME(mm,pmp.start_range) mnt,
		COUNT(1) AS month_count
		FROM veh
INNER JOIN  pmp ON pmp.license_no=veh.license_no
WHERE  YEAR(pmp.start_range)=@yy
GROUP BY veh.license_no,DATENAME(mm,pmp.start_range)

)
,p_pivot_count_sum AS (
	SELECT license_no,SUM(month_count) AS month_total 
	FROM 
	p_pivot_count
	GROUP BY license_no
)
,p_pivot_price AS (
SELECT	veh.license_no,
		DATENAME(mm,pmp.start_range) mnt,
		ISNULL(COUNT(1),0)*ISNULL(veh.service_price,0.0) AS month_price
		FROM veh
INNER JOIN  pmp ON pmp.license_no=veh.license_no
WHERE  YEAR(pmp.start_range)=@yy
GROUP BY veh.license_no,DATENAME(mm,pmp.start_range),service_price
)
,p_pivot_price_sum AS (
		SELECT license_no,SUM(month_price) month_price_total
		FROM 
		p_pivot_price
		GROUP BY license_no
)
,pivot_count_month AS (
SELECT 
	pvt.license_no,
	ISNULL([JANUARY],0) AS JANUARY,
	ISNULL([FEBRUARY],0) AS FEBRUARY,
	ISNULL([MARCH],0) AS MARCH,
	ISNULL([APRIL],0) AS APRIL,
	ISNULL([MAY],0) AS MAY,
	ISNULL([JUNE],0) AS JUNE,
	ISNULL([JULY],0) AS JULY,
	ISNULL([AUGUST],0) AS AUGUST,
	ISNULL([SEPTEMBER],0) AS SEPTEMBER,
	ISNULL([OCTOBER],0) AS OCTOBER,
	ISNULL([NOVEMBER],0) AS NOVEMBER,
	ISNULL([DECEMBER],0) AS DECEMBER,
	ISNULL(p_pivot_count_sum.month_total,0) AS 'MONTH_TOTAL'
FROM p_pivot_count
PIVOT (SUM(month_count) for [mnt] in ([JANUARY],[FEBRUARY],[MARCH],[APRIL],[MAY],[JUNE],[JULY],[AUGUST],[SEPTEMBER],[OCTOBER],[NOVEMBER],[DECEMBER])
) AS pvt
INNER JOIN p_pivot_count_sum ON p_pivot_count_sum.license_no=pvt.license_no
)
,pivot_sum_month AS (
SELECT 
	pvt.license_no,
	ISNULL([JANUARY],0) AS JANUARY_INVOICE,
	ISNULL([FEBRUARY],0) AS FEBRUARY_INVOICE,
	ISNULL([MARCH],0) AS MARCH_INVOICE,
	ISNULL([APRIL],0) AS APRIL_INVOICE,
	ISNULL([MAY],0) AS MAY_INVOICE,
	ISNULL([JUNE],0) AS JUNE_INVOICE,
	ISNULL([JULY],0) AS JULY_INVOICE,
	ISNULL([AUGUST],0) AS AUGUST_INVOICE,
	ISNULL([SEPTEMBER],0) AS SEPTEMBER_INVOICE,
	ISNULL([OCTOBER],0) AS OCTOBER_INVOICE,
	ISNULL([NOVEMBER],0) AS NOVEMBER_INVOICE,
	ISNULL([DECEMBER],0) AS DECEMBER_INVOICE,
	ISNULL(p_pivot_price_sum.month_price_total,0) AS 'MONTH_TOTAL_INVOICE'
FROM p_pivot_price
PIVOT (SUM(month_price) for [mnt] in ([JANUARY],[FEBRUARY],[MARCH],[APRIL],[MAY],[JUNE],[JULY],[AUGUST],[SEPTEMBER],[OCTOBER],[NOVEMBER],[DECEMBER])
) AS pvt
INNER JOIN p_pivot_price_sum ON p_pivot_price_sum.license_no=pvt.license_no
)
SELECT 	
	veh.license_no AS 'Serial_Number', 
	v.chassis_no AS 'Fleet_Number',
	v.model_no 'Model_code',
	ct.contract_type_name AS 'contract_type',
	v.service_no 'PMP',
	ISNULL(v.std_pmp,0.0) AS 'STD_PMP_TIME',
	cus.fname+ ' '+cus.lname AS 'Customer_Name',
	cus.address 'Site_Address_Line1',
	ISNULL(e.user_name,'-') AS 'PREF_FSR1',
	ISNULL(e.fullname,'-') AS 'PREF_FSR1_NAME',
	'admin' AS 'LAST_CONTACT',
	cus.phone_no AS 'Contact_Phone_Number',
	pcm.JANUARY, pcm.FEBRUARY, pcm.MARCH, pcm.APRIL, pcm.MAY, pcm.JUNE, pcm.JULY, pcm.AUGUST, pcm.SEPTEMBER, pcm.OCTOBER, pcm.NOVEMBER, pcm.DECEMBER, pcm.[MONTH_TOTAL],
	psm.JANUARY_INVOICE, psm.FEBRUARY_INVOICE, psm.MARCH_INVOICE, psm.APRIL_INVOICE, psm.MAY_INVOICE, psm.JUNE_INVOICE, psm.JULY_INVOICE, psm.AUGUST_INVOICE, psm.SEPTEMBER_INVOICE, psm.OCTOBER_INVOICE, psm.NOVEMBER_INVOICE, psm.DECEMBER_INVOICE, psm.[MONTH_TOTAL_INVOICE],
	CONVERT(VARCHAR(10),v.effective_date,103) 'Agree_Start_Date',
	CONVERT(VARCHAR(10),v.expire_date,103) 'Expiry_Date'
FROM veh 
INNER JOIN tbm_vehicle v ON v.license_no=veh.license_no AND v.seq=veh.seq
LEFT JOIN tbm_customer cus ON cus.customer_id=v.customer_id
INNER JOIN tbm_contract_type ct ON ct.contract_type_id=ISNULL(v.contract_type,0)
LEFT JOIN tbm_employee e ON e.user_id=v.employee_id
left JOIN pivot_count_month pcm ON pcm.license_no=veh.license_no
Left JOIN pivot_sum_month psm ON psm.license_no=veh.license_no
WHERE LEFT(v.service_no,2)='PM' 
and (@license_no IS NULL OR RTRIM(LTRIM(veh.license_no))=RTRIM(LTRIM(@license_no)))
AND (GETDATE() BETWEEN v.effective_date AND v.expire_date)
AND (@customer_id IS NULL OR v.customer_id=@customer_id)


ORDER BY veh.license_no,v.service_no ASC

	--DECLARE @msg VARCHAR(1000)=NULL
	--SET @msg=CONCAT('ระบบพบการเรียก Report PMP !!! [',cast( getdate() as varchar) ,']')
	--IF (DB_NAME()='ISEE')
	--begin
	--		DECLARE @token VARCHAR(1000)='m3dNJOqKOn65dJ5Vs3umWIZegQG5x7M12JPCBMFHRx7'
	--		EXEC sp_sendmsg_line @msg,@token
 -- end

	
END

--exec sp_getReportPMP



GO
/****** Object:  StoredProcedure [dbo].[sp_getReportProductive_time]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_getReportProductive_time]
	@flag_year INT=NULL,
	@current_date DATETIME=NULL
AS
BEGIN



	IF @current_date IS NULL---fix for runallyear
	BEGIN
			IF year(GETDATE())<>'2022'
			BEGIN
					DECLARE @tb AS TABLE(
						full_name VARCHAR(100),
						job_in_month INT,
						day_in_month INT,
						holiday_in_month	INT,
						work_actual_in_month	INT,
						leave_in_month		INT,
						day_in_month_leave	INT,
						actual_hour_in_month VARCHAR(100),
						all_hour_in_month	varchar(100),
						range_date	varchar(100)
					)

					DECLARE @v_date DATE='2022-09-01'
					
					WHILE (@v_date<=GETDATE())
					BEGIN
                    INSERT INTO @tb 
					EXEC sp_getReportProductive_time NULL,@v_date
							SET @v_date=DATEADD(M,1,@v_date)
					END
					SELECT full_name,
                           job_in_month,
                           day_in_month,
                           holiday_in_month,
                           work_actual_in_month,
                           leave_in_month,
                           day_in_month_leave,
                           actual_hour_in_month,
                           all_hour_in_month,
                           range_date
						    FROM @tb
			END	

	RETURN;
	END
	IF @flag_year=1 
	BEGIN
		WHILE (@flag_year<=12)
		BEGIN
			DECLARE @year	INT =	YEAR(COALESCE(@current_date,GETDATE()))
			DECLARE @month	INT =	@flag_year
			DECLARE @day	INT =	1
			DECLARE @day_value DATETIME=DATEFROMPARTS(@year,@month,@day)
			-------------------------------------------------------------
			DECLARE @data_result TABLE
			(
				full_name VARCHAR(500),
				job_in_month INT,
				day_in_month INT,
				holiday_in_month INT,
				work_actual_in_month DECIMAL(10,1),
				leave_in_month DECIMAL(10,1),
				day_in_month_leave DECIMAL(10,1),
				actual_hour_in_month VARCHAR(10),
				all_hour_in_month VARCHAR(10),
				range_date VARCHAR(100)
			)
			-------------------------------------------------------------
			INSERT INTO @data_result
			EXEC sp_getReportProductive_time NULL,@day_value
		
			SET @flag_year=@flag_year+1
		END
		SELECT full_name,
               job_in_month,
               day_in_month,
               holiday_in_month,
               work_actual_in_month,
               leave_in_month,
               day_in_month_leave,
               actual_hour_in_month AS 'actual_hour_in_month',
               all_hour_in_month	AS 'all_hour_in_month',
               range_date
			   FROM @data_result

        RETURN;
	END

	DECLARE		@vdate datetime=COALESCE(@current_date,GETDATE())
	DECLARE		@eday date =EOMONTH(@vdate)
	DECLARE		@fday date =@vdate-DAY(@vdate)+1	--FOMONTH
	DECLARE		@nom  INT=DATEDIFF(DAY,@fday,@eday)+1
	DECLARE		@wday INT=@nom-dbo.fn_CountHoliday(@fday,@eday)
	DECLARE		@hour_per_day INT =8


	SELECT ROW_NUMBER() OVER (ORDER BY bjob_id) ord,bjob_id,dbo.fn_cleansep(v_service_mane) AS s_owner
	INTO #temp_multi_owner
	FROM tbt_job_detail d
	INNER JOIN tbt_job_header h ON h.job_id=d.bjob_id
	WHERE v_service_mane IS NOT NULL
	AND dbo.fn_cleansep(v_service_mane) LIKE '%|%'
	AND h.fix_date BETWEEN @fday AND @eday


		

	
--	;WITH wdata AS (
--	SELECT jh.job_id,
--			jd.v_service_mane,
--			LOWER(e.fullname +' '+e.lastname) AS full_name,
--			ISNULL(jd.v_total,0.0) w_hour,
--			jh.create_date,
--			e.user_id			 
--	FROM tbt_job_header jh
--	LEFT JOIN tbt_job_detail jd ON jh.job_id=jd.bjob_id
--	LEFT JOIN tbm_employee e ON e.user_id=COALESCE(transfer_to,owner_id)
--	WHERE  jh.fix_date BETWEEN @fday AND @eday


--	),
--gdata AS (
--	SELECT	wdata.full_name,
--			COUNT(full_name) 'job_in_month',
--			@wday 'day_in_month',
--			dbo.fn_CountHoliday(@fday,@eday) 'holiday_in_month',
--			CONVERT(DECIMAL(10,1),SUM(w_hour)) 'work_actual_in_month',
--			dbo.fn_get_leave_data(user_id,@fday,@eday,null) 'leave_in_month',
--			@wday-dbo.fn_get_leave_data(user_id,@fday,@eday,null) 'day_in_month_leave'
--	FROM wdata
--	GROUP BY wdata.full_name,user_id
--)
--SELECT gdata.full_name,
--       gdata.job_in_month,
--       gdata.day_in_month,			--- วันทำงานในเเดือน
--       gdata.holiday_in_month,		---- จำนวนวันหยุด
--       gdata.work_actual_in_month,  ---- การทำงานจริงจาก job ว่ากี่ชม.
--       gdata.leave_in_month,		-----จำนวนวันลาจริง
--       gdata.day_in_month_leave,
--	   CONCAT((CONVERT(INT,work_actual_in_month*60))/60,':',(CONVERT(INT,work_actual_in_month*60))%60) 'actual_hour_in_month', --ทำงานจริงเป็นชม.
--	   CONCAT(CONVERT(INT,(((gdata.day_in_month_leave*@hour_per_day*60))/60)),':',(CONVERT(INT,(((gdata.day_in_month_leave*@hour_per_day)*60)))%60)) 'all_hour_in_month', --วันทำงานจริงเป็นชมลบวันลาด้วย คิดเป็นชมจริงๆต่อเดือน
--	   CONCAT(@fday,' - ',@eday) 'range_date'
--FROM gdata 
--ORDER BY gdata.full_name


-------------------------------------------------

DECLARE @tb_mutlijob  TABLE 
(
	job_id varchar(20),
	user_id int
)

DECLARE @i INT=1
WHILE (@i<=(SELECT MAX(ord) FROM #temp_multi_owner))
BEGIN
	DECLARE @var VARCHAR(20)
	DECLARE @job_id VARCHAR(20)
	
	SELECT	@var=s_owner,
			@job_id=bjob_id
	FROM #temp_multi_owner WHERE ord=@i
	PRINT @var
	INSERT @tb_mutlijob
	SELECT @job_id AS 'Job_id',
			e.user_id
	FROM  dbo.fn_split('|',@var)
	LEFT JOIN tbm_employee e ON e.technician_code=CONVERT(INT,[data]) AND e.technician_code IS NOT NULL

	SET @i=@i+1
END
------------------------------------------------
--SELECT * FROM @tb_mutlijob WHERE user_id=9

;WITH wdata_s AS (
	SELECT 
			jh.job_id,
			LOWER(e.fullname +' '+e.lastname) AS full_name,
			jd.V_service_mane,
			ISNULL(jd.v_labour,0) v_labour,
			ISNULL(jd.v_travel,0) v_travel,
			ISNULL(jd.v_total,0.0) w_hour,
			jh.create_date,
			e.user_id 
	FROM tbt_job_header jh
	LEFT JOIN tbt_job_detail jd ON jh.job_id=jd.bjob_id
	LEFT JOIN tbm_employee e ON e.user_id=COALESCE(transfer_to,owner_id)
	WHERE  jh.create_date BETWEEN @fday AND @eday
	AND jh.job_id NOT IN (SELECT bjob_id FROM #temp_multi_owner)
	
	UNION ALL

		SELECT 
			jh.job_id,
			LOWER(e.fullname +' '+e.lastname) AS full_name,
			jd.V_service_mane,
			ISNULL(jd.v_labour,0) v_labour,
			ISNULL(jd.v_travel,0) v_travel,
			ISNULL(jd.v_total,0.0) w_hour,
			jh.create_date,
			t.user_id 
	FROM tbt_job_header jh
	LEFT JOIN tbt_job_detail jd ON jh.job_id=jd.bjob_id
	INNER JOIN @tb_mutlijob t ON t.job_id=jh.job_id
	LEFT JOIN tbm_employee e ON e.user_id=t.user_id
	),
gdata AS (
	SELECT	wdata_s.full_name,
			COUNT(full_name) 'job_in_month',
			@wday 'day_in_month',
			dbo.fn_CountHoliday(@fday,@eday) 'holiday_in_month',
			CONVERT(DECIMAL(10,1),SUM(w_hour)) 'work_actual_in_month',
			dbo.fn_get_leave_data(user_id,@fday,@eday,null) 'leave_in_month',
			@wday-dbo.fn_get_leave_data(user_id,@fday,@eday,null) 'day_in_month_leave'
	FROM wdata_s
	GROUP BY wdata_s.full_name,wdata_s.user_id
)
SELECT gdata.full_name,
       gdata.job_in_month,
       gdata.day_in_month,			--- วันทำงานในเเดือน
       gdata.holiday_in_month,		---- จำนวนวันหยุด
       gdata.work_actual_in_month,  ---- การทำงานจริงจาก job ว่ากี่ชม.
       gdata.leave_in_month,		-----จำนวนวันลาจริง
       gdata.day_in_month_leave,
	   CONCAT((CONVERT(INT,work_actual_in_month*60))/60,':',(CONVERT(INT,work_actual_in_month*60))%60) 'actual_hour_in_month', --ทำงานจริงเป็นชม.
	   CONCAT(CONVERT(INT,(((gdata.day_in_month_leave*@hour_per_day*60))/60)),':',(CONVERT(INT,(((gdata.day_in_month_leave*@hour_per_day)*60)))%60)) 'all_hour_in_month', --วันทำงานจริงเป็นชมลบวันลาด้วย คิดเป็นชมจริงๆต่อเดือน
	   CONCAT(@fday,' - ',@eday) 'range_date'
FROM gdata
ORDER BY gdata.full_name






DROP TABLE #temp_multi_owner

END
GO
/****** Object:  StoredProcedure [dbo].[sp_getReportRunningCost]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_getReportRunningCost] 
	@createfrm		DATETIME=NULL,
	@createto		DATETIME=NULL,
	@fix_datefrm	DATETIME=NULL,
	@fix_dateto		DATETIME=NULL,
	@closefrom		DATETIME=NULL,
	@closeto		DATETIME=NULL,
	@license_no	VARCHAR(100)=NULL,
	@type_job		varchar(2)=NULL,
	@Teachnicial	INT=NULL,
	@customer_name	VARCHAR(100)=NULL
AS
BEGIN
; with vh AS (
		SELECT ROW_NUMBER() OVER (PARTITION BY license_no ORDER BY seq DESC) ord,license_no,seq,customer_id,model_no,chassis_no 
		FROM tbm_vehicle
	) 
	SELECT license_no,seq,customer_id,model_no,chassis_no   INTO #temp_vehicle
	FROM vh 
	WHERE ord=1

		SELECT	cus.fname					AS	'CUST_NAME',
				ISNULL(vh.license_no,'')	AS	'SERIAL_NUMBER',
				ISNULL(vh.model_no,'')		AS	'MODEL_CODE',
				ISNULL(jh.Job_id,'')		AS	'SJC_NUMBER',
				ISNULL(jh.summary,'')			AS 'JOB_DESC',
				ISNULL(CONVERT(VARCHAR(10),jh.create_date,103),'')	AS 'SJC_DATE',
				ISNULL(jd.fair_wear,'')		AS 'FAIR_WEAR',
				ISNULL(jd.H_meter,'')		AS 'METER_READING',
				ISNULL(jp.part_no,'-')		AS 'ITEM_NUMBER',
				ISNULL(sp.part_name,'-')	    AS 'DESCRIPTION',
				ISNULL(sp.sale_price,0.0)		AS 'SELLING_PRICE',
				ISNULL(jp.total,0)			AS 'QTY',
				CONVERT(DECIMAL(10,2),ISNULL(jp.total,0)*ISNULL(sp.sale_price,0.0)) AS 'TOTAL_SELLING_PRICE',
				ISNULL(sp.cost_price,0.0) AS 'BRANCH_PRICE',
				CONVERT(DECIMAL(10,2),ISNULL(jp.total,0)*ISNULL(sp.cost_price,0.0)) AS 'TOTAL_BRANCH_PRICE',
				ISNULL(vh.chassis_no,'-')	AS	'FLeet',
				cus.address AS 'Job_Location',
				ISNULL(jh.action,'') AS 'SJC_Free_Text_Lines'
		FROM tbm_customer cus
		LEFT JOIN tbt_job_header jh ON jh.customer_id=cus.customer_id and jh.STATUS=1
		LEFT JOIN #temp_vehicle vh ON vh.customer_id=cus.customer_id AND cus.STATUS=1 AND vh.license_no= jh.license_no  
		LEFT JOIN tbt_job_detail jd ON jd.bjob_id=jh.job_id
		LEFT JOIN tbt_job_part jp ON jp.pjob_id=jh.job_id
		LEFT JOIN tbm_sparepart  sp ON sp.part_id=jp.part_id
		WHERE 
		jh.job_id IS NOT NULL 
		and
		(@createfrm IS NULL OR CONVERT(DATE,JH.create_date)>=@createfrm) AND (@createto IS NULL OR CONVERT(DATE,JH.create_date)<=@createto)
	  AND
     (@fix_datefrm IS NULL OR CONVERT(DATE,JH.fix_date)>=@fix_datefrm) AND (@fix_dateto IS NULL OR CONVERT(DATE,JH.fix_date)<=@fix_dateto)
	  AND
     (@closefrom IS NULL OR CONVERT(DATE,JH.close_date)>=@closefrom) AND (@closeto IS NULL OR CONVERT(DATE,JH.close_date)<=@closeto)
	 AND 
	 (@customer_name IS NULL OR CONCAT(cus.fname,' ',cus.lname) LIKE '%'+@customer_name +'%')
	 AND (@type_job IS NULL OR JH.type_job=@type_job)
	
		 	DROP TABLE #temp_vehicle


	DECLARE @msg VARCHAR(1000)=NULL
	SET @msg=CONCAT('ระบบพบการเรียก Report Running Cost !!! [',cast( getdate() as varchar) ,']')
	IF (DB_NAME()='ISEE')
	begin
			DECLARE @token VARCHAR(1000)='WwffLgfoEnLkP0ahspONOmqNhfy1CopGzAZxt3WpAJD'
			EXEC sp_sendmsg_line @msg,@token
	end

END




--exec sp_getReportRunningCost @Customer_name='Mobile Logistics Co.,Ltd.'
GO
/****** Object:  StoredProcedure [dbo].[sp_getReportStock]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_getReportStock] 
	@P_part_no VARCHAR(50)=NULL,
	@P_create_from DATETIME=NULL,
	@P_create_to DATETIME=NULL,
	@P_user_id INT=NULL,
    @p_location_id VARCHAR(3)=NULL

AS
BEGIN
	SELECT 
		sp.part_id,
		sp.part_no,
		sp.part_name,
		sp.part_desc,
		sp.part_type,
		sp.cost_price,
		sp.sale_price,
		sp.part_weight,
		u.unit_code,
		u.unit_name,
		dbo.fn_get_onhand(sp.part_id,NULL) part_value,
		CASE WHEN (adj.adj_type=0 OR adj_type=99)			THEN dbo.fn_get_adjustpart(sp.part_id,adj.adj_id)	ELSE 0 END AS adj_part_value,
		CASE WHEN adj.adj_type=1							THEN dbo.fn_get_stockin(sp.part_id,adj.adj_id)		ELSE 0 END AS Stock_IN,
		CASE WHEN (adj.adj_type=-1 OR adj.adj_type IS NULL) THEN dbo.fn_get_stockout(sp.part_id,adj.adj_id)		ELSE 0 end AS Stock_OUT,
		sp.minimum_value,
		sp.maximum_value,
		lo.location_id,
		lo.location_name,
		CONVERT(VARCHAR(10),sp.create_date,23) create_date,
		(select CONCAT(fullname,' ',lastname) from [dbo].[tbm_employee] where user_id = sp.[create_by] ) as create_by,
		sp.update_date,
		(select CONCAT(fullname,' ',lastname) from [dbo].[tbm_employee] where user_id = sp.[update_by]) as update_by,
		ISNULL(adj.remark,'N/A') AS remark,
		sp.ref_group,
		sp.ref_other,
		CONVERT(VARCHAR(10),adj.create_date,23) AS 'Adj_STOCKINOUT_DATE'
	INTO #TEMP
	FROM tbm_sparepart sp
	LEFT JOIN tbm_location_store lo ON sp.location_id=lo.location_id AND status=1
	LEFT JOIN tbt_adj_sparepart adj ON adj.part_id=sp.part_id AND sp.location_id='L01'
	LEFT JOIN tbm_unit u ON u.unit_code=sp.unit_code
	WHERE (@P_part_no IS NULL OR (CONCAT(sp.part_no, '(',sp.part_id,')') LIKE '%'+ @P_part_no +'%'))
		  AND
		  (@P_location_id IS NULL  OR sp.location_id=@p_location_id)
		  AND
		  (@P_user_id IS NULL OR lo.owner_id=@P_user_id)
		  AND
		  (
		  (@P_create_from IS NULL OR CONVERT(DATE,sp.create_date)>=CONVERT(DATE,@P_create_from))
		  AND 
		  (@P_create_to IS NULL OR CONVERT(DATE,sp.create_date)<=CONVERT(DATE,@P_create_to))
		  )
		--AND sp.cancel_date IS null
	
;WITH PD AS (
	SELECT	t.part_id,
			MAX(t.part_value) part_value,
			SUM(t.adj_part_value) adj_part_value,
			SUM(t.Stock_IN) Stock_IN,
			SUM(t.Stock_OUT) Stock_OUT,
			MAX(t.Adj_STOCKINOUT_DATE) Adj_STOCKINOUT_DATE,
			MAX(t.update_date) update_date,
			(SELECT STUFF
				(
					(
					   SELECT ','+ CONVERT(VARCHAR,remark) FROM #TEMP WHERE part_id=t.part_id AND remark IS NOT null FOR XML PATH('')
					),
					 1, 1, ''
				)) AS remark,
						(SELECT STUFF
				(
					(
					   SELECT ','+ CONVERT(VARCHAR,ref_group) FROM #TEMP WHERE part_id=t.part_id AND ref_group IS NOT null FOR XML PATH('')
					),
					 1, 1, ''
				)) AS ref_group,
										(SELECT STUFF
				(
					(
					   SELECT ','+ CONVERT(VARCHAR,ref_other) FROM #TEMP WHERE part_id=t.part_id AND ref_other IS NOT null FOR XML PATH('')
					),
					 1, 1, ''
				)) AS ref_other
				 

	 FROM #TEMP t
	GROUP BY t.part_id
) 
SELECT 
sp.part_id,
sp.part_no,
sp.part_name,
sp.part_desc,
sp.part_type,
sp.cost_price,
sp.sale_price,
sp.part_weight,
u.unit_code,
u.unit_name,
pd.part_value,
pd.adj_part_value,
pd.Stock_IN,
pd.Stock_OUT,
sp.minimum_value,
sp.maximum_value,
sp.location_id,
lo.location_name,
sp.create_date,
sp.create_by,
Pd.update_date,
sp.update_by,
pd.remark,
pd.ref_group,
pd.ref_other,
pd.Adj_STOCKINOUT_DATE
FROM PD
INNER JOIN tbm_sparepart SP ON sp.part_id=pd.part_id
LEFT JOIN tbm_unit u ON u.unit_code=sp.unit_code
LEFT JOIN tbm_location_store lo ON sp.location_id=lo.location_id AND status=1
	

	--SELECT * FROM #TEMP

	DROP TABLE #TEMP

END



GO
/****** Object:  StoredProcedure [dbo].[sp_init_master_table-]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_init_master_table-]
AS
BEGIN


PRINT '================= Prefix Table==================================='
TRUNCATE TABLE tbm_running_no_prefix;
INSERT into [dbo].[tbm_running_no_prefix]
SELECT 1,'PMyymm','ลักษณะแพ็คเกตตามสัญญาที่ได้ทำไว้กับลูกค้าตาม แพ็คเกตต่างๆ','',4;
INSERT into [dbo].[tbm_running_no_prefix]
SELECT 2,'BDyymm','Brake down ลักษณะการเสียแบบแจ้งซ่อมแซม','',4;
INSERT into [dbo].[tbm_running_no_prefix]
SELECT 3,'WRyymm','ลักษณะ Warantee ตามงานซ่อม หากพบปัญหากลับมา โดยต้อง Ref: ใบงานเก่า','',4;
INSERT into [dbo].[tbm_running_no_prefix]
SELECT 4,'DAyymm','ลักษณะขายอะไหล่บางชนิดให้กับลูกค้า จะไม่ได้ซ่อมอะไรแต่จะมีรายการเพิ่มอะไหล่อย่างเดียว','',4;

PRINT '===================Province Table======================================='
TRUNCATE TABLE tbm_province;
INSERT INTO tbm_province
VALUES
( '01', 'กรุงเทพมหานคร', 1 ), 
( '02', 'สมุทรปราการ', 1 ), 
( '03', 'นนทบุรี', 1 ), 
( '04', 'ปทุมธานี', 1 ), 
( '05', 'พระนครศรีอยุธยา', 1 ), 
( '06', 'อ่างทอง', 1 ), 
( '07', 'ลพบุรี', 1 ), 
( '08', 'สิงห์บุรี', 1 ), 
( '09', 'ชัยนาท', 1 ), 
( '10', 'สระบุรี', 1 ), 
( '11', 'ชลบุรี', 1 ), 
( '12', 'ระยอง', 1 ), 
( '13', 'จันทบุรี', 1 ), 
( '14', 'ตราด', 1 ), 
( '15', 'ฉะเชิงเทรา', 1 ), 
( '16', 'ปราจีนบุรี', 1 ), 
( '17', 'นครนายก', 1 ), 
( '18', 'สระแก้ว', 1 ), 
( '19', 'นครราชสีมา', 1 ), 
( '20', 'บุรีรัมย์', 1 ), 
( '21', 'สุรินทร์', 1 ), 
( '22', 'ศรีสะเกษ', 1 ), 
( '23', 'อุบลราชธานี', 1 ), 
( '24', 'ยโสธร', 1 ), 
( '25', 'ชัยภูมิ', 1 ), 
( '26', 'อำนาจเจริญ', 1 ), 
( '27', 'หนองบัวลำภู', 1 ), 
( '28', 'ขอนแก่น', 1 ), 
( '29', 'อุดรธานี', 1 ), 
( '30', 'เลย', 1 ), 
( '31', 'หนองคาย', 1 ), 
( '32', 'มหาสารคาม', 1 ), 
( '33', 'ร้อยเอ็ด', 1 ), 
( '34', 'กาฬสินธุ์', 1 ), 
( '35', 'สกลนคร', 1 ), 
( '36', 'นครพนม', 1 ), 
( '37', 'มุกดาหาร', 1 ), 
( '38', 'เชียงใหม่', 1 ), 
( '39', 'ลำพูน', 1 ), 
( '40', 'ลำปาง', 1 ), 
( '41', 'อุตรดิตถ์', 1 ), 
( '42', 'แพร่', 1 ), 
( '43', 'น่าน', 1 ), 
( '44', 'พะเยา', 1 ), 
( '45', 'เชียงราย', 1 ), 
( '46', 'แม่ฮ่องสอน', 1 ), 
( '47', 'นครสวรรค์', 1 ), 
( '48', 'อุทัยธานี', 1 ), 
( '49', 'กำแพงเพชร', 1 ), 
( '50', 'ตาก', 1 ), 
( '51', 'สุโขทัย', 1 ), 
( '52', 'พิษณุโลก', 1 ), 
( '53', 'พิจิตร', 1 ), 
( '54', 'เพชรบูรณ์', 1 ), 
( '55', 'ราชบุรี', 1 ), 
( '56', 'กาญจนบุรี', 1 ), 
( '57', 'สุพรรณบุรี', 1 ), 
( '58', 'นครปฐม', 1 ), 
( '59', 'สมุทรสาคร', 1 ), 
( '60', 'สมุทรสงคราม', 1 ), 
( '61', 'เพชรบุรี', 1 ), 
( '62', 'ประจวบคีรีขันธ์', 1 ), 
( '63', 'นครศรีธรรมราช', 1 ), 
( '64', 'กระบี่', 1 ), 
( '65', 'พังงา', 1 ), 
( '66', 'ภูเก็ต', 1 ), 
( '67', 'สุราษฎร์ธานี', 1 ), 
( '68', 'ระนอง', 1 ), 
( '69', 'ชุมพร', 1 ), 
( '70', 'สงขลา', 1 ), 
( '71', 'สตูล', 1 ), 
( '72', 'ตรัง', 1 ), 
( '73', 'พัทลุง', 1 ), 
( '74', 'ปัตตานี', 1 ), 
( '75', 'ยะลา', 1 ), 
( '76', 'นราธิวาส', 1 ), 
( '77', 'บึงกาฬ', 1 );
PRINT '================= district Table==================================='
TRUNCATE TABLE tbm_district;
INSERT INTO tbm_district
VALUES
( '0001', 'พระนคร', '01', '10200', 1 )
INSERT INTO tbm_district
VALUES
( '0002', 'ดุสิต', '01', '10300', 1 )
INSERT INTO tbm_district
VALUES
( '0003', 'หนองจอก', '01', '10530', 1 )
INSERT INTO tbm_district
VALUES
( '0004', 'บางรัก', '01', '10500', 1 )
INSERT INTO tbm_district
VALUES
( '0005', 'บางเขน', '01', '10220', 1 )
INSERT INTO tbm_district
VALUES
( '0006', 'บางกะปิ', '01', '10240', 1 )
INSERT INTO tbm_district
VALUES
( '0007', 'ปทุมวัน', '01', '10330', 1 )
INSERT INTO tbm_district
VALUES
( '0008', 'ป้อมปราบศัตรูพ่าย', '01', '10100', 1 )
INSERT INTO tbm_district
VALUES
( '0009', 'พระโขนง', '01', '10260', 1 )
INSERT INTO tbm_district
VALUES
( '0010', 'มีนบุรี', '01', '10510', 1 )
INSERT INTO tbm_district
VALUES
( '0011', 'ลาดกระบัง', '01', '10520', 1 )
INSERT INTO tbm_district
VALUES
( '0012', 'ยานนาวา', '01', '10110', 1 )
INSERT INTO tbm_district
VALUES
( '0013', 'สัมพันธวงศ์', '01', '10100', 1 )
INSERT INTO tbm_district
VALUES
( '0014', 'พญาไท', '01', '10400', 1 )
INSERT INTO tbm_district
VALUES
( '0015', 'ธนบุรี', '01', '10600', 1 )
INSERT INTO tbm_district
VALUES
( '0016', 'บางกอกใหญ่', '01', '10600', 1 )
INSERT INTO tbm_district
VALUES
( '0017', 'ห้วยขวาง', '01', '10310', 1 )
INSERT INTO tbm_district
VALUES
( '0018', 'คลองสาน', '01', '10600', 1 )
INSERT INTO tbm_district
VALUES
( '0019', 'ตลิ่งชัน', '01', '10170', 1 )
INSERT INTO tbm_district
VALUES
( '0020', 'บางกอกน้อย', '01', '10700', 1 )
INSERT INTO tbm_district
VALUES
( '0021', 'บางขุนเทียน', '01', '10150', 1 )
INSERT INTO tbm_district
VALUES
( '0022', 'ภาษีเจริญ', '01', '10160', 1 )
INSERT INTO tbm_district
VALUES
( '0023', 'หนองแขม', '01', '10160', 1 )
INSERT INTO tbm_district
VALUES
( '0024', 'ราษฎร์บูรณะ', '01', '10140', 1 )
INSERT INTO tbm_district
VALUES
( '0025', 'บางพลัด', '01', '10700', 1 )
INSERT INTO tbm_district
VALUES
( '0026', 'ดินแดง', '01', '10400', 1 )
INSERT INTO tbm_district
VALUES
( '0027', 'บึงกุ่ม', '01', '10230', 1 )
INSERT INTO tbm_district
VALUES
( '0028', 'สาทร', '01', '10120', 1 )
INSERT INTO tbm_district
VALUES
( '0029', 'บางซื่อ', '01', '10800', 1 )
INSERT INTO tbm_district
VALUES
( '0030', 'จตุจักร', '01', '10900', 1 )
INSERT INTO tbm_district
VALUES
( '0031', 'บางคอแหลม', '01', '10120', 1 )
INSERT INTO tbm_district
VALUES
( '0032', 'ประเวศ', '01', '10250', 1 )
INSERT INTO tbm_district
VALUES
( '0033', 'คลองเตย', '01', '10110', 1 )
INSERT INTO tbm_district
VALUES
( '0034', 'สวนหลวง', '01', '10250', 1 )
INSERT INTO tbm_district
VALUES
( '0035', 'จอมทอง', '01', '10150', 1 )
INSERT INTO tbm_district
VALUES
( '0036', 'ดอนเมือง', '01', '10001', 1 )
INSERT INTO tbm_district
VALUES
( '0037', 'ราชเทวี', '01', '10400', 1 )
INSERT INTO tbm_district
VALUES
( '0038', 'ลาดพร้าว', '01', '10230', 1 )
INSERT INTO tbm_district
VALUES
( '0039', 'วัฒนา', '01', '10110', 1 )
INSERT INTO tbm_district
VALUES
( '0040', 'บางแค', '01', '10160', 1 )
INSERT INTO tbm_district
VALUES
( '0041', 'หลักสี่', '01', '10010', 1 )
INSERT INTO tbm_district
VALUES
( '0042', 'สายไหม', '01', '10220', 1 )
INSERT INTO tbm_district
VALUES
( '0043', 'คันนายาว', '01', '10230', 1 )
INSERT INTO tbm_district
VALUES
( '0044', 'สะพานสูง', '01', '10240', 1 )
INSERT INTO tbm_district
VALUES
( '0045', 'วังทองหลาง', '01', '10310', 1 )
INSERT INTO tbm_district
VALUES
( '0046', 'คลองสามวา', '01', '10510', 1 )
INSERT INTO tbm_district
VALUES
( '0047', 'บางนา', '01', '10260', 1 )
INSERT INTO tbm_district
VALUES
( '0048', 'ทวีวัฒนา', '01', '10170', 1 )
INSERT INTO tbm_district
VALUES
( '0049', 'ทุ่งครุ', '01', '10140', 1 )
INSERT INTO tbm_district
VALUES
( '0050', 'บางบอน', '01', '10150', 1 )
INSERT INTO tbm_district
VALUES
( '0051', 'บ้านทะวาย', '01', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0052', 'เมืองสมุทรปราการ', '02', '10270', 1 )
INSERT INTO tbm_district
VALUES
( '0053', 'บางบ่อ', '02', '10550', 1 )
INSERT INTO tbm_district
VALUES
( '0054', 'บางพลี', '02', '10540', 1 )
INSERT INTO tbm_district
VALUES
( '0055', 'พระประแดง', '02', '10130', 1 )
INSERT INTO tbm_district
VALUES
( '0056', 'พระสมุทรเจดีย์', '02', '10290', 1 )
INSERT INTO tbm_district
VALUES
( '0057', 'บางเสาธง', '02', '10540', 1 )
INSERT INTO tbm_district
VALUES
( '0058', 'เมืองนนทบุรี', '03', '11000', 1 )
INSERT INTO tbm_district
VALUES
( '0059', 'บางกรวย', '03', '11130', 1 )
INSERT INTO tbm_district
VALUES
( '0060', 'บางใหญ่', '03', '11140', 1 )
INSERT INTO tbm_district
VALUES
( '0061', 'บางบัวทอง', '03', '11110', 1 )
INSERT INTO tbm_district
VALUES
( '0062', 'ไทรน้อย', '03', '11150', 1 )
INSERT INTO tbm_district
VALUES
( '0063', 'ปากเกร็ด', '03', '11120', 1 )
INSERT INTO tbm_district
VALUES
( '0064', 'เทศบาลนครนนทบุรี (สาขาแขวงท่าทราย)', '03', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0065', 'เทศบาลเมืองปากเกร็ด', '03', '11120', -1 )
INSERT INTO tbm_district
VALUES
( '0066', 'เมืองปทุมธานี', '04', '12000', 1 )
INSERT INTO tbm_district
VALUES
( '0067', 'คลองหลวง', '04', '12110', 1 )
INSERT INTO tbm_district
VALUES
( '0068', 'ธัญบุรี', '04', '12110', 1 )
INSERT INTO tbm_district
VALUES
( '0069', 'หนองเสือ', '04', '12170', 1 )
INSERT INTO tbm_district
VALUES
( '0070', 'ลาดหลุมแก้ว', '04', '12140', 1 )
INSERT INTO tbm_district
VALUES
( '0071', 'ลำลูกกา', '04', '12130', 1 )
INSERT INTO tbm_district
VALUES
( '0072', 'สามโคก', '04', '12160', 1 )
INSERT INTO tbm_district
VALUES
( '0073', 'ลำลูกกา (สาขาตำบลคูคต)', '04', '12150', -1 )
INSERT INTO tbm_district
VALUES
( '0074', 'พระนครศรีอยุธยา', '05', '13000', 1 )
INSERT INTO tbm_district
VALUES
( '0075', 'ท่าเรือ', '05', '13130', 1 )
INSERT INTO tbm_district
VALUES
( '0076', 'นครหลวง', '05', '13260', 1 )
INSERT INTO tbm_district
VALUES
( '0077', 'บางไทร', '05', '13190', 1 )
INSERT INTO tbm_district
VALUES
( '0078', 'บางบาล', '05', '13250', 1 )
INSERT INTO tbm_district
VALUES
( '0079', 'บางปะอิน', '05', '13160', 1 )
INSERT INTO tbm_district
VALUES
( '0080', 'บางปะหัน', '05', '13220', 1 )
INSERT INTO tbm_district
VALUES
( '0081', 'ผักไห่', '05', '13120', 1 )
INSERT INTO tbm_district
VALUES
( '0082', 'ภาชี', '05', '13140', 1 )
INSERT INTO tbm_district
VALUES
( '0083', 'ลาดบัวหลวง', '05', '13230', 1 )
INSERT INTO tbm_district
VALUES
( '0084', 'วังน้อย', '05', '13170', 1 )
INSERT INTO tbm_district
VALUES
( '0085', 'เสนา', '05', '13110', 1 )
INSERT INTO tbm_district
VALUES
( '0086', 'บางซ้าย', '05', '13270', 1 )
INSERT INTO tbm_district
VALUES
( '0087', 'อุทัย', '05', '13000', 1 )
INSERT INTO tbm_district
VALUES
( '0088', 'มหาราช', '05', '13150', 1 )
INSERT INTO tbm_district
VALUES
( '0089', 'บ้านแพรก', '05', '13240', 1 )
INSERT INTO tbm_district
VALUES
( '0090', 'เมืองอ่างทอง', '06', '14000', 1 )
INSERT INTO tbm_district
VALUES
( '0091', 'ไชโย', '06', '14140', 1 )
INSERT INTO tbm_district
VALUES
( '0092', 'ป่าโมก', '06', '14130', 1 )
INSERT INTO tbm_district
VALUES
( '0093', 'โพธิ์ทอง', '06', '14120', 1 )
INSERT INTO tbm_district
VALUES
( '0094', 'แสวงหา', '06', '14150', 1 )
INSERT INTO tbm_district
VALUES
( '0095', 'วิเศษชัยชาญ', '06', '14110', 1 )
INSERT INTO tbm_district
VALUES
( '0096', 'สามโก้', '06', '14160', 1 )
INSERT INTO tbm_district
VALUES
( '0097', 'เมืองลพบุรี', '07', '15000', 1 )
INSERT INTO tbm_district
VALUES
( '0098', 'พัฒนานิคม', '07', '15140', 1 )
INSERT INTO tbm_district
VALUES
( '0099', 'โคกสำโรง', '07', '15120', 1 )
INSERT INTO tbm_district
VALUES
( '0100', 'ชัยบาดาล', '07', '15130', 1 )
INSERT INTO tbm_district
VALUES
( '0101', 'ท่าวุ้ง', '07', '15150', 1 )
INSERT INTO tbm_district
VALUES
( '0102', 'บ้านหมี่', '07', '15110', 1 )
INSERT INTO tbm_district
VALUES
( '0103', 'ท่าหลวง', '07', '15230', 1 )
INSERT INTO tbm_district
VALUES
( '0104', 'สระโบสถ์', '07', '15240', 1 )
INSERT INTO tbm_district
VALUES
( '0105', 'โคกเจริญ', '07', '15250', 1 )
INSERT INTO tbm_district
VALUES
( '0106', 'ลำสนธิ', '07', '15130', 1 )
INSERT INTO tbm_district
VALUES
( '0107', 'หนองม่วง', '07', '15170', 1 )
INSERT INTO tbm_district
VALUES
( '0108', 'อ.บ้านเช่า  จ.ลพบุรี', '07', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0109', 'เมืองสิงห์บุรี', '08', '16000', 1 )
INSERT INTO tbm_district
VALUES
( '0110', 'บางระจัน', '08', '16130', 1 )
INSERT INTO tbm_district
VALUES
( '0111', 'ค่ายบางระจัน', '08', '16150', 1 )
INSERT INTO tbm_district
VALUES
( '0112', 'พรหมบุรี', '08', '16120', 1 )
INSERT INTO tbm_district
VALUES
( '0113', 'ท่าช้าง', '08', '16140', 1 )
INSERT INTO tbm_district
VALUES
( '0114', 'อินทร์บุรี', '08', '16110', 1 )
INSERT INTO tbm_district
VALUES
( '0115', 'เมืองชัยนาท', '09', '17000', 1 )
INSERT INTO tbm_district
VALUES
( '0116', 'มโนรมย์', '09', '17110', 1 )
INSERT INTO tbm_district
VALUES
( '0117', 'วัดสิงห์', '09', '17120', 1 )
INSERT INTO tbm_district
VALUES
( '0118', 'สรรพยา', '09', '17150', 1 )
INSERT INTO tbm_district
VALUES
( '0119', 'สรรคบุรี', '09', '17140', 1 )
INSERT INTO tbm_district
VALUES
( '0120', 'หันคา', '09', '17130', 1 )
INSERT INTO tbm_district
VALUES
( '0121', 'หนองมะโมง', '09', '17120', 1 )
INSERT INTO tbm_district
VALUES
( '0122', 'เนินขาม', '09', '17130', 1 )
INSERT INTO tbm_district
VALUES
( '0123', 'เมืองสระบุรี', '10', '18000', 1 )
INSERT INTO tbm_district
VALUES
( '0124', 'แก่งคอย', '10', '18110', 1 )
INSERT INTO tbm_district
VALUES
( '0125', 'หนองแค', '10', '18140', 1 )
INSERT INTO tbm_district
VALUES
( '0126', 'วิหารแดง', '10', '18150', 1 )
INSERT INTO tbm_district
VALUES
( '0127', 'หนองแซง', '10', '18170', 1 )
INSERT INTO tbm_district
VALUES
( '0128', 'บ้านหมอ', '10', '18130', 1 )
INSERT INTO tbm_district
VALUES
( '0129', 'ดอนพุด', '10', '18210', 1 )
INSERT INTO tbm_district
VALUES
( '0130', 'หนองโดน', '10', '18190', 1 )
INSERT INTO tbm_district
VALUES
( '0131', 'พระพุทธบาท', '10', '18120', 1 )
INSERT INTO tbm_district
VALUES
( '0132', 'เสาไห้', '10', '18160', 1 )
INSERT INTO tbm_district
VALUES
( '0133', 'มวกเหล็ก', '10', '18180', 1 )
INSERT INTO tbm_district
VALUES
( '0134', 'วังม่วง', '10', '18220', 1 )
INSERT INTO tbm_district
VALUES
( '0135', 'เฉลิมพระเกียรติ', '10', '18000', 1 )
INSERT INTO tbm_district
VALUES
( '0136', 'เมืองชลบุรี', '11', '20000', 1 )
INSERT INTO tbm_district
VALUES
( '0137', 'บ้านบึง', '11', '20170', 1 )
INSERT INTO tbm_district
VALUES
( '0138', 'หนองใหญ่', '11', '20190', 1 )
INSERT INTO tbm_district
VALUES
( '0139', 'บางละมุง', '11', '20150', 1 )
INSERT INTO tbm_district
VALUES
( '0140', 'พานทอง', '11', '20160', 1 )
INSERT INTO tbm_district
VALUES
( '0141', 'พนัสนิคม', '11', '20140', 1 )
INSERT INTO tbm_district
VALUES
( '0142', 'ศรีราชา', '11', '20110', 1 )
INSERT INTO tbm_district
VALUES
( '0143', 'เกาะสีชัง', '11', '20120', 1 )
INSERT INTO tbm_district
VALUES
( '0144', 'สัตหีบ', '11', '20180', 1 )
INSERT INTO tbm_district
VALUES
( '0145', 'บ่อทอง', '11', '20270', 1 )
INSERT INTO tbm_district
VALUES
( '0146', 'เกาะจันทร์', '11', '20240', 1 )
INSERT INTO tbm_district
VALUES
( '0147', 'สัตหีบ (สาขาตำบลบางเสร่)', '11', '20180', -1 )
INSERT INTO tbm_district
VALUES
( '0148', 'ท้องถิ่นเทศบาลเมืองหนองปรือ', '11', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0149', 'เทศบาลตำบลแหลมฉบัง', '11', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0150', 'เทศบาลเมืองชลบุรี', '11', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0151', 'เมืองระยอง', '12', '21000', 1 )
INSERT INTO tbm_district
VALUES
( '0152', 'บ้านฉาง', '12', '21130', 1 )
INSERT INTO tbm_district
VALUES
( '0153', 'แกลง', '12', '21110', 1 )
INSERT INTO tbm_district
VALUES
( '0154', 'วังจันทร์', '12', '21210', 1 )
INSERT INTO tbm_district
VALUES
( '0155', 'บ้านค่าย', '12', '21120', 1 )
INSERT INTO tbm_district
VALUES
( '0156', 'ปลวกแดง', '12', '21140', 1 )
INSERT INTO tbm_district
VALUES
( '0157', 'เขาชะเมา', '12', '21110', 1 )
INSERT INTO tbm_district
VALUES
( '0158', 'นิคมพัฒนา', '12', '21180', 1 )
INSERT INTO tbm_district
VALUES
( '0159', 'สาขาตำบลมาบข่า', '12', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0160', 'เมืองจันทบุรี', '13', '22000', 1 )
INSERT INTO tbm_district
VALUES
( '0161', 'ขลุง', '13', '22110', 1 )
INSERT INTO tbm_district
VALUES
( '0162', 'ท่าใหม่', '13', '22120', 1 )
INSERT INTO tbm_district
VALUES
( '0163', 'โป่งน้ำร้อน', '13', '22140', 1 )
INSERT INTO tbm_district
VALUES
( '0164', 'มะขาม', '13', '22150', 1 )
INSERT INTO tbm_district
VALUES
( '0165', 'แหลมสิงห์', '13', '22120', 1 )
INSERT INTO tbm_district
VALUES
( '0166', 'สอยดาว', '13', '22180', 1 )
INSERT INTO tbm_district
VALUES
( '0167', 'แก่งหางแมว', '13', '22160', 1 )
INSERT INTO tbm_district
VALUES
( '0168', 'นายายอาม', '13', '22160', 1 )
INSERT INTO tbm_district
VALUES
( '0169', 'เขาคิชฌกูฏ', '13', '22210', 1 )
INSERT INTO tbm_district
VALUES
( '0170', 'กิ่ง อ.กำพุธ  จ.จันทบุรี', '13', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0171', 'เมืองตราด', '14', '23000', 1 )
INSERT INTO tbm_district
VALUES
( '0172', 'คลองใหญ่', '14', '23110', 1 )
INSERT INTO tbm_district
VALUES
( '0173', 'เขาสมิง', '14', '23130', 1 )
INSERT INTO tbm_district
VALUES
( '0174', 'บ่อไร่', '14', '23140', 1 )
INSERT INTO tbm_district
VALUES
( '0175', 'แหลมงอบ', '14', '23120', 1 )
INSERT INTO tbm_district
VALUES
( '0176', 'เกาะกูด', '14', '23000', 1 )
INSERT INTO tbm_district
VALUES
( '0177', 'เกาะช้าง', '14', '23170', 1 )
INSERT INTO tbm_district
VALUES
( '0178', 'เมืองฉะเชิงเทรา', '15', '24000', 1 )
INSERT INTO tbm_district
VALUES
( '0179', 'บางคล้า', '15', '24110', 1 )
INSERT INTO tbm_district
VALUES
( '0180', 'บางน้ำเปรี้ยว', '15', '24000', 1 )
INSERT INTO tbm_district
VALUES
( '0181', 'บางปะกง', '15', '24130', 1 )
INSERT INTO tbm_district
VALUES
( '0182', 'บ้านโพธิ์', '15', '24140', 1 )
INSERT INTO tbm_district
VALUES
( '0183', 'พนมสารคาม', '15', '24120', 1 )
INSERT INTO tbm_district
VALUES
( '0184', 'ราชสาส์น', '15', '24120', 1 )
INSERT INTO tbm_district
VALUES
( '0185', 'สนามชัยเขต', '15', '24160', 1 )
INSERT INTO tbm_district
VALUES
( '0186', 'แปลงยาว', '15', '24190', 1 )
INSERT INTO tbm_district
VALUES
( '0187', 'ท่าตะเกียบ', '15', '24160', 1 )
INSERT INTO tbm_district
VALUES
( '0188', 'คลองเขื่อน', '15', '24000', 1 )
INSERT INTO tbm_district
VALUES
( '0189', 'เมืองปราจีนบุรี', '16', '25000', 1 )
INSERT INTO tbm_district
VALUES
( '0190', 'กบินทร์บุรี', '16', '25110', 1 )
INSERT INTO tbm_district
VALUES
( '0191', 'นาดี', '16', '25220', 1 )
INSERT INTO tbm_district
VALUES
( '0192', 'สระแก้ว', '16', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0193', 'วังน้ำเย็น', '16', '27210', -1 )
INSERT INTO tbm_district
VALUES
( '0194', 'บ้านสร้าง', '16', '25150', 1 )
INSERT INTO tbm_district
VALUES
( '0195', 'ประจันตคาม', '16', '25130', 1 )
INSERT INTO tbm_district
VALUES
( '0196', 'ศรีมหาโพธิ', '16', '25140', 1 )
INSERT INTO tbm_district
VALUES
( '0197', 'ศรีมโหสถ', '16', '25190', 1 )
INSERT INTO tbm_district
VALUES
( '0198', 'อรัญประเทศ', '16', '27120', -1 )
INSERT INTO tbm_district
VALUES
( '0199', 'ตาพระยา', '16', '27180', -1 )
INSERT INTO tbm_district
VALUES
( '0200', 'วัฒนานคร', '16', '27160', -1 )
INSERT INTO tbm_district
VALUES
( '0201', 'คลองหาด', '16', '27260', -1 )
INSERT INTO tbm_district
VALUES
( '0202', 'เมืองนครนายก', '17', '26000', 1 )
INSERT INTO tbm_district
VALUES
( '0203', 'ปากพลี', '17', '26130', 1 )
INSERT INTO tbm_district
VALUES
( '0204', 'บ้านนา', '17', '26110', 1 )
INSERT INTO tbm_district
VALUES
( '0205', 'องครักษ์', '17', '26120', 1 )
INSERT INTO tbm_district
VALUES
( '0206', 'เมืองสระแก้ว', '18', '27000', 1 )
INSERT INTO tbm_district
VALUES
( '0207', 'คลองหาด', '18', '27260', 1 )
INSERT INTO tbm_district
VALUES
( '0208', 'ตาพระยา', '18', '27180', 1 )
INSERT INTO tbm_district
VALUES
( '0209', 'วังน้ำเย็น', '18', '27210', 1 )
INSERT INTO tbm_district
VALUES
( '0210', 'วัฒนานคร', '18', '27160', 1 )
INSERT INTO tbm_district
VALUES
( '0211', 'อรัญประเทศ', '18', '27120', 1 )
INSERT INTO tbm_district
VALUES
( '0212', 'เขาฉกรรจ์', '18', '27000', 1 )
INSERT INTO tbm_district
VALUES
( '0213', 'โคกสูง', '18', '27120', 1 )
INSERT INTO tbm_district
VALUES
( '0214', 'วังสมบูรณ์', '18', '27210', 1 )
INSERT INTO tbm_district
VALUES
( '0215', 'เมืองนครราชสีมา', '19', '30000', 1 )
INSERT INTO tbm_district
VALUES
( '0216', 'ครบุรี', '19', '30250', 1 )
INSERT INTO tbm_district
VALUES
( '0217', 'เสิงสาง', '19', '30330', 1 )
INSERT INTO tbm_district
VALUES
( '0218', 'คง', '19', '30260', 1 )
INSERT INTO tbm_district
VALUES
( '0219', 'บ้านเหลื่อม', '19', '30350', 1 )
INSERT INTO tbm_district
VALUES
( '0220', 'จักราช', '19', '30230', 1 )
INSERT INTO tbm_district
VALUES
( '0221', 'โชคชัย', '19', '30190', 1 )
INSERT INTO tbm_district
VALUES
( '0222', 'ด่านขุนทด', '19', '30210', 1 )
INSERT INTO tbm_district
VALUES
( '0223', 'โนนไทย', '19', '30220', 1 )
INSERT INTO tbm_district
VALUES
( '0224', 'โนนสูง', '19', '30160', 1 )
INSERT INTO tbm_district
VALUES
( '0225', 'ขามสะแกแสง', '19', '30290', 1 )
INSERT INTO tbm_district
VALUES
( '0226', 'บัวใหญ่', '19', '30120', 1 )
INSERT INTO tbm_district
VALUES
( '0227', 'ประทาย', '19', '30180', 1 )
INSERT INTO tbm_district
VALUES
( '0228', 'ปักธงชัย', '19', '30150', 1 )
INSERT INTO tbm_district
VALUES
( '0229', 'พิมาย', '19', '30110', 1 )
INSERT INTO tbm_district
VALUES
( '0230', 'ห้วยแถลง', '19', '30240', 1 )
INSERT INTO tbm_district
VALUES
( '0231', 'ชุมพวง', '19', '30270', 1 )
INSERT INTO tbm_district
VALUES
( '0232', 'สูงเนิน', '19', '30170', 1 )
INSERT INTO tbm_district
VALUES
( '0233', 'ขามทะเลสอ', '19', '30280', 1 )
INSERT INTO tbm_district
VALUES
( '0234', 'สีคิ้ว', '19', '30140', 1 )
INSERT INTO tbm_district
VALUES
( '0235', 'ปากช่อง', '19', '30130', 1 )
INSERT INTO tbm_district
VALUES
( '0236', 'หนองบุญนาก', '19', '30410', 1 )
INSERT INTO tbm_district
VALUES
( '0237', 'แก้งสนามนาง', '19', '30440', 1 )
INSERT INTO tbm_district
VALUES
( '0238', 'โนนแดง', '19', '30360', 1 )
INSERT INTO tbm_district
VALUES
( '0239', 'วังน้ำเขียว', '19', '30150', 1 )
INSERT INTO tbm_district
VALUES
( '0240', 'เทพารักษ์', '19', '30210', 1 )
INSERT INTO tbm_district
VALUES
( '0241', 'เมืองยาง', '19', '30270', 1 )
INSERT INTO tbm_district
VALUES
( '0242', 'พระทองคำ', '19', '30220', 1 )
INSERT INTO tbm_district
VALUES
( '0243', 'ลำทะเมนชัย', '19', '30270', 1 )
INSERT INTO tbm_district
VALUES
( '0244', 'บัวลาย', '19', '30120', 1 )
INSERT INTO tbm_district
VALUES
( '0245', 'สีดา', '19', '30430', 1 )
INSERT INTO tbm_district
VALUES
( '0246', 'เฉลิมพระเกียรติ', '19', '30000', 1 )
INSERT INTO tbm_district
VALUES
( '0247', 'ท้องถิ่นเทศบาลตำบลโพธิ์กลาง', '19', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0248', 'สาขาตำบลมะค่า-พลสงคราม', '19', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0249', 'โนนลาว', '19', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0250', 'เมืองบุรีรัมย์', '20', '31000', 1 )
INSERT INTO tbm_district
VALUES
( '0251', 'คูเมือง', '20', '31190', 1 )
INSERT INTO tbm_district
VALUES
( '0252', 'กระสัง', '20', '31160', 1 )
INSERT INTO tbm_district
VALUES
( '0253', 'นางรอง', '20', '31110', 1 )
INSERT INTO tbm_district
VALUES
( '0254', 'หนองกี่', '20', '31210', 1 )
INSERT INTO tbm_district
VALUES
( '0255', 'ละหานทราย', '20', '31170', 1 )
INSERT INTO tbm_district
VALUES
( '0256', 'ประโคนชัย', '20', '31140', 1 )
INSERT INTO tbm_district
VALUES
( '0257', 'บ้านกรวด', '20', '31180', 1 )
INSERT INTO tbm_district
VALUES
( '0258', 'พุทไธสง', '20', '31120', 1 )
INSERT INTO tbm_district
VALUES
( '0259', 'ลำปลายมาศ', '20', '31130', 1 )
INSERT INTO tbm_district
VALUES
( '0260', 'สตึก', '20', '31150', 1 )
INSERT INTO tbm_district
VALUES
( '0261', 'ปะคำ', '20', '31220', 1 )
INSERT INTO tbm_district
VALUES
( '0262', 'นาโพธิ์', '20', '31230', 1 )
INSERT INTO tbm_district
VALUES
( '0263', 'หนองหงส์', '20', '31240', 1 )
INSERT INTO tbm_district
VALUES
( '0264', 'พลับพลาชัย', '20', '31250', 1 )
INSERT INTO tbm_district
VALUES
( '0265', 'ห้วยราช', '20', '31000', 1 )
INSERT INTO tbm_district
VALUES
( '0266', 'โนนสุวรรณ', '20', '31110', 1 )
INSERT INTO tbm_district
VALUES
( '0267', 'ชำนิ', '20', '31110', 1 )
INSERT INTO tbm_district
VALUES
( '0268', 'บ้านใหม่ไชยพจน์', '20', '31120', 1 )
INSERT INTO tbm_district
VALUES
( '0269', 'โนนดินแดง', '20', '31260', 1 )
INSERT INTO tbm_district
VALUES
( '0270', 'บ้านด่าน', '20', '31000', 1 )
INSERT INTO tbm_district
VALUES
( '0271', 'แคนดง', '20', '31150', 1 )
INSERT INTO tbm_district
VALUES
( '0272', 'เฉลิมพระเกียรติ', '20', '31110', 1 )
INSERT INTO tbm_district
VALUES
( '0273', 'เมืองสุรินทร์', '21', '32000', 1 )
INSERT INTO tbm_district
VALUES
( '0274', 'ชุมพลบุรี', '21', '32190', 1 )
INSERT INTO tbm_district
VALUES
( '0275', 'ท่าตูม', '21', '32120', 1 )
INSERT INTO tbm_district
VALUES
( '0276', 'จอมพระ', '21', '32180', 1 )
INSERT INTO tbm_district
VALUES
( '0277', 'ปราสาท', '21', '32140', 1 )
INSERT INTO tbm_district
VALUES
( '0278', 'กาบเชิง', '21', '32210', 1 )
INSERT INTO tbm_district
VALUES
( '0279', 'รัตนบุรี', '21', '32130', 1 )
INSERT INTO tbm_district
VALUES
( '0280', 'สนม', '21', '32160', 1 )
INSERT INTO tbm_district
VALUES
( '0281', 'ศรีขรภูมิ', '21', '32110', 1 )
INSERT INTO tbm_district
VALUES
( '0282', 'สังขะ', '21', '32150', 1 )
INSERT INTO tbm_district
VALUES
( '0283', 'ลำดวน', '21', '32220', 1 )
INSERT INTO tbm_district
VALUES
( '0284', 'สำโรงทาบ', '21', '32170', 1 )
INSERT INTO tbm_district
VALUES
( '0285', 'บัวเชด', '21', '32230', 1 )
INSERT INTO tbm_district
VALUES
( '0286', 'พนมดงรัก', '21', '32140', 1 )
INSERT INTO tbm_district
VALUES
( '0287', 'ศรีณรงค์', '21', '32150', 1 )
INSERT INTO tbm_district
VALUES
( '0288', 'เขวาสินรินทร์', '21', '32000', 1 )
INSERT INTO tbm_district
VALUES
( '0289', 'โนนนารายณ์', '21', '32130', 1 )
INSERT INTO tbm_district
VALUES
( '0290', 'เมืองศรีสะเกษ', '22', '33000', 1 )
INSERT INTO tbm_district
VALUES
( '0291', 'ยางชุมน้อย', '22', '33190', 1 )
INSERT INTO tbm_district
VALUES
( '0292', 'กันทรารมย์', '22', '33130', 1 )
INSERT INTO tbm_district
VALUES
( '0293', 'กันทรลักษ์', '22', '33110', 1 )
INSERT INTO tbm_district
VALUES
( '0294', 'ขุขันธ์', '22', '33140', 1 )
INSERT INTO tbm_district
VALUES
( '0295', 'ไพรบึง', '22', '33180', 1 )
INSERT INTO tbm_district
VALUES
( '0296', 'ปรางค์กู่', '22', '33170', 1 )
INSERT INTO tbm_district
VALUES
( '0297', 'ขุนหาญ', '22', '33150', 1 )
INSERT INTO tbm_district
VALUES
( '0298', 'ราษีไศล', '22', '33160', 1 )
INSERT INTO tbm_district
VALUES
( '0299', 'อุทุมพรพิสัย', '22', '33120', 1 )
INSERT INTO tbm_district
VALUES
( '0300', 'บึงบูรพ์', '22', '33220', 1 )
INSERT INTO tbm_district
VALUES
( '0301', 'ห้วยทับทัน', '22', '33210', 1 )
INSERT INTO tbm_district
VALUES
( '0302', 'โนนคูณ', '22', '33250', 1 )
INSERT INTO tbm_district
VALUES
( '0303', 'ศรีรัตนะ', '22', '33240', 1 )
INSERT INTO tbm_district
VALUES
( '0304', 'น้ำเกลี้ยง', '22', '33130', 1 )
INSERT INTO tbm_district
VALUES
( '0305', 'วังหิน', '22', '33270', 1 )
INSERT INTO tbm_district
VALUES
( '0306', 'ภูสิงห์', '22', '33140', 1 )
INSERT INTO tbm_district
VALUES
( '0307', 'เมืองจันทร์', '22', '33120', 1 )
INSERT INTO tbm_district
VALUES
( '0308', 'เบญจลักษณ์', '22', '33110', 1 )
INSERT INTO tbm_district
VALUES
( '0309', 'พยุห์', '22', '33230', 1 )
INSERT INTO tbm_district
VALUES
( '0310', 'โพธิ์ศรีสุวรรณ', '22', '33120', 1 )
INSERT INTO tbm_district
VALUES
( '0311', 'ศิลาลาด', '22', '33160', 1 )
INSERT INTO tbm_district
VALUES
( '0312', 'เมืองอุบลราชธานี', '23', '34000', 1 )
INSERT INTO tbm_district
VALUES
( '0313', 'ศรีเมืองใหม่', '23', '34250', 1 )
INSERT INTO tbm_district
VALUES
( '0314', 'โขงเจียม', '23', '34220', 1 )
INSERT INTO tbm_district
VALUES
( '0315', 'เขื่องใน', '23', '34150', 1 )
INSERT INTO tbm_district
VALUES
( '0316', 'เขมราฐ', '23', '34170', 1 )
INSERT INTO tbm_district
VALUES
( '0317', 'ชานุมาน', '23', '37210', -1 )
INSERT INTO tbm_district
VALUES
( '0318', 'เดชอุดม', '23', '34160', 1 )
INSERT INTO tbm_district
VALUES
( '0319', 'นาจะหลวย', '23', '34280', 1 )
INSERT INTO tbm_district
VALUES
( '0320', 'น้ำยืน', '23', '34260', 1 )
INSERT INTO tbm_district
VALUES
( '0321', 'บุณฑริก', '23', '34230', 1 )
INSERT INTO tbm_district
VALUES
( '0322', 'ตระการพืชผล', '23', '34130', 1 )
INSERT INTO tbm_district
VALUES
( '0323', 'กุดข้าวปุ้น', '23', '34270', 1 )
INSERT INTO tbm_district
VALUES
( '0324', 'พนา', '23', '37180', -1 )
INSERT INTO tbm_district
VALUES
( '0325', 'ม่วงสามสิบ', '23', '34140', 1 )
INSERT INTO tbm_district
VALUES
( '0326', 'วารินชำราบ', '23', '34190', 1 )
INSERT INTO tbm_district
VALUES
( '0327', 'อำนาจเจริญ', '23', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0328', 'เสนางคนิคม', '23', '37290', -1 )
INSERT INTO tbm_district
VALUES
( '0329', 'หัวตะพาน', '23', '37240', -1 )
INSERT INTO tbm_district
VALUES
( '0330', 'พิบูลมังสาหาร', '23', '34110', 1 )
INSERT INTO tbm_district
VALUES
( '0331', 'ตาลสุม', '23', '34330', 1 )
INSERT INTO tbm_district
VALUES
( '0332', 'โพธิ์ไทร', '23', '34340', 1 )
INSERT INTO tbm_district
VALUES
( '0333', 'สำโรง', '23', '34360', 1 )
INSERT INTO tbm_district
VALUES
( '0334', 'กิ่งอำเภอลืออำนาจ', '23', '37000', -1 )
INSERT INTO tbm_district
VALUES
( '0335', 'ดอนมดแดง', '23', '34000', 1 )
INSERT INTO tbm_district
VALUES
( '0336', 'สิรินธร', '23', '34350', 1 )
INSERT INTO tbm_district
VALUES
( '0337', 'ทุ่งศรีอุดม', '23', '34160', 1 )
INSERT INTO tbm_district
VALUES
( '0338', 'ปทุมราชวงศา', '23', '37110', -1 )
INSERT INTO tbm_district
VALUES
( '0339', 'กิ่งอำเภอศรีหลักชัย', '23', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0340', 'นาเยีย', '23', '34160', 1 )
INSERT INTO tbm_district
VALUES
( '0341', 'นาตาล', '23', '34170', 1 )
INSERT INTO tbm_district
VALUES
( '0342', 'เหล่าเสือโก้ก', '23', '34000', 1 )
INSERT INTO tbm_district
VALUES
( '0343', 'สว่างวีระวงศ์', '23', '34190', 1 )
INSERT INTO tbm_district
VALUES
( '0344', 'น้ำขุ่น', '23', '34260', 1 )
INSERT INTO tbm_district
VALUES
( '0345', 'อ.สุวรรณวารี  จ.อุบลราชธานี', '23', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0346', 'เมืองยโสธร', '24', '35000', 1 )
INSERT INTO tbm_district
VALUES
( '0347', 'ทรายมูล', '24', '35170', 1 )
INSERT INTO tbm_district
VALUES
( '0348', 'กุดชุม', '24', '35140', 1 )
INSERT INTO tbm_district
VALUES
( '0349', 'คำเขื่อนแก้ว', '24', '35110', 1 )
INSERT INTO tbm_district
VALUES
( '0350', 'ป่าติ้ว', '24', '35150', 1 )
INSERT INTO tbm_district
VALUES
( '0351', 'มหาชนะชัย', '24', '35130', 1 )
INSERT INTO tbm_district
VALUES
( '0352', 'ค้อวัง', '24', '35160', 1 )
INSERT INTO tbm_district
VALUES
( '0353', 'เลิงนกทา', '24', '35120', 1 )
INSERT INTO tbm_district
VALUES
( '0354', 'ไทยเจริญ', '24', '35120', 1 )
INSERT INTO tbm_district
VALUES
( '0355', 'เมืองชัยภูมิ', '25', '36000', 1 )
INSERT INTO tbm_district
VALUES
( '0356', 'บ้านเขว้า', '25', '36170', 1 )
INSERT INTO tbm_district
VALUES
( '0357', 'คอนสวรรค์', '25', '36140', 1 )
INSERT INTO tbm_district
VALUES
( '0358', 'เกษตรสมบูรณ์', '25', '36000', 1 )
INSERT INTO tbm_district
VALUES
( '0359', 'หนองบัวแดง', '25', '36210', 1 )
INSERT INTO tbm_district
VALUES
( '0360', 'จัตุรัส', '25', '36130', 1 )
INSERT INTO tbm_district
VALUES
( '0361', 'บำเหน็จณรงค์', '25', '36160', 1 )
INSERT INTO tbm_district
VALUES
( '0362', 'หนองบัวระเหว', '25', '36250', 1 )
INSERT INTO tbm_district
VALUES
( '0363', 'เทพสถิต', '25', '36230', 1 )
INSERT INTO tbm_district
VALUES
( '0364', 'ภูเขียว', '25', '36110', 1 )
INSERT INTO tbm_district
VALUES
( '0365', 'บ้านแท่น', '25', '36190', 1 )
INSERT INTO tbm_district
VALUES
( '0366', 'แก้งคร้อ', '25', '36150', 1 )
INSERT INTO tbm_district
VALUES
( '0367', 'คอนสาร', '25', '36180', 1 )
INSERT INTO tbm_district
VALUES
( '0368', 'ภักดีชุมพล', '25', '36260', 1 )
INSERT INTO tbm_district
VALUES
( '0369', 'เนินสง่า', '25', '36130', 1 )
INSERT INTO tbm_district
VALUES
( '0370', 'ซับใหญ่', '25', '36130', 1 )
INSERT INTO tbm_district
VALUES
( '0371', 'เมืองชัยภูมิ (สาขาตำบลโนนสำราญ)', '25', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0372', 'สาขาตำบลบ้านหว่าเฒ่า', '25', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0373', 'หนองบัวแดง (สาขาตำบลวังชมภู)', '25', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0374', 'กิ่งอำเภอซับใหญ่ (สาขาตำบลซับใหญ่)', '25', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0375', 'สาขาตำบลโคกเพชร', '25', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0376', 'เทพสถิต (สาขาตำบลนายางกลัก)', '25', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0377', 'บ้านแท่น (สาขาตำบลบ้านเต่า)', '25', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0378', 'แก้งคร้อ (สาขาตำบลท่ามะไฟหวาน)', '25', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0379', 'คอนสาร (สาขาตำบลโนนคูณ)', '25', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0380', 'เมืองอำนาจเจริญ', '26', '37000', 1 )
INSERT INTO tbm_district
VALUES
( '0381', 'ชานุมาน', '26', '37210', 1 )
INSERT INTO tbm_district
VALUES
( '0382', 'ปทุมราชวงศา', '26', '37110', 1 )
INSERT INTO tbm_district
VALUES
( '0383', 'พนา', '26', '37180', 1 )
INSERT INTO tbm_district
VALUES
( '0384', 'เสนางคนิคม', '26', '37290', 1 )
INSERT INTO tbm_district
VALUES
( '0385', 'หัวตะพาน', '26', '37240', 1 )
INSERT INTO tbm_district
VALUES
( '0386', 'ลืออำนาจ', '26', '37000', 1 )
INSERT INTO tbm_district
VALUES
( '0387', 'เมืองหนองบัวลำภู', '27', '39000', 1 )
INSERT INTO tbm_district
VALUES
( '0388', 'นากลาง', '27', '39170', 1 )
INSERT INTO tbm_district
VALUES
( '0389', 'โนนสัง', '27', '39140', 1 )
INSERT INTO tbm_district
VALUES
( '0390', 'ศรีบุญเรือง', '27', '39180', 1 )
INSERT INTO tbm_district
VALUES
( '0391', 'สุวรรณคูหา', '27', '39270', 1 )
INSERT INTO tbm_district
VALUES
( '0392', 'นาวัง', '27', '39170', 1 )
INSERT INTO tbm_district
VALUES
( '0393', 'เมืองขอนแก่น', '28', '40000', 1 )
INSERT INTO tbm_district
VALUES
( '0394', 'บ้านฝาง', '28', '40270', 1 )
INSERT INTO tbm_district
VALUES
( '0395', 'พระยืน', '28', '40320', 1 )
INSERT INTO tbm_district
VALUES
( '0396', 'หนองเรือ', '28', '40210', 1 )
INSERT INTO tbm_district
VALUES
( '0397', 'ชุมแพ', '28', '40130', 1 )
INSERT INTO tbm_district
VALUES
( '0398', 'สีชมพู', '28', '40220', 1 )
INSERT INTO tbm_district
VALUES
( '0399', 'น้ำพอง', '28', '40140', 1 )
INSERT INTO tbm_district
VALUES
( '0400', 'อุบลรัตน์', '28', '40250', 1 )
INSERT INTO tbm_district
VALUES
( '0401', 'กระนวน', '28', '40170', 1 )
INSERT INTO tbm_district
VALUES
( '0402', 'บ้านไผ่', '28', '40110', 1 )
INSERT INTO tbm_district
VALUES
( '0403', 'เปือยน้อย', '28', '40340', 1 )
INSERT INTO tbm_district
VALUES
( '0404', 'พล', '28', '40120', 1 )
INSERT INTO tbm_district
VALUES
( '0405', 'แวงใหญ่', '28', '40330', 1 )
INSERT INTO tbm_district
VALUES
( '0406', 'แวงน้อย', '28', '40230', 1 )
INSERT INTO tbm_district
VALUES
( '0407', 'หนองสองห้อง', '28', '40190', 1 )
INSERT INTO tbm_district
VALUES
( '0408', 'ภูเวียง', '28', '40150', 1 )
INSERT INTO tbm_district
VALUES
( '0409', 'มัญจาคีรี', '28', '40160', 1 )
INSERT INTO tbm_district
VALUES
( '0410', 'ชนบท', '28', '40180', 1 )
INSERT INTO tbm_district
VALUES
( '0411', 'เขาสวนกวาง', '28', '40280', 1 )
INSERT INTO tbm_district
VALUES
( '0412', 'ภูผาม่าน', '28', '40350', 1 )
INSERT INTO tbm_district
VALUES
( '0413', 'ซำสูง', '28', '40170', 1 )
INSERT INTO tbm_district
VALUES
( '0414', 'โคกโพธิ์ไชย', '28', '40160', 1 )
INSERT INTO tbm_district
VALUES
( '0415', 'หนองนาคำ', '28', '40150', 1 )
INSERT INTO tbm_district
VALUES
( '0416', 'บ้านแฮด', '28', '40110', 1 )
INSERT INTO tbm_district
VALUES
( '0417', 'โนนศิลา', '28', '40110', 1 )
INSERT INTO tbm_district
VALUES
( '0418', 'เวียงเก่า', '28', '40150', 1 )
INSERT INTO tbm_district
VALUES
( '0419', 'ท้องถิ่นเทศบาลตำบลบ้านเป็ด', '28', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0420', 'เทศบาลตำบลเมืองพล', '28', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0421', 'เมืองอุดรธานี', '29', '41000', 1 )
INSERT INTO tbm_district
VALUES
( '0422', 'กุดจับ', '29', '41250', 1 )
INSERT INTO tbm_district
VALUES
( '0423', 'หนองวัวซอ', '29', '41220', 1 )
INSERT INTO tbm_district
VALUES
( '0424', 'กุมภวาปี', '29', '41110', 1 )
INSERT INTO tbm_district
VALUES
( '0425', 'โนนสะอาด', '29', '41240', 1 )
INSERT INTO tbm_district
VALUES
( '0426', 'หนองหาน', '29', '41130', 1 )
INSERT INTO tbm_district
VALUES
( '0427', 'ทุ่งฝน', '29', '41310', 1 )
INSERT INTO tbm_district
VALUES
( '0428', 'ไชยวาน', '29', '41290', 1 )
INSERT INTO tbm_district
VALUES
( '0429', 'ศรีธาตุ', '29', '41230', 1 )
INSERT INTO tbm_district
VALUES
( '0430', 'วังสามหมอ', '29', '41280', 1 )
INSERT INTO tbm_district
VALUES
( '0431', 'บ้านดุง', '29', '41190', 1 )
INSERT INTO tbm_district
VALUES
( '0432', 'หนองบัวลำภู', '29', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0433', 'ศรีบุญเรือง', '29', '39180', -1 )
INSERT INTO tbm_district
VALUES
( '0434', 'นากลาง', '29', '39350', -1 )
INSERT INTO tbm_district
VALUES
( '0435', 'สุวรรณคูหา', '29', '39270', -1 )
INSERT INTO tbm_district
VALUES
( '0436', 'โนนสัง', '29', '39140', -1 )
INSERT INTO tbm_district
VALUES
( '0437', 'บ้านผือ', '29', '41160', 1 )
INSERT INTO tbm_district
VALUES
( '0438', 'น้ำโสม', '29', '41210', 1 )
INSERT INTO tbm_district
VALUES
( '0439', 'เพ็ญ', '29', '41150', 1 )
INSERT INTO tbm_district
VALUES
( '0440', 'สร้างคอม', '29', '41260', 1 )
INSERT INTO tbm_district
VALUES
( '0441', 'หนองแสง', '29', '41340', 1 )
INSERT INTO tbm_district
VALUES
( '0442', 'นายูง', '29', '41380', 1 )
INSERT INTO tbm_district
VALUES
( '0443', 'พิบูลย์รักษ์', '29', '41130', 1 )
INSERT INTO tbm_district
VALUES
( '0444', 'กู่แก้ว', '29', '41130', 1 )
INSERT INTO tbm_district
VALUES
( '0445', 'ประจักษ์ศิลปาคม', '29', '41110', 1 )
INSERT INTO tbm_district
VALUES
( '0446', 'เมืองเลย', '30', '42000', 1 )
INSERT INTO tbm_district
VALUES
( '0447', 'นาด้วง', '30', '42210', 1 )
INSERT INTO tbm_district
VALUES
( '0448', 'เชียงคาน', '30', '42110', 1 )
INSERT INTO tbm_district
VALUES
( '0449', 'ปากชม', '30', '42150', 1 )
INSERT INTO tbm_district
VALUES
( '0450', 'ด่านซ้าย', '30', '42120', 1 )
INSERT INTO tbm_district
VALUES
( '0451', 'นาแห้ว', '30', '42170', 1 )
INSERT INTO tbm_district
VALUES
( '0452', 'ภูเรือ', '30', '42160', 1 )
INSERT INTO tbm_district
VALUES
( '0453', 'ท่าลี่', '30', '42140', 1 )
INSERT INTO tbm_district
VALUES
( '0454', 'วังสะพุง', '30', '42130', 1 )
INSERT INTO tbm_district
VALUES
( '0455', 'ภูกระดึง', '30', '42180', 1 )
INSERT INTO tbm_district
VALUES
( '0456', 'ภูหลวง', '30', '42230', 1 )
INSERT INTO tbm_district
VALUES
( '0457', 'ผาขาว', '30', '42240', 1 )
INSERT INTO tbm_district
VALUES
( '0458', 'เอราวัณ', '30', '42220', 1 )
INSERT INTO tbm_district
VALUES
( '0459', 'หนองหิน', '30', '42190', 1 )
INSERT INTO tbm_district
VALUES
( '0460', 'เมืองหนองคาย', '31', '43000', 1 )
INSERT INTO tbm_district
VALUES
( '0461', 'ท่าบ่อ', '31', '43110', 1 )
INSERT INTO tbm_district
VALUES
( '0462', 'บึงกาฬ', '31', '43140', 1 )
INSERT INTO tbm_district
VALUES
( '0463', 'พรเจริญ', '31', '43180', 1 )
INSERT INTO tbm_district
VALUES
( '0464', 'โพนพิสัย', '31', '43120', 1 )
INSERT INTO tbm_district
VALUES
( '0465', 'โซ่พิสัย', '31', '43170', 1 )
INSERT INTO tbm_district
VALUES
( '0466', 'ศรีเชียงใหม่', '31', '43130', 1 )
INSERT INTO tbm_district
VALUES
( '0467', 'สังคม', '31', '43160', 1 )
INSERT INTO tbm_district
VALUES
( '0468', 'เซกา', '31', '43150', 1 )
INSERT INTO tbm_district
VALUES
( '0469', 'ปากคาด', '31', '43190', 1 )
INSERT INTO tbm_district
VALUES
( '0470', 'บึงโขงหลง', '31', '43220', 1 )
INSERT INTO tbm_district
VALUES
( '0471', 'ศรีวิไล', '31', '43210', 1 )
INSERT INTO tbm_district
VALUES
( '0472', 'บุ่งคล้า', '31', '43140', 1 )
INSERT INTO tbm_district
VALUES
( '0473', 'สระใคร', '31', '43100', 1 )
INSERT INTO tbm_district
VALUES
( '0474', 'เฝ้าไร่', '31', '43120', 1 )
INSERT INTO tbm_district
VALUES
( '0475', 'รัตนวาปี', '31', '43120', 1 )
INSERT INTO tbm_district
VALUES
( '0476', 'โพธิ์ตาก', '31', '43130', 1 )
INSERT INTO tbm_district
VALUES
( '0477', 'เมืองมหาสารคาม', '32', '44000', 1 )
INSERT INTO tbm_district
VALUES
( '0478', 'แกดำ', '32', '44190', 1 )
INSERT INTO tbm_district
VALUES
( '0479', 'โกสุมพิสัย', '32', '44140', 1 )
INSERT INTO tbm_district
VALUES
( '0480', 'กันทรวิชัย', '32', '44150', 1 )
INSERT INTO tbm_district
VALUES
( '0481', 'เชียงยืน', '32', '44160', 1 )
INSERT INTO tbm_district
VALUES
( '0482', 'บรบือ', '32', '44130', 1 )
INSERT INTO tbm_district
VALUES
( '0483', 'นาเชือก', '32', '44170', 1 )
INSERT INTO tbm_district
VALUES
( '0484', 'พยัคฆภูมิพิสัย', '32', '44110', 1 )
INSERT INTO tbm_district
VALUES
( '0485', 'วาปีปทุม', '32', '44120', 1 )
INSERT INTO tbm_district
VALUES
( '0486', 'นาดูน', '32', '44180', 1 )
INSERT INTO tbm_district
VALUES
( '0487', 'ยางสีสุราช', '32', '44210', 1 )
INSERT INTO tbm_district
VALUES
( '0488', 'กุดรัง', '32', '44130', 1 )
INSERT INTO tbm_district
VALUES
( '0489', 'ชื่นชม', '32', '44160', 1 )
INSERT INTO tbm_district
VALUES
( '0490', 'หลุบ', '32', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0491', 'เมืองร้อยเอ็ด', '33', '45000', 1 )
INSERT INTO tbm_district
VALUES
( '0492', 'เกษตรวิสัย', '33', '45150', 1 )
INSERT INTO tbm_district
VALUES
( '0493', 'ปทุมรัตต์', '33', '45190', 1 )
INSERT INTO tbm_district
VALUES
( '0494', 'จตุรพักตรพิมาน', '33', '45180', 1 )
INSERT INTO tbm_district
VALUES
( '0495', 'ธวัชบุรี', '33', '45170', 1 )
INSERT INTO tbm_district
VALUES
( '0496', 'พนมไพร', '33', '45140', 1 )
INSERT INTO tbm_district
VALUES
( '0497', 'โพนทอง', '33', '45110', 1 )
INSERT INTO tbm_district
VALUES
( '0498', 'โพธิ์ชัย', '33', '45230', 1 )
INSERT INTO tbm_district
VALUES
( '0499', 'หนองพอก', '33', '45210', 1 )
INSERT INTO tbm_district
VALUES
( '0500', 'เสลภูมิ', '33', '45120', 1 )
INSERT INTO tbm_district
VALUES
( '0501', 'สุวรรณภูมิ', '33', '45130', 1 )
INSERT INTO tbm_district
VALUES
( '0502', 'เมืองสรวง', '33', '45220', 1 )
INSERT INTO tbm_district
VALUES
( '0503', 'โพนทราย', '33', '45240', 1 )
INSERT INTO tbm_district
VALUES
( '0504', 'อาจสามารถ', '33', '45160', 1 )
INSERT INTO tbm_district
VALUES
( '0505', 'เมยวดี', '33', '45250', 1 )
INSERT INTO tbm_district
VALUES
( '0506', 'ศรีสมเด็จ', '33', '45000', 1 )
INSERT INTO tbm_district
VALUES
( '0507', 'จังหาร', '33', '45000', 1 )
INSERT INTO tbm_district
VALUES
( '0508', 'เชียงขวัญ', '33', '45000', 1 )
INSERT INTO tbm_district
VALUES
( '0509', 'หนองฮี', '33', '45140', 1 )
INSERT INTO tbm_district
VALUES
( '0510', 'ทุ่งเขาหลวง', '33', '45170', 1 )
INSERT INTO tbm_district
VALUES
( '0511', 'เมืองกาฬสินธุ์', '34', '46000', 1 )
INSERT INTO tbm_district
VALUES
( '0512', 'นามน', '34', '46230', 1 )
INSERT INTO tbm_district
VALUES
( '0513', 'กมลาไสย', '34', '46130', 1 )
INSERT INTO tbm_district
VALUES
( '0514', 'ร่องคำ', '34', '46210', 1 )
INSERT INTO tbm_district
VALUES
( '0515', 'กุฉินารายณ์', '34', '46110', 1 )
INSERT INTO tbm_district
VALUES
( '0516', 'เขาวง', '34', '46160', 1 )
INSERT INTO tbm_district
VALUES
( '0517', 'ยางตลาด', '34', '46120', 1 )
INSERT INTO tbm_district
VALUES
( '0518', 'ห้วยเม็ก', '34', '46170', 1 )
INSERT INTO tbm_district
VALUES
( '0519', 'สหัสขันธ์', '34', '46140', 1 )
INSERT INTO tbm_district
VALUES
( '0520', 'คำม่วง', '34', '46180', 1 )
INSERT INTO tbm_district
VALUES
( '0521', 'ท่าคันโท', '34', '46190', 1 )
INSERT INTO tbm_district
VALUES
( '0522', 'หนองกุงศรี', '34', '46220', 1 )
INSERT INTO tbm_district
VALUES
( '0523', 'สมเด็จ', '34', '46150', 1 )
INSERT INTO tbm_district
VALUES
( '0524', 'ห้วยผึ้ง', '34', '46240', 1 )
INSERT INTO tbm_district
VALUES
( '0525', 'สามชัย', '34', '46180', 1 )
INSERT INTO tbm_district
VALUES
( '0526', 'นาคู', '34', '46160', 1 )
INSERT INTO tbm_district
VALUES
( '0527', 'ดอนจาน', '34', '46000', 1 )
INSERT INTO tbm_district
VALUES
( '0528', 'ฆ้องชัย', '34', '46130', 1 )
INSERT INTO tbm_district
VALUES
( '0529', 'เมืองสกลนคร', '35', '47000', 1 )
INSERT INTO tbm_district
VALUES
( '0530', 'กุสุมาลย์', '35', '47210', 1 )
INSERT INTO tbm_district
VALUES
( '0531', 'กุดบาก', '35', '47180', 1 )
INSERT INTO tbm_district
VALUES
( '0532', 'พรรณานิคม', '35', '47130', 1 )
INSERT INTO tbm_district
VALUES
( '0533', 'พังโคน', '35', '47160', 1 )
INSERT INTO tbm_district
VALUES
( '0534', 'วาริชภูมิ', '35', '47150', 1 )
INSERT INTO tbm_district
VALUES
( '0535', 'นิคมน้ำอูน', '35', '47270', 1 )
INSERT INTO tbm_district
VALUES
( '0536', 'วานรนิวาส', '35', '47120', 1 )
INSERT INTO tbm_district
VALUES
( '0537', 'คำตากล้า', '35', '47250', 1 )
INSERT INTO tbm_district
VALUES
( '0538', 'บ้านม่วง', '35', '47140', 1 )
INSERT INTO tbm_district
VALUES
( '0539', 'อากาศอำนวย', '35', '47170', 1 )
INSERT INTO tbm_district
VALUES
( '0540', 'สว่างแดนดิน', '35', '47110', 1 )
INSERT INTO tbm_district
VALUES
( '0541', 'ส่องดาว', '35', '47190', 1 )
INSERT INTO tbm_district
VALUES
( '0542', 'เต่างอย', '35', '47260', 1 )
INSERT INTO tbm_district
VALUES
( '0543', 'โคกศรีสุพรรณ', '35', '47280', 1 )
INSERT INTO tbm_district
VALUES
( '0544', 'เจริญศิลป์', '35', '47290', 1 )
INSERT INTO tbm_district
VALUES
( '0545', 'โพนนาแก้ว', '35', '47230', 1 )
INSERT INTO tbm_district
VALUES
( '0546', 'ภูพาน', '35', '47180', 1 )
INSERT INTO tbm_district
VALUES
( '0547', 'วานรนิวาส (สาขาตำบลกุดเรือคำ)', '35', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0548', 'อ.บ้านหัน  จ.สกลนคร', '35', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0549', 'เมืองนครพนม', '36', '48000', 1 )
INSERT INTO tbm_district
VALUES
( '0550', 'ปลาปาก', '36', '48160', 1 )
INSERT INTO tbm_district
VALUES
( '0551', 'ท่าอุเทน', '36', '48120', 1 )
INSERT INTO tbm_district
VALUES
( '0552', 'บ้านแพง', '36', '48140', 1 )
INSERT INTO tbm_district
VALUES
( '0553', 'ธาตุพนม', '36', '48110', 1 )
INSERT INTO tbm_district
VALUES
( '0554', 'เรณูนคร', '36', '48170', 1 )
INSERT INTO tbm_district
VALUES
( '0555', 'นาแก', '36', '48130', 1 )
INSERT INTO tbm_district
VALUES
( '0556', 'ศรีสงคราม', '36', '48150', 1 )
INSERT INTO tbm_district
VALUES
( '0557', 'นาหว้า', '36', '48180', 1 )
INSERT INTO tbm_district
VALUES
( '0558', 'โพนสวรรค์', '36', '48190', 1 )
INSERT INTO tbm_district
VALUES
( '0559', 'นาทม', '36', '48140', 1 )
INSERT INTO tbm_district
VALUES
( '0560', 'วังยาง', '36', '48130', 1 )
INSERT INTO tbm_district
VALUES
( '0561', 'เมืองมุกดาหาร', '37', '49000', 1 )
INSERT INTO tbm_district
VALUES
( '0562', 'นิคมคำสร้อย', '37', '49130', 1 )
INSERT INTO tbm_district
VALUES
( '0563', 'ดอนตาล', '37', '49120', 1 )
INSERT INTO tbm_district
VALUES
( '0564', 'ดงหลวง', '37', '49140', 1 )
INSERT INTO tbm_district
VALUES
( '0565', 'คำชะอี', '37', '49110', 1 )
INSERT INTO tbm_district
VALUES
( '0566', 'หว้านใหญ่', '37', '49150', 1 )
INSERT INTO tbm_district
VALUES
( '0567', 'หนองสูง', '37', '49160', 1 )
INSERT INTO tbm_district
VALUES
( '0568', 'เมืองเชียงใหม่', '38', '50000', 1 )
INSERT INTO tbm_district
VALUES
( '0569', 'จอมทอง', '38', '50160', 1 )
INSERT INTO tbm_district
VALUES
( '0570', 'แม่แจ่ม', '38', '50270', 1 )
INSERT INTO tbm_district
VALUES
( '0571', 'เชียงดาว', '38', '50170', 1 )
INSERT INTO tbm_district
VALUES
( '0572', 'ดอยสะเก็ด', '38', '50220', 1 )
INSERT INTO tbm_district
VALUES
( '0573', 'แม่แตง', '38', '50150', 1 )
INSERT INTO tbm_district
VALUES
( '0574', 'แม่ริม', '38', '50180', 1 )
INSERT INTO tbm_district
VALUES
( '0575', 'สะเมิง', '38', '50250', 1 )
INSERT INTO tbm_district
VALUES
( '0576', 'ฝาง', '38', '50110', 1 )
INSERT INTO tbm_district
VALUES
( '0577', 'แม่อาย', '38', '50280', 1 )
INSERT INTO tbm_district
VALUES
( '0578', 'พร้าว', '38', '50190', 1 )
INSERT INTO tbm_district
VALUES
( '0579', 'สันป่าตอง', '38', '50120', 1 )
INSERT INTO tbm_district
VALUES
( '0580', 'สันกำแพง', '38', '50130', 1 )
INSERT INTO tbm_district
VALUES
( '0581', 'สันทราย', '38', '50210', 1 )
INSERT INTO tbm_district
VALUES
( '0582', 'หางดง', '38', '50230', 1 )
INSERT INTO tbm_district
VALUES
( '0583', 'ฮอด', '38', '50240', 1 )
INSERT INTO tbm_district
VALUES
( '0584', 'ดอยเต่า', '38', '50260', 1 )
INSERT INTO tbm_district
VALUES
( '0585', 'อมก๋อย', '38', '50310', 1 )
INSERT INTO tbm_district
VALUES
( '0586', 'สารภี', '38', '50140', 1 )
INSERT INTO tbm_district
VALUES
( '0587', 'เวียงแหง', '38', '50350', 1 )
INSERT INTO tbm_district
VALUES
( '0588', 'ไชยปราการ', '38', '50320', 1 )
INSERT INTO tbm_district
VALUES
( '0589', 'แม่วาง', '38', '50360', 1 )
INSERT INTO tbm_district
VALUES
( '0590', 'แม่ออน', '38', '50130', 1 )
INSERT INTO tbm_district
VALUES
( '0591', 'ดอยหล่อ', '38', '50160', 1 )
INSERT INTO tbm_district
VALUES
( '0592', 'เทศบาลนครเชียงใหม่ (สาขาแขวงกาลวิละ', '38', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0593', 'เทศบาลนครเชียงใหม่ (สาขาแขวงศรีวิชั', '38', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0594', 'เทศบาลนครเชียงใหม่ (สาขาเม็งราย', '38', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0595', 'เมืองลำพูน', '39', '51000', 1 )
INSERT INTO tbm_district
VALUES
( '0596', 'แม่ทา', '39', '51140', 1 )
INSERT INTO tbm_district
VALUES
( '0597', 'บ้านโฮ่ง', '39', '51130', 1 )
INSERT INTO tbm_district
VALUES
( '0598', 'ลี้', '39', '51110', 1 )
INSERT INTO tbm_district
VALUES
( '0599', 'ทุ่งหัวช้าง', '39', '51160', 1 )
INSERT INTO tbm_district
VALUES
( '0600', 'ป่าซาง', '39', '51120', 1 )
INSERT INTO tbm_district
VALUES
( '0601', 'บ้านธิ', '39', '51180', 1 )
INSERT INTO tbm_district
VALUES
( '0602', 'เวียงหนองล่อง', '39', '51120', 1 )
INSERT INTO tbm_district
VALUES
( '0603', 'เมืองลำปาง', '40', '52000', 1 )
INSERT INTO tbm_district
VALUES
( '0604', 'แม่เมาะ', '40', '52000', 1 )
INSERT INTO tbm_district
VALUES
( '0605', 'เกาะคา', '40', '52130', 1 )
INSERT INTO tbm_district
VALUES
( '0606', 'เสริมงาม', '40', '52210', 1 )
INSERT INTO tbm_district
VALUES
( '0607', 'งาว', '40', '52110', 1 )
INSERT INTO tbm_district
VALUES
( '0608', 'แจ้ห่ม', '40', '52120', 1 )
INSERT INTO tbm_district
VALUES
( '0609', 'วังเหนือ', '40', '52140', 1 )
INSERT INTO tbm_district
VALUES
( '0610', 'เถิน', '40', '52160', 1 )
INSERT INTO tbm_district
VALUES
( '0611', 'แม่พริก', '40', '52180', 1 )
INSERT INTO tbm_district
VALUES
( '0612', 'แม่ทะ', '40', '52150', 1 )
INSERT INTO tbm_district
VALUES
( '0613', 'สบปราบ', '40', '52170', 1 )
INSERT INTO tbm_district
VALUES
( '0614', 'ห้างฉัตร', '40', '52190', 1 )
INSERT INTO tbm_district
VALUES
( '0615', 'เมืองปาน', '40', '52240', 1 )
INSERT INTO tbm_district
VALUES
( '0616', 'เมืองอุตรดิตถ์', '41', '53000', 1 )
INSERT INTO tbm_district
VALUES
( '0617', 'ตรอน', '41', '53140', 1 )
INSERT INTO tbm_district
VALUES
( '0618', 'ท่าปลา', '41', '53110', 1 )
INSERT INTO tbm_district
VALUES
( '0619', 'น้ำปาด', '41', '53110', 1 )
INSERT INTO tbm_district
VALUES
( '0620', 'ฟากท่า', '41', '53160', 1 )
INSERT INTO tbm_district
VALUES
( '0621', 'บ้านโคก', '41', '53180', 1 )
INSERT INTO tbm_district
VALUES
( '0622', 'พิชัย', '41', '53120', 1 )
INSERT INTO tbm_district
VALUES
( '0623', 'ลับแล', '41', '53130', 1 )
INSERT INTO tbm_district
VALUES
( '0624', 'ทองแสนขัน', '41', '53230', 1 )
INSERT INTO tbm_district
VALUES
( '0625', 'เมืองแพร่', '42', '54000', 1 )
INSERT INTO tbm_district
VALUES
( '0626', 'ร้องกวาง', '42', '54140', 1 )
INSERT INTO tbm_district
VALUES
( '0627', 'ลอง', '42', '54150', 1 )
INSERT INTO tbm_district
VALUES
( '0628', 'สูงเม่น', '42', '54000', 1 )
INSERT INTO tbm_district
VALUES
( '0629', 'เด่นชัย', '42', '54110', 1 )
INSERT INTO tbm_district
VALUES
( '0630', 'สอง', '42', '54120', 1 )
INSERT INTO tbm_district
VALUES
( '0631', 'วังชิ้น', '42', '54160', 1 )
INSERT INTO tbm_district
VALUES
( '0632', 'หนองม่วงไข่', '42', '54170', 1 )
INSERT INTO tbm_district
VALUES
( '0633', 'เมืองน่าน', '43', '55000', 1 )
INSERT INTO tbm_district
VALUES
( '0634', 'แม่จริม', '43', '55170', 1 )
INSERT INTO tbm_district
VALUES
( '0635', 'บ้านหลวง', '43', '55190', 1 )
INSERT INTO tbm_district
VALUES
( '0636', 'นาน้อย', '43', '55150', 1 )
INSERT INTO tbm_district
VALUES
( '0637', 'ปัว', '43', '55120', 1 )
INSERT INTO tbm_district
VALUES
( '0638', 'ท่าวังผา', '43', '55140', 1 )
INSERT INTO tbm_district
VALUES
( '0639', 'เวียงสา', '43', '55110', 1 )
INSERT INTO tbm_district
VALUES
( '0640', 'ทุ่งช้าง', '43', '55130', 1 )
INSERT INTO tbm_district
VALUES
( '0641', 'เชียงกลาง', '43', '55160', 1 )
INSERT INTO tbm_district
VALUES
( '0642', 'นาหมื่น', '43', '55180', 1 )
INSERT INTO tbm_district
VALUES
( '0643', 'สันติสุข', '43', '55210', 1 )
INSERT INTO tbm_district
VALUES
( '0644', 'บ่อเกลือ', '43', '55220', 1 )
INSERT INTO tbm_district
VALUES
( '0645', 'สองแคว', '43', '55160', 1 )
INSERT INTO tbm_district
VALUES
( '0646', 'ภูเพียง', '43', '55000', 1 )
INSERT INTO tbm_district
VALUES
( '0647', 'เฉลิมพระเกียรติ', '43', '55130', 1 )
INSERT INTO tbm_district
VALUES
( '0648', 'เมืองพะเยา', '44', '56000', 1 )
INSERT INTO tbm_district
VALUES
( '0649', 'จุน', '44', '56150', 1 )
INSERT INTO tbm_district
VALUES
( '0650', 'เชียงคำ', '44', '56110', 1 )
INSERT INTO tbm_district
VALUES
( '0651', 'เชียงม่วน', '44', '56160', 1 )
INSERT INTO tbm_district
VALUES
( '0652', 'ดอกคำใต้', '44', '56120', 1 )
INSERT INTO tbm_district
VALUES
( '0653', 'ปง', '44', '56140', 1 )
INSERT INTO tbm_district
VALUES
( '0654', 'แม่ใจ', '44', '56130', 1 )
INSERT INTO tbm_district
VALUES
( '0655', 'ภูซาง', '44', '56110', 1 )
INSERT INTO tbm_district
VALUES
( '0656', 'ภูกามยาว', '44', '56000', 1 )
INSERT INTO tbm_district
VALUES
( '0657', 'เมืองเชียงราย', '45', '57000', 1 )
INSERT INTO tbm_district
VALUES
( '0658', 'เวียงชัย', '45', '57210', 1 )
INSERT INTO tbm_district
VALUES
( '0659', 'เชียงของ', '45', '57140', 1 )
INSERT INTO tbm_district
VALUES
( '0660', 'เทิง', '45', '57160', 1 )
INSERT INTO tbm_district
VALUES
( '0661', 'พาน', '45', '57120', 1 )
INSERT INTO tbm_district
VALUES
( '0662', 'ป่าแดด', '45', '57190', 1 )
INSERT INTO tbm_district
VALUES
( '0663', 'แม่จัน', '45', '57110', 1 )
INSERT INTO tbm_district
VALUES
( '0664', 'เชียงแสน', '45', '57150', 1 )
INSERT INTO tbm_district
VALUES
( '0665', 'แม่สาย', '45', '57130', 1 )
INSERT INTO tbm_district
VALUES
( '0666', 'แม่สรวย', '45', '57180', 1 )
INSERT INTO tbm_district
VALUES
( '0667', 'เวียงป่าเป้า', '45', '57170', 1 )
INSERT INTO tbm_district
VALUES
( '0668', 'พญาเม็งราย', '45', '57290', 1 )
INSERT INTO tbm_district
VALUES
( '0669', 'เวียงแก่น', '45', '57310', 1 )
INSERT INTO tbm_district
VALUES
( '0670', 'ขุนตาล', '45', '57340', 1 )
INSERT INTO tbm_district
VALUES
( '0671', 'แม่ฟ้าหลวง', '45', '57110', 1 )
INSERT INTO tbm_district
VALUES
( '0672', 'แม่ลาว', '45', '57000', 1 )
INSERT INTO tbm_district
VALUES
( '0673', 'เวียงเชียงรุ้ง', '45', '57210', 1 )
INSERT INTO tbm_district
VALUES
( '0674', 'ดอยหลวง', '45', '57110', 1 )
INSERT INTO tbm_district
VALUES
( '0675', 'เมืองแม่ฮ่องสอน', '46', '58000', 1 )
INSERT INTO tbm_district
VALUES
( '0676', 'ขุนยวม', '46', '58140', 1 )
INSERT INTO tbm_district
VALUES
( '0677', 'ปาย', '46', '58130', 1 )
INSERT INTO tbm_district
VALUES
( '0678', 'แม่สะเรียง', '46', '58110', 1 )
INSERT INTO tbm_district
VALUES
( '0679', 'แม่ลาน้อย', '46', '58120', 1 )
INSERT INTO tbm_district
VALUES
( '0680', 'สบเมย', '46', '58110', 1 )
INSERT INTO tbm_district
VALUES
( '0681', 'ปางมะผ้า', '46', '58150', 1 )
INSERT INTO tbm_district
VALUES
( '0682', 'อ.ม่วยต่อ  จ.แม่ฮ่องสอน', '46', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0683', 'เมืองนครสวรรค์', '47', '60000', 1 )
INSERT INTO tbm_district
VALUES
( '0684', 'โกรกพระ', '47', '60170', 1 )
INSERT INTO tbm_district
VALUES
( '0685', 'ชุมแสง', '47', '60120', 1 )
INSERT INTO tbm_district
VALUES
( '0686', 'หนองบัว', '47', '60110', 1 )
INSERT INTO tbm_district
VALUES
( '0687', 'บรรพตพิสัย', '47', '60180', 1 )
INSERT INTO tbm_district
VALUES
( '0688', 'เก้าเลี้ยว', '47', '60230', 1 )
INSERT INTO tbm_district
VALUES
( '0689', 'ตาคลี', '47', '60140', 1 )
INSERT INTO tbm_district
VALUES
( '0690', 'ท่าตะโก', '47', '60160', 1 )
INSERT INTO tbm_district
VALUES
( '0691', 'ไพศาลี', '47', '60220', 1 )
INSERT INTO tbm_district
VALUES
( '0692', 'พยุหะคีรี', '47', '60130', 1 )
INSERT INTO tbm_district
VALUES
( '0693', 'ลาดยาว', '47', '60150', 1 )
INSERT INTO tbm_district
VALUES
( '0694', 'ตากฟ้า', '47', '60190', 1 )
INSERT INTO tbm_district
VALUES
( '0695', 'แม่วงก์', '47', '60150', 1 )
INSERT INTO tbm_district
VALUES
( '0696', 'แม่เปิน', '47', '60150', 1 )
INSERT INTO tbm_district
VALUES
( '0697', 'ชุมตาบง', '47', '60150', 1 )
INSERT INTO tbm_district
VALUES
( '0698', 'สาขาตำบลห้วยน้ำหอม', '47', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0699', 'กิ่งอำเภอชุมตาบง (สาขาตำบลชุมตาบง)', '47', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0700', 'แม่วงก์ (สาขาตำบลแม่เล่ย์)', '47', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0701', 'เมืองอุทัยธานี', '48', '61000', 1 )
INSERT INTO tbm_district
VALUES
( '0702', 'ทัพทัน', '48', '61120', 1 )
INSERT INTO tbm_district
VALUES
( '0703', 'สว่างอารมณ์', '48', '61150', 1 )
INSERT INTO tbm_district
VALUES
( '0704', 'หนองฉาง', '48', '61110', 1 )
INSERT INTO tbm_district
VALUES
( '0705', 'หนองขาหย่าง', '48', '61130', 1 )
INSERT INTO tbm_district
VALUES
( '0706', 'บ้านไร่', '48', '61140', 1 )
INSERT INTO tbm_district
VALUES
( '0707', 'ลานสัก', '48', '61160', 1 )
INSERT INTO tbm_district
VALUES
( '0708', 'ห้วยคต', '48', '61170', 1 )
INSERT INTO tbm_district
VALUES
( '0709', 'เมืองกำแพงเพชร', '49', '62000', 1 )
INSERT INTO tbm_district
VALUES
( '0710', 'ไทรงาม', '49', '62150', 1 )
INSERT INTO tbm_district
VALUES
( '0711', 'คลองลาน', '49', '62180', 1 )
INSERT INTO tbm_district
VALUES
( '0712', 'ขาณุวรลักษบุรี', '49', '62130', 1 )
INSERT INTO tbm_district
VALUES
( '0713', 'คลองขลุง', '49', '62120', 1 )
INSERT INTO tbm_district
VALUES
( '0714', 'พรานกระต่าย', '49', '62110', 1 )
INSERT INTO tbm_district
VALUES
( '0715', 'ลานกระบือ', '49', '62170', 1 )
INSERT INTO tbm_district
VALUES
( '0716', 'ทรายทองวัฒนา', '49', '62190', 1 )
INSERT INTO tbm_district
VALUES
( '0717', 'ปางศิลาทอง', '49', '62120', 1 )
INSERT INTO tbm_district
VALUES
( '0718', 'บึงสามัคคี', '49', '62210', 1 )
INSERT INTO tbm_district
VALUES
( '0719', 'โกสัมพีนคร', '49', '62000', 1 )
INSERT INTO tbm_district
VALUES
( '0720', 'เมืองตาก', '50', '63000', 1 )
INSERT INTO tbm_district
VALUES
( '0721', 'บ้านตาก', '50', '63120', 1 )
INSERT INTO tbm_district
VALUES
( '0722', 'สามเงา', '50', '63130', 1 )
INSERT INTO tbm_district
VALUES
( '0723', 'แม่ระมาด', '50', '63140', 1 )
INSERT INTO tbm_district
VALUES
( '0724', 'ท่าสองยาง', '50', '63150', 1 )
INSERT INTO tbm_district
VALUES
( '0725', 'แม่สอด', '50', '63110', 1 )
INSERT INTO tbm_district
VALUES
( '0726', 'พบพระ', '50', '63160', 1 )
INSERT INTO tbm_district
VALUES
( '0727', 'อุ้มผาง', '50', '63170', 1 )
INSERT INTO tbm_district
VALUES
( '0728', 'วังเจ้า', '50', '63000', 1 )
INSERT INTO tbm_district
VALUES
( '0729', 'กิ่ง อ.ท่าปุย  จ.ตาก', '50', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0730', 'เมืองสุโขทัย', '51', '64000', 1 )
INSERT INTO tbm_district
VALUES
( '0731', 'บ้านด่านลานหอย', '51', '64140', 1 )
INSERT INTO tbm_district
VALUES
( '0732', 'คีรีมาศ', '51', '64160', 1 )
INSERT INTO tbm_district
VALUES
( '0733', 'กงไกรลาศ', '51', '64170', 1 )
INSERT INTO tbm_district
VALUES
( '0734', 'ศรีสัชนาลัย', '51', '64130', 1 )
INSERT INTO tbm_district
VALUES
( '0735', 'ศรีสำโรง', '51', '64120', 1 )
INSERT INTO tbm_district
VALUES
( '0736', 'สวรรคโลก', '51', '64110', 1 )
INSERT INTO tbm_district
VALUES
( '0737', 'ศรีนคร', '51', '64180', 1 )
INSERT INTO tbm_district
VALUES
( '0738', 'ทุ่งเสลี่ยม', '51', '64150', 1 )
INSERT INTO tbm_district
VALUES
( '0739', 'เมืองพิษณุโลก', '52', '65000', 1 )
INSERT INTO tbm_district
VALUES
( '0740', 'นครไทย', '52', '65120', 1 )
INSERT INTO tbm_district
VALUES
( '0741', 'ชาติตระการ', '52', '65170', 1 )
INSERT INTO tbm_district
VALUES
( '0742', 'บางระกำ', '52', '65140', 1 )
INSERT INTO tbm_district
VALUES
( '0743', 'บางกระทุ่ม', '52', '65110', 1 )
INSERT INTO tbm_district
VALUES
( '0744', 'พรหมพิราม', '52', '65150', 1 )
INSERT INTO tbm_district
VALUES
( '0745', 'วัดโบสถ์', '52', '65160', 1 )
INSERT INTO tbm_district
VALUES
( '0746', 'วังทอง', '52', '65130', 1 )
INSERT INTO tbm_district
VALUES
( '0747', 'เนินมะปราง', '52', '65190', 1 )
INSERT INTO tbm_district
VALUES
( '0748', 'เมืองพิจิตร', '53', '66000', 1 )
INSERT INTO tbm_district
VALUES
( '0749', 'วังทรายพูน', '53', '66180', 1 )
INSERT INTO tbm_district
VALUES
( '0750', 'โพธิ์ประทับช้าง', '53', '66190', 1 )
INSERT INTO tbm_district
VALUES
( '0751', 'ตะพานหิน', '53', '66110', 1 )
INSERT INTO tbm_district
VALUES
( '0752', 'บางมูลนาก', '53', '66120', 1 )
INSERT INTO tbm_district
VALUES
( '0753', 'โพทะเล', '53', '66130', 1 )
INSERT INTO tbm_district
VALUES
( '0754', 'สามง่าม', '53', '66140', 1 )
INSERT INTO tbm_district
VALUES
( '0755', 'ทับคล้อ', '53', '66150', 1 )
INSERT INTO tbm_district
VALUES
( '0756', 'สากเหล็ก', '53', '66160', 1 )
INSERT INTO tbm_district
VALUES
( '0757', 'บึงนาราง', '53', '66130', 1 )
INSERT INTO tbm_district
VALUES
( '0758', 'ดงเจริญ', '53', '66210', 1 )
INSERT INTO tbm_district
VALUES
( '0759', 'วชิรบารมี', '53', '66140', 1 )
INSERT INTO tbm_district
VALUES
( '0760', 'เมืองเพชรบูรณ์', '54', '67000', 1 )
INSERT INTO tbm_district
VALUES
( '0761', 'ชนแดน', '54', '67150', 1 )
INSERT INTO tbm_district
VALUES
( '0762', 'หล่มสัก', '54', '67110', 1 )
INSERT INTO tbm_district
VALUES
( '0763', 'หล่มเก่า', '54', '67120', 1 )
INSERT INTO tbm_district
VALUES
( '0764', 'วิเชียรบุรี', '54', '67130', 1 )
INSERT INTO tbm_district
VALUES
( '0765', 'ศรีเทพ', '54', '67170', 1 )
INSERT INTO tbm_district
VALUES
( '0766', 'หนองไผ่', '54', '67140', 1 )
INSERT INTO tbm_district
VALUES
( '0767', 'บึงสามพัน', '54', '67160', 1 )
INSERT INTO tbm_district
VALUES
( '0768', 'น้ำหนาว', '54', '67260', 1 )
INSERT INTO tbm_district
VALUES
( '0769', 'วังโป่ง', '54', '67240', 1 )
INSERT INTO tbm_district
VALUES
( '0770', 'เขาค้อ', '54', '67270', 1 )
INSERT INTO tbm_district
VALUES
( '0771', 'เมืองราชบุรี', '55', '70000', 1 )
INSERT INTO tbm_district
VALUES
( '0772', 'จอมบึง', '55', '70150', 1 )
INSERT INTO tbm_district
VALUES
( '0773', 'สวนผึ้ง', '55', '70180', 1 )
INSERT INTO tbm_district
VALUES
( '0774', 'ดำเนินสะดวก', '55', '70130', 1 )
INSERT INTO tbm_district
VALUES
( '0775', 'บ้านโป่ง', '55', '70110', 1 )
INSERT INTO tbm_district
VALUES
( '0776', 'บางแพ', '55', '70160', 1 )
INSERT INTO tbm_district
VALUES
( '0777', 'โพธาราม', '55', '70120', 1 )
INSERT INTO tbm_district
VALUES
( '0778', 'ปากท่อ', '55', '70140', 1 )
INSERT INTO tbm_district
VALUES
( '0779', 'วัดเพลง', '55', '70170', 1 )
INSERT INTO tbm_district
VALUES
( '0780', 'บ้านคา', '55', '70180', 1 )
INSERT INTO tbm_district
VALUES
( '0781', 'ท้องถิ่นเทศบาลตำบลบ้านฆ้อง', '55', NULL, 1 )
INSERT INTO tbm_district
VALUES
( '0782', 'เมืองกาญจนบุรี', '56', '71000', 1 )
INSERT INTO tbm_district
VALUES
( '0783', 'ไทรโยค', '56', '71150', 1 )
INSERT INTO tbm_district
VALUES
( '0784', 'บ่อพลอย', '56', '71160', 1 )
INSERT INTO tbm_district
VALUES
( '0785', 'ศรีสวัสดิ์', '56', '71220', 1 )
INSERT INTO tbm_district
VALUES
( '0786', 'ท่ามะกา', '56', '70190', 1 )
INSERT INTO tbm_district
VALUES
( '0787', 'ท่าม่วง', '56', '71000', 1 )
INSERT INTO tbm_district
VALUES
( '0788', 'ทองผาภูมิ', '56', '71180', 1 )
INSERT INTO tbm_district
VALUES
( '0789', 'สังขละบุรี', '56', '71240', 1 )
INSERT INTO tbm_district
VALUES
( '0790', 'พนมทวน', '56', '71140', 1 )
INSERT INTO tbm_district
VALUES
( '0791', 'เลาขวัญ', '56', '71210', 1 )
INSERT INTO tbm_district
VALUES
( '0792', 'ด่านมะขามเตี้ย', '56', '71260', 1 )
INSERT INTO tbm_district
VALUES
( '0793', 'หนองปรือ', '56', '71220', 1 )
INSERT INTO tbm_district
VALUES
( '0794', 'ห้วยกระเจา', '56', '71170', 1 )
INSERT INTO tbm_district
VALUES
( '0795', 'สาขาตำบลท่ากระดาน', '56', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0796', 'บ้านทวน  จ.กาญจนบุรี', '56', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0797', 'เมืองสุพรรณบุรี', '57', '72000', 1 )
INSERT INTO tbm_district
VALUES
( '0798', 'เดิมบางนางบวช', '57', '72120', 1 )
INSERT INTO tbm_district
VALUES
( '0799', 'ด่านช้าง', '57', '72180', 1 )
INSERT INTO tbm_district
VALUES
( '0800', 'บางปลาม้า', '57', '72150', 1 )
INSERT INTO tbm_district
VALUES
( '0801', 'ศรีประจันต์', '57', '72140', 1 )
INSERT INTO tbm_district
VALUES
( '0802', 'ดอนเจดีย์', '57', '72170', 1 )
INSERT INTO tbm_district
VALUES
( '0803', 'สองพี่น้อง', '57', '71170', 1 )
INSERT INTO tbm_district
VALUES
( '0804', 'สามชุก', '57', '72130', 1 )
INSERT INTO tbm_district
VALUES
( '0805', 'อู่ทอง', '57', '71170', 1 )
INSERT INTO tbm_district
VALUES
( '0806', 'หนองหญ้าไซ', '57', '72240', 1 )
INSERT INTO tbm_district
VALUES
( '0807', 'เมืองนครปฐม', '58', '73000', 1 )
INSERT INTO tbm_district
VALUES
( '0808', 'กำแพงแสน', '58', '73140', 1 )
INSERT INTO tbm_district
VALUES
( '0809', 'นครชัยศรี', '58', '73120', 1 )
INSERT INTO tbm_district
VALUES
( '0810', 'ดอนตูม', '58', '73150', 1 )
INSERT INTO tbm_district
VALUES
( '0811', 'บางเลน', '58', '73130', 1 )
INSERT INTO tbm_district
VALUES
( '0812', 'สามพราน', '58', '73110', 1 )
INSERT INTO tbm_district
VALUES
( '0813', 'พุทธมณฑล', '58', '73170', 1 )
INSERT INTO tbm_district
VALUES
( '0814', 'เมืองสมุทรสาคร', '59', '74000', 1 )
INSERT INTO tbm_district
VALUES
( '0815', 'กระทุ่มแบน', '59', '74110', 1 )
INSERT INTO tbm_district
VALUES
( '0816', 'บ้านแพ้ว', '59', '70210', 1 )
INSERT INTO tbm_district
VALUES
( '0817', 'เมืองสมุทรสงคราม', '60', '75000', 1 )
INSERT INTO tbm_district
VALUES
( '0818', 'บางคนที', '60', '75120', 1 )
INSERT INTO tbm_district
VALUES
( '0819', 'อัมพวา', '60', '75110', 1 )
INSERT INTO tbm_district
VALUES
( '0820', 'เมืองเพชรบุรี', '61', '76000', 1 )
INSERT INTO tbm_district
VALUES
( '0821', 'เขาย้อย', '61', '76140', 1 )
INSERT INTO tbm_district
VALUES
( '0822', 'หนองหญ้าปล้อง', '61', '76160', 1 )
INSERT INTO tbm_district
VALUES
( '0823', 'ชะอำ', '61', '76120', 1 )
INSERT INTO tbm_district
VALUES
( '0824', 'ท่ายาง', '61', '76130', 1 )
INSERT INTO tbm_district
VALUES
( '0825', 'บ้านลาด', '61', '76150', 1 )
INSERT INTO tbm_district
VALUES
( '0826', 'บ้านแหลม', '61', '76100', 1 )
INSERT INTO tbm_district
VALUES
( '0827', 'แก่งกระจาน', '61', '76170', 1 )
INSERT INTO tbm_district
VALUES
( '0828', 'เมืองประจวบคีรีขันธ์', '62', '77000', 1 )
INSERT INTO tbm_district
VALUES
( '0829', 'กุยบุรี', '62', '77150', 1 )
INSERT INTO tbm_district
VALUES
( '0830', 'ทับสะแก', '62', '77130', 1 )
INSERT INTO tbm_district
VALUES
( '0831', 'บางสะพาน', '62', '77140', 1 )
INSERT INTO tbm_district
VALUES
( '0832', 'บางสะพานน้อย', '62', '77170', 1 )
INSERT INTO tbm_district
VALUES
( '0833', 'ปราณบุรี', '62', '77120', 1 )
INSERT INTO tbm_district
VALUES
( '0834', 'หัวหิน', '62', '77110', 1 )
INSERT INTO tbm_district
VALUES
( '0835', 'สามร้อยยอด', '62', '77120', 1 )
INSERT INTO tbm_district
VALUES
( '0836', 'เมืองนครศรีธรรมราช', '63', '80000', 1 )
INSERT INTO tbm_district
VALUES
( '0837', 'พรหมคีรี', '63', '80320', 1 )
INSERT INTO tbm_district
VALUES
( '0838', 'ลานสกา', '63', '80230', 1 )
INSERT INTO tbm_district
VALUES
( '0839', 'ฉวาง', '63', '80150', 1 )
INSERT INTO tbm_district
VALUES
( '0840', 'พิปูน', '63', '80270', 1 )
INSERT INTO tbm_district
VALUES
( '0841', 'เชียรใหญ่', '63', '80190', 1 )
INSERT INTO tbm_district
VALUES
( '0842', 'ชะอวด', '63', '80180', 1 )
INSERT INTO tbm_district
VALUES
( '0843', 'ท่าศาลา', '63', '80160', 1 )
INSERT INTO tbm_district
VALUES
( '0844', 'ทุ่งสง', '63', '80110', 1 )
INSERT INTO tbm_district
VALUES
( '0845', 'นาบอน', '63', '80220', 1 )
INSERT INTO tbm_district
VALUES
( '0846', 'ทุ่งใหญ่', '63', '80240', 1 )
INSERT INTO tbm_district
VALUES
( '0847', 'ปากพนัง', '63', '80140', 1 )
INSERT INTO tbm_district
VALUES
( '0848', 'ร่อนพิบูลย์', '63', '80130', 1 )
INSERT INTO tbm_district
VALUES
( '0849', 'สิชล', '63', '80120', 1 )
INSERT INTO tbm_district
VALUES
( '0850', 'ขนอม', '63', '80210', 1 )
INSERT INTO tbm_district
VALUES
( '0851', 'หัวไทร', '63', '80170', 1 )
INSERT INTO tbm_district
VALUES
( '0852', 'บางขัน', '63', '80360', 1 )
INSERT INTO tbm_district
VALUES
( '0853', 'ถ้ำพรรณรา', '63', '80260', 1 )
INSERT INTO tbm_district
VALUES
( '0854', 'จุฬาภรณ์', '63', '80130', 1 )
INSERT INTO tbm_district
VALUES
( '0855', 'พระพรหม', '63', '80000', 1 )
INSERT INTO tbm_district
VALUES
( '0856', 'นบพิตำ', '63', '80160', 1 )
INSERT INTO tbm_district
VALUES
( '0857', 'ช้างกลาง', '63', '80220', 1 )
INSERT INTO tbm_district
VALUES
( '0858', 'เฉลิมพระเกียรติ', '63', '80190', 1 )
INSERT INTO tbm_district
VALUES
( '0859', 'เชียรใหญ่ (สาขาตำบลเสือหึง)', '63', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0860', 'สาขาตำบลสวนหลวง', '63', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0861', 'ร่อนพิบูลย์ (สาขาตำบลหินตก)', '63', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0862', 'หัวไทร (สาขาตำบลควนชะลิก)', '63', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0863', 'ทุ่งสง (สาขาตำบลกะปาง)', '63', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0864', 'เมืองกระบี่', '64', '81000', 1 )
INSERT INTO tbm_district
VALUES
( '0865', 'เขาพนม', '64', '80240', 1 )
INSERT INTO tbm_district
VALUES
( '0866', 'เกาะลันตา', '64', '81120', 1 )
INSERT INTO tbm_district
VALUES
( '0867', 'คลองท่อม', '64', '81120', 1 )
INSERT INTO tbm_district
VALUES
( '0868', 'อ่าวลึก', '64', '81110', 1 )
INSERT INTO tbm_district
VALUES
( '0869', 'ปลายพระยา', '64', '81160', 1 )
INSERT INTO tbm_district
VALUES
( '0870', 'ลำทับ', '64', '81120', 1 )
INSERT INTO tbm_district
VALUES
( '0871', 'เหนือคลอง', '64', '81130', 1 )
INSERT INTO tbm_district
VALUES
( '0872', 'เมืองพังงา', '65', '82000', 1 )
INSERT INTO tbm_district
VALUES
( '0873', 'เกาะยาว', '65', '82160', 1 )
INSERT INTO tbm_district
VALUES
( '0874', 'กะปง', '65', '82170', 1 )
INSERT INTO tbm_district
VALUES
( '0875', 'ตะกั่วทุ่ง', '65', '82130', 1 )
INSERT INTO tbm_district
VALUES
( '0876', 'ตะกั่วป่า', '65', '82110', 1 )
INSERT INTO tbm_district
VALUES
( '0877', 'คุระบุรี', '65', '82150', 1 )
INSERT INTO tbm_district
VALUES
( '0878', 'ทับปุด', '65', '82180', 1 )
INSERT INTO tbm_district
VALUES
( '0879', 'ท้ายเหมือง', '65', '82120', 1 )
INSERT INTO tbm_district
VALUES
( '0880', 'เมืองภูเก็ต', '66', '83000', 1 )
INSERT INTO tbm_district
VALUES
( '0881', 'กะทู้', '66', '83120', 1 )
INSERT INTO tbm_district
VALUES
( '0882', 'ถลาง', '66', '83110', 1 )
INSERT INTO tbm_district
VALUES
( '0883', 'ทุ่งคา', '66', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0884', 'เมืองสุราษฎร์ธานี', '67', '84000', 1 )
INSERT INTO tbm_district
VALUES
( '0885', 'กาญจนดิษฐ์', '67', '84160', 1 )
INSERT INTO tbm_district
VALUES
( '0886', 'ดอนสัก', '67', '84160', 1 )
INSERT INTO tbm_district
VALUES
( '0887', 'เกาะสมุย', '67', '84140', 1 )
INSERT INTO tbm_district
VALUES
( '0888', 'เกาะพะงัน', '67', '84280', 1 )
INSERT INTO tbm_district
VALUES
( '0889', 'ไชยา', '67', '84110', 1 )
INSERT INTO tbm_district
VALUES
( '0890', 'ท่าชนะ', '67', '84170', 1 )
INSERT INTO tbm_district
VALUES
( '0891', 'คีรีรัฐนิคม', '67', '84180', 1 )
INSERT INTO tbm_district
VALUES
( '0892', 'บ้านตาขุน', '67', '84230', 1 )
INSERT INTO tbm_district
VALUES
( '0893', 'พนม', '67', '84250', 1 )
INSERT INTO tbm_district
VALUES
( '0894', 'ท่าฉาง', '67', '84150', 1 )
INSERT INTO tbm_district
VALUES
( '0895', 'บ้านนาสาร', '67', '84120', 1 )
INSERT INTO tbm_district
VALUES
( '0896', 'บ้านนาเดิม', '67', '84240', 1 )
INSERT INTO tbm_district
VALUES
( '0897', 'เคียนซา', '67', '84210', 1 )
INSERT INTO tbm_district
VALUES
( '0898', 'เวียงสระ', '67', '84190', 1 )
INSERT INTO tbm_district
VALUES
( '0899', 'พระแสง', '67', '84210', 1 )
INSERT INTO tbm_district
VALUES
( '0900', 'พุนพิน', '67', '84130', 1 )
INSERT INTO tbm_district
VALUES
( '0901', 'ชัยบุรี', '67', '84350', 1 )
INSERT INTO tbm_district
VALUES
( '0902', 'วิภาวดี', '67', '84180', 1 )
INSERT INTO tbm_district
VALUES
( '0903', 'เกาะพงัน (สาขาตำบลเกาะเต่า)', '67', '84360', 1 )
INSERT INTO tbm_district
VALUES
( '0904', 'อ.บ้านดอน  จ.สุราษฎร์ธานี', '67', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0905', 'เมืองระนอง', '68', '85000', 1 )
INSERT INTO tbm_district
VALUES
( '0906', 'ละอุ่น', '68', '85130', 1 )
INSERT INTO tbm_district
VALUES
( '0907', 'กะเปอร์', '68', '85120', 1 )
INSERT INTO tbm_district
VALUES
( '0908', 'กระบุรี', '68', '85110', 1 )
INSERT INTO tbm_district
VALUES
( '0909', 'สุขสำราญ', '68', '85120', 1 )
INSERT INTO tbm_district
VALUES
( '0910', 'เมืองชุมพร', '69', '86000', 1 )
INSERT INTO tbm_district
VALUES
( '0911', 'ท่าแซะ', '69', '86140', 1 )
INSERT INTO tbm_district
VALUES
( '0912', 'ปะทิว', '69', '86160', 1 )
INSERT INTO tbm_district
VALUES
( '0913', 'หลังสวน', '69', '86110', 1 )
INSERT INTO tbm_district
VALUES
( '0914', 'ละแม', '69', '86170', 1 )
INSERT INTO tbm_district
VALUES
( '0915', 'พะโต๊ะ', '69', '86180', 1 )
INSERT INTO tbm_district
VALUES
( '0916', 'สวี', '69', '86130', 1 )
INSERT INTO tbm_district
VALUES
( '0917', 'ทุ่งตะโก', '69', '86220', 1 )
INSERT INTO tbm_district
VALUES
( '0918', 'เมืองสงขลา', '70', '90000', 1 )
INSERT INTO tbm_district
VALUES
( '0919', 'สทิงพระ', '70', '90190', 1 )
INSERT INTO tbm_district
VALUES
( '0920', 'จะนะ', '70', '90130', 1 )
INSERT INTO tbm_district
VALUES
( '0921', 'นาทวี', '70', '90160', 1 )
INSERT INTO tbm_district
VALUES
( '0922', 'เทพา', '70', '90150', 1 )
INSERT INTO tbm_district
VALUES
( '0923', 'สะบ้าย้อย', '70', '90210', 1 )
INSERT INTO tbm_district
VALUES
( '0924', 'ระโนด', '70', '90140', 1 )
INSERT INTO tbm_district
VALUES
( '0925', 'กระแสสินธุ์', '70', '90270', 1 )
INSERT INTO tbm_district
VALUES
( '0926', 'รัตภูมิ', '70', '90180', 1 )
INSERT INTO tbm_district
VALUES
( '0927', 'สะเดา', '70', '90120', 1 )
INSERT INTO tbm_district
VALUES
( '0928', 'หาดใหญ่', '70', '90110', 1 )
INSERT INTO tbm_district
VALUES
( '0929', 'นาหม่อม', '70', '90310', 1 )
INSERT INTO tbm_district
VALUES
( '0930', 'ควนเนียง', '70', '90220', 1 )
INSERT INTO tbm_district
VALUES
( '0931', 'บางกล่ำ', '70', '90110', 1 )
INSERT INTO tbm_district
VALUES
( '0932', 'สิงหนคร', '70', '90280', 1 )
INSERT INTO tbm_district
VALUES
( '0933', 'คลองหอยโข่ง', '70', '90115', 1 )
INSERT INTO tbm_district
VALUES
( '0934', 'ท้องถิ่นเทศบาลตำบลสำนักขาม', '70', NULL, 1 )
INSERT INTO tbm_district
VALUES
( '0935', 'เทศบาลตำบลบ้านพรุ', '70', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0936', 'เมืองสตูล', '71', '91000', 1 )
INSERT INTO tbm_district
VALUES
( '0937', 'ควนโดน', '71', '91160', 1 )
INSERT INTO tbm_district
VALUES
( '0938', 'ควนกาหลง', '71', '91130', 1 )
INSERT INTO tbm_district
VALUES
( '0939', 'ท่าแพ', '71', '91150', 1 )
INSERT INTO tbm_district
VALUES
( '0940', 'ละงู', '71', '91110', 1 )
INSERT INTO tbm_district
VALUES
( '0941', 'ทุ่งหว้า', '71', '91120', 1 )
INSERT INTO tbm_district
VALUES
( '0942', 'มะนัง', '71', '91130', 1 )
INSERT INTO tbm_district
VALUES
( '0943', 'เมืองตรัง', '72', '92000', 1 )
INSERT INTO tbm_district
VALUES
( '0944', 'กันตัง', '72', '92110', 1 )
INSERT INTO tbm_district
VALUES
( '0945', 'ย่านตาขาว', '72', '92140', 1 )
INSERT INTO tbm_district
VALUES
( '0946', 'ปะเหลียน', '72', '92120', 1 )
INSERT INTO tbm_district
VALUES
( '0947', 'สิเกา', '72', '92000', 1 )
INSERT INTO tbm_district
VALUES
( '0948', 'ห้วยยอด', '72', '92130', 1 )
INSERT INTO tbm_district
VALUES
( '0949', 'วังวิเศษ', '72', '92000', 1 )
INSERT INTO tbm_district
VALUES
( '0950', 'นาโยง', '72', '92170', 1 )
INSERT INTO tbm_district
VALUES
( '0951', 'รัษฎา', '72', '92130', 1 )
INSERT INTO tbm_district
VALUES
( '0952', 'หาดสำราญ', '72', '92120', 1 )
INSERT INTO tbm_district
VALUES
( '0953', 'อำเภอเมืองตรัง(สาขาคลองเต็ง)', '72', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0954', 'เมืองพัทลุง', '73', '93000', 1 )
INSERT INTO tbm_district
VALUES
( '0955', 'กงหรา', '73', '93000', 1 )
INSERT INTO tbm_district
VALUES
( '0956', 'เขาชัยสน', '73', '93130', 1 )
INSERT INTO tbm_district
VALUES
( '0957', 'ตะโหมด', '73', '93160', 1 )
INSERT INTO tbm_district
VALUES
( '0958', 'ควนขนุน', '73', '93110', 1 )
INSERT INTO tbm_district
VALUES
( '0959', 'ปากพะยูน', '73', '93120', 1 )
INSERT INTO tbm_district
VALUES
( '0960', 'ศรีบรรพต', '73', '93190', 1 )
INSERT INTO tbm_district
VALUES
( '0961', 'ป่าบอน', '73', '93170', 1 )
INSERT INTO tbm_district
VALUES
( '0962', 'บางแก้ว', '73', '93140', 1 )
INSERT INTO tbm_district
VALUES
( '0963', 'ป่าพะยอม', '73', '93110', 1 )
INSERT INTO tbm_district
VALUES
( '0964', 'ศรีนครินทร์', '73', '93000', 1 )
INSERT INTO tbm_district
VALUES
( '0965', 'เมืองปัตตานี', '74', '94000', 1 )
INSERT INTO tbm_district
VALUES
( '0966', 'โคกโพธิ์', '74', '94120', 1 )
INSERT INTO tbm_district
VALUES
( '0967', 'หนองจิก', '74', '94170', 1 )
INSERT INTO tbm_district
VALUES
( '0968', 'ปะนาเระ', '74', '94130', 1 )
INSERT INTO tbm_district
VALUES
( '0969', 'มายอ', '74', '94140', 1 )
INSERT INTO tbm_district
VALUES
( '0970', 'ทุ่งยางแดง', '74', '94140', 1 )
INSERT INTO tbm_district
VALUES
( '0971', 'สายบุรี', '74', '94110', 1 )
INSERT INTO tbm_district
VALUES
( '0972', 'ไม้แก่น', '74', '94220', 1 )
INSERT INTO tbm_district
VALUES
( '0973', 'ยะหริ่ง', '74', '94150', 1 )
INSERT INTO tbm_district
VALUES
( '0974', 'ยะรัง', '74', '94160', 1 )
INSERT INTO tbm_district
VALUES
( '0975', 'กะพ้อ', '74', '94230', 1 )
INSERT INTO tbm_district
VALUES
( '0976', 'แม่ลาน', '74', '94180', 1 )
INSERT INTO tbm_district
VALUES
( '0977', 'เมืองยะลา', '75', '95000', 1 )
INSERT INTO tbm_district
VALUES
( '0978', 'เบตง', '75', '95110', 1 )
INSERT INTO tbm_district
VALUES
( '0979', 'บันนังสตา', '75', '95130', 1 )
INSERT INTO tbm_district
VALUES
( '0980', 'ธารโต', '75', '95130', 1 )
INSERT INTO tbm_district
VALUES
( '0981', 'ยะหา', '75', '95120', 1 )
INSERT INTO tbm_district
VALUES
( '0982', 'รามัน', '75', '95140', 1 )
INSERT INTO tbm_district
VALUES
( '0983', 'กาบัง', '75', '95120', 1 )
INSERT INTO tbm_district
VALUES
( '0984', 'กรงปินัง', '75', '95000', 1 )
INSERT INTO tbm_district
VALUES
( '0985', 'เมืองนราธิวาส', '76', '96000', 1 )
INSERT INTO tbm_district
VALUES
( '0986', 'ตากใบ', '76', '96110', 1 )
INSERT INTO tbm_district
VALUES
( '0987', 'บาเจาะ', '76', '96170', 1 )
INSERT INTO tbm_district
VALUES
( '0988', 'ยี่งอ', '76', '96180', 1 )
INSERT INTO tbm_district
VALUES
( '0989', 'ระแงะ', '76', '96130', 1 )
INSERT INTO tbm_district
VALUES
( '0990', 'รือเสาะ', '76', '96150', 1 )
INSERT INTO tbm_district
VALUES
( '0991', 'ศรีสาคร', '76', '96210', 1 )
INSERT INTO tbm_district
VALUES
( '0992', 'แว้ง', '76', '96160', 1 )
INSERT INTO tbm_district
VALUES
( '0993', 'สุคิริน', '76', '96190', 1 )
INSERT INTO tbm_district
VALUES
( '0994', 'สุไหงโก-ลก', '76', NULL, 1 )
INSERT INTO tbm_district
VALUES
( '0995', 'สุไหงปาดี', '76', '96140', 1 )
INSERT INTO tbm_district
VALUES
( '0996', 'จะแนะ', '76', '96220', 1 )
INSERT INTO tbm_district
VALUES
( '0997', 'เจาะไอร้อง', '76', '96130', 1 )
INSERT INTO tbm_district
VALUES
( '0998', 'อ.บางนรา  จ.นราธิวาส', '76', NULL, -1 )
INSERT INTO tbm_district
VALUES
( '0999', 'กัลยาณิวัฒนา', '38', NULL, 1 )
INSERT INTO tbm_district
VALUES
( '1000', 'เซกา', '77', '38150', 1 )
INSERT INTO tbm_district
VALUES
( '1001', 'โซ่พิสัย', '77', '38170', 1 )
INSERT INTO tbm_district
VALUES
( '1002', 'บึงโขงหลง', '77', '38220', 1 )
INSERT INTO tbm_district
VALUES
( '1003', 'บุ่งคล้า', '77', '38000', 1 )
INSERT INTO tbm_district
VALUES
( '1004', 'เบญจลักษ์', '22', NULL, 1 )
INSERT INTO tbm_district
VALUES
( '1005', 'ปากคาด', '77', '38190', 1 )
INSERT INTO tbm_district
VALUES
( '1006', 'พรเจริญ', '77', '38180', 1 )
INSERT INTO tbm_district
VALUES
( '1007', 'เมืองบึงกาฬ', '77', '38000', 1 )
INSERT INTO tbm_district
VALUES
( '1008', 'ศรีวิไล', '77', '38210', 1 )
INSERT INTO tbm_district
VALUES
( '1009', 'ศีขรภูมิ', '21', NULL, 1 )
INSERT INTO tbm_district
VALUES
( '1010', 'สนามชัย', '15', NULL, 1 )
INSERT INTO tbm_district
VALUES
( '1011', 'สำนักทะเบียนกลาง', '01', NULL, 1 )
INSERT INTO tbm_district
VALUES
( '1012', 'หนองบุญมาก', '19', NULL, 1 )
INSERT INTO tbm_district
VALUES
( '1013', 'หนองบุนนาก', '19', '30410', 1 );
PRINT '================= district Table===================================';
TRUNCATE TABLE tbm_sub_district;
INSERT INTO tbm_sub_district
VALUES
( '00001', 'พระบรมมหาราชวัง', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00002', 'วังบูรพาภิรมย์', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00003', 'วัดราชบพิธ', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00004', 'สำราญราษฎร์', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00005', 'ศาลเจ้าพ่อเสือ', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00006', 'เสาชิงช้า', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00007', 'บวรนิเวศ', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00008', 'ตลาดยอด', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00009', 'ชนะสงคราม', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00010', 'บ้านพานถม', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00011', 'บางขุนพรหม', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00012', 'วัดสามพระยา', '0001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00013', 'ดุสิต', '0002', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00014', 'วชิรพยาบาล', '0002', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00015', 'สวนจิตรลดา', '0002', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00016', 'สี่แยกมหานาค', '0002', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00017', 'บางซื่อ', '0002', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00018', 'ถนนนครไชยศรี', '0002', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00019', 'สามเสนใน', '0002', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00020', 'กระทุ่มราย', '0003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00021', 'หนองจอก', '0003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00022', 'คลองสิบ', '0003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00023', 'คลองสิบสอง', '0003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00024', 'โคกแฝด', '0003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00025', 'คู้ฝั่งเหนือ', '0003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00026', 'ลำผักชี', '0003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00027', 'ลำต้อยติ่ง', '0003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00028', 'มหาพฤฒาราม', '0004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00029', 'สีลม', '0004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00030', 'สุริยวงศ์', '0004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00031', 'บางรัก', '0004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00032', 'สี่พระยา', '0004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00033', 'ลาดยาว', '0005', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00034', 'อนุสาวรีย์', '0005', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00035', 'คลองถนน', '0005', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00036', 'ตลาดบางเขน', '0005', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00037', 'สีกัน', '0005', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00038', 'สายไหม', '0005', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00039', 'ทุ่งสองห้อง', '0005', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00040', 'ท่าแร้ง', '0005', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00041', 'ออเงิน', '0005', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00042', 'บางเขน', '0005', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00043', 'คลองจั่น', '0006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00044', 'วังทองหลาง', '0006', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00045', 'ลาดพร้าว', '0006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00046', 'คลองกุ่ม', '0006', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00047', 'สะพานสูง', '0006', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00048', 'คันนายาว', '0006', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00049', 'จรเข้บัว', '0006', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00050', 'หัวหมาก', '0006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00051', 'รองเมือง', '0007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00052', 'วังใหม่', '0007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00053', 'ปทุมวัน', '0007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00054', 'ลุมพินี', '0007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00055', 'ป้อมปราบ', '0008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00056', 'วัดเทพศิรินทร์', '0008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00057', 'คลองมหานาค', '0008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00058', 'บ้านบาตร', '0008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00059', 'วัดโสมนัส', '0008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00060', 'นางเลิ้ง', '0008', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00061', 'คลองเตย', '0009', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00062', 'คลองตัน', '0009', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00063', 'พระโขนง', '0009', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00064', 'บางนา', '0009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00065', 'บางจาก', '0009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00066', 'สวนหลวง', '0009', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00067', 'หนองบอน', '0009', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00068', 'ประเวศ', '0009', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00069', 'ดอกไม้', '0009', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00070', 'พระโขนง', '0009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00071', 'คลองตัน', '0009', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00072', 'คลองเตย', '0009', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00073', 'มีนบุรี', '0010', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00074', 'แสนแสบ', '0010', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00075', 'บางชัน', '0010', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00076', 'ทรายกองดิน', '0010', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00077', 'ทรายกองดินใต้', '0010', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00078', 'สามวาตะวันออก', '0010', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00079', 'สามวาตะวันตก', '0010', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00080', 'ลาดกระบัง', '0011', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00081', 'คลองสองต้นนุ่น', '0011', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00082', 'คลองสามประเวศ', '0011', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00083', 'ลำปลาทิว', '0011', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00084', 'ทับยาว', '0011', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00085', 'ขุมทอง', '0011', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00086', 'ทุ่งวัดดอน', '0012', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00087', 'ยานนาวา', '0012', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00088', 'ช่องนนทรี', '0012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00089', 'บางโพงพาง', '0012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00090', 'วัดพระยาไกร', '0012', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00091', 'บางโคล่', '0012', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00092', 'บางคอแหลม', '0012', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00093', 'ทุ่งมหาเมฆ', '0012', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00094', 'บางโคล่', '0012', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00095', 'บางคอแหลม', '0012', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00096', 'จักรวรรดิ', '0013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00097', 'สัมพันธวงศ์', '0013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00098', 'ตลาดน้อย', '0013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00099', 'สามเสนใน', '0014', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00100', 'ถนนเพชรบุรี', '0014', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00101', 'ทุ่งพญาไท', '0014', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00102', 'มักกะสัน', '0014', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00103', 'ถนนพญาไท', '0014', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00104', 'ทุ่งพญาไท', '0014', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00105', 'วัดกัลยาณ์', '0015', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00106', 'หิรัญรูจี', '0015', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00107', 'บางยี่เรือ', '0015', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00108', 'บุคคโล', '0015', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00109', 'ตลาดพลู', '0015', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00110', 'ดาวคะนอง', '0015', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00111', 'สำเหร่', '0015', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00112', 'คลองสาน', '0015', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00113', 'วัดอรุณ', '0016', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00114', 'วัดท่าพระ', '0016', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00115', 'ห้วยขวาง', '0017', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00116', 'บางกะปิ', '0017', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00117', 'ดินแดง', '0017', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00118', 'สามเสนนอก', '0017', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00119', 'สมเด็จเจ้าพระยา', '0018', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00120', 'คลองสาน', '0018', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00121', 'บางลำภูล่าง', '0018', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00122', 'คลองต้นไทร', '0018', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00123', 'คลองชักพระ', '0019', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00124', 'ตลิ่งชัน', '0019', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00125', 'ฉิมพลี', '0019', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00126', 'บางพรม', '0019', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00127', 'บางระมาด', '0019', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00128', 'ทวีวัฒนา', '0019', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00129', 'บางเชือกหนัง', '0019', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00130', 'ศาลาธรรมสพน์', '0019', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00131', 'บางพลัด', '0020', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00132', 'บางบำหรุ', '0020', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00133', 'บางอ้อ', '0020', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00134', 'ศิริราช', '0020', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00135', 'บ้านช่างหล่อ', '0020', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00136', 'บางขุนนนท์', '0020', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00137', 'บางขุนศรี', '0020', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00138', 'บางยี่ขัน', '0020', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00139', 'อรุณอมรินทร์', '0020', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00140', 'บางยี่ขัน', '0020', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00141', 'บางบำหรุ', '0020', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00142', 'บางอ้อ', '0020', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00143', 'บางค้อ', '0021', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00144', 'จอมทอง', '0021', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00145', 'บางขุนเทียน', '0021', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00146', 'บางบอน', '0021', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00147', 'ท่าข้าม', '0021', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00148', 'บางมด', '0021', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00149', 'แสมดำ', '0021', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00150', 'บางหว้า', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00151', 'บางด้วน', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00152', 'บางแค', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00153', 'บางแคเหนือ', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00154', 'บางไผ่', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00155', 'บางจาก', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00156', 'บางแวก', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00157', 'คลองขวาง', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00158', 'ปากคลองภาษีเจริญ', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00159', 'คูหาสวรรค์', '0022', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00160', 'หลักสอง', '0023', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00161', 'หนองแขม', '0023', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00162', 'หนองค้างพลู', '0023', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00163', 'ราษฎร์บูรณะ', '0024', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00164', 'บางปะกอก', '0024', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00165', 'บางมด', '0024', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00166', 'ทุ่งครุ', '0024', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00167', 'บางพลัด', '0025', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00168', 'บางอ้อ', '0025', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00169', 'บางบำหรุ', '0025', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00170', 'บางยี่ขัน', '0025', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00171', 'ดินแดง', '0026', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00172', 'คลองกุ่ม', '0027', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00173', 'สะพานสูง', '0027', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00174', 'คันนายาว', '0027', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00175', 'ทุ่งวัดดอน', '0028', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00176', 'ยานนาวา', '0028', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00177', 'ทุ่งมหาเมฆ', '0028', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00178', 'บางซื่อ', '0029', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00179', 'ลาดยาว', '0030', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00180', 'เสนานิคม', '0030', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00181', 'จันทรเกษม', '0030', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00182', 'จอมพล', '0030', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00183', 'จตุจักร', '0030', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00184', 'บางคอแหลม', '0031', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00185', 'วัดพระยาไกร', '0031', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00186', 'บางโคล่', '0031', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00187', 'ประเวศ', '0032', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00188', 'หนองบอน', '0032', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00189', 'ดอกไม้', '0032', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00190', 'สวนหลวง', '0032', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00191', 'คลองเตย', '0033', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00192', 'คลองตัน', '0033', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00193', 'พระโขนง', '0033', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00194', 'คลองเตยเหนือ', '0033', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00195', 'คลองตันเหนือ', '0033', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00196', 'พระโขนงเหนือ', '0033', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00197', 'สวนหลวง', '0034', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00198', 'บางขุนเทียน', '0035', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00199', 'บางค้อ', '0035', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00200', 'บางมด', '0035', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00201', 'จอมทอง', '0035', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00202', 'ตลาดบางเขน', '0036', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00203', 'สีกัน', '0036', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00204', 'ทุ่งสองห้อง', '0036', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00205', 'ทุ่งพญาไท', '0037', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00206', 'ถนนพญาไท', '0037', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00207', 'ถนนเพชรบุรี', '0037', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00208', 'มักกะสัน', '0037', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00209', 'ลาดพร้าว', '0038', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00210', 'จรเข้บัว', '0038', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00211', 'คลองเตยเหนือ', '0039', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00212', 'คลองตันเหนือ', '0039', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00213', 'พระโขนงเหนือ', '0039', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00214', 'บางแค', '0040', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00215', 'บางแคเหนือ', '0040', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00216', 'บางไผ่', '0040', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00217', 'หลักสอง', '0040', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00218', 'ทุ่งสองห้อง', '0041', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00219', 'ตลาดบางเขน', '0041', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00220', 'สายไหม', '0042', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00221', 'ออเงิน', '0042', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00222', 'คลองถนน', '0042', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00223', 'คันนายาว', '0043', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00224', 'สะพานสูง', '0044', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00225', 'วังทองหลาง', '0045', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00226', 'สามวาตะวันตก', '0046', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00227', 'สามวาตะวันออก', '0046', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00228', 'บางชัน', '0046', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00229', 'ทรายกองดิน', '0046', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00230', 'ทรายกองดินใต้', '0046', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00231', 'บางนา', '0047', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00232', 'ทวีวัฒนา', '0048', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00233', 'ศาลาธรรมสพน์', '0048', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00234', 'บางมด', '0049', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00235', 'ทุ่งครุ', '0049', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00236', 'บางบอน', '0050', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00237', 'ปากน้ำ', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00238', 'สำโรงเหนือ', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00239', 'บางเมือง', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00240', 'ท้ายบ้าน', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00241', 'นาเกลือ', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00242', 'แหลมฟ้าผ่า', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00243', 'ในคลองบางปลากด', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00244', 'บางปูใหม่', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00245', 'ปากคลองบางปลากด', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00246', 'แพรกษา', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00247', 'บางโปรง', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00248', 'บางปู', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00249', 'บางด้วน', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00250', 'บางเมืองใหม่', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00251', 'เทพารักษ์', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00252', 'ท้ายบ้านใหม่', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00253', 'แพรกษาใหม่', '0052', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00254', 'บางปูเก่า', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00255', 'ในคลองบางปลากด', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00256', 'ปากคลองบางปลากด', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00257', 'แหลมฟ้าผ่า', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00258', 'บ้านคลองสวน', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00259', 'นาเกลือ', '0052', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00260', 'บางบ่อ', '0053', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00261', 'บ้านระกาศ', '0053', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00262', 'บางพลีน้อย', '0053', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00263', 'บางเพรียง', '0053', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00264', 'คลองด่าน', '0053', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00265', 'คลองสวน', '0053', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00266', 'เปร็ง', '0053', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00267', 'คลองนิยมยาตรา', '0053', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00268', 'คลองนิยม', '0053', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00269', 'บางพลีใหญ่', '0054', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00270', 'บางแก้ว', '0054', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00271', 'บางปลา', '0054', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00272', 'บางโฉลง', '0054', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00273', 'บางเสาธง', '0054', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00274', 'ศรีษะจรเข้ใหญ่', '0054', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00275', 'ศรีษะจรเข้น้อย', '0054', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00276', 'ราชาเทวะ', '0054', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00277', 'หนองปรือ', '0054', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00278', 'ตลาด', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00279', 'บางพึ่ง', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00280', 'บางจาก', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00281', 'บางครุ', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00282', 'บางหญ้าแพรก', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00283', 'บางหัวเสือ', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00284', 'สำโรงใต้', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00285', 'บางยอ', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00286', 'บางกะเจ้า', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00287', 'บางน้ำผึ้ง', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00288', 'บางกระสอบ', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00289', 'บางกอบัว', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00290', 'ทรงคนอง', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00291', 'สำโรง', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00292', 'สำโรงกลาง', '0055', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00293', 'นาเกลือ', '0056', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00294', 'บ้านคลองสวน', '0056', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00295', 'แหลมฟ้าผ่า', '0056', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00296', 'ปากคลองบางปลากด', '0056', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00297', 'ในคลองบางปลากด', '0056', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00298', 'บางเสาธง', '0057', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00299', 'ศีรษะจรเข้น้อย', '0057', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00300', 'ศีรษะจรเข้ใหญ่', '0057', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00301', 'สวนใหญ่', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00302', 'ตลาดขวัญ', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00303', 'บางเขน', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00304', 'บางกระสอ', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00305', 'ท่าทราย', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00306', 'บางไผ่', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00307', 'บางศรีเมือง', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00308', 'บางกร่าง', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00309', 'ไทรม้า', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00310', 'บางรักน้อย', '0058', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00311', 'วัดชลอ', '0059', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00312', 'บางกรวย', '0059', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00313', 'บางสีทอง', '0059', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00314', 'บางขนุน', '0059', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00315', 'บางขุนกอง', '0059', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00316', 'บางคูเวียง', '0059', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00317', 'มหาสวัสดิ์', '0059', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00318', 'ปลายบาง', '0059', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00319', 'ศาลากลาง', '0059', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00320', 'บางม่วง', '0060', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00321', 'บางแม่นาง', '0060', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00322', 'บางเลน', '0060', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00323', 'เสาธงหิน', '0060', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00324', 'บางใหญ่', '0060', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00325', 'บ้านใหม่', '0060', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00326', 'โสนลอย', '0061', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00327', 'บางบัวทอง', '0061', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00328', 'บางรักใหญ่', '0061', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00329', 'บางคูรัด', '0061', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00330', 'ละหาร', '0061', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00331', 'ลำโพ', '0061', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00332', 'พิมลราช', '0061', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00333', 'บางรักพัฒนา', '0061', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00334', 'ไทรน้อย', '0062', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00335', 'ราษฎร์นิยม', '0062', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00336', 'หนองเพรางาย', '0062', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00337', 'ไทรใหญ่', '0062', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00338', 'ขุนศรี', '0062', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00339', 'คลองขวาง', '0062', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00340', 'ทวีวัฒนา', '0062', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00341', 'ปากเกร็ด', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00342', 'บางตลาด', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00343', 'บ้านใหม่', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00344', 'บางพูด', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00345', 'บางตะไนย์', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00346', 'คลองพระอุดม', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00347', 'ท่าอิฐ', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00348', 'เกาะเกร็ด', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00349', 'อ้อมเกร็ด', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00350', 'คลองข่อย', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00351', 'บางพลับ', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00352', 'คลองเกลือ', '0063', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00353', 'บางปรอก', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00354', 'บ้านใหม่', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00355', 'บ้านกลาง', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00356', 'บ้านฉาง', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00357', 'บ้านกระแชง', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00358', 'บางขะแยง', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00359', 'บางคูวัด', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00360', 'บางหลวง', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00361', 'บางเดื่อ', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00362', 'บางพูด', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00363', 'บางพูน', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00364', 'บางกะดี', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00365', 'สวนพริกไทย', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00366', 'หลักหก', '0066', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00367', 'คลองหนึ่ง', '0067', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00368', 'คลองสอง', '0067', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00369', 'คลองสาม', '0067', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00370', 'คลองสี่', '0067', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00371', 'คลองห้า', '0067', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00372', 'คลองหก', '0067', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00373', 'คลองเจ็ด', '0067', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00374', 'ประชาธิปัตย์', '0068', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00375', 'บึงยี่โถ', '0068', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00376', 'รังสิต', '0068', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00377', 'ลำผักกูด', '0068', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00378', 'บึงสนั่น', '0068', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00379', 'บึงน้ำรักษ์', '0068', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00380', 'บึงบา', '0069', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00381', 'บึงบอน', '0069', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00382', 'บึงกาสาม', '0069', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00383', 'บึงชำอ้อ', '0069', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00384', 'หนองสามวัง', '0069', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00385', 'ศาลาครุ', '0069', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00386', 'นพรัตน์', '0069', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00387', 'ระแหง', '0070', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00388', 'ลาดหลุมแก้ว', '0070', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00389', 'คูบางหลวง', '0070', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00390', 'คูขวาง', '0070', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00391', 'คลองพระอุดม', '0070', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00392', 'บ่อเงิน', '0070', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00393', 'หน้าไม้', '0070', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00394', 'คูคต', '0071', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00395', 'ลาดสวาย', '0071', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00396', 'บึงคำพร้อย', '0071', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00397', 'ลำลูกกา', '0071', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00398', 'บึงทองหลาง', '0071', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00399', 'ลำไทร', '0071', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00400', 'บึงคอไห', '0071', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00401', 'พืชอุดม', '0071', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00402', 'บางเตย', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00403', 'คลองควาย', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00404', 'สามโคก', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00405', 'กระแชง', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00406', 'บางโพธิ์เหนือ', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00407', 'เชียงรากใหญ่', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00408', 'บ้านปทุม', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00409', 'บ้านงิ้ว', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00410', 'เชียงรากน้อย', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00411', 'บางกระบือ', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00412', 'ท้ายเกาะ', '0072', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00413', 'ประตูชัย', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00414', 'กะมัง', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00415', 'หอรัตนไชย', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00416', 'หัวรอ', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00417', 'ท่าวาสุกรี', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00418', 'ไผ่ลิง', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00419', 'ปากกราน', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00420', 'ภูเขาทอง', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00421', 'สำเภาล่ม', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00422', 'สวนพริก', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00423', 'คลองตะเคียน', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00424', 'วัดตูม', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00425', 'หันตรา', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00426', 'ลุมพลี', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00427', 'บ้านใหม่', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00428', 'บ้านเกาะ', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00429', 'คลองสวนพลู', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00430', 'คลองสระบัว', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00431', 'เกาะเรียน', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00432', 'บ้านป้อม', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00433', 'บ้านรุน', '0074', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00434', 'จำปา', '0074', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00435', 'ท่าเรือ', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00436', 'จำปา', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00437', 'ท่าหลวง', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00438', 'บ้านร่อม', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00439', 'ศาลาลอย', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00440', 'วังแดง', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00441', 'โพธิ์เอน', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00442', 'ปากท่า', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00443', 'หนองขนาก', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00444', 'ท่าเจ้าสนุก', '0075', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00445', 'นครหลวง', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00446', 'ท่าช้าง', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00447', 'บ่อโพง', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00448', 'บ้านชุ้ง', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00449', 'ปากจั่น', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00450', 'บางระกำ', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00451', 'บางพระครู', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00452', 'แม่ลา', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00453', 'หนองปลิง', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00454', 'คลองสะแก', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00455', 'สามไถ', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00456', 'พระนอน', '0076', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00457', 'บางไทร', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00458', 'บางพลี', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00459', 'สนามชัย', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00460', 'บ้านแป้ง', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00461', 'หน้าไม้', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00462', 'บางยี่โท', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00463', 'แคออก', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00464', 'แคตก', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00465', 'ช่างเหล็ก', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00466', 'กระแชง', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00467', 'บ้านกลึง', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00468', 'ช้างน้อย', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00469', 'ห่อหมก', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00470', 'ไผ่พระ', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00471', 'กกแก้วบูรพา', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00472', 'ไม้ตรา', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00473', 'บ้านม้า', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00474', 'บ้านเกาะ', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00475', 'ราชคราม', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00476', 'ช้างใหญ่', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00477', 'โพแตง', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00478', 'เชียงรากน้อย', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00479', 'โคกช้าง', '0077', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00480', 'บางบาล', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00481', 'วัดยม', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00482', 'ไทรน้อย', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00483', 'สะพานไทย', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00484', 'มหาพราหมณ์', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00485', 'กบเจา', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00486', 'บ้านคลัง', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00487', 'พระขาว', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00488', 'น้ำเต้า', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00489', 'ทางช้าง', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00490', 'วัดตะกู', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00491', 'บางหลวง', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00492', 'บางหลวงโดด', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00493', 'บางหัก', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00494', 'บางชะนี', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00495', 'บ้านกุ่ม', '0078', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00496', 'บ้านเลน', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00497', 'เชียงรากน้อย', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00498', 'บ้านโพ', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00499', 'บ้านกรด', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00500', 'บางกระสั้น', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00501', 'คลองจิก', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00502', 'บ้านหว้า', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00503', 'วัดยม', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00504', 'บางประแดง', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00505', 'สามเรือน', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00506', 'เกาะเกิด', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00507', 'บ้านพลับ', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00508', 'บ้านแป้ง', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00509', 'คุ้งลาน', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00510', 'ตลิ่งชัน', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00511', 'บ้านสร้าง', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00512', 'ตลาดเกรียบ', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00513', 'ขนอนหลวง', '0079', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00514', 'บางปะหัน', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00515', 'ขยาย', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00516', 'บางเดื่อ', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00517', 'เสาธง', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00518', 'ทางกลาง', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00519', 'บางเพลิง', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00520', 'หันสัง', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00521', 'บางนางร้า', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00522', 'ตานิม', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00523', 'ทับน้ำ', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00524', 'บ้านม้า', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00525', 'ขวัญเมือง', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00526', 'บ้านลี่', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00527', 'โพธิ์สามต้น', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00528', 'พุทเลา', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00529', 'ตาลเอน', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00530', 'บ้านขล้อ', '0080', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00531', 'ผักไห่', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00532', 'อมฤต', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00533', 'บ้านแค', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00534', 'ลาดน้ำเค็ม', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00535', 'ตาลาน', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00536', 'ท่าดินแดง', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00537', 'ดอนลาน', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00538', 'นาคู', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00539', 'กุฎี', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00540', 'ลำตะเคียน', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00541', 'โคกช้าง', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00542', 'จักราช', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00543', 'หนองน้ำใหญ่', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00544', 'ลาดชิด', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00545', 'หน้าโคก', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00546', 'บ้านใหญ่', '0081', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00547', 'ภาชี', '0082', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00548', 'โคกม่วง', '0082', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00549', 'ระโสม', '0082', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00550', 'หนองน้ำใส', '0082', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00551', 'ดอนหญ้านาง', '0082', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00552', 'ไผ่ล้อม', '0082', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00553', 'กระจิว', '0082', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00554', 'พระแก้ว', '0082', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00555', 'ลาดบัวหลวง', '0083', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00556', 'หลักชัย', '0083', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00557', 'สามเมือง', '0083', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00558', 'พระยาบันลือ', '0083', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00559', 'สิงหนาท', '0083', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00560', 'คู้สลอด', '0083', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00561', 'คลองพระยาบันลือ', '0083', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00562', 'ลำตาเสา', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00563', 'บ่อตาโล่', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00564', 'วังน้อย', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00565', 'ลำไทร', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00566', 'สนับทึบ', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00567', 'พยอม', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00568', 'หันตะเภา', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00569', 'วังจุฬา', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00570', 'ข้าวงาม', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00571', 'ชะแมบ', '0084', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00572', 'เสนา', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00573', 'บ้านแพน', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00574', 'เจ้าเจ็ด', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00575', 'สามกอ', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00576', 'บางนมโค', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00577', 'หัวเวียง', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00578', 'มารวิชัย', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00579', 'บ้านโพธิ์', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00580', 'รางจรเข้', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00581', 'บ้านกระทุ่ม', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00582', 'บ้านแถว', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00583', 'ชายนา', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00584', 'สามตุ่ม', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00585', 'ลาดงา', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00586', 'ดอนทอง', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00587', 'บ้านหลวง', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00588', 'เจ้าเสด็จ', '0085', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00589', 'บางซ้าย', '0086', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00590', 'แก้วฟ้า', '0086', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00591', 'เต่าเล่า', '0086', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00592', 'ปลายกลัด', '0086', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00593', 'เทพมงคล', '0086', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00594', 'วังพัฒนา', '0086', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00595', 'คานหาม', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00596', 'บ้านช้าง', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00597', 'สามบัณฑิต', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00598', 'บ้านหีบ', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00599', 'หนองไม้ซุง', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00600', 'อุทัย', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00601', 'เสนา', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00602', 'หนองน้ำส้ม', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00603', 'โพสาวหาญ', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00604', 'ธนู', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00605', 'ข้าวเม่า', '0087', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00606', 'หัวไผ่', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00607', 'กะทุ่ม', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00608', 'มหาราช', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00609', 'น้ำเต้า', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00610', 'บางนา', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00611', 'โรงช้าง', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00612', 'เจ้าปลุก', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00613', 'พิตเพียน', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00614', 'บ้านนา', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00615', 'บ้านขวาง', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00616', 'ท่าตอ', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00617', 'บ้านใหม่', '0088', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00618', 'บ้านแพรก', '0089', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00619', 'บ้านใหม่', '0089', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00620', 'สำพะเนียง', '0089', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00621', 'คลองน้อย', '0089', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00622', 'สองห้อง', '0089', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00623', 'ตลาดหลวง', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00624', 'บางแก้ว', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00625', 'ศาลาแดง', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00626', 'ป่างิ้ว', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00627', 'บ้านแห', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00628', 'ตลาดกรวด', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00629', 'มหาดไทย', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00630', 'บ้านอิฐ', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00631', 'หัวไผ่', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00632', 'จำปาหล่อ', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00633', 'โพสะ', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00634', 'บ้านรี', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00635', 'คลองวัว', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00636', 'ย่านซื่อ', '0090', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00637', 'จรเข้ร้อง', '0091', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00638', 'ไชยภูมิ', '0091', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00639', 'ชัยฤทธิ์', '0091', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00640', 'เทวราช', '0091', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00641', 'ราชสถิตย์', '0091', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00642', 'ไชโย', '0091', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00643', 'หลักฟ้า', '0091', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00644', 'ชะไว', '0091', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00645', 'ตรีณรงค์', '0091', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00646', 'บางปลากด', '0092', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00647', 'ป่าโมก', '0092', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00648', 'สายทอง', '0092', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00649', 'โรงช้าง', '0092', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00650', 'บางเสด็จ', '0092', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00651', 'นรสิงห์', '0092', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00652', 'เอกราช', '0092', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00653', 'โผงเผง', '0092', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00654', 'อ่างแก้ว', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00655', 'อินทประมูล', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00656', 'บางพลับ', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00657', 'หนองแม่ไก่', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00658', 'รำมะสัก', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00659', 'บางระกำ', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00660', 'โพธิ์รังนก', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00661', 'องครักษ์', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00662', 'โคกพุทรา', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00663', 'ยางช้าย', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00664', 'บ่อแร่', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00665', 'ทางพระ', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00666', 'สามง่าม', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00667', 'บางเจ้าฉ่า', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00668', 'คำหยาด', '0093', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00669', 'แสวงหา', '0094', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00670', 'ศรีพราน', '0094', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00671', 'บ้านพราน', '0094', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00672', 'วังน้ำเย็น', '0094', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00673', 'สีบัวทอง', '0094', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00674', 'ห้วยไผ่', '0094', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00675', 'จำลอง', '0094', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00676', 'ไผ่จำศิล', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00677', 'ศาลเจ้าโรงทอง', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00678', 'ไผ่ดำพัฒนา', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00679', 'สาวร้องไห้', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00680', 'ท่าช้าง', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00681', 'ยี่ล้น', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00682', 'บางจัก', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00683', 'ห้วยคันแหลน', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00684', 'คลองขนาก', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00685', 'ไผ่วง', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00686', 'สี่ร้อย', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00687', 'ม่วงเตี้ย', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00688', 'หัวตะพาน', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00689', 'หลักแก้ว', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00690', 'ตลาดใหม่', '0095', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00691', 'สามโก้', '0096', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00692', 'ราษฎรพัฒนา', '0096', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00693', 'อบทม', '0096', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00694', 'โพธิ์ม่วงพันธ์', '0096', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00695', 'มงคลธรรมนิมิต', '0096', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00696', 'ทะเลชุบศร', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00697', 'ท่าหิน', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00698', 'กกโก', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00699', 'โก่งธนู', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00700', 'เขาพระงาม', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00701', 'เขาสามยอด', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00702', 'โคกกะเทียม', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00703', 'โคกลำพาน', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00704', 'โคกตูม', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00705', 'งิ้วราย', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00706', 'ดอนโพธิ์', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00707', 'ตะลุง', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00708', 'ทะเลชุบศร', '0097', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00709', 'ท่าแค', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00710', 'ท่าศาลา', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00711', 'นิคมสร้างตนเอง', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00712', 'บางขันหมาก', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00713', 'บ้านข่อย', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00714', 'ท้ายตลาด', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00715', 'ป่าตาล', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00716', 'พรหมมาสตร์', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00717', 'โพธิ์เก้าต้น', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00718', 'โพธิ์ตรุ', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00719', 'สี่คลอง', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00720', 'ถนนใหญ่', '0097', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00721', 'พัฒนานิคม', '0098', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00722', 'ช่องสาริกา', '0098', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00723', 'มะนาวหวาน', '0098', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00724', 'ดีลัง', '0098', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00725', 'โคกสลุง', '0098', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00726', 'ชอนน้อย', '0098', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00727', 'หนองบัว', '0098', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00728', 'ห้วยขุนราม', '0098', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00729', 'น้ำสุด', '0098', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00730', 'โคกสำโรง', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00731', 'เกาะแก้ว', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00732', 'ถลุงเหล็ก', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00733', 'หลุมข้าว', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00734', 'ห้วยโป่ง', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00735', 'คลองเกตุ', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00736', 'สะแกราบ', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00737', 'เพนียด', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00738', 'วังเพลิง', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00739', 'ดงมะรุม', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00740', 'ชอนสารเดช', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00741', 'หนองม่วง', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00742', 'บ่อทอง', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00743', 'ยางโทน', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00744', 'ชอนสมบูรณ์', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00745', 'โคกเจริญ', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00746', 'ยางราก', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00747', 'วังขอนขว้าง', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00748', 'ดงดินแดง', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00749', 'วังจั่น', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00750', 'หนองมะค่า', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00751', 'หนองแขม', '0099', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00752', 'วังทอง', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00753', 'ชอนสารเดช', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00754', 'ยางโทน', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00755', 'ชอนสมบูรณ์', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00756', 'ดงดินแดง', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00757', 'บ่อทอง', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00758', 'หนองม่วง', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00759', 'ยางราก', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00760', 'โคกเจริญ', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00761', 'ทุ่งท่าช้าง', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00762', 'มหาโพธิ์', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00763', 'สระโบสถ์', '0099', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00764', 'ลำนารายณ์', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00765', 'ชัยนารายณ์', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00766', 'ศิลาทิพย์', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00767', 'ห้วยหิน', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00768', 'ม่วงค่อม', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00769', 'บัวชุม', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00770', 'ท่าดินดำ', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00771', 'มะกอกหวาน', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00772', 'ซับตะเคียน', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00773', 'นาโสม', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00774', 'หนองยายโต๊ะ', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00775', 'เกาะรัง', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00776', 'หนองรี', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00777', 'ท่ามะนาว', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00778', 'กุดตาเพชร', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00779', 'ลำสนธิ', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00780', 'นิคมลำนารายณ์', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00781', 'ชัยบาดาล', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00782', 'บ้านใหม่สามัคคี', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00783', 'ซับสมบูรณ์', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00784', 'เขารวก', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00785', 'เขาแหลม', '0100', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00786', 'เขาฉกรรจ์', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00787', 'กุดตาเพชร', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00788', 'หนองรี', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00789', 'ลำสนธิ', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00790', 'หนองผักแว่น', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00791', 'ซับจำปา', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00792', 'แก่งผักกูด', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00793', 'ท่าหลวง', '0100', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00794', 'ท่าวุ้ง', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00795', 'บางคู้', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00796', 'โพตลาดแก้ว', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00797', 'บางลี่', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00798', 'บางงา', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00799', 'โคกสลุด', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00800', 'เขาสมอคอน', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00801', 'หัวสำโรง', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00802', 'ลาดสาลี่', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00803', 'บ้านเบิก', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00804', 'มุจลินท์', '0101', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00805', 'ไผ่ใหญ่', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00806', 'บ้านทราย', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00807', 'บ้านกล้วย', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00808', 'ดงพลับ', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00809', 'บ้านชี', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00810', 'พุคา', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00811', 'หินปัก', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00812', 'บางพึ่ง', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00813', 'หนองทรายขาว', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00814', 'บางกะพี้', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00815', 'หนองเต่า', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00816', 'โพนทอง', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00817', 'บางขาม', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00818', 'ดอนดึง', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00819', 'ชอนม่วง', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00820', 'หนองกระเบียน', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00821', 'สายห้วยแก้ว', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00822', 'มหาสอน', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00823', 'บ้านหมี่', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00824', 'เชียงงา', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00825', 'หนองเมือง', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00826', 'สนามแจง', '0102', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00827', 'ท่าหลวง', '0103', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00828', 'แก่งผักกูด', '0103', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00829', 'ซับจำปา', '0103', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00830', 'หนองผักแว่น', '0103', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00831', 'ทะเลวังวัด', '0103', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00832', 'หัวลำ', '0103', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00833', 'สระโบสถ์', '0104', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00834', 'มหาโพธิ', '0104', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00835', 'ทุ่งท่าช้าง', '0104', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00836', 'ห้วยใหญ่', '0104', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00837', 'นิยมชัย', '0104', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00838', 'โคกเจริญ', '0105', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00839', 'ยางราก', '0105', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00840', 'หนองมะค่า', '0105', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00841', 'วังทอง', '0105', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00842', 'โคกแสมสาร', '0105', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00843', 'ลำสนธิ', '0106', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00844', 'ซับสมบูรณ์', '0106', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00845', 'หนองรี', '0106', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00846', 'กุดตาเพชร', '0106', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00847', 'เขารวก', '0106', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00848', 'เขาน้อย', '0106', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00849', 'หนองม่วง', '0107', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00850', 'บ่อทอง', '0107', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00851', 'ดงดินแดง', '0107', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00852', 'ชอนสมบูรณ์', '0107', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00853', 'ยางโทน', '0107', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00854', 'ชอนสารเดช', '0107', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00855', 'บางพุทรา', '0109', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00856', 'บางมัญ', '0109', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00857', 'โพกรวม', '0109', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00858', 'ม่วงหมู่', '0109', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00859', 'หัวไผ่', '0109', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00860', 'ต้นโพธิ์', '0109', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00861', 'จักรสีห์', '0109', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00862', 'บางกระบือ', '0109', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00863', 'สิงห์', '0110', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00864', 'ไม้ดัด', '0110', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00865', 'เชิงกลัด', '0110', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00866', 'โพชนไก่', '0110', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00867', 'แม่ลา', '0110', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00868', 'บ้านจ่า', '0110', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00869', 'พักทัน', '0110', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00870', 'สระแจง', '0110', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00871', 'โพทะเล', '0111', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00872', 'บางระจัน', '0111', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00873', 'โพสังโฆ', '0111', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00874', 'ท่าข้าม', '0111', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00875', 'คอทราย', '0111', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00876', 'หนองกระทุ่ม', '0111', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00877', 'พระงาม', '0112', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00878', 'พรหมบุรี', '0112', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00879', 'บางน้ำเชี่ยว', '0112', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00880', 'บ้านหม้อ', '0112', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00881', 'บ้านแป้ง', '0112', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00882', 'หัวป่า', '0112', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00883', 'โรงช้าง', '0112', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00884', 'ถอนสมอ', '0113', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00885', 'โพประจักษ์', '0113', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00886', 'วิหารขาว', '0113', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00887', 'พิกุลทอง', '0113', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00888', 'อินทร์บุรี', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00889', 'ประศุก', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00890', 'ทับยา', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00891', 'งิ้วราย', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00892', 'ชีน้ำร้าย', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00893', 'ท่างาม', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00894', 'น้ำตาล', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00895', 'ทองเอน', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00896', 'ห้วยชัน', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00897', 'โพธิ์ชัย', '0114', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00898', 'ในเมือง', '0115', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00899', 'บ้านกล้วย', '0115', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00900', 'ท่าชัย', '0115', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00901', 'ชัยนาท', '0115', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00902', 'เขาท่าพระ', '0115', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00903', 'หาดท่าเสา', '0115', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00904', 'ธรรมามูล', '0115', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00905', 'เสือโฮก', '0115', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00906', 'นางลือ', '0115', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00907', 'คุ้งสำเภา', '0116', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00908', 'วัดโคก', '0116', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00909', 'ศิลาดาน', '0116', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00910', 'ท่าฉนวน', '0116', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00911', 'หางน้ำสาคร', '0116', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00912', 'ไร่พัฒนา', '0116', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00913', 'อู่ตะเภา', '0116', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00914', 'วัดสิงห์', '0117', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00915', 'มะขามเฒ่า', '0117', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00916', 'หนองน้อย', '0117', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00917', 'หนองบัว', '0117', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00918', 'หนองมะโมง', '0117', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00919', 'หนองขุ่น', '0117', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00920', 'บ่อแร่', '0117', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00921', 'กุดจอก', '0117', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00922', 'วังตะเคียน', '0117', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00923', 'สะพานหิน', '0117', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00924', 'วังหมัน', '0117', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00925', 'สรรพยา', '0118', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00926', 'ตลุก', '0118', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00927', 'เขาแก้ว', '0118', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00928', 'โพนางดำตก', '0118', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00929', 'โพนางดำออก', '0118', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00930', 'บางหลวง', '0118', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00931', 'หาดอาษา', '0118', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00932', 'แพรกศรีราชา', '0119', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00933', 'เที่ยงแท้', '0119', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00934', 'ห้วยกรด', '0119', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00935', 'โพงาม', '0119', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00936', 'บางขุด', '0119', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00937', 'ดงคอน', '0119', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00938', 'ดอนกำ', '0119', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00939', 'ห้วยกรดพัฒนา', '0119', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00940', 'หันคา', '0120', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00941', 'บ้านเชี่ยน', '0120', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00942', 'เนินขาม', '0120', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00943', 'สุขเดือนห้า', '0120', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00944', 'ไพรนกยูง', '0120', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00945', 'หนองแซง', '0120', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00946', 'ห้วยงู', '0120', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00947', 'วังไก่เถื่อน', '0120', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00948', 'เด่นใหญ่', '0120', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00949', 'กะบกเตี้ย', '0120', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00950', 'สามง่ามท่าโบสถ์', '0120', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00951', 'หนองมะโมง', '0121', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00952', 'วังตะเคียน', '0121', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00953', 'สะพานหิน', '0121', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00954', 'กุดจอก', '0121', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00955', 'เนินขาม', '0122', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00956', 'กะบกเตี้ย', '0122', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00957', 'สุขเดือนห้า', '0122', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00958', 'ปากเพรียว', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00959', 'หน้าพระลาน', '0123', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00960', 'พุแค', '0123', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00961', 'ห้วยบง', '0123', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00962', 'ดาวเรือง', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00963', 'นาโฉง', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00964', 'โคกสว่าง', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00965', 'หนองโน', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00966', 'หนองยาว', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00967', 'ปากข้าวสาร', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00968', 'หนองปลาไหล', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00969', 'กุดนกเปล้า', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00970', 'ตลิ่งชัน', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00971', 'ตะกุด', '0123', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00972', 'บ้านแก้ง', '0123', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00973', 'ผึ้งรวง', '0123', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00974', 'เขาดินพัฒนา', '0123', -1 )
INSERT INTO tbm_sub_district
VALUES
( '00975', 'แก่งคอย', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00976', 'ทับกวาง', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00977', 'ตาลเดี่ยว', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00978', 'ห้วยแห้ง', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00979', 'ท่าคล้อ', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00980', 'หินซ้อน', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00981', 'บ้านธาตุ', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00982', 'บ้านป่า', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00983', 'ท่าตูม', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00984', 'ชะอม', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00985', 'สองคอน', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00986', 'เตาปูน', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00987', 'ชำผักแพว', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00988', 'ท่ามะปราง', '0124', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00989', 'หนองแค', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00990', 'กุ่มหัก', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00991', 'คชสิทธิ์', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00992', 'โคกตูม', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00993', 'โคกแย้', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00994', 'บัวลอย', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00995', 'ไผ่ต่ำ', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00996', 'โพนทอง', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00997', 'ห้วยขมิ้น', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00998', 'ห้วยทราย', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '00999', 'หนองไข่น้ำ', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01000', 'หนองแขม', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01001', 'หนองจิก', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01002', 'หนองจรเข้', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01003', 'หนองนาก', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01004', 'หนองปลาหมอ', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01005', 'หนองปลิง', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01006', 'หนองโรง', '0125', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01007', 'หนองหมู', '0126', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01008', 'บ้านลำ', '0126', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01009', 'คลองเรือ', '0126', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01010', 'วิหารแดง', '0126', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01011', 'หนองสรวง', '0126', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01012', 'เจริญธรรม', '0126', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01013', 'หนองแซง', '0127', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01014', 'หนองควายโซ', '0127', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01015', 'หนองหัวโพ', '0127', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01016', 'หนองสีดา', '0127', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01017', 'หนองกบ', '0127', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01018', 'ไก่เส่า', '0127', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01019', 'โคกสะอาด', '0127', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01020', 'ม่วงหวาน', '0127', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01021', 'เขาดิน', '0127', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01022', 'บ้านหมอ', '0128', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01023', 'บางโขมด', '0128', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01024', 'สร่างโศก', '0128', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01025', 'ตลาดน้อย', '0128', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01026', 'หรเทพ', '0128', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01027', 'โคกใหญ่', '0128', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01028', 'ไผ่ขวาง', '0128', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01029', 'บ้านครัว', '0128', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01030', 'หนองบัว', '0128', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01031', 'ดงตะงาว', '0128', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01032', 'บ้านหลวง', '0128', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01033', 'ไผ่หลิ่ว', '0128', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01034', 'ดอนพุด', '0128', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01035', 'ดอนพุด', '0129', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01036', 'ไผ่หลิ่ว', '0129', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01037', 'บ้านหลวง', '0129', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01038', 'ดงตะงาว', '0129', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01039', 'หนองโดน', '0130', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01040', 'บ้านกลับ', '0130', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01041', 'ดอนทอง', '0130', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01042', 'บ้านโปร่ง', '0130', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01043', 'พระพุทธบาท', '0131', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01044', 'ขุนโขลน', '0131', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01045', 'ธารเกษม', '0131', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01046', 'นายาว', '0131', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01047', 'พุคำจาน', '0131', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01048', 'เขาวง', '0131', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01049', 'ห้วยป่าหวาย', '0131', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01050', 'พุกร่าง', '0131', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01051', 'หนองแก', '0131', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01052', 'เสาไห้', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01053', 'บ้านยาง', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01054', 'หัวปลวก', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01055', 'งิ้วงาม', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01056', 'ศาลารีไทย', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01057', 'ต้นตาล', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01058', 'ท่าช้าง', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01059', 'พระยาทด', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01060', 'ม่วงงาม', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01061', 'เริงราง', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01062', 'เมืองเก่า', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01063', 'สวนดอกไม้', '0132', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01064', 'มวกเหล็ก', '0133', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01065', 'มิตรภาพ', '0133', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01066', 'แสลงพัน', '0133', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01067', 'หนองย่างเสือ', '0133', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01068', 'ลำสมพุง', '0133', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01069', 'คำพราน', '0133', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01070', 'ลำพญากลาง', '0133', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01071', 'วังม่วง', '0133', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01072', 'ซับสนุ่น', '0133', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01073', 'แสลงพัน', '0134', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01074', 'คำพราน', '0134', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01075', 'วังม่วง', '0134', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01076', 'เขาดินพัฒนา', '0135', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01077', 'บ้านแก้ง', '0135', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01078', 'ผึ้งรวง', '0135', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01079', 'พุแค', '0135', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01080', 'ห้วยบง', '0135', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01081', 'หน้าพระลาน', '0135', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01082', 'บางปลาสร้อย', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01083', 'มะขามหย่ง', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01084', 'บ้านโขด', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01085', 'แสนสุข', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01086', 'บ้านสวน', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01087', 'หนองรี', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01088', 'นาป่า', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01089', 'หนองข้างคอก', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01090', 'ดอนหัวฬ่อ', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01091', 'หนองไม้แดง', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01092', 'บางทราย', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01093', 'คลองตำหรุ', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01094', 'เหมือง', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01095', 'บ้านปึก', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01096', 'ห้วยกะปิ', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01097', 'เสม็ด', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01098', 'อ่างศิลา', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01099', 'สำนักบก', '0136', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01100', 'เทศบาลเมืองชลบุรี', '0136', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01101', 'บ้านบึง', '0137', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01102', 'คลองกิ่ว', '0137', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01103', 'มาบไผ่', '0137', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01104', 'หนองซ้ำซาก', '0137', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01105', 'หนองบอนแดง', '0137', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01106', 'หนองชาก', '0137', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01107', 'หนองอิรุณ', '0137', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01108', 'หนองไผ่แก้ว', '0137', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01109', 'หนองเสือช้าง', '0137', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01110', 'คลองพลู', '0137', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01111', 'หนองใหญ่', '0137', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01112', 'หนองใหญ่', '0138', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01113', 'คลองพลู', '0138', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01114', 'หนองเสือช้าง', '0138', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01115', 'ห้างสูง', '0138', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01116', 'เขาซก', '0138', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01117', 'บางละมุง', '0139', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01118', 'หนองปรือ', '0139', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01119', 'หนองปลาไหล', '0139', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01120', 'โป่ง', '0139', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01121', 'เขาไม้แก้ว', '0139', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01122', 'ห้วยใหญ่', '0139', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01123', 'ตะเคียนเตี้ย', '0139', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01124', 'นาเกลือ', '0139', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01125', 'พานทอง', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01126', 'หนองตำลึง', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01127', 'มาบโป่ง', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01128', 'หนองกะขะ', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01129', 'หนองหงษ์', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01130', 'โคกขี้หนอน', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01131', 'บ้านเก่า', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01132', 'หน้าประดู่', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01133', 'บางนาง', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01134', 'เกาะลอย', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01135', 'บางหัก', '0140', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01136', 'พนัสนิคม', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01137', 'หน้าพระธาตุ', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01138', 'วัดหลวง', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01139', 'บ้านเซิด', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01140', 'นาเริก', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01141', 'หมอนนาง', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01142', 'สระสี่เหลี่ยม', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01143', 'วัดโบสถ์', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01144', 'กุฎโง้ง', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01145', 'หัวถนน', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01146', 'ท่าข้าม', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01147', 'ท่าบุญมี', '0141', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01148', 'หนองปรือ', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01149', 'หนองขยาด', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01150', 'ทุ่งขวาง', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01151', 'หนองเหียง', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01152', 'นาวังหิน', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01153', 'บ้านช้าง', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01154', 'เกาะจันทร์', '0141', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01155', 'โคกเพลาะ', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01156', 'ไร่หลักทอง', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01157', 'นามะตูม', '0141', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01158', 'บ้านเซิด', '0141', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01159', 'พูนพัฒนาทรัพย์', '0141', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01160', 'บ่อกวางทอง', '0141', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01161', 'วัดสุวรรณ', '0141', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01162', 'บ่อทอง', '0141', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01163', 'ศรีราชา', '0142', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01164', 'สุรศักดิ์', '0142', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01165', 'ทุ่งสุขลา', '0142', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01166', 'บึง', '0142', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01167', 'หนองขาม', '0142', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01168', 'เขาคันทรง', '0142', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01169', 'บางพระ', '0142', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01170', 'บ่อวิน', '0142', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01171', 'ท่าเทววงษ์', '0142', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01172', 'ท่าเทววงษ์', '0143', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01173', 'สัตหีบ', '0144', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01174', 'นาจอมเทียน', '0144', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01175', 'พลูตาหลวง', '0144', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01176', 'บางเสร่', '0144', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01177', 'แสมสาร', '0144', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01178', 'บ่อทอง', '0145', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01179', 'วัดสุวรรณ', '0145', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01180', 'บ่อกวางทอง', '0145', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01181', 'ธาตุทอง', '0145', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01182', 'เกษตรสุวรรณ', '0145', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01183', 'พลวงทอง', '0145', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01184', 'เกาะจันทร์', '0146', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01185', 'ท่าบุญมี', '0146', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01186', 'หนองปรือ', '0148', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01187', 'ท่าประดู่', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01188', 'เชิงเนิน', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01189', 'ตะพง', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01190', 'ปากน้ำ', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01191', 'เพ', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01192', 'แกลง', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01193', 'บ้านแลง', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01194', 'นาตาขวัญ', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01195', 'เนินพระ', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01196', 'กะเฉด', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01197', 'ทับมา', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01198', 'น้ำคอก', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01199', 'ห้วยโป่ง', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01200', 'มาบตาพุด', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01201', 'สำนักทอง', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01202', 'สำนักท้อน', '0151', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01203', 'พลา', '0151', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01204', 'สำนักท้อน', '0152', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01205', 'พลา', '0152', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01206', 'บ้านฉาง', '0152', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01207', 'ทางเกวียน', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01208', 'วังหว้า', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01209', 'ชากโดน', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01210', 'เนินฆ้อ', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01211', 'กร่ำ', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01212', 'ชากพง', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01213', 'กระแสบน', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01214', 'บ้านนา', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01215', 'ทุ่งควายกิน', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01216', 'กองดิน', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01217', 'คลองปูน', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01218', 'พังราด', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01219', 'ปากน้ำกระแส', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01220', 'น้ำเป็น', '0153', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01221', 'ชำฆ้อ', '0153', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01222', 'ห้วยทับมอญ', '0153', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01223', 'ห้วยยาง', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01224', 'สองสลึง', '0153', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01225', 'เขาน้อย', '0153', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01226', 'ชุมแสง', '0153', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01227', 'วังจันทร์', '0153', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01228', 'วังจันทร์', '0154', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01229', 'ชุมแสง', '0154', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01230', 'ป่ายุบใน', '0154', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01231', 'พลงตาเอี่ยม', '0154', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01232', 'บ้านค่าย', '0155', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01233', 'หนองละลอก', '0155', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01234', 'หนองตะพาน', '0155', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01235', 'ตาขัน', '0155', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01236', 'บางบุตร', '0155', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01237', 'หนองบัว', '0155', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01238', 'ชากบก', '0155', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01239', 'มาบข่า', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01240', 'พนานิคม', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01241', 'นิคมพัฒนา', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01242', 'มะขามคู่', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01243', 'หนองไร่', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01244', 'มาบยางพร', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01245', 'แม่น้ำคู้', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01246', 'ละหาร', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01247', 'ตาสิทธิ์', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01248', 'ปลวกแดง', '0155', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01249', 'ปลวกแดง', '0156', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01250', 'ตาสิทธิ์', '0156', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01251', 'ละหาร', '0156', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01252', 'แม่น้ำคู้', '0156', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01253', 'มาบยางพร', '0156', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01254', 'หนองไร่', '0156', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01255', 'น้ำเป็น', '0157', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01256', 'ห้วยทับมอญ', '0157', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01257', 'ชำฆ้อ', '0157', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01258', 'เขาน้อย', '0157', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01259', 'นิคมพัฒนา', '0158', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01260', 'มาบข่า', '0158', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01261', 'พนานิคม', '0158', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01262', 'มะขามคู่', '0158', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01263', 'ตลาด', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01264', 'วัดใหม่', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01265', 'คลองนารายณ์', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01266', 'เกาะขวาง', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01267', 'คมบาง', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01268', 'ท่าช้าง', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01269', 'จันทนิมิต', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01270', 'บางกะจะ', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01271', 'แสลง', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01272', 'หนองบัว', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01273', 'พลับพลา', '0160', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01274', 'ขลุง', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01275', 'บ่อ', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01276', 'เกวียนหัก', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01277', 'ตะปอน', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01278', 'บางชัน', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01279', 'วันยาว', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01280', 'ซึ้ง', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01281', 'มาบไพ', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01282', 'วังสรรพรส', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01283', 'ตรอกนอง', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01284', 'ตกพรม', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01285', 'บ่อเวฬุ', '0161', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01286', 'ท่าใหม่', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01287', 'ยายร้า', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01288', 'สีพยา', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01289', 'บ่อพุ', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01290', 'พลอยแหวน', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01291', 'เขาวัว', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01292', 'เขาบายศรี', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01293', 'สองพี่น้อง', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01294', 'ทุ่งเบญจา', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01295', 'วังโตนด', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01296', 'รำพัน', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01297', 'โขมง', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01298', 'ตะกาดเง้า', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01299', 'คลองขุด', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01300', 'กระแจะ', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01301', 'สนามไชย', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01302', 'ช้างข้าม', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01303', 'นายายอาม', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01304', 'แก่งหางแมว', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01305', 'สามพี่น้อง', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01306', 'เขาวงกต', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01307', 'พวา', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01308', 'ขุนซ่อง', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01309', 'เขาแก้ว', '0162', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01310', 'กระแจะ', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01311', 'สนามไช', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01312', 'ช้างข้าม', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01313', 'วังโตนด', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01314', 'นายายอาม', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01315', 'แก่งหางแมว', '0162', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01316', 'ทับไทร', '0163', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01317', 'โป่งน้ำร้อน', '0163', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01318', 'ทรายขาว', '0163', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01319', 'หนองตาคง', '0163', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01320', 'ปะตง', '0163', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01321', 'ทุ่งขนาน', '0163', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01322', 'สะตอน', '0163', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01323', 'ทับช้าง', '0163', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01324', 'เทพนิมิต', '0163', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01325', 'คลองใหญ่', '0163', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01326', 'มะขาม', '0164', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01327', 'ท่าหลวง', '0164', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01328', 'ปัถวี', '0164', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01329', 'วังแซ้ม', '0164', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01330', 'พลวง', '0164', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01331', 'ฉมัน', '0164', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01332', 'ตะเคียนทอง', '0164', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01333', 'อ่างคีรี', '0164', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01334', 'คลองพลู', '0164', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01335', 'ซากไทย', '0164', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01336', 'ปากน้ำแหลมสิงห์', '0165', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01337', 'เกาะเปริด', '0165', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01338', 'หนองชิ่ม', '0165', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01339', 'พลิ้ว', '0165', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01340', 'คลองน้ำเค็ม', '0165', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01341', 'บางสระเก้า', '0165', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01342', 'บางกะไชย', '0165', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01343', 'ปะตง', '0166', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01344', 'ทุ่งขนาน', '0166', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01345', 'ทับช้าง', '0166', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01346', 'ทรายขาว', '0166', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01347', 'สะตอน', '0166', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01348', 'แก่งหางแมว', '0167', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01349', 'ขุนซ่อง', '0167', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01350', 'สามพี่น้อง', '0167', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01351', 'พวา', '0167', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01352', 'เขาวงกต', '0167', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01353', 'นายายอาม', '0168', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01354', 'วังโตนด', '0168', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01355', 'กระแจะ', '0168', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01356', 'สนามไชย', '0168', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01357', 'ช้างข้าม', '0168', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01358', 'วังใหม่', '0168', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01359', 'ชากไทย', '0169', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01360', 'พลวง', '0169', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01361', 'ตะเคียนทอง', '0169', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01362', 'คลองพลู', '0169', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01363', 'จันทเขลม', '0169', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01364', 'บางพระ', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01365', 'หนองเสม็ด', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01366', 'หนองโสน', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01367', 'หนองคันทรง', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01368', 'ห้วงน้ำขาว', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01369', 'อ่าวใหญ่', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01370', 'วังกระแจะ', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01371', 'ห้วยแร้ง', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01372', 'เนินทราย', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01373', 'ท่าพริก', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01374', 'ท่ากุ่ม', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01375', 'ตะกาง', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01376', 'ชำราก', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01377', 'แหลมกลัด', '0171', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01378', 'คลองใหญ่', '0172', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01379', 'ไม้รูด', '0172', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01380', 'หาดเล็ก', '0172', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01381', 'เขาสมิง', '0173', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01382', 'แสนตุ้ง', '0173', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01383', 'วังตะเคียน', '0173', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01384', 'ท่าโสม', '0173', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01385', 'สะตอ', '0173', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01386', 'ประณีต', '0173', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01387', 'เทพนิมิต', '0173', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01388', 'ทุ่งนนทรี', '0173', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01389', 'บ่อไร่', '0173', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01390', 'ด่านชุมพล', '0173', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01391', 'หนองบอน', '0173', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01392', 'ช้างทูน', '0173', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01393', 'บ่อพลอย', '0173', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01394', 'บ่อพลอย', '0174', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01395', 'ช้างทูน', '0174', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01396', 'ด่านชุมพล', '0174', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01397', 'หนองบอน', '0174', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01398', 'นนทรีย์', '0174', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01399', 'แหลมงอบ', '0175', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01400', 'น้ำเชี่ยว', '0175', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01401', 'บางปิด', '0175', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01402', 'เกาะช้าง', '0175', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01403', 'เกาะหมาก', '0175', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01404', 'เกาะกูด', '0175', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01405', 'คลองใหญ่', '0175', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01406', 'เกาะช้างใต้', '0175', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01407', 'เกาะหมาก', '0176', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01408', 'เกาะกูด', '0176', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01409', 'เกาะช้าง', '0177', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01410', 'เกาะช้างใต้', '0177', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01411', 'หน้าเมือง', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01412', 'ท่าไข่', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01413', 'บ้านใหม่', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01414', 'คลองนา', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01415', 'บางตีนเป็ด', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01416', 'บางไผ่', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01417', 'คลองจุกกระเฌอ', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01418', 'บางแก้ว', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01419', 'บางขวัญ', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01420', 'คลองนครเนื่องเขต', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01421', 'วังตะเคียน', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01422', 'โสธร', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01423', 'บางพระ', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01424', 'บางกะไห', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01425', 'หนามแดง', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01426', 'คลองเปรง', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01427', 'คลองอุดมชลจร', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01428', 'คลองหลวงแพ่ง', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01429', 'บางเตย', '0178', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01430', 'บางคล้า', '0179', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01431', 'ก้อนแก้ว', '0179', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01432', 'คลองเขื่อน', '0179', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01433', 'บางสวน', '0179', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01434', 'บางเล่า', '0179', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01435', 'บางโรง', '0179', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01436', 'บางตลาด', '0179', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01437', 'บางกระเจ็ด', '0179', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01438', 'ปากน้ำ', '0179', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01439', 'ท่าทองหลาง', '0179', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01440', 'สาวชะโงก', '0179', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01441', 'เสม็ดเหนือ', '0179', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01442', 'เสม็ดใต้', '0179', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01443', 'หัวไทร', '0179', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01444', 'บางน้ำเปรี้ยว', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01445', 'บางขนาก', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01446', 'สิงโตทอง', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01447', 'หมอนทอง', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01448', 'บึงน้ำรักษ์', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01449', 'ดอนเกาะกา', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01450', 'โยธะกา', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01451', 'ดอนฉิมพลี', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01452', 'ศาลาแดง', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01453', 'โพรงอากาศ', '0180', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01454', 'บางปะกง', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01455', 'ท่าสะอ้าน', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01456', 'บางวัว', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01457', 'บางสมัคร', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01458', 'บางผึ้ง', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01459', 'บางเกลือ', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01460', 'สองคลอง', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01461', 'หนองจอก', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01462', 'พิมพา', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01463', 'ท่าข้าม', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01464', 'หอมศีล', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01465', 'เขาดิน', '0181', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01466', 'บ้านโพธิ์', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01467', 'เกาะไร่', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01468', 'คลองขุด', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01469', 'คลองบ้านโพธิ์', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01470', 'คลองประเวศ', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01471', 'ดอนทราย', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01472', 'เทพราช', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01473', 'ท่าพลับ', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01474', 'หนองตีนนก', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01475', 'หนองบัว', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01476', 'บางซ่อน', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01477', 'บางกรูด', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01478', 'แหลมประดู่', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01479', 'ลาดขวาง', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01480', 'สนามจันทร์', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01481', 'แสนภูดาษ', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01482', 'สิบเอ็ดศอก', '0182', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01483', 'เกาะขนุน', '0183', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01484', 'บ้านซ่อง', '0183', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01485', 'พนมสารคาม', '0183', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01486', 'เมืองเก่า', '0183', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01487', 'หนองยาว', '0183', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01488', 'ท่าถ่าน', '0183', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01489', 'หนองแหน', '0183', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01490', 'เขาหินซ้อน', '0183', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01491', 'บางคา', '0184', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01492', 'เมืองใหม่', '0184', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01493', 'ดงน้อย', '0184', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01494', 'คู้ยายหมี', '0185', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01495', 'ท่ากระดาน', '0185', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01496', 'ทุ่งพระยา', '0185', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01497', 'ท่าตะเกียบ', '0185', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01498', 'ลาดกระทิง', '0185', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01499', 'คลองตะเกรา', '0185', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01500', 'แปลงยาว', '0186', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01501', 'วังเย็น', '0186', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01502', 'หัวสำโรง', '0186', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01503', 'หนองไม้แก่น', '0186', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01504', 'ท่าตะเกียบ', '0187', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01505', 'คลองตะเกรา', '0187', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01506', 'ก้อนแก้ว', '0188', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01507', 'คลองเขื่อน', '0188', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01508', 'บางเล่า', '0188', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01509', 'บางโรง', '0188', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01510', 'บางตลาด', '0188', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01511', 'หน้าเมือง', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01512', 'รอบเมือง', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01513', 'วัดโบสถ์', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01514', 'บางเดชะ', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01515', 'ท่างาม', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01516', 'บางบริบูรณ์', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01517', 'ดงพระราม', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01518', 'บ้านพระ', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01519', 'โคกไม้ลาย', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01520', 'ไม้เค็ด', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01521', 'ดงขี้เหล็ก', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01522', 'เนินหอม', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01523', 'โนนห้อม', '0189', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01524', 'กบินทร์', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01525', 'เมืองเก่า', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01526', 'วังดาล', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01527', 'นนทรี', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01528', 'ย่านรี', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01529', 'วังตะเคียน', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01530', 'หาดนางแก้ว', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01531', 'ลาดตะเคียน', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01532', 'บ้านนา', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01533', 'บ่อทอง', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01534', 'หนองกี่', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01535', 'นาแขม', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01536', 'เขาไม้แก้ว', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01537', 'วังท่าช้าง', '0190', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01538', 'สะพานหิน', '0190', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01539', 'นาดี', '0190', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01540', 'ลำพันตา', '0190', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01541', 'ทุ่งโพธิ์', '0190', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01542', 'นาดี', '0191', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01543', 'สำพันตา', '0191', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01544', 'สะพานหิน', '0191', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01545', 'ทุ่งโพธิ์', '0191', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01546', 'แก่งดินสอ', '0191', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01547', 'บุพราหมณ์', '0191', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01548', 'สระแก้ว', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01549', 'บ้านแก้ง', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01550', 'ศาลาลำดวน', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01551', 'โคกปี่ฆ้อง', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01552', 'ท่าแยก', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01553', 'ท่าเกษม', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01554', 'เขาฉกรรจ์', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01555', 'สระขวัญ', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01556', 'หนองหว้า', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01557', 'พระเพลิง', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01558', 'หนองบอน', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01559', 'เขาสามสิบ', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01560', 'ตาหลังใน', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01561', 'วังสมบูรณ์', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01562', 'วังน้ำเย็น', '0192', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01563', 'วังน้ำเย็น', '0193', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01564', 'วังสมบูรณ์', '0193', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01565', 'ตาหลังใน', '0193', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01566', 'วังใหม่', '0193', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01567', 'คลองหินปูน', '0193', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01568', 'ทุ่งมหาเจริญ', '0193', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01569', 'บ้านสร้าง', '0194', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01570', 'บางกระเบา', '0194', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01571', 'บางเตย', '0194', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01572', 'บางยาง', '0194', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01573', 'บางแตน', '0194', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01574', 'บางพลวง', '0194', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01575', 'บางปลาร้า', '0194', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01576', 'บางขาม', '0194', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01577', 'กระทุ่มแพ้ว', '0194', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01578', 'ประจันตคาม', '0195', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01579', 'เกาะลอย', '0195', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01580', 'บ้านหอย', '0195', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01581', 'หนองแสง', '0195', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01582', 'ดงบัง', '0195', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01583', 'คำโตนด', '0195', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01584', 'บุฝ้าย', '0195', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01585', 'หนองแก้ว', '0195', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01586', 'โพธิ์งาม', '0195', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01587', 'ศรีมหาโพธิ', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01588', 'สัมพันธ์', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01589', 'บ้านทาม', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01590', 'ท่าตูม', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01591', 'บางกุ้ง', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01592', 'ดงกระทงยาม', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01593', 'หนองโพรง', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01594', 'หัวหว้า', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01595', 'หาดยาง', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01596', 'กรอกสมบูรณ์', '0196', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01597', 'คู้ลำพัน', '0196', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01598', 'โคกปีบ', '0196', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01599', 'โคกไทย', '0196', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01600', 'ไผ่ชะเลือด', '0196', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01601', 'โคกปีบ', '0197', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01602', 'โคกไทย', '0197', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01603', 'คู้ลำพัน', '0197', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01604', 'ไผ่ชะเลือด', '0197', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01605', 'อรัญประเทศ', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01606', 'เมืองไผ่', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01607', 'หันทราย', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01608', 'คลองน้ำใส', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01609', 'ท่าข้าม', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01610', 'ป่าไร่', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01611', 'ทับพริก', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01612', 'บ้านใหม่หนองไทร', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01613', 'ผ่านศึก', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01614', 'หนองสังข์', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01615', 'คลองทับจันทร์', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01616', 'ฟากห้วย', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01617', 'บ้านด่าน', '0198', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01618', 'ตาพระยา', '0199', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01619', 'ทัพเสด็จ', '0199', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01620', 'โคกสูง', '0199', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01621', 'หนองแวง', '0199', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01622', 'หนองม่วง', '0199', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01623', 'ทัพราช', '0199', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01624', 'ทัพไทย', '0199', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01625', 'โนนหมากมุ่น', '0199', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01626', 'โคคลาน', '0199', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01627', 'วัฒนานคร', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01628', 'ท่าเกวียน', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01629', 'ซับมะกรูด', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01630', 'ผักขะ', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01631', 'โนนหมากเค็ง', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01632', 'หนองน้ำใส', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01633', 'ช่องกุ่ม', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01634', 'หนองแวง', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01635', 'ไทยอุดม', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01636', 'ไทรเดี่ยว', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01637', 'คลองหาด', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01638', 'แซร์ออ', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01639', 'หนองหมากฝ้าย', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01640', 'หนองตะเคียนบอน', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01641', 'ห้วยโจด', '0200', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01642', 'คลองหาด', '0201', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01643', 'ไทยอุดม', '0201', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01644', 'ซับมะกรูด', '0201', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01645', 'ไทรเดี่ยว', '0201', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01646', 'คลองไก่เถื่อน', '0201', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01647', 'เบญจขร', '0201', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01648', 'ไทรทอง', '0201', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01649', 'นครนายก', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01650', 'ท่าช้าง', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01651', 'บ้านใหญ่', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01652', 'วังกระโจม', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01653', 'ท่าทราย', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01654', 'ดอนยอ', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01655', 'ศรีจุฬา', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01656', 'ดงละคร', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01657', 'ศรีนาวา', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01658', 'สาริกา', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01659', 'หินตั้ง', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01660', 'เขาพระ', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01661', 'พรหมณี', '0202', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01662', 'เกาะหวาย', '0203', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01663', 'เกาะโพธิ์', '0203', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01664', 'ปากพลี', '0203', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01665', 'โคกกรวด', '0203', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01666', 'ท่าเรือ', '0203', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01667', 'หนองแสง', '0203', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01668', 'นาหินลาด', '0203', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01669', 'บ้านนา', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01670', 'บ้านพร้าว', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01671', 'บ้านพริก', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01672', 'อาษา', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01673', 'ทองหลาง', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01674', 'บางอ้อ', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01675', 'พิกุลออก', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01676', 'ป่าขะ', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01677', 'เขาเพิ่ม', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01678', 'ศรีกะอาง', '0204', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01679', 'พระอาจารย์', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01680', 'บึงศาล', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01681', 'ศีรษะกระบือ', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01682', 'โพธิ์แทน', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01683', 'บางสมบูรณ์', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01684', 'ทรายมูล', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01685', 'บางปลากด', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01686', 'บางลูกเสือ', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01687', 'องครักษ์', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01688', 'ชุมพล', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01689', 'คลองใหญ่', '0205', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01690', 'สระแก้ว', '0206', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01691', 'บ้านแก้ง', '0206', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01692', 'ศาลาลำดวน', '0206', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01693', 'โคกปี่ฆ้อง', '0206', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01694', 'ท่าแยก', '0206', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01695', 'ท่าเกษม', '0206', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01696', 'เขาฉกรรจ์', '0206', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01697', 'สระขวัญ', '0206', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01698', 'หนองหว้า', '0206', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01699', 'พระเพลิง', '0206', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01700', 'หนองบอน', '0206', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01701', 'เขาสามสิบ', '0206', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01702', 'คลองหาด', '0207', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01703', 'ไทยอุดม', '0207', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01704', 'ซับมะกรูด', '0207', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01705', 'ไทรเดี่ยว', '0207', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01706', 'คลองไก่เถื่อน', '0207', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01707', 'เบญจขร', '0207', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01708', 'ไทรทอง', '0207', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01709', 'ตาพระยา', '0208', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01710', 'ทัพเสด็จ', '0208', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01711', 'โคกสูง', '0208', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01712', 'หนองแวง', '0208', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01713', 'หนองม่วง', '0208', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01714', 'ทัพราช', '0208', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01715', 'ทัพไทย', '0208', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01716', 'โนนหมากมุ่น', '0208', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01717', 'โคคลาน', '0208', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01718', 'วังน้ำเย็น', '0209', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01719', 'วังสมบูรณ์', '0209', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01720', 'ตาหลังใน', '0209', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01721', 'วังใหม่', '0209', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01722', 'คลองหินปูน', '0209', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01723', 'ทุ่งมหาเจริญ', '0209', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01724', 'วังทอง', '0209', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01725', 'วัฒนานคร', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01726', 'ท่าเกวียน', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01727', 'ผักขะ', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01728', 'โนนหมากเค็ง', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01729', 'หนองน้ำใส', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01730', 'ช่องกุ่ม', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01731', 'หนองแวง', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01732', 'แซร์ออ', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01733', 'หนองหมากฝ้าย', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01734', 'หนองตะเคียนบอน', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01735', 'ห้วยโจด', '0210', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01736', 'อรัญประเทศ', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01737', 'เมืองไผ่', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01738', 'หันทราย', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01739', 'คลองน้ำใส', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01740', 'ท่าข้าม', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01741', 'ป่าไร่', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01742', 'ทับพริก', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01743', 'บ้านใหม่หนองไทร', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01744', 'ผ่านศึก', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01745', 'หนองสังข์', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01746', 'คลองทับจันทร์', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01747', 'ฟากห้วย', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01748', 'บ้านด่าน', '0211', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01749', 'เขาฉกรรจ์', '0212', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01750', 'หนองหว้า', '0212', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01751', 'พระเพลิง', '0212', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01752', 'เขาสามสิบ', '0212', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01753', 'โคกสูง', '0213', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01754', 'หนองม่วง', '0213', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01755', 'หนองแวง', '0213', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01756', 'โนนหมากมุ่น', '0213', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01757', 'วังสมบูรณ์', '0214', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01758', 'วังใหม่', '0214', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01759', 'วังทอง', '0214', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01760', 'ในเมือง', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01761', 'โพธิ์กลาง', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01762', 'หนองจะบก', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01763', 'โคกสูง', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01764', 'มะเริง', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01765', 'หนองระเวียง', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01766', 'ปรุใหญ่', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01767', 'หมื่นไวย', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01768', 'พลกรัง', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01769', 'หนองไผ่ล้อม', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01770', 'หัวทะเล', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01771', 'บ้านเกาะ', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01772', 'บ้านใหม่', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01773', 'พุดซา', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01774', 'บ้านโพธิ์', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01775', 'จอหอ', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01776', 'โคกกรวด', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01777', 'ไชยมงคล', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01778', 'หนองบัวศาลา', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01779', 'สุรนารี', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01780', 'สีมุม', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01781', 'ตลาด', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01782', 'พะเนา', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01783', 'หนองกระทุ่ม', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01784', 'หนองไข่น้ำ', '0215', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01785', 'แชะ', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01786', 'เฉลียง', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01787', 'ครบุรี', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01788', 'โคกกระชาย', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01789', 'จระเข้หิน', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01790', 'มาบตะโกเอน', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01791', 'อรพิมพ์', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01792', 'บ้านใหม่', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01793', 'ลำเพียก', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01794', 'ครบุรีใต้', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01795', 'ตะแบกบาน', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01796', 'สระว่านพระยา', '0216', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01797', 'เสิงสาง', '0217', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01798', 'สระตะเคียน', '0217', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01799', 'โนนสมบูรณ์', '0217', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01800', 'กุดโบสถ์', '0217', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01801', 'สุขไพบูลย์', '0217', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01802', 'บ้านราษฎร์', '0217', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01803', 'เมืองคง', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01804', 'คูขาด', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01805', 'เทพาลัย', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01806', 'ตาจั่น', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01807', 'บ้านปรางค์', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01808', 'หนองมะนาว', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01809', 'หนองบัว', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01810', 'โนนเต็ง', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01811', 'ดอนใหญ่', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01812', 'ขามสมบูรณ์', '0218', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01813', 'บ้านเหลื่อม', '0219', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01814', 'วังโพธิ์', '0219', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01815', 'โคกกระเบื้อง', '0219', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01816', 'ช่อระกา', '0219', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01817', 'จักราช', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01818', 'ท่าช้าง', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01819', 'ทองหลาง', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01820', 'สีสุก', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01821', 'หนองขาม', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01822', 'หนองงูเหลือม', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01823', 'หนองพลวง', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01824', 'หนองยาง', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01825', 'พระพุทธ', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01826', 'ศรีละกอ', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01827', 'คลองเมือง', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01828', 'ช้างทอง', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01829', 'หินโคน', '0220', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01830', 'กระโทก', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01831', 'พลับพลา', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01832', 'ท่าอ่าง', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01833', 'ทุ่งอรุณ', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01834', 'ท่าลาดขาว', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01835', 'ท่าจะหลุง', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01836', 'ท่าเยี่ยม', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01837', 'โชคชัย', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01838', 'ละลมใหม่พัฒนา', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01839', 'ด่านเกวียน', '0221', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01840', 'กุดพิมาน', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01841', 'ด่านขุนทด', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01842', 'ด่านนอก', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01843', 'ด่านใน', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01844', 'ตะเคียน', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01845', 'บ้านเก่า', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01846', 'บ้านแปรง', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01847', 'พันชนะ', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01848', 'สระจรเข้', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01849', 'หนองกราด', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01850', 'หนองบัวตะเกียด', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01851', 'หนองบัวละคร', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01852', 'หินดาด', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01853', 'สำนักตะคร้อ', '0222', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01854', 'ห้วยบง', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01855', 'หนองแวง', '0222', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01856', 'โนนเมืองพัฒนา', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01857', 'หนองไทร', '0222', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01858', 'บึงปรือ', '0222', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01859', 'โนนไทย', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01860', 'ด่านจาก', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01861', 'กำปัง', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01862', 'สำโรง', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01863', 'ค้างพลู', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01864', 'บ้านวัง', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01865', 'บัลลังก์', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01866', 'สายออ', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01867', 'ถนนโพธิ์', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01868', 'พังเทียม', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01869', 'สระพระ', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01870', 'ทัพรั้ง', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01871', 'หนองหอย', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01872', 'มะค่า', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01873', 'มาบกราด', '0223', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01874', 'โนนสูง', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01875', 'ใหม่', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01876', 'โตนด', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01877', 'บิง', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01878', 'ดอนชมพู', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01879', 'ธารปราสาท', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01880', 'หลุมข้าว', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01881', 'มะค่า', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01882', 'พลสงคราม', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01883', 'จันอัด', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01884', 'ขามเฒ่า', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01885', 'ด่านคล้า', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01886', 'ลำคอหงษ์', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01887', 'เมืองปราสาท', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01888', 'ดอนหวาย', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01889', 'ลำมูล', '0224', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01890', 'ขามสะแกแสง', '0225', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01891', 'โนนเมือง', '0225', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01892', 'เมืองนาท', '0225', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01893', 'ชีวึก', '0225', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01894', 'พะงาด', '0225', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01895', 'หนองหัวฟาน', '0225', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01896', 'เมืองเกษตร', '0225', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01897', 'บัวใหญ่', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01898', 'ห้วยยาง', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01899', 'เสมาใหญ่', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01900', 'บึงพะไล', '0226', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01901', 'ดอนตะหนิน', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01902', 'หนองบัวสะอาด', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01903', 'โนนทองหลาง', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01904', 'หนองหว้า', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01905', 'บัวลาย', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01906', 'สีดา', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01907', 'โพนทอง', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01908', 'แก้งสนามนาง', '0226', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01909', 'กุดจอก', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01910', 'ด่านช้าง', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01911', 'โนนจาน', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01912', 'สีสุก', '0226', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01913', 'สามเมือง', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01914', 'โนนสำราญ', '0226', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01915', 'ขุนทอง', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01916', 'หนองตาดใหญ่', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01917', 'เมืองพะไล', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01918', 'โนนประดู่', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01919', 'หนองแจ้งใหญ่', '0226', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01920', 'ประทาย', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01921', 'โนนแดง', '0227', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01922', 'กระทุ่มราย', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01923', 'วังไม้แดง', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01924', 'วังหิน', '0227', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01925', 'ตลาดไทร', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01926', 'หนองพลวง', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01927', 'หนองค่าย', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01928', 'หันห้วยทราย', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01929', 'ดอนมัน', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01930', 'โนนตาเถร', '0227', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01931', 'สำพะเนียง', '0227', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01932', 'นางรำ', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01933', 'โนนเพ็ด', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01934', 'ทุ่งสว่าง', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01935', 'ดอนยาวใหญ่', '0227', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01936', 'โคกกลาง', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01937', 'เมืองโดน', '0227', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01938', 'เมืองปัก', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01939', 'ตะคุ', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01940', 'โคกไทย', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01941', 'สำโรง', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01942', 'ตะขบ', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01943', 'นกออก', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01944', 'ดอน', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01945', 'วังน้ำเขียว', '0228', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01946', 'ตูม', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01947', 'งิ้ว', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01948', 'สะแกราช', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01949', 'ลำนางแก้ว', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01950', 'วังหมี', '0228', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01951', 'ระเริง', '0228', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01952', 'อุดมทรัพย์', '0228', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01953', 'ภูหลวง', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01954', 'ธงชัยเหนือ', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01955', 'สุขเกษม', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01956', 'เกษมทรัพย์', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01957', 'บ่อปลาทอง', '0228', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01958', 'ในเมือง', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01959', 'สัมฤทธิ์', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01960', 'โบสถ์', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01961', 'กระเบื้องใหญ่', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01962', 'ท่าหลวง', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01963', 'รังกาใหญ่', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01964', 'ชีวาน', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01965', 'นิคมสร้างตนเอง', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01966', 'กระชอน', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01967', 'ดงใหญ่', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01968', 'ธารละหลอด', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01969', 'หนองระเวียง', '0229', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01970', 'ห้วยแถลง', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01971', 'ทับสวาย', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01972', 'เมืองพลับพลา', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01973', 'หลุ่งตะเคียน', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01974', 'หินดาด', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01975', 'งิ้ว', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01976', 'กงรถ', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01977', 'หลุ่งประดู่', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01978', 'ตะโก', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01979', 'ห้วยแคน', '0230', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01980', 'ชุมพวง', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01981', 'ประสุข', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01982', 'ท่าลาด', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01983', 'สาหร่าย', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01984', 'ตลาดไทร', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01985', 'ช่องแมว', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01986', 'ขุย', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01987', 'กระเบื้องนอก', '0231', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01988', 'เมืองยาง', '0231', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01989', 'โนนรัง', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01990', 'บ้านยาง', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01991', 'ละหานปลาค้าว', '0231', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01992', 'โนนอุดม', '0231', -1 )
INSERT INTO tbm_sub_district
VALUES
( '01993', 'หนองหลัก', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01994', 'ไพล', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01995', 'โนนตูม', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01996', 'โนนยอ', '0231', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01997', 'สูงเนิน', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01998', 'เสมา', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '01999', 'โคราช', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02000', 'บุ่งขี้เหล็ก', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02001', 'โนนค่า', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02002', 'โค้งยาง', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02003', 'มะเกลือเก่า', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02004', 'มะเกลือใหม่', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02005', 'นากลาง', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02006', 'หนองตะไก้', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02007', 'กุดจิก', '0232', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02008', 'ขามทะเลสอ', '0233', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02009', 'โป่งแดง', '0233', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02010', 'พันดุง', '0233', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02011', 'หนองสรวง', '0233', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02012', 'บึงอ้อ', '0233', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02013', 'สีคิ้ว', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02014', 'บ้านหัน', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02015', 'กฤษณา', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02016', 'ลาดบัวขาว', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02017', 'หนองหญ้าขาว', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02018', 'กุดน้อย', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02019', 'หนองน้ำใส', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02020', 'วังโรงใหญ่', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02021', 'มิตรภาพ', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02022', 'คลองไผ่', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02023', 'ดอนเมือง', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02024', 'หนองบัวน้อย', '0234', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02025', 'ปากช่อง', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02026', 'กลางดง', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02027', 'จันทึก', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02028', 'วังกะทะ', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02029', 'หมูสี', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02030', 'หนองสาหร่าย', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02031', 'ขนงพระ', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02032', 'โป่งตาลอง', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02033', 'คลองม่วง', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02034', 'หนองน้ำแดง', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02035', 'วังไทร', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02036', 'พญาเย็น', '0235', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02037', 'หนองบุนนาก', '0236', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02038', 'สารภี', '0236', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02039', 'ไทยเจริญ', '0236', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02040', 'หนองหัวแรต', '0236', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02041', 'แหลมทอง', '0236', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02042', 'หนองตะไก้', '0236', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02043', 'ลุงเขว้า', '0236', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02044', 'หนองไม้ไผ่', '0236', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02045', 'บ้านใหม่', '0236', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02046', 'แก้งสนามนาง', '0237', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02047', 'โนนสำราญ', '0237', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02048', 'บึงพะไล', '0237', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02049', 'สีสุก', '0237', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02050', 'บึงสำโรง', '0237', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02051', 'โนนแดง', '0238', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02052', 'โนนตาเถร', '0238', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02053', 'สำพะเนียง', '0238', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02054', 'วังหิน', '0238', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02055', 'ดอนยาวใหญ่', '0238', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02056', 'วังน้ำเขียว', '0239', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02057', 'วังหมี', '0239', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02058', 'ระเริง', '0239', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02059', 'อุดมทรัพย์', '0239', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02060', 'ไทยสามัคคี', '0239', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02061', 'สำนักตะคร้อ', '0240', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02062', 'หนองแวง', '0240', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02063', 'บึงปรือ', '0240', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02064', 'วังยายทอง', '0240', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02065', 'เมืองยาง', '0241', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02066', 'กระเบื้องนอก', '0241', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02067', 'ละหานปลาค้าว', '0241', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02068', 'โนนอุดม', '0241', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02069', 'สระพระ', '0242', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02070', 'มาบกราด', '0242', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02071', 'พังเทียม', '0242', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02072', 'ทัพรั้ง', '0242', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02073', 'หนองหอย', '0242', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02074', 'ขุย', '0243', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02075', 'บ้านยาง', '0243', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02076', 'ช่องแมว', '0243', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02077', 'ไพล', '0243', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02078', 'เมืองพะไล', '0244', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02079', 'โนนจาน', '0244', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02080', 'บัวลาย', '0244', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02081', 'หนองหว้า', '0244', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02082', 'สีดา', '0245', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02083', 'โพนทอง', '0245', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02084', 'โนนประดู่', '0245', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02085', 'สามเมือง', '0245', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02086', 'หนองตาดใหญ่', '0245', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02087', 'ช้างทอง', '0246', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02088', 'ท่าช้าง', '0246', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02089', 'พระพุทธ', '0246', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02090', 'หนองงูเหลือม', '0246', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02091', 'หนองยาง', '0246', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02092', 'ในเมือง', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02093', 'อิสาณ', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02094', 'เสม็ด', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02095', 'บ้านบัว', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02096', 'สะแกโพรง', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02097', 'สวายจีก', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02098', 'ห้วยราช', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02099', 'บ้านยาง', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02100', 'บ้านด่าน', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02101', 'สามแวง', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02102', 'ปราสาท', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02103', 'พระครู', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02104', 'ถลุงเหล็ก', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02105', 'หนองตาด', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02106', 'โนนขวาง', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02107', 'ตาเสา', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02108', 'ลุมปุ๊ก', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02109', 'สองห้อง', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02110', 'บัวทอง', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02111', 'ชุมเห็ด', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02112', 'สนวน', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02113', 'หลักเขต', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02114', 'วังเหนือ', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02115', 'บ้านตะโก', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02116', 'สะแกซำ', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02117', 'กลันทา', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02118', 'กระสัง', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02119', 'เมืองฝาง', '0250', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02120', 'ปะเคียบ', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02121', 'ห้วยราช', '0250', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02122', 'คูเมือง', '0251', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02123', 'ปะเคียบ', '0251', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02124', 'บ้านแพ', '0251', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02125', 'พรสำราญ', '0251', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02126', 'หินเหล็กไฟ', '0251', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02127', 'ตูมใหญ่', '0251', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02128', 'หนองขมาร', '0251', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02129', 'กระสัง', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02130', 'ลำดวน', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02131', 'สองชั้น', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02132', 'สูงเนิน', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02133', 'หนองเต็ง', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02134', 'เมืองไผ่', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02135', 'ชุมแสง', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02136', 'บ้านปรือ', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02137', 'ห้วยสำราญ', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02138', 'กันทรารมย์', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02139', 'ศรีภูมิ', '0252', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02140', 'นางรอง', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02141', 'ตาเป๊ก', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02142', 'สะเดา', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02143', 'ชำนิ', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02144', 'ชุมแสง', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02145', 'หนองโบสถ์', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02146', 'หนองปล่อง', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02147', 'หนองกง', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02148', 'ทุ่งจังหัน', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02149', 'เมืองยาง', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02150', 'เจริญสุข', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02151', 'โนนสุวรรณ', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02152', 'ถนนหัก', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02153', 'หนองไทร', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02154', 'ก้านเหลือง', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02155', 'บ้านสิงห์', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02156', 'ลำไทรโยง', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02157', 'ทรัพย์พระยา', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02158', 'อีสานเขต', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02159', 'ดงอีจาน', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02160', 'โกรกแก้ว', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02161', 'ช่อผกา', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02162', 'ละลวด', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02163', 'หนองยายพิมพ์', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02164', 'หัวถนน', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02165', 'ทุ่งแสงทอง', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02166', 'หนองโสน', '0253', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02167', 'หนองปล่อง', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02168', 'ชำนิ', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02169', 'ดอนอะราง', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02170', 'เมืองไผ่', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02171', 'เย้ยปราสาท', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02172', 'หนองกี่', '0253', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02173', 'หนองกี่', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02174', 'เย้ยปราสาท', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02175', 'เมืองไผ่', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02176', 'ดอนอะราง', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02177', 'โคกสว่าง', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02178', 'ทุ่งกระตาดพัฒนา', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02179', 'ทุ่งกระเต็น', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02180', 'ท่าโพธิ์ชัย', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02181', 'โคกสูง', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02182', 'บุกระสัง', '0254', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02183', 'ละหานทราย', '0255', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02184', 'ถาวร', '0255', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02185', 'ตาจง', '0255', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02186', 'สำโรงใหม่', '0255', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02187', 'โนนดินแดง', '0255', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02188', 'ยายแย้มวัฒนา', '0255', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02189', 'หนองแวง', '0255', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02190', 'ลำนางรอง', '0255', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02191', 'ส้มป่อย', '0255', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02192', 'หนองตะครอง', '0255', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02193', 'โคกว่าน', '0255', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02194', 'ไทยเจริญ', '0255', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02195', 'ประโคนชัย', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02196', 'แสลงโทน', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02197', 'บ้านไทร', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02198', 'จันดุม', '0256', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02199', 'ละเวี้ย', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02200', 'จรเข้มาก', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02201', 'ปังกู', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02202', 'โคกย่าง', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02203', 'โคกขมิ้น', '0256', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02204', 'โคกม้า', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02205', 'ป่าชัน', '0256', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02206', 'สะเดา', '0256', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02207', 'ไพศาล', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02208', 'ตะโกตาพิ', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02209', 'เขาคอก', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02210', 'หนองบอน', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02211', 'สำโรง', '0256', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02212', 'โคกมะขาม', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02213', 'โคกตูม', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02214', 'ประทัดบุ', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02215', 'สี่เหลี่ยม', '0256', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02216', 'ป่าชัน', '0256', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02217', 'โคกขมิ้น', '0256', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02218', 'จันดุม', '0256', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02219', 'บ้านกรวด', '0257', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02220', 'โนนเจริญ', '0257', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02221', 'หนองไม้งาม', '0257', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02222', 'ปราสาท', '0257', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02223', 'สายตะกู', '0257', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02224', 'หินลาด', '0257', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02225', 'บึงเจริญ', '0257', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02226', 'จันทบเพชร', '0257', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02227', 'เขาดินเหนือ', '0257', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02228', 'พุทไธสง', '0258', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02229', 'มะเฟือง', '0258', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02230', 'บ้านจาน', '0258', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02231', 'หนองแวง', '0258', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02232', 'ทองหลาง', '0258', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02233', 'บ้านเป้า', '0258', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02234', 'บ้านแวง', '0258', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02235', 'บ้านแดงใหญ่', '0258', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02236', 'บ้านยาง', '0258', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02237', 'หายโศก', '0258', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02238', 'กู่สวนแตง', '0258', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02239', 'หนองเยือง', '0258', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02240', 'ลำปลายมาศ', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02241', 'หนองคู', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02242', 'แสลงพัน', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02243', 'ทะเมนชัย', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02244', 'ตลาดโพธิ์', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02245', 'หนองกะทิง', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02246', 'โคกกลาง', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02247', 'โคกสะอาด', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02248', 'เมืองแฝก', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02249', 'บ้านยาง', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02250', 'ผไทรินทร์', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02251', 'โคกล่าม', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02252', 'หินโคน', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02253', 'หนองบัวโคก', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02254', 'บุโพธิ์', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02255', 'หนองโดน', '0259', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02256', 'ไทยสามัคคี', '0259', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02257', 'ห้วยหิน', '0259', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02258', 'สระแก้ว', '0259', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02259', 'สตึก', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02260', 'นิคม', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02261', 'ทุ่งวัง', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02262', 'เมืองแก', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02263', 'หนองใหญ่', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02264', 'ร่อนทอง', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02265', 'แคนดง', '0260', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02266', 'ดงพลอง', '0260', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02267', 'ดอนมนต์', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02268', 'ชุมแสง', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02269', 'ท่าม่วง', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02270', 'สะแก', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02271', 'สระบัว', '0260', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02272', 'สนามชัย', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02273', 'กระสัง', '0260', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02274', 'หัวฝาย', '0260', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02275', 'ปะคำ', '0261', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02276', 'ไทยเจริญ', '0261', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02277', 'หนองบัว', '0261', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02278', 'โคกมะม่วง', '0261', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02279', 'หูทำนบ', '0261', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02280', 'นาโพธิ์', '0262', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02281', 'บ้านคู', '0262', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02282', 'บ้านดู่', '0262', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02283', 'ดอนกอก', '0262', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02284', 'ศรีสว่าง', '0262', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02285', 'สระแก้ว', '0263', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02286', 'ห้วยหิน', '0263', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02287', 'ไทยสามัคคี', '0263', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02288', 'หนองชัยศรี', '0263', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02289', 'เสาเดียว', '0263', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02290', 'เมืองฝ้าย', '0263', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02291', 'สระทอง', '0263', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02292', 'จันดุม', '0264', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02293', 'โคกขมิ้น', '0264', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02294', 'ป่าชัน', '0264', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02295', 'สะเดา', '0264', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02296', 'สำโรง', '0264', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02297', 'ห้วยราช', '0265', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02298', 'สามแวง', '0265', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02299', 'ตาเสา', '0265', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02300', 'บ้านตะโก', '0265', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02301', 'สนวน', '0265', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02302', 'โคกเหล็ก', '0265', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02303', 'เมืองโพธิ์', '0265', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02304', 'ห้วยราชา', '0265', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02305', 'โนนสุวรรณ', '0266', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02306', 'ทุ่งจังหัน', '0266', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02307', 'โกรกแก้ว', '0266', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02308', 'ดงอีจาน', '0266', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02309', 'ชำนิ', '0267', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02310', 'หนองปล่อง', '0267', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02311', 'เมืองยาง', '0267', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02312', 'ช่อผกา', '0267', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02313', 'ละลวด', '0267', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02314', 'โคกสนวน', '0267', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02315', 'หนองแวง', '0268', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02316', 'ทองหลาง', '0268', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02317', 'แดงใหญ่', '0268', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02318', 'กู่สวนแตง', '0268', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02319', 'หนองเยือง', '0268', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02320', 'โนนดินแดง', '0269', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02321', 'ส้มป่อย', '0269', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02322', 'ลำนางรอง', '0269', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02323', 'บ้านด่าน', '0270', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02324', 'ปราสาท', '0270', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02325', 'วังเหนือ', '0270', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02326', 'โนนขวาง', '0270', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02327', 'แคนดง', '0271', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02328', 'ดงพลอง', '0271', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02329', 'สระบัว', '0271', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02330', 'หัวฝาย', '0271', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02331', 'เจริญสุข', '0272', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02332', 'ตาเป๊ก', '0272', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02333', 'อีสานเขต', '0272', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02334', 'ถาวร', '0272', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02335', 'ยายแย้มวัฒนา', '0272', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02336', 'ในเมือง', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02337', 'ตั้งใจ', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02338', 'เพี้ยราม', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02339', 'นาดี', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02340', 'ท่าสว่าง', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02341', 'สลักได', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02342', 'ตาอ็อง', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02343', 'ตากูก', '0273', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02344', 'สำโรง', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02345', 'แกใหญ่', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02346', 'นอกเมือง', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02347', 'คอโค', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02348', 'สวาย', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02349', 'เฉนียง', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02350', 'บึง', '0273', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02351', 'เทนมีย์', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02352', 'เขวาสินรินทร์', '0273', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02353', 'นาบัว', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02354', 'เมืองที', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02355', 'ราม', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02356', 'บุฤาษี', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02357', 'ตระแสง', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02358', 'บ้านแร่', '0273', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02359', 'ปราสาททอง', '0273', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02360', 'แสลงพันธ์', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02361', 'กาเกาะ', '0273', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02362', 'ชุมพลบุรี', '0274', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02363', 'นาหนองไผ่', '0274', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02364', 'ไพรขลา', '0274', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02365', 'ศรีณรงค์', '0274', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02366', 'ยะวึก', '0274', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02367', 'เมืองบัว', '0274', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02368', 'สระขุด', '0274', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02369', 'กระเบื้อง', '0274', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02370', 'หนองเรือ', '0274', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02371', 'ท่าตูม', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02372', 'กระโพ', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02373', 'พรมเทพ', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02374', 'โพนครก', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02375', 'เมืองแก', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02376', 'บะ', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02377', 'หนองบัว', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02378', 'บัวโคก', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02379', 'หนองเมธี', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02380', 'ทุ่งกุลา', '0275', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02381', 'จอมพระ', '0276', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02382', 'เมืองลีง', '0276', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02383', 'กระหาด', '0276', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02384', 'บุแกรง', '0276', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02385', 'หนองสนิท', '0276', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02386', 'บ้านผือ', '0276', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02387', 'ลุ่มระวี', '0276', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02388', 'ชุมแสง', '0276', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02389', 'เป็นสุข', '0276', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02390', 'กังแอน', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02391', 'ทมอ', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02392', 'ไพล', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02393', 'ปรือ', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02394', 'ทุ่งมน', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02395', 'ตาเบา', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02396', 'หนองใหญ่', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02397', 'โคกยาง', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02398', 'โคกสะอาด', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02399', 'บ้านไทร', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02400', 'โชคนาสาม', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02401', 'เชื้อเพลิง', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02402', 'ปราสาททนง', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02403', 'ตานี', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02404', 'บ้านพลวง', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02405', 'กันตวจระมวล', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02406', 'สมุด', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02407', 'ประทัดบุ', '0277', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02408', 'ด่าน', '0277', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02409', 'คูตัน', '0277', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02410', 'โคกกลาง', '0277', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02411', 'บักได', '0277', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02412', 'กาบเชิง', '0277', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02413', 'กาบเชิง', '0278', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02414', 'บักได', '0278', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02415', 'โคกกลาง', '0278', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02416', 'คูตัน', '0278', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02417', 'ด่าน', '0278', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02418', 'แนงมุด', '0278', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02419', 'โคกตะเคียน', '0278', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02420', 'ตาเมียง', '0278', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02421', 'จีกแดก', '0278', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02422', 'ตะเคียน', '0278', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02423', 'รัตนบุรี', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02424', 'ธาตุ', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02425', 'แก', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02426', 'ดอนแรด', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02427', 'หนองบัวทอง', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02428', 'หนองบัวบาน', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02429', 'หนองหลวง', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02430', 'หนองเทพ', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02431', 'ไผ่', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02432', 'โนน', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02433', 'เบิด', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02434', 'ระเวียง', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02435', 'น้ำเขียว', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02436', 'กุดขาคีม', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02437', 'ยางสว่าง', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02438', 'ทับใหญ่', '0279', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02439', 'คำผง', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02440', 'สนม', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02441', 'หนองระฆัง', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02442', 'นานวน', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02443', 'โพนโก', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02444', 'แคน', '0279', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02445', 'สนม', '0280', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02446', 'โพนโก', '0280', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02447', 'หนองระฆัง', '0280', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02448', 'นานวน', '0280', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02449', 'แคน', '0280', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02450', 'หัวงัว', '0280', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02451', 'หนองอียอ', '0280', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02452', 'ระแงง', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02453', 'ตรึม', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02454', 'จารพัต', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02455', 'ยาง', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02456', 'แตล', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02457', 'หนองบัว', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02458', 'คาละแมะ', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02459', 'หนองเหล็ก', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02460', 'หนองขวาว', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02461', 'ช่างปี่', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02462', 'กุดหวาย', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02463', 'ขวาวใหญ่', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02464', 'นารุ่ง', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02465', 'ตรมไพร', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02466', 'ผักไหม', '0281', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02467', 'สังขะ', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02468', 'ขอนแตก', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02469', 'ณรงค์', '0282', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02470', 'แจนแวน', '0282', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02471', 'ตรวจ', '0282', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02472', 'ดม', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02473', 'พระแก้ว', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02474', 'บ้านจารย์', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02475', 'กระเทียม', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02476', 'สะกาด', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02477', 'ตาตุม', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02478', 'ทับทัน', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02479', 'ตาคง', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02480', 'ศรีสุข', '0282', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02481', 'บ้านชบ', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02482', 'หนองแวง', '0282', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02483', 'เทพรักษา', '0282', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02484', 'คูตัน', '0282', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02485', 'ด่าน', '0282', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02486', 'ลำดวน', '0283', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02487', 'โชคเหนือ', '0283', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02488', 'อู่โลก', '0283', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02489', 'ตรำดม', '0283', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02490', 'ตระเปียงเตีย', '0283', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02491', 'สำโรงทาบ', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02492', 'หนองไผ่ล้อม', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02493', 'กระออม', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02494', 'หนองฮะ', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02495', 'ศรีสุข', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02496', 'เกาะแก้ว', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02497', 'หมื่นศรี', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02498', 'เสม็จ', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02499', 'สะโน', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02500', 'ประดู่', '0284', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02501', 'บัวเชด', '0285', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02502', 'สะเดา', '0285', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02503', 'จรัส', '0285', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02504', 'ตาวัง', '0285', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02505', 'อาโพน', '0285', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02506', 'สำเภาลูน', '0285', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02507', 'บักได', '0286', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02508', 'โคกกลาง', '0286', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02509', 'จีกแดก', '0286', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02510', 'ตาเมียง', '0286', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02511', 'ณรงค์', '0287', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02512', 'แจนแวน', '0287', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02513', 'ตรวจ', '0287', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02514', 'หนองแวง', '0287', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02515', 'ศรีสุข', '0287', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02516', 'เขวาสินรินทร์', '0288', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02517', 'บึง', '0288', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02518', 'ตากูก', '0288', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02519', 'ปราสาททอง', '0288', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02520', 'บ้านแร่', '0288', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02521', 'หนองหลวง', '0289', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02522', 'คำผง', '0289', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02523', 'โนน', '0289', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02524', 'ระเวียง', '0289', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02525', 'หนองเทพ', '0289', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02526', 'เมืองเหนือ', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02527', 'เมืองใต้', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02528', 'คูซอด', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02529', 'ซำ', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02530', 'จาน', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02531', 'ตะดอบ', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02532', 'หนองครก', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02533', 'โนนเพ็ก', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02534', 'พรหมสวัสดิ์', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02535', 'พยุห์', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02536', 'โพนข่า', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02537', 'โพนค้อ', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02538', 'ธาตุ', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02539', 'ตำแย', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02540', 'โพนเขวา', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02541', 'หญ้าปล้อง', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02542', 'บุสูง', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02543', 'ทุ่ม', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02544', 'หนองไฮ', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02545', 'ดวนใหญ่', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02546', 'หนองแก้ว', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02547', 'น้ำคำ', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02548', 'โพธิ์', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02549', 'หมากเขียบ', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02550', 'บ่อแก้ว', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02551', 'ศรีสำราญ', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02552', 'หนองไผ่', '0290', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02553', 'หนองค้า', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02554', 'ดวนใหญ่', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02555', 'ธาตุ', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02556', 'บุสูง', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02557', 'คอนกาม', '0290', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02558', 'ยางชุมน้อย', '0291', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02559', 'ลิ้นฟ้า', '0291', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02560', 'คอนกาม', '0291', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02561', 'โนนคูณ', '0291', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02562', 'กุดเมืองฮาม', '0291', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02563', 'บึงบอน', '0291', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02564', 'ยางชุมใหญ่', '0291', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02565', 'ดูน', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02566', 'โนนสัง', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02567', 'หนองหัวช้าง', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02568', 'ยาง', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02569', 'หนองแวง', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02570', 'หนองแก้ว', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02571', 'ทาม', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02572', 'ละทาย', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02573', 'เมืองน้อย', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02574', 'อีปาด', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02575', 'บัวน้อย', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02576', 'หนองบัว', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02577', 'ดู่', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02578', 'ผักแพว', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02579', 'จาน', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02580', 'ตองบิด', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02581', 'ละเอาะ', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02582', 'น้ำเกลี้ยง', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02583', 'เขิน', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02584', 'คำเนียม', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02585', 'ตองปิด', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02586', 'ละเอาะ', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02587', 'หนองกุง', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02588', 'โพธิ์', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02589', 'บก', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02590', 'โนนค้อ', '0292', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02591', 'บึงมะลู', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02592', 'กุดเสลา', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02593', 'เมือง', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02594', 'หนองหว้า', '0293', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02595', 'สังเม็ก', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02596', 'น้ำอ้อม', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02597', 'ละลาย', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02598', 'รุง', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02599', 'ตระกาจ', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02600', 'เสียว', '0293', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02601', 'จานใหญ่', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02602', 'ภูเงิน', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02603', 'ชำ', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02604', 'กระแชง', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02605', 'โนนสำราญ', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02606', 'หนองหญ้าลาด', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02607', 'หนองงูเหลือม', '0293', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02608', 'ท่าคล้อ', '0293', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02609', 'เสาธงชัย', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02610', 'ขนุน', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02611', 'สวนกล้วย', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02612', 'หนองฮาง', '0293', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02613', 'เวียงเหนือ', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02614', 'ทุ่งใหญ่', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02615', 'ภูผาหมอก', '0293', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02616', 'สระเยาว์', '0293', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02617', 'พิงพวย', '0293', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02618', 'ศรีแก้ว', '0293', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02619', 'ตูม', '0293', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02620', 'กันทรารมย์', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02621', 'จะกง', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02622', 'ใจดี', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02623', 'ดองกำเม็ด', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02624', 'โสน', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02625', 'ปรือใหญ่', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02626', 'สะเดาใหญ่', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02627', 'ตาอุด', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02628', 'ห้วยเหนือ', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02629', 'ห้วยใต้', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02630', 'หัวเสือ', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02631', 'ละลม', '0294', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02632', 'ตะเคียน', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02633', 'โคกตาล', '0294', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02634', 'นิคมพัฒนา', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02635', 'ห้วยตามอญ', '0294', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02636', 'โคกเพชร', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02637', 'ปราสาท', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02638', 'ตะเคียนราม', '0294', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02639', 'ห้วยติ๊กชู', '0294', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02640', 'สำโรงตาเจ็น', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02641', 'ห้วยสำราญ', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02642', 'ดงรัก', '0294', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02643', 'กฤษณา', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02644', 'ลมศักดิ์', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02645', 'หนองฉลอง', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02646', 'ศรีตระกูล', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02647', 'ศรีสะอาด', '0294', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02648', 'ละลม', '0294', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02649', 'ไพรบึง', '0295', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02650', 'ดินแดง', '0295', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02651', 'ปราสาทเยอ', '0295', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02652', 'สำโรงพลัน', '0295', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02653', 'สุขสวัสดิ์', '0295', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02654', 'โนนปูน', '0295', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02655', 'พิมาย', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02656', 'กู่', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02657', 'หนองเชียงทูน', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02658', 'ตูม', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02659', 'สมอ', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02660', 'โพธิ์ศรี', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02661', 'สำโรงปราสาท', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02662', 'ดู่', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02663', 'สวาย', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02664', 'พิมายเหนือ', '0296', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02665', 'สิ', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02666', 'บักดอง', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02667', 'พราน', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02668', 'โพธิ์วงศ์', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02669', 'ไพร', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02670', 'กระหวัน', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02671', 'ขุนหาญ', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02672', 'โนนสูง', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02673', 'กันทรอม', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02674', 'ภูฝ้าย', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02675', 'โพธิ์กระสังข์', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02676', 'ห้วยจันทร์', '0297', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02677', 'เมืองคง', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02678', 'เมืองแคน', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02679', 'หนองแค', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02680', 'กุง', '0298', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02681', 'คลีกลิ้ง', '0298', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02682', 'จิกสังข์ทอง', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02683', 'ด่าน', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02684', 'ดู่', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02685', 'หนองอึ่ง', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02686', 'บัวหุ่ง', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02687', 'ไผ่', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02688', 'ส้มป่อย', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02689', 'หนองหมี', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02690', 'หว้านคำ', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02691', 'สร้างปี่', '0298', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02692', 'โจดม่วง', '0298', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02693', 'หนองบัวดง', '0298', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02694', 'กำแพง', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02695', 'อี่หล่ำ', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02696', 'ก้านเหลือง', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02697', 'ทุ่งไชย', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02698', 'สำโรง', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02699', 'แขม', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02700', 'หนองไฮ', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02701', 'ขะยูง', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02702', 'ตาโกน', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02703', 'ตาเกษ', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02704', 'หัวช้าง', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02705', 'รังแร้ง', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02706', 'เมืองจันทร์', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02707', 'แต้', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02708', 'แข้', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02709', 'โพธิ์ชัย', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02710', 'ปะอาว', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02711', 'หนองห้าง', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02712', 'โดด', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02713', 'เสียว', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02714', 'หนองม้า', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02715', 'สระกำแพงใหญ่', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02716', 'หนองใหญ่', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02717', 'โคกหล่าม', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02718', 'โคกจาน', '0299', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02719', 'ผือใหญ่', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02720', 'อีเซ', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02721', 'ผักไหม', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02722', 'กล้วยกว้าง', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02723', 'ห้วยทับทัน', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02724', 'เป๊าะ', '0299', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02725', 'เป๊าะ', '0300', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02726', 'บึงบูรพ์', '0300', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02727', 'ห้วยทับทัน', '0301', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02728', 'เมืองหลวง', '0301', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02729', 'กล้วยกว้าง', '0301', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02730', 'ผักไหม', '0301', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02731', 'จานแสนไชย', '0301', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02732', 'ปราสาท', '0301', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02733', 'โนนค้อ', '0302', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02734', 'บก', '0302', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02735', 'โพธิ์', '0302', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02736', 'หนองกุง', '0302', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02737', 'เหล่ากวาง', '0302', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02738', 'ศรีแก้ว', '0303', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02739', 'พิงพวย', '0303', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02740', 'สระเยาว์', '0303', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02741', 'ตูม', '0303', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02742', 'เสื่องข้าว', '0303', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02743', 'ศรีโนนงาม', '0303', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02744', 'สะพุง', '0303', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02745', 'น้ำเกลี้ยง', '0304', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02746', 'ละเอาะ', '0304', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02747', 'ตองปิด', '0304', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02748', 'เขิน', '0304', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02749', 'รุ่งระวี', '0304', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02750', 'คูบ', '0304', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02751', 'บุสูง', '0305', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02752', 'ธาตุ', '0305', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02753', 'ดวนใหญ่', '0305', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02754', 'บ่อแก้ว', '0305', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02755', 'ศรีสำราญ', '0305', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02756', 'ทุ่งสว่าง', '0305', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02757', 'วังหิน', '0305', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02758', 'โพนยาง', '0305', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02759', 'โคกตาล', '0306', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02760', 'ห้วยตามอญ', '0306', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02761', 'ห้วยตึ๊กชู', '0306', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02762', 'ละลม', '0306', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02763', 'ตะเคียนราม', '0306', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02764', 'ดงรัก', '0306', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02765', 'ไพรพัฒนา', '0306', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02766', 'เมืองจันทร์', '0307', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02767', 'ตาโกน', '0307', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02768', 'หนองใหญ่', '0307', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02769', 'เสียว', '0308', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02770', 'หนองหว้า', '0308', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02771', 'หนองงูเหลือม', '0308', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02772', 'หนองฮาง', '0308', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02773', 'ท่าคล้อ', '0308', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02774', 'พยุห์', '0309', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02775', 'พรหมสวัสดิ์', '0309', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02776', 'ตำแย', '0309', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02777', 'โนนเพ็ก', '0309', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02778', 'หนองค้า', '0309', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02779', 'โดด', '0310', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02780', 'เสียว', '0310', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02781', 'หนองม้า', '0310', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02782', 'ผือใหญ่', '0310', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02783', 'อีเซ', '0310', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02784', 'กุง', '0311', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02785', 'คลีกลิ้ง', '0311', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02786', 'หนองบัวดง', '0311', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02787', 'โจดม่วง', '0311', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02788', 'ในเมือง', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02789', 'โพนเมือง', '0312', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02790', 'ท่าเมือง', '0312', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02791', 'หัวเรือ', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02792', 'หนองขอน', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02793', 'ดอนมดแดง', '0312', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02794', 'ปทุม', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02795', 'ขามใหญ่', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02796', 'แจระแม', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02797', 'คำไฮใหญ่', '0312', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02798', 'หนองบ่อ', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02799', 'ไร่น้อย', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02800', 'กระโสบ', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02801', 'เหล่าแดง', '0312', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02802', 'เหล่าเสือโก้ก', '0312', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02803', 'กุดลาด', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02804', 'หนองบก', '0312', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02805', 'แพงใหญ่', '0312', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02806', 'ขี้เหล็ก', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02807', 'ปะอาว', '0312', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02808', 'นาคำ', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02809', 'แก้งกอก', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02810', 'เอือดใหญ่', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02811', 'วาริน', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02812', 'ลาดควาย', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02813', 'สงยาง', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02814', 'ตะบ่าย', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02815', 'คำไหล', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02816', 'หนามแท่ง', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02817', 'นาเลิน', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02818', 'ดอนใหญ่', '0313', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02819', 'โขงเจียม', '0314', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02820', 'ห้วยยาง', '0314', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02821', 'นาโพธิ์กลาง', '0314', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02822', 'หนองแสงใหญ่', '0314', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02823', 'ห้วยไผ่', '0314', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02824', 'คำเขื่อนแก้ว', '0314', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02825', 'เขื่องใน', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02826', 'สร้างถ่อ', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02827', 'ค้อทอง', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02828', 'ก่อเอ้', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02829', 'หัวดอน', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02830', 'ชีทวน', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02831', 'ท่าไห', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02832', 'นาคำใหญ่', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02833', 'แดงหม้อ', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02834', 'ธาตุน้อย', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02835', 'บ้านไทย', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02836', 'บ้านกอก', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02837', 'กลางใหญ่', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02838', 'โนนรัง', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02839', 'ยางขี้นก', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02840', 'ศรีสุข', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02841', 'สหธาตุ', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02842', 'หนองเหล่า', '0315', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02843', 'เขมราฐ', '0316', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02844', 'กองโพน', '0316', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02845', 'ขามป้อม', '0316', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02846', 'เจียด', '0316', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02847', 'พังเคน', '0316', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02848', 'นาตาล', '0316', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02849', 'หนองผือ', '0316', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02850', 'นาแวง', '0316', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02851', 'พะลาน', '0316', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02852', 'แก้งเหนือ', '0316', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02853', 'หนองนกทา', '0316', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02854', 'หนองสิม', '0316', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02855', 'หัวนา', '0316', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02856', 'ชานุมาน', '0317', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02857', 'โคกสาร', '0317', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02858', 'คำเขื่อนแก้ว', '0317', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02859', 'หนองข่า', '0317', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02860', 'คำโพน', '0317', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02861', 'โคกก่ง', '0317', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02862', 'ป่าก่อ', '0317', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02863', 'เมืองเดช', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02864', 'นาส่วง', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02865', 'นาเยีย', '0318', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02866', 'นาเจริญ', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02867', 'นาเรือง', '0318', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02868', 'ทุ่งเทิง', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02869', 'หนองอ้ม', '0318', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02870', 'สมสะอาด', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02871', 'กุดประทาย', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02872', 'ตบหู', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02873', 'กลาง', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02874', 'แก้ง', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02875', 'ท่าโพธิ์ศรี', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02876', 'นาเกษม', '0318', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02877', 'บัวงาม', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02878', 'คำครั่ง', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02879', 'นากระแซง', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02880', 'กุดเรือ', '0318', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02881', 'นาดี', '0318', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02882', 'โพนงาม', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02883', 'ป่าโมง', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02884', 'โคกชำแระ', '0318', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02885', 'โนนสมบูรณ์', '0318', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02886', 'นาจะหลวย', '0319', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02887', 'โนนสมบูรณ์', '0319', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02888', 'พรสวรรค์', '0319', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02889', 'บ้านตูม', '0319', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02890', 'โสกแสง', '0319', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02891', 'โนนสวรรค์', '0319', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02892', 'โซง', '0320', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02893', 'ตาเกา', '0320', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02894', 'ยาง', '0320', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02895', 'โดมประดิษฐ์', '0320', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02896', 'ขี้เหล็ก', '0320', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02897', 'บุเปือย', '0320', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02898', 'สีวิเชียร', '0320', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02899', 'ไพบูลย์', '0320', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02900', 'ยางใหญ่', '0320', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02901', 'โคกสะอาด', '0320', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02902', 'เก่าขาม', '0320', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02903', 'โพนงาม', '0321', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02904', 'ห้วยข่า', '0321', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02905', 'คอแลน', '0321', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02906', 'นาโพธิ์', '0321', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02907', 'หนองสะโน', '0321', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02908', 'โนนค้อ', '0321', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02909', 'บัวงาม', '0321', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02910', 'บ้านแมด', '0321', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02911', 'ขุหลุ', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02912', 'กระเดียน', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02913', 'เกษม', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02914', 'กุศกร', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02915', 'ขามเปี้ย', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02916', 'คอนสาย', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02917', 'โคกจาน', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02918', 'นาพิน', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02919', 'นาสะไม', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02920', 'โนนกุง', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02921', 'ตระการ', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02922', 'ตากแดด', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02923', 'ไหล่ทุ่ง', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02924', 'เป้า', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02925', 'เซเป็ด', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02926', 'สะพือ', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02927', 'หนองเต่า', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02928', 'ถ้ำแข้', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02929', 'ท่าหลวง', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02930', 'ห้วยฝ้ายพัฒนา', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02931', 'กุดยาลวน', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02932', 'บ้านแดง', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02933', 'คำเจริญ', '0322', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02934', 'ข้าวปุ้น', '0323', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02935', 'โนนสวาง', '0323', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02936', 'แก่งเค็ง', '0323', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02937', 'กาบิน', '0323', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02938', 'หนองทันน้ำ', '0323', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02939', 'พนา', '0324', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02940', 'จานลาน', '0324', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02941', 'ไม้กลอน', '0324', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02942', 'ลือ', '0324', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02943', 'ห้วย', '0324', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02944', 'นาหว้า', '0324', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02945', 'พระเหลา', '0324', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02946', 'นาป่าแซง', '0324', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02947', 'ม่วงสามสิบ', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02948', 'เหล่าบก', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02949', 'ดุมใหญ่', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02950', 'หนองช้างใหญ่', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02951', 'หนองเมือง', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02952', 'เตย', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02953', 'ยางสักกระโพหลุ่ม', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02954', 'หนองไข่นก', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02955', 'หนองเหล่า', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02956', 'หนองฮาง', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02957', 'ยางโยภาพ', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02958', 'ไผ่ใหญ่', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02959', 'นาเลิง', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02960', 'โพนแพง', '0325', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02961', 'วารินชำราบ', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02962', 'ธาตุ', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02963', 'ท่าช้าง', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02964', 'ท่าลาด', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02965', 'โนนโหนน', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02966', 'โนนกาเล็น', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02967', 'คูเมือง', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02968', 'สระสมิง', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02969', 'ค้อน้อย', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02970', 'คำน้ำแซบ', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02971', 'บุ่งหวาย', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02972', 'หนองไฮ', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02973', 'สำโรง', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02974', 'สว่าง', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02975', 'คำขวาง', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02976', 'โพธิ์ใหญ่', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02977', 'โคกก่อง', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02978', 'แสนสุข', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02979', 'โคกสว่าง', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02980', 'หนองกินเพล', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02981', 'โนนผึ้ง', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02982', 'เมืองศรีไค', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02983', 'บุ่งมะแลง', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02984', 'ห้วยขะยูง', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02985', 'แก่งโดม', '0326', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02986', 'บุ่งไหม', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '02987', 'บุ่ง', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02988', 'ไก่คำ', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02989', 'นาจิก', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02990', 'ดงมะยาง', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02991', 'อำนาจ', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02992', 'เปือย', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02993', 'ดงบัง', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02994', 'ไร่ขี', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02995', 'ปลาค้าว', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02996', 'เหล่าพรวน', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02997', 'สร้างนกทา', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02998', 'คิ่มใหญ่', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '02999', 'นาผือ', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03000', 'น้ำปลีก', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03001', 'นาวัง', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03002', 'นาหมอม้า', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03003', 'โนนโพธิ์', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03004', 'โนนหนามแท่ง', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03005', 'ห้วยไร่', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03006', 'หนองมะแซว', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03007', 'แมด', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03008', 'กุดปลาดุก', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03009', 'โนนงาม', '0327', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03010', 'เสนางคนิคม', '0328', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03011', 'โพนทอง', '0328', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03012', 'ไร่สีสุก', '0328', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03013', 'นาเวียง', '0328', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03014', 'หนองไฮ', '0328', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03015', 'หนองสามสี', '0328', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03016', 'หัวตะพาน', '0329', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03017', 'คำพระ', '0329', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03018', 'เค็งใหญ่', '0329', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03019', 'หนองแก้ว', '0329', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03020', 'โพนเมืองน้อย', '0329', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03021', 'สร้างถ่อน้อย', '0329', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03022', 'จิกดู่', '0329', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03023', 'รัตนวารี', '0329', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03024', 'พิบูล', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03025', 'กุดชมภู', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03026', 'คันไร่', '0330', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03027', 'ดอนจิก', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03028', 'ทรายมูล', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03029', 'นาโพธิ์', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03030', 'โนนกลาง', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03031', 'ฝางคำ', '0330', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03032', 'โพธิ์ไทร', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03033', 'โพธิ์ศรี', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03034', 'ระเว', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03035', 'ไร่ใต้', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03036', 'หนองบัวฮี', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03037', 'อ่างศิลา', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03038', 'นิคมสร้างตนเองฯ', '0330', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03039', 'ช่องเม็ก', '0330', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03040', 'โนนก่อ', '0330', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03041', 'โนนกาหลง', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03042', 'บ้านแขม', '0330', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03043', 'ตาลสุม', '0331', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03044', 'สำโรง', '0331', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03045', 'จิกเทิง', '0331', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03046', 'หนองกุง', '0331', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03047', 'นาคาย', '0331', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03048', 'คำหว้า', '0331', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03049', 'โพธิ์ไทร', '0332', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03050', 'ม่วงใหญ่', '0332', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03051', 'สำโรง', '0332', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03052', 'สองคอน', '0332', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03053', 'สารภี', '0332', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03054', 'เหล่างาม', '0332', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03055', 'สำโรง', '0333', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03056', 'โคกก่อง', '0333', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03057', 'หนองไฮ', '0333', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03058', 'ค้อน้อย', '0333', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03059', 'โนนกาเล็น', '0333', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03060', 'โคกสว่าง', '0333', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03061', 'โนนกลาง', '0333', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03062', 'บอน', '0333', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03063', 'ขามป้อม', '0333', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03064', 'อำนาจ', '0334', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03065', 'ดงมะยาง', '0334', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03066', 'เปือย', '0334', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03067', 'ดงบัง', '0334', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03068', 'ไร่ขี', '0334', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03069', 'แมด', '0334', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03070', 'ดอนมดแดง', '0335', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03071', 'เหล่าแดง', '0335', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03072', 'ท่าเมือง', '0335', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03073', 'คำไฮใหญ่', '0335', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03074', 'คันไร่', '0336', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03075', 'ช่องเม็ก', '0336', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03076', 'โนนก่อ', '0336', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03077', 'นิคมสร้างตนเองลำโดมน้อย', '0336', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03078', 'ฝางคำ', '0336', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03079', 'คำเขื่อนแก้ว', '0336', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03080', 'ทุ่งเทิง', '0337', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03081', 'หนองอ้ม', '0337', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03082', 'นาเกษม', '0337', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03083', 'กุดเรือ', '0337', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03084', 'โคกชำแระ', '0337', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03085', 'นาห่อม', '0337', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03086', 'หนองข่า', '0338', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03087', 'คำโพน', '0338', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03088', 'นาหว้า', '0338', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03089', 'ลือ', '0338', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03090', 'ห้วย', '0338', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03091', 'โนนงาม', '0338', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03092', 'นาป่าแซง', '0338', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03093', 'นาเยีย', '0340', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03094', 'นาดี', '0340', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03095', 'นาเรือง', '0340', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03096', 'นาตาล', '0341', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03097', 'พะลาน', '0341', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03098', 'กองโพน', '0341', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03099', 'พังเคน', '0341', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03100', 'เหล่าเสือโก้ก', '0342', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03101', 'โพนเมือง', '0342', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03102', 'แพงใหญ่', '0342', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03103', 'หนองบก', '0342', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03104', 'แก่งโดม', '0343', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03105', 'ท่าช้าง', '0343', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03106', 'บุ่งมะแลง', '0343', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03107', 'สว่าง', '0343', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03108', 'ตาเกา', '0344', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03109', 'ไพบูลย์', '0344', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03110', 'ขี้เหล็ก', '0344', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03111', 'โคกสะอาด', '0344', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03112', 'ในเมือง', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03113', 'น้ำคำใหญ่', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03114', 'ตาดทอง', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03115', 'สำราญ', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03116', 'ค้อเหนือ', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03117', 'ดู่ทุ่ง', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03118', 'เดิด', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03119', 'ขั้นไดใหญ่', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03120', 'ทุ่งแต้', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03121', 'สิงห์', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03122', 'นาสะไมย์', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03123', 'เขื่องคำ', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03124', 'หนองหิน', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03125', 'หนองคู', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03126', 'ขุมเงิน', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03127', 'ทุ่งนางโอก', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03128', 'หนองเรือ', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03129', 'หนองเป็ด', '0346', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03130', 'นาเวียง', '0346', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03131', 'ดงมะไฟ', '0346', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03132', 'ดู่ลาย', '0346', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03133', 'ทรายมูล', '0346', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03134', 'ทรายมูล', '0347', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03135', 'ดู่ลาด', '0347', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03136', 'ดงมะไฟ', '0347', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03137', 'นาเวียง', '0347', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03138', 'ไผ่', '0347', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03139', 'กุดชุม', '0348', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03140', 'โนนเปือย', '0348', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03141', 'กำแมด', '0348', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03142', 'นาโส่', '0348', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03143', 'ห้วยแก้ง', '0348', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03144', 'หนองหมี', '0348', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03145', 'โพนงาม', '0348', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03146', 'คำน้ำสร้าง', '0348', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03147', 'หนองแหน', '0348', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03148', 'ลุมพุก', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03149', 'ย่อ', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03150', 'สงเปือย', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03151', 'โพนทัน', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03152', 'ทุ่งมน', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03153', 'นาคำ', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03154', 'ดงแคนใหญ่', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03155', 'กู่จาน', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03156', 'นาแก', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03157', 'กุดกุง', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03158', 'เหล่าไฮ', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03159', 'แคนน้อย', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03160', 'ดงเจริญ', '0349', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03161', 'โพธิ์ไทร', '0350', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03162', 'กระจาย', '0350', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03163', 'โคกนาโก', '0350', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03164', 'เชียงเพ็ง', '0350', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03165', 'ศรีฐาน', '0350', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03166', 'ฟ้าหยาด', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03167', 'หัวเมือง', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03168', 'คูเมือง', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03169', 'ผือฮี', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03170', 'บากเรือ', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03171', 'ม่วง', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03172', 'โนนทราย', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03173', 'บึงแก', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03174', 'พระเสาร์', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03175', 'สงยาง', '0351', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03176', 'ค้อวัง', '0351', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03177', 'น้ำอ้อม', '0351', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03178', 'กุดน้ำใส', '0351', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03179', 'ฟ้าห่วน', '0351', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03180', 'ฟ้าห่วน', '0352', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03181', 'กุดน้ำใส', '0352', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03182', 'น้ำอ้อม', '0352', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03183', 'ค้อวัง', '0352', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03184', 'น้ำคำ', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03185', 'บุ่งค้า', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03186', 'สวาท', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03187', 'ส้มผ่อ', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03188', 'ห้องแซง', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03189', 'สามัคคี', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03190', 'กุดเชียงหมี', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03191', 'คำเตย', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03192', 'คำไผ่', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03193', 'สามแยก', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03194', 'กุดแห่', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03195', 'โคกสำราญ', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03196', 'สร้างมิ่ง', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03197', 'ศรีแก้ว', '0353', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03198', 'ไทยเจริญ', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03199', 'ไทยเจริญ', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03200', 'คำไผ่', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03201', 'คำเตย', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03202', 'ส้มผ่อ', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03203', 'น้ำคำ', '0353', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03204', 'ไทยเจริญ', '0354', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03205', 'น้ำคำ', '0354', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03206', 'ส้มผ่อ', '0354', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03207', 'คำเตย', '0354', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03208', 'คำไผ่', '0354', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03209', 'ในเมือง', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03210', 'รอบเมือง', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03211', 'โพนทอง', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03212', 'นาฝาย', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03213', 'บ้านค่าย', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03214', 'กุดตุ้ม', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03215', 'ชีลอง', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03216', 'บ้านเล่า', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03217', 'นาเสียว', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03218', 'หนองนาแซง', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03219', 'ลาดใหญ่', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03220', 'หนองไผ่', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03221', 'ท่าหินโงม', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03222', 'ห้วยต้อน', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03223', 'ห้วยบง', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03224', 'โนนสำราญ', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03225', 'โคกสูง', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03226', 'บุ่งคล้า', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03227', 'ซับสีทอง', '0355', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03228', 'เจาทอง', '0355', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03229', 'บ้านเจียง', '0355', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03230', 'บ้านเขว้า', '0356', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03231', 'ตลาดแร้ง', '0356', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03232', 'ลุ่มลำชี', '0356', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03233', 'ชีบน', '0356', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03234', 'ภูแลนคา', '0356', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03235', 'โนนแดง', '0356', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03236', 'คอนสวรรค์', '0357', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03237', 'ยางหวาย', '0357', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03238', 'ช่องสามหมอ', '0357', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03239', 'โนนสะอาด', '0357', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03240', 'ห้วยไร่', '0357', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03241', 'บ้านโสก', '0357', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03242', 'โคกมั่งงอย', '0357', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03243', 'หนองขาม', '0357', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03244', 'ศรีสำราญ', '0357', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03245', 'บ้านยาง', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03246', 'บ้านหัน', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03247', 'บ้านเดื่อ', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03248', 'บ้านเป้า', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03249', 'กุดเลาะ', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03250', 'โนนกอก', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03251', 'สระโพนทอง', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03252', 'หนองข่า', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03253', 'หนองโพนงาม', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03254', 'บ้านบัว', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03255', 'ซับสีทอง', '0358', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03256', 'โนนทอง', '0358', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03257', 'หนองบัวแดง', '0359', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03258', 'กุดชุมแสง', '0359', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03259', 'ถ้ำวัวแดง', '0359', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03260', 'นางแดด', '0359', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03261', 'บ้านเจียง', '0359', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03262', 'เจาทอง', '0359', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03263', 'หนองแวง', '0359', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03264', 'คูเมือง', '0359', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03265', 'ท่าใหญ่', '0359', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03266', 'วังทอง', '0359', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03267', 'วังชมภู', '0359', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03268', 'เจาทอง', '0359', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03269', 'บ้านเจียง', '0359', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03270', 'บ้านกอก', '0360', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03271', 'หนองบัวบาน', '0360', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03272', 'บ้านขาม', '0360', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03273', 'หนองฉิม', '0360', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03274', 'กุดน้ำใส', '0360', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03275', 'หนองโดน', '0360', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03276', 'ละหาน', '0360', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03277', 'ตาเนิน', '0360', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03278', 'กะฮาด', '0360', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03279', 'หนองบัวใหญ่', '0360', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03280', 'หนองบัวโคก', '0360', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03281', 'ท่ากูบ', '0360', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03282', 'ส้มป่อย', '0360', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03283', 'ซับใหญ่', '0360', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03284', 'รังงาม', '0360', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03285', 'ตะโกทอง', '0360', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03286', 'บ้านชวน', '0361', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03287', 'บ้านเพชร', '0361', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03288', 'บ้านตาล', '0361', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03289', 'หัวทะเล', '0361', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03290', 'โคกเริงรมย์', '0361', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03291', 'เกาะมะนาว', '0361', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03292', 'โคกเพชรพัฒนา', '0361', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03293', 'บ้านไร่', '0361', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03294', 'นายางกลัก', '0361', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03295', 'ห้วยยายจิ๋ว', '0361', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03296', 'วะตะแบก', '0361', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03297', 'หนองบัวระเหว', '0362', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03298', 'วังตะเฆ่', '0362', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03299', 'ห้วยแย้', '0362', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03300', 'โคกสะอาด', '0362', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03301', 'โสกปลาดุก', '0362', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03302', 'วะตะแบก', '0363', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03303', 'ห้วยยายจิ๋ว', '0363', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03304', 'นายางกลัก', '0363', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03305', 'บ้านไร่', '0363', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03306', 'โป่งนก', '0363', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03307', 'ผักปัง', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03308', 'กวางโจน', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03309', 'หนองคอนไทย', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03310', 'บ้านแก้ง', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03311', 'กุดยม', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03312', 'บ้านเพชร', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03313', 'โคกสะอาด', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03314', 'หนองตูม', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03315', 'โอโล', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03316', 'ธาตุทอง', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03317', 'บ้านดอน', '0364', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03318', 'บ้านแท่น', '0365', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03319', 'สามสวน', '0365', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03320', 'สระพัง', '0365', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03321', 'บ้านเต่า', '0365', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03322', 'หนองคู', '0365', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03323', 'ช่องสามหมอ', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03324', 'หนองขาม', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03325', 'นาหนองทุ่ม', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03326', 'บ้านแก้ง', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03327', 'หนองสังข์', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03328', 'หลุบคา', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03329', 'โคกกุง', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03330', 'เก่าย่าดี', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03331', 'ท่ามะไฟหวาน', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03332', 'หนองไผ่', '0366', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03333', 'คอนสาร', '0367', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03334', 'ทุ่งพระ', '0367', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03335', 'โนนคูณ', '0367', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03336', 'ห้วยยาง', '0367', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03337', 'ทุ่งลุยลาย', '0367', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03338', 'ดงบัง', '0367', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03339', 'ทุ่งนาเลา', '0367', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03340', 'ดงกลาง', '0367', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03341', 'บ้านเจียง', '0368', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03342', 'เจาทอง', '0368', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03343', 'วังทอง', '0368', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03344', 'แหลมทอง', '0368', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03345', 'หนองฉิม', '0369', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03346', 'ตาเนิน', '0369', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03347', 'กะฮาด', '0369', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03348', 'รังงาม', '0369', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03349', 'ซับใหญ่', '0370', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03350', 'ท่ากูบ', '0370', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03351', 'ตะโกทอง', '0370', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03352', 'บุ่ง', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03353', 'ไก่คำ', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03354', 'นาจิก', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03355', 'ปลาค้าว', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03356', 'เหล่าพรวน', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03357', 'สร้างนกทา', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03358', 'คึมใหญ่', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03359', 'นาผือ', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03360', 'น้ำปลีก', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03361', 'นาวัง', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03362', 'นาหมอม้า', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03363', 'โนนโพธิ์', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03364', 'โนนหนามแท่ง', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03365', 'ห้วยไร่', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03366', 'หนองมะแซว', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03367', 'กุดปลาดุก', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03368', 'ดอนเมย', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03369', 'นายม', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03370', 'นาแต้', '0380', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03371', 'โพนทอง', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03372', 'ดงมะยาง', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03373', 'เปือย', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03374', 'หนองไฮ', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03375', 'นาเวียง', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03376', 'ไร่ขี', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03377', 'ไร่สีสุก', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03378', 'เสนางคนิคม', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03379', 'อำนาจ', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03380', 'ดงบัง', '0380', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03381', 'ชานุมาน', '0381', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03382', 'โคกสาร', '0381', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03383', 'คำเขื่อนแก้ว', '0381', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03384', 'โคกก่ง', '0381', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03385', 'ป่าก่อ', '0381', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03386', 'หนองข่า', '0381', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03387', 'หนองข่า', '0382', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03388', 'คำโพน', '0382', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03389', 'นาหว้า', '0382', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03390', 'ลือ', '0382', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03391', 'ห้วย', '0382', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03392', 'โนนงาม', '0382', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03393', 'นาป่าแซง', '0382', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03394', 'พนา', '0383', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03395', 'จานลาน', '0383', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03396', 'ไม้กลอน', '0383', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03397', 'พระเหลา', '0383', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03398', 'นาหว้า', '0383', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03399', 'ลือ', '0383', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03400', 'ห้วย', '0383', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03401', 'เสนางคนิคม', '0384', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03402', 'โพนทอง', '0384', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03403', 'ไร่สีสุก', '0384', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03404', 'นาเวียง', '0384', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03405', 'หนองไฮ', '0384', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03406', 'หนองสามสี', '0384', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03407', 'หัวตะพาน', '0385', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03408', 'คำพระ', '0385', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03409', 'เค็งใหญ่', '0385', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03410', 'หนองแก้ว', '0385', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03411', 'โพนเมืองน้อย', '0385', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03412', 'สร้างถ่อน้อย', '0385', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03413', 'จิกดู่', '0385', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03414', 'รัตนวารี', '0385', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03415', 'อำนาจ', '0386', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03416', 'ดงมะยาง', '0386', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03417', 'เปือย', '0386', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03418', 'ดงบัง', '0386', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03419', 'ไร่ขี', '0386', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03420', 'แมด', '0386', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03421', 'โคกกลาง', '0386', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03422', 'หนองบัว', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03423', 'หนองภัยศูนย์', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03424', 'โพธิ์ชัย', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03425', 'หนองสวรรค์', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03426', 'หัวนา', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03427', 'บ้านขาม', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03428', 'นามะเฟือง', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03429', 'บ้านพร้าว', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03430', 'โนนขมิ้น', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03431', 'ลำภู', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03432', 'กุดจิก', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03433', 'โนนทัน', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03434', 'นาคำไฮ', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03435', 'ป่าไม้งาม', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03436', 'หนองหว้า', '0387', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03437', 'นากลาง', '0388', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03438', 'ด่านช้าง', '0388', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03439', 'นาเหล่า', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03440', 'นาแก', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03441', 'กุดดินจี่', '0388', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03442', 'ฝั่งแดง', '0388', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03443', 'เก่ากลอย', '0388', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03444', 'วังทอง', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03445', 'โนนเมือง', '0388', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03446', 'อุทัยสวรรค์', '0388', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03447', 'ดงสวรรค์', '0388', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03448', 'วังปลาป้อม', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03449', 'กุดแห่', '0388', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03450', 'เทพคีรี', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03451', 'โนนภูทอง', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03452', 'นาดี', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03453', 'นาสี', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03454', 'บ้านโคก', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03455', 'โคกนาเหล่า', '0388', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03456', 'โนนสัง', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03457', 'บ้านถิ่น', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03458', 'หนองเรือ', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03459', 'กุดดู่', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03460', 'บ้านค้อ', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03461', 'โนนเมือง', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03462', 'โคกใหญ่', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03463', 'โคกม่วง', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03464', 'นิคมพัฒนา', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03465', 'ปางกู่', '0389', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03466', 'เมืองใหม่', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03467', 'ศรีบุญเรือง', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03468', 'หนองบัวใต้', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03469', 'กุดสะเทียน', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03470', 'นากอก', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03471', 'โนนสะอาด', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03472', 'ยางหล่อ', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03473', 'โนนม่วง', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03474', 'หนองกุงแก้ว', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03475', 'หนองแก', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03476', 'ทรายทอง', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03477', 'หันนางาม', '0390', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03478', 'นาสี', '0391', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03479', 'บ้านโคก', '0391', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03480', 'นาดี', '0391', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03481', 'นาด่าน', '0391', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03482', 'ดงมะไฟ', '0391', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03483', 'สุวรรณคูหา', '0391', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03484', 'บุญทัน', '0391', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03485', 'กุดผึ้ง', '0391', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03486', 'นาเหล่า', '0392', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03487', 'นาแก', '0392', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03488', 'วังทอง', '0392', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03489', 'วังปลาป้อม', '0392', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03490', 'เทพคีรี', '0392', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03491', 'ในเมือง', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03492', 'สำราญ', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03493', 'โคกสี', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03494', 'ท่าพระ', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03495', 'บ้านทุ่ม', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03496', 'เมืองเก่า', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03497', 'พระลับ', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03498', 'สาวะถี', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03499', 'บ้านหว้า', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03500', 'บ้านค้อ', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03501', 'แดงใหญ่', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03502', 'ดอนช้าง', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03503', 'ดอนหัน', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03504', 'ศิลา', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03505', 'บ้านเป็ด', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03506', 'หนองตูม', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03507', 'บึงเนียม', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03508', 'โนนท่อน', '0393', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03509', 'บ้านโต้น', '0393', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03510', 'หนองบัว', '0393', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03511', 'หนองบัว', '0394', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03512', 'ป่าหวายนั่ง', '0394', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03513', 'โนนฆ้อง', '0394', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03514', 'บ้านเหล่า', '0394', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03515', 'ป่ามะนาว', '0394', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03516', 'บ้านฝาง', '0394', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03517', 'โคกงาม', '0394', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03518', 'พระยืน', '0395', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03519', 'พระบุ', '0395', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03520', 'บ้านโต้น', '0395', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03521', 'หนองแวง', '0395', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03522', 'ขามป้อม', '0395', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03523', 'หนองเรือ', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03524', 'บ้านเม็ง', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03525', 'บ้านกง', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03526', 'ยางคำ', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03527', 'จระเข้', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03528', 'โนนทอง', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03529', 'กุดกว้าง', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03530', 'โนนทัน', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03531', 'โนนสะอาด', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03532', 'บ้านผือ', '0396', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03533', 'ชุมแพ', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03534', 'โนนหัน', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03535', 'นาหนองทุ่ม', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03536', 'โนนอุดม', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03537', 'ขัวเรียง', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03538', 'หนองไผ่', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03539', 'ไชยสอ', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03540', 'วังหินลาด', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03541', 'นาเพียง', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03542', 'หนองเขียด', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03543', 'หนองเสาเล้า', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03544', 'โนนสะอาด', '0397', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03545', 'สีชมพู', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03546', 'ศรีสุข', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03547', 'นาจาน', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03548', 'วังเพิ่ม', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03549', 'ซำยาง', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03550', 'หนองแดง', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03551', 'ดงลาน', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03552', 'บริบูรณ์', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03553', 'บ้านใหม่', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03554', 'ภูห่าน', '0398', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03555', 'น้ำพอง', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03556', 'วังชัย', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03557', 'หนองกุง', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03558', 'บัวใหญ่', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03559', 'สะอาด', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03560', 'ม่วงหวาน', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03561', 'บ้านขาม', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03562', 'บัวเงิน', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03563', 'ทรายมูล', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03564', 'ท่ากระเสริม', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03565', 'พังทุย', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03566', 'กุดน้ำใส', '0399', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03567', 'โคกสูง', '0400', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03568', 'บ้านดง', '0400', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03569', 'เขื่อนอุบลรัตน์', '0400', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03570', 'นาคำ', '0400', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03571', 'ศรีสุขสำราญ', '0400', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03572', 'ทุ่งโป่ง', '0400', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03573', 'หนองโก', '0401', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03574', 'หนองกุงใหญ่', '0401', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03575', 'กระนวน', '0401', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03576', 'บ้านโนน', '0401', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03577', 'ห้วยโจด', '0401', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03578', 'ห้วยยาง', '0401', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03579', 'บ้านฝาง', '0401', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03580', 'คำแมด', '0401', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03581', 'ดูนสาด', '0401', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03582', 'หนองโน', '0401', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03583', 'น้ำอ้อม', '0401', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03584', 'หัวนาคำ', '0401', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03585', 'คูคำ', '0401', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03586', 'ห้วยเตย', '0401', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03587', 'บ้านไผ่', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03588', 'ในเมือง', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03589', 'บ้านแฮด', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03590', 'โคกสำราญ', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03591', 'เมืองเพีย', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03592', 'เปือยใหญ่', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03593', 'โนนศิลา', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03594', 'บ้านหัน', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03595', 'บ้านลาน', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03596', 'แคนเหนือ', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03597', 'ภูเหล็ก', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03598', 'หนองแซง', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03599', 'ป่าปอ', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03600', 'หินตั้ง', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03601', 'โนนสมบูรณ์', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03602', 'หนองน้ำใส', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03603', 'หัวหนอง', '0402', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03604', 'บ้านแฮด', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03605', 'โนนแดง', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03606', 'หนองปลาหมอ', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03607', 'สระแก้ว', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03608', 'ขามป้อม', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03609', 'วังม่วง', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03610', 'เปือยน้อย', '0402', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03611', 'เปือยน้อย', '0403', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03612', 'วังม่วง', '0403', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03613', 'ขามป้อม', '0403', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03614', 'สระแก้ว', '0403', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03615', 'เมืองพล', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03616', 'โจดหนองแก', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03617', 'เก่างิ้ว', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03618', 'หนองมะเขือ', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03619', 'หนองแวงโสกพระ', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03620', 'เพ็กใหญ่', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03621', 'โคกสง่า', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03622', 'หนองแวงนางเบ้า', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03623', 'ลอมคอม', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03624', 'โนนข่า', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03625', 'โสกนกเต็น', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03626', 'หัวทุ่ง', '0404', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03627', 'ทางขวาง', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03628', 'ท่าวัด', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03629', 'ท่านางแมว', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03630', 'แวงน้อย', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03631', 'ก้านเหลือง', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03632', 'ละหารนา', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03633', 'แวงใหญ่', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03634', 'โนนทอง', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03635', 'ใหม่นาเพียง', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03636', 'คอนฉิม', '0404', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03637', 'คอนฉิม', '0405', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03638', 'ใหม่นาเพียง', '0405', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03639', 'โนนทอง', '0405', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03640', 'แวงใหญ่', '0405', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03641', 'โนนสะอาด', '0405', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03642', 'แวงน้อย', '0406', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03643', 'ก้านเหลือง', '0406', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03644', 'ท่านางแนว', '0406', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03645', 'ละหานนา', '0406', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03646', 'ท่าวัด', '0406', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03647', 'ทางขวาง', '0406', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03648', 'หนองสองห้อง', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03649', 'คึมชาด', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03650', 'โนนธาตุ', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03651', 'ตะกั่วป่า', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03652', 'สำโรง', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03653', 'หนองเม็ก', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03654', 'ดอนดู่', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03655', 'ดงเค็ง', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03656', 'หันโจด', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03657', 'ดอนดั่ง', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03658', 'วังหิน', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03659', 'หนองไผ่ล้อม', '0407', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03660', 'บ้านเรือ', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03661', 'ในเมือง', '0408', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03662', 'บ้านโคก', '0408', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03663', 'หว้าทอง', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03664', 'กุดขอนแก่น', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03665', 'นาชุมแสง', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03666', 'นาหว้า', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03667', 'เขาน้อย', '0408', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03668', 'กุดธาตุ', '0408', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03669', 'หนองกุงธนสาร', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03670', 'ขนวน', '0408', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03671', 'หนองกุงเซิน', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03672', 'สงเปือย', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03673', 'ทุ่งชมพู', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03674', 'เมืองเก่าพัฒนา', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03675', 'ดินดำ', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03676', 'ภูเวียง', '0408', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03677', 'กุดเค้า', '0409', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03678', 'สวนหม่อน', '0409', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03679', 'หนองแปน', '0409', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03680', 'โพนเพ็ก', '0409', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03681', 'คำแคน', '0409', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03682', 'นาข่า', '0409', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03683', 'นางาม', '0409', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03684', 'บ้านโคก', '0409', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03685', 'โพธิ์ไชย', '0409', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03686', 'ท่าศาลา', '0409', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03687', 'ซับสมบูรณ์', '0409', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03688', 'นาแพง', '0409', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03689', 'ชนบท', '0410', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03690', 'กุดเพียขอม', '0410', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03691', 'วังแสง', '0410', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03692', 'ห้วยแก', '0410', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03693', 'บ้านแท่น', '0410', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03694', 'ศรีบุญเรือง', '0410', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03695', 'โนนพะยอม', '0410', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03696', 'ปอแดง', '0410', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03697', 'เขาสวนกวาง', '0411', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03698', 'ดงเมืองแอม', '0411', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03699', 'นางิ้ว', '0411', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03700', 'โนนสมบูรณ์', '0411', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03701', 'คำม่วง', '0411', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03702', 'โนนคอม', '0412', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03703', 'นาฝาย', '0412', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03704', 'ภูผาม่าน', '0412', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03705', 'วังสวาบ', '0412', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03706', 'ห้วยม่วง', '0412', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03707', 'กระนวน', '0413', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03708', 'คำแมด', '0413', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03709', 'บ้านโนน', '0413', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03710', 'คูคำ', '0413', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03711', 'ห้วยเตย', '0413', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03712', 'บ้านโคก', '0414', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03713', 'โพธิ์ไชย', '0414', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03714', 'ซับสมบูรณ์', '0414', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03715', 'นาแพง', '0414', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03716', 'กุดธาตุ', '0415', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03717', 'บ้านโคก', '0415', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03718', 'ขนวน', '0415', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03719', 'บ้านแฮด', '0416', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03720', 'โคกสำราญ', '0416', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03721', 'โนนสมบูรณ์', '0416', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03722', 'หนองแซง', '0416', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03723', 'โนนศิลา', '0417', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03724', 'หนองปลาหมอ', '0417', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03725', 'บ้านหัน', '0417', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03726', 'เปือยใหญ่', '0417', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03727', 'โนนแดง', '0417', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03728', 'ในเมือง', '0418', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03729', 'เมืองเก่าพัฒนา', '0418', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03730', 'เขาน้อย', '0418', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03731', 'บ้านเป็ด', '0419', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03732', 'หมากแข้ง', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03733', 'นิคมสงเคราะห์', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03734', 'บ้านขาว', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03735', 'หนองบัว', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03736', 'บ้านตาด', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03737', 'โนนสูง', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03738', 'หมูม่น', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03739', 'เชียงยืน', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03740', 'หนองนาคำ', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03741', 'กุดสระ', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03742', 'นาดี', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03743', 'บ้านเลื่อม', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03744', 'เชียงพิณ', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03745', 'สามพร้าว', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03746', 'หนองไฮ', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03747', 'นาข่า', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03748', 'บ้านจั่น', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03749', 'หนองขอนกว้าง', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03750', 'โคกสะอาด', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03751', 'นากว้าง', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03752', 'หนองไผ่', '0421', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03753', 'ขอนยูง', '0421', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03754', 'ปะโค', '0421', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03755', 'หนองหว้า', '0421', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03756', 'ขอนยูง', '0421', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03757', 'ปะโค', '0421', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03758', 'เชียงเพ็ง', '0421', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03759', 'กุดจับ', '0421', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03760', 'หนองปุ', '0421', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03761', 'กุดจับ', '0422', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03762', 'ปะโค', '0422', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03763', 'ขอนยูง', '0422', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03764', 'เชียงเพ็ง', '0422', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03765', 'สร้างก่อ', '0422', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03766', 'เมืองเพีย', '0422', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03767', 'ตาลเลียน', '0422', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03768', 'หมากหญ้า', '0423', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03769', 'หนองอ้อ', '0423', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03770', 'อูบมุง', '0423', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03771', 'กุดหมากไฟ', '0423', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03772', 'น้ำพ่น', '0423', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03773', 'หนองบัวบาน', '0423', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03774', 'โนนหวาย', '0423', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03775', 'หนองวัวซอ', '0423', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03776', 'ตูมใต้', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03777', 'พันดอน', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03778', 'เวียงคำ', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03779', 'แชแล', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03780', 'อุ่มจาน', '0424', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03781', 'เชียงแหว', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03782', 'ห้วยเกิ้ง', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03783', 'ห้วยสามพาด', '0424', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03784', 'เสอเพลอ', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03785', 'สีออ', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03786', 'ปะโค', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03787', 'นาม่วง', '0424', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03788', 'ผาสุก', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03789', 'ท่าลี่', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03790', 'กุมภวาปี', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03791', 'หนองหว้า', '0424', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03792', 'โนนสะอาด', '0424', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03793', 'โพธิ์ศรีสำราญ', '0424', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03794', 'บุ่งแก้ว', '0424', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03795', 'หนองแสง', '0424', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03796', 'แสงสว่าง', '0424', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03797', 'โนนสะอาด', '0425', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03798', 'บุ่งแก้ว', '0425', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03799', 'โพธิ์ศรีสำราญ', '0425', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03800', 'ทมนางาม', '0425', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03801', 'หนองกุงศรี', '0425', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03802', 'โคกกลาง', '0425', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03803', 'หนองหาน', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03804', 'หนองเม็ก', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03805', 'คอนสาย', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03806', 'บ้านจีต', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03807', 'พังงู', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03808', 'สะแบง', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03809', 'สร้อยพร้าว', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03810', 'บ้านแดง', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03811', 'บ้านเชียง', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03812', 'บ้านยา', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03813', 'โพนงาม', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03814', 'ผักตบ', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03815', 'ดอนกลอย', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03816', 'หนองไผ่', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03817', 'นาทราย', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03818', 'ค้อใหญ่', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03819', 'ดอนหายโศก', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03820', 'หนองสระปลา', '0426', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03821', 'โนนทองอินทร์', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03822', 'หนองหลัก', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03823', 'บ้านแดง', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03824', 'ทุ่งใหญ่', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03825', 'ทุ่งฝน', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03826', 'โพนสูง', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03827', 'ไชยวาน', '0426', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03828', 'ทุ่งฝน', '0427', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03829', 'ทุ่งใหญ่', '0427', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03830', 'นาชุมแสง', '0427', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03831', 'นาทม', '0427', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03832', 'ไชยวาน', '0428', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03833', 'หนองหลัก', '0428', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03834', 'คำเลาะ', '0428', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03835', 'โพนสูง', '0428', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03836', 'ศรีธาตุ', '0429', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03837', 'จำปี', '0429', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03838', 'บ้านโปร่ง', '0429', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03839', 'หัวนาคำ', '0429', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03840', 'หนองนกเขียน', '0429', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03841', 'นายูง', '0429', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03842', 'ตาดทอง', '0429', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03843', 'หนองกุงทับม้า', '0430', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03844', 'หนองหญ้าไซ', '0430', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03845', 'บะยาว', '0430', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03846', 'ผาสุก', '0430', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03847', 'คำโคกสูง', '0430', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03848', 'วังสามหมอ', '0430', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03849', 'ศรีสุทโธ', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03850', 'บ้านดุง', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03851', 'ดงเย็น', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03852', 'โพนสูง', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03853', 'อ้อมกอ', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03854', 'บ้านจันทน์', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03855', 'บ้านชัย', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03856', 'นาไหม', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03857', 'ถ่อนนาลับ', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03858', 'วังทอง', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03859', 'บ้านม่วง', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03860', 'บ้านตาด', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03861', 'นาคำ', '0431', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03862', 'หนองบัว', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03863', 'หนองภัยศูนย์', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03864', 'โพธิ์ชัย', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03865', 'หนองสวรรค์', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03866', 'หัวนา', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03867', 'บ้านขาม', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03868', 'นามะเฟือง', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03869', 'บ้านพร้าว', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03870', 'โนนขมิ้น', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03871', 'ลำภู', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03872', 'กุดจิก', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03873', 'โนนทัน', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03874', 'นาคำไฮ', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03875', 'ป่าไม้งาม', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03876', 'หนองหว้า', '0432', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03877', 'เมืองใหม่', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03878', 'ศรีบุญเรือง', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03879', 'หนองบัวใต้', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03880', 'กุดสะเทียน', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03881', 'นากอก', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03882', 'โนนสะอาด', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03883', 'ยางหล่อ', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03884', 'โนนม่วง', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03885', 'หนองกุงแก้ว', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03886', 'หนองแก', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03887', 'ทรายทอง', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03888', 'หันนางาม', '0433', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03889', 'นากลาง', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03890', 'ด่านช้าง', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03891', 'นาเหล่า', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03892', 'นาแก', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03893', 'กุดดินจี่', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03894', 'ฝั่งแดง', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03895', 'เก่ากลอย', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03896', 'วังทอง', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03897', 'โนนเมือง', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03898', 'อุทัยสวรรค์', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03899', 'ดงสวรรค์', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03900', 'วังปลาป้อม', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03901', 'กุดแห่', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03902', 'เทพคีรี', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03903', 'โนนภูทอง', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03904', 'บุญทัน', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03905', 'สุวรรณคูหา', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03906', 'ดงมะไฟ', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03907', 'นาด่าน', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03908', 'นาดี', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03909', 'บ้านโคก', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03910', 'นาสี', '0434', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03911', 'นาสี', '0435', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03912', 'บ้านโคก', '0435', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03913', 'นาดี', '0435', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03914', 'นาด่าน', '0435', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03915', 'ดงมะไฟ', '0435', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03916', 'สุวรรณคูหา', '0435', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03917', 'บุญทัน', '0435', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03918', 'โนนสัง', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03919', 'บ้านถิ่น', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03920', 'หนองเรือ', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03921', 'กุดดู่', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03922', 'บ้านค้อ', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03923', 'โนนเมือง', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03924', 'โคกใหญ่', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03925', 'โคกม่วง', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03926', 'นิคมพัฒนา', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03927', 'ปางกู่', '0436', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03928', 'บ้านผือ', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03929', 'หายโศก', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03930', 'เขือน้ำ', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03931', 'คำบง', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03932', 'โนนทอง', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03933', 'ข้าวสาร', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03934', 'จำปาโมง', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03935', 'กลางใหญ่', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03936', 'เมืองพาน', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03937', 'คำด้วง', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03938', 'หนองหัวคู', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03939', 'บ้านค้อ', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03940', 'หนองแวง', '0437', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03941', 'บ้านเม็ก', '0437', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03942', 'นางัว', '0438', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03943', 'น้ำโสม', '0438', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03944', 'นายูง', '0438', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03945', 'นาแค', '0438', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03946', 'หนองแวง', '0438', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03947', 'บ้านหยวก', '0438', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03948', 'โสมเยี่ยม', '0438', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03949', 'โนนทอง', '0438', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03950', 'บ้านก้อง', '0438', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03951', 'ศรีสำราญ', '0438', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03952', 'ทุบกุง', '0438', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03953', 'สามัคคี', '0438', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03954', 'นาแค', '0438', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03955', 'นายูง', '0438', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03956', 'เพ็ญ', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03957', 'บ้านธาตุ', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03958', 'นาพู่', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03959', 'เชียงหวาง', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03960', 'สุมเส้า', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03961', 'นาบัว', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03962', 'บ้านเหล่า', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03963', 'จอมศรี', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03964', 'เตาไห', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03965', 'โคกกลาง', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03966', 'สร้างแป้น', '0439', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03967', 'เชียงดา', '0439', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03968', 'บ้านยวด', '0439', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03969', 'สร้างคอม', '0439', -1 )
INSERT INTO tbm_sub_district
VALUES
( '03970', 'สร้างคอม', '0440', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03971', 'เชียงดา', '0440', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03972', 'บ้านยวด', '0440', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03973', 'บ้านโคก', '0440', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03974', 'นาสะอาด', '0440', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03975', 'บ้านหินโงม', '0440', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03976', 'หนองแสง', '0441', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03977', 'แสงสว่าง', '0441', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03978', 'นาดี', '0441', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03979', 'ทับกุง', '0441', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03980', 'นายูง', '0442', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03981', 'บ้านก้อง', '0442', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03982', 'นาแค', '0442', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03983', 'โนนทอง', '0442', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03984', 'บ้านแดง', '0443', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03985', 'นาทราย', '0443', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03986', 'ดอนกลอย', '0443', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03987', 'บ้านจีต', '0444', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03988', 'โนนทองอินทร์', '0444', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03989', 'ค้อใหญ่', '0444', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03990', 'คอนสาย', '0444', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03991', 'นาม่วง', '0445', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03992', 'ห้วยสามพาด', '0445', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03993', 'อุ่มจาน', '0445', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03994', 'กุดป่อง', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03995', 'เมือง', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03996', 'นาอ้อ', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03997', 'กกดู่', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03998', 'น้ำหมาน', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '03999', 'เสี้ยว', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04000', 'นาอาน', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04001', 'นาโป่ง', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04002', 'นาดินดำ', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04003', 'น้ำสวย', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04004', 'ชัยพฤกษ์', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04005', 'นาแขม', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04006', 'ศรีสองรัก', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04007', 'กกทอง', '0446', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04008', 'นาด้วง', '0447', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04009', 'นาดอกคำ', '0447', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04010', 'ท่าสะอาด', '0447', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04011', 'ท่าสวรรค์', '0447', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04012', 'เชียงคาน', '0448', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04013', 'ธาตุ', '0448', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04014', 'นาซ่าว', '0448', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04015', 'เขาแก้ว', '0448', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04016', 'ปากตม', '0448', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04017', 'บุฮม', '0448', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04018', 'จอมศรี', '0448', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04019', 'หาดทรายขาว', '0448', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04020', 'ปากชม', '0449', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04021', 'เชียงกลม', '0449', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04022', 'หาดคัมภีร์', '0449', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04023', 'ห้วยบ่อซืน', '0449', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04024', 'ห้วยพิชัย', '0449', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04025', 'ชมเจริญ', '0449', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04026', 'ด่านซ้าย', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04027', 'ปากหมัน', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04028', 'นาดี', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04029', 'โคกงาม', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04030', 'โพนสูง', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04031', 'อิปุ่ม', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04032', 'กกสะทอน', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04033', 'โป่ง', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04034', 'วังยาว', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04035', 'นาหอ', '0450', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04036', 'ร่องจิก', '0450', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04037', 'แสงภา', '0450', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04038', 'ปลาบ่า', '0450', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04039', 'นาพึ่ง', '0450', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04040', 'ท่าศาลา', '0450', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04041', 'หนองบัว', '0450', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04042', 'นาแห้ว', '0450', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04043', 'นาแห้ว', '0451', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04044', 'แสงภา', '0451', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04045', 'นาพึง', '0451', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04046', 'นามาลา', '0451', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04047', 'เหล่ากอหก', '0451', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04048', 'หนองบัว', '0452', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04049', 'ท่าศาลา', '0452', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04050', 'ร่องจิก', '0452', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04051', 'ปลาบ่า', '0452', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04052', 'ลาดค่าง', '0452', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04053', 'สานตม', '0452', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04054', 'ท่าลี่', '0453', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04055', 'หนองผือ', '0453', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04056', 'อาฮี', '0453', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04057', 'น้ำแคม', '0453', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04058', 'โคกใหญ่', '0453', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04059', 'น้ำทูน', '0453', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04060', 'วังสะพุง', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04061', 'ทรายขาว', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04062', 'หนองหญ้าปล้อง', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04063', 'หนองงิ้ว', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04064', 'ปากปวน', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04065', 'ผาน้อย', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04066', 'เอราวัณ', '0454', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04067', 'ผาอินทร์แปลง', '0454', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04068', 'ผาสามยอด', '0454', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04069', 'ผาบิ้ง', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04070', 'เขาหลวง', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04071', 'โคกขมิ้น', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04072', 'ศรีสงคราม', '0454', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04073', 'ทรัพย์ไพวัลย์', '0454', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04074', 'หนองคัน', '0454', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04075', 'ภูหอ', '0454', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04076', 'ศรีฐาน', '0455', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04077', 'ปวนพุ', '0455', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04078', 'ท่าช้างคล้อง', '0455', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04079', 'ผาขาว', '0455', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04080', 'ผานกเค้า', '0455', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04081', 'โนนป่าซาง', '0455', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04082', 'ภูกระดึง', '0455', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04083', 'หนองหิน', '0455', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04084', 'โนนปอแดง', '0455', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04085', 'ห้วยส้ม', '0455', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04086', 'ตาดข่า', '0455', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04087', 'ภูหอ', '0456', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04088', 'หนองคัน', '0456', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04089', 'วังน้ำใส', '0456', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04090', 'ห้วยสีเสียด', '0456', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04091', 'เลยวังไสย์', '0456', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04092', 'แก่งศรีภูมิ', '0456', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04093', 'ผาขาว', '0457', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04094', 'ท่าช้างคล้อง', '0457', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04095', 'โนนปอแดง', '0457', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04096', 'โนนป่าซาง', '0457', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04097', 'บ้านเพิ่ม', '0457', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04098', 'เอราวัณ', '0458', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04099', 'ผาอินทร์แปลง', '0458', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04100', 'ผาสามยอด', '0458', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04101', 'ทรัพย์ไพวัลย์', '0458', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04102', 'หนองหิน', '0459', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04103', 'ตาดข่า', '0459', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04104', 'ปวนพุ', '0459', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04105', 'ในเมือง', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04106', 'มีชัย', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04107', 'โพธิ์ชัย', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04108', 'กวนวัน', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04109', 'เวียงคุก', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04110', 'วัดธาตุ', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04111', 'หาดคำ', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04112', 'หินโงม', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04113', 'บ้านเดื่อ', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04114', 'ค่ายบกหวาน', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04115', 'สองห้อง', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04116', 'สระใคร', '0460', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04117', 'พระธาตุบังพวน', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04118', 'บ้านฝาง', '0460', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04119', 'คอกช้าง', '0460', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04120', 'หนองกอมเกาะ', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04121', 'ปะโค', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04122', 'เมืองหมี', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04123', 'สีกาย', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04124', 'ท่าบ่อ', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04125', 'น้ำโมง', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04126', 'กองนาง', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04127', 'โคกคอน', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04128', 'บ้านเดื่อ', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04129', 'บ้านถ่อน', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04130', 'บ้านว่าน', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04131', 'นาข่า', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04132', 'โพนสา', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04133', 'หนองนาง', '0461', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04134', 'บึงกาฬ', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04135', 'ชุมภูพร', '0462', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04136', 'โนนสมบูรณ์', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04137', 'หนองเข็ง', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04138', 'หอคำ', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04139', 'หนองเลิง', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04140', 'โคกก่อง', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04141', 'หนองเดิ่น', '0462', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04142', 'นาสะแบง', '0462', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04143', 'นาสวรรค์', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04144', 'ไคสี', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04145', 'โคกกว้าง', '0462', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04146', 'ศรีวิไล', '0462', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04147', 'ชัยพร', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04148', 'นาแสง', '0462', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04149', 'วิศิษฐ์', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04150', 'บุ่งคล้า', '0462', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04151', 'คำนาดี', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04152', 'โป่งเปือย', '0462', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04153', 'ศรีชมภู', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04154', 'ดอนหญ้านาง', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04155', 'พรเจริญ', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04156', 'หนองหัวช้าง', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04157', 'วังชมภู', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04158', 'ป่าแฝก', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04159', 'ศรีสำราญ', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04160', 'จุมพล', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04161', 'วัดหลวง', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04162', 'กุดบง', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04163', 'ชุมช้าง', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04164', 'รัตนวาปี', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04165', 'ทุ่งหลวง', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04166', 'เหล่าต่างคำ', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04167', 'นาหนัง', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04168', 'เซิม', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04169', 'หนองหลวง', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04170', 'โพนแพง', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04171', 'เฝ้าไร่', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04172', 'บ้านโพธิ์', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04173', 'นาทับไฮ', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04174', 'วังหลวง', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04175', 'พระบาทนาสิงห์', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04176', 'อุดมพร', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04177', 'นาดี', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04178', 'บ้านต้อน', '0464', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04179', 'บ้านผือ', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04180', 'สร้างนางขาว', '0464', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04181', 'โซ่', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04182', 'หนองพันทา', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04183', 'ศรีชมภู', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04184', 'คำแก้ว', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04185', 'บัวตูม', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04186', 'ถ้ำเจริญ', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04187', 'เหล่าทอง', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04188', 'พานพร้าว', '0466', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04189', 'โพธิ์ตาก', '0466', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04190', 'บ้านหม้อ', '0466', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04191', 'พระพุทธบาท', '0466', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04192', 'หนองปลาปาก', '0466', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04193', 'โพนทอง', '0466', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04194', 'ด่านศรีสุข', '0466', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04195', 'แก้งไก่', '0467', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04196', 'ผาตั้ง', '0467', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04197', 'บ้านม่วง', '0467', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04198', 'นางิ้ว', '0467', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04199', 'สังคม', '0467', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04200', 'เซกา', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04201', 'ซาง', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04202', 'ท่ากกแดง', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04203', 'โพธิ์หมากแข้ง', '0468', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04204', 'ดงบัง', '0468', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04205', 'บ้านต้อง', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04206', 'ป่งไฮ', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04207', 'น้ำจั้น', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04208', 'ท่าสะอาด', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04209', 'บึงโขงหลง', '0468', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04210', 'ท่าดอกคำ', '0468', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04211', 'หนองทุ่ม', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04212', 'โสกก่าม', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04213', 'ปากคาด', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04214', 'หนองยอง', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04215', 'นากั้ง', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04216', 'โนนศิลา', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04217', 'สมสนุก', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04218', 'นาดง', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04219', 'บึงโขงหลง', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04220', 'โพธิ์หมากแข้ง', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04221', 'ดงบัง', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04222', 'ท่าดอกคำ', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04223', 'ศรีวิไล', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04224', 'ชุมภูพร', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04225', 'นาแสง', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04226', 'นาสะแบง', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04227', 'นาสิงห์', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04228', 'บุ่งคล้า', '0472', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04229', 'หนองเดิ่น', '0472', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04230', 'โคกกว้าง', '0472', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04231', 'สระใคร', '0473', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04232', 'คอกช้าง', '0473', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04233', 'บ้านฝาง', '0473', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04234', 'เฝ้าไร่', '0474', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04235', 'นาดี', '0474', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04236', 'หนองหลวง', '0474', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04237', 'วังหลวง', '0474', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04238', 'อุดมพร', '0474', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04239', 'รัตนวาปี', '0475', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04240', 'นาทับไฮ', '0475', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04241', 'บ้านต้อน', '0475', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04242', 'พระบาทนาสิงห์', '0475', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04243', 'โพนแพง', '0475', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04244', 'โพธิ์ตาก', '0476', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04245', 'โพนทอง', '0476', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04246', 'ด่านศรีสุข', '0476', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04247', 'ตลาด', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04248', 'เขวา', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04249', 'ท่าตูม', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04250', 'แวงน่าง', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04251', 'โคกก่อ', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04252', 'ดอนหว่าน', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04253', 'เกิ้ง', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04254', 'แก่งเลิงจาน', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04255', 'ท่าสองคอน', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04256', 'ลาดพัฒนา', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04257', 'หนองปลิง', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04258', 'ห้วยแอ่ง', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04259', 'หนองโน', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04260', 'บัวค้อ', '0477', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04261', 'แกดำ', '0478', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04262', 'วังแสง', '0478', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04263', 'มิตรภาพ', '0478', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04264', 'หนองกุง', '0478', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04265', 'โนนภิบาล', '0478', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04266', 'หัวขวาง', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04267', 'ยางน้อย', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04268', 'วังยาว', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04269', 'เขวาไร่', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04270', 'แพง', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04271', 'แก้งแก', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04272', 'หนองเหล็ก', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04273', 'หนองบัว', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04274', 'เหล่า', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04275', 'เขื่อน', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04276', 'หนองบอน', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04277', 'โพนงาม', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04278', 'ยางท่าแจ้ง', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04279', 'แห่ใต้', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04280', 'หนองกุงสวรรค์', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04281', 'เลิงใต้', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04282', 'ดอนกลาง', '0479', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04283', 'โคกพระ', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04284', 'คันธารราษฎร์', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04285', 'มะค่า', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04286', 'ท่าขอนยาง', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04287', 'นาสีนวน', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04288', 'ขามเรียง', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04289', 'เขวาใหญ่', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04290', 'ศรีสุข', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04291', 'กุดใส้จ่อ', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04292', 'ขามเฒ่าพัฒนา', '0480', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04293', 'เชียงยืน', '0481', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04294', 'ชื่นชม', '0481', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04295', 'หนองซอน', '0481', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04296', 'เหล่าดอกไม้', '0481', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04297', 'ดอนเงิน', '0481', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04298', 'กู่ทอง', '0481', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04299', 'นาทอง', '0481', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04300', 'เสือเฒ่า', '0481', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04301', 'กุดปลาดุก', '0481', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04302', 'หนองกุง', '0481', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04303', 'โพนทอง', '0481', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04304', 'เหล่าบัวบาน', '0481', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04305', 'บรบือ', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04306', 'บ่อใหญ่', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04307', 'กุดรัง', '0482', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04308', 'วังไชย', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04309', 'หนองม่วง', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04310', 'กำพี้', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04311', 'โนนราษี', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04312', 'โนนแดง', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04313', 'เลิงแฝก', '0482', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04314', 'หนองจิก', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04315', 'บัวมาศ', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04316', 'นาโพธิ์', '0482', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04317', 'หนองคูขาด', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04318', 'หนองแวง', '0482', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04319', 'วังใหม่', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04320', 'ยาง', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04321', 'ห้วยเตย', '0482', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04322', 'หนองสิม', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04323', 'หนองโก', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04324', 'ดอนงัว', '0482', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04325', 'นาเชือก', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04326', 'สำโรง', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04327', 'หนองแดง', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04328', 'เขวาไร่', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04329', 'หนองโพธิ์', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04330', 'ปอพาน', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04331', 'หนองเม็ก', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04332', 'หนองเรือ', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04333', 'หนองกุง', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04334', 'สันป่าตอง', '0483', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04335', 'ปะหลาน', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04336', 'ก้ามปู', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04337', 'เวียงสะอาด', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04338', 'เม็กดำ', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04339', 'นาสีนวล', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04340', 'ดงเมือง', '0484', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04341', 'แวงดง', '0484', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04342', 'ขามเรียน', '0484', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04343', 'ราษฎร์เจริญ', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04344', 'หนองบัวแก้ว', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04345', 'นาภู', '0484', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04346', 'เมืองเตา', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04347', 'บ้านกู่', '0484', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04348', 'ยางสีสุราช', '0484', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04349', 'ลานสะแก', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04350', 'เวียงชัย', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04351', 'หนองบัว', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04352', 'ราษฎร์พัฒนา', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04353', 'เมืองเสือ', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04354', 'ภารแอ่น', '0484', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04355', 'หนองแสง', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04356', 'ขามป้อม', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04357', 'เสือโก้ก', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04358', 'ดงใหญ่', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04359', 'โพธิ์ชัย', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04360', 'หัวเรือ', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04361', 'แคน', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04362', 'งัวบา', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04363', 'นาข่า', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04364', 'บ้านหวาย', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04365', 'หนองไฮ', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04366', 'ประชาพัฒนา', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04367', 'หนองทุ่ม', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04368', 'หนองแสน', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04369', 'โคกสีทองหลาง', '0485', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04370', 'หนองไผ่', '0485', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04371', 'นาดูน', '0485', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04372', 'หนองคู', '0485', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04373', 'นาดูน', '0486', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04374', 'หนองไผ่', '0486', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04375', 'หนองคู', '0486', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04376', 'ดงบัง', '0486', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04377', 'ดงดวน', '0486', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04378', 'หัวดง', '0486', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04379', 'ดงยาง', '0486', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04380', 'กู่สันตรัตน์', '0486', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04381', 'พระธาตุ', '0486', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04382', 'ยางสีสุราช', '0487', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04383', 'นาภู', '0487', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04384', 'แวงดง', '0487', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04385', 'บ้านกู่', '0487', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04386', 'ดงเมือง', '0487', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04387', 'ขามเรียน', '0487', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04388', 'หนองบัวสันตุ', '0487', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04389', 'กุดรัง', '0488', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04390', 'นาโพธิ์', '0488', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04391', 'เลิงแฝก', '0488', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04392', 'หนองแวง', '0488', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04393', 'ห้วยเตย', '0488', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04394', 'ชื่นชม', '0489', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04395', 'กุดปลาดุก', '0489', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04396', 'เหล่าดอกไม้', '0489', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04397', 'หนองกุง', '0489', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04398', 'ในเมือง', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04399', 'รอบเมือง', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04400', 'เหนือเมือง', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04401', 'ขอนแก่น', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04402', 'นาโพธิ์', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04403', 'สะอาดสมบูรณ์', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04404', 'ปาฝา', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04405', 'สีแก้ว', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04406', 'ปอภาร  (ปอพาน)', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04407', 'โนนรัง', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04408', 'ดงสิงห์', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04409', 'สวนจิก', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04410', 'ม่วงลาด', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04411', 'โพธิ์ทอง', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04412', 'จังหาร', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04413', 'ดินดำ', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04414', 'หนองแก้ว', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04415', 'หนองแวง', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04416', 'ศรีสมเด็จ', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04417', 'ดงลาน', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04418', 'หนองใหญ่', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04419', 'เมืองเปลือย', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04420', 'แคนใหญ่', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04421', 'โนนตาล', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04422', 'เมืองทอง', '0491', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04423', 'ดงสิงห์', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04424', 'จังหาร', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04425', 'ม่วงลาด', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04426', 'ปาฝา', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04427', 'ดินดำ', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04428', 'สวนจิก', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04429', 'เมืองเปลือย', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04430', 'ศรีสมเด็จ', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04431', 'โพธิ์ทอง', '0491', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04432', 'เกษตรวิสัย', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04433', 'เมืองบัว', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04434', 'เหล่าหลวง', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04435', 'สิงห์โคก', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04436', 'ดงครั่งใหญ่', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04437', 'บ้านฝาง', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04438', 'หนองแวง', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04439', 'กำแพง', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04440', 'กู่กาสิงห์', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04441', 'น้ำอ้อม', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04442', 'โนนสว่าง', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04443', 'ทุ่งทอง', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04444', 'ดงครั่งน้อย', '0492', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04445', 'บัวแดง', '0493', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04446', 'ดอกล้ำ', '0493', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04447', 'หนองแคน', '0493', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04448', 'โพนสูง', '0493', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04449', 'โนนสวรรค์', '0493', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04450', 'สระบัว', '0493', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04451', 'โนนสง่า', '0493', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04452', 'ขี้เหล็ก', '0493', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04453', 'หัวช้าง', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04454', 'หนองผือ', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04455', 'เมืองหงส์', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04456', 'โคกล่าม', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04457', 'น้ำใส', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04458', 'ดงแดง', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04459', 'ดงกลาง', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04460', 'ป่าสังข์', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04461', 'อีง่อง', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04462', 'ลิ้นฟ้า', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04463', 'ดู่น้อย', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04464', 'ศรีโคตร', '0494', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04465', 'นิเวศน์', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04466', 'ธงธานี', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04467', 'หนองไผ่', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04468', 'ธวัชบุรี', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04469', 'หมูม้น', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04470', 'อุ่มเม้า', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04471', 'มะอึ', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04472', 'เหล่า', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04473', 'มะบ้า', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04474', 'เขวาทุ่ง', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04475', 'พระธาตุ', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04476', 'บึงงาม', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04477', 'บ้านเขือง', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04478', 'พระเจ้า', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04479', 'ไพศาล', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04480', 'เทอดไทย', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04481', 'เมืองน้อย', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04482', 'โนนศิลา', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04483', 'เชียงขวัญ', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04484', 'บึงนคร', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04485', 'พลับพลา', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04486', 'ราชธานี', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04487', 'ทุ่งเขาหลวง', '0495', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04488', 'หนองพอก', '0495', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04489', 'พนมไพร', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04490', 'แสนสุข', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04491', 'กุดน้ำใส', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04492', 'หนองทัพไทย', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04493', 'โพธิ์ใหญ่', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04494', 'วารีสวัสดิ์', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04495', 'โคกสว่าง', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04496', 'หนองฮี', '0496', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04497', 'เด่นราษฎร์', '0496', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04498', 'ดูกอึ่ง', '0496', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04499', 'โพธิ์ชัย', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04500', 'นานวล', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04501', 'คำไฮ', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04502', 'สระแก้ว', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04503', 'ค้อใหญ่', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04504', 'สาวแห', '0496', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04505', 'ชานุวรรณ', '0496', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04506', 'แวง', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04507', 'โคกกกม่วง', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04508', 'นาอุดม', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04509', 'สว่าง', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04510', 'หนองใหญ่', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04511', 'โพธิ์ทอง', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04512', 'โนนชัยศรี', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04513', 'โพธิ์ศรีสว่าง', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04514', 'อุ่มเม่า', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04515', 'คำนาดี', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04516', 'พรมสวรรค์', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04517', 'สระนกแก้ว', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04518', 'วังสามัคคี', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04519', 'โคกสูง', '0497', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04520', 'ชุมพร', '0497', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04521', 'เมยวดี', '0497', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04522', 'คำพอง', '0497', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04523', 'อัคคะคำ', '0497', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04524', 'เชียงใหม่', '0497', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04525', 'ขามเบี้ย', '0497', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04526', 'ขามเปี้ย', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04527', 'เชียงใหม่', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04528', 'บัวคำ', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04529', 'อัคคะคำ', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04530', 'สะอาด', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04531', 'คำพอุง', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04532', 'หนองตาไก้', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04533', 'ดอนโอง', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04534', 'โพธิ์ศรี', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04535', 'หนองพอก', '0499', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04536', 'บึงงาม', '0499', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04537', 'ภูเขาทอง', '0499', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04538', 'กกโพธิ์', '0499', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04539', 'โคกสว่าง', '0499', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04540', 'หนองขุ่นใหญ่', '0499', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04541', 'รอบเมือง', '0499', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04542', 'ผาน้ำย้อย', '0499', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04543', 'ท่าสีดา', '0499', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04544', 'กลาง', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04545', 'นางาม', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04546', 'เมืองไพร', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04547', 'นาแซง', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04548', 'นาเมือง', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04549', 'วังหลวง', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04550', 'ท่าม่วง', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04551', 'ขวาว', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04552', 'โพธิ์ทอง', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04553', 'ภูเงิน', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04554', 'เกาะแก้ว', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04555', 'นาเลิง', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04556', 'เหล่าน้อย', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04557', 'ศรีวิลัย', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04558', 'หนองหลวง', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04559', 'พรสวรรค์', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04560', 'ขวัญเมือง', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04561', 'บึงเกลือ', '0500', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04562', 'สระคู', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04563', 'ดอกไม้', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04564', 'นาใหญ่', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04565', 'หินกอง', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04566', 'เมืองทุ่ง', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04567', 'หัวโทน', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04568', 'บ่อพันขัน', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04569', 'ทุ่งหลวง', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04570', 'หัวช้าง', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04571', 'น้ำคำ', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04572', 'ห้วยหินลาด', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04573', 'ช้างเผือก', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04574', 'ทุ่งกุลา', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04575', 'ทุ่งศรีเมือง', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04576', 'จำปาขัน', '0501', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04577', 'หนองผือ', '0502', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04578', 'หนองหิน', '0502', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04579', 'คูเมือง', '0502', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04580', 'กกกุง', '0502', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04581', 'เมืองสรวง', '0502', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04582', 'โพนทราย', '0503', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04583', 'สามขา', '0503', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04584', 'ศรีสว่าง', '0503', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04585', 'ยางคำ', '0503', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04586', 'ท่าหาดยาว', '0503', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04587', 'อาจสามารถ', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04588', 'โพนเมือง', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04589', 'บ้านแจ้ง', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04590', 'หน่อม', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04591', 'หนองหมื่นถ่าน', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04592', 'หนองขาม', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04593', 'โหรา', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04594', 'หนองบัว', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04595', 'ขี้เหล็ก', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04596', 'บ้านดู่', '0504', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04597', 'เมยวดี', '0505', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04598', 'ชุมพร', '0505', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04599', 'บุ่งเลิศ', '0505', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04600', 'ชมสะอาด', '0505', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04601', 'โพธิ์ทอง', '0506', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04602', 'ศรีสมเด็จ', '0506', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04603', 'เมืองเปลือย', '0506', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04604', 'หนองใหญ่', '0506', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04605', 'สวนจิก', '0506', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04606', 'โพธิ์สัย', '0506', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04607', 'หนองแวงควง', '0506', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04608', 'บ้านบาก', '0506', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04609', 'ดินดำ', '0507', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04610', 'ปาฝา', '0507', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04611', 'ม่วงลาด', '0507', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04612', 'จังหาร', '0507', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04613', 'ดงสิงห์', '0507', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04614', 'ยางใหญ่', '0507', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04615', 'ผักแว่น', '0507', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04616', 'แสนชาติ', '0507', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04617', 'เชียงขวัญ', '0508', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04618', 'พลับพลา', '0508', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04619', 'พระธาตุ', '0508', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04620', 'พระเจ้า', '0508', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04621', 'หมูม้น', '0508', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04622', 'บ้านเขือง', '0508', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04623', 'หนองฮี', '0509', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04624', 'สาวแห', '0509', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04625', 'ดูกอึ่ง', '0509', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04626', 'เด่นราษฎร์', '0509', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04627', 'ทุ่งเขาหลวง', '0510', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04628', 'เทอดไทย', '0510', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04629', 'บึงงาม', '0510', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04630', 'มะบ้า', '0510', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04631', 'เหล่า', '0510', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04632', 'กาฬสินธุ์', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04633', 'เหนือ', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04634', 'หลุบ', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04635', 'ไผ่', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04636', 'ลำปาว', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04637', 'ลำพาน', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04638', 'เชียงเครือ', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04639', 'บึงวิชัย', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04640', 'ห้วยโพธิ์', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04641', 'ม่วงนา', '0511', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04642', 'ภูปอ', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04643', 'ดงพยุง', '0511', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04644', 'ภูดิน', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04645', 'ดอนจาน', '0511', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04646', 'หนองกุง', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04647', 'กลางหมื่น', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04648', 'ขมิ้น', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04649', 'นาจำปา', '0511', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04650', 'โพนทอง', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04651', 'นาจารย์', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04652', 'ลำคลอง', '0511', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04653', 'สะอาดไชยศรี', '0511', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04654', 'นามน', '0511', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04655', 'ยอดแกง', '0511', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04656', 'นามน', '0512', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04657', 'ยอดแกง', '0512', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04658', 'สงเปลือย', '0512', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04659', 'หลักเหลี่ยม', '0512', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04660', 'หนองบัว', '0512', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04661', 'กมลาไสย', '0513', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04662', 'หลักเมือง', '0513', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04663', 'โพนงาม', '0513', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04664', 'ดงลิง', '0513', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04665', 'ธัญญา', '0513', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04666', 'กุดฆ้องชัย', '0513', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04667', 'ลำชี', '0513', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04668', 'หนองแปน', '0513', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04669', 'โคกสะอาด', '0513', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04670', 'เจ้าท่า', '0513', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04671', 'โคกสมบูรณ์', '0513', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04672', 'โนนศิลา', '0513', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04673', 'ฆ้องชัยพัฒนา', '0513', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04674', 'ร่องคำ', '0514', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04675', 'สามัคคี', '0514', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04676', 'เหล่าอ้อย', '0514', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04677', 'บัวขาว', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04678', 'แจนแลน', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04679', 'เหล่าใหญ่', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04680', 'จุมจัง', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04681', 'เหล่าไฮงาม', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04682', 'กุดหว้า', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04683', 'สามขา', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04684', 'นาขาม', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04685', 'หนองห้าง', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04686', 'นาโก', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04687', 'สมสะอาด', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04688', 'กุดค้าว', '0515', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04689', 'คุ้มเก่า', '0516', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04690', 'สงเปลือย', '0516', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04691', 'หนองผือ', '0516', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04692', 'ภูแล่นช้าง', '0516', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04693', 'นาคู', '0516', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04694', 'กุดสิมคุ้มใหม่', '0516', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04695', 'บ่อแก้ว', '0516', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04696', 'สระพังทอง', '0516', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04697', 'สายนาวัง', '0516', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04698', 'โนนนาจาน', '0516', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04699', 'กุดปลาค้าว', '0516', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04700', 'ยางตลาด', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04701', 'หัวงัว', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04702', 'อุ่มเม่า', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04703', 'บัวบาน', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04704', 'เว่อ', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04705', 'อิตื้อ', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04706', 'หัวนาคำ', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04707', 'หนองอิเฒ่า', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04708', 'ดอนสมบูรณ์', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04709', 'นาเชือก', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04710', 'คลองขาม', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04711', 'เขาพระนอน', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04712', 'นาดี', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04713', 'โนนสูง', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04714', 'หนองตอกแป้น', '0517', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04715', 'ห้วยเม็ก', '0518', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04716', 'คำใหญ่', '0518', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04717', 'กุดโดน', '0518', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04718', 'บึงนาเรียง', '0518', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04719', 'หัวหิน', '0518', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04720', 'พิมูล', '0518', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04721', 'คำเหมือดแก้ว', '0518', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04722', 'โนนสะอาด', '0518', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04723', 'ทรายทอง', '0518', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04724', 'ภูสิงห์', '0519', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04725', 'สหัสขันธ์', '0519', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04726', 'นามะเขือ', '0519', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04727', 'โนนศิลา', '0519', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04728', 'นิคม', '0519', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04729', 'โนนแหลมทอง', '0519', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04730', 'โนนบุรี', '0519', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04731', 'โนนน้ำเกลี้ยง', '0519', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04732', 'หนองบัว', '0519', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04733', 'ทุ่งคลอง', '0519', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04734', 'สำราญ', '0519', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04735', 'โพน', '0519', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04736', 'ทุ่งคลอง', '0520', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04737', 'โพน', '0520', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04738', 'สำราญ', '0520', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04739', 'สำราญใต้', '0520', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04740', 'ดินจี่', '0520', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04741', 'นาบอน', '0520', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04742', 'นาทัน', '0520', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04743', 'คำสร้างเที่ยง', '0520', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04744', 'เนินยาง', '0520', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04745', 'หนองช้าง', '0520', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04746', 'ท่าคันโท', '0521', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04747', 'กุงเก่า', '0521', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04748', 'ยางอู้ม', '0521', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04749', 'กุดจิก', '0521', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04750', 'นาตาล', '0521', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04751', 'ดงสมบูรณ์', '0521', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04752', 'โคกเครือ', '0521', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04753', 'สหัสขันธ์', '0521', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04754', 'หนองกุงศรี', '0522', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04755', 'หนองบัว', '0522', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04756', 'โคกเครือ', '0522', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04757', 'หนองสรวง', '0522', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04758', 'เสาเล้า', '0522', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04759', 'หนองใหญ่', '0522', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04760', 'ดงมูล', '0522', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04761', 'ลำหนองแสน', '0522', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04762', 'หนองหิน', '0522', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04763', 'สมเด็จ', '0523', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04764', 'หนองแวง', '0523', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04765', 'แซงบาดาล', '0523', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04766', 'มหาไชย', '0523', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04767', 'หมูม่น', '0523', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04768', 'ผาเสวย', '0523', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04769', 'ศรีสมเด็จ', '0523', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04770', 'ลำห้วยหลัว', '0523', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04771', 'คำบง', '0524', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04772', 'ไค้นุ่น', '0524', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04773', 'นิคมห้วยผึ้ง', '0524', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04774', 'หนองอีบุตร', '0524', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04775', 'สำราญ', '0525', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04776', 'สำราญใต้', '0525', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04777', 'คำสร้างเที่ยง', '0525', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04778', 'หนองช้าง', '0525', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04779', 'นาคู', '0526', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04780', 'สายนาวัง', '0526', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04781', 'โนนนาจาน', '0526', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04782', 'บ่อแก้ว', '0526', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04783', 'ภูแล่นช้าง', '0526', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04784', 'ดอนจาน', '0527', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04785', 'สะอาดไชยศรี', '0527', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04786', 'ดงพยุง', '0527', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04787', 'ม่วงนา', '0527', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04788', 'นาจำปา', '0527', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04789', 'ฆ้องชัยพัฒนา', '0528', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04790', 'เหล่ากลาง', '0528', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04791', 'โคกสะอาด', '0528', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04792', 'โนนศิลาเลิง', '0528', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04793', 'ลำชี', '0528', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04794', 'ธาตุเชิงชุม', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04795', 'ขมิ้น', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04796', 'งิ้วด่อน', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04797', 'โนนหอม', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04798', 'นาตงวัฒนา', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04799', 'เชียงเครือ', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04800', 'ท่าแร่', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04801', 'บ้านโพน', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04802', 'ม่วงลาย', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04803', 'กกปลาซิว', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04804', 'ดงชน', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04805', 'ห้วยยาง', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04806', 'พังขว้าง', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04807', 'นาแก้ว', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04808', 'ดงมะไฟ', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04809', 'ธาตุนาเวง', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04810', 'เหล่าปอแดง', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04811', 'หนองลาด', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04812', 'บ้านแป้น', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04813', 'ฮางโฮง', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04814', 'โคกก่อง', '0529', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04815', 'นาตงวัฒนา', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04816', 'นาแก้ว', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04817', 'บ้านโพน', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04818', 'เหล่าโพนค้อ', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04819', 'ตองโขบ', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04820', 'เต่างอย', '0529', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04821', 'กุสุมาลย์', '0530', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04822', 'นาโพธิ์', '0530', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04823', 'นาเพียง', '0530', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04824', 'โพธิไพศาล', '0530', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04825', 'อุ่มจาน', '0530', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04826', 'กุดบาก', '0531', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04827', 'โคกภู', '0531', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04828', 'นาม่อง', '0531', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04829', 'สร้างค้อ', '0531', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04830', 'กุดไห', '0531', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04831', 'หลุบเลา', '0531', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04832', 'พรรณา', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04833', 'วังยาง', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04834', 'พอกน้อย', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04835', 'นาหัวบ่อ', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04836', 'ไร่', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04837', 'ช้างมิ่ง', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04838', 'นาใน', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04839', 'สว่าง', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04840', 'บะฮี', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04841', 'เชิงชุม', '0532', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04842', 'พังโคน', '0533', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04843', 'ม่วงไข่', '0533', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04844', 'แร่', '0533', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04845', 'ไฮหย่อง', '0533', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04846', 'ต้นผึ้ง', '0533', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04847', 'คลองกระจัง', '0533', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04848', 'สระกรวด', '0533', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04849', 'วาริชภูมิ', '0534', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04850', 'ปลาโหล', '0534', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04851', 'หนองลาด', '0534', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04852', 'คำบ่อ', '0534', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04853', 'ค้อเขียว', '0534', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04854', 'นิคมน้ำอูน', '0535', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04855', 'หนองปลิง', '0535', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04856', 'หนองบัว', '0535', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04857', 'สุวรรณคาม', '0535', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04858', 'วานรนิวาส', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04859', 'เดื่อศรีคันไชย', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04860', 'ขัวก่าย', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04861', 'หนองสนม', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04862', 'คูสะคาม', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04863', 'ธาตุ', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04864', 'หนองแวง', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04865', 'ศรีวิชัย', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04866', 'นาซอ', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04867', 'อินทร์แปลง', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04868', 'นาคำ', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04869', 'คอนสวรรค์', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04870', 'กุดเรือคำ', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04871', 'หนองแวงใต้', '0536', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04872', 'คำตากล้า', '0537', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04873', 'หนองบัวสิม', '0537', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04874', 'นาแต้', '0537', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04875', 'แพด', '0537', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04876', 'ม่วง', '0538', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04877', 'มาย', '0538', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04878', 'ดงหม้อทอง', '0538', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04879', 'ดงเหนือ', '0538', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04880', 'ดงหม้อทองใต้', '0538', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04881', 'ห้วยหลัว', '0538', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04882', 'โนนสะอาด', '0538', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04883', 'หนองกวั่ง', '0538', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04884', 'บ่อแก้ว', '0538', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04885', 'อากาศ', '0539', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04886', 'โพนแพง', '0539', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04887', 'วาใหญ่', '0539', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04888', 'โพนงาม', '0539', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04889', 'ท่าก้อน', '0539', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04890', 'นาฮี', '0539', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04891', 'บะหว้า', '0539', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04892', 'สามัคคีพัฒนา', '0539', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04893', 'สว่างแดนดิน', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04894', 'บ้านเหล่า', '0540', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04895', 'คำสะอาด', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04896', 'บ้านต้าย', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04897', 'เจริญศิลป์', '0540', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04898', 'บงเหนือ', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04899', 'โพนสูง', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04900', 'โคกสี', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04901', 'ทุ่งแก', '0540', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04902', 'หนองหลวง', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04903', 'บงใต้', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04904', 'ค้อใต้', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04905', 'พันนา', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04906', 'แวง', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04907', 'ทรายมูล', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04908', 'ตาลโกน', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04909', 'ตาลเนิ้ง', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04910', 'โคกศิลา', '0540', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04911', 'หนองแปน', '0540', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04912', 'ธาตุทอง', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04913', 'บ้านถ่อน', '0540', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04914', 'ส่องดาว', '0541', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04915', 'ท่าศิลา', '0541', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04916', 'วัฒนา', '0541', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04917', 'ปทุมวาปี', '0541', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04918', 'เต่างอย', '0542', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04919', 'บึงทวาย', '0542', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04920', 'นาตาล', '0542', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04921', 'จันทร์เพ็ญ', '0542', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04922', 'ตองโขบ', '0543', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04923', 'เหล่าโพนค้อ', '0543', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04924', 'ด่านม่วงคำ', '0543', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04925', 'แมดนาท่ม', '0543', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04926', 'บ้านเหล่า', '0544', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04927', 'เจริญศิลป์', '0544', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04928', 'ทุ่งแก', '0544', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04929', 'โคกศิลา', '0544', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04930', 'หนองแปน', '0544', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04931', 'บ้านโพน', '0545', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04932', 'นาแก้ว', '0545', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04933', 'นาตงวัฒนา', '0545', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04934', 'บ้านแป้น', '0545', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04935', 'เชียงสือ', '0545', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04936', 'สร้างค้อ', '0546', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04937', 'หลุบเลา', '0546', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04938', 'โคกภู', '0546', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04939', 'กกปลาซิว', '0546', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04940', 'ในเมือง', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04941', 'หนองแสง', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04942', 'นาทราย', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04943', 'นาราชควาย', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04944', 'กุรุคุ', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04945', 'บ้านผึ้ง', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04946', 'อาจสามารถ', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04947', 'ขามเฒ่า', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04948', 'บ้านกลาง', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04949', 'ท่าค้อ', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04950', 'คำเตย', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04951', 'หนองญาติ', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04952', 'ดงขวาง', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04953', 'วังตามัว', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04954', 'โพธิ์ตาก', '0549', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04955', 'ปลาปาก', '0550', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04956', 'หนองฮี', '0550', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04957', 'กุตาไก้', '0550', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04958', 'โคกสว่าง', '0550', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04959', 'โคกสูง', '0550', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04960', 'มหาชัย', '0550', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04961', 'นามะเขือ', '0550', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04962', 'หนองเทาใหญ่', '0550', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04963', 'ท่าอุเทน', '0551', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04964', 'โนนตาล', '0551', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04965', 'ท่าจำปา', '0551', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04966', 'ไชยบุรี', '0551', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04967', 'พนอม', '0551', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04968', 'พะทาย', '0551', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04969', 'นาขมิ้น', '0551', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04970', 'โพนบก', '0551', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04971', 'โพนสวรรค์', '0551', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04972', 'บ้านค้อ', '0551', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04973', 'เวินพระบาท', '0551', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04974', 'รามราช', '0551', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04975', 'นาหัวบ่อ', '0551', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04976', 'หนองเทา', '0551', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04977', 'บ้านแพง', '0552', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04978', 'ไผ่ล้อม', '0552', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04979', 'โพนทอง', '0552', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04980', 'หนองแวง', '0552', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04981', 'นาทม', '0552', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04982', 'หนองซน', '0552', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04983', 'ดอนเตย', '0552', -1 )
INSERT INTO tbm_sub_district
VALUES
( '04984', 'นางัว', '0552', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04985', 'นาเข', '0552', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04986', 'ธาตุพนม', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04987', 'ฝั่งแดง', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04988', 'โพนแพง', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04989', 'พระกลางทุ่ง', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04990', 'นาถ่อน', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04991', 'แสนพัน', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04992', 'ดอนนางหงส์', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04993', 'น้ำก่ำ', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04994', 'อุ่มเหม้า', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04995', 'นาหนาด', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04996', 'กุดฉิม', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04997', 'ธาตุพนมเหนือ', '0553', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04998', 'เรณู', '0554', 1 )
INSERT INTO tbm_sub_district
VALUES
( '04999', 'โพนทอง', '0554', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05000', 'ท่าลาด', '0554', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05001', 'นางาม', '0554', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05002', 'โคกหินแฮ่', '0554', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05003', 'เรณูนคร', '0554', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05004', 'หนองย่างชิ้น', '0554', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05005', 'เรณูใต้', '0554', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05006', 'นาขาม', '0554', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05007', 'นาแก', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05008', 'พระซอง', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05009', 'หนองสังข์', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05010', 'นาคู่', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05011', 'พิมาน', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05012', 'พุ่มแก', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05013', 'ก้านเหลือง', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05014', 'หนองบ่อ', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05015', 'นาเลียง', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05016', 'โคกสี', '0555', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05017', 'วังยาง', '0555', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05018', 'บ้านแก้ง', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05019', 'คำพี้', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05020', 'ยอดชาด', '0555', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05021', 'สีชมพู', '0555', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05022', 'หนองโพธิ์', '0555', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05023', 'ศรีสงคราม', '0556', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05024', 'นาเดื่อ', '0556', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05025', 'บ้านเอื้อง', '0556', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05026', 'สามผง', '0556', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05027', 'ท่าบ่อสงคราม', '0556', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05028', 'บ้านข่า', '0556', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05029', 'นาคำ', '0556', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05030', 'โพนสว่าง', '0556', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05031', 'หาดแพง', '0556', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05032', 'นาหว้า', '0557', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05033', 'นางัว', '0557', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05034', 'บ้านเสียว', '0557', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05035', 'นาคูณใหญ่', '0557', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05036', 'เหล่าพัฒนา', '0557', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05037', 'ท่าเรือ', '0557', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05038', 'โพนสวรรค์', '0558', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05039', 'นาหัวบ่อ', '0558', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05040', 'นาขมิ้น', '0558', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05041', 'โพนบก', '0558', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05042', 'บ้านค้อ', '0558', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05043', 'โพนจาน', '0558', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05044', 'นาใน', '0558', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05045', 'นาทม', '0559', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05046', 'หนองซน', '0559', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05047', 'ดอนเตย', '0559', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05048', 'วังยาง', '0560', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05049', 'โคกสี', '0560', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05050', 'ยอดชาด', '0560', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05051', 'หนองโพธิ์', '0560', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05052', 'มุกดาหาร', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05053', 'ศรีบุญเรือง', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05054', 'บ้านโคก', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05055', 'บางทรายใหญ่', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05056', 'โพนทราย', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05057', 'ผึ่งแดด', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05058', 'นาโสก', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05059', 'นาสีนวน', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05060', 'คำป่าหลาย', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05061', 'คำอาฮวน', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05062', 'ดงเย็น', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05063', 'ดงมอน', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05064', 'กุดแข้', '0561', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05065', 'หนองแวง', '0561', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05066', 'กกแดง', '0561', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05067', 'นากอก', '0561', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05068', 'นำคมคำสร้อย', '0561', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05069', 'บางทรายน้อย', '0561', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05070', 'หว้านใหญ่', '0561', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05071', 'นิคมคำสร้อย', '0562', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05072', 'นากอก', '0562', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05073', 'หนองแวง', '0562', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05074', 'กกแดง', '0562', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05075', 'นาอุดม', '0562', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05076', 'โชคชัย', '0562', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05077', 'ร่มเกล้า', '0562', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05078', 'ดอนตาล', '0563', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05079', 'โพธิ์ไทร', '0563', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05080', 'ป่าไร่', '0563', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05081', 'เหล่าหมี', '0563', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05082', 'บ้านบาก', '0563', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05083', 'นาสะเม็ง', '0563', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05084', 'บ้านแก้ง', '0563', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05085', 'ดงหลวง', '0564', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05086', 'หนองบัว', '0564', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05087', 'กกตูม', '0564', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05088', 'หนองแคน', '0564', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05089', 'ชะโนดน้อย', '0564', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05090', 'พังแดง', '0564', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05091', 'หนองสูงใต้', '0565', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05092', 'หนองสูง', '0565', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05093', 'บ้านซ่ง', '0565', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05094', 'คำชะอี', '0565', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05095', 'หนองเอี่ยน', '0565', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05096', 'บ้านค้อ', '0565', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05097', 'บ้านเหล่า', '0565', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05098', 'โพนงาม', '0565', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05099', 'โนนยาง', '0565', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05100', 'บ้านเป้า', '0565', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05101', 'เหล่าสร้างถ่อ', '0565', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05102', 'คำบก', '0565', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05103', 'ภูวง', '0565', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05104', 'น้ำเที่ยง', '0565', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05105', 'หนองสูงใต้', '0565', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05106', 'บ้านเป้า', '0565', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05107', 'หนองสูง', '0565', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05108', 'หว้านใหญ่', '0566', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05109', 'ป่งขาม', '0566', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05110', 'บางทรายน้อย', '0566', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05111', 'ชะโนด', '0566', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05112', 'ดงหมู', '0566', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05113', 'หนองสูง', '0567', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05114', 'โนนยาง', '0567', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05115', 'ภูวง', '0567', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05116', 'บ้านเป้า', '0567', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05117', 'หนองสูงใต้', '0567', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05118', 'หนองสูงเหนือ', '0567', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05119', 'ศรีภูมิ', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05120', 'พระสิงห์', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05121', 'หายยา', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05122', 'ช้างม่อย', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05123', 'ช้างคลาน', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05124', 'วัดเกต', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05125', 'ช้างเผือก', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05126', 'สุเทพ', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05127', 'แม่เหียะ', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05128', 'ป่าแดด', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05129', 'หนองหอย', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05130', 'ท่าศาลา', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05131', 'หนองป่าครั่ง', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05132', 'ฟ้าฮ่าม', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05133', 'ป่าตัน', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05134', 'สันผีเสื้อ', '0568', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05135', 'ยางคราม', '0569', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05136', 'สองแคว', '0569', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05137', 'บ้านหลวง', '0569', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05138', 'ข่วงเปา', '0569', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05139', 'สบเตี๊ยะ', '0569', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05140', 'บ้านแปะ', '0569', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05141', 'ดอยแก้ว', '0569', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05142', 'ดอยหล่อ', '0569', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05143', 'แม่สอย', '0569', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05144', 'สันติสุข', '0569', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05145', 'ช่างเคิ่ง', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05146', 'ท่าผา', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05147', 'บ้านทับ', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05148', 'แม่ศึก', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05149', 'แม่นาจร', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05150', 'บ้านจันทร์', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05151', 'ปางหินฝน', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05152', 'กองแขก', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05153', 'แม่แดด', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05154', 'แจ่มหลวง', '0570', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05155', 'เชียงดาว', '0571', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05156', 'เมืองนะ', '0571', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05157', 'เมืองงาย', '0571', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05158', 'แม่นะ', '0571', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05159', 'เมืองคอง', '0571', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05160', 'ปิงโค้ง', '0571', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05161', 'ทุ่งข้าวพวง', '0571', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05162', 'เชิงดอย', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05163', 'สันปูเลย', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05164', 'ลวงเหนือ', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05165', 'ป่าป้อง', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05166', 'สง่าบ้าน', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05167', 'ป่าลาน', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05168', 'ตลาดขวัญ', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05169', 'สำราญราษฎร์', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05170', 'แม่คือ', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05171', 'ตลาดใหญ่', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05172', 'แม่ฮ้อยเงิน', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05173', 'แม่โป่ง', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05174', 'ป่าเมี่ยง', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05175', 'เทพเสด็จ', '0572', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05176', 'สันมหาพน', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05177', 'แม่แตง', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05178', 'ขี้เหล็ก', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05179', 'ช่อแล', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05180', 'แม่หอพระ', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05181', 'สบเปิง', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05182', 'บ้านเป้า', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05183', 'สันป่ายาง', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05184', 'ป่าแป๋', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05185', 'เมืองก๋าย', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05186', 'บ้านช้าง', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05187', 'กื้ดช้าง', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05188', 'อินทขิล', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05189', 'สมก๋าย', '0573', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05190', 'ริมใต้', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05191', 'ริมเหนือ', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05192', 'สันโป่ง', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05193', 'ขี้เหล็ก', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05194', 'สะลวง', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05195', 'ห้วยทราย', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05196', 'แม่แรม', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05197', 'โป่งแยง', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05198', 'แม่สา', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05199', 'ดอนแก้ว', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05200', 'เหมืองแก้ว', '0574', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05201', 'สะเมิงใต้', '0575', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05202', 'สะเมิงเหนือ', '0575', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05203', 'แม่สาบ', '0575', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05204', 'บ่อแก้ว', '0575', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05205', 'ยั้งเมิน', '0575', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05206', 'เวียง', '0576', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05207', 'ปงตำ', '0576', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05208', 'ม่อนปิ่น', '0576', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05209', 'แม่งอน', '0576', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05210', 'แม่สูน', '0576', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05211', 'สันทราย', '0576', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05212', 'ศรีดงเย็น', '0576', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05213', 'แม่ทะลบ', '0576', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05214', 'หนองบัว', '0576', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05215', 'แม่คะ', '0576', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05216', 'แม่ข่า', '0576', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05217', 'โป่งน้ำร้อน', '0576', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05218', 'แม่นาวาง', '0576', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05219', 'แม่สาว', '0576', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05220', 'แม่อาย', '0576', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05221', 'ศรีดงเย็น', '0576', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05222', 'ปงตำ', '0576', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05223', 'แม่อาย', '0577', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05224', 'แม่สาว', '0577', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05225', 'สันต้นหมื้อ', '0577', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05226', 'แม่นาวาง', '0577', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05227', 'ท่าตอน', '0577', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05228', 'บ้านหลวง', '0577', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05229', 'มะลิกา', '0577', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05230', 'เวียง', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05231', 'ทุ่งหลวง', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05232', 'ป่าตุ้ม', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05233', 'ป่าไหน่', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05234', 'สันทราย', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05235', 'บ้านโป่ง', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05236', 'น้ำแพร่', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05237', 'เขื่อนผาก', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05238', 'แม่แวน', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05239', 'แม่ปั๋ง', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05240', 'โหล่งขอด', '0578', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05241', 'ยุหว่า', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05242', 'สันกลาง', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05243', 'ท่าวังพร้าว', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05244', 'มะขามหลวง', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05245', 'แม่ก๊า', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05246', 'บ้านแม', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05247', 'บ้านกลาง', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05248', 'ทุ่งสะโตก', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05249', 'ทุ่งปี้', '0579', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05250', 'ทุ่งต้อม', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05251', 'บ้านกาด', '0579', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05252', 'แม่วิน', '0579', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05253', 'ทุ่งรวงทอง', '0579', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05254', 'น้ำบ่อหลวง', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05255', 'มะขุนหวาน', '0579', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05256', 'สันกำแพง', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05257', 'ทรายมูล', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05258', 'ร้องวัวแดง', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05259', 'บวกค้าง', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05260', 'แช่ช้าง', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05261', 'ออนใต้', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05262', 'ออนเหนือ', '0580', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05263', 'บ้านสหกรณ์', '0580', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05264', 'ห้วยแก้ว', '0580', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05265', 'แม่ปูคา', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05266', 'ห้วยทราย', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05267', 'ต้นเปา', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05268', 'สันกลาง', '0580', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05269', 'แม่ทา', '0580', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05270', 'ทาเหนือ', '0580', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05271', 'ออนกลาง', '0580', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05272', 'แม่วิน', '0580', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05273', 'ทุ่งปี้', '0580', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05274', 'บ้านกาด', '0580', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05275', 'สันทรายหลวง', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05276', 'สันทรายน้อย', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05277', 'สันพระเนตร', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05278', 'สันนาเม็ง', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05279', 'สันป่าเปา', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05280', 'หนองแหย่ง', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05281', 'หนองจ๊อม', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05282', 'หนองหาร', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05283', 'แม่แฝก', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05284', 'แม่แฝกใหม่', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05285', 'เมืองเล็น', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05286', 'ป่าไผ่', '0581', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05287', 'หางดง', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05288', 'หนองแก๋ว', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05289', 'หารแก้ว', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05290', 'หนองตอง', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05291', 'ขุนคง', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05292', 'สบแม่ข่า', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05293', 'บ้านแหวน', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05294', 'สันผักหวาน', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05295', 'หนองควาย', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05296', 'บ้านปง', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05297', 'น้ำแพร่', '0582', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05298', 'หางดง', '0583', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05299', 'ฮอด', '0583', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05300', 'บ้านตาล', '0583', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05301', 'บ่อหลวง', '0583', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05302', 'บ่อสลี', '0583', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05303', 'นาคอเรือ', '0583', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05304', 'ดอยเต่า', '0584', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05305', 'ท่าเดื่อ', '0584', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05306', 'มืดกา', '0584', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05307', 'บ้านแอ่น', '0584', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05308', 'บงตัน', '0584', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05309', 'โปงทุ่ง', '0584', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05310', 'อมก๋อย', '0585', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05311', 'ยางเปียง', '0585', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05312', 'แม่ตื่น', '0585', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05313', 'ม่อนจอง', '0585', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05314', 'สบโขง', '0585', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05315', 'นาเกียน', '0585', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05316', 'ยางเนิ้ง', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05317', 'สารภี', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05318', 'ชมภู', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05319', 'ไชยสถาน', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05320', 'ขัวมุง', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05321', 'หนองแฝก', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05322', 'หนองผึ้ง', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05323', 'ท่ากว้าง', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05324', 'ดอนแก้ว', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05325', 'ท่าวังตาล', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05326', 'สันทราย', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05327', 'ป่าบง', '0586', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05328', 'เมืองแหง', '0587', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05329', 'เปียงหลวง', '0587', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05330', 'แสนไห', '0587', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05331', 'ปงตำ', '0588', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05332', 'ศรีดงเย็น', '0588', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05333', 'แม่ทะลบ', '0588', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05334', 'หนองบัว', '0588', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05335', 'บ้านกาด', '0589', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05336', 'ทุ่งปี้', '0589', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05337', 'ทุ่งรวงทอง', '0589', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05338', 'แม่วิน', '0589', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05339', 'ดอนเปา', '0589', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05340', 'ออนเหนือ', '0590', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05341', 'ออนกลาง', '0590', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05342', 'บ้านสหกรณ์', '0590', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05343', 'ห้วยแก้ว', '0590', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05344', 'แม่ทา', '0590', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05345', 'ทาเหนือ', '0590', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05346', 'ดอยหล่อ', '0591', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05347', 'สองแคว', '0591', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05348', 'ยางคราม', '0591', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05349', 'สันติสุข', '0591', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05350', 'ในเมือง', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05351', 'เหมืองง่า', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05352', 'อุโมงค์', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05353', 'หนองช้างคืน', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05354', 'ประตูป่า', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05355', 'ริมปิง', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05356', 'ต้นธง', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05357', 'บ้านแป้น', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05358', 'เหมืองจี้', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05359', 'ป่าสัก', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05360', 'เวียงยอง', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05361', 'บ้านกลาง', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05362', 'มะเขือแจ้', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05363', 'บ้านธิ', '0595', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05364', 'ห้วยยาบ', '0595', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05365', 'ศรีบัวบาน', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05366', 'หนองหนาม', '0595', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05367', 'ห้วยยาบ', '0595', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05368', 'บ้านธิ', '0595', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05369', 'ทาปลาดุก', '0596', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05370', 'ทาสบเส้า', '0596', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05371', 'ทากาศ', '0596', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05372', 'ทาขุมเงิน', '0596', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05373', 'ทาทุ่งหลวง', '0596', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05374', 'ทาแม่ลอบ', '0596', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05375', 'บ้านโฮ่ง', '0597', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05376', 'ป่าพลู', '0597', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05377', 'เหล่ายาว', '0597', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05378', 'ศรีเตี้ย', '0597', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05379', 'หนองปลาสะวาย', '0597', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05380', 'ลี้', '0598', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05381', 'แม่ตืน', '0598', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05382', 'นาทราย', '0598', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05383', 'ดงดำ', '0598', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05384', 'ก้อ', '0598', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05385', 'แม่ลาน', '0598', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05386', 'บ้านไผ่', '0598', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05387', 'ป่าไผ่', '0598', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05388', 'ศรีวิชัย', '0598', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05389', 'บ้านปวง', '0598', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05390', 'ทุ่งหัวช้าง', '0598', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05391', 'ทุ่งหัวช้าง', '0599', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05392', 'บ้านปวง', '0599', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05393', 'ตะเคียนปม', '0599', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05394', 'ปากบ่อง', '0600', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05395', 'ป่าซาง', '0600', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05396', 'แม่แรง', '0600', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05397', 'ม่วงน้อย', '0600', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05398', 'บ้านเรือน', '0600', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05399', 'มะกอก', '0600', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05400', 'ท่าตุ้ม', '0600', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05401', 'น้ำดิบ', '0600', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05402', 'วังผาง', '0600', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05403', 'หนองล่อง', '0600', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05404', 'นครเจดีย์', '0600', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05405', 'หนองยวง', '0600', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05406', 'บ้านธิ', '0601', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05407', 'ห้วยยาบ', '0601', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05408', 'หนองล่อง', '0602', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05409', 'หนองยวง', '0602', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05410', 'วังผาง', '0602', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05411', 'เวียงเหนือ', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05412', 'หัวเวียง', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05413', 'สวนดอก', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05414', 'สบตุ๋ย', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05415', 'พระบาท', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05416', 'ชมพู', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05417', 'กล้วยแพะ', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05418', 'ปงแสนทอง', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05419', 'บ้านแลง', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05420', 'บ้านเสด็จ', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05421', 'พิชัย', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05422', 'ทุ่งฝาย', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05423', 'บ้านเอื้อม', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05424', 'บ้านเป้า', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05425', 'บ้านค่า', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05426', 'บ่อแฮ้ว', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05427', 'ต้นธงชัย', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05428', 'นิคมพัฒนา', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05429', 'บุญนาคพัฒนา', '0603', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05430', 'นาสัก', '0603', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05431', 'บ้านดง', '0603', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05432', 'บ้านดง', '0604', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05433', 'นาสัก', '0604', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05434', 'จางเหนือ', '0604', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05435', 'แม่เมาะ', '0604', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05436', 'สบป้าด', '0604', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05437', 'ลำปางหลวง', '0605', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05438', 'นาแก้ว', '0605', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05439', 'ไหล่หิน', '0605', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05440', 'วังพร้าว', '0605', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05441', 'ศาลา', '0605', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05442', 'เกาะคา', '0605', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05443', 'นาแส่ง', '0605', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05444', 'ท่าผา', '0605', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05445', 'ใหม่พัฒนา', '0605', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05446', 'ทุ่งงาม', '0606', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05447', 'เสริมขวา', '0606', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05448', 'เสริมซ้าย', '0606', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05449', 'เสริมกลาง', '0606', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05450', 'หลวงเหนือ', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05451', 'หลวงใต้', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05452', 'บ้านโป่ง', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05453', 'บ้านร้อง', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05454', 'ปงเตา', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05455', 'นาแก', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05456', 'บ้านอ้อน', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05457', 'บ้านแหง', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05458', 'บ้านหวด', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05459', 'แม่ตีบ', '0607', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05460', 'แจ้ห่ม', '0608', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05461', 'บ้านสา', '0608', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05462', 'ปงดอน', '0608', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05463', 'แม่สุก', '0608', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05464', 'เมืองมาย', '0608', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05465', 'ทุ่งผึ้ง', '0608', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05466', 'วิเชตนคร', '0608', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05467', 'แจ้ซ้อน', '0608', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05468', 'ทุ่งกว๋าว', '0608', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05469', 'บ้านขอ', '0608', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05470', 'เมืองปาน', '0608', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05471', 'ทุ่งฮั้ว', '0609', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05472', 'วังเหนือ', '0609', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05473', 'วังใต้', '0609', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05474', 'ร่องเคาะ', '0609', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05475', 'วังทอง', '0609', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05476', 'วังซ้าย', '0609', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05477', 'วังแก้ว', '0609', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05478', 'วังทรายคำ', '0609', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05479', 'ล้อมแรด', '0610', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05480', 'แม่วะ', '0610', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05481', 'แม่ปะ', '0610', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05482', 'แม่มอก', '0610', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05483', 'เวียงมอก', '0610', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05484', 'นาโป่ง', '0610', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05485', 'แม่ถอด', '0610', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05486', 'เถินบุรี', '0610', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05487', 'แม่พริก', '0611', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05488', 'ผาปัง', '0611', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05489', 'แม่ปุ', '0611', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05490', 'พระบาทวังตวง', '0611', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05491', 'แม่ทะ', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05492', 'นาครัว', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05493', 'ป่าตัน', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05494', 'บ้านกิ่ว', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05495', 'บ้านบอม', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05496', 'น้ำโจ้', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05497', 'ดอนไฟ', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05498', 'หัวเสือ', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05499', 'สบป้าด', '0612', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05500', 'วังเงิน', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05501', 'สันดอนแก้ว', '0612', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05502', 'สบปราบ', '0613', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05503', 'สมัย', '0613', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05504', 'แม่กัวะ', '0613', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05505', 'นายาง', '0613', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05506', 'ห้างฉัตร', '0614', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05507', 'หนองหล่ม', '0614', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05508', 'เมืองยาว', '0614', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05509', 'ปงยางคก', '0614', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05510', 'เวียงตาล', '0614', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05511', 'แม่สัน', '0614', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05512', 'วอแก้ว', '0614', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05513', 'เมืองปาน', '0615', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05514', 'บ้านขอ', '0615', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05515', 'ทุ่งกว๋าว', '0615', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05516', 'แจ้ซ้อน', '0615', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05517', 'หัวเมือง', '0615', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05518', 'ท่าอิฐ', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05519', 'ท่าเสา', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05520', 'บ้านเกาะ', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05521', 'ป่าเซ่า', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05522', 'คุ้งตะเภา', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05523', 'วังกะพี้', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05524', 'หาดกรวด', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05525', 'น้ำริด', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05526', 'งิ้วงาม', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05527', 'บ้านด่านนาขาม', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05528', 'บ้านด่าน', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05529', 'ผาจุก', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05530', 'วังดิน', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05531', 'แสนตอ', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05532', 'หาดงิ้ว', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05533', 'ขุนฝาง', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05534', 'ถ้ำฉลอง', '0616', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05535', 'ร่วมจิตร', '0616', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05536', 'วังแดง', '0617', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05537', 'บ้านแก่ง', '0617', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05538', 'หาดสองแคว', '0617', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05539', 'น้ำอ่าง', '0617', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05540', 'ข่อยสูง', '0617', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05541', 'น้ำพี้', '0617', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05542', 'บ่อทอง', '0617', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05543', 'ผักขวง', '0617', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05544', 'ป่าคาย', '0617', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05545', 'ท่าปลา', '0618', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05546', 'หาดล้า', '0618', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05547', 'ผาเลือด', '0618', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05548', 'จริม', '0618', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05549', 'น้ำหมัน', '0618', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05550', 'ท่าแฝก', '0618', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05551', 'นางพญา', '0618', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05552', 'ร่วมจิต', '0618', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05553', 'แสนตอ', '0619', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05554', 'บ้านฝาย', '0619', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05555', 'เด่นเหล็ก', '0619', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05556', 'น้ำไคร้', '0619', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05557', 'น้ำไผ่', '0619', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05558', 'ห้วยมุ่น', '0619', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05559', 'ฟากท่า', '0620', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05560', 'สองคอน', '0620', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05561', 'บ้านเสี้ยว', '0620', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05562', 'สองห้อง', '0620', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05563', 'ม่วงเจ็ดต้น', '0621', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05564', 'บ้านโคก', '0621', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05565', 'นาขุม', '0621', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05566', 'บ่อเบี้ย', '0621', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05567', 'ในเมือง', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05568', 'บ้านดารา', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05569', 'ไร่อ้อย', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05570', 'ท่าสัก', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05571', 'คอรุม', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05572', 'บ้านหม้อ', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05573', 'ท่ามะเฟือง', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05574', 'บ้านโคน', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05575', 'พญาแมน', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05576', 'นาอิน', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05577', 'นายาง', '0622', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05578', 'ศรีพนมมาศ', '0623', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05579', 'แม่พูล', '0623', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05580', 'นานกกก', '0623', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05581', 'ฝายหลวง', '0623', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05582', 'ชัยจุมพล', '0623', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05583', 'ไผ่ล้อม', '0623', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05584', 'ทุ่งยั้ง', '0623', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05585', 'ด่านแม่คำมัน', '0623', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05586', 'ศรีพนมมาศ', '0623', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05587', 'ผักขวง', '0624', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05588', 'บ่อทอง', '0624', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05589', 'ป่าคาย', '0624', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05590', 'น้ำพี้', '0624', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05591', 'ในเวียง', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05592', 'นาจักร', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05593', 'น้ำชำ', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05594', 'ป่าแดง', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05595', 'ทุ่งโฮ้ง', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05596', 'เหมืองหม้อ', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05597', 'วังธง', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05598', 'แม่หล่าย', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05599', 'ห้วยม้า', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05600', 'ป่าแมต', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05601', 'บ้านถิ่น', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05602', 'สวนเขื่อน', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05603', 'วังหงส์', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05604', 'แม่คำมี', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05605', 'ทุ่งกวาว', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05606', 'ท่าข้าม', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05607', 'แม่ยม', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05608', 'ช่อแฮ', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05609', 'ร่องฟอง', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05610', 'กาญจนา', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05611', 'ร้องกวาง', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05612', 'หนองม่วงไข่', '0626', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05613', 'แม่คำมี', '0626', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05614', 'ร้องเข็ม', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05615', 'น้ำเลา', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05616', 'บ้านเวียง', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05617', 'ทุ่งศรี', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05618', 'แม่ยางตาล', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05619', 'แม่ยางฮ่อ', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05620', 'ไผ่โทน', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05621', 'น้ำรัด', '0626', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05622', 'วังหลวง', '0626', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05623', 'ห้วยโรง', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05624', 'แม่ทราย', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05625', 'แม่ยางร้อง', '0626', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05626', 'หนองม่วงไข่', '0626', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05627', 'แม่คำมี', '0626', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05628', 'ห้วยอ้อ', '0627', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05629', 'บ้านปิน', '0627', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05630', 'ต้าผามอก', '0627', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05631', 'เวียงต้า', '0627', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05632', 'ปากกาง', '0627', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05633', 'หัวทุ่ง', '0627', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05634', 'ทุ่งแล้ง', '0627', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05635', 'บ่อเหล็กลอง', '0627', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05636', 'แม่ปาน', '0627', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05637', 'สูงเม่น', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05638', 'น้ำชำ', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05639', 'หัวฝาย', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05640', 'ดอนมูล', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05641', 'บ้านเหล่า', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05642', 'บ้านกวาง', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05643', 'บ้านปง', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05644', 'บ้านกาศ', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05645', 'ร่องกาศ', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05646', 'สบสาย', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05647', 'เวียงทอง', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05648', 'พระหลวง', '0628', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05649', 'เด่นชัย', '0629', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05650', 'แม่จั๊วะ', '0629', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05651', 'ไทรย้อย', '0629', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05652', 'ห้วยไร่', '0629', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05653', 'ปงป่าหวาย', '0629', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05654', 'บ้านหนุน', '0630', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05655', 'บ้านกลาง', '0630', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05656', 'ห้วยหม้าย', '0630', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05657', 'เตาปูน', '0630', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05658', 'หัวเมือง', '0630', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05659', 'สะเอียบ', '0630', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05660', 'แดนชุมพล', '0630', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05661', 'ทุ่งน้าว', '0630', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05662', 'วังชิ้น', '0631', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05663', 'สรอย', '0631', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05664', 'แม่ป้าก', '0631', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05665', 'นาพูน', '0631', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05666', 'แม่พุง', '0631', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05667', 'ป่าสัก', '0631', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05668', 'แม่เกิ๋ง', '0631', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05669', 'แม่คำมี', '0632', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05670', 'หนองม่วงไข่', '0632', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05671', 'น้ำรัด', '0632', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05672', 'วังหลวง', '0632', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05673', 'ตำหนักธรรม', '0632', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05674', 'ทุ่งแค้ว', '0632', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05675', 'ในเวียง', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05676', 'บ่อ', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05677', 'ผาสิงห์', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05678', 'ไชยสถาน', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05679', 'ถืมตอง', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05680', 'เรือง', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05681', 'นาซาว', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05682', 'ดู่ใต้', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05683', 'กองควาย', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05684', 'ฝายแก้ว', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05685', 'ม่วงตึ๊ด', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05686', 'ท่าน้าว', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05687', 'นาปัง', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05688', 'เมืองจัง', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05689', 'น้ำแก่น', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05690', 'สวก', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05691', 'สะเนียน', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05692', 'น้ำเกี๋ยน', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05693', 'ป่าคาหลวง', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05694', 'หมอเมือง', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05695', 'บ้านฟ้า', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05696', 'ดู่พงษ์', '0633', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05697', 'พงษ์', '0634', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05698', 'หนองแดง', '0634', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05699', 'หมอเมือง', '0634', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05700', 'น้ำพาง', '0634', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05701', 'น้ำปาย', '0634', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05702', 'แม่จริม', '0634', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05703', 'บ้านฟ้า', '0635', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05704', 'ป่าคาหลวง', '0635', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05705', 'สวด', '0635', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05706', 'บ้านพี้', '0635', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05707', 'นาน้อย', '0636', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05708', 'เชียงของ', '0636', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05709', 'ศรีษะเกษ', '0636', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05710', 'สถาน', '0636', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05711', 'สันทะ', '0636', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05712', 'บัวใหญ่', '0636', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05713', 'น้ำตก', '0636', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05714', 'ปัว', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05715', 'แงง', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05716', 'สถาน', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05717', 'ศิลาแลง', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05718', 'ศิลาเพชร', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05719', 'อวน', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05720', 'บ่อเกลือเหนือ', '0637', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05721', 'บ่อเกลือใต้', '0637', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05722', 'ไชยวัฒนา', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05723', 'เจดีย์ชัย', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05724', 'ภูคา', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05725', 'สกาด', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05726', 'ป่ากลาง', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05727', 'วรนคร', '0637', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05728', 'ริม', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05729', 'ป่าคา', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05730', 'ผาตอ', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05731', 'ยม', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05732', 'ตาลชุม', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05733', 'ศรีภูมิ', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05734', 'จอมพระ', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05735', 'แสนทอง', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05736', 'ท่าวังผา', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05737', 'ผาทอง', '0638', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05738', 'กลางเวียง', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05739', 'ขึ่ง', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05740', 'ไหล่น่าน', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05741', 'ตาลชุม', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05742', 'นาเหลือง', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05743', 'ส้าน', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05744', 'น้ำมวบ', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05745', 'น้ำปั้ว', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05746', 'ยาบหัวนา', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05747', 'ปงสนุก', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05748', 'อ่ายนาไลย', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05749', 'ส้านนาหนองใหม่', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05750', 'แม่ขะนิง', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05751', 'แม่สาคร', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05752', 'จอมจันทร์', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05753', 'แม่สา', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05754', 'ทุ่งศรีทอง', '0639', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05755', 'ปอน', '0640', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05756', 'งอบ', '0640', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05757', 'และ', '0640', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05758', 'ทุ่งช้าง', '0640', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05759', 'ห้วยโก๋น', '0640', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05760', 'เปือ', '0640', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05761', 'เชียงกลาง', '0640', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05762', 'เชียงกลาง', '0641', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05763', 'เปือ', '0641', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05764', 'เชียงคาน', '0641', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05765', 'พระธาตุ', '0641', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05766', 'นนาไร่หลวง', '0641', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05767', 'ชชนแดน', '0641', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05768', 'ยยอด', '0641', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05769', 'พญาแก้ว', '0641', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05770', 'พระพุทธบาท', '0641', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05771', 'นาไร่หลวง', '0641', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05772', 'ยอด', '0641', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05773', 'นาทะนุง', '0642', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05774', 'บ่อแก้ว', '0642', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05775', 'เมืองลี', '0642', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05776', 'ปิงหลวง', '0642', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05777', 'ดู่พงษ์', '0643', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05778', 'ป่าแลวหลวง', '0643', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05779', 'พงษ์', '0643', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05780', 'บ่อเกลือเหนือ', '0644', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05781', 'บ่อเกลือใต้', '0644', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05782', 'ขุนน่าน', '0644', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05783', 'ภูฟ้า', '0644', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05784', 'ดงพญา', '0644', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05785', 'นาไร่หลวง', '0645', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05786', 'ชนแดน', '0645', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05787', 'ยอด', '0645', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05788', 'ม่วงตึ๊ด', '0646', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05789', 'นาปัง', '0646', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05790', 'น้ำแก่น', '0646', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05791', 'น้ำเกี๋ยน', '0646', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05792', 'เมืองจัง', '0646', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05793', 'ท่าน้าว', '0646', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05794', 'ฝายแก้ว', '0646', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05795', 'ห้วยโก๋น', '0647', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05796', 'ขุนน่าน', '0647', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05797', 'เวียง', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05798', 'แม่ต๋ำ', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05799', 'ดงเจน', '0648', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05800', 'แม่นาเรือ', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05801', 'บ้านตุ่น', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05802', 'บ้านต๊ำ', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05803', 'บ้านต๋อม', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05804', 'แม่ปืม', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05805', 'ห้วยแก้ว', '0648', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05806', 'แม่กา', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05807', 'บ้านใหม่', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05808', 'จำป่าหวาย', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05809', 'ท่าวังทอง', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05810', 'แม่ใส', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05811', 'บ้านสาง', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05812', 'ท่าจำปี', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05813', 'แม่อิง', '0648', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05814', 'สันป่าม่วง', '0648', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05815', 'ห้วยข้าวก่ำ', '0649', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05816', 'จุน', '0649', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05817', 'ลอ', '0649', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05818', 'หงส์หิน', '0649', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05819', 'ทุ่งรวงทอง', '0649', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05820', 'ห้วยยางขาม', '0649', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05821', 'พระธาตุขิงแกง', '0649', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05822', 'หย่วน', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05823', 'ทุ่งกล้วย', '0650', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05824', 'สบบง', '0650', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05825', 'เชียงแรง', '0650', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05826', 'ภูซาง', '0650', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05827', 'น้ำแวน', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05828', 'เวียง', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05829', 'ฝายกวาง', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05830', 'เจดีย์คำ', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05831', 'ร่มเย็น', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05832', 'เชียงบาน', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05833', 'แม่ลาว', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05834', 'อ่างทอง', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05835', 'ทุ่งผาสุข', '0650', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05836', 'ป่าสัก', '0650', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05837', 'เชียงม่วน', '0651', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05838', 'บ้านมาง', '0651', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05839', 'สระ', '0651', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05840', 'ดอกคำใต้', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05841', 'ดอนศรีชุม', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05842', 'บ้านถ้ำ', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05843', 'บ้านปิน', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05844', 'ห้วยลาน', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05845', 'สันโค้ง', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05846', 'ป่าซาง', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05847', 'หนองหล่ม', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05848', 'ดงสุวรรณ', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05849', 'บุญเกิด', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05850', 'สว่างอารมณ์', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05851', 'คือเวียง', '0652', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05852', 'ปง', '0653', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05853', 'ควร', '0653', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05854', 'ออย', '0653', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05855', 'งิม', '0653', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05856', 'ผาช้างน้อย', '0653', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05857', 'นาปรัง', '0653', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05858', 'ขุนควร', '0653', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05859', 'แม่ใจ', '0654', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05860', 'ศรีถ้อย', '0654', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05861', 'แม่สุก', '0654', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05862', 'ป่าแฝก', '0654', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05863', 'บ้านเหล่า', '0654', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05864', 'เจริญราษฎร์', '0654', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05865', 'ภูซาง', '0655', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05866', 'ป่าสัก', '0655', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05867', 'ทุ่งกล้วย', '0655', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05868', 'เชียงแรง', '0655', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05869', 'สบบง', '0655', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05870', 'ห้วยแก้ว', '0656', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05871', 'ดงเจน', '0656', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05872', 'แม่อิง', '0656', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05873', 'เวียง', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05874', 'รอบเวียง', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05875', 'บ้านดู่', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05876', 'นางแล', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05877', 'แม่ข้าวต้ม', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05878', 'แม่ยาว', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05879', 'สันทราย', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05880', 'บัวสลี', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05881', 'ดงมะดะ', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05882', 'ป่าก่อดำ', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05883', 'แม่กรณ์', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05884', 'ห้วยชมภู', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05885', 'ห้วยสัก', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05886', 'ริมกก', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05887', 'ดอยลาน', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05888', 'ป่าอ้อดอนชัย', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05889', 'จอมหมอกแก้ว', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05890', 'ท่าสาย', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05891', 'โป่งแพร่', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05892', 'ดอยฮาง', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05893', 'ท่าสุด', '0657', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05894', 'ทุ่งก่อ', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05895', 'ป่าก่อดำ', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05896', 'ดงมะดะ', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05897', 'บัวสลี', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05898', 'เวียงเหนือ', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05899', 'ผางาม', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05900', 'เวียงชัย', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05901', 'ทุ่งก่อ', '0657', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05902', 'ทุ่งก่อ', '0658', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05903', 'เวียงชัย', '0658', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05904', 'ผางาม', '0658', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05905', 'เวียงเหนือ', '0658', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05906', 'ป่าซาง', '0658', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05907', 'ดอนศิลา', '0658', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05908', 'ดงมหาวัน', '0658', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05909', 'เมืองชุม', '0658', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05910', 'เวียง', '0659', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05911', 'สถาน', '0659', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05912', 'ครึ่ง', '0659', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05913', 'บุญเรือง', '0659', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05914', 'ห้วยซ้อ', '0659', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05915', 'ม่วงยาย', '0659', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05916', 'ปอ', '0659', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05917', 'ศรีดอนชัย', '0659', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05918', 'หล่ายงาว', '0659', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05919', 'ริมโขง', '0659', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05920', 'ปอ', '0659', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05921', 'ม่วงยาย', '0659', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05922', 'เวียง', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05923', 'งิ้ว', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05924', 'ปล้อง', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05925', 'แม่ลอย', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05926', 'เชียงเคี่ยน', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05927', 'ตต้า', '0660', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05928', 'ปป่าตาล', '0660', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05929', 'ยยางฮอม', '0660', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05930', 'ตับเต่า', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05931', 'หงาว', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05932', 'สันทรายงาม', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05933', 'ศรีดอนไชย', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05934', 'หนองแรด', '0660', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05935', 'แม่ลอย', '0660', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05936', 'ต้า', '0660', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05937', 'ยางฮอม', '0660', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05938', 'แม่เปา', '0660', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05939', 'ป่าตาล', '0660', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05940', 'สันมะเค็ด', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05941', 'แม่อ้อ', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05942', 'ธารทอง', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05943', 'สันติสุข', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05944', 'ดอยงาม', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05945', 'หัวง้ม', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05946', 'เจริญเมือง', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05947', 'ป่าหุ่ง', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05948', 'ม่วงคำ', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05949', 'ทรายขาว', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05950', 'สันกลาง', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05951', 'แม่เย็น', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05952', 'เมืองพาน', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05953', 'ทานตะวัน', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05954', 'เวียงห้าว', '0661', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05955', 'ป่าแงะ', '0661', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05956', 'สันมะค่า', '0661', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05957', 'ป่าแดด', '0661', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05958', 'ป่าแดด', '0662', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05959', 'ป่าแงะ', '0662', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05960', 'สันมะค่า', '0662', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05961', 'โรงช้าง', '0662', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05962', 'ศรีโพธิ์เงิน', '0662', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05963', 'แม่จัน', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05964', 'จันจว้า', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05965', 'แม่คำ', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05966', 'ป่าซาง', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05967', 'สันทราย', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05968', 'ท่าข้าวเปลือก', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05969', 'ปงน้อย', '0663', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05970', 'ป่าตึง', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05971', 'หนองป่าก่อ', '0663', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05972', 'แม่ไร่', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05973', 'ศรีค้ำ', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05974', 'จันจว้าใต้', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05975', 'จอมสวรรค์', '0663', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05976', 'เเทอดไทย', '0663', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05977', 'แแม่สลองใน', '0663', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05978', 'แม่สลองนอก', '0663', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05979', 'โชคชัย', '0663', -1 )
INSERT INTO tbm_sub_district
VALUES
( '05980', 'เวียง', '0664', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05981', 'ป่าสัก', '0664', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05982', 'บ้านแซว', '0664', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05983', 'ศรีดอนมูล', '0664', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05984', 'แม่เงิน', '0664', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05985', 'โยนก', '0664', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05986', 'แม่สาย', '0665', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05987', 'ห้วยไคร้', '0665', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05988', 'เกาะช้าง', '0665', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05989', 'โป่งผา', '0665', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05990', 'ศรีเมืองชุม', '0665', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05991', 'เวียงพางคำ', '0665', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05992', 'บ้านด้าย', '0665', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05993', 'โป่งงาม', '0665', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05994', 'แม่สรวย', '0666', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05995', 'ป่าแดด', '0666', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05996', 'แม่พริก', '0666', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05997', 'ศรีถ้อย', '0666', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05998', 'ท่าก๊อ', '0666', 1 )
INSERT INTO tbm_sub_district
VALUES
( '05999', 'วาวี', '0666', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06000', 'เจดีย์หลวง', '0666', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06001', 'สันสลี', '0667', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06002', 'เวียง', '0667', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06003', 'บ้านโป่ง', '0667', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06004', 'ป่างิ้ว', '0667', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06005', 'เวียงกาหลง', '0667', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06006', 'แม่เจดีย์', '0667', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06007', 'แม่เจดีย์ใหม่', '0667', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06008', 'เวียงกาหลง', '0667', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06009', 'แม่เปา', '0668', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06010', 'แม่ต๋ำ', '0668', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06011', 'ไม้ยา', '0668', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06012', 'เม็งราย', '0668', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06013', 'ตาดควัน', '0668', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06014', 'ม่วงยาย', '0669', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06015', 'ปอ', '0669', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06016', 'หล่ายงาว', '0669', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06017', 'ท่าข้าม', '0669', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06018', 'ต้า', '0670', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06019', 'ป่าตาล', '0670', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06020', 'ยางฮอม', '0670', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06021', 'เทอดไทย', '0671', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06022', 'แม่สลองใน', '0671', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06023', 'แม่สลองนอก', '0671', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06024', 'แม่ฟ้าหลวง', '0671', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06025', 'ดงมะดะ', '0672', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06026', 'จอมหมอกแก้ว', '0672', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06027', 'บัวสลี', '0672', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06028', 'ป่าก่อดำ', '0672', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06029', 'โป่งแพร่', '0672', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06030', 'ทุ่งก่อ', '0673', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06031', 'ดงมหาวัน', '0673', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06032', 'ป่าซาง', '0673', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06033', 'ปงน้อย', '0674', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06034', 'โชคชัย', '0674', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06035', 'หนองป่าก่อ', '0674', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06036', 'จองคำ', '0675', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06037', 'ห้วยโป่ง', '0675', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06038', 'ผาบ่อง', '0675', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06039', 'ปางหมู', '0675', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06040', 'หมอกจำแป่', '0675', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06041', 'ห้วยผา', '0675', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06042', 'ปางมะผ้า', '0675', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06043', 'สบป่อง', '0675', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06044', 'ห้วยปูลิง', '0675', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06045', 'ขุนยวม', '0676', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06046', 'แม่เงา', '0676', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06047', 'เมืองปอน', '0676', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06048', 'แม่ยวมน้อย', '0676', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06049', 'แม่กิ๊', '0676', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06050', 'แม่อูคอ', '0676', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06051', 'เวียงใต้', '0677', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06052', 'เวียงเหนือ', '0677', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06053', 'แม่นาเติง', '0677', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06054', 'แม่ฮี้', '0677', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06055', 'ทุ่งยาว', '0677', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06056', 'เมืองแปง', '0677', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06057', 'โป่งสา', '0677', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06058', 'บ้านกาศ', '0678', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06059', 'แม่สะเรียง', '0678', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06060', 'แม่คง', '0678', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06061', 'แม่เหาะ', '0678', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06062', 'แม่ยวม', '0678', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06063', 'เสาหิน', '0678', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06064', 'ป่าแป๋', '0678', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06065', 'กองกอย', '0678', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06066', 'แม่คะตวน', '0678', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06067', 'สบเมย', '0678', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06068', 'แม่ลาน้อย', '0679', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06069', 'แม่ลาหลวง', '0679', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06070', 'ท่าผาปุ้ม', '0679', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06071', 'แม่โถ', '0679', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06072', 'ห้วยห้อม', '0679', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06073', 'แม่นาจาง', '0679', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06074', 'สันติคีรี', '0679', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06075', 'ขุนแม่ลาน้อย', '0679', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06076', 'สบเมย', '0680', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06077', 'แม่คะตวน', '0680', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06078', 'กองก๋อย', '0680', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06079', 'แม่สวด', '0680', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06080', 'ป่าโปง', '0680', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06081', 'แม่สามแลบ', '0680', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06082', 'สบป่อง', '0681', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06083', 'ปางมะผ้า', '0681', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06084', 'ถ้ำลอด', '0681', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06085', 'นาปู่ป้อม', '0681', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06086', 'ปากน้ำโพ', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06087', 'กลางแดด', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06088', 'เกรียงไกร', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06089', 'แควใหญ่', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06090', 'ตะเคียนเลื่อน', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06091', 'นครสวรรค์ตก', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06092', 'นครสวรรค์ออก', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06093', 'บางพระหลวง', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06094', 'บางม่วง', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06095', 'บ้านมะเกลือ', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06096', 'บ้านแก่ง', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06097', 'พระนอน', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06098', 'วัดไทร', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06099', 'หนองกรด', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06100', 'หนองกระโดน', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06101', 'หนองปลิง', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06102', 'บึงเสนาท', '0683', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06103', 'โกรกพระ', '0684', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06104', 'ยางตาล', '0684', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06105', 'บางมะฝ่อ', '0684', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06106', 'บางประมุง', '0684', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06107', 'นากลาง', '0684', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06108', 'ศาลาแดง', '0684', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06109', 'เนินกว้าว', '0684', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06110', 'เนินศาลา', '0684', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06111', 'หาดสูง', '0684', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06112', 'ชุมแสง', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06113', 'ทับกฤช', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06114', 'พิกุล', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06115', 'เกยไชย', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06116', 'ท่าไม้', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06117', 'บางเคียน', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06118', 'หนองกระเจา', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06119', 'พันลาน', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06120', 'โคกหม้อ', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06121', 'ไผ่สิงห์', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06122', 'ฆะมัง', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06123', 'ทับกฤชใต้', '0685', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06124', 'หนองบัว', '0686', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06125', 'หนองกลับ', '0686', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06126', 'ธารทหาร', '0686', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06127', 'ห้วยร่วม', '0686', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06128', 'ห้วยถั่วใต้', '0686', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06129', 'ห้วยถั่วเหนือ', '0686', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06130', 'ห้วยใหญ่', '0686', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06131', 'ทุ่งทอง', '0686', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06132', 'วังบ่อ', '0686', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06133', 'ท่างิ้ว', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06134', 'บางตาหงาย', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06135', 'หูกวาง', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06136', 'อ่างทอง', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06137', 'บ้านแดน', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06138', 'บางแก้ว', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06139', 'ตาขีด', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06140', 'ตาสัง', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06141', 'ด่านช้าง', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06142', 'หนองกรด', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06143', 'หนองตางู', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06144', 'บึงปลาทู', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06145', 'เจริญผล', '0687', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06146', 'มหาโพธิ', '0688', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06147', 'เก้าเลี้ยว', '0688', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06148', 'หนองเต่า', '0688', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06149', 'เขาดิน', '0688', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06150', 'หัวดง', '0688', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06151', 'ตาคลี', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06152', 'ช่องแค', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06153', 'จันเสน', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06154', 'ห้วยหอม', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06155', 'หัวหวาย', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06156', 'หนองโพ', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06157', 'หนองหม้อ', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06158', 'สร้อยทอง', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06159', 'ลาดทิพรส', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06160', 'พรหมนิมิต', '0689', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06161', 'ท่าตะโก', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06162', 'พนมรอก', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06163', 'หัวถนน', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06164', 'สายลำโพง', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06165', 'วังมหากร', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06166', 'ดอนคา', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06167', 'ทำนบ', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06168', 'วังใหญ่', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06169', 'พนมเศษ', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06170', 'หนองหลวง', '0690', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06171', 'โคกเดื่อ', '0691', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06172', 'สำโรงชัย', '0691', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06173', 'วังน้ำลัด', '0691', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06174', 'ตะคร้อ', '0691', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06175', 'โพธิ์ประสาท', '0691', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06176', 'วังข่อย', '0691', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06177', 'นาขอม', '0691', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06178', 'ไพศาลี', '0691', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06179', 'พยุหะ', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06180', 'เนินมะกอก', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06181', 'นิคมเขาบ่อแก้ว', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06182', 'ม่วงหัก', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06183', 'ยางขาว', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06184', 'ย่านมัทรี', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06185', 'เขาทอง', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06186', 'ท่าน้ำอ้อย', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06187', 'น้ำทรง', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06188', 'เขากะลา', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06189', 'สระทะเล', '0692', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06190', 'ลาดยาว', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06191', 'ห้วยน้ำหอม', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06192', 'วังม้า', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06193', 'วังเมือง', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06194', 'สร้อยละคร', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06195', 'มาบแก', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06196', 'หนองยาว', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06197', 'หนองนมวัว', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06198', 'บ้านไร่', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06199', 'เนินขี้เหล็ก', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06200', 'แแม่เล่ย์', '0693', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06201', 'แแม่วงก์', '0693', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06202', 'ววังซ่าน', '0693', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06203', 'เเขาชนกัน', '0693', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06204', 'ปปางสวรรค์', '0693', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06205', 'ศาลเจ้าไก่ต่อ', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06206', 'สระแก้ว', '0693', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06207', 'ตากฟ้า', '0694', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06208', 'ลำพยนต์', '0694', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06209', 'สุขสำราญ', '0694', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06210', 'หนองพิกุล', '0694', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06211', 'พุนกยูง', '0694', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06212', 'อุดมธัญญา', '0694', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06213', 'เขาชายธง', '0694', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06214', 'แม่วงก์', '0695', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06215', 'ห้วยน้ำหอม', '0695', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06216', 'แม่เล่ย์', '0695', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06217', 'วังซ่าน', '0695', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06218', 'เขาชนกัน', '0695', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06219', 'ปางสวรรค์', '0695', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06220', 'แม่เปิน', '0695', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06221', 'ชุมตาบง', '0695', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06222', 'แม่เปิน', '0696', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06223', 'ชุมตาบง', '0697', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06224', 'ปางสวรรค์', '0697', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06225', 'อุทัยใหม่', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06226', 'น้ำซึม', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06227', 'สะแกกรัง', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06228', 'ดอนขวาง', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06229', 'หาดทนง', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06230', 'เกาะเทโพ', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06231', 'ท่าซุง', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06232', 'หนองแก', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06233', 'โนนเหล็ก', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06234', 'หนองเต่า', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06235', 'หนองไผ่แบน', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06236', 'หนองพังค่า', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06237', 'ทุ่งใหญ่', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06238', 'เนินแจง', '0701', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06239', 'ข้าวเม่า', '0701', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06240', 'ทัพทัน', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06241', 'ทุ่งนาไทย', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06242', 'เขาขี้ฝอย', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06243', 'หนองหญ้าปล้อง', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06244', 'โคกหม้อ', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06245', 'หนองยายดา', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06246', 'หนองกลางดง', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06247', 'หนองกระทุ่ม', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06248', 'หนองสระ', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06249', 'ตลุกดู่', '0702', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06250', 'สว่างอารมณ์', '0703', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06251', 'หนองหลวง', '0703', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06252', 'พลวงสองนาง', '0703', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06253', 'ไผ่เขียว', '0703', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06254', 'บ่อยาง', '0703', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06255', 'หนองฉาง', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06256', 'หนองยาง', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06257', 'หนองนางนวล', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06258', 'หนองสรวง', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06259', 'บ้านเก่า', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06260', 'อุทัยเก่า', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06261', 'ทุ่งโพ', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06262', 'ทุ่งพง', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06263', 'เขาบางแกรก', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06264', 'เขากวางทอง', '0704', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06265', 'หนองขาหย่าง', '0705', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06266', 'หนองไผ่', '0705', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06267', 'ดอนกลอย', '0705', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06268', 'ห้วยรอบ', '0705', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06269', 'ทุ่งพึ่ง', '0705', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06270', 'ท่าโพ', '0705', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06271', 'หมกแถว', '0705', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06272', 'หลุมเข้า', '0705', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06273', 'ดงขวาง', '0705', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06274', 'บ้านไร่', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06275', 'ทัพหลวง', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06276', 'ห้วยแห้ง', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06277', 'คอกควาย', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06278', 'วังหิน', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06279', 'เมืองการุ้ง', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06280', 'แก่นมะกรูด', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06281', 'หนองจอก', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06282', 'หูช้าง', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06283', 'บ้านบึง', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06284', 'บ้านใหม่คลองเคียน', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06285', 'หนองบ่มกล้วย', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06286', 'เจ้าวัด', '0706', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06287', 'ห้วยคต', '0706', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06288', 'สุขฤทัย', '0706', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06289', 'ป่าอ้อ', '0706', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06290', 'ประดู่ยืน', '0706', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06291', 'ลานสัก', '0706', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06292', 'ลานสัก', '0707', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06293', 'ประดู่ยืน', '0707', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06294', 'ป่าอ้อ', '0707', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06295', 'ระบำ', '0707', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06296', 'น้ำรอบ', '0707', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06297', 'ทุ่งนางาม', '0707', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06298', 'สุขฤทัย', '0708', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06299', 'ทองหลาง', '0708', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06300', 'ห้วยคต', '0708', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06301', 'ในเมือง', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06302', 'ไตรตรึงษ์', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06303', 'อ่างทอง', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06304', 'นาบ่อคำ', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06305', 'นครชุม', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06306', 'ทรงธรรม', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06307', 'ลานดอกไม้', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06308', 'ลานดอกไม้ตก', '0709', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06309', 'โกสัมพี', '0709', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06310', 'หนองปลิง', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06311', 'คณฑี', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06312', 'นิคมทุ่งโพธิ์ทะเล', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06313', 'เทพนคร', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06314', 'วังทอง', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06315', 'ท่าขุนราม', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06316', 'เพชรชมภู', '0709', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06317', 'คลองแม่ลาย', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06318', 'ธำมรงค์', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06319', 'สระแก้ว', '0709', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06320', 'หนองคล้า', '0709', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06321', 'โป่งน้ำร้อน', '0709', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06322', 'ไทรงาม', '0709', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06323', 'ไทรงาม', '0710', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06324', 'หนองคล้า', '0710', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06325', 'หนองทอง', '0710', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06326', 'หนองไม้กอง', '0710', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06327', 'มหาชัย', '0710', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06328', 'พานทอง', '0710', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06329', 'หนองแม่แตง', '0710', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06330', 'คลองน้ำไหล', '0711', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06331', 'โป่งน้ำร้อน', '0711', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06332', 'คลองลานพัฒนา', '0711', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06333', 'สักงาม', '0711', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06334', 'วังชะโอน', '0712', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06335', 'ระหาน', '0712', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06336', 'ยางสูง', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06337', 'ป่าพุทรา', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06338', 'แสนตอ', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06339', 'สลกบาตร', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06340', 'บ่อถ้ำ', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06341', 'ดอนแตง', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06342', 'วังชะพลู', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06343', 'โค้งไผ่', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06344', 'ปางมะค่า', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06345', 'วังหามแห', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06346', 'เกาะตาล', '0712', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06347', 'บึงสามัคคี', '0712', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06348', 'คลองขลุง', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06349', 'ท่ามะเขือ', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06350', 'ททุ่งทราย', '0713', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06351', 'ท่าพุทรา', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06352', 'แม่ลาด', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06353', 'วังยาง', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06354', 'วังแขม', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06355', 'หัวถนน', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06356', 'วังไทร', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06357', 'โพธิ์ทอง', '0713', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06358', 'ปางตาไว', '0713', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06359', 'ถถาวรวัฒนา', '0713', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06360', 'วังบัว', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06361', 'ทุ่งทอง', '0713', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06362', 'หินดาต', '0713', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06363', 'คลองสมบูรณ์', '0713', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06364', 'ทุ่งทราย', '0713', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06365', 'พรานกระต่าย', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06366', 'หนองหัววัว', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06367', 'ท่าไม้', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06368', 'วังควง', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06369', 'วังตะแบก', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06370', 'เขาคีริส', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06371', 'คุยบ้านโอง', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06372', 'คลองพิไกร', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06373', 'ถ้ำกระต่ายทอง', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06374', 'ห้วยยั้ง', '0714', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06375', 'ลานกระบือ', '0715', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06376', 'ช่องลม', '0715', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06377', 'หนองหลวง', '0715', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06378', 'โนนพลวง', '0715', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06379', 'ประชาสุขสันต์', '0715', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06380', 'บึงทับแรต', '0715', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06381', 'จันทิมา', '0715', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06382', 'ทุ่งทราย', '0716', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06383', 'ทุ่งทอง', '0716', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06384', 'ถาวรวัฒนา', '0716', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06385', 'โพธิ์ทอง', '0717', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06386', 'หินดาต', '0717', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06387', 'ปางตาไว', '0717', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06388', 'บึงสามัคคี', '0718', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06389', 'วังชะโอน', '0718', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06390', 'ระหาน', '0718', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06391', 'เทพนิมิต', '0718', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06392', 'โกสัมพี', '0719', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06393', 'เพชรชมภู', '0719', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06394', 'ลานดอกไม้ตก', '0719', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06395', 'ระแหง', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06396', 'หนองหลวง', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06397', 'เชียงเงิน', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06398', 'หัวเดียด', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06399', 'หนองบัวเหนือ', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06400', 'ไม้งาม', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06401', 'โป่งแดง', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06402', 'น้ำรึม', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06403', 'วังหิน', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06404', 'เชียงทอง', '0720', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06405', 'แม่ท้อ', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06406', 'ป่ามะม่วง', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06407', 'หนองบัวใต้', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06408', 'วังประจบ', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06409', 'ตลุกกลางทุ่ง', '0720', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06410', 'นาโบสถ์', '0720', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06411', 'ประดาง', '0720', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06412', 'ตากออก', '0721', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06413', 'สมอโคน', '0721', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06414', 'แม่สลิด', '0721', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06415', 'ตากตก', '0721', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06416', 'เกาะตะเภา', '0721', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06417', 'ทุ่งกระเชาะ', '0721', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06418', 'ท้องฟ้า', '0721', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06419', 'สามเงา', '0722', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06420', 'วังหมัน', '0722', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06421', 'ยกกระบัตร', '0722', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06422', 'ย่านรี', '0722', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06423', 'บ้านนา', '0722', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06424', 'วังจันทร์', '0722', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06425', 'แม่ระมาด', '0723', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06426', 'แม่จะเรา', '0723', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06427', 'ขะเนจื้อ', '0723', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06428', 'แม่ตื่น', '0723', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06429', 'สามหมื่น', '0723', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06430', 'พระธาตุ', '0723', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06431', 'ท่าสองยาง', '0724', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06432', 'แม่ต้าน', '0724', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06433', 'แม่สอง', '0724', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06434', 'แม่หละ', '0724', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06435', 'แม่วะหลวง', '0724', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06436', 'แม่อุสุ', '0724', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06437', 'แม่สอด', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06438', 'แม่กุ', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06439', 'พะวอ', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06440', 'แม่ตาว', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06441', 'แม่กาษา', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06442', 'ท่าสายลวด', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06443', 'แม่ปะ', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06444', 'มหาวัน', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06445', 'ด่านแม่ละเมา', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06446', 'พระธาตุผาแดง', '0725', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06447', 'พบพระ', '0726', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06448', 'ช่องแคบ', '0726', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06449', 'คีรีราษฎร์', '0726', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06450', 'วาเล่ย์', '0726', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06451', 'รวมไทยพัฒนา', '0726', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06452', 'อุ้มผาง', '0727', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06453', 'หนองหลวง', '0727', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06454', 'โมโกร', '0727', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06455', 'แม่จัน', '0727', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06456', 'แม่ละมุ้ง', '0727', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06457', 'แม่กลอง', '0727', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06458', 'เชียงทอง', '0728', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06459', 'นาโบสถ์', '0728', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06460', 'ประดาง', '0728', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06461', 'ธานี', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06462', 'บ้านสวน', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06463', 'เมืองเก่า', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06464', 'ปากแคว', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06465', 'ยางซ้าย', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06466', 'บ้านกล้วย', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06467', 'บ้านหลุม', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06468', 'ตาลเตี้ย', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06469', 'ปากพระ', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06470', 'วังทองแดง', '0730', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06471', 'ลานหอย', '0731', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06472', 'บ้านด่าน', '0731', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06473', 'วังตะคร้อ', '0731', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06474', 'วังน้ำขาว', '0731', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06475', 'ตลิ่งชัน', '0731', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06476', 'หนองหญ้าปล้อง', '0731', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06477', 'วังลึก', '0731', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06478', 'โตนด', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06479', 'ทุ่งหลวง', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06480', 'บ้านป้อม', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06481', 'สามพวง', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06482', 'ศรีคีรีมาศ', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06483', 'หนองจิก', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06484', 'นาเชิงคีรี', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06485', 'หนองกระดิ่ง', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06486', 'บ้านน้ำพุ', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06487', 'ทุ่งยางเมือง', '0732', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06488', 'กง', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06489', 'บ้านกร่าง', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06490', 'ไกรนอก', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06491', 'ไกรกลาง', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06492', 'ไกรใน', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06493', 'ดงเดือย', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06494', 'ป่าแฝก', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06495', 'กกแรต', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06496', 'ท่าฉนวน', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06497', 'หนองตูม', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06498', 'บ้านใหม่สุขเกษม', '0733', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06499', 'หาดเสี้ยว', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06500', 'ป่างิ้ว', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06501', 'แม่สำ', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06502', 'แม่สิน', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06503', 'บ้านตึก', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06504', 'หนองอ้อ', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06505', 'ท่าชัย', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06506', 'ศรีสัชนาลัย', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06507', 'ดงคู่', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06508', 'บ้านแก่ง', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06509', 'สารจิตร', '0734', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06510', 'คลองตาล', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06511', 'วังลึก', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06512', 'สามเรือน', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06513', 'บ้านนา', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06514', 'วังทอง', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06515', 'นาขุนไกร', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06516', 'เกาะตาเลี้ยง', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06517', 'วัดเกาะ', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06518', 'บ้านไร่', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06519', 'ทับผึ้ง', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06520', 'บ้านซ่าน', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06521', 'วังใหญ่', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06522', 'ราวต้นจันทร์', '0735', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06523', 'เมืองสวรรคโลก', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06524', 'ในเมือง', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06525', 'คลองกระจง', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06526', 'วังพิณพาทย์', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06527', 'วังไม้ขอน', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06528', 'ย่านยาว', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06529', 'นาทุ่ง', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06530', 'คลองยาง', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06531', 'เมืองบางยม', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06532', 'ท่าทอง', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06533', 'ปากน้ำ', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06534', 'ป่ากุมเกาะ', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06535', 'เมืองบางขลัง', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06536', 'หนองกลับ', '0736', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06537', 'ประชาราษฎร์', '0736', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06538', 'คลองมะพลับ', '0736', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06539', 'น้ำขุม', '0736', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06540', 'นครเดิฐ', '0736', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06541', 'ศรีนคร', '0736', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06542', 'ศรีนคร', '0737', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06543', 'นครเดิฐ', '0737', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06544', 'น้ำขุม', '0737', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06545', 'คลองมะพลับ', '0737', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06546', 'หนองบัว', '0737', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06547', 'บ้านใหม่ไชยมงคล', '0738', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06548', 'ไทยชนะศึก', '0738', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06549', 'ทุ่งเสลี่ยม', '0738', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06550', 'กลางดง', '0738', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06551', 'เขาแก้วศรีสมบูรณ์', '0738', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06552', 'ในเมือง', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06553', 'วังน้ำคู้', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06554', 'วัดจันทร์', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06555', 'วัดพริก', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06556', 'ท่าทอง', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06557', 'ท่าโพธิ์', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06558', 'สมอแข', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06559', 'ดอนทอง', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06560', 'บ้านป่า', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06561', 'ปากโทก', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06562', 'หัวรอ', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06563', 'จอมทอง', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06564', 'บ้านกร่าง', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06565', 'บ้านคลอง', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06566', 'พลายชุมพล', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06567', 'มะขามสูง', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06568', 'อรัญญิก', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06569', 'บึงพระ', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06570', 'ไผ่ขอดอน', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06571', 'งิ้วงาม', '0739', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06572', 'นครไทย', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06573', 'หนองกะท้าว', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06574', 'บ้านแยง', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06575', 'เนินเพิ่ม', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06576', 'นาบัว', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06577', 'นครชุม', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06578', 'น้ำกุ่ม', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06579', 'ยางโกลน', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06580', 'บ่อโพธิ์', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06581', 'บ้านพร้าว', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06582', 'ห้วยเฮี้ย', '0740', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06583', 'ป่าแดง', '0741', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06584', 'ชาติตระการ', '0741', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06585', 'สวนเมี่ยง', '0741', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06586', 'บ้านดง', '0741', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06587', 'บ่อภาค', '0741', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06588', 'ท่าสะแก', '0741', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06589', 'บางระกำ', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06590', 'ปลักแรด', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06591', 'พันเสา', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06592', 'วังอิทก', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06593', 'บึงกอก', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06594', 'หนองกุลา', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06595', 'ชุมแสงสงคราม', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06596', 'นิคมพัฒนา', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06597', 'บ่อทอง', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06598', 'ท่านางงาม', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06599', 'คุยม่วง', '0742', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06600', 'บางกระทุ่ม', '0743', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06601', 'บ้านไร่', '0743', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06602', 'โคกสลุด', '0743', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06603', 'สนามคลี', '0743', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06604', 'ท่าตาล', '0743', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06605', 'ไผ่ล้อม', '0743', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06606', 'นครป่าหมาก', '0743', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06607', 'เนินกุ่ม', '0743', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06608', 'วัดตายม', '0743', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06609', 'พรหมพิราม', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06610', 'ท่าช้าง', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06611', 'วงฆ้อง', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06612', 'มะตูม', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06613', 'หอกลอง', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06614', 'ศรีภิรมย์', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06615', 'ตลุกเทียม', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06616', 'วังวน', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06617', 'หนองแขม', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06618', 'มะต้อง', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06619', 'ทับยายเชียง', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06620', 'ดงประคำ', '0744', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06621', 'วัดโบสถ์', '0745', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06622', 'ท่างาม', '0745', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06623', 'ท้อแท้', '0745', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06624', 'บ้านยาง', '0745', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06625', 'หินลาด', '0745', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06626', 'คันโช้ง', '0745', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06627', 'วังทอง', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06628', 'พันชาลี', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06629', 'แม่ระกา', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06630', 'บ้านกลาง', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06631', 'วังพิกุล', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06632', 'แก่งโสภา', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06633', 'ท่าหมื่นราม', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06634', 'วังนกแอ่น', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06635', 'หนองพระ', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06636', 'ชัยนาม', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06637', 'ดินทอง', '0746', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06638', 'บ้านน้อยซุ้มขี้เหล็ก', '0746', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06639', 'วังโพรง', '0746', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06640', 'ไทรย้อย', '0746', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06641', 'บ้านมุง', '0746', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06642', 'ชมพู', '0746', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06643', 'ชมพู', '0747', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06644', 'บ้านมุง', '0747', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06645', 'ไทรย้อย', '0747', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06646', 'วังโพรง', '0747', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06647', 'บ้านน้อยซุ้มขี้เหล็ก', '0747', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06648', 'เนินมะปราง', '0747', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06649', 'วังยาง', '0747', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06650', 'โคกแหลม', '0747', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06651', 'ในเมือง', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06652', 'ไผ่ขวาง', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06653', 'ย่านยาว', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06654', 'ท่าฬ่อ', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06655', 'ปากทาง', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06656', 'คลองคะเชนทร์', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06657', 'โรงช้าง', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06658', 'เมืองเก่า', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06659', 'ท่าหลวง', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06660', 'บ้านบุ่ง', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06661', 'ฆะมัง', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06662', 'ดงป่าคำ', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06663', 'หัวดง', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06664', 'หนองปล้อง', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06665', 'ป่ามะคาบ', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06666', 'สากเหล็ก', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06667', 'ท่าเยี่ยม', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06668', 'คลองทราย', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06669', 'สายคำโห้', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06670', 'ดงกลาง', '0748', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06671', 'ไผ่รอบ', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06672', 'วังจิก', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06673', 'โพธิ์ประทับช้าง', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06674', 'ไผ่ท่าโพ', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06675', 'วังจิก', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06676', 'หนองพระ', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06677', 'หนองปลาไหล', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06678', 'วังทรายพูน', '0748', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06679', 'วังทรายพูน', '0749', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06680', 'หนองปลาไหล', '0749', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06681', 'หนองพระ', '0749', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06682', 'หนองปล้อง', '0749', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06683', 'โพธิ์ประทับช้าง', '0750', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06684', 'ไผ่ท่าโพ', '0750', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06685', 'วังจิก', '0750', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06686', 'ไผ่รอบ', '0750', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06687', 'ดงเสือเหลือง', '0750', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06688', 'เนินสว่าง', '0750', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06689', 'ทุ่งใหญ่', '0750', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06690', 'ตะพานหิน', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06691', 'งิ้วราย', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06692', 'ห้วยเกตุ', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06693', 'ไทรโรงโขน', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06694', 'หนองพยอม', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06695', 'ทุ่งโพธิ์', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06696', 'ดงตะขบ', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06697', 'คลองคูณ', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06698', 'วังสำโรง', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06699', 'วังหว้า', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06700', 'วังหลุม', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06701', 'ทับหมัน', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06702', 'ไผ่หลวง', '0751', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06703', 'ท้ายทุ่ง', '0751', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06704', 'เขาเจ็ดลูก', '0751', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06705', 'เขาทราย', '0751', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06706', 'ทับคล้อ', '0751', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06707', 'บางมูลนาก', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06708', 'บางไผ่', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06709', 'หอไกร', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06710', 'เนินมะกอก', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06711', 'วังสำโรง', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06712', 'ภูมิ', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06713', 'วังกรด', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06714', 'ห้วยเขน', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06715', 'วังตะกู', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06716', 'สำนักขุนเณร', '0752', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06717', 'ห้วยพุก', '0752', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06718', 'ห้วยร่วม', '0752', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06719', 'วังงิ้ว', '0752', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06720', 'ลำประดา', '0752', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06721', 'วังงิ้วใต้', '0752', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06722', 'โพทะเล', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06723', 'ท้ายน้ำ', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06724', 'ทะนง', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06725', 'ท่าบัว', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06726', 'ทุ่งน้อย', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06727', 'ท่าขมิ้น', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06728', 'ท่าเสา', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06729', 'บางคลาน', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06730', 'บางลาย', '0753', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06731', 'บึงนาราง', '0753', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06732', 'ท่านั่ง', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06733', 'บ้านน้อย', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06734', 'วัดขวาง', '0753', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06735', 'โพธิ์ไทรงาม', '0753', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06736', 'แหลมรัง', '0753', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06737', 'ห้วยแก้ว', '0753', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06738', 'สามง่าม', '0754', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06739', 'กำแพงดิน', '0754', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06740', 'รังนก', '0754', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06741', 'หนองหลุม', '0754', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06742', 'บ้านนา', '0754', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06743', 'เนินปอ', '0754', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06744', 'หนองโสน', '0754', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06745', 'วังโมกข์', '0754', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06746', 'บึงบัว', '0754', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06747', 'ทับคล้อ', '0755', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06748', 'เขาทราย', '0755', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06749', 'เขาเจ็ดลูก', '0755', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06750', 'ท้ายทุ่ง', '0755', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06751', 'สากเหล็ก', '0756', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06752', 'ท่าเยี่ยม', '0756', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06753', 'คลองทราย', '0756', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06754', 'หนองหญ้าไทร', '0756', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06755', 'วังทับไทร', '0756', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06756', 'ห้วยแก้ว', '0757', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06757', 'โพธิ์ไทรงาม', '0757', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06758', 'แหลมรัง', '0757', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06759', 'บางลาย', '0757', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06760', 'บึงนาราง', '0757', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06761', 'วังงิ้วใต้', '0758', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06762', 'วังงิ้ว', '0758', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06763', 'ห้วยร่วม', '0758', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06764', 'ห้วยพุก', '0758', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06765', 'สำนักขุนเณร', '0758', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06766', 'บ้านนา', '0759', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06767', 'บึงบัว', '0759', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06768', 'วังโมกข์', '0759', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06769', 'หนองหลุม', '0759', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06770', 'ในเมือง', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06771', 'ตะเบาะ', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06772', 'บ้านโตก', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06773', 'สะเดียง', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06774', 'ป่าเลา', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06775', 'นางั่ว', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06776', 'ท่าพล', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06777', 'ดงมูลเหล็ก', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06778', 'บ้านโคก', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06779', 'ชอนไพร', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06780', 'นาป่า', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06781', 'นายม', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06782', 'วังชมภู', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06783', 'น้ำร้อน', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06784', 'ห้วยสะแก', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06785', 'ห้วยใหญ่', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06786', 'ระวิง', '0760', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06787', 'ชนแดน', '0761', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06788', 'ดงขุย', '0761', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06789', 'ท่าข้าม', '0761', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06790', 'พุทธบาท', '0761', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06791', 'ลาดแค', '0761', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06792', 'บ้านกล้วย', '0761', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06793', 'ซับเปิม', '0761', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06794', 'ซับพุทรา', '0761', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06795', 'ตะกุดไร', '0761', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06796', 'ศาลาลาย', '0761', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06797', 'ท้ายดง', '0761', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06798', 'วังโป่ง', '0761', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06799', 'หล่มสัก', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06800', 'วัดป่า', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06801', 'ตาลเดี่ยว', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06802', 'ฝายนาแซง', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06803', 'หนองสว่าง', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06804', 'น้ำเฮี้ย', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06805', 'สักหลง', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06806', 'ท่าอิบุญ', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06807', 'บ้านโสก', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06808', 'บ้านติ้ว', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06809', 'ห้วยไร่', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06810', 'น้ำก้อ', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06811', 'ปากช่อง', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06812', 'น้ำชุน', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06813', 'หนองไขว่', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06814', 'ลานบ่า', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06815', 'บุ่งคล้า', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06816', 'บุ่งน้ำเต้า', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06817', 'บ้านกลาง', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06818', 'ช้างตะลูด', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06819', 'บ้านไร่', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06820', 'ปากดุก', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06821', 'บ้านหวาย', '0762', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06822', 'แคมป์สน', '0762', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06823', 'หล่มเก่า', '0763', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06824', 'นาซำ', '0763', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06825', 'หินฮาว', '0763', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06826', 'บ้านเนิน', '0763', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06827', 'ศิลา', '0763', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06828', 'นาแซง', '0763', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06829', 'วังบาล', '0763', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06830', 'นาเกาะ', '0763', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06831', 'ตาดกลอย', '0763', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06832', 'น้ำหนาว', '0763', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06833', 'ท่าโรง', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06834', 'สระประดู่', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06835', 'สามแยก', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06836', 'โคกปรง', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06837', 'น้ำร้อน', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06838', 'บ่อรัง', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06839', 'พุเตย', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06840', 'พุขาม', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06841', 'ภูน้ำหยด', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06842', 'ซับสมบูรณ์', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06843', 'บึงกระจับ', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06844', 'วังใหญ่', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06845', 'ยางสาว', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06846', 'ซับน้อย', '0764', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06847', 'นาสนุ่น', '0764', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06848', 'คลองกระจัง', '0764', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06849', 'สระกรวด', '0764', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06850', 'ศรีเทพ', '0764', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06851', 'ศรีเทพ', '0765', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06852', 'สระกรวด', '0765', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06853', 'คลองกระจัง', '0765', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06854', 'นาสนุ่น', '0765', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06855', 'โคกสะอาด', '0765', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06856', 'หนองย่างทอย', '0765', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06857', 'ประดู่งาม', '0765', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06858', 'กองทูล', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06859', 'นาเฉลียง', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06860', 'บ้านโภชน์', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06861', 'ท่าแดง', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06862', 'เพชรละคร', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06863', 'บ่อไทย', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06864', 'ห้วยโป่ง', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06865', 'วังท่าดี', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06866', 'บัววัฒนา', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06867', 'หนองไผ่', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06868', 'วังโบสถ์', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06869', 'ยางงาม', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06870', 'ท่าด้วง', '0766', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06871', 'ซับสมอทอด', '0767', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06872', 'ซับไม้แดง', '0767', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06873', 'หนองแจง', '0767', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06874', 'กันจุ', '0767', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06875', 'วังพิกุล', '0767', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06876', 'พญาวัง', '0767', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06877', 'ศรีมงคล', '0767', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06878', 'สระแก้ว', '0767', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06879', 'บึงสามพัน', '0767', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06880', 'น้ำหนาว', '0768', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06881', 'หลักด่าน', '0768', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06882', 'วังกวาง', '0768', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06883', 'โคกมน', '0768', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06884', 'วังโป่ง', '0769', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06885', 'ท้ายดง', '0769', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06886', 'ซับเปิบ', '0769', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06887', 'วังหิน', '0769', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06888', 'วังศาล', '0769', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06889', 'ทุ่งสมอ', '0770', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06890', 'แคมป์สน', '0770', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06891', 'เขาค้อ', '0770', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06892', 'ริมสีม่วง', '0770', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06893', 'สะเดาะพง', '0770', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06894', 'หนองแม่นา', '0770', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06895', 'เข็กน้อย', '0770', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06896', 'หน้าเมือง', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06897', 'เจดีย์หัก', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06898', 'ดอนตะโก', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06899', 'หนองกลางนา', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06900', 'ห้วยไผ่', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06901', 'คุ้งน้ำวน', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06902', 'คุ้งกระถิน', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06903', 'อ่างทอง', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06904', 'โคกหม้อ', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06905', 'สามเรือน', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06906', 'พิกุลทอง', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06907', 'น้ำพุ', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06908', 'ดอนแร่', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06909', 'หินกอง', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06910', 'เขาแร้ง', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06911', 'เกาะพลับพลา', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06912', 'หลุมดิน', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06913', 'บางป่า', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06914', 'พงสวาย', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06915', 'คูบัว', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06916', 'ท่าราบ', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06917', 'บ้านไร่', '0771', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06918', 'จอมบึง', '0772', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06919', 'ปากช่อง', '0772', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06920', 'เบิกไพร', '0772', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06921', 'ด่านทับตะโก', '0772', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06922', 'แก้มอ้น', '0772', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06923', 'รางบัว', '0772', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06924', 'ป่าหวาย', '0772', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06925', 'บ้านผึ้ง', '0772', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06926', 'สวนผึ้ง', '0772', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06927', 'สวนผึ้ง', '0773', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06928', 'ป่าหวาย', '0773', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06929', 'บ้านบึง', '0773', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06930', 'ท่าเคย', '0773', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06931', 'บ้านคา', '0773', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06932', 'หนองพันจันทร์', '0773', -1 )
INSERT INTO tbm_sub_district
VALUES
( '06933', 'ตะนาวศรี', '0773', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06934', 'ดำเนินสะดวก', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06935', 'ประสาทสิทธิ์', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06936', 'ศรีสุราษฎร์', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06937', 'ตาหลวง', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06938', 'ดอนกรวย', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06939', 'ดอนคลัง', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06940', 'บัวงาม', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06941', 'บ้านไร่', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06942', 'แพงพวย', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06943', 'สี่หมื่น', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06944', 'ท่านัด', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06945', 'ขุนพิทักษ์', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06946', 'ดอนไผ่', '0774', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06947', 'บ้านโป่ง', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06948', 'ท่าผา', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06949', 'กรับใหญ่', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06950', 'ปากแรต', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06951', 'หนองกบ', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06952', 'หนองอ้อ', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06953', 'ดอนกระเบื้อง', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06954', 'สวนกล้วย', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06955', 'นครชุมน์', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06956', 'บ้านม่วง', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06957', 'คุ้งพยอม', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06958', 'หนองปลาหมอ', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06959', 'เขาขลุง', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06960', 'เบิกไพร', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06961', 'ลาดบัวขาว', '0775', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06962', 'บางแพ', '0776', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06963', 'วังเย็น', '0776', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06964', 'หัวโพ', '0776', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06965', 'วัดแก้ว', '0776', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06966', 'ดอนใหญ่', '0776', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06967', 'ดอนคา', '0776', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06968', 'โพหัก', '0776', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06969', 'โพธาราม', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06970', 'ดอนกระเบื้อง', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06971', 'หนองโพ', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06972', 'บ้านเลือก', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06973', 'คลองตาคต', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06974', 'บ้านฆ้อง', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06975', 'บ้านสิงห์', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06976', 'ดอนทราย', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06977', 'เจ็ดเสมียน', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06978', 'คลองข่อย', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06979', 'ชำแระ', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06980', 'สร้อยฟ้า', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06981', 'ท่าชุมพล', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06982', 'บางโตนด', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06983', 'เตาปูน', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06984', 'นางแก้ว', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06985', 'ธรรมเสน', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06986', 'เขาชะงุ้ม', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06987', 'หนองกวาง', '0777', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06988', 'ทุ่งหลวง', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06989', 'วังมะนาว', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06990', 'ดอนทราย', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06991', 'หนองกระทุ่ม', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06992', 'ปากท่อ', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06993', 'ป่าไก่', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06994', 'วัดยางงาม', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06995', 'อ่างหิน', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06996', 'บ่อกระดาน', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06997', 'ยางหัก', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06998', 'วันดาว', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '06999', 'ห้วยยางโทน', '0778', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07000', 'เกาะศาลพระ', '0779', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07001', 'จอมประทัด', '0779', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07002', 'วัดเพลง', '0779', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07003', 'บ้านคา', '0780', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07004', 'บ้านบึง', '0780', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07005', 'หนองพันจันทร์', '0780', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07006', 'บ้านเหนือ', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07007', 'บ้านใต้', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07008', 'ปากแพรก', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07009', 'ท่ามะขาม', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07010', 'แก่งเสี้ยน', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07011', 'หนองบัว', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07012', 'ลาดหญ้า', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07013', 'วังด้ง', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07014', 'ช่องสะเดา', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07015', 'หนองหญ้า', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07016', 'เกาะสำโรง', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07017', 'ด่านมะขามเตี้ย', '0782', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07018', 'บ้านเก่า', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07019', 'จรเข้เผือก', '0782', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07020', 'กลอนโด', '0782', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07021', 'วังเย็น', '0782', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07022', 'ลุ่มสุ่ม', '0783', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07023', 'ท่าเสา', '0783', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07024', 'สิงห์', '0783', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07025', 'ไทรโยค', '0783', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07026', 'วังกระแจะ', '0783', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07027', 'ศรีมงคล', '0783', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07028', 'บ้องตี้', '0783', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07029', 'บ่อพลอย', '0784', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07030', 'หนองกุ่ม', '0784', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07031', 'หนองรี', '0784', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07032', 'หนองปรือ', '0784', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07033', 'หลุมรัง', '0784', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07034', 'หนองปลาไหล', '0784', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07035', 'สมเด็จเจริญ', '0784', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07036', 'ช่องด่าน', '0784', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07037', 'หนองกร่าง', '0784', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07038', 'นาสวน', '0785', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07039', 'ด่านแม่แฉลบ', '0785', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07040', 'หนองเป็ด', '0785', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07041', 'ท่ากระดาน', '0785', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07042', 'เขาโจด', '0785', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07043', 'แม่กระบุง', '0785', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07044', 'พงตึก', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07045', 'ยางม่วง', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07046', 'ดอนชะเอม', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07047', 'ท่าไม้', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07048', 'ตะคร้ำเอน', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07049', 'ท่ามะกา', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07050', 'ท่าเรือ', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07051', 'โคกตะบอง', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07052', 'ดอนขมิ้น', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07053', 'อุโลกสี่หมื่น', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07054', 'เขาสามสิบหาบ', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07055', 'พระแท่น', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07056', 'หวายเหนียว', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07057', 'แสนตอ', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07058', 'สนามแย้', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07059', 'ท่าเสา', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07060', 'หนองลาน', '0786', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07061', 'ท่าม่วง', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07062', 'วังขนาย', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07063', 'วังศาลา', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07064', 'ท่าล้อ', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07065', 'หนองขาว', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07066', 'ทุ่งทอง', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07067', 'เขาน้อย', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07068', 'ม่วงชุม', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07069', 'บ้านใหม่', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07070', 'พังตรุ', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07071', 'ท่าตะคร้อ', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07072', 'รางสาลี่', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07073', 'หนองตากยา', '0787', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07074', 'ท่าขนุน', '0788', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07075', 'ปิล๊อก', '0788', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07076', 'หินดาด', '0788', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07077', 'ลิ่นถิ่น', '0788', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07078', 'ชะแล', '0788', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07079', 'ห้วยเขย่ง', '0788', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07080', 'สหกรณ์นิคม', '0788', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07081', 'หนองลู', '0789', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07082', 'ปรังเผล', '0789', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07083', 'ไล่โว่', '0789', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07084', 'พนมทวน', '0790', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07085', 'หนองโรง', '0790', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07086', 'ทุ่งสมอ', '0790', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07087', 'ดอนเจดีย์', '0790', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07088', 'พังตรุ', '0790', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07089', 'รางหวาย', '0790', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07090', 'ดอนแสลบ', '0790', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07091', 'ห้วยกระเจา', '0790', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07092', 'สระลงเรือ', '0790', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07093', 'วังไผ่', '0790', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07094', 'หนองสาหร่าย', '0790', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07095', 'ดอนตาเพชร', '0790', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07096', 'เลาขวัญ', '0791', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07097', 'หนองโสน', '0791', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07098', 'หนองประดู่', '0791', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07099', 'หนองปลิง', '0791', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07100', 'หนองนกแก้ว', '0791', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07101', 'ทุ่งกระบ่ำ', '0791', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07102', 'หนองฝ้าย', '0791', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07103', 'ด่านมะขามเตี้ย', '0792', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07104', 'กลอนโด', '0792', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07105', 'จรเข้เผือก', '0792', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07106', 'หนองไผ่', '0792', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07107', 'หนองปรือ', '0793', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07108', 'หนองปลาไหล', '0793', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07109', 'สมเด็จเจริญ', '0793', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07110', 'ห้วยกระเจา', '0794', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07111', 'วังไผ่', '0794', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07112', 'ดอนแสลบ', '0794', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07113', 'สระลงเรือ', '0794', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07114', 'ท่าพี่เลี้ยง', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07115', 'รั้วใหญ่', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07116', 'ทับตีเหล็ก', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07117', 'ท่าระหัด', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07118', 'ไผ่ขวาง', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07119', 'โคกโคเฒ่า', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07120', 'ดอนตาล', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07121', 'ดอนมะสังข์', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07122', 'พิหารแดง', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07123', 'ดอนกำยาน', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07124', 'ดอนโพธิ์ทอง', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07125', 'บ้านโพธิ์', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07126', 'สระแก้ว', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07127', 'ตลิ่งชัน', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07128', 'บางกุ้ง', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07129', 'ศาลาขาว', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07130', 'สวนแตง', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07131', 'สนามชัย', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07132', 'โพธิ์พระยา', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07133', 'สนามคลี', '0797', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07134', 'เขาพระ', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07135', 'เดิมบาง', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07136', 'นางบวช', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07137', 'เขาดิน', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07138', 'ปากน้ำ', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07139', 'ทุ่งคลี', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07140', 'โคกช้าง', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07141', 'หัวเขา', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07142', 'หัวนา', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07143', 'บ่อกรุ', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07144', 'วังศรีราช', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07145', 'ป่าสะแก', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07146', 'ยางนอน', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07147', 'หนองกระทุ่ม', '0798', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07148', 'องค์พระ', '0798', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07149', 'ห้วยขมิ้น', '0798', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07150', 'ด่านช้าง', '0798', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07151', 'หนองมะค่าโมง', '0798', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07152', 'หนองมะค่าโมง', '0799', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07153', 'ด่านช้าง', '0799', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07154', 'ห้วยขมิ้น', '0799', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07155', 'องค์พระ', '0799', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07156', 'วังคัน', '0799', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07157', 'นิคมกระเสียว', '0799', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07158', 'วังยาว', '0799', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07159', 'โคกคราม', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07160', 'บางปลาม้า', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07161', 'ตะค่า', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07162', 'บางใหญ่', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07163', 'กฤษณา', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07164', 'สาลี', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07165', 'ไผ่กองดิน', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07166', 'องครักษ์', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07167', 'จรเข้ใหญ่', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07168', 'บ้านแหลม', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07169', 'มะขามล้ม', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07170', 'วังน้ำเย็น', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07171', 'วัดโบสถ์', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07172', 'วัดดาว', '0800', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07173', 'ศรีประจันต์', '0801', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07174', 'บ้านกร่าง', '0801', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07175', 'มดแดง', '0801', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07176', 'บางงาม', '0801', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07177', 'ดอนปรู', '0801', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07178', 'ปลายนา', '0801', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07179', 'วังหว้า', '0801', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07180', 'วังน้ำซับ', '0801', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07181', 'วังยาง', '0801', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07182', 'ดอนเจดีย์', '0802', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07183', 'หนองสาหร่าย', '0802', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07184', 'ไร่รถ', '0802', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07185', 'สระกระโจม', '0802', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07186', 'ทะเลบก', '0802', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07187', 'สองพี่น้อง', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07188', 'บางเลน', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07189', 'บางตาเถร', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07190', 'บางตะเคียน', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07191', 'บ้านกุ่ม', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07192', 'หัวโพธิ์', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07193', 'บางพลับ', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07194', 'เนินพระปรางค์', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07195', 'บ้านช้าง', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07196', 'ต้นตาล', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07197', 'ศรีสำราญ', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07198', 'ทุ่งคอก', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07199', 'หนองบ่อ', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07200', 'บ่อสุพรรณ', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07201', 'ดอนมะนาว', '0803', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07202', 'ย่านยาว', '0804', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07203', 'วังลึก', '0804', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07204', 'สามชุก', '0804', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07205', 'หนองผักนาก', '0804', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07206', 'บ้านสระ', '0804', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07207', 'หนองสะเดา', '0804', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07208', 'กระเสียว', '0804', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07209', 'แจงงาม', '0804', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07210', 'หนองโพธิ์', '0804', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07211', 'หนองราชวัตร', '0804', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07212', 'หนองหญ้าไซ', '0804', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07213', 'อู่ทอง', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07214', 'สระยายโสม', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07215', 'จรเข้สามพัน', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07216', 'บ้านดอน', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07217', 'ยุ้งทะลาย', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07218', 'ดอนมะเกลือ', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07219', 'หนองโอ่ง', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07220', 'ดอนคา', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07221', 'พลับพลาไชย', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07222', 'บ้านโข้ง', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07223', 'เจดีย์', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07224', 'สระพังลาน', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07225', 'กระจัน', '0805', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07226', 'หนองหญ้าไซ', '0806', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07227', 'หนองราชวัตร', '0806', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07228', 'หนองโพธิ์', '0806', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07229', 'แจงงาม', '0806', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07230', 'หนองขาม', '0806', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07231', 'ทัพหลวง', '0806', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07232', 'พระปฐมเจดีย์', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07233', 'บางแขม', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07234', 'พระประโทน', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07235', 'ธรรมศาลา', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07236', 'ตาก้อง', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07237', 'มาบแค', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07238', 'สนามจันทร์', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07239', 'ดอนยายหอม', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07240', 'ถนนขาด', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07241', 'บ่อพลับ', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07242', 'นครปฐม', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07243', 'วังตะกู', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07244', 'หนองปากโลง', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07245', 'สามควายเผือก', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07246', 'ทุ่งน้อย', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07247', 'หนองดินแดง', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07248', 'วังเย็น', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07249', 'โพรงมะเดื่อ', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07250', 'ลำพยา', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07251', 'สระกะเทียม', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07252', 'สวนป่าน', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07253', 'ห้วยจรเข้', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07254', 'ทัพหลวง', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07255', 'หนองงูเหลือม', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07256', 'บ้านยาง', '0807', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07257', 'ทุ่งกระพังโหม', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07258', 'กระตีบ', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07259', 'ทุ่งลูกนก', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07260', 'ห้วยขวาง', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07261', 'ทุ่งขวาง', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07262', 'สระสี่มุม', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07263', 'ทุ่งบัว', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07264', 'ดอนข่อย', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07265', 'สระพัฒนา', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07266', 'ห้วยหมอนทอง', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07267', 'ห้วยม่วง', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07268', 'กำแพงแสน', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07269', 'รางพิกุล', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07270', 'หนองกระทุ่ม', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07271', 'วังน้ำเขียว', '0808', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07272', 'นครชัยศรี', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07273', 'บางกระเบา', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07274', 'วัดแค', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07275', 'ท่าตำหนัก', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07276', 'บางแก้ว', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07277', 'ท่ากระชับ', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07278', 'ขุนแก้ว', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07279', 'ท่าพระยา', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07280', 'พะเนียด', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07281', 'บางระกำ', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07282', 'โคกพระเจดีย์', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07283', 'ศรีษะทอง', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07284', 'แหลมบัว', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07285', 'ศรีมหาโพธิ์', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07286', 'สัมปทวน', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07287', 'วัดสำโรง', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07288', 'ดอนแฝก', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07289', 'ห้วยพลู', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07290', 'วัดละมุด', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07291', 'บางพระ', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07292', 'บางแก้วฟ้า', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07293', 'ลานตากฟ้า', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07294', 'งิ้วราย', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07295', 'ไทยาวาส', '0809', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07296', 'ศาลายา', '0809', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07297', 'มหาสวัสดิ์', '0809', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07298', 'คลองโยง', '0809', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07299', 'มหาสวัสดิ์', '0809', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07300', 'คลองโยง', '0809', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07301', 'ศาลายา', '0809', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07302', 'สามง่าม', '0810', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07303', 'ห้วยพระ', '0810', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07304', 'ลำเหย', '0810', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07305', 'ดอนพุทรา', '0810', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07306', 'บ้านหลวง', '0810', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07307', 'ดอนรวก', '0810', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07308', 'ห้วยด้วน', '0810', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07309', 'ลำลูกบัว', '0810', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07310', 'บางเลน', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07311', 'บางปลา', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07312', 'บางหลวง', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07313', 'บางภาษี', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07314', 'บางระกำ', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07315', 'บางไทรป่า', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07316', 'หินมูล', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07317', 'ไทรงาม', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07318', 'ดอนตูม', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07319', 'นิลเพชร', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07320', 'บัวปากท่า', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07321', 'คลองนกกระทุง', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07322', 'นราภิรมย์', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07323', 'ลำพญา', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07324', 'ไผ่หูช้าง', '0811', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07325', 'ท่าข้าม', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07326', 'ทรงคนอง', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07327', 'หอมเกร็ด', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07328', 'บางกระทึก', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07329', 'บางเตย', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07330', 'สามพราน', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07331', 'บางช้าง', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07332', 'ไร่ขิง', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07333', 'ท่าตลาด', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07334', 'กระทุ่มล้ม', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07335', 'คลองใหม่', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07336', 'ตลาดจินดา', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07337', 'คลองจินดา', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07338', 'ยายชา', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07339', 'บ้านใหม่', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07340', 'อ้อมใหญ่', '0812', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07341', 'ศาลายา', '0813', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07342', 'คลองโยง', '0813', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07343', 'มหาสวัสดิ์', '0813', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07344', 'มหาชัย', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07345', 'ท่าฉลอม', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07346', 'โกรกกราก', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07347', 'บ้านบ่อ', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07348', 'บางโทรัด', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07349', 'กาหลง', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07350', 'นาโคก', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07351', 'ท่าจีน', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07352', 'นาดี', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07353', 'ท่าทราย', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07354', 'คอกกระบือ', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07355', 'บางน้ำจืด', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07356', 'พันท้ายนรสิงห์', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07357', 'โคกขาม', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07358', 'บ้านเกาะ', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07359', 'บางกระเจ้า', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07360', 'บางหญ้าแพรก', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07361', 'ชัยมงคล', '0814', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07362', 'ตลาดกระทุ่มแบน', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07363', 'อ้อมน้อย', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07364', 'ท่าไม้', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07365', 'สวนหลวง', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07366', 'บางยาง', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07367', 'คลองมะเดื่อ', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07368', 'หนองนกไข่', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07369', 'ดอนไก่ดี', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07370', 'แคราย', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07371', 'ท่าเสา', '0815', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07372', 'บ้านแพ้ว', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07373', 'หลักสาม', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07374', 'ยกกระบัตร', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07375', 'โรงเข้', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07376', 'หนองสองห้อง', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07377', 'หนองบัว', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07378', 'หลักสอง', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07379', 'เจ็ดริ้ว', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07380', 'คลองตัน', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07381', 'อำแพง', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07382', 'สวนส้ม', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07383', 'เกษตรพัฒนา', '0816', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07384', 'แม่กลอง', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07385', 'บางขันแตก', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07386', 'ลาดใหญ่', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07387', 'บ้านปรก', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07388', 'บางแก้ว', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07389', 'ท้ายหาด', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07390', 'แหลมใหญ่', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07391', 'คลองเขิน', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07392', 'คลองโคน', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07393', 'นางตะเคียน', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07394', 'บางจะเกร็ง', '0817', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07395', 'กระดังงา', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07396', 'บางสะแก', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07397', 'บางยี่รงค์', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07398', 'โรงหีบ', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07399', 'บางคนที', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07400', 'ดอนมะโนรา', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07401', 'บางพรม', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07402', 'บางกุ้ง', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07403', 'จอมปลวก', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07404', 'บางนกแขวก', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07405', 'ยายแพง', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07406', 'บางกระบือ', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07407', 'บ้านปราโมทย์', '0818', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07408', 'อัมพวา', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07409', 'สวนหลวง', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07410', 'ท่าคา', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07411', 'วัดประดู่', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07412', 'เหมืองใหม่', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07413', 'บางช้าง', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07414', 'แควอ้อม', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07415', 'ปลายโพงพาง', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07416', 'บางแค', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07417', 'แพรกหนามแดง', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07418', 'ยี่สาร', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07419', 'บางนางลี่', '0819', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07420', 'ท่าราบ', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07421', 'คลองกระแชง', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07422', 'บางจาน', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07423', 'นาพันสาม', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07424', 'ธงชัย', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07425', 'บ้านกุ่ม', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07426', 'หนองโสน', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07427', 'ไร่ส้ม', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07428', 'เวียงคอย', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07429', 'บางจาก', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07430', 'บ้านหม้อ', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07431', 'ต้นมะม่วง', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07432', 'ช่องสะแก', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07433', 'นาวุ้ง', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07434', 'สำมะโรง', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07435', 'โพพระ', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07436', 'หาดเจ้าสำราญ', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07437', 'หัวสะพาน', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07438', 'ต้นมะพร้าว', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07439', 'วังตะโก', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07440', 'โพไร่หวาน', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07441', 'ดอนยาง', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07442', 'หนองขนาน', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07443', 'หนองพลับ', '0820', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07444', 'มาตยาวงศ์', '0820', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07445', 'เขาย้อย', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07446', 'สระพัง', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07447', 'บางเค็ม', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07448', 'ทับคาง', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07449', 'หนองปลาไหล', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07450', 'หนองปรง', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07451', 'หนองชุมพล', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07452', 'ห้วยโรง', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07453', 'ห้วยท่าช้าง', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07454', 'หนองชุมพลเหนือ', '0821', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07455', 'ยางน้ำกลักใต้', '0821', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07456', 'ยางน้ำกลักเหนือ', '0821', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07457', 'หนองหญ้าปล้อง', '0821', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07458', 'หนองหญ้าปล้อง', '0822', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07459', 'ยางน้ำกลัดเหนือ', '0822', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07460', 'ยางน้ำกลัดใต้', '0822', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07461', 'ท่าตะคร้อ', '0822', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07462', 'ชะอำ', '0823', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07463', 'บางเก่า', '0823', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07464', 'นายาง', '0823', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07465', 'เขาใหญ่', '0823', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07466', 'หนองศาลา', '0823', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07467', 'ห้วยทรายเหนือ', '0823', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07468', 'ไร่ใหม่พัฒนา', '0823', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07469', 'สามพระยา', '0823', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07470', 'ดอนขุนห้วย', '0823', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07471', 'ท่ายาง', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07472', 'ท่าคอย', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07473', 'ยางหย่อง', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07474', 'หนองจอก', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07475', 'มาบปลาเค้า', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07476', 'ท่าไม้รวก', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07477', 'วังไคร้', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07478', 'วังจันทร์', '0824', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07479', 'สองพี่น้อง', '0824', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07480', 'แก่งกระจาน', '0824', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07481', 'กลัดหลวง', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07482', 'ปึกเตียน', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07483', 'เขากระปุก', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07484', 'ท่าแลง', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07485', 'บ้านในดง', '0824', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07486', 'สระปลาดู่', '0824', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07487', 'บางเมือง', '0824', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07488', 'นาไพร', '0824', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07489', 'วังจันทร์', '0824', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07490', 'สองพี่น้อง', '0824', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07491', 'แก่งกระจาน', '0824', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07492', 'บ้านลาด', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07493', 'บ้านหาด', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07494', 'บ้านทาน', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07495', 'ตำหรุ', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07496', 'สมอพลือ', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07497', 'ไร่มะขาม', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07498', 'ท่าเสน', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07499', 'หนองกระเจ็ด', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07500', 'หนองกะปุ', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07501', 'ลาดโพธิ์', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07502', 'สะพานไกร', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07503', 'ไร่โคก', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07504', 'โรงเข้', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07505', 'ไร่สะท้อน', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07506', 'ห้วยข้อง', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07507', 'ท่าช้าง', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07508', 'ถ้ำรงค์', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07509', 'ห้วยลึก', '0825', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07510', 'บ้านแหลม', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07511', 'บางขุนไทร', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07512', 'ปากทะเล', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07513', 'บางแก้ว', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07514', 'แหลมผักเบี้ย', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07515', 'บางตะบูน', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07516', 'บางตะบูนออก', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07517', 'บางครก', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07518', 'ท่าแร้ง', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07519', 'ท่าแร้งออก', '0826', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07520', 'แก่งกระจาน', '0827', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07521', 'สองพี่น้อง', '0827', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07522', 'วังจันทร์', '0827', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07523', 'ป่าเด็ง', '0827', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07524', 'พุสวรรค์', '0827', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07525', 'ห้วยแม่เพรียง', '0827', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07526', 'ประจวบคีรีขันธ์', '0828', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07527', 'เกาะหลัก', '0828', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07528', 'คลองวาฬ', '0828', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07529', 'ห้วยทราย', '0828', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07530', 'อ่าวน้อย', '0828', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07531', 'บ่อนอก', '0828', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07532', 'กุยบุรี', '0829', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07533', 'กุยเหนือ', '0829', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07534', 'เขาแดง', '0829', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07535', 'ดอนยายหนู', '0829', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07536', 'ไร่ใหม่', '0829', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07537', 'สามกระทาย', '0829', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07538', 'หาดขาม', '0829', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07539', 'ทับสะแก', '0830', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07540', 'อ่างทอง', '0830', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07541', 'นาหูกวาง', '0830', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07542', 'เขาล้าน', '0830', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07543', 'ห้วยยาง', '0830', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07544', 'แสงอรุณ', '0830', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07545', 'กำเนิดนพคุณ', '0831', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07546', 'พงศ์ประศาสน์', '0831', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07547', 'ร่อนทอง', '0831', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07548', 'ธงชัย', '0831', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07549', 'ชัยเกษม', '0831', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07550', 'ทองมงคล', '0831', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07551', 'แม่รำพึง', '0831', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07552', 'ปากแพรก', '0832', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07553', 'บางสะพาน', '0832', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07554', 'ทรายทอง', '0832', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07555', 'ช้างแรก', '0832', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07556', 'ไชยราช', '0832', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07557', 'ปราณบุรี', '0833', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07558', 'เขาน้อย', '0833', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07559', 'ศิลาลอย', '0833', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07560', 'ปากน้ำปราณ', '0833', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07561', 'สามร้อยยอด', '0833', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07562', 'ไร่เก่า', '0833', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07563', 'หนองตาแต้ม', '0833', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07564', 'วังก์พง', '0833', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07565', 'เขาจ้าว', '0833', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07566', 'หัวหิน', '0834', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07567', 'หนองแก', '0834', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07568', 'หินเหล็กไฟ', '0834', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07569', 'หนองพลับ', '0834', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07570', 'ทับใต้', '0834', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07571', 'ห้วยสัตว์ใหญ่', '0834', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07572', 'บึงนคร', '0834', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07573', 'สามร้อยยอด', '0835', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07574', 'ศิลาลอย', '0835', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07575', 'ไร่เก่า', '0835', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07576', 'ศาลาลัย', '0835', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07577', 'ไร่ใหม่', '0835', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07578', 'ในเมือง', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07579', 'ท่าวัง', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07580', 'คลัง', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07581', 'นา', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07582', 'ศาลามีชัย', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07583', 'ท่าไร่', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07584', 'ปากนคร', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07585', 'นาทราย', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07586', 'นาพรุ', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07587', 'ช้างซ้าย', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07588', 'นาสาร', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07589', 'กำแพงเซา', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07590', 'ไชยมนตรี', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07591', 'มะม่วงสองต้น', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07592', 'นาเคียน', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07593', 'ท่างิ้ว', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07594', 'ท้ายสำเภา', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07595', 'โพธิ์เสด็จ', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07596', 'บางจาก', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07597', 'ปากพูน', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07598', 'ท่าซัก', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07599', 'ท่าเรือ', '0836', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07600', 'อินคีรี', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07601', 'พรหมโลก', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07602', 'ศาลามีชัย', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07603', 'นา', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07604', 'บ้านเกาะ', '0836', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07605', 'พรหมโลก', '0837', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07606', 'บ้านเกาะ', '0837', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07607', 'อินคีรี', '0837', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07608', 'ทอนหงส์', '0837', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07609', 'นาเรียง', '0837', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07610', 'เขาแก้ว', '0838', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07611', 'ลานสกา', '0838', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07612', 'ท่าดี', '0838', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07613', 'กำโลน', '0838', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07614', 'ขุนทะเล', '0838', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07615', 'ฉวาง', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07616', 'ช้างกลาง', '0839', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07617', 'ละอาย', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07618', 'นาแว', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07619', 'ไม้เรียง', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07620', 'กะเปียด', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07621', 'นากะชะ', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07622', 'ถ้ำพรรณรา', '0839', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07623', 'ห้วยปริก', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07624', 'ไสหร้า', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07625', 'หลักช้าง', '0839', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07626', 'สวนขัน', '0839', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07627', 'คลองเส', '0839', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07628', 'ดุสิต', '0839', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07629', 'นาเขลียง', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07630', 'จันดี', '0839', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07631', 'พิปูน', '0840', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07632', 'กะทูน', '0840', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07633', 'เขาพระ', '0840', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07634', 'ยางค้อม', '0840', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07635', 'ควนกลาง', '0840', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07636', 'เชียรใหญ่', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07637', 'เชียรเขา', '0841', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07638', 'ท่าขนาน', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07639', 'บ้านกลาง', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07640', 'บ้านเนิน', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07641', 'ไสหมาก', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07642', 'ท้องลำเจียก', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07643', 'ดอนตรอ', '0841', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07644', 'สวนหลวง', '0841', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07645', 'เสือหึง', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07646', 'การะเกด', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07647', 'เขาพระบาท', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07648', 'แม่เจ้าอยู่หัว', '0841', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07649', 'ชะอวด', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07650', 'ท่าเสม็ด', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07651', 'ท่าประจะ', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07652', 'เคร็ง', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07653', 'วังอ่าง', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07654', 'บ้านตูล', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07655', 'ขอนหาด', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07656', 'เกาะขันธ์', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07657', 'ควนหนองหงษ์', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07658', 'เขาพระทอง', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07659', 'นางหลง', '0842', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07660', 'บ้านควนมุด', '0842', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07661', 'บ้านชะอวด', '0842', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07662', 'ท่าศาลา', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07663', 'กลาย', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07664', 'ท่าขึ้น', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07665', 'หัวตะพาน', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07666', 'กะหรอ', '0843', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07667', 'สระแก้ว', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07668', 'โมคลาน', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07669', 'นบพิตำ', '0843', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07670', 'ไทยบุรี', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07671', 'ดอนตะโก', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07672', 'ตลิ่งชัน', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07673', 'กรุงชิง', '0843', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07674', 'โพธิ์ทอง', '0843', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07675', 'นาเหรง', '0843', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07676', 'ปากแพรก', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07677', 'ชะมาย', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07678', 'หนองหงส์', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07679', 'ควนกรด', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07680', 'นาไม้ไผ่', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07681', 'นาหลวงเสน', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07682', 'เขาโร', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07683', 'กะปาง', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07684', 'ที่วัง', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07685', 'น้ำตก', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07686', 'ถ้ำใหญ่', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07687', 'นาโพธิ์', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07688', 'เขาขาว', '0844', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07689', 'วังหิน', '0844', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07690', 'บ้านลำนาว', '0844', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07691', 'บางขัน', '0844', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07692', 'แก้วแสน', '0844', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07693', 'ทุ่งสง', '0844', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07694', 'นาบอน', '0844', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07695', 'นาบอน', '0845', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07696', 'ทุ่งสง', '0845', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07697', 'แก้วแสน', '0845', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07698', 'ท่ายาง', '0846', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07699', 'ทุ่งสัง', '0846', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07700', 'ทุ่งใหญ่', '0846', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07701', 'กุแหระ', '0846', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07702', 'ปริก', '0846', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07703', 'บางรูป', '0846', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07704', 'กรุงหยัน', '0846', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07705', 'ปากพนัง', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07706', 'คลองน้อย', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07707', 'ป่าระกำ', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07708', 'ชะเมา', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07709', 'คลองกระบือ', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07710', 'เกาะทวด', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07711', 'บ้านใหม่', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07712', 'หูล่อง', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07713', 'แหลมตะลุมพุก', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07714', 'ปากพนังฝั่งตะวันตก', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07715', 'บางศาลา', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07716', 'บางพระ', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07717', 'บางตะพง', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07718', 'ปากพนังฝั่งตะวันออก', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07719', 'บ้านเพิง', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07720', 'ท่าพยา', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07721', 'ปากแพรก', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07722', 'ขนาบนาก', '0847', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07723', 'ร่อนพิบูลย์', '0848', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07724', 'หินตก', '0848', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07725', 'เสาธง', '0848', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07726', 'ควนเกย', '0848', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07727', 'ควนพัง', '0848', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07728', 'ควนชุม', '0848', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07729', 'สามตำบล', '0848', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07730', 'ทางพูน', '0848', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07731', 'นาหมอบุญ', '0848', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07732', 'ทุ่งโพธิ์', '0848', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07733', 'ควนหนองคว้า', '0848', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07734', 'สิชล', '0849', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07735', 'ทุ่งปรัง', '0849', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07736', 'ฉลอง', '0849', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07737', 'เสาเภา', '0849', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07738', 'เปลี่ยน', '0849', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07739', 'สี่ขีด', '0849', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07740', 'เทพราช', '0849', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07741', 'เขาน้อย', '0849', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07742', 'ทุ่งใส', '0849', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07743', 'ขนอม', '0850', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07744', 'ควนทอง', '0850', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07745', 'ท้องเนียน', '0850', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07746', 'หัวไทร', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07747', 'หน้าสตน', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07748', 'ทรายขาว', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07749', 'แหลม', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07750', 'เขาพังไกร', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07751', 'บ้านราม', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07752', 'บางนบ', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07753', 'ท่าซอม', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07754', 'ควนชะลิก', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07755', 'รามแก้ว', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07756', 'เกาะเพชร', '0851', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07757', 'บางขัน', '0852', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07758', 'บ้านลำนาว', '0852', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07759', 'วังหิน', '0852', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07760', 'บ้านนิคม', '0852', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07761', 'ถ้ำพรรณรา', '0853', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07762', 'คลองเส', '0853', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07763', 'ดุสิต', '0853', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07764', 'บ้านควนมุด', '0854', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07765', 'บ้านชะอวด', '0854', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07766', 'ควนหนองคว้า', '0854', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07767', 'ทุ่งโพธิ์', '0854', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07768', 'นาหมอบุญ', '0854', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07769', 'สามตำบล', '0854', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07770', 'นาพรุ', '0855', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07771', 'นาสาร', '0855', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07772', 'ท้ายสำเภา', '0855', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07773', 'ช้างซ้าย', '0855', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07774', 'นบพิตำ', '0856', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07775', 'กรุงชิง', '0856', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07776', 'กะหรอ', '0856', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07777', 'นาเหรง', '0856', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07778', 'ช้างกลาง', '0857', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07779', 'หลักช้าง', '0857', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07780', 'สวนขัน', '0857', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07781', 'เชียรเขา', '0858', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07782', 'ดอนตรอ', '0858', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07783', 'สวนหลวง', '0858', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07784', 'ทางพูน', '0858', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07785', 'ปากน้ำ', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07786', 'กระบี่ใหญ่', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07787', 'กระบี่น้อย', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07788', 'เกาะศรีบอยา', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07789', 'เขาคราม', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07790', 'เขาทอง', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07791', 'คลองขนาน', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07792', 'คลองเขม้า', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07793', 'โคกยาง', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07794', 'ตลิ่งชัน', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07795', 'ทับปริก', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07796', 'ปกาสัย', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07797', 'ห้วยยูง', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07798', 'เหนือคลอง', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07799', 'ไสไทย', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07800', 'อ่าวนาง', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07801', 'หนองทะเล', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07802', 'คลองประสงค์', '0864', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07803', 'เกาะศรีบายอ', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07804', 'คลองเขม้า', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07805', 'โคกยาง', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07806', 'ห้วยยูง', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07807', 'คลองขนาน', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07808', 'ตลิ่งชัน', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07809', 'ปกาสัย', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07810', 'เหนือคลอง', '0864', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07811', 'เขาพนม', '0865', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07812', 'เขาดิน', '0865', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07813', 'สินปุน', '0865', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07814', 'พรุเตียว', '0865', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07815', 'หน้าเขา', '0865', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07816', 'โคกหาร', '0865', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07817', 'เกาะลันตาใหญ่', '0866', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07818', 'เกาะลันตาน้อย', '0866', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07819', 'เกาะกลาง', '0866', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07820', 'คลองยาง', '0866', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07821', 'ศาลาด่าน', '0866', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07822', 'คลองท่อมใต้', '0867', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07823', 'คลองท่อมเหนือ', '0867', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07824', 'คลองพน', '0867', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07825', 'ทรายขาว', '0867', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07826', 'ห้วยน้ำขาว', '0867', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07827', 'พรุดินนา', '0867', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07828', 'เพหลา', '0867', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07829', 'ลำทับ', '0867', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07830', 'อ่าวลึกใต้', '0868', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07831', 'แหลมสัก', '0868', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07832', 'นาเหนือ', '0868', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07833', 'คลองหิน', '0868', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07834', 'อ่าวลึกน้อย', '0868', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07835', 'อ่าวลึกเหนือ', '0868', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07836', 'เขาใหญ่', '0868', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07837', 'คลองยา', '0868', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07838', 'บ้านกลาง', '0868', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07839', 'เขาเขน', '0868', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07840', 'เขาต่อ', '0868', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07841', 'ปลายพระยา', '0868', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07842', 'ปลายพระยา', '0869', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07843', 'เขาเขน', '0869', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07844', 'เขาต่อ', '0869', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07845', 'คีรีวง', '0869', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07846', 'ลำทับ', '0870', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07847', 'ดินอุดม', '0870', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07848', 'ทุ่งไทรทอง', '0870', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07849', 'ดินแดง', '0870', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07850', 'เหนือคลอง', '0871', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07851', 'เกาะศรีบอยา', '0871', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07852', 'คลองขนาน', '0871', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07853', 'คลองเขม้า', '0871', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07854', 'โคกยาง', '0871', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07855', 'ตลิ่งชัน', '0871', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07856', 'ปกาสัย', '0871', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07857', 'ห้วยยูง', '0871', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07858', 'ท้ายช้าง', '0872', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07859', 'นบปริง', '0872', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07860', 'ถ้ำน้ำผุด', '0872', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07861', 'บางเตย', '0872', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07862', 'ตากแดด', '0872', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07863', 'สองแพรก', '0872', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07864', 'ทุ่งคาโงก', '0872', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07865', 'เกาะปันหยี', '0872', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07866', 'ป่ากอ', '0872', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07867', 'เกาะยาวใหญ่', '0872', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07868', 'เกาะยาวน้อย', '0872', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07869', 'เกาะยาวน้อย', '0873', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07870', 'เกาะยาวใหญ่', '0873', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07871', 'พรุใน', '0873', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07872', 'กะปง', '0874', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07873', 'ท่านา', '0874', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07874', 'เหมาะ', '0874', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07875', 'เหล', '0874', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07876', 'รมณีย์', '0874', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07877', 'ถ้ำ', '0875', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07878', 'กระโสม', '0875', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07879', 'กะไหล', '0875', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07880', 'ท่าอยู่', '0875', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07881', 'หล่อยูง', '0875', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07882', 'โคกกลอย', '0875', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07883', 'คลองเคียน', '0875', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07884', 'ตะกั่วป่า', '0876', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07885', 'บางนายสี', '0876', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07886', 'บางไทร', '0876', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07887', 'บางม่วง', '0876', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07888', 'ตำตัว', '0876', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07889', 'โคกเคียน', '0876', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07890', 'คึกคัก', '0876', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07891', 'เกาะคอเขา', '0876', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07892', 'คุระ', '0877', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07893', 'บางวัน', '0877', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07894', 'เกาะพระทอง', '0877', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07895', 'เกาะคอเขา', '0877', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07896', 'แม่นางขาว', '0877', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07897', 'ทับปุด', '0878', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07898', 'มะรุ่ย', '0878', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07899', 'บ่อแสน', '0878', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07900', 'ถ้ำทองหลาง', '0878', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07901', 'โคกเจริญ', '0878', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07902', 'บางเหรียง', '0878', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07903', 'ท้ายเหมือง', '0879', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07904', 'นาเตย', '0879', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07905', 'บางทอง', '0879', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07906', 'ทุ่งมะพร้าว', '0879', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07907', 'ลำภี', '0879', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07908', 'ลำแก่น', '0879', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07909', 'ตลาดใหญ่', '0880', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07910', 'ตลาดเหนือ', '0880', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07911', 'เกาะแก้ว', '0880', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07912', 'รัษฎา', '0880', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07913', 'วิชิต', '0880', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07914', 'ฉลอง', '0880', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07915', 'ราไวย์', '0880', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07916', 'กะรน', '0880', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07917', 'กะทู้', '0881', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07918', 'ป่าตอง', '0881', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07919', 'กมลา', '0881', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07920', 'เทพกระษัตรี', '0882', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07921', 'ศรีสุนทร', '0882', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07922', 'เชิงทะเล', '0882', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07923', 'ป่าคลอก', '0882', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07924', 'ไม้ขาว', '0882', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07925', 'สาคู', '0882', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07926', 'ตลาด', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07927', 'มะขามเตี้ย', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07928', 'วัดประดู่', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07929', 'ขุนทะเล', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07930', 'บางใบไม้', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07931', 'บางชนะ', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07932', 'คลองน้อย', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07933', 'บางไทร', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07934', 'บางโพธิ์', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07935', 'บางกุ้ง', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07936', 'คลองฉนาก', '0884', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07937', 'ท่าทองใหม่', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07938', 'ท่าทอง', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07939', 'กะแดะ', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07940', 'ทุ่งกง', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07941', 'กรูด', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07942', 'ช้างซ้าย', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07943', 'พลายวาส', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07944', 'ป่าร่อน', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07945', 'ตะเคียนทอง', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07946', 'ช้างขวา', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07947', 'ท่าอุแท', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07948', 'ทุ่งรัง', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07949', 'คลองสระ', '0885', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07950', 'ดอนสัก', '0886', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07951', 'ชลคราม', '0886', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07952', 'ไชยคราม', '0886', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07953', 'ปากแพรก', '0886', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07954', 'อ่างทอง', '0887', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07955', 'ลิปะน้อย', '0887', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07956', 'ตลิ่งงาม', '0887', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07957', 'หน้าเมือง', '0887', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07958', 'มะเร็ต', '0887', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07959', 'บ่อผุด', '0887', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07960', 'แม่น้ำ', '0887', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07961', 'เกาะพะงัน', '0888', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07962', 'บ้านใต้', '0888', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07963', 'เกาะเต่า', '0888', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07964', 'ตลาดไชยา', '0889', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07965', 'พุมเรียง', '0889', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07966', 'เลม็ด', '0889', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07967', 'เวียง', '0889', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07968', 'ทุ่ง', '0889', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07969', 'ป่าเว', '0889', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07970', 'ตะกรบ', '0889', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07971', 'โมถ่าย', '0889', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07972', 'ปากหมาก', '0889', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07973', 'ท่าชนะ', '0890', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07974', 'สมอทอง', '0890', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07975', 'ประสงค์', '0890', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07976', 'คันธุลี', '0890', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07977', 'วัง', '0890', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07978', 'คลองพา', '0890', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07979', 'ท่าขนอน', '0891', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07980', 'บ้านยาง', '0891', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07981', 'น้ำหัก', '0891', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07982', 'ตะกุกใต้', '0891', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07983', 'ตะกุกเหนือ', '0891', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07984', 'กะเปา', '0891', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07985', 'ท่ากระดาน', '0891', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07986', 'ย่านยาว', '0891', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07987', 'ถ้ำสิงขร', '0891', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07988', 'บ้านทำเนียบ', '0891', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07989', 'ตะกุดใต้', '0891', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07990', 'เขาวง', '0892', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07991', 'พะแสง', '0892', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07992', 'พรุไทย', '0892', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07993', 'เขาพัง', '0892', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07994', 'ไกรสร', '0892', -1 )
INSERT INTO tbm_sub_district
VALUES
( '07995', 'พนม', '0893', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07996', 'ต้นยวน', '0893', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07997', 'คลองศก', '0893', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07998', 'พลูเถื่อน', '0893', 1 )
INSERT INTO tbm_sub_district
VALUES
( '07999', 'พังกาญจน์', '0893', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08000', 'คลองชะอุ่น', '0893', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08001', 'ท่าฉาง', '0894', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08002', 'ท่าเคย', '0894', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08003', 'คลองไทร', '0894', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08004', 'เขาถ่าน', '0894', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08005', 'เสวียด', '0894', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08006', 'ปากฉลุย', '0894', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08007', 'นาสาร', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08008', 'พรุพี', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08009', 'ทุ่งเตา', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08010', 'ลำพูน', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08011', 'ท่าชี', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08012', 'ควนศรี', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08013', 'ควนสุบรรณ', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08014', 'คลองปราบ', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08015', 'น้ำพุ', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08016', 'ทุ่งเตาใหม่', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08017', 'เพิ่มพูนทรัพย์', '0895', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08018', 'ท่าเรือ', '0895', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08019', 'บ้านนา', '0895', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08020', 'บ้านนา', '0896', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08021', 'ท่าเรือ', '0896', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08022', 'ทรัพย์ทวี', '0896', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08023', 'นาใต้', '0896', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08024', 'เคียนซา', '0897', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08025', 'พ่วงพรมคร', '0897', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08026', 'เขาตอก', '0897', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08027', 'อรัญคามวารี', '0897', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08028', 'บ้านเสด็จ', '0897', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08029', 'เวียงสระ', '0898', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08030', 'บ้านส้อง', '0898', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08031', 'คลองฉนวน', '0898', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08032', 'ทุ่งหลวง', '0898', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08033', 'เขานิพันธ์', '0898', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08034', 'อิปัน', '0899', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08035', 'สินปุน', '0899', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08036', 'บางสวรรค์', '0899', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08037', 'ไทรขึง', '0899', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08038', 'สินเจริญ', '0899', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08039', 'ไทรโสภา', '0899', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08040', 'สาคู', '0899', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08041', 'ชัยบุรี', '0899', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08042', 'สองแพรก', '0899', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08043', 'ท่าข้าม', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08044', 'ท่าสะท้อน', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08045', 'ลีเล็ด', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08046', 'บางมะเดื่อ', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08047', 'บางเดือน', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08048', 'ท่าโรงช้าง', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08049', 'กรูด', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08050', 'พุนพิน', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08051', 'บางงอน', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08052', 'ศรีวิชัย', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08053', 'น้ำรอบ', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08054', 'มะลวน', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08055', 'หัวเตย', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08056', 'หนองไทร', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08057', 'เขาหัวควาย', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08058', 'ตะปาน', '0900', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08059', 'คลองไทร', '0900', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08060', 'สองแพรก', '0901', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08061', 'ชัยบุรี', '0901', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08062', 'คลองน้อย', '0901', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08063', 'ไทรทอง', '0901', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08064', 'ตะกุกใต้', '0902', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08065', 'ตะกุกเหนือ', '0902', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08066', 'เขานิเวศน์', '0905', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08067', 'ราชกรูด', '0905', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08068', 'หงาว', '0905', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08069', 'บางริ้น', '0905', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08070', 'ปากน้ำ', '0905', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08071', 'บางนอน', '0905', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08072', 'หาดส้มแป้น', '0905', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08073', 'ทรายแดง', '0905', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08074', 'เกาะพยาม', '0905', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08075', 'ละอุ่นใต้', '0906', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08076', 'ละอุ่นเหนือ', '0906', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08077', 'บางพระใต้', '0906', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08078', 'บางพระเหนือ', '0906', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08079', 'บางแก้ว', '0906', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08080', 'ในวงเหนือ', '0906', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08081', 'ในวงใต้', '0906', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08082', 'ม่วงกลวง', '0907', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08083', 'กะเปอร์', '0907', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08084', 'เชี่ยวเหลียง', '0907', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08085', 'บ้านนา', '0907', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08086', 'บางหิน', '0907', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08087', 'นาคา', '0907', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08088', 'กำพวน', '0907', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08089', 'น้ำจืด', '0908', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08090', 'น้ำจืดน้อย', '0908', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08091', 'มะมุ', '0908', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08092', 'ปากจั่น', '0908', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08093', 'ลำเลียง', '0908', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08094', 'จ.ป.ร.', '0908', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08095', 'บางใหญ่', '0908', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08096', 'นาคา', '0909', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08097', 'กำพวน', '0909', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08098', 'ท่าตะเภา', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08099', 'ปากน้ำ', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08100', 'ท่ายาง', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08101', 'บางหมาก', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08102', 'นาทุ่ง', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08103', 'นาชะอัง', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08104', 'ตากแดด', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08105', 'บางลึก', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08106', 'หาดพันไกร', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08107', 'วังไผ่', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08108', 'วังใหม่', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08109', 'บ้านนา', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08110', 'ขุนกระทิง', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08111', 'ทุ่งคา', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08112', 'วิสัยเหนือ', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08113', 'หาดทรายรี', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08114', 'ถ้ำสิงห์', '0910', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08115', 'ท่าแซะ', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08116', 'คุริง', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08117', 'สลุย', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08118', 'นากระตาม', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08119', 'รับร่อ', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08120', 'ท่าข้าม', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08121', 'หงษ์เจริญ', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08122', 'หินแก้ว', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08123', 'ทรัพย์อนันต์', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08124', 'สองพี่น้อง', '0911', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08125', 'บางสน', '0912', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08126', 'ทะเลทรัพย์', '0912', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08127', 'สะพลี', '0912', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08128', 'ชุมโค', '0912', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08129', 'ดอนยาง', '0912', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08130', 'ปากคลอง', '0912', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08131', 'เขาไชยราช', '0912', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08132', 'หลังสวน', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08133', 'ขันเงิน', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08134', 'ท่ามะพลา', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08135', 'นาขา', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08136', 'นาพญา', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08137', 'บ้านควน', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08138', 'บางมะพร้าว', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08139', 'บางน้ำจืด', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08140', 'ปากน้ำ', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08141', 'พ้อแดง', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08142', 'แหลมทราย', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08143', 'วังตะกอ', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08144', 'หาดยาย', '0913', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08145', 'ละแม', '0914', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08146', 'ทุ่งหลวง', '0914', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08147', 'สวนแตง', '0914', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08148', 'ทุ่งคาวัด', '0914', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08149', 'พะโต๊ะ', '0915', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08150', 'ปากทรง', '0915', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08151', 'ปังหวาน', '0915', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08152', 'พระรักษ์', '0915', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08153', 'นาโพธิ์', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08154', 'สวี', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08155', 'ทุ่งระยะ', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08156', 'ท่าหิน', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08157', 'ปากแพรก', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08158', 'ด่านสวี', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08159', 'ครน', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08160', 'วิสัยใต้', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08161', 'นาสัก', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08162', 'เขาทะลุ', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08163', 'เขาค่าย', '0916', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08164', 'ปากตะโก', '0917', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08165', 'ทุ่งตะไคร', '0917', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08166', 'ตะโก', '0917', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08167', 'ช่องไม้แก้ว', '0917', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08168', 'บ่อยาง', '0918', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08169', 'เขารูปช้าง', '0918', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08170', 'เกาะแต้ว', '0918', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08171', 'พะวง', '0918', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08172', 'ทุ่งหวัง', '0918', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08173', 'เกาะยอ', '0918', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08174', 'ชิงโค', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08175', 'สทิงหม้อ', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08176', 'ทำนบ', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08177', 'รำแดง', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08178', 'วัดขนุน', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08179', 'ชะแล้', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08180', 'ปากรอ', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08181', 'ป่าขาด', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08182', 'หัวเขา', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08183', 'บางเขียด', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08184', 'ม่วงงาม', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08185', 'ปากรอ', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08186', 'ทำนบ', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08187', 'ชลเจริญ', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08188', 'ม่วงงาม', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08189', 'หัวเขา', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08190', 'ชะแล้', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08191', 'วัดขนุน', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08192', 'สทิงหม้อ', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08193', 'บางเขียด', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08194', 'ป่าขาด', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08195', 'รำแดง', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08196', 'ชิงโค', '0918', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08197', 'จะทิ้งพระ', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08198', 'กระดังงา', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08199', 'สนามชัย', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08200', 'ดีหลวง', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08201', 'ชุมพล', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08202', 'คลองรี', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08203', 'คูขุด', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08204', 'ท่าหิน', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08205', 'วัดจันทร์', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08206', 'บ่อแดง', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08207', 'บ่อดาน', '0919', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08208', 'บ้านนา', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08209', 'ป่าชิง', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08210', 'สะพานไม้แก่น', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08211', 'สะกอม', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08212', 'นาหว้า', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08213', 'นาทับ', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08214', 'น้ำขาว', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08215', 'ขุนตัดหวาย', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08216', 'ท่าหมอไทร', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08217', 'จะโหนง', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08218', 'คู', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08219', 'แค', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08220', 'คลองเปียะ', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08221', 'ตลิ่งชัน', '0920', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08222', 'นาทวี', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08223', 'ฉาง', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08224', 'นาหมอศรี', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08225', 'คลองทราย', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08226', 'ปลักหนู', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08227', 'ท่าประดู่', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08228', 'สะท้อน', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08229', 'ทับช้าง', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08230', 'ประกอบ', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08231', 'คลองกวาง', '0921', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08232', 'เทพา', '0922', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08233', 'ปากบาง', '0922', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08234', 'เกาะสะบ้า', '0922', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08235', 'ลำไพล', '0922', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08236', 'ท่าม่วง', '0922', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08237', 'วังใหญ่', '0922', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08238', 'สะกอม', '0922', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08239', 'สะบ้าย้อย', '0923', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08240', 'ทุ่งพอ', '0923', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08241', 'เปียน', '0923', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08242', 'บ้านโหนด', '0923', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08243', 'จะแหน', '0923', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08244', 'คูหา', '0923', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08245', 'เขาแดง', '0923', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08246', 'บาโหย', '0923', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08247', 'ธารคีรี', '0923', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08248', 'ระโนด', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08249', 'คลองแดน', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08250', 'ตะเครียะ', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08251', 'ท่าบอน', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08252', 'บ้านใหม่', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08253', 'บ่อตรุ', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08254', 'ปากแตระ', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08255', 'พังยาง', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08256', 'ระวะ', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08257', 'วัดสน', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08258', 'บ้านขาว', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08259', 'แดนสงวน', '0924', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08260', 'เชิงแส', '0924', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08261', 'โรง', '0924', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08262', 'เกาะใหญ่', '0924', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08263', 'เกาะใหญ่', '0925', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08264', 'โรง', '0925', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08265', 'เชิงแส', '0925', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08266', 'กระแสสินธุ์', '0925', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08267', 'กำแพงเพชร', '0926', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08268', 'ท่าชะมวง', '0926', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08269', 'คูหาใต้', '0926', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08270', 'ควนรู', '0926', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08271', 'ควนโส', '0926', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08272', 'รัตภูมิ', '0926', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08273', 'บางเหรียง', '0926', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08274', 'ห้วยลึก', '0926', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08275', 'เขาพระ', '0926', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08276', 'บางเหรี่ยง', '0926', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08277', 'ห้วยลึก', '0926', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08278', 'ควนโส', '0926', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08279', 'รัตนภูมิ', '0926', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08280', 'สะเดา', '0927', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08281', 'ปริก', '0927', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08282', 'พังลา', '0927', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08283', 'สำนักแต้ว', '0927', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08284', 'ทุ่งหมอ', '0927', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08285', 'ท่าโพธิ์', '0927', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08286', 'ปาดังเบซาร์', '0927', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08287', 'สำนักขาม', '0927', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08288', 'เขามีเกียรติ', '0927', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08289', 'หาดใหญ่', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08290', 'ควนลัง', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08291', 'คูเต่า', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08292', 'คอหงส์', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08293', 'คลองแห', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08294', 'คลองหอยโข่ง', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08295', 'คลองอู่ตะเภา', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08296', 'ฉลุง', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08297', 'ทุ่งลาน', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08298', 'ท่าช้าง', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08299', 'ทุ่งใหญ่', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08300', 'ทุ่งตำเสา', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08301', 'ท่าข้าม', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08302', 'น้ำน้อย', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08303', 'บางกล่ำ', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08304', 'บ้านพรุ', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08305', 'บ้านหาร', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08306', 'พะตง', '0928', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08307', 'แม่ทอม', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08308', 'โคกม่วง', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08309', 'ทุ่งลาน', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08310', 'คลองหอยโข่ง', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08311', 'บ้านหาร', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08312', 'แม่ทอม', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08313', 'ท่าช้าง', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08314', 'บางกล่ำ', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08315', 'คลองหรัง', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08316', 'ทุ่งขมิ้น', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08317', 'พิจิตร', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08318', 'นาหม่อม', '0928', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08319', 'นาหม่อม', '0929', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08320', 'พิจิตร', '0929', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08321', 'ทุ่งขมิ้น', '0929', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08322', 'คลองหรัง', '0929', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08323', 'รัตภูมิ', '0930', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08324', 'ควนโส', '0930', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08325', 'ห้วยลึก', '0930', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08326', 'บางเหรียง', '0930', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08327', 'บางกล่ำ', '0931', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08328', 'ท่าช้าง', '0931', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08329', 'แม่ทอม', '0931', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08330', 'บ้านหาร', '0931', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08331', 'ชิงโค', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08332', 'สทิงหม้อ', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08333', 'ทำนบ', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08334', 'รำแดง', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08335', 'วัดขนุน', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08336', 'ชะแล้', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08337', 'ปากรอ', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08338', 'ป่าขาด', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08339', 'หัวเขา', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08340', 'บางเขียด', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08341', 'ม่วงงาม', '0932', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08342', 'คลองหอยโข่ง', '0933', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08343', 'ทุ่งลาน', '0933', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08344', 'โคกม่วง', '0933', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08345', 'คลองหลา', '0933', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08346', 'สำนักขาม', '0934', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08347', 'พิมาน', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08348', 'คลองขุด', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08349', 'ควนขัน', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08350', 'บ้านควน', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08351', 'ฉลุง', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08352', 'เกาะสาหร่าย', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08353', 'ตันหยงโป', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08354', 'เจ๊ะบิลัง', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08355', 'ตำมะลัง', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08356', 'ปูยู', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08357', 'ควนโพธิ์', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08358', 'เกตรี', '0936', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08359', 'ท่าแพ', '0936', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08360', 'ควนโดน', '0937', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08361', 'ควนสตอ', '0937', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08362', 'ย่านซื่อ', '0937', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08363', 'วังประจัน', '0937', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08364', 'ทุ่งนุ้ย', '0938', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08365', 'ควนกาหลง', '0938', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08366', 'อุใดเจริญ', '0938', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08367', 'นิคมพัฒนา', '0938', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08368', 'ปาล์มพัฒนา', '0938', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08369', 'ท่าแพ', '0939', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08370', 'แป-ระ', '0939', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08371', 'สาคร', '0939', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08372', 'ท่าเรือ', '0939', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08373', 'กำแพง', '0940', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08374', 'ละงู', '0940', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08375', 'เขาขาว', '0940', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08376', 'ปากน้ำ', '0940', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08377', 'น้ำผุด', '0940', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08378', 'แหลมสน', '0940', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08379', 'ทุ่งหว้า', '0941', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08380', 'นาทอน', '0941', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08381', 'ขอนคลาน', '0941', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08382', 'ทุ่งบุหลัง', '0941', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08383', 'ป่าแก่บ่อหิน', '0941', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08384', 'ปาล์มพัฒนา', '0942', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08385', 'นิคมพัฒนา', '0942', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08386', 'ทับเที่ยง', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08387', 'โคกสะบ้า', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08388', 'ละมอ', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08389', 'นาพละ', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08390', 'บ้านควน', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08391', 'นาบินหลา', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08392', 'ควนปริง', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08393', 'นาโยงใต้', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08394', 'บางรัก', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08395', 'โคกหล่อ', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08396', 'นาข้าวเสีย', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08397', 'นาหมื่นศรี', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08398', 'นาโต๊ะหมิง', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08399', 'หนองตรุด', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08400', 'น้ำผุด', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08401', 'นาโยงเหนือ', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08402', 'นาตาล่วง', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08403', 'บ้านโพธิ์', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08404', 'นาท่ามเหนือ', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08405', 'นาท่ามใต้', '0943', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08406', 'ช่อง', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08407', 'นาข้าวเสีย', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08408', 'โคกสะบ้า', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08409', 'ละมอ', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08410', 'นาหมื่นศรี', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08411', 'ช่อง', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08412', 'นาโยงเหนือ', '0943', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08413', 'กันตัง', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08414', 'ควนธานี', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08415', 'บางหมาก', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08416', 'บางเป้า', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08417', 'วังวน', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08418', 'กันตังใต้', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08419', 'โคกยาง', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08420', 'คลองลุ', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08421', 'ย่านซื่อ', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08422', 'บ่อน้ำร้อน', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08423', 'บางสัก', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08424', 'นาเกลือ', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08425', 'เกาะลิบง', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08426', 'คลองชีล้อม', '0944', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08427', 'ย่านตาขาว', '0945', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08428', 'หนองบ่อ', '0945', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08429', 'นาชุมเห็ด', '0945', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08430', 'ในควน', '0945', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08431', 'โพรงจระเข้', '0945', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08432', 'ทุ่งกระบือ', '0945', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08433', 'ทุ่งค่าย', '0945', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08434', 'เกาะเปียะ', '0945', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08435', 'ท่าข้าม', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08436', 'ทุ่งยาว', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08437', 'ปะเหลียน', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08438', 'บางด้วน', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08439', 'หาดสำราญ', '0946', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08440', 'ตะเสะ', '0946', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08441', 'บ้านนา', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08442', 'บ้าหวี', '0946', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08443', 'สุโสะ', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08444', 'ลิพัง', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08445', 'เกาะสุกร', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08446', 'ท่าพญา', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08447', 'แหลมสอม', '0946', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08448', 'บ่อหิน', '0947', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08449', 'เขาไม้แก้ว', '0947', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08450', 'กะลาเส', '0947', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08451', 'ไม้ฝาด', '0947', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08452', 'นาเมืองเพชร', '0947', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08453', 'ท่าสะบ้า', '0947', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08454', 'สิเกา', '0947', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08455', 'อ่าวตง', '0947', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08456', 'วังมะปราง', '0947', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08457', 'เขาวิเศษ', '0947', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08458', 'ห้วยยอด', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08459', 'หนองช้างแล่น', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08460', 'หนองปรือ', '0948', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08461', 'หนองบัว', '0948', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08462', 'บางดี', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08463', 'บางกุ้ง', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08464', 'เขากอบ', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08465', 'เขาขาว', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08466', 'เขาปูน', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08467', 'ปากแจ่ม', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08468', 'ปากคม', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08469', 'คลองปาง', '0948', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08470', 'ควนเมา', '0948', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08471', 'ท่างิ้ว', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08472', 'ลำภูรา', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08473', 'นาวง', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08474', 'ห้วยนาง', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08475', 'เขาไพร', '0948', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08476', 'ในเตา', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08477', 'ทุ่งต่อ', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08478', 'วังคีรี', '0948', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08479', 'หนองปรือ', '0948', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08480', 'หนองบัว', '0948', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08481', 'คลองปาง', '0948', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08482', 'ควนเมา', '0948', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08483', 'เขาวิเศษ', '0949', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08484', 'วังมะปราง', '0949', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08485', 'อ่าวตง', '0949', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08486', 'ท่าสะบ้า', '0949', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08487', 'วังมะปรางเหนือ', '0949', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08488', 'นาโยงเหนือ', '0950', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08489', 'ช่อง', '0950', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08490', 'ละมอ', '0950', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08491', 'โคกสะบ้า', '0950', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08492', 'นาหมื่นศรี', '0950', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08493', 'นาข้าวเสีย', '0950', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08494', 'ควนเมา', '0951', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08495', 'คลองปาง', '0951', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08496', 'หนองบัว', '0951', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08497', 'หนองปรือ', '0951', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08498', 'เขาไพร', '0951', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08499', 'หาดสำราญ', '0952', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08500', 'บ้าหวี', '0952', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08501', 'ตะเสะ', '0952', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08502', 'คูหาสวรรค์', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08503', 'บ้านนา', '0954', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08504', 'เขาเจียก', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08505', 'ท่ามิหรำ', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08506', 'โคกชะงาย', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08507', 'นาท่อม', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08508', 'ปรางหมู่', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08509', 'ท่าแค', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08510', 'ลำปำ', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08511', 'ตำนาน', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08512', 'ควนมะพร้าว', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08513', 'ร่มเมือง', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08514', 'ชัยบุรี', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08515', 'นาโหนด', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08516', 'พญาขัน', '0954', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08517', 'ลำสินธุ์', '0954', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08518', 'อ่างทอง', '0954', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08519', 'ชุมพล', '0954', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08520', 'กงหรา', '0955', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08521', 'ชะรัด', '0955', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08522', 'คลองเฉลิม', '0955', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08523', 'คลองทรายขาว', '0955', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08524', 'สมหวัง', '0955', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08525', 'เขาชัยสน', '0956', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08526', 'ควนขนุน', '0956', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08527', 'ท่ามะเดื่อ', '0956', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08528', 'นาปะขอ', '0956', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08529', 'จองถนน', '0956', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08530', 'หานโพธิ์', '0956', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08531', 'โคกม่วง', '0956', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08532', 'โคกสัก', '0956', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08533', 'นาปะขอ', '0956', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08534', 'คลองใหญ่', '0956', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08535', 'ตะโหมด', '0956', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08536', 'ท่ามะเดื่อ', '0956', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08537', 'แม่ขรี', '0956', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08538', 'แม่ขรี', '0957', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08539', 'ตะโหมด', '0957', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08540', 'คลองใหญ่', '0957', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08541', 'ควนขนุน', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08542', 'ทะเลน้อย', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08543', 'เกาะเต่า', '0958', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08544', 'นาขยาด', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08545', 'พนมวังก์', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08546', 'แหลมโตนด', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08547', 'ป่าพะยอม', '0958', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08548', 'ปันแต', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08549', 'โตนดด้วน', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08550', 'ดอนทราย', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08551', 'มะกอกเหนือ', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08552', 'พนางตุง', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08553', 'ชะมวง', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08554', 'บ้านพร้าว', '0958', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08555', 'ลานข่อย', '0958', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08556', 'แพรกหา', '0958', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08557', 'คำไผ่', '0958', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08558', 'คำเตย', '0958', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08559', 'ส้มผ่อ', '0958', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08560', 'ป่าพะยอม', '0958', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08561', 'ปากพะยูน', '0959', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08562', 'ดอนประดู่', '0959', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08563', 'เกาะนางคำ', '0959', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08564', 'เกาะหมาก', '0959', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08565', 'ฝาละมี', '0959', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08566', 'หารเทา', '0959', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08567', 'ดอนทราย', '0959', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08568', 'หนองแซง', '0959', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08569', 'โคกทราย', '0959', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08570', 'ป่าบอน', '0959', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08571', 'เขาย่า', '0960', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08572', 'เขาปู่', '0960', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08573', 'ตะแพน', '0960', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08574', 'ป่าบอน', '0961', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08575', 'โคกทราย', '0961', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08576', 'หนองธง', '0961', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08577', 'ทุ่งนารี', '0961', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08578', 'วังใหม่', '0961', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08579', 'ท่ามะเดื่อ', '0962', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08580', 'นาปะขอ', '0962', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08581', 'โคกสัก', '0962', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08582', 'ป่าพะยอม', '0963', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08583', 'ลานข่อย', '0963', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08584', 'เกาะเต่า', '0963', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08585', 'บ้านพร้าว', '0963', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08586', 'ชุมพล', '0964', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08587', 'บ้านนา', '0964', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08588', 'อ่างทอง', '0964', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08589', 'ลำสินธุ์', '0964', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08590', 'สะบารัง', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08591', 'อาเนาะรู', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08592', 'จะบังติกอ', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08593', 'บานา', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08594', 'ตันหยงลุโละ', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08595', 'คลองมานิง', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08596', 'กะมิยอ', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08597', 'บาราโหม', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08598', 'ปะกาฮะรัง', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08599', 'รูสะมิแล', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08600', 'ตะลุโบะ', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08601', 'บาราเฮาะ', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08602', 'ปุยุด', '0965', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08603', 'โคกโพธิ์', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08604', 'มะกรูด', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08605', 'บางโกระ', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08606', 'ป่าบอน', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08607', 'ทรายขาว', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08608', 'นาประดู่', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08609', 'ปากล่อ', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08610', 'ทุ่งพลา', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08611', 'แม่ลาน', '0966', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08612', 'ป่าไร่', '0966', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08613', 'ท่าเรือ', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08614', 'ม่วงเตี้ย', '0966', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08615', 'นาเกตุ', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08616', 'ควนโนรี', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08617', 'ช้างให้ตก', '0966', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08618', 'เกาะเปาะ', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08619', 'คอลอตันหยง', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08620', 'ดอนรัก', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08621', 'ดาโต๊ะ', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08622', 'ตุยง', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08623', 'ท่ากำชำ', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08624', 'บ่อทอง', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08625', 'บางเขา', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08626', 'บางตาวา', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08627', 'ปุโละปุโย', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08628', 'ยาบี', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08629', 'ลิปะสะโง', '0967', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08630', 'ปะนาเระ', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08631', 'ท่าข้าม', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08632', 'บ้านนอก', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08633', 'ดอน', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08634', 'ควน', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08635', 'ท่าน้ำ', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08636', 'คอกกระบือ', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08637', 'พ่อมิ่ง', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08638', 'บ้านกลาง', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08639', 'บ้านน้ำบ่อ', '0968', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08640', 'มายอ', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08641', 'ถนน', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08642', 'ตรัง', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08643', 'กระหวะ', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08644', 'ลุโบะยิไร', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08645', 'ลางา', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08646', 'กระเสาะ', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08647', 'เกาะจัน', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08648', 'ปะโด', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08649', 'สาคอบน', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08650', 'สาคอใต้', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08651', 'สะกำ', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08652', 'ปานัน', '0969', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08653', 'ตะโละแมะนา', '0970', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08654', 'พิเทน', '0970', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08655', 'น้ำดำ', '0970', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08656', 'ปากู', '0970', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08657', 'ตะลุบัน', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08658', 'ตะบิ้ง', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08659', 'ปะเสยะวอ', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08660', 'บางเก่า', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08661', 'บือเระ', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08662', 'เตราะบอน', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08663', 'กะดุนง', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08664', 'ละหาร', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08665', 'มะนังดาลำ', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08666', 'แป้น', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08667', 'ทุ่งคล้า', '0971', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08668', 'ไทรทอง', '0972', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08669', 'ไม้แก่น', '0972', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08670', 'ตะโละไกรทอง', '0972', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08671', 'ดอนทราย', '0972', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08672', 'ตะโละ', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08673', 'ตะโละกาโปร์', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08674', 'ตันหยงดาลอ', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08675', 'ตันหยงจึงงา', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08676', 'ตอหลัง', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08677', 'ตาแกะ', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08678', 'ตาลีอายร์', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08679', 'ยามู', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08680', 'บางปู', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08681', 'หนองแรต', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08682', 'ปิยามุมัง', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08683', 'ปุลากง', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08684', 'บาโลย', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08685', 'สาบัน', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08686', 'มะนังยง', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08687', 'ราตาปันยัง', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08688', 'จะรัง', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08689', 'แหลมโพธิ์', '0973', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08690', 'ยะรัง', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08691', 'สะดาวา', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08692', 'ประจัน', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08693', 'สะนอ', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08694', 'ระแว้ง', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08695', 'ปิตูมุดี', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08696', 'วัด', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08697', 'กระโด', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08698', 'คลองใหม่', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08699', 'เมาะมาวี', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08700', 'กอลำ', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08701', 'เขาตูม', '0974', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08702', 'กะรุบี', '0975', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08703', 'ตะโละดือรามัน', '0975', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08704', 'ปล่องหอย', '0975', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08705', 'แม่ลาน', '0976', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08706', 'ม่วงเตี้ย', '0976', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08707', 'ป่าไร่', '0976', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08708', 'สะเตง', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08709', 'บุดี', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08710', 'ยุโป', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08711', 'ลิดล', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08712', 'ปุโรง', '0977', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08713', 'ยะลา', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08714', 'สะเอะ', '0977', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08715', 'ท่าสาป', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08716', 'ลำใหม่', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08717', 'หน้าถ้ำ', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08718', 'ลำพะยา', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08719', 'เปาะเส้ง', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08720', 'กรงปินัง', '0977', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08721', 'พร่อน', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08722', 'บันนังสาเรง', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08723', 'สะเตงนอก', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08724', 'ห้วยกระทิง', '0977', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08725', 'ตาเซะ', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08726', 'เบตง', '0978', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08727', 'ยะรม', '0978', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08728', 'ตาเนาะแมเราะ', '0978', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08729', 'อัยเยอร์เวง', '0978', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08730', 'ธารน้ำทิพย์', '0978', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08731', 'บันนังสตา', '0979', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08732', 'บาเจาะ', '0979', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08733', 'ตาเนาะปูเต๊ะ', '0979', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08734', 'ถ้ำทะลุ', '0979', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08735', 'ตลิ่งชัน', '0979', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08736', 'เขื่อนบางลาง', '0979', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08737', 'แม่หวาด', '0979', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08738', 'บ้านแหร', '0979', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08739', 'ธารโต', '0979', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08740', 'ธารโต', '0980', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08741', 'บ้านแหร', '0980', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08742', 'แม่หวาด', '0980', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08743', 'คีรีเขต', '0980', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08744', 'ยะหา', '0981', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08745', 'ละแอ', '0981', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08746', 'ปะแต', '0981', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08747', 'บาโร๊ะ', '0981', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08748', 'กาบัง', '0981', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08749', 'ตาชี', '0981', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08750', 'บาโงยซิแน', '0981', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08751', 'กาตอง', '0981', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08752', 'บาละ', '0981', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08753', 'กาบัง', '0981', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08754', 'กายูบอเกาะ', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08755', 'กาลูปัง', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08756', 'กาลอ', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08757', 'กอตอตือร๊ะ', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08758', 'โกตาบารู', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08759', 'เกะรอ', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08760', 'จะกว๊ะ', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08761', 'ท่าธง', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08762', 'เนินงาม', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08763', 'บาลอ', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08764', 'บาโงย', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08765', 'บือมัง', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08766', 'ยะต๊ะ', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08767', 'วังพญา', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08768', 'อาซ่อง', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08769', 'ตะโล๊ะหะลอ', '0982', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08770', 'กาบัง', '0983', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08771', 'บาละ', '0983', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08772', 'กรงปินัง', '0984', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08773', 'สะเอะ', '0984', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08774', 'ห้วยกระทิง', '0984', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08775', 'ปุโรง', '0984', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08776', 'บางนาค', '0985', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08777', 'ลำภู', '0985', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08778', 'มะนังตายอ', '0985', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08779', 'บางปอ', '0985', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08780', 'กะลุวอ', '0985', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08781', 'กะลุวอเหนือ', '0985', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08782', 'โคกเคียน', '0985', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08783', 'เจ๊ะเห', '0986', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08784', 'ไพรวัน', '0986', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08785', 'พร่อน', '0986', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08786', 'ศาลาใหม่', '0986', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08787', 'บางขุนทอง', '0986', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08788', 'เกาะสะท้อน', '0986', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08789', 'นานาค', '0986', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08790', 'โฆษิต', '0986', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08791', 'บาเจาะ', '0987', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08792', 'ลุโบะสาวอ', '0987', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08793', 'กาเยาะมาตี', '0987', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08794', 'ปะลุกาสาเมาะ', '0987', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08795', 'บาเระเหนือ', '0987', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08796', 'บาเระใต้', '0987', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08797', 'ยี่งอ', '0988', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08798', 'ละหาร', '0988', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08799', 'จอเบาะ', '0988', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08800', 'ลุโบะบายะ', '0988', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08801', 'ลุโบะบือซา', '0988', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08802', 'ตะปอเยาะ', '0988', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08803', 'ตันหยงมัส', '0989', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08804', 'ตันหยงลิมอ', '0989', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08805', 'จวบ', '0989', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08806', 'มะรือโบตะวันออก', '0989', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08807', 'บูกิต', '0989', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08808', 'บองอ', '0989', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08809', 'กาลิซา', '0989', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08810', 'บาโงสะโต', '0989', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08811', 'เฉลิม', '0989', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08812', 'มะรือโบตก', '0989', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08813', 'ดุซงญอ', '0989', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08814', 'จะแนะ', '0989', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08815', 'รือเสาะ', '0990', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08816', 'สาวอ', '0990', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08817', 'เรียง', '0990', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08818', 'สามัคคี', '0990', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08819', 'บาตง', '0990', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08820', 'ลาโละ', '0990', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08821', 'รือเสาะออก', '0990', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08822', 'โคกสะตอ', '0990', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08823', 'สุวารี', '0990', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08824', 'ตะมะยูง', '0990', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08825', 'ชากอ', '0990', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08826', 'ซากอ', '0991', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08827', 'ตะมะยูง', '0991', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08828', 'ศรีสาคร', '0991', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08829', 'เชิงคีรี', '0991', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08830', 'กาหลง', '0991', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08831', 'ศรีบรรพต', '0991', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08832', 'แว้ง', '0992', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08833', 'กายูคละ', '0992', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08834', 'ฆอเลาะ', '0992', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08835', 'โละจูด', '0992', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08836', 'แม่ดง', '0992', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08837', 'เอราวัณ', '0992', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08838', 'มาโม', '0992', -1 )
INSERT INTO tbm_sub_district
VALUES
( '08839', 'มาโมง', '0993', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08840', 'สุคิริน', '0993', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08841', 'เกียร์', '0993', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08842', 'ภูเขาทอง', '0993', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08843', 'ร่มไทร', '0993', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08844', 'สุไหงโก-ลก', '0994', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08845', 'ปาเสมัส', '0994', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08846', 'มูโนะ', '0994', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08847', 'ปูโยะ', '0994', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08848', 'ปะลุรู', '0995', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08849', 'สุไหงปาดี', '0995', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08850', 'โต๊ะเด็ง', '0995', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08851', 'สากอ', '0995', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08852', 'ริโก๋', '0995', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08853', 'กาวะ', '0995', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08854', 'จะแนะ', '0996', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08855', 'ดุซงญอ', '0996', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08856', 'ผดุงมาตร', '0996', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08857', 'ช้างเผือก', '0996', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08858', 'จวบ', '0997', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08859', 'บูกิต', '0997', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08860', 'มะรือโบออก', '0997', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08861', 'วงศ์สว่าง', '0026', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08865', 'รามอินทรา', '0043', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08866', 'เซกา', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08868', 'ซาง', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08870', 'ท่ากกแดง', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08872', 'บ้านต้อง', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08874', 'ป่งไฮ', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08876', 'น้ำจั้น', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08878', 'ท่าสะอาด', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08880', 'หนองทุ่ม', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08882', 'โสกก่าม', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08884', 'โซ่', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08886', 'หนองพันทา', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08888', 'ศรีชมภู', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08890', 'คำแก้ว', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08892', 'บัวตูม', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08894', 'ถ้ำเจริญ', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08896', 'เหล่าทอง', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08898', 'ดอนเมือง', '0036', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08899', 'สนามบิน', '0036', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08900', 'วงศ์สว่าง', '0029', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08901', 'นวมินทร์', '0027', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08902', 'นวลจันทร์', '0027', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08903', 'บึงโขงหลง', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08905', 'โพธิ์หมากแข้ง', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08907', 'ดงบัง', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08909', 'ท่าดอกคำ', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08911', 'บุ่งคล้า', '0472', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08913', 'หนองเดิ่น', '0472', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08915', 'โคกกว้าง', '0472', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08922', 'ปากคาด', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08924', 'หนองยอง', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08926', 'นากั้ง', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08928', 'โนนศิลา', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08930', 'สมสนุก', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08932', 'นาดง', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08934', 'ศรีชมภู', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08936', 'ดอนหญ้านาง', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08938', 'พรเจริญ', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08940', 'หนองหัวช้าง', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08942', 'วังชมภู', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08944', 'ป่าแฝก', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08946', 'ศรีสำราญ', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08948', 'บ่อสวก', '0633', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08961', 'โพนสว่าง', '0460', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08962', 'ทุ่งปี๊', '0589', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08963', 'สร้างแซ่ง', '0487', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08964', 'สะพานสอง', '0045', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08965', 'คลองเจ้าคุณสิงห์', '0045', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08966', 'พลับพลา', '0045', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08967', 'ห้วยขะยุง', '0326', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08968', 'ศรีวิไล', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08970', 'ชุมภูพร', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08972', 'นาแสง', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08974', 'นาสะแบง', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08976', 'นาสิงห์', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08977', 'บ้านจันทร์', '0999', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08978', 'แม่แดด', '0999', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08979', 'แจ่มหลวง', '0999', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08980', 'เซกา', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08981', 'เซกา', '1000', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08982', 'ซาง', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08983', 'ซาง', '1000', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08984', 'ท่ากกแดง', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08985', 'ท่ากกแดง', '1000', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08986', 'บ้านต้อง', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08987', 'บ้านต้อง', '1000', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08988', 'ป่งไฮ', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08989', 'ป่งไฮ', '1000', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08990', 'น้ำจั้น', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08991', 'น้ำจั้น', '1000', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08992', 'ท่าสะอาด', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08993', 'ท่าสะอาด', '1000', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08994', 'หนองทุ่ม', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08995', 'หนองทุ่ม', '1000', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08996', 'โสกก่าม', '0468', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08997', 'โสกก่าม', '1000', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08998', 'โซ่', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '08999', 'โซ่', '1001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09000', 'หนองพันทา', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09001', 'หนองพันทา', '1001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09002', 'ศรีชมภู', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09003', 'ศรีชมภู', '1001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09004', 'คำแก้ว', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09005', 'คำแก้ว', '1001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09006', 'บัวตูม', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09007', 'บัวตูม', '1001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09008', 'ถ้ำเจริญ', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09009', 'ถ้ำเจริญ', '1001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09010', 'เหล่าทอง', '0465', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09011', 'เหล่าทอง', '1001', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09012', 'บึงโขงหลง', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09013', 'บึงโขงหลง', '1002', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09014', 'โพธิ์หมากแข้ง', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09015', 'โพธิ์หมากแข้ง', '1002', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09016', 'ดงบัง', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09017', 'ดงบัง', '1002', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09018', 'ท่าดอกคำ', '0470', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09019', 'ท่าดอกคำ', '1002', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09020', 'บุ่งคล้า', '0472', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09021', 'บุ่งคล้า', '1003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09022', 'หนองเดิ่น', '0472', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09023', 'หนองเดิ่น', '1003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09024', 'โคกกว้าง', '0472', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09025', 'โคกกว้าง', '1003', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09026', 'เสียว', '1004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09027', 'หนองหว้า', '1004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09028', 'หนองงูเหลือม', '1004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09029', 'หนองฮาง', '1004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09030', 'ท่าคล้อ', '1004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09031', 'ปากคาด', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09032', 'ปากคาด', '1005', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09033', 'หนองยอง', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09034', 'หนองยอง', '1005', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09035', 'นากั้ง', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09036', 'นากั้ง', '1005', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09037', 'โนนศิลา', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09038', 'โนนศิลา', '1005', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09039', 'สมสนุก', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09040', 'สมสนุก', '1005', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09041', 'นาดง', '0469', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09042', 'นาดง', '1005', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09043', 'ศรีชมภู', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09044', 'ศรีชมภู', '1006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09045', 'ดอนหญ้านาง', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09046', 'ดอนหญ้านาง', '1006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09047', 'พรเจริญ', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09048', 'พรเจริญ', '1006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09049', 'หนองหัวช้าง', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09050', 'หนองหัวช้าง', '1006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09051', 'วังชมภู', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09052', 'วังชมภู', '1006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09053', 'ป่าแฝก', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09054', 'ป่าแฝก', '1006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09055', 'ศรีสำราญ', '0463', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09056', 'ศรีสำราญ', '1006', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09057', 'บึงกาฬ', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09058', 'โนนสมบูรณ์', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09059', 'โนนสว่าง', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09060', 'หอคำ', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09061', 'หนองเลิง', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09062', 'โคกก่อง', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09063', 'นาสวรรค์', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09064', 'ไคสี', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09065', 'ชัยพร', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09066', 'วิศิษฐ์', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09067', 'คำนาดี', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09068', 'โป่งเปือย', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09069', 'ศรีวิไล', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09070', 'ศรีวิไล', '1008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09071', 'ชุมภูพร', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09072', 'ชุมภูพร', '1008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09073', 'นาแสง', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09074', 'นาแสง', '1008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09075', 'นาสะแบง', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09076', 'นาสะแบง', '1008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09077', 'นาสิงห์', '0471', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09078', 'นาสิงห์', '1008', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09079', 'ระแงง', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09080', 'ตรึม', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09081', 'จารพัต', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09082', 'ยาง', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09083', 'แตล', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09084', 'หนองบัว', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09085', 'คาละแมะ', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09086', 'หนองเหล็ก', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09087', 'หนองขวาว', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09088', 'ช่างปี่', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09089', 'กุดหวาย', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09090', 'ขวาวใหญ่', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09091', 'นารุ่ง', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09092', 'ตรมไพร', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09093', 'ผักไหม', '1009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09094', 'คู้ยายหมี', '1010', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09095', 'ท่ากระดาน', '1010', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09096', 'ทุ่งพระยา', '1010', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09097', 'ท่าตะเกียบ', '1010', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09098', 'ลาดกระทิง', '1010', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09099', 'คลองตะเกรา', '1010', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09100', 'หนองบุนนาก', '1012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09101', 'สารภี', '1012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09102', 'ไทยเจริญ', '1012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09103', 'หนองหัวแรต', '1012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09104', 'แหลมทอง', '1012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09105', 'หนองตะไก้', '1012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09106', 'ลุงเขว้า', '1012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09107', 'หนองไม้ไผ่', '1012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09108', 'บ้านใหม่', '1012', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09109', 'ยายร้า', '0152', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09110', 'ในเมือง', '0977', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09112', 'ช้างกลาง', '0845', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09113', 'ห้วยปราบ', '0156', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09129', 'ศรีเวียง', '0004', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09130', 'บ่อฝ้าย', '0834', 1 )
INSERT INTO tbm_sub_district
VALUES
( '09131', 'ท่าแฝก', '0619', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9110', 'ในเมือง', '0151', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9111', 'สามเสนใน', '0017', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9114', 'ไทยเจริญ', '1013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9115', 'บ้านใหม่', '1013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9116', 'ลุงเขว้า', '1013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9117', 'สารภี', '1013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9118', 'หนองตะไก้', '1013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9119', 'หนองบุนนาก', '1013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9120', 'หนองไม้ไผ่', '1013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9121', 'หนองหัวแรต', '1013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9122', 'แหลมทอง', '1013', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9123', 'หนองเข็ง', '1007', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9124', 'หนองตระครอง', '0255', 0 )
INSERT INTO tbm_sub_district
VALUES
( '9125', 'วังหงษ์', '0625', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9126', 'ขามเบี้ย', '0498', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9127', 'ทุ่งใหญ่', '0292', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9128', 'นิคมลำโดมน้อย', '0336', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9129', 'บางบอนใต้', '0050', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9130', 'คลองบางพราน', '0050', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9131', 'พระโขนงใต้', '0009', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9132', 'พญาไท', '0014', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9133', 'รัชดาภิเษก', '0026', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9134', 'อ่อนนุช', '0034', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9135', 'พัฒนาการ', '0034', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9136', 'ราษฎร์พัฒนา', '0044', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9137', 'ทับช้าง', '0044', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9138', 'บางนาเหนือ', '0047', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9139', 'บางนาใต้', '0047', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9140', 'บางบอนเหนือ', '0050', 1 )
INSERT INTO tbm_sub_district
VALUES
( '9141', 'คลองบางบอน', '0050', 1 )
;
PRINT '================= Unit Table==================================='
TRUNCATE TABLE tbm_unit;
INSERT INTO tbm_unit
VALUES
( '''', 'นิ้ว' ), 
( '"2', 'ตารางนิ้ว' ), 
( '"3', 'ลูกบาศก์นิ้ว' ), 
( '%O', 'ต่อ mille' ), 
( 'A/V', 'ซีเมนส์ต่อเมตร' ), 
( 'ACR', 'เอเคอร์' ), 
( 'AU', 'หน่วยนับกิจกรรม' ), 
( 'BAG', 'ถุง' ), 
( 'BK', 'เล่ม' ), 
( 'BPH', 'แกลลอนต่อชั่วโมง (US)' ), 
( 'BT.', 'ขวด' ), 
( 'C3S', 'ลูกบาศก์เซนติเมตร/วินาที' ), 
( 'CAB', 'ตู้' ), 
( 'CAN', 'กระป๋อง' ), 
( 'CAR', 'คัน' ), 
( 'CCM', 'ลูกบาศก์เซนติเมตร' ), 
( 'CD3', 'ลูกบาศก์เดซิเมตร' ), 
( 'CL', 'เซนติลิตร' ), 
( 'CM', 'เซนติเมตร' ), 
( 'CM2', 'ตารางเซนติเมตร' ), 
( 'CMS', 'เซนติเมตร/วินาที' ), 
( 'CRT', 'กล่อง' ), 
( 'CT', 'คาร์ตัน' ), 
( 'CUP', 'ถ้วย' ), 
( 'CV', 'หีบ' ), 
( 'DAY', 'วัน' ), 
( 'DEG', 'องศา' ), 
( 'DM', 'เดซิเมตร' ), 
( 'DR', 'ถัง' ), 
( 'DZ', 'โหล' ), 
( 'EA', 'ชิ้น' ), 
( 'EML', 'หน่วยเอมไซน์/มิลลิลิตร' ), 
( 'EU', 'หน่วยเอมไซน์' ), 
( 'FIL', 'แฟ้ม' ), 
( 'FOZ', 'ออนซ์หน่วยวัดของเหลว US' ), 
( 'FT', 'ฟุต' ), 
( 'FT2', 'ตารางฟุต' ), 
( 'FT3', 'ลูกบาศก์ฟุต' ), 
( 'FYR', 'กิกะจูล' ), 
( 'G', 'กรัม' ), 
( 'GA', 'US แกลลอน' ), 
( 'GAU', 'กรัมทองคำ' ), 
( 'GL', 'gram act.ingrd / liter' ), 
( 'GLI', 'กรัม/ลิตร' ), 
( 'GM', 'กรัมต่อโมล' ), 
( 'GM2', 'กรัม/ตารางเมตร' ), 
( 'GM3', 'กรัมต่อลูกบาศก์เมตร' ), 
( 'GOH', 'กิกะโอห์ม' ), 
( 'GPM', 'แกลลอนต่อไมล์ (US)' ), 
( 'GRO', 'ตัวใหญ่' ), 
( 'GRP', 'กลุ่ม' ), 
( 'H', 'ชั่วโมง' ), 
( 'HA', 'เฮกตาร์' ), 
( 'HL', 'เฮกโตลิตร' ), 
( 'HR.', 'ชั่วโมง' ), 
( 'IB', 'พิโคฟาเรด' ), 
( 'JKG', 'จูล/กิโลกรัม' ), 
( 'JMO', 'จูล/โมล' ), 
( 'JOB', 'งาน' ), 
( 'KAI', 'Kilogram act. ingrd.' ), 
( 'KD3', 'กิโลกรัมต่อลูกบาศก์เดซิเมตร' ), 
( 'KG', 'กิโลกรัม' ), 
( 'KGM', 'กิโลกรัม/โมล' ), 
( 'KGS', 'กิโลกรัมต่อวินาที' ), 
( 'KIK', 'kg act.ingrd. / kg' ), 
( 'KJK', 'กิโลจูล/กิโลกรัม' ), 
( 'KJM', 'กิโลจูล/โมล' ), 
( 'KM', 'กิโลเมตร' ), 
( 'KM2', 'ตารางกิโลเมตร' ), 
( 'KMH', 'กิโลเมตรต่อชั่วโมง' ), 
( 'KMN', 'เคลวิน/นาที' ), 
( 'KMS', 'เคลวิน/วินาที' ), 
( 'KPA', 'กิโลปาสคาล' ), 
( 'KVA', 'กิโลโวลต์แอมแปร์' ), 
( 'L', 'ลิตร' ), 
( 'LB', 'US ปอนด์' ), 
( 'LHK', 'ลิตรต่อ 100 กิโลเมตร' ), 
( 'LMI', 'ลิตร/นาที' ), 
( 'LMS', 'ลิตร/โมลวินาที' ), 
( 'LPH', 'ลิตรต่อชั่วโมง' ), 
( 'LT', 'Kilotonne' ), 
( 'M', 'เมตร' ), 
( 'M/L', 'โมลต่อลิตร' ), 
( 'M/M', 'โมลต่อลูกบาศก์เมตร' ), 
( 'M/S', 'เมตร/วินาที' ), 
( 'M2', 'ตารางเมตร' ), 
( 'M-2', '1 / ตารางเมตร' ), 
( 'M2S', 'ตารางเมตร/วินาที' ), 
( 'M3', 'ลูกบาศก์เมตร' ), 
( 'M3H', 'ลูกบาศก์เมตร/ชั่วโมง' ), 
( 'M3S', 'ลูกบาศก์เมตร/วินาที' ), 
( 'MAC', 'เครื่อง' ), 
( 'MD', 'มัด' ), 
( 'MEJ', 'เมกะจูล' ), 
( 'MG', 'มิลลิกรัม' ), 
( 'MGL', 'มิลลิกรัม/ลิตร' ), 
( 'MGO', 'เมกะโอมห์' ), 
( 'MGQ', 'มิลลิกรัม/ลูกบาศก์เมตร' ), 
( 'MH', 'เมตร/ชั่วโมง' ), 
( 'MHV', 'เมกะโวลต์' ), 
( 'MI', 'ไมล์' ), 
( 'MI2', 'ตารางไมล์' ), 
( 'MIN', 'นาที' ), 
( 'MIS', 'ไมโครวินาที' ), 
( 'ML', 'มิลลิลิตร' ), 
( 'MLI', 'Milliliter act. ingr.' ), 
( 'MM', 'มิลลิเมตร' ), 
( 'MM2', 'ตารางมิลลิเมตร' ), 
( 'MM3', 'ลูกบาศก์มิลลิเมตร' ), 
( 'MN', 'เมกะนิวตัน' ), 
( 'MNM', 'มิลลินิวตัน/เมตร' ), 
( 'MPG', 'ไมล์ต่อแกลลอน (US)' ), 
( 'MPL', 'มิลิโมลต่อลิตร' ), 
( 'MPS', 'มิลลิปาสคาลวินาที' ), 
( 'MS', 'พิโควินาที' ), 
( 'MS2', 'เมตร/วินาทีกำลังสอง' ), 
( 'MSC', 'ไมโครซเมนส์ต่อเซนติเมตร' ), 
( 'MSE', 'มิลลิวินาที' ), 
( 'MTH', 'เดือน' ), 
( 'MWH', 'เมกะวัตต์ ชั่วโมง' ), 
( 'NA', 'นาโนแอมแปร์' ), 
( 'NAM', 'นาโนเมตร' ), 
( 'NG', 'Gram act. ingrd.' ), 
( 'NI', 'กิโลนิวตัน' ), 
( 'NM', 'นิวตัน/เมตร' ), 
( 'NMM', 'นิวตัน/ตารางมิลลิเมตร' ), 
( 'NS', 'นาโนวินาที' ), 
( 'OC', 'ออนซ์' ), 
( 'P', 'จุด' ), 
( 'PAA', 'คู่' ), 
( 'PAC', 'แพค/ห่อ' ), 
( 'PAL', 'แพลเลต' ), 
( 'PAS', 'ปาสคาลวินาที' ), 
( 'PC.', 'เมกะโวลต์แอมแปร์' ), 
( 'PGL', 'กิโลกรัมต่อลูกบาศก์เมตร' ), 
( 'PMI', 'หนึ่ง/นาที' ), 
( 'PPB', 'อัตราส่วนพันล้าน' ), 
( 'PPM', 'อัตราส่วนล้าน' ), 
( 'PPT', 'อัตราส่วนล้านล้าน' ), 
( 'PRD', 'งวด' ), 
( 'PRS', 'คน' ), 
( 'PT', 'ไพนท์, หน่วยวัดขนาดของเหลว US' ), 
( 'QML', 'กิโลโมล' ), 
( 'QT', 'ควอรท,หน่วยวัดขนาดของเหลว US' ), 
( 'RF', 'มิลลิฟาเรด' ), 
( 'RHO', 'กรัม/ลูกบาศก์เซนติเมตร' ), 
( 'RM', 'รีม' ), 
( 'ROL', 'Roll (ม้วน)' ), 
( 'R-U', 'นาโนฟาเรด' ), 
( 'SHE', 'ผืน' ), 
( 'SHT', 'แผ่น' ), 
( 'ST', 'ชุด' ), 
( 'STK', 'ท่อน' ), 
( 'SYS', 'ระบบ' ), 
( 'T', 'หลักพัน' ), 
( 'TM', 'ครั้ง' ), 
( 'TO', 'ตัน' ), 
( 'TOM', 'ตัน/ลูกบาศก์เมตร' ), 
( 'TON', 'US ตัน' ), 
( 'TUB', 'ท่อ' ), 
( 'U1', 'แท่ง' ), 
( 'U10', 'ขด' ), 
( 'U11', 'โคม' ), 
( 'U12', 'คิว' ), 
( 'U13', 'ปี๊บ' ), 
( 'U14', 'ซอง' ), 
( 'U15', 'ดวง' ), 
( 'U16', 'ดอก' ), 
( 'U17', 'แผง' ), 
( 'U18', 'ตลับ' ), 
( 'U19', 'เที่ยว' ), 
( 'U2', 'ตัว' ), 
( 'U20', 'นัด' ), 
( 'U21', 'แท่น' ), 
( 'U22', 'บาน' ), 
( 'U23', 'ใบ' ), 
( 'U24', 'ภาพ/รูป' ), 
( 'U25', 'เรือน' ), 
( 'U26', 'ล้อ' ), 
( 'U27', 'ลัง' ), 
( 'U28', 'วง' ), 
( 'U29', 'เส้น' ), 
( 'U3', 'ลูก' ), 
( 'U30', 'หลอด' ), 
( 'U31', 'หลัง' ), 
( 'U32', 'เม็ด' ), 
( 'U33', 'ไมโครแอมแปร์' ), 
( 'U34', 'ไมโครฟาเรด' ), 
( 'U35', 'ไมโครเมตร' ), 
( 'U36', 'ไมโครกรัม/ลูกบาศก์เมตร' ), 
( 'U37', 'ไมโครลิตร' ), 
( 'U4', 'กระสอบ' ), 
( 'U40', 'ไมโครกรัม/ลิตร' ), 
( 'U5', 'กรง' ), 
( 'U6', 'กรอบ' ), 
( 'U7', 'กระถาง' ), 
( 'U8', 'กระบอก' ), 
( 'U9', 'ก้อน' ), 
( 'UNT', 'หน่วย' ), 
( 'VAL', 'วัสดุที่คิดมูลค่าเท่านั้น' ), 
( 'VAM', 'โวลต์แอมแปร์' ), 
( 'WKS', 'สัปดาห์' ), 
( 'Y', 'ปี' ), 
( 'YD', 'หลา' ), 
( 'YD2', 'ตารางหลา' ), 
( 'YD3', 'ลูกบาศก์หลา' )




END



GO
/****** Object:  StoredProcedure [dbo].[sp_insert_leave_data]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_leave_data]
	@start_leave DATE,
    @stop_leave DATE,
	@leave_type	varchar(2),
	@leave_path INT,
	@emp_id		INT	
    
AS
BEGIN
SET NOCOUNT OFF	
	IF (CONVERT(DATE,@start_leave)<>CONVERT(DATE,@stop_leave))
			SET @leave_path=0

IF EXISTS(
	SELECT leave_id FROM tbt_leave
	WHERE emp_id=@emp_id AND @start_leave BETWEEN CONVERT(DATE,leave_date_from) AND CONVERT(DATE,leave_date_to)
	AND cancel_date IS NULL AND leave_type=@leave_type
	AND DATEDIFF(DAY,CONVERT(DATE,leave_date_from),CONVERT(DATE,leave_date_to))>0
    ) OR 
	EXISTS(
	SELECT leave_id FROM tbt_leave
	WHERE emp_id=@emp_id AND @stop_leave BETWEEN CONVERT(DATE,leave_date_from) AND CONVERT(DATE,leave_date_to)
	AND cancel_date IS NULL 
	AND leave_type=@leave_type 
	AND DATEDIFF(DAY,CONVERT(DATE,leave_date_from),CONVERT(DATE,leave_date_to))>0
	)
	BEGIN
		SELECT 0
		RETURN
	END



INSERT INTO tbt_leave
		SELECT @leave_type,
			   @emp_id,
			   @start_leave,
			   @stop_leave,
			   @leave_path,
			   NULL,--GETDATE(), approve daet
			   NULL,--1, approve by 
			   NULL,
			   NULL,
			   GETDATE(),
			   1;
SELECT @@ROWCOUNT
		
END


--DELETE FROM tbt_leave WHERE leave_id=4
GO
/****** Object:  StoredProcedure [dbo].[sp_script_maintain]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_script_maintain]
AS
BEGIN
	RETURN
MERGE tbm_sparepart AS t
USING temp_part AS s
ON s.part_no=t.part_no
WHEN NOT MATCHED BY TARGET THEN
INSERT	   ([part_no]
           ,[part_name]
           ,[part_desc]
           ,[part_type]
           ,[cost_price]
           ,[sale_price]
           ,[unit_code]
           ,[part_value]
           ,[part_weight]
           ,[minimum_value]
           ,[maximum_value]
           ,[location_id]
           ,[create_date]
           ,[create_by]
           ,[cancel_date]
           ,[cancel_by]
           ,[cancel_reason]
           ,[update_date]
           ,[update_by]
           ,[parent_id]
           ,[ref_group]
           ,[ref_other])
VALUES (s.part_no,s.part_name,'-','00',s.cost_price,s.sale_price,s.unit_code,0,0,0,0,'L01',GETDATE(),1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)

WHEN MATCHED THEN UPDATE SET
t.cost_price=s.cost_price,
t.sale_price=s.sale_price,
t.unit_code=s.unit_code;


ROLLBACK TRAN

------------------------------ delete job relate ---------------


BEGIN TRAN

SELECT job_id INTO #temp_job
FROM tbt_job_header
WHERE MONTH(create_date)=8

DELETE FROM tbt_job_checklist
WHERE ckjob_id IN (SELECT * FROM #temp_job)

DELETE FROM tbt_job_image
WHERE ijob_id IN (SELECT * FROM #temp_job)

delete FROM tbt_job_part
WHERE pjob_id IN (SELECT * FROM #temp_job)

delete FROM tbt_job_detail
WHERE bjob_id IN (SELECT * FROM #temp_job)

DELETE FROM tbt_job_header
WHERE job_id IN (SELECT * FROM #temp_job)

DROP TABLE #temp_job


COMMIT tran
-----------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[sp_sendmsg_line]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_sendmsg_line]
	@ProcessText varchar(MAX),
	@token VARCHAR(1000)
AS
BEGIN
----------------------------------------------
Declare @obj as Int;      
Declare @response as varchar(1000);      
DECLARE @newurl varchar(MAX)='http://localhost/LineWeb/SendLine.aspx?msg='+@ProcessText+'&token='+@token   
--DECLARE @newurl varchar(5000)='http://128.1.3.16:8001/api/line?msg='+@ProcessText       --dayend
EXEC Sp_oacreate  'MSXML2.ServerXMLHTTP',@obj OUT;      
EXEC Sp_oamethod @obj,'open',NULL,'get',@newurl,'false'   
EXEC sp_OASetProperty @obj, 'Charset', 'utf-8'     
EXEC Sp_oamethod @obj,'send'
EXEC Sp_oamethod @obj,'responseText',@response OUTPUT         
EXEC Sp_oadestroy @obj     
END
--m3dNJOqKOn65dJ5Vs3umWIZegQG5x7M12JPCBMFHRx7
--WwffLgfoEnLkP0ahspONOmqNhfy1CopGzAZxt3WpAJD
--934NW0lwdz0qTqiZxrOgYDAvBQOqTrdCfJp1MAKq86S
GO
/****** Object:  StoredProcedure [dbo].[sp_update_cut_Stock]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_update_cut_Stock] 
		@part_id	int

AS
BEGIN
	SET NOCOUNT OFF;
	declare @m_log_id int
	declare @locat varchar(3)=''

	select @locat=location_id from tbm_sparepart 
	where part_id=@part_id

	select 
	@m_log_id=
	max(log_id) from tbt_log_part 
	where part_id=@part_id and typelog in (0,1)

	declare @date_var datetime
	select top 1 @date_var=create_date from tbt_log_part 
	where part_id=@part_id and log_id=@m_log_id
	--and typelog=1 ---stock in
----------------------------------------------------------------
	insert into tbt_log_part
	select
		part_id,
		dbo.fn_get_parent_part(@part_id) as parent_id,
		0 as part_value_old,
		(-1*convert(int,total)) as part_value_new,
		null,
		null,
		3 as typelog,--ค่าปัจจุบัน
		dbo.fn_get_onhand(@part_id,null) as onhand,
		'' as remark,
		create_by,
		@date_var,
		part_id,
		NULL as adj_id		 
	from tbt_job_part where 
	 part_id=@part_id and create_date>=@date_var
	select @@ROWCOUNT
END

--exec sp_update_Cut_Stock 390




GO
/****** Object:  StoredProcedure [dbo].[sp_update_cut_Stock_Job]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_update_cut_Stock_Job]
	@job_id varchar(10)
AS
BEGIN
	select pjob_id,part_no,part_id,ROW_NUMBER() over (order by part_id asc) rx into #temp from tbt_job_part jp 
	where jp.pjob_id=@job_id

	declare @rox int,@i int=1
	select @rox=max(rx) from #temp
		begin tran
	while(@i<=@rox)
	begin
		begin try
			declare @part_id int
			select @part_id=part_id from #temp where rx=@i
			--print @part_id
			EXEC sp_update_cut_Stock @part_id
			set @i=@i+1
		end try
		begin catch
				rollback tran
		end catch
	end
	commit tran

END
GO
/****** Object:  StoredProcedure [dbo].[sp_update_receive_job]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_update_receive_job] 
	@job_id VARCHAR(50)=NULL
AS
BEGIN
				UPDATE tbt_job_header
				SET receive_date=GETDATE()
				WHERE job_id=@job_id	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_update_sparepart]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_update_sparepart]
	@P_part_id INT,
	@P_location_id VARCHAR(3),
	@P_part_value INT,
	@P_user_id INT,
	------------------end transfer------------
	@P_part_no VARCHAR(100)=NULL,
	@P_part_name varchar(100)=NULL,
	@p_part_desc VARCHAR(MAX)=NULL,
	@p_part_type VARCHAR(2)=NULL,
	@p_cost_price DECIMAL(10,2)=NULL,
	@p_sale_price DECIMAL(10,2)=NULL,
	@p_unit_code VARCHAR(50)=NULL,
	@P_minimum INT=NULL,
	@P_maximum INT=NULL,
	@P_ref_group VARCHAR(50)=NULL,
	@P_ref_other VARCHAR(50)=NULL,
	@P_part_weight INT=NULL
AS
BEGIN
	SET NOCOUNT OFF;



	DECLARE @create_date datetime=getdate()
	DECLARE @stat_onhand INT
	DECLARE @old_location VARCHAR(3)=NULL
	SELECT @old_location =location_id 
	FROM tbm_sparepart WHERE part_id=@P_part_id

	-------- add part only-------------------
	if (@P_part_id=0)
	BEGIN
	BEGIN TRY
		BEGIN TRAN
		PRINT concat('Add Sparepart : ',@P_part_no)
		INSERT INTO [dbo].[tbm_sparepart]
           ([part_no]
           ,[part_name]
           ,[part_desc]
           ,[part_type]
           ,[cost_price]
           ,[sale_price]
           ,[unit_code]
           ,[part_value]
           ,[part_weight]
           ,[minimum_value]
           ,[maximum_value]
           ,[location_id]
           ,[create_date]
           ,[create_by]
           ,[cancel_date]
           ,[cancel_by]
           ,[cancel_reason]
           ,[update_date]
           ,[update_by]
           ,[parent_id]
           ,[ref_group]
           ,[ref_other])
     VALUES
           (@P_part_no
           ,@P_part_name
           ,@p_part_desc
           ,@p_part_type
           ,@p_cost_price
           ,@p_sale_price
           ,@p_unit_code
           ,0
           ,@P_part_weight
           ,isnull(@P_minimum,0)
           ,isnull(@P_maximum,0)
           ,'L01'
           ,getdate()
           ,@P_user_id
           ,NULL
           ,NULL
           ,NULL
           ,getdate()
           ,@P_user_id
           ,NULL
           ,@P_ref_group
           ,@P_ref_other)

		SELECT 1
		COMMIT TRAN;
		RETURN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;		
	 END CATCH
	
	END


	PRINT concat('Old Location : ',@old_location, '---', 'New Location : ', @p_location_id)
	DECLARE @parent_id INT =dbo.fn_get_parent_part(@P_part_id)
	
	IF (@old_location<>'L01' AND @P_location_id='L01') ---- โอนกลับ main
	BEGIN
	BEGIN TRY
		BEGIN TRAN
		SELECT @stat_onhand=dbo.fn_get_onhand(@P_part_id,NULL)
		IF ((@stat_onhand=0) OR (@stat_onhand<@P_part_value))
			begin
				RAISERROR('Cannot Transfer where Sparepart<=0',16,1); 
				ROLLBACK;
			end
		else
			BEGIN
				EXEC sp_update_Stockin_out
				@part_id=@parent_id,
				@part_no=@P_part_no,
				@adj_part_value=@P_part_value,
				@remark=@p_part_desc,
				@create_by=@P_user_id,
				@adj_type=N'1', --- stock in ที่ main
				@log_type=2
					
				EXEC sp_update_Stockin_out
				@part_id=@P_part_id,
				@part_no=@P_part_no,
				@adj_part_value=@P_part_value,
				@remark=@p_part_desc,
				@create_by=@P_user_id,
				@adj_type=N'-1', --- stock out หักออกจากตัวหลัก
				@log_type=2


				print concat('Insert Log part : Tranfert Back to ',@P_location_id,' :: ',getdate())
				SELECT 1
				COMMIT TRAN
			END

     END TRY
	 BEGIN CATCH
		ROLLBACK TRAN;		
	 END CATCH
	RETURN;
	END


	IF (@old_location='L01' AND @P_location_id<>'L01') --- โอนไปแวน
	BEGIN
	BEGIN TRY
	BEGIN TRAN

		SELECT @stat_onhand=dbo.fn_get_onhand(@P_part_id,NULL)
		IF ((@stat_onhand=0) OR (@stat_onhand<@P_part_value))
		begin
			RAISERROR('Cannot Transfer where Sparepart<=0',16,1); 
			ROLLBACK;
		end
	    
    	
		IF NOT EXISTS(SELECT part_id FROM tbm_sparepart WHERE location_id=@P_location_id AND part_no=@P_part_no) ---ยังไม่เคยโอนไปแวนที่ต้องการ
			BEGIN
				INSERT INTO [dbo].[tbm_sparepart]  ([part_no], [part_name], [part_desc], [part_type], [cost_price], [sale_price], [unit_code], [part_value], [minimum_value], [maximum_value], [location_id], [create_date], [create_by], [cancel_date], [cancel_by], [cancel_reason], [update_date], [update_by],[parent_id],[ref_group],[ref_other],part_weight)
				SELECT								[part_no], [part_name], [part_desc], [part_type], [cost_price], [sale_price], [unit_code], 0, 0, 0, @P_location_id, @create_date, @P_user_id, NULL, NULL, NULL, NULL, NULL,@P_part_id,@P_ref_group,@P_ref_other,@P_part_weight
				FROM [dbo].[tbm_sparepart]
				WHERE part_id=@P_part_id;

				DECLARE @pid_new INT  
				select @pid_new=max(part_id) from tbm_sparepart 
				where part_no=@P_part_no

				EXEC [ISEE_DEV2].[dbo].[sp_update_Stockin_out] 
				@part_id=@pid_new,
				@part_no=@P_part_no,
				@adj_part_value=@P_part_value,
				@remark=@p_part_desc,
				@create_by=@P_user_id,
				@adj_type=N'1', --- stock in
				@log_type=1


				print concat('Insert New Part_id : Tranfert to ',@P_location_id,' :: ',getdate())
			END
		ELSE  -- ถ้าเคยโอนไปแวนที่ต้องการแล้ว
			BEGIN
				DECLARE @ud_part_id INT=NULL
				SELECT @ud_part_id=part_id FROM tbm_sparepart 
				WHERE location_id=@P_location_id AND part_no=@P_part_no

				EXEC [ISEE_DEV2].[dbo].[sp_update_Stockin_out] 
				@part_id=@ud_part_id,
				@part_no=@P_part_no,
				@adj_part_value=@P_part_value,
				@remark=@p_part_desc,
				@create_by=@P_user_id,
				@adj_type=N'1', --- stock in
				@log_type=1

				print concat('Existing Part_id : Tranfert to ',@P_location_id,' :: ',getdate())

			END

				EXEC [ISEE_DEV2].[dbo].[sp_update_Stockin_out] 
				@part_id=@P_part_id,
				@part_no=@P_part_no,
				@adj_part_value=@P_part_value,
				@remark=@p_part_desc,
				@create_by=@P_user_id,
				@adj_type=N'-1', --- stock out หักออกจากตัวหลัก
				@log_type=1
		print concat('Insert Log part : Tranfert to ',@P_location_id,' :: ',getdate())
		select 1

	COMMIT TRAN		
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
	END CATCH
	RETURN;
	END ---end if


	-------------------------------- end Adjust  ค่าในตัวมันเอง -----------------------------------------
	BEGIN TRY	
		BEGIN TRAN
		SELECT @stat_onhand=dbo.fn_get_onhand(@P_part_id,NULL)

		IF EXISTS(SELECT part_id FROM tbm_sparepart WHERE part_id=@P_part_id) --ถ้ามี part ปัจจุบันอยู่แล้วให้เป็นวิธี adj ค่าเอา
		Begin
			PRINT concat('Check @p_part_value <> onhand',':: ',getdate())
			if (@P_part_value<>@stat_onhand)
			BEGIN
			
				EXEC [ISEE_DEV2].[dbo].[sp_update_Stockin_out] 
				@part_id=@P_part_id,
				@part_no=@P_part_no,
				@adj_part_value=@P_part_value,
				@remark=@p_part_desc,
				@create_by=@P_user_id,
				@adj_type=N'0' --- stock out หักออกจากตัวหลัก


				PRINT concat('INSERT adjustment & INSERT log_part Normal CASE ',':: ',getdate())
			END	
		END



		PRINT concat('Update Sparepart Normal CASE', ':: ',getdate())
		UPDATE [dbo].[tbm_sparepart]
			   SET [part_no]	= COALESCE(@P_part_no,part_no),
				   [part_name]	= COALESCE(@P_part_name,part_name)
				  ,[part_desc]	= COALESCE(@p_part_desc,part_desc)
				  ,[part_type]	= COALESCE(@p_part_type,part_type)
				  ,[cost_price] = COALESCE(@p_cost_price,cost_price)
				  ,[sale_price] = COALESCE(@P_sale_price,sale_price)
				  ,[unit_code] =  COALESCE(@p_unit_code,unit_code)
				  ,[part_value]= part_value
				  ,[minimum_value] = COALESCE(@P_minimum,minimum_value,0)
				  ,[maximum_value] = COALESCE(@P_maximum,maximum_value,0)
				  ,[location_id]   = COALESCE(@P_location_id,location_id)
				  --,[ref_group]		= COALESCE(@P_ref_group,ref_group)
				  --,[ref_other]		= COALESCE(@P_ref_other,ref_other)
				  ,[part_weight]	=COALESCE(@P_part_weight,part_weight)
				  ,[update_date] = @create_date
				  ,[update_by] = @P_user_id
			 WHERE part_id=@P_part_id
		SELECT @@ROWCOUNT
		COMMIT TRAN
	END TRY
    BEGIN CATCH
		ROLLBACK TRAN
	END CATCH

	-------------------------------- end Adjust  ค่าในตัวมันเอง -----------------------------------------
END
GO
/****** Object:  StoredProcedure [dbo].[sp_update_start_job]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_update_start_job] 
	@job_id VARCHAR(50)=NULL
AS
BEGIN
				UPDATE tbt_job_header
				SET job_date=GETDATE()
				WHERE job_id=@job_id	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_update_stockin_out]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_update_stockin_out] 
		@adj_type int,		 -- 0=adjust ,1=StockIn,-1=StockOut,3=Cut Stock
		@part_id	int,
		@part_no	varchar(50),
		@adj_part_value	int,
		@remark		varchar(max),
		@create_by	int,	
		@job_id		int=NULL,
		@cut_stock_date datetime=NULL,
		@log_type int =NULL  ---1,2 from  transfer

AS
BEGIN
	SET NOCOUNT OFF;

		---------------------------
	declare @onhand int
	select @onhand=dbo.fn_get_onhand(@part_id,@job_id)
	
	if @log_type is NULL
		SET @log_type=0

	if (@onhand=0 and @adj_type=-1)  ---ไม่มีของห้าม stock out
		return;

begin try
	begin tran
		declare @create_date datetime=getdate()
		INSERT INTO  [tbt_adj_sparepart]
			   (
			   [part_id]
			   ,[part_no]
			   ,[adj_part_value]
			   ,[remark]
			   ,[create_date]
			   ,[create_by]
			   ,[adj_type])
		 VALUES
			   (
			   @part_id
			   ,@part_no
			   ,case when @adj_type=1 then 
							abs(@adj_part_value) 
					 when @adj_type=0 then
							@adj_part_value
					 when @adj_type=-1 then
							abs(@adj_part_value) *-1
					else	
							abs(@adj_part_value) *-1
				end
			   ,@remark
			   ,@create_date
			   ,@create_by
			   ,@adj_type)
		INSERT tbt_log_part
		select 
			@part_id,
			NULL,
			0,
			case when @adj_type=1 then 
							abs(@adj_part_value) 
					 when @adj_type=0 then
							@adj_part_value
					 when @adj_type=-1 then
							abs(@adj_part_value) *-1
					else
							abs(@adj_part_value) *-1
			end,
			0,
			0,
			@log_type, ---type log adjust
			@onhand,
			remark=CASE WHEN @adj_type=0 THEN 'Fix-Admin'
					    when @adj_type=3 Then 'Cut-stock'
						 ELSE @remark END,
			@create_by,
			@create_date,
			@part_id,
			(select max(adj_id) from tbt_adj_sparepart where part_id=@part_id)
		select @@ROWCOUNT
	commit tran	

end try
begin catch
		rollback tran
end catch
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_update_travel_job]    Script Date: 21/09/2566 22:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_update_travel_job] 
	@job_id VARCHAR(50)=NULL
AS
BEGIN
				UPDATE tbt_job_header
				SET travel_date=GETDATE()
				WHERE job_id=@job_id	
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Running number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbm_brand', @level2type=N'COLUMN',@level2name=N'brand_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ref_quataton' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbt_job_header', @level2type=N'COLUMN',@level2name=N'qt_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0=full day,1=first,2=back' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbt_leave', @level2type=N'COLUMN',@level2name=N'leave_path'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'project_name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbt_quotation', @level2type=N'COLUMN',@level2name=N'qt_name'
GO
USE [master]
GO
ALTER DATABASE [ISEE_DEV2] SET  READ_WRITE 
GO
