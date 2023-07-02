-- Script de criação de dimensão de tempo mensal (granularidade a nivel de mes)
SET LANGUAGE Portuguese

DROP TABLE IF EXISTS #DW_DIM_TEMPO_MENSAL_AUTO
CREATE TABLE #DW_DIM_TEMPO_MENSAL_AUTO (
    [NUM_ANO_MES]		  INT			NOT NULL,
    [NUM_MES]             AS            CAST(RIGHT([NUM_ANO_MES], 2) AS INT),
    [NME_MES]             AS			DATENAME(mm, CONCAT([NUM_ANO_MES], '01')),
    [NUM_ANO]             AS			LEFT([NUM_ANO_MES], 4),
	[NME_MES_CURTO]       AS			LEFT(DATENAME(mm, CONCAT([NUM_ANO_MES], '01')), 3),
    [NME_MES_ANO]         AS            (concat(LEFT(DATENAME(mm, CONCAT([NUM_ANO_MES], '01')), 3),'/',LEFT([NUM_ANO_MES], 4))),
	[NME_MES_ANO_LONGO]   AS			(concat(DATENAME(mm, CONCAT([NUM_ANO_MES], '01')),'/',LEFT([NUM_ANO_MES], 4))),
	[NUM_TRIMESTRE]       AS            (datename(quarter,TRY_CAST(concat(LEFT([NUM_ANO_MES], 4),'-',CAST(RIGHT([NUM_ANO_MES], 2) AS INT),'-01') AS [date]))),
    [NME_TRIMESTRE]       AS            (concat(datename(quarter,TRY_CAST(concat(LEFT([NUM_ANO_MES], 4),'-',CAST(RIGHT([NUM_ANO_MES], 2) AS INT),'-01') AS [date])),'º Trimestre')),
    [NME_TRIMESTRE_LONGO] AS            (concat(datename(quarter,TRY_CAST(concat(LEFT([NUM_ANO_MES], 4),'-',CAST(RIGHT([NUM_ANO_MES], 2) AS INT),'-01') AS [date])),'º Trimestre de ',LEFT([NUM_ANO_MES], 4))),
    [NUM_SEMESTRE]        AS            (case when datepart(month,CAST(RIGHT([NUM_ANO_MES], 2) AS INT))<(7) then (1) else (2) end),
    [NME_SEMESTRE]        AS            (concat(case when datepart(month,CAST(RIGHT([NUM_ANO_MES], 2) AS INT))<(7) then (1) else (2) end,'º Semestre')),
    [NME_SEMESTRE_LONGO]  AS            (concat(case when datepart(month,CAST(RIGHT([NUM_ANO_MES], 2) AS INT))<(7) then (1) else (2) end,'º Semestre de ',LEFT([NUM_ANO_MES], 4))),
    [DTA_INCLUSAO]        DATETIME2 (2) CONSTRAINT [DF_DIM_TEMPO_MENSAL_DTA_INCLUSAO] DEFAULT (getdate()) NULL,
    [DTA_ATUALIZACAO]     DATETIME2 (2) NULL,
    [FLG_ATIVO]           BIT           CONSTRAINT [DF_DIM_TEMPO_MENSAL_FLG_ATIVO] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_DW_DIM_TEMPO_MENSAL] PRIMARY KEY CLUSTERED ([NUM_ANO_MES] ASC)
);

DECLARE @DTA_INICIO DATE	= '2005-01-01', 
		@DTA_TERMINO DATE	= '2030-01-01',
		@DTA_REGISTRO DATE  
SET  @DTA_REGISTRO  = @DTA_INICIO

WHILE @DTA_REGISTRO   <= @DTA_TERMINO
BEGIN 
	INSERT INTO #DW_DIM_TEMPO_MENSAL_AUTO
	(
	  NUM_ANO_MES
	)
	VALUES (
		CONCAT(YEAR(@DTA_REGISTRO), RIGHT('0' + CAST(MONTH(@DTA_REGISTRO) AS varchar(2)), 2))
	)

	SET @DTA_REGISTRO = DATEADD(MM, 1, @DTA_REGISTRO)
END 
select * from #DW_DIM_TEMPO_MENSAL_AUTO
