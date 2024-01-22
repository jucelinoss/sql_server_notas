Notas LIVRO - REFERÊNCIA DA CERTIFICAÇÃO MICROSOFT 70-761 

CAPITULO 1 - GERENCIAR DADOS COM T-SQL

Introdução 
SQL Server também suporta C# and Visual Basic, mas T-SQL é a linguagem mais recomendada para manipulação de dados.
T-SQL é um dialeto do SQL. SQL é a linguagem padrão do ISO e ANSI. 
Versões de SQL:
■ SQL-86
■ SQL-89
■ SQL-92
■ SQL:1999
■ SQL:2003
■ SQL:2006
■ SQL:2008
■ SQL:2011

Todos os principais fabricantes do mercardo implementam um dialeto de SQL como linguagem principal para manipulação de dados. 
Cada fabricante decide quais recursos implementar e quais não. 
Cada fabricante também implementa extensões para abranger o que julga necessário. 
Quando um dialeto suporta a versão padrão e específica do dialeto, você sempre deverá optar pela opção padrão, exceto quando a notação do dialeto tenha algum benefício importante que não seja coberto pelo SQL ANSI. 
Exemplo: 
	CAST - SQL ANSI 
	CONVERT - T-SQL 
	Sempre dê preferência pelo SQL ANSI
	Você deve considerar o uso de CONVERT apenas quando precisar confiar no estilo do argumento. 
- Não usar ponto e virgula (;) para encerrar os comandos T-SQL ESTÁ DEPRECIADO. 
- T-SQL ainda aceita comandos sem ponto-e-vírgula, mas você deve adquirir esta prática
- Uma relação no modelo relacional é o que a linguagem SQL usa para representar uma tabela. Assim como na teoria dos conjuntos, uma relação de objetos de um conjunto não precisa estar ordenada. O mesmo vale para SQL. 
- Predicado: proposição lógica avaliada como verdadeira ou falsa. 
- Cursores: você deve evitar o uso de cursores e loops que trabalham linhas por linha
- O modo correto de interagir com as linhas de uma tabela é de uma única vez através de operadores relacionais para se obter um resultado relacional. 
- Tabela, linha e coluna (objetos lógicos)
- Campo e registro (objeto físico)
- NULL - indica ausência de valor (não é um valor em si)
- SQL ANSI suporta NULLS FIRST e NULLS LAST para controlar os nulos, mas T-SQL não suporta
Para que uma consulta seja relacional, ela precisa
- não ter ordenação
- as colunas devem ter nomes únicos
- SQL já foi chamado de SEQUEL -  “structured English query language.”. Mudou de nome por causa de disputa de nome comercial 
- Você não pode utilizar Aliases como filtro, somente a expressão de determinado alias (o filtro é avaliado antes da cláusula SELECT)
Diferença entre WHERE e HAVING
- WHERE - filtro de coluna 
- HAVING - filtro de agrupamento


ORDER BY
- Quando você realiza uma consulta e não indica explicitamente a ordenção, é suposto que o resultado seja relacional. O SQL Server pode escolher entre diferentes modos de acesso para processar a query, sabendo que não precisa garantir a ordenação. 
- Critérios usados pelo SQL para escolher a ordem de exposição dos dados
	- distribuição dos dados
	- disponibilidade de estruturas físicas (como índices) e de harware (memória e CPU por exemplo)
	- mudanças no motor do Banco de dados (upgrade de versão ou de service pack)
- Você pode referenciar as colunas de uma query através da posição (apenas para consultas AD-HOC)
	- Exemplo: ORDER BY 1,3
- Sempre inicie o nome das colunas que você irá ordenar em consultas que serão processadas por sistemas (aplicações, procedures, ETL etc.)
- você pode ordenar por colunas ou expressões (Você deve nomear a coluna na saída da query)
- Consultas ordenadas não são relacionais. Você não pode operar tal resultado em uma query externa porque esta espera como entrada uma consulta relacional. (por isso CTEs não são ordenadas)
- Aliases são visíveis para ordenação (processamento executado no final)
- Sem bons índices, SQL Server precisa ordenar os dados, o que pode ser custoso, principalmente em grandes conjuntos de dados. Se você não precisa de dados ordenados, certifique-se de que não há um comando de ordenação desnecessário. 
- SQL ANSI indica que registros nulos devem ser ordenados junto com os dados, mas cada implementação têm liberdade de escolher a ordem de nulos.
- No SQL Server, registros nulos antecedem os não nulos (ordem ascendente)
- SQL ANSI suporta as opções NULLS FIRST e NULLS LAST para configurar a ordem dos nulos, mas o SQL Server não suporta sta opção.  
- uma consulta com ORDER BY conceitualmente retorna um cursor e não uma relação de dados. 

Campos nulos
- predicados com valores NULL resultam em um valor desconhecido (exceto com IS NULL ou IS NOT NULL)
- Você precisa saber o que acontece quando há campos nulos na construção da query (filtro, ordenação, agrupamento, join, interseção. 
- Você deve se perguntar se pode haver nulos nos dados manipulados. Em caso afirmativo, você precisa garantir em seus testes que sua consulta consegue tratá-los. 

Processamento lógico de consultas
Lado lógico de uma query - interpretação conceitual do que a query faz
Lado físico - processamento da query pela engine de Banco de Dados. 

SELECT 
- Usado para retornar as colunas e /ou expressões desejadas
- Pode-se usar o asterisco (*) para retornar todos os campos (não recomendado)
- O uso de asterisco pode tornar a consulta lenta ao trazer mais campos do que o desejado
- O uso de asterisco pode enviar mais dados do que o necessário pela rede. 
- Ao trazer as colunas desejadas, você preve o SQL Server de  usar índices de cobertura 
- Dê preferência para informar as colunas desejadas em suas consultas
- Recomenda-se usar a cláusula AS (é padrao SQL e torna o código mais legível)
- o Uso de Aliases ajuda a tornar a consulta relacional (evita colunas repetidas e / ou sem nome)
- Em caso de registros duplicados, T-SQL não irá eliminá-los, exceto quando instruído
- Um resultado com dados duplicados não é considerado relacional porque relações (conjuntos de dados) não devem ter dados repetidos. 
- Usa-se a cláusula DISTINCT para eliminar os registros duplicados
- T-SQL suporta comandos SELECT sem a cláusula FROM, enquanto que o SQL ANSI exige as cláusulas SELECT e FROM (como ocorre no Oracle, que geralmente se usa a tabela DUAL)

DELIMITADORES
- T_SQL suporta colchetes e aspas duplas para delimitar objetos de estrutura do banco
- O primeiro caractere deve ser letra no padrão Unicode [A-Z][a-z], @ ou #
- Os caracteres subsequentes podem incluir letras, numeros decimais, $ ou _. 
- Os objetos não podem usar palavras reservadas do sistema, ter espacos em branco
- Identificadores que não contemplam estas regras precisam ser delimitados, como [2017] ou "2017"

Predicados
- Avaliam proposições logicas através de colunas, funções ou variáveis. 
- O predicado avalia como desconhecido quando um dos lados da comparação for nulo caso não seja usado IS NULL / IS NOT NULL
- registros avaliados como desconhecido são descartados, tanto em filtros quanto em joins
- Você pode combinar predicados através os operadores lógicos AND  (e) e OR (ou), além de NOT para negação. 
- Não se esqueça de isolar predicados com OR se houver outros no mesmo nível 
Exemplo: 
	WHERE col1 = 'w' AND (col2 = 'x' OR col3 = 'y') AND col4 = 'z'
Devido ao conceito de tudo-na_primeira-vez do SQL Server, nem sempre a engine do banco avalia os predicados da esquerda para a direita. Baseado em questões de custo, o motor do banco pode avaliar a segunda expressão e partir para a primeira em seguida. 
- Quando você monta uma expressão usando diferentes tipos de dados, o SQL Server faz a conversão implícita, que pode piorar a performance
- É importante saber o tipo apropriado do termo literal usado nos predicados para que o banco realize a consulta com os tipos corretos. 
Exemplo Clássico: 
- Misturar tipos de dados Unicode com tipos não-Unicode
- A forma correta é utilizar a letra N antes do valor de caracteres desejado: WHERE lastname = N'Davis'

PREDICADO LIKE 
- Suporta texto literal e também caracteres curinga
+-------------------------------+---------------------------------------+---------------------------------------------------+
|  Caractere coringa 			|			Significado 		   		|					Exemplo						   	|
+-------------------------------+---------------------------------------+---------------------------------------------------+
|			% 					|	Qualquer texto mesmo vazio			|	'D%'	 - Texto iniciado com a letra D		  	|
+-------------------------------+---------------------------------------+---------------------------------------------------+
|			_					|	Um caractere						|	'_D%'	 - Texto cuja segunda letra é D			|
+-------------------------------+---------------------------------------+---------------------------------------------------+
|	[<lista de caracteres>]		|	Um caractere da lista				|	'[AC]%'   - Texto iniciado com a letra A ou C	|
+-------------------------------+---------------------------------------+---------------------------------------------------+
|	[<range de caracteres>]		|	Um caractere do range				|	'[0-9]%'  - Texto iniciado com um número		|
+-------------------------------+---------------------------------------+---------------------------------------------------+
| [^<lista/range de caracteres>]|	Um caractere fora da lista / range	|	'[^0-9]%' - Texto não iniciado com um número	|
+-------------------------------+---------------------------------------+---------------------------------------------------+

Caractere de Escape - palavra-chave ESCAPE {texto_escape} ou [texto_escape]

Exemplo
WITH 
LIKE_WILDCARD AS (
SELECT '_' AS ID 
UNION SELECT '1' 
UNION SELECT '2'
UNION SELECT '3'
UNION SELECT 'Diamante'
UNION SELECT 'C120'
UNION SELECT 'ACONCÁGUA'
UNION SELECT 'New'
)
SELECT * FROM LIKE_WILDCARD WHERE 
	 ID LIKE '!_%' ESCAPE '!'
	OR ID LIKE '[_]%'
	OR ID LIKE '[AC]%'
	OR ID LIKE '[0-9]%'
	OR ID LIKE 'C[0-9]%'
	OR ID LIKE 'D%'
	OR ID LIKE '_e%'

PREDICADOS COM DATAS
- Deve-se tomar cuidado com ranges de data do tipo DATETIME
- O modo recomendado é utilizar um intervalo aberto e um fechado 
	WHERE orderdate >= '20160401' AND orderdate < '20160501';
Exemplo de problema 
	WHERE orderdate BETWEEN '20160401' AND '20160430 23:59:59.999' 
DATETIME trabalha com arredondamento de 3 ms. Já que 999 não é um multiplo dessa precisão, o valor é arredondado para o próximo ms, avançando para meia-noite do próximo dia. 

TOP
Permite filtrar os X primeiros registros da consulta (valor absoluto ou percentual)
A ordem dos registros exibidos é a mesma da consulta
Dica de exame - Pode ser usado com ou sem parênteses por questão de compatibilidade. Recomenda-se o uso de parênteses. 
Parâmetros 
	TOP Absoluto -  BIGINT
	TOP PERCENT  - FLOAT
TOP(X) PERCENT - arredonda para cima o valor percentual
Exemplo: numa tabela de 499 registros, são retornados 50 linhas num TOP(10) PERCENT
O valor do TOP pode ser parametrizado em uma variável 
Não há garantias de retornar os mesmos dados se a consulta não estiver ordenada
Se você realmente quer linhas arbitrárias, é uma boa idéia adicionar uma cláusula ORDER BY com a expressão (SELECT NULL) para que as pessoas saibam que é intencional.
O filtro TOP é processado depois das cláusulas FROM, WHERE, GROUP e SELECT 

TOP WITH TIES 
Utilizado para trazer também os registros cuja ordenação está empatada. 
Se não for colocado será apresentado apenas os x registros, ignorando os que estão empatados com o ultimo registro exibido. 

OFFSET-FETCH
Usado para filtrar registros em tarefas especificas de paginamento
Pode ser usado para filtrar dados baseado em um número especificado de linhas
Possui a capacidade de pular linhas (útil para finalidades ad-hoc)
Seleciona dados semelhante a um recorte. 
Exemplo: 
Num ranking de alunos, pode ser utilizado para retornar os que se encontram entre a posição 100 e 200
Requer ordenação
As cláusulas OFFSET e FETCH aparecem depois do ORDER BY 
OFFSET - especifica quantas linhas serão ignoradas (0 indica nenhuma)
FETCH - indica quantas linhas você deseja trazer
a partir do que foi ignorado
Se você deseja filtrar as x primeiras linhas, utilize OFFSET 0  
Row pode ser usado no plural e no singular. 
NEXT e FIRST podem ser alternados (são sinônimos no comando OFFSET-FETCH)
Ao pular algumas linhas pode ser mais intuitivo usar FETCH NEXT, mas quando não tiver pulado nenhuma faz mais sentido usar FETCH FIST (apenas muda conceitualmente a leitura da consulta)
T-SQL, diferentemente do SQL ANSI, requer que a cláusula FETCH seja precedida da cláusula OFFSET. 
A cláusula OFFSET não exige a cláusula FETCH (indica para pular as linhas do OFFSET e mostrar todas as restantes)
Se você precisar filtrar certo número de linhas em uma ordem arbitrária, sem ordenar alguma coluna, pode usar ORDER BY (SELECT NULL)
OFFSET-FETCH aceita expressões e variáveis como entrada. 
OFFSET e TOP podem ser vistos como extensões do ORDER BY 

Dica de exame 
O filtro OFFSET-FETCH é processado depois das cláusulas FROM, WHERE, GROUP e SELECT, DISTINCT e ROW_NUMBER. 
DISTINCT e ROW_NUMBER são processados depois das cláusulas FROM, WHERE, GROUP e SELECT, 
OFFSET-FETCH faz parte do SQL-ANSI, enquanto o TOP não. 
OFFSET-FETCH deve ser usado no lugar de TOP quando as consultas forem equivalentes
OFFSET-FETCH tem a vantagem de pular as primeiras linhas em relação ao TOP. 
OFFSET-FETCH não suporta PERCENT e WITH TIES
Sob a ótica de performance, as colunas ordenadas devem er indexadas

SINTAXE 
SELECT [campos]
from [TABELA] ORDER BY [COLUNAS ]
OFFSET [X] ROWS FETCH [NEXT | FIRST] [Y] ROWS ONLY;

Operadores de conjuntos (SET OPERATORS)
Trabalham com dois result sets de consultas, comparando todas as colunas e linhas de cada consulta.
- UNION, UNION ALL, EXCEPT, INTERSECT
- Já que todas as linhas são comparadas, o número de colunas deve ser o mesmo em ambas as consultas
- Esses operadores fazem comparações baseadas em distinção e não em igualdade
- comparações com nulos retornam Verdadeiro, enquanto comparações de nulos com não nulos retornam falso, além das comparações entre não nulos
- cada query não pode ter ORDER BY (são operadores de conjunto e não operadores de cursor)
- você pode adicionar a ordenação no final, que será aplicada no resultado da comparação entre os conjuntos
- o nome das colunas apresentados são definidos pela primeira query

Dica de exame - 
O termo "operador de conjunto" não é o mais preciso para descrever os operadores UNION, INTERSECT e EXCEPT. Eles são na verdade Operadores relacionais. 
Considerando que na teoria dos conjuntos da matemática você pode unificar dois conjuntos de dados distintos, na teoria relacional não. 
Você só pode unificar conjuntos que possuem os mesmos atributos. 
Para mais detalhes:  http://sqlblog.com/blogs/dejan_sarka/archive/2014/01/10/sql-set-operators-set-really.aspx
Tanto a comunidade SQL quanto a documentação oficial de T-SQL usam o termo "operador de conjunto". 
Existe a chance de ambas as terminologias serem usadas no exame. 


UNION e UNION ALL
- juntam os resultados de duas queries. 
- UNION remove os duplicados, enquanto UNION ALL não. 
- UNION ALL é mais performático (não realiza comparações de duplicidade), mas pode duplicar registros
- quando você conseguir garantir que as consultas não possuem duplicidade, recomenda-se usar UNION ALL, para que não seja realizada a verificação de repetição que é feita pelo UNION (melhora a performance)

Nota 
- Para ver o plano de execução em modo gráfico no SSMS, utilize o comando Ctrl + M 
- Para mais informações:  http://sqlmag.com/t-sql/understanding-query-plans

INTERSECT 
- Retorna apenas os registros comuns a ambas as queries, removendo os registros duplicados. 
- Não importa quantas vezes o registro aparece de cada lado, se for comum a ambas as consultas, aparecerá apenas uma vez (se quiser repetições utilize consultas com INNER JOIN )

EXCEPT
- Retorna a diferença de conjuntos (A-B), ou seja, os registros da primeira consulta que não aparecem na segunda. 

Operadores de conjunto possuem ordem de precedência 
- INTERSECT precede UNION e EXCEPT
- UNION e EXCEPT são avaliados da esquerda para a direita 
Exemplo: 
	<query 1> UNION <query 2> INTERSECT <query 3>;
Equivale a 
	<query 1> UNION (<query 2> INTERSECT <query 3>);
Se você precisa executar a união antes, deve explicitar a ordem de precedência através de parênteses	
	(<query 1> UNION <query 2>) INTERSECT <query 3>;



Para mais informações 
Processamento lógico de consultas:
■ Part 1 at http://sqlmag.com/sql-server/logical-query-processing-what-it-and-what-itmeans-you
■ Part 2 at http://sqlmag.com/sql-server/logical-query-processing-clause-and-joins
■ Part 3 at http://sqlmag.com/sql-server/logical-query-processing-clause-and-apply
■ Part 4: http://sqlmag.com/sql-server/logical-query-processing-clause-and-pivot
■ Part 5 at http://sqlmag.com/sql-server/logical-query-processing-part-5-clause-andunpivot
■ Part 6 at http://sqlmag.com/sql-server-2016/logical-query-processing-part-6-whereclause
■ Part 7 at http://sqlmag.com/sql-server/logical-query-processing-part-7-group-andhaving
■ Part 8 at http://sqlmag.com/sql-server/logical-query-processing-part-8-select-and-order

------------------------------------------------------------------------------------------------

JOINs

CROSS JOIN
- é o tipo de junção mais simples
- realiza um cruzamento cartesiano (cruza todos os registros de uma tabela com todos os de outra) 
- semelhante a A x B
- o uso de alias é obrigatório quando é realizada uma junção de uma tabela com ela mesma
- é conveniente utilizar aliases para simplificar o nome da tabela
- T-SQL e SQL-ANSI permitem o uso da sintaxe antiga para a realização de CROSS JOIN (FROM T1, T2)
- Evite utilizar a sintaxe antiga: está mais propensa a erros. Se você esquecer de indicar algum predicado de junção, a consulta acarretara um cross join não intencional. 

A nova sintaxe proporciona um código mais legível e consistente
Predicate pushdown (Flexão do predicado) - técnca de otimização do SQL Server que avalia primeiro os filtros, para em seguida combinar as linhas restantes

INNER JOIN (também conhecido por Equi join)
- realiza a combinação de tabelas ou consultas que atendem aos critérios definidos, retornando os registros comuns a ambos os lados (funciona como intersecção de consultas ou tabelas)
- ao juntar tabelas, você deve usar relacionamentos de chave única (PK - FK)
- Campos de Chave primária ou UNIQUE são criados com Índice único nas coolunas que fazem parte da constraint para garantir unicidade da constraint. 
- quando você cria columnas com chave estrangeira, os índices não são criados automaticamente. Você deve criá-los quando forem úteis. 
- ao trabalhar com otimização de índices, é interessante avaliar as chaves estrangeiras
- é uma boa prática utilizar aliases para referenciar corretamente cada coluna, tornando o código mais claro. 
- Para Equijoins, não há diferença prática para as cláusulas ON e WHERE
- Nos equijoins, ON e WHERE  filtram apenas as linhas que atendem aos predicados, discartando as que resultam em falso ou desconhecido (comparações com valores nulos)
- na lógica de processamento da query, a cláusula WHERE é avaliada logo após a cláusula FROM (conceitualmente equivale a concatenar os predicados com um operador AND)
- Internamente o SQL Server pode reorganizar a ordem de execução dos filtros baseados em estimativas de custo (por isso é possível colocar todos os predicados na cláusula ON ou WHERE, embora não seja recomendado misturar o local de filtros de joins para manter a clareza do código)
Por outro lado, as cláusulas ON e WHERE executam diferentes tarefas. Cabe a você avaliar qual é mais apropriada para cada um dos predicados. 

Exemplo de INNER JOIN com set operators
SELECT EL.country, EL.region, EL.city, EL.numemps, CL.numcusts
	FROM dbo.EmpLocations AS EL
INNER JOIN dbo.CustLocations AS CL
ON EXISTS (SELECT EL.country, EL.region, EL.city
			INTERSECT
			SELECT CL.country, CL.region, CL.city);

LEFT (OUTER) JOIN
- Retorna dos os dados da tabela / consulta à esquerda + correspondeências de tabela / consulta da direita

RIGHT (OUTER) JOINS
- Retorna dos os dados da tabela / consulta à direita + correspondeências de tabela / consulta da esquerda

ON e WHERE em OUTER JOINS
- As cláulas ON e WHERE atuam de forma diferente em OUTER JOINS
- A cláusula ON filtra apenas os registros que possuem correspondência na outra tabela (o filtro não funciona quando não há correspondência)
A cláusula ON não é determinante para filtrar o lado preservado o join, mas sim a cláusula WHERE

FULL JOIN 
- Retorna os registros que combinaram (INNER JOIN) + registros da esquerda sem correspondência com a direita (LEFT JOIN) + registros da direita sem correspondência com a esquerda (RIGHT JOIN)
- não é comum precisar de FULL JOIN porque a maioria dos relacionamentos é unilateral (não é necessário os dois lados para saber o que não combina com o outro lado)


COMPOSITE JOIN (join composto) - cruzamento que envolve mais de um predicado

TRATAMENTO DE NULOS EM JOINS
- Evite o uso de ISNULL ou COALESCE em joins para tratar nulos porque afeta consideravelmente a performance. 
- utilize a sintaxe abaixo: 
Errado 
	ON ISNULL(A.ID, 0) = ISNULL(B.ID, 0)
Correto
	A.ID = B.ID OR (A.ID IS NULL AND B.ID IS NULL)
	
Consultas com múltiplos joins
Conceitualmente, um join em T-SQL avalia duas tabelas por vez
O resultado de um join vira entrada para o próximo (não compreender isto pode levar a erros nas consultas com múltiplos joins)
Exemplo
	SELECT
		S.companyname AS supplier, S.country,
		P.productid, P.productname, P.unitprice,
		C.categoryname
	FROM Production.Suppliers AS S
	LEFT OUTER JOIN Production.Products AS P
	ON S.supplierid = P.supplierid
	INNER JOIN Production.Categories AS C
	ON C.categoryid = P.categoryid
	WHERE S.country = N'Japan';
	
Para evitar que os registros nulos do outer join se percam ao cruzá-lo com um inner join, devemos:
- trocar o inner join por left join para não haver perda de registros ou
	SELECT
		S.companyname AS supplier, S.country,
		P.productid, P.productname, P.unitprice,
		C.categoryname
	FROM Production.Suppliers AS S
	LEFT OUTER JOIN Production.Products AS P
	ON S.supplierid = P.supplierid
	LEFT JOIN Production.Categories AS C
	ON C.categoryid = P.categoryid
	WHERE S.country = N'Japan';

- separar os joins logicamente através de parenteses
	SELECT
		S.companyname AS supplier, S.country,
		P.productid, P.productname, P.unitprice,
		C.categoryname
	FROM Production.Suppliers AS S
	LEFT OUTER JOIN
	(
		Production.Products AS P
		INNER JOIN Production.Categories AS C
		ON C.categoryid = P.categoryid
	)
		ON S.supplierid = P.supplierid
		WHERE S.country = N'Japan';

- A ordem dos predicados da cláusula ON define a ordenação lógica do join. 

Dica de Exame
Joins múltiplos que misturam diferentes tipos de dados são muito comuns na prática. 
Há uma grande possibilidade de caírem no exame
Certifique-se de que você entende as armadilhas ao misturar tipos de joins quando um outer join é seguido de um inner join, que descarta as linhas da junção anterior. 

------------------------------------------------------------------------------------------------

Funções e agregação de dados

T-SQL suporta muitas funções incorporadas (built-in) para manipular dados
- scalar-valued functions - retornam um único valor
- table-valued functions - retornam o resultado no formato de tabela
O uso de funções incorporadas pode melhorar a produtividade do desenvolvedor, mas você precisa entender quando cada uma é mais adequada, além do determinismo funcional (capacidade de uma função sempre retornar o mesmo valor ou não com os mesmos parâmetros) e seus efeitos nas consultas 

Funções de conversão de tipos
Principais funções - CAST(SQL-ANSI) e CONVERT(T-SQL)

PARSE 
	função alternativa ao CONVERT
	a passagem de parâmetros é mais amigável 
	Exemplo: 
		select PARSE('01/02/2017' AS DATE USING 'PT-BR')
	é mais lenta do que a função CONVERT
	recomenda-se não usá-la
Tratamento de erros 
- Para evitar erros, usamos as funções
	TRY_CAST( [coluna] AS [tipo de dado])
	TRY_CONVERT( data_type [ ( length ) ] , expression [ , style ])
	TRY_PARSE(string_value AS data_type [ USING culture ] )
- retorna nulo em caso de erros
- T-SQL também suporta 

FORMAT
- alternativa para a função CONVERT quando você quiser formata uma expressão, especificando o formato usado na arquitetura .NET
Ex.: 
	SELECT FORMAT(GETDATE(), N'yyyy-MM-dd')
Assim PARSE, FORMAT é um pouco lento
Quando precisar formatar muitos números em uma consulta, opte por funções mais performáticas

Para mais informações, consulte 
https://msdn.microsoft.com/en-us/library/hh213505.aspx http://msdn.microsoft.com/en-us/library/26etazsy.aspx

-------------------------------------------------------
Funções de data e hora

A lista completa de funções pode ser vista em  
https://msdn.microsoft.com/en-us/library/ms186724.aspx

Data e hora atual
GETDATE()				- T-SQL; retorna a data e hora da instância do SQL Server no formato DATETIME
CURRENT_TIMESTAMP       - SQL-ANSI; faz o mesmo que GETDATE(); é a mais recomendada
GETUTCDATE()            - T-SQL; retorna a data e hora UTC da instancia do SQL Server no formato datetime
SYSDATETIME()           - T-SQL; retorna a data e hora da instância do SQL Server no formato DATETIME2(7)
SYSUTCDATETIME()        - T-SQL; retorna a data e hora UTC da instancia do SQL Server no formato datetime2(7)
SYSDATETIMEOFFSET()     - T-SQL; retorna a data e hora da instância do SQL Server no formato DATETIMEOFFSET(7) [FUSO]

	Exemplo para testar
	SELECT GETDATE() 			as [GETDATE]
	SELECT CURRENT_TIMESTAMP	as [CURRENT_TIMESTAMP]
	SELECT GETUTCDATE()			as [GETUTCDATE]
	SELECT SYSDATETIME()		as [SYSDATETIME]
	SELECT SYSUTCDATETIME()		as [SYSUTCDATETIME]
	SELECT SYSDATETIMEOFFSET()	as [SYSDATETIMEOFFSET]

	Não há funções que retornam apenas a data ou hora. As funções acima devem ser convertidas para o formato desejado

Partes e data e hora
DATEPART ( datepart , date ) - permite extrair partes de determinada data
DATENAME ( datepart , date ) - permite extrair partes de determinada data por extenso (bsaeado na linguagem da sessão)
YEAR	 ( date	)			 - permite extrair o número do ano
MONTH	 ( date	)			 - permite extrair o número do mês
DAY		 ( date )			 - permite extrair o número do dia

	Exemplo
	DECLARE @HOJE DATE = CAST(GETDATE() AS DATE)
	SELECT DATEPART(MONTH, @HOJE) DATEPART, DATENAME(MONTH, @HOJE)DATENAME, YEAR(@HOJE) YEAR, MONTH(@HOJE) MONTH, DAY(@HOJE) DAY

	DATEPART DATENAME   YEAR  MONTH DAY
	-------- ---------- ----- ----- ---
	5        May        2020  5     27 

DATENAME() é uma função dependente da linguagem

-- GERAÇÃO DE DATA A PARTIR DAS PARTES
DATEFROMPARTS ( year, month, day )
	- retorna a data através dos parametros informados no formato DATE
DATETIMEFROMPARTS ( 	year, month, day, hour, minute, seconds, milliseconds )
	- retorna a data através dos parametros informados no formato DATETIME
DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision ) 										
	- retorna a data através dos parametros informados no formato DATETIME2
DATETIMEOFFSETFROMPARTS ( year, month, day, hour, minute, seconds, fractions, hour_offset, minute_offset, precision )             
	- retorna a data através dos parametros informados no formato DATETIMEOFFSET
SMALLDATETIMEFROMPARTS ( year, month, day, hour, minute )              
	- retorna a data através dos parametros informados no formato SMALLDATETIME
TIMEFROMPARTS ( hour, minute, seconds, fractions, precision )                         
	- retorna a data através dos parametros informados no formato TIME
EOMONTH ( start_date [, month_to_add ] ) - retorna o último dia do atual ou da quantidade de meses a frente ou atras (negativo)
Exemplo: 
	SELECT EOMONTH(GETDATE()) EOMONTH_ATUAL, EOMONTH(GETDATE(), 1) EOMONTH_PROX_MES, EOMONTH(GETDATE(), -1) EOMONTH_ULT_MES
	
DATEADD (datepart , number , date )  
	Avança / retrocede a data conforme o período desejado 
	Exemplo: 
		SELECT GETDATE()DATA_ATUAL, DATEADD(M,  1, GETDATE()) DATEADD_1_MES
			
			DATA_ATUAL              DATEADD_1_MES
		----------------------- -----------------------
		2020-05-27 22:03:26.597 2020-06-27 22:03:26.597

DATEDIFF ( datepart , startdate , enddate ) 
	Calcula a diferença de períodos do intervalo informado
	Exemplo: 
		select DATEDIFF(D, '2010-01-01', '2010-05-01') DIFERENCA_EM_DIAS
		
		DIFERENCA_EM_DIAS
		-----------------
		120
	DATEDIFF retorna valores INT. Se a diferença for muito grande (como a diferença em millisegundos), utilize a função DATEDIFF_BIG
	
SWITCHOFFSET ( DATETIMEOFFSET, time_zone )  
	- retorna a data informada conforme o fuso-horário determinado 
	Exemplo
		SELECT CAST('1998-09-20 07:45:50.7134500 -05:00' AS DATETIMEOFFSET) DATETIMEOFFSET, 
			SWITCHOFFSET ('1998-09-20 07:45:50.7134500 -05:00', '-08:00')   SWITCHOFFSET_UTC_MENOS8H

	DATETIMEOFFSET                     		SWITCHOFFSET_UTC_MENOS8H
	---------------------------------- 		----------------------------------
	1998-09-20 07:45:50.7134500 -05:00 		1998-09-20 04:45:50.7134500 -08:00

	TODATETIMEOFFSET ( expression , time_zone )  
	- altera o fuso-horário da expressão informada 
	- é útil para converter uma data sem UTC em data com UTC sem realizar manipulação de string
	- atente-se para a questão do horário de verão ao definir o UTC 
	
	SELECT TODATETIMEOFFSET('20170212 14:00:00.0000000', '-08:00') AS [TODATETIMEOFFSET1], 
	TODATETIMEOFFSET('20170212 14:00:00.0000000', '-02:00') AS [TODATETIMEOFFSET2]
	
	TODATETIMEOFFSET1                  TODATETIMEOFFSET2
	---------------------------------- ----------------------------------
	2017-02-12 14:00:00.0000000 -08:00 2017-02-12 14:00:00.0000000 -02:00

	Expressão AT TIME ZONE - Permite configurar o UTC por extenso, evitando confusões com UTC em horas ou com horário de verão
	- equivalente à função TODATETIMEOFFSET, cujo UTC é informado por extenso
	
	select getdate() AT TIME ZONE 'Pacific Standard Time';
	
---------------------------------------------------------------------------------------------------

Funções de caractere

Concatenação 
- T-SQL suporta duas formas de concatenação
	- (+)	
		Atenção
		Por padrão, 'TEXTO'	 + NULL RESULTA EM NULL. Isso pode ser alterador desativando a variavel de sessão CONCAT_NULL_YELDS_NULL (SETR CONCAT_NULL_YELDS_NULL OFF), mas não será possível desativar tal recurso no futuro
		Exemplo 
			SELECT 'A' + NULL AS [CONCATENACAO_+]
			CONCATENACAO_+
			--------------
			NULL
		
	- CONCAT('texto1', 'texto2')
		concatena os textos informados nos parâmetros 
		substitui Nulo por uma string vazia na concatenação
		EXEMPLO
		SELECT CONCAT('A', NULL, 'B') CONCAT

EXTRAÇÃO E POSIÇÃO DE SUBSTRINGS
SUBSTRING ( expression ,start , length ) - retorna parte de uma cadeia de caracteres / binária
	Exemplo 
		SELECT SUBSTRING('ABCDE',2, 3) AS SUBSTRING

		SUBSTRING
		---------
		BCD

LEFT ( character_expression , integer_expression ) - retorna a parte da esquerda de uma cadeia de caracteres
	Exemplo
		SELECT LEFT('ABCDE', 3) AS [LEFT]
	
		LEFT
		----
		ABC
 
RIGHT ( character_expression , integer_expression ) - retorna a parte da direita de uma cadeia de caracteres
	Exemplo
		SELECT RIGHT('ABCDE', 3) AS [RIGHT]
	
		RIGHT
		-----
		CDE

CHARINDEX ( expressionToFind , expressionToSearch [ , start_location ] )  - retorna a posição da primeira ocorrência do texto procurado na expressão informada
	- análogo à função index_of 
	- o terceiro parametro indica a partir de onde será realizada a busca
	Exemplo
		SELECT CHARINDEX('CD', 'ABCDEF') [CHARINDEX]
		CHARINDEX
		-----------
		3

		SELECT CHARINDEX('CD', 'ABCDEF', 2 ) [CHARINDEX]
		CHARINDEX
		-----------
		3

		SELECT CHARINDEX('CD', 'ABCDEF', 4) [CHARINDEX]
		CHARINDEX
		-----------
		0

PATINDEX ( '%pattern%' , expression )  - retorna a posição da primeira ocorrência do padrão procurado na expressão informada
	- utiliza os mesmos caracteres coringa da cláusula LIKE
	Para mais informações
		https://msdn.microsoft.com/en-us/library/ms188395.aspx
		https://msdn.microsoft.com/en-us/library/ms179859.aspx
	Exemplo
		SELECT PATINDEX('%[0-9]%','ABCD123EFGH') [PATINDEX]
		
		PATINDEX
		-----------
		5

Tamanho de strings
LEN ( string_expression )  - retorna o tamanho de caracteres (não de bytes) da string informada 
	Espaços em branco após a cadeia de caracteres são desconsiderados na contagem (espaços no início ou no meio são contados) 
	Exemplo
	SELECT LEN('XYZ') LEN_NON_UNICODE, LEN(N'XYZ') LEN_UNICODE, LEN('XYZ    ') LEN_SPACED_RIGHT, LEN(' XYZ    ') LEN_SPACED_LEFT_RIGHT
	
	LEN_NON_UNICODE LEN_UNICODE LEN_SPACED_RIGHT LEN_SPACED_LEFT_RIGHT
	--------------- ----------- ---------------- ---------------------
	3               3           3                4

DATALENGTH ( expression ) - retorna o tamanho do espaço ocupado pelo parâmetro informado
	Espaços em branco no início, meio ou final são considerados
	Exemplo
	SELECT DATALENGTH('XYZ') DATALEN_NON_UNICODE, DATALENGTH(N'XYZ') DATALEN_UNICODE, 
		DATALENGTH('XYZ ') DATALEN_NON_UNICODE_SPACED, DATALENGTH(N' XYZ') DATALEN_UNICODE_SPACED 
	
	DATALEN_NON_UNICODE DATALEN_UNICODE DATALEN_NON_UNICODE_SPACED DATALEN_UNICODE_SPACED
	------------------- --------------- -------------------------- ----------------------
	3                   6               4                          8

Alteração de strings

REPLACE ( string_expression , string_pattern , string_replacement ) - troca todas as ocorrências de uma expressão por outra 
	Exemplo 
		SELECT REPLACE('.1.2.3.', '.', '/') AS REPLACE
		REPLACE
		--------
		/1/2/3/
		
REPLICATE ( string_expression ,integer_expression )	- REPETE um valor x vezes
	Exemplo
		SELECT REPLICATE('0', 10) AS REPLICATE
	
		REPLICATE
		----------
		0000000000
	
STUFF ( character_expression , start , length , replaceWith_expression ) - insere uma cadeia de caracteres no lugar de outra. 
	Exemplo 
		SELECT STUFF('ABCDEF', 2, 3, 'IJKLMN') STUFF -- troca 3 caracteres da expressão 'ABCDEF' a partir da posição 2 e substitui pela expressão do 4o parâmetro
		
		STUFF
		---------
		AIJKLMNEF
	
Formatação 

UPPER ( character_expression ) - retorna a expressão em caixa alta
LOWER ( character_expression ) - retorna a expressão em caixa baixa
LTRIM ( character_expression ) - retorna a expressão sem os espaços em branco à esquerda
RTRIM ( character_expression ) - retorna a expressão sem os espaços em branco à direita

A função TRIM() está disponível apenas a partir da versão SQL Server 2017
É necessário utilizar as funções em conjunto RTRIM(LTRIM(texto)) ou LTRIM(RTRIM(texto)) 

FORMAT ( value, format [, culture ] )  - retorna o valor formatado no padrão especificado. 
	pode ser usado para formatação de data e hora ou strings
	para conversoes, use CAST ou CONVERT
	Exemplo 
	SELECT FORMAT(1759, '0000000000') FORMAT_STR, FORMAT(GETDATE(), 'yyyy-MM-dd') FORMAT_DATE
	FORMAT_STR  FORMAT_DATE
	----------- -----------
	0000001759  2020-05-28


Divisão de strings (split)
STRING_SPLIT ( string , separator ) - divide uma cadeia de caracteres em colunas através do separador especificado
	retorna uma tabela com uma coluna dos valores quebrados
	Exemplo 	
	
	ALTER DATABASE TSQLV4 SET COMPATIBILITY_LEVEL = 130

	DECLARE @tags NVARCHAR(400) = 'clothing,road,,touring,bike'  
	SELECT value  FROM STRING_SPLIT(@tags, ',')  WHERE RTRIM(value) <> '';

CASE 
CASE é uma expressão, e não um statement (declaração)
Valor default - NULL
COALESCE(), NULLIF(), ISNULL(), IIF() e CHOOSE() são funções que atuam como abreviações de expressões CASE

	
Tratamento de Nulo 
ISNULL ( check_expression , replacement_value ) - substitui o valor nulo pelo valor especificado 
	T-SQL
	um pouco mais limitado do que COALESCE()
COALESCE ( expression [ ,...n ] )			   -  retorna o valor do primeiro parâmetro não-nulo
	SQL-ANSI

Diferenças entre ISNULL e COALESCE
1 - O tipo de dado retornado da função COALESCE é determinada pelo elemento retornado, enquanto na função ISNULL() o valor retornado é determinado pelo primeiro parâmetro
	DECLARE
		@x AS VARCHAR(3) = NULL,
		@y AS VARCHAR(10) = '1234567890';
	SELECT COALESCE(@x, @y) AS [COALESCE], ISNULL(@x, @y) AS [ISNULL];

	COALESCE   ISNULL
	---------- ------
	1234567890 123
	
2 - Na criação de uma tabela temporária através do comando SELECT INTO, o uso das funções COALESCE e ISNULL pode gerar colunas com tipos de dados diferentes
	SELECT COALESCE(COLUNA_NOT_NULL, 0)COALESCE, ISNULL(COLUNA_NOT_NULL, 0) ISNULL INTO #TEMP FROM X
	Ambas criam colunas NOT NULL quando a coluna de origem for NOT NULL 
	COALESCE cria uma coluna que permite nullo quando a coluna de origem aceitar NULL, enquanto ISNULL criará uma coluna NOT NULL
	
NULLIF ( expression , expression )	- Retorna nulo se o primeiro parâmetro for igual ao segundo parâmetro; caso contrário retorna o primeiro parâmetro

IIF ( boolean_expression, true_value, false_value )  - se o primeiro parametro for true, retorna o 2o parametro, caso contrário retorna o terceiro parametro)
- CHOOSE ( index, val_1, val_2 [, val_n ] )  - retorna o item da posição do parametro especificado
	Exemplo: 
		SELECT CHOOSE ( 3, 'Manager', 'Director', 'Developer', 'Tester' ) AS CHOOSE;
		CHOOSE
		---------
		Developer
IIF e CHOOSE são funções T-SQL. São recomendadas em migrações que envolvem tecnologias compatíveis, como SQL Server e Access. 
	O ideal depois de realizar a migração é transcrever o código na notação SQL-ANSI
	
SYSTEM FUNCTIONS
@@ROWNCOUNT - retorna a quantidade de linhas afetadas (INT) do último statement (declaração) executado

@@ROWNCOUNT_BIG - realiza o mesmo trabalho que @@ROWNCOUNT do tipo BIGINT

Funções de compressão
permitem compactar cadeias de caracteres ou de binários através do algoritmo GZIP 

 COMPRESS( expression )    - compacta a expressão de entrada usando o algoritmo GZIP. Retorna uma matriz de bytes do tipo varbinary(max)
	- você precisa invocar explicitamente a função para compactar o parâmetro antes de salvar o resultado da compressão em uma tabela
 DECOMPRESS ( expression ) - descompacta a expressão de entrada usando o algoritmo GZIP. Retorna uma matriz de bytes do tipo  varbinary(max)
 	Exemplo
 
		DECLARE @PAIS VARCHAR(15) = 'BRASIL'
		DROP TABLE IF EXISTS #TESTE 
		CREATE TABLE #TESTE (COL1 VARBINARY(200))
		
		INSERT INTO #TESTE
		SELECT COMPRESS(@PAIS)
		
		SELECT DATALENGTH(COL1) DATALENGTH, DECOMPRESS(COL1) DECOMPRESS, CAST(DECOMPRESS(COL1)  AS VARCHAR(100))
		FROM #TESTE
	
CONTEXT_INFO 
	- variável do tipo varbinary de 128 bytes associada a seção do usuário
	- serve para enviar parâmetros para objetos niladic (não recebem informações por parâmetro), como TRIGGERS
	- existe apenas uma variável de contexto. Se precisar armazenar multiplos valores, será de ser um de cada vez
			
	Exemplo
		DECLARE @mycontextinfo AS VARBINARY(128) = CAST('us_english' AS VARBINARY(128));
		SET CONTEXT_INFO @mycontextinfo;
		SELECT CAST(CONTEXT_INFO() AS VARCHAR(128)) AS mycontextinfo;
		mycontextinfo
		--------------
		us_english    

CONTEXT SESSION 
	- alternativa ao CONTEXT_INFO 
	- permite armazenar dados na estrutura chave-valor
	- as chaves são do tipo NVARCHAR(128)
	- os valores são do tipo SQL_VARIANT
	- um par chave-valor pode ser marcado como read-only
	- SP_SET_SESSION_CONTEXT - procedure usada para criar e setar valores nas chaves
	- SESSION_CONTEXT - função usada para ler os dados do CONTEXT_INFO
	
	sp_set_session_context [ @key= ] N'key', [ @value= ] 'value'  [ , [ @read_only = ] { 0 | 1 } ]  	
		read_only = 1 --> 	não é possível alterar o valor da variável
		read_only = 0 --> 	o valor pode ser alterado
	
	Exemplo 
		EXEC sys.sp_set_session_context @key = N'language', @value = 'us_english', @read_only = 1;
		SELECT SESSION_CONTEXT(N'language') AS [language];

		language
		-----------
		us_english
	
GUID e funções de identidade	

NEWID() - gera chave globalmente única, do tipo UNIQUEIDENTIFIER
	Exemplo
		SELECT NEWID() AS MYGUID;

		MYGUID
		------------------------------------
		6257FB59-117F-4D99-9700-B138B0C440D2

NEWSEQUENTIALID () - função de sistema utilizada como default no DDL de uma tabela	em colunas do tipo  UNIQUEIDENTIFIER
	esta função não pode ser chamada independentemente em consultas ou expressões. 	
	para gerar valores de chave numérica, pode-se utilizar SEQUENCES ou a propriedade de coluna IDENTITY
	

Para gerar novos valores de uma SEQUENCE, usa-se a função NEXT VALUE FOR <seq_name>

SCOPE_INDENTITY() - função que retorna o último valor de campo IDENTITY gerado no mesmo escopo e sessão do usuário

@@IDENTITY - função que retorna o último valor de campo IDENTITY gerado na mesma sessão do usuário
	
----------------------------------------------------------------------------------------------------
	
OPERADORES ARITMÉTICOS 	
	- operadores mais básicos (+ , -, * , /, %)
	O tipo de dados dos operandos em um cálculo arimético determina o tipo de dado retornado 
	Divisão-> retona o mesmo tipo de dado dos valores de entrada
	Para forçar o retorno de um tipo de dado diferente da origem, é possível usar a função cast , ou representar o valor no formato desejado 
	EXEMPLO 
		Divisão inteira
		SELECT 9/2 [9/2 INT]
		9/2 int
		-----------
		4
		
		Divisão com conversão
		DECLARE @p1 AS INT = 9, @p2 AS INT = 2;
		SELECT CAST(@p1 AS NUMERIC(12, 2)) / CAST(@p2 AS NUMERIC(12, 2));
		
		---------------------------------------
		4.500000000000000
		
		Divisão com conversão implícita
		DECLARE @p1 AS INT = 9, @p2 AS INT = 2;
		SELECT 1.0 * @p1 / @p2;
		
		---------------------------------------
		4.500000000000

	Regra de precisão -> p1-s1 + s2 + max(6, s1+p2 + 1)
	Confira as regras de precisão e escola de cálculos no link a seguir: 
		https://msdn.microsoft.com/en-us/library/ms190476.aspx
	
	Operadores de atribuição binária: 
		+= (adicionar)
		-= (subtraído)
		*= (multiplicar)
		/= (divisão)
		%= (modulo)
		&= (bitwise e)
		|= (bitwise ou)
		^= (bitwise xor)
		+= (concatenação)

Funções de agregação 
	Principais - SUM(), COUNT(), MIN(), MAX(), AVG()
	Para valores muito grandes, use COUNT_BIG()
	Funções de agregação ignoram registros nulos
	O tipo de dado coluna pode determinar o tipo de dado retornado na função, como AVG()
	Funções de agregação podem ser usadas em window functions
	
Search arguments (SARG) 
- são argumentos de busca
- filtram predicados que fazem o otimizador das consultar confiar na ordenação do índice
Fórmula 
	WHERE <column>  <operator>  <expression> 
Requisitos 
	- não aplica manipulação na coluna filtrada
	- o operador avalia os registros na ordem do índice. É o que ocorre com =, >, <, >=, <=, between e like sem caracteres coringa
	- <> e LIKE com caracteres coringa no início da expressão não são SARG
	- Exemplos de predicado com tratamento de nulo
		DECLARE @dt AS DATE = NULL;
		SELECT orderid, shippeddate
			FROM Sales.Orders
			WHERE shippeddate = @dt OR (shippeddate IS NULL AND @dt IS NULL);
	
		DECLARE @dt AS DATE = NULL;
		SELECT orderid, shippeddate
			FROM Sales.Orders
			WHERE EXISTS (SELECT shippeddate INTERSECT SELECT @dt);
			
	Exemplo de consulta NO-SARG
		DECLARE @dt AS DATE = NULL;
		SELECT orderid, shippeddate
			FROM Sales.Orders 
			WHERE ISNULL(shippeddate, '99991231') = ISNULL(@dt, '99991231');
			
Funções determinísticas
	- funções que retornam sempre o mesmo valor a partir dos mesmos parâmetros de entrada
	- funções que retornam valores diferentes nestas condições são chamadas de não-determinísticas
	- Para mais informações, consulte
		https://msdn.microsoft.com/en-us/library/ms178091.aspx
	- Existem 3 categorias principais de funções determinísticas
		- sempre determinísticas
			funções de texto, COALESCE, ISNULL, ABS, SQRT etc
		- determinísticas em algumas circunstâncias 
			CAST() - pode retornar dados em formatos diferentes dependendo de configurações de regionalização
			RAND() - determinística quando for informada a semente, não quando a semente não for informada (SQL Server gera uma semente se não houver, gerando um valor semi-aleatório)
		- sempre não determinísticas
			SYSDATETIME()
			NEWID()
			Geração de dados randômicos de um a 10
			
			SELECT 1 + ABS(CHECKSUM(NEWID())) % 10;
			
	Para ordenar dados aleatoriamente use ORDER BY CHECKSUM(NEWID)
	- Funções não determinísticas ou semi-determinísticas impedem a indexação da coluna
	
------------------------------------------------------------------------------------------------------

Manipulação de dados 
		
Tipos de INSERT
- INSERT VALUES 
- INSERT SELECT 
- INSERT EXEC 
- SELECT INTO 

O uso de SEQUENCE é uma alternativa aos campos IDENTITY (SEQUENCE é um objeto não vinculado em uma tabela)
Para maiores detalhes sobre a comparação entre SEQUENCE e propriedade IDENTITY:
■ Sequences part 1 at http://sqlmag.com/sql-server/sequences-part-1
■ Sequences part 2 at http://sqlmag.com/sql-server/sequences-part-2
■ Sequence and identity performance at http://sqlmag.com/sql-server/sequence-andidentity-performance

INSERT VALUES 
	permite a inserção de um ou mais registros na tabela de destino
	recomenda-se especificar as colunas, mas não é obrigatório
	INSERT VALUES sem especificar as colunas precisa ter valores na mesma ordem de definição da tabela
	Se a tabela for alterada, podem ocorrer erros ou gravar dados nas colunas erradas
	Se quiser inserir valores na tabela e no campo IDENTITY, você precisa ativar a opção IDENTITY_INSERT:
		SET IDENTITY_INSERT <table> ON;
	Desative-a após a inserção 
		SET IDENTITY_INSERT <table> OFF;
	Para alterar a opção IDENTITY_INSERT, você precisa ter permissões ALTER na tabela ou ser o dono dela. 
	Colunas com constraint DEFAULT 
		se o campo não for informado, será inserido o valor especificado na constraint DEFAULT da coluna
		INSERT INTO Sales.MyOrders(custid, empid, shipcountry, freight)
				VALUES(3, 17, N'USA', 30.00);
		
		O uso da cláusula DEFAULT permite que o SQL Server insira na tabela o valor definido na constraint DEFAULT da coluna. 
			INSERT INTO Sales.MyOrders(custid, empid, orderdate, shipcountry, freight)
				VALUES(3, 17, DEFAULT, N'USA', 30.00);
		Se for definido o valor para a coluna, ainda que seja um valor nulo, não será utilizada a constraint DEFAULT
			INSERT INTO Sales.MyOrders(custid, empid, orderdate, shipcountry, freight)
				VALUES(3, 17, NULL, N'USA', 30.00); -- SERÁ INSERIDO O REGISTRO COM A COLUNA ORDER DATE = NULL SE A TABELA ACEITAR NULOS, CASO CONTRÁRIO RESULTARÁ EM ERRO 
	
	A declaração INSERT VALUES permite inserir até 1000 linhas de uma única vez. Para inserir mais que isso, deve-se criar uma consulta com os valores especificados, e partir desta, inserir os registros na tabela. 
	Exemplo 
		DECLARE @T AS table (c1 int);

		INSERT @T (c1)
		SELECT V.v 
		FROM 
		(
			VALUES
				(1),(2),(3),(4),(5),(6),(7),(8),(9),(10), -- [...]
				(998),(999),(1000),
				(1001)
		) AS V(v)
	
[NOTA]				
	SELECT * é considerada uma prática ruim para ser utilizada em sistemas
	Pode ser usada apenas para consutas ad-hoc (consultas criadas no momento)
	
INSERT SELECT 
	inserte o resultado de uma consulta na tabela de destino
	recomenda-se especificar as colunas  para mapeamento, mas não é obrigatório
	Você pode omitir colunas com valor IDENTITY, DEFAULT ou que permitem registros Nulos
		
INSERT EXEC 		
	permite inserir um ou mais resultset gerado a partir de declarações dinâmicas ou stored procedure na tabela especificada. 
	INSERT EXEC permite especificar as colunas para mapeamento ou omitir colunas com valor automático / nulo
	EXEMPLO
	
		DROP TABLE IF EXISTS Sales.MyOrders;
		GO
		CREATE TABLE Sales.MyOrders
		(
			orderid INT NOT NULL IDENTITY(1, 1)
			CONSTRAINT PK_MyOrders_orderid PRIMARY KEY,
			custid INT NOT NULL,
			empid INT NOT NULL,
			orderdate DATE NOT NULL
			CONSTRAINT DFT_MyOrders_orderdate DEFAULT (CAST(SYSDATETIME() AS DATE)),
			shipcountry NVARCHAR(15) NOT NULL,
			freight MONEY NOT NULL
		);

		SET IDENTITY_INSERT Sales.MyOrders ON;
		INSERT INTO Sales.MyOrders(orderid, custid, empid, orderdate, shipcountry, freight)
		EXEC Sales.OrdersForCountry
		@country = N'Portugal';
		SET IDENTITY_INSERT Sales.MyOrders OFF;

		SELECT * FROM Sales.MyOrders;

SELECT INTO 
	Cria uma tabela a partir das origens da consulta
	A declaração copia alguns aspectos de DDL como nome de colunas, tipo,nullabilidade e identity, além dos dados em si 
	Índices, constraint, triggers e permissões não são copiados. Para incluí-los na nova tabela, você gerar o script destes objetos da tabela antiga e aplicá-los na tabela de destino
	Você não possui controle sobre o DDL da tabela de destino, a não ser que faça alguma manipulação dos dados 
		para que a tabela de origem não aceite nulos em uma consulta cuja origem aceita, você deve usar a função ISNULL, para que o SQL Server saiba que algum valor precise ser informado e defina o campo como não nulo. 
		Exemplo: 
			ISNULL(column_name  + 0, -1)
		Para alterar o tipo de dado da tabela de origem no DDL da tabela de destino, você pode usar as funções CAST ou CONVERT. 
			Lembre-se de que nestes casos a coluna pode aceitar nulo, necessitando aplicar também alguma função de tratamento de nulos, como ISNULL
		Exemplo
			ISNULL(CAST(orderdate AS DATE), '19000101') AS orderdate
	Um dos benefícios da declaração SELECT INTO é o fato 
	Quando o modelo de recuperação do banco não está setado como completo, apenas com log simples, a declaração usa uma versão otimizada de log, o que resulta em uma inserção mais rápida do que o modo completo de log. 
	Para mais informações:
		Modos de recuperação do SQL Server
		https://msdn.microsoft.com/en-us/library/ms189275.aspx
		Performance de carga de dados
		https://msdn.microsoft.com/en-us/library/dd425070.aspx
	SELECT INTO possui algumas desvantagens: 
		você tem controle limitado sobre o DDL da tabela de destino
			Mesmo aplicando manipulação de dados, alguns recursos são limitados, como o FILEGROUP da tabela de destino. 
		A tabela fica bloqueada enquanto os dados são carregados. 	
	
Atualização de dados
T-SQL suporta a declaração UPDATE do SQL-ANSI, que permite atualizar registros de uma tabela

	UPDATE <target table>
	SET <col 1> = <expression 1>,
		...,
		<col n> = <expression n>
	WHERE <predicate>;
	
	Apenas os registros cujos predicados resultam em verdadeiro são atualizadas. 
	Se não houver filtro, toda a tabela será atualizada (o famoso UPDATE sem WHERE)
	
[DICA DE EXAME]
	Se estiver usando um cursor, você pode modificar a linha na qual o cursor está posicionado através do filtro WHERE CURRENT OF <cursor_name>
	Exemplo
		Para conceder um desconto de 5% a todos os produtos selecionados: 
		UPDATE dbo.MyTable SET discount += 0.05 WHERE CURRENT OF MyCursor;
			
	Para mais informações sobre cursores, consulte: 
	https://msdn.microsoft.com/en-us/library/ms180169.aspx
	
UPDATE a partir de joins 
	SQL-ANSI não suporta Update a partir de joins, mas T-SQL sim. 
	O recurso permite atualizar registros que combinam com os de outra tabela ou que atendam aos predicados informados, tanto da tabela a ser afetada, quanto da tabela relacionada.
	- recomenda-se criar uma consulta com os joins e filtros usados no update para se certificar de que os registros retornados são os que devem ser atualizados
	UPDATE <alias1><target table>
	SET <col 1> = <expression 1>,
		...,
		<col n> = <expression n>
	FROM <table1><alias>
	[INNER | LEFT | RIGHT ] JOIN <table2> <alias2> 
	ON 
		<alias1>.[chave] = <alias2>.[chave]
	WHERE <predicate>;
	
	Exemplo 
	
	UPDATE OD
		SET OD.discount += 0.05
	FROM Sales.MyCustomers AS C
	INNER JOIN Sales.MyOrders AS O
		ON C.custid = O.custid
	INNER JOIN Sales.MyOrderDetails AS OD
		ON O.orderid = OD.orderid
	WHERE
		C.country = N'Norway';
		
	Limitações
	só é possível atualizar uma tabela por vez
		
	UPDATE NÃO DETERMINÍSTICO
		Certifique-se de que o Update a partir de joins não seja não-determístico. 
		Declarações são não-determinísticas quando várias linhas de origem correspondem a uma linha de destino.
		Nestas situações, SQL Server não envia mensagem de aviso ou erros. O banco atualiza um dos registros arbitrariamente (é atualizado o registro que tem o menor custo de performance)
		Recomenda-se aplicar predicados que permitam a atualização de um único registro da origem com correspondência com o destino
		Exemplo: 
			UPDATE C
				SET C.postalcode = A.shippostalcode
				FROM Sales.MyCustomers AS C
			CROSS APPLY (
					SELECT TOP (1) O.shippostalcode
						FROM Sales.MyOrders AS O
						WHERE O.custid = C.custid
						ORDER BY orderdate, orderid) AS A;
		
Update com variável
	T-SQL suporta um tipo de UPDATE que permite salvar o resutado de colunas modificadas em variáveis
	Exemplo:
		DECLARE @newdiscount AS NUMERIC(4, 3) = NULL;
		UPDATE Sales.MyOrderDetails
		SET @newdiscount = discount += 0.05
			WHERE orderid = 10250
			AND productid = 51;
		
		SELECT @newdiscount;

Update tudo de uma vez (all-at-once)
	Expressões que aparecem na mesma fase lógica são tratadas como um conjunto, de maneira única
	O conceito all-at-once também tem algumas implicações em declarações UPDATE
	Todas as atribuições usam os valores originais da linha como valores de origem, independentemente da ordem de atribuição de valores do mesmo comando. 
	Exemplo: 
	
		DROP TABLE IF EXISTS dbo.T1;
		CREATE TABLE dbo.T1
		(
		keycol INT NOT NULL
		CONSTRAINT PK_T1 PRIMARY KEY,
		col1 INT NOT NULL,
		col2 INT NOT NULL
		);
		INSERT INTO dbo.T1(keycol, col1, col2) VALUES(1, 100, 0);

		SELECT * FROM dbo.T1;
		DECLARE @add AS INT = 10;
		UPDATE dbo.T1
		SET col1 += @add, col2 = col1
		WHERE keycol = 1;
		SELECT * FROM dbo.T1;

		keycol      col1        col2
		----------- ----------- -----------
		1           100         0
		
		keycol      col1        col2
		----------- ----------- -----------
		1           110         100

Deleção de dados
	T-SQL suporta duas declarações que permitem excluir dados de tabelas: DELETE e TRUNCATE TABLE	

	DELETE 
		Permite excluir os dados de uma tabela. 
		
		DELETE FROM <table>
			WHERE <predicate>;
		
		Serão excluídos os registros que atendem os predicados. 
		[IMPORTANTE]
		Se você não especificar um predicado, todos os registros da tabela serão excluídos. Assim como em UPDATES desaqualificados, atente-se para exclusão acidental de todos os registros ao selecionar a declaração sem a parte dos predicados. 
		A declaração DELETE é totalmente logada. Para mais informações, consulte: 
			https://msdn.microsoft.com/en-us/library/ms190925.aspx
		Grandes exclusões podem levar muito tempo para serem concluídas
			- fazem com que o de log de transações aumente drasticamente
			- podem resultar em uma escalada de bloqueio (o SQL Server passa a bloquear linhas, páginas de dados e até mesmo tabelas)
			Para mais informações sobre bloqueio, consulte: 
				https://technet.microsoft.com/en-us/library/ms190615(v=sql.105).aspx
		Para realizar exclusões parciais, você pode quebrar seu delete em pequenas partes, como o exemplo através da função TOP dentro de um loop:
				
			WHILE 1 = 1
			BEGIN
				DELETE TOP (1000) FROM Sales.MyOrderDetails
				WHERE productid = 12;
				IF @@rowcount < 1000 BREAK;
			END
		
[DICA DE EXAME]	
	Similar à sintaxe UPDATE WHERE CURRENT OF, você pode usar a sintaxe DELETE WHERE CURRENT OF para a linha atual do cursor. 
	Exemplo
		DELETE FROM dbo.MyTable WHERE CURRENT OF MyCursor;
		
	TRUNCATE TABLE 
		- declaração que excluir todos os registros da tabela ou partição
		- não suporta filtro
		- utiliza um sistema otimizado de log e é significativamente mais rápido. 
		Exemplo
			Truncate de tabela
				TRUNCATE TABLE Sales.MyOrderDetails;
			
			Truncate de partição
				TRUNCAT TABLE MyTable WITH (PARTITIONS (1, 2, 11 TO 20))
		
DELETE x TRUNCATE 

+---------------------------+-----------------------------------+-----------------------------------+
|		Característica	  	|		DELETE 						|			TRUNCATE				|
+---------------------------+-----------------------------------+-----------------------------------+
| Privilégio necessário   	|		DELETE						| 			ALTER 					|
+---------------------------+-----------------------------------+-----------------------------------+
| 	Coluna IDENTITY			|	NÃO ALTERA O VALOR 				|	RESETA O VALOR DO CAMPO 		|
+---------------------------+-----------------------------------+-----------------------------------+
|  Colunas referenciadas 	|	Executa se os registros 		|	Não executa o comando; é 		|
|   em outras tabelas 		| excluídos não forem refenciados	| necessário dropar as constraints, |
|							|									| truncar a tabela e recriar chaves	|
+---------------------------+-----------------------------------+-----------------------------------+
| 	Views indexadas			|  suporta views indexadas			|	não suporta views indexadas		|
+---------------------------+-----------------------------------+-----------------------------------+

	Para usar o comando TRUNCATE é necessário ter o privilégio de ALTER TABLE
		Uma solução alternativa é colocar o comando TRUNCATE TABLE em um módulo, como uma procedure, atribuindo as permissões necessárias ao objeto usando a CLÁUSULA EXECUTE AS. 
	
	Recomenda-se truncar a tabela para limpar todos os registros. 
	
DELETE baseado em joins
	SQL-ANSI não suporta DELETE a partir de joins, mas T-SQL sim. 
	Permite excluir registros que 	
	O recurso permite excluir registros que combinam com os de outra tabela ou que atendam aos predicados informados, tanto da tabela a ser afetada, quanto da tabela relacionada. 
	Exemplo: 
		DELETE FROM O
			FROM Sales.MyOrders AS O
		INNER JOIN Sales.MyCustomers AS C
		ON O.custid = C.custid
			WHERE C.country = N'USA';
	A cláusula FROM que aparece logo em seguida do comando DELETE é opcional 
	Recomenda-se informar aliases para indicar corretamente qual a tabela que será afetada. 

	
MERGE
	Com a declaração MERGE, você pode mesclar (MERGE) registros da tabela ou expressão de origem com os da tabela de destino. 
	É um recurso muito útil tanto em cenários OLTP quanto em datawarehouses
	Casos de Uso 
		OLTP: 
			suponha que você tenha uma tabela que não seja atualizada diretamente por alguma aplicação; em vez disso, você recebe o delta de mudanças periodicamente a partir de um sistema externo.
			Primeiro você carrega o delta das mudanças em tabelas stage, para em seguida usar as tabelas stage como a fonte para a operação de merge nas tabelas de destino 
		Data warehouse
			suponha que você mantenha visualizações agregadas dos dados em seu data warehouse.
			Com a instrução MERGE, você pode aplicar alterações que foram aplicadas a linhas detalhadas no formulário agregado.
	É suportada pelo SQl-ANSI, porém a cláusula WHEN NOT MATCHED BY SOURCE é proprietáraria da Microsoft, e faz parte do T-SQL. 

	Sintaxe
		MERGE INTO <target table> AS TGT
		USING <SOURCE TABLE> AS SRC
		ON <merge predicate>
			WHEN MATCHED [AND <predicate>] 					-- duas cláusulas aceitas (UPDATE ou DELETE) - aceita uma de cada
				THEN <action> 								
				-- UPDATE
				-- DELETE 
			WHEN NOT MATCHED [BY TARGET] [AND <predicate>] 	-- uma cláusula é aceita (INSERT) - obrigatório
				THEN INSERT... 								
			WHEN NOT MATCHED BY SOURCE [AND <predicate>] 	-- duas cláusulas aceitas (UPDATE ou DELETE)
				THEN <action>; 								-- one with UPDATE one with DELETE - aceita uma de cada
				-- UPDATE 
				-- DELETE 

	DECLARAÇÕES DO MERGE
	- MERGE INTO <target table> - define a tabela de destino da operação de mesclagem de dados (merge)
	
	USING - <source table> - define a fonte da operação. 
		- aceita o uso de alias
		- possui função semelhante à cláusula FROM do comando SELECT
		- aceita joins, CTEs, APPLY, PIVOT, UNPIVOT,  ou até memso uma função de tabela como OPENROWSET e OPENXML com tabelas reais, temporárias ou váriáveis de tabela
		- a saida da cláusula USING é uma tabela, usada como fonte do processo de merge
		
	ON <merge predicate> - cláusula que permite especificar os predicados para combinar os registros entre a origem e o destino. 
		- Não realiza filtro como na cláusula ON de um join. 
		
	WHEN MATCHED [AND <predicate>] THEN <action> - cláusula que define a ação a ser realizada quando uma linha de origem combina com uma de destino. 
		- devido ao fato de a linha já existir, o comando INSERT não é permitido
		- São aceitas duas ações: UPDATE ou DELETE
		- Se quiser realizar duas operações diferentes em duas condições diferentes, você precisa especificar a cláusula WHEN MATCHED duas vezes, uma para cada operação, com as respectivas condições de atualização e de exclusão
		
	WHEN NOT MATCHED [BY TARGET] [AND <predicate>] 	- define que ação será tomada quando uma linha da origem não combinar com qualquer linha da tabela de destino e o predicado for atendido
		- devido ao fato de a linha não existir no destino, é permitido apenas o comando INSERT
		- UPDATE e DELETE - não possuem nenhum efeito quando a linha não existe
	
	WHEN NOT MATCHED BY SOURCE [AND <predicate>]  - define a ação a ser tomada quando a linha existe no destino mas não na origem
		- cláusula proprietária da Microsoft (extensão da declaração MERGE padrão)
		- devido ao fato de a linha existir no destino, são aceitos apenas UPDATE e DELETE
		- é possível utilizar a cláusula duas vezes, uma para cada comando, com os respectivos predicados (para indicar quando atualizar e quando excluir linhas que não existem na origem)
		- 
	IMPORTANTE - Conflitos de Merge
	- para evitar conflitos de merge (registros duplicados na mesma consulta de origem), utilize SERIALIZABLE ou HOLDLOCK (ambos com significado equivalente)
		Neste nível de isolamento, nenhuma outra transação pode modificar dados que foram lidos pela transação atual até que está seja finalizada. 
		Outras transações não podem inserir novas linhas com chaves lidas por uma transação até que este seja finalizado.  https://docs.microsoft.com/en-us/sql/t-sql/statements/set-transaction-isolation-level-transact-sql?view=sql-server-2017

	É muito despedício de recurso realizar atualizações em registros que não sofreram modificação. Além disso, processos de auditoria ou de log podem registrar a alteração como atualização da tabela desnecessariamente. Uma forma de contornar isso é garantir que sejam atualizados somente os registros que tiveram modificação em alguma coluna, como pode ser visto no exemplo a seguir:
	
	WHEN MATCHED 
		AND DESTINO.COL1 <> ORIGEM.COL1 
		OR (TGT.custid IS NULL AND SRC.custid IS NOT NULL)
		OR (TGT.custid IS NOT NULL AND SRC.custid IS NULL)
	Os predicados acima verificam se houve modificação de dado ou se uma das colunas está nula e a outra não (comparação não identificada em um predicado <> ou =, já que predicados com null retornam DESCONHECIDO) 
	
	É possível identificar modificações de registros através de operadores de conjuntos, como no exemplo a seguir:
	WHEN MATCHED AND EXISTS( SELECT SRC.* EXCEPT SELECT TGT.* ) THEN UPDATE
		Qualquer linha modificada é retornada através do operador EXCEPT
		Operadores de conjunto realizam comparações de distinção de cada coluna, mas não distinguem campos nulos (se ambos estiverem nulos, o operador considera que são iguais, sem retornar DESCONHECIDO). 
		Quando uma linha possuir qualquer diferença entre a origem e o destino, o operador EXCEPT retorna a linha e a cláusula EXISTS retorna verdadeiro, de forma que a linha seja atualizada  
		Quando as linhas forem iguais, a consulta com o comando EXCEPT retorna vazio e não atualiza o registro
	
	Para maiores detalhes: 
		http://sqlmag.com/sql-server/merge-statement-tips
	
OUTPUT 
	T-SQL suporta a cláusula OUTPUT para DML, que pode ser usado para retornar informações dos registros modificados. Você pode usar a saída para propósitos de auditoria, arquivamento etc. 
	A Cláusula OUTPUT possui sintaxe parecida com a do comando SELECT, no sentido de especificar expressões e atribuir aliases. 
	Uma diferença é que, quando você se refere às colunas de linhas modificadas, você precisa prefixar os nomes das colunas com as palavras-chave INSERTED ou DELETED.
	Prefixo INSERTED - usado para referenciar os registros que foram inseridos na tabela 
	Prefixo DELETED - usado para referenciar os registros que foram excluídos da tabela 
	Em um comando  UPDATE
		- inserted - estado do registro depois da atualização
		- deleted  - estado do registro antes da atualização
	
	A cláusula OUTPUT pode ser usada para retornar um result para o chamador ou para alguma tabela (também ao mesmo tempo)
	Caso a saída seja direcionada para uma tabela (INTO) a tabela de destino não pode referenciar ou ser referenciada em uma chave estrangeira (FK), além de não ter triggers vinculados. 
	
	INSERT com OUTPUT
	A Cláusula OUTPUT pode ser usada em declarações INSERT para retornar as linhas inseridas
	Exemplo prático:
		Quando é executado o comando INSERT de múltiplas linhas, o comando OUTPUT salva  novas chaves inseridas de uma SEQUENCE ou em um campo IDENTITY, de forma a saber quais os valores gerados. 
	Exemplo:
		INSERT INTO SALES.MYORDERS(CUSTID, EMPID, ORDERDATE)
		OUTPUT
			INSERTED.ORDERID, INSERTED.CUSTID, INSERTED.EMPID, INSERTED.ORDERDATE
		SELECT CUSTID, EMPID, ORDERDATE
			FROM SALES.ORDERS
		WHERE SHIPCOUNTRY = N'NORWAY';
		
		-- 1a execução
		-- dados insertidos na tabela, retornados pela query via comando OUTPUT
		orderid     custid      empid       orderdate
		----------- ----------- ----------- ----------
		13          70          1           2014-12-18
		14          70          7           2015-04-29
		15          70          7           2015-08-20
		16          70          3           2016-01-14
		17          70          1           2016-02-26
		18          70          2           2016-04-10

		(6 row(s) affected)

		-- 1a execução
		orderid     custid      empid       orderdate
		----------- ----------- ----------- ----------
		31          70          1           2014-12-18
		32          70          7           2015-04-29
		33          70          7           2015-08-20
		34          70          3           2016-01-14
		35          70          1           2016-02-26
		36          70          2           2016-04-10

		(6 row(s) affected)

		-- consulta na tabela após 2o INSERT
		
		orderid     custid      empid       orderdate
		----------- ----------- ----------- ----------
		25          70          1           2014-12-18
		26          70          7           2015-04-29
		27          70          7           2015-08-20
		28          70          3           2016-01-14
		29          70          1           2016-02-26
		30          70          2           2016-04-10
		31          70          1           2014-12-18
		32          70          7           2015-04-29
		33          70          7           2015-08-20
		34          70          3           2016-01-14
		35          70          1           2016-02-26
		36          70          2           2016-04-10

		(12 row(s) affected)

		
	Para armazenar o resultado de uma tabela em vez de exibir os dados ao chamador, basta adicionar a cláusula INTRO com uma tabela de destino, como no exemplo:
	OUTPUT
		inserted.orderid, inserted.custid, inserted.empid, inserted.orderdate
	INTO SomeTable(orderid, custid, empid, orderdate)

	Em uma declaração INSERT, não é possível usar o prefixo DELETED, já que não há linhas excluídas.  
	
	DELETE com OUTPUT
		Você pode usar a cláusula OUTPUT para retornar informações das linhas excluídas em uma declaração DELETE através do prefixo DELETED. 
		Comandos de delete não aceitam o prefixo INSERTED, visto que nenhuma linha pode ser inserida
	Exemplo:
		DELETE FROM Sales.MyOrders
		OUTPUT deleted.orderid
		WHERE empid = 1;
	
	Saída (linhas excluídas)
		orderid
		-----------
		37
		41
		43
		47
	Para persistir a saída dos dados em uma tabela, você pode usar a cláusula INTO <target_table>
	
	declare @deleted_empids as table (empid int)

	DELETE FROM Sales.MyOrders
		OUTPUT deleted.orderid -- saída para leitura dos dados 
		into @deleted_empids ( deleted.empid) -- saida para var table 
		OUTPUT deleted.orderid
		WHERE empid = 1;

Fonte:
	https://www.sqlservercentral.com/articles/the-output-clause-for-insert-and-delete-statements
		
	Limitações da cláusula OUTPUT:
		Declarações DML que referenciam views particionadas, distruibuídas ou tabelas remotas
		Declarações INSERT que contenham o comando EXECUTE
		Preducados de texto não são permitidos quando o nível de compatibilidade do banco está configurado para 100
		OUTPUT INTO não pode ser usado para inserir dados em views ou funções ROWSET. 		
		Funções definidas pelo usuário não podem ser criadas se contiverem a cláusula OUTPUT INTO com uma tabela de destino
		
	Para maiores detalhes,acesse o link a seguir: 
	https://technet.microsoft.com/en-us/library/ms177564(v=sql.110).aspx
	
	MERGE com OUTPUT
	Você pode usar a cláusula OUTPUT junto com a declaração MERGE, mas há considerações especiais. 
	Declarações  MERGE podem aplicar diferentes ações em uma tabela de destino. 
	O SQL Server utiliza a função $action para distinguir a operação realizada no comando MERGE, retornando as strings INSERT, UPDATE ou DELETE. 
	Linhas afetadas por comandos INSERT terão valores inseridos 
	
	Você pode referir-se às colunas das linhas excluídas com o prefixo DELETED e às colunas das linhas inseridas com o prefixo INSERTED
		As linhas afetadas por uma ação INSERT têm valores na linha inserida e NULLs na linha excluída. 
		As linhas afetadas por uma ação DELETE têm NULLs na linha inserida e valores na linha excluída. 
		As linhas afetadas por uma ação UPDATE possuem valores em ambas. 
	Se você quiser retornar a chave da linha afetada (assumindo que a própria chave não foi modificada), você pode usar a expressão COALESCE (INSERTED.chave, DELETED.chave).
	
	Exemplo
		MERGE INTO Sales.MyOrders AS TGT
		USING (
				VALUES(1, 70, 1, '20151218'), (2, 70, 7, '20160429'), (3, 70, 7, '20160820'),
				(4, 70, 3, '20170114'), (5, 70, 1, '20170226'), (6, 70, 2, '20170410')
			)
			AS SRC(orderid, custid, empid, orderdate)
			ON SRC.orderid = TGT.orderid
			WHEN MATCHED AND EXISTS( SELECT SRC.* EXCEPT SELECT TGT.* ) THEN
				UPDATE SET 	TGT.custid = SRC.custid,
							TGT.empid = SRC.empid,
							TGT.orderdate = SRC.orderdate
			WHEN NOT MATCHED THEN
				INSERT VALUES(SRC.orderid, SRC.custid, SRC.empid, SRC.orderdate)
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE
			OUTPUT
			$action AS the_action,COALESCE(inserted.orderid, deleted.orderid) AS orderid;
	
	Saída
	the_action orderid
	---------- -----------
	INSERT     1
	INSERT     2
	INSERT     3
	INSERT     4
	INSERT     5
	INSERT     6
	DELETE     50
	DELETE     51
	DELETE     52
	DELETE     54
	DELETE     56
	DELETE     57
	DELETE     58
	DELETE     60

	Dica de Exame
	Em declarações INSERT, UPDATE e DELETE, você só pode referenciar colunas da tabela de destino na cláusula OUTPUT
	Na declaração MERGE, você pode referenciar colunas tanto da origem quanto do destino. 
	Exemplo
		suponha que no exemplo de INSERT de várias linhas, a seção  OUTPUT retornasse a chave da origem e do destino. 
		Isso não pode ser feito diretamente na instrução INSERT porque você não tem acesso à tabela de origem.
	Você pode conseguir isso com a instrução MERGE, pois uma ação INSERT só é permitida quando o predicado de merge retorna falso, como 1=2. 
	

SELECT orderid, custid, empid, orderdate
			FROM Sales.Orders
			WHERE shipcountry = N'Norway' 
			
	orderid     custid      empid       orderdate
	----------- ----------- ----------- ----------
	10387       70          1           2014-12-18
	10520       70          7           2015-04-29
	10639       70          7           2015-08-20
	10831       70          3           2016-01-14
	10909       70          1           2016-02-26
	11015       70          2           2016-04-10
	
	MERGE INTO Sales.MyOrders AS TGT
		USING ( SELECT orderid, custid, empid, orderdate
			FROM Sales.Orders
			WHERE shipcountry = N'Norway' ) AS SRC
		ON 1 = 2
		WHEN NOT MATCHED THEN
			INSERT(custid, empid, orderdate) VALUES(custid, empid, orderdate)
			OUTPUT
				SRC.orderid AS src_orderid, inserted.orderid AS tgt_orderid,
				inserted.custid, inserted.empid, inserted.orderdate;
			
	src_orderid tgt_orderid custid      empid       orderdate
	----------- ----------- ----------- ----------- ----------
	10387       73          70          1           2014-12-18
	10520       74          70          7           2015-04-29
	10639       75          70          7           2015-08-20
	10831       76          70          3           2016-01-14
	10909       77          70          1           2016-02-26
	11015       78          70          2           2016-04-10

	DML aninhado
	Com T-SQL você pode definir algo semelhante a uma tabela derivada a partir de modificações com a cláusula OUTPUT. Assim, é possível ter um INSERT SELECT externo a partir de uma tabela derivada. 
	O comando INSERT SELECT exerno pode filtrar as lihas da tabela derivada, inserindo apenas os registros que atendem aos filtros, realizando também operações como GROUP BY, HAVING, operadores de tabelas etc.
	
	Exemplo:
	

	DECLARE @InsertedOrders AS TABLE
	(
	orderid INT NOT NULL PRIMARY KEY,
	custid INT NOT NULL,
	empid INT NOT NULL,
	orderdate DATE NOT NULL
	);
	INSERT INTO @InsertedOrders(orderid, custid, empid, orderdate)
	SELECT orderid, custid, empid, orderdate
	FROM (
		MERGE INTO Sales.MyOrders AS TGT
			USING (
					VALUES
						(1, 70, 1, '20151218'), (2, 70, 7, '20160429'), (3, 70, 7, '20160820'),
						(4, 70, 3, '20170114'), (5, 70, 1, '20170226'), (6, 70, 2, '20170410')
					)
					AS SRC(orderid, custid, empid, orderdate)
			ON SRC.orderid = TGT.orderid
			WHEN MATCHED AND EXISTS( SELECT SRC.* EXCEPT SELECT TGT.* ) THEN
				UPDATE SET TGT.custid = SRC.custid,
				TGT.empid = SRC.empid,
				TGT.orderdate = SRC.orderdate
			WHEN NOT MATCHED THEN
				INSERT VALUES(SRC.orderid, SRC.custid, SRC.empid, SRC.orderdate)
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE
			OUTPUT
				$action AS the_action, inserted.*) AS D
		WHERE the_action = 'INSERT';

	SELECT * FROM @InsertedOrders;
		
	Na segunda execução do código não há nenhum registro na tabela de variável, já que nenhum novo registro foi inserido. 
	
Impacto nos dados de mudanças estruturais

Adição de colunas 
	Para adicionar uma coluna a tabela, utilize a sintaxe abaixo
	ALTER TABLE < table_name > ADD <column_definition> [<column_constraint>] [WITH VALUES];
	
	Se a tabela estiver vazia, você pode adicionar uma coluna que não aceita nulos, sem valor DEFAULT. Se a tabela não estiver vazia, a operação de criação da coluna falha. 
	
	use TSQLV4

	ALTER TABLE Sales.MyOrders ADD requireddate DATE NOT NULL; -- a tabela não está vazia
	
	Msg 4901, Level 16, State 1, Line 5
ALTER TABLE only allows columns to be added that can contain nulls, or have a DEFAULT definition specified, or the column being added is an identity or timestamp column, or alternatively if none of the previous conditions are satisfied the table must be empty to allow addition of this column. Column 'requireddate' cannot be added to non-empty table 'MyOrders' because it does not satisfy these conditions.
	Você pode associar a coluna à uma constraint DEFAULT, e também indicar que você deseja que a expressão padrão seja aplicada às linhas existentes, adicionando a cláusula WITH VALUES:
	
	ALTER TABLE Sales.MyOrders	ADD requireddate DATE NOT NULL
		CONSTRAINT DFT_MyOrders_requireddate DEFAULT ('19000101') WITH VALUES
	
	orderid     custid      empid       orderdate  requireddate
	----------- ----------- ----------- ---------- ------------
	1           70          1           2015-12-18 1900-01-01
	2           70          7           2016-04-29 1900-01-01
	3           70          7           2016-08-20 1900-01-01
	4           70          3           2017-01-14 1900-01-01
	5           70          1           2017-02-26 1900-01-01
	6           70          2           2017-04-10 1900-01-01
	
	Se a coluna estiver definida como NOT NULL, a expressão DEFAULT será aplicada com ou sem a cláusula WITH VALUES
	Se a coluna estiver definida para aceitar nulos e a cláusula WITH VALUES for informada, o campo terá o valor default aplicado. Se esta cláusula não for informada, a coluna será criada com nulo. 
	
EXCLUSÃO DE COLUNA
	Para remover uma coluna de uma tabela, utilize a sintaxe a seguir:
	ALTER TABLE <table_name> DROP COLUMN <column_name>;
	
	A tentativa de exclusão da coluna falhará quando 
		■ for utilizada em um índice
		■ for utilizada em constraints default, check, foreign key, unique, ou primary key
		■ estiver vinculada a um objeto ou regra padrão. 
	
ALTERAÇÃO DE COLUNA 
	Para alterar uma coluna, utilize a sintaxe a seguir: 
	ALTER TABLE <table_name> ALTER COLUMN <column_definition> WITH ( ONLINE = ON | OFF );
	
	A tentativa de alteração de uma coluna pode falhar quando (lista parcial)
		■ quando for usada em uma chave primária ou estrangeira
		■ quando for usada em uma constraint unique, a menos que você mantenha ou aumente o tamanho de uma coluna de tamanho variável  
		■ quando for usada em uma constraint DEFAULT, a menos que você esteja alterando o tamanho, precisão ou escada de uma coluna, desde que o tipo de dado não seja alterado
	
	Exemplo:
		ALTER TABLE Sales.MyOrders ALTER COLUMN requireddate DATETIME NOT NULL; 
	
	Msg 5074, Level 16, State 1, Line 15
		The object 'DFT_MyOrders_requireddate' is dependent on column 'requireddate'.
	Msg 4922, Level 16, State 9, Line 15
	ALTER TABLE ALTER COLUMN requireddate failed because one or more objects access this column.
	
	Se uma coluna for incluída em uma chave primária, você não pode alterá-la de NOT NULL para NULL
	Ao modificar uma coluna com registros nulos para NOT NULL, o processo resultará em erro, a não ser que seja definido um valor default no momento da alteração da coluna 
	
	Por padrão, o SQL Server utiliza um modo WITH CHECK, que verifica se os dados existentes atendem aos requisitos das constraints, e falha no caso se a tentativa de adicionar a constraint for inválida. É possível informar ao SQL Server para não realizar estas verificações de dados, através da cláusula WITH NOCHECK
	Para muitas operações de coluna, o SQL Server suporta indicar a opção ONLINE = ON (está definida como OFF por padrão). Com esta opção ativada, a tabela está disponível enquanto a operação está em progresso. 
	Se você precisar alterar uma coluna para iniciar ou parar de pegar os valores de uma SEQUENCE, você pode realizá-lo adicionando ou apagando uma constraint DEFAULT com a chamada da função NEXT
	VALUE FOR 
	
	Exemplo:
	
	ALTER TABLE Sales.MyOrders DROP CONSTRAINT DFT_MyOrders_orderid;

	ALTER TABLE Sales.MyOrders ADD CONSTRAINT DFT_MyOrders_orderid
		DEFAULT(NEXT VALUE FOR Sales.SeqOrderIDs) FOR orderid;

	select NEXT VALUE FOR Sales.SeqOrderIDs
	-----------
	7
	
	A operação não é tão simples com a propriedade IDENTITY. Você não pode alterar uma coluna para adicionar ou remover esta propriedade. Se você precisa realizá-lo, é uma necessário:
	■ criação de outra tabela
	■ copiar os dados
	■ eliminar a tabela original
	■ renomear a nova tabela para o nome da tabela original 
	
	Dica de exame	
	Apesar de o exame tentar medir seu conhecimento e proficiência com o assunto, tenha em mente que o exame o coloca em diferentes condições na vida real. 
	Você não terá acesso a nenhum material de consulta, logo precisará memoriar a sintaxe de diferentes instuções T-SQL que serão abordadas no exame. 
	Além disso, tente se concentrar exatamente no que a pergunta quer, em oposição ao que é considerado como melhor prática, ou como você teria feito 
	
	Para mais informações, consulte: 
	https://msdn.microsoft.com/en-us/library/ms190273.aspx.
	
	
	Exemplo de consulta do próximo valor de uma SEQUENCE:
	SELECT NEXT VALUE FOR SALES.SEQORDERIDS
	
--------------------------------------------------------------------------------------------------

CAPÍTULO 2 - CONSULTA DE DADOS COM COMPONENTES T-SQL AVANÇADOS

SUBQUERIES
	São subconsultas, cujo resultado é considerado como uma tabela no formato de expressão. Podem ser:
	■ independentes da consulta externa
	■ correlacionadas (dependem da consulta externa)
	Tipos de resultado de uma subconsulta:
	■ escalar - retornar um único valor 
	■ coluna multivalorada (uma coluna com várias linhas)
	■ múltiplas colunas multivaloradas (várias colunas com várias linhas)
	
	Exemplos:
	Subconsulta escalar: 
	
	SELECT productid, productname, unitprice
		FROM Production.Products
		WHERE unitprice =
			(SELECT MIN(unitprice)
				FROM Production.Products
			);
	Saída
	productid 	productname 	unitprice
	---------- 	-------------- 	----------
	33 			Product ASTMN 	2.50
	
	Se a subconsulta retornasse mais de um valor, a consulta provocaria um erro. 
	Se a subconsulta retornasse vazio, seu retorno seria convertido para NULL
	
	Subconsulta de coluna multivalorada:
		Uma subconsulta também pode retornar múltiplos valores no formato de várias linhas em uma única coluna, como acontece no exemplo a seguir: 
		
	SELECT productid, productname, unitprice
	FROM Production.Products
		WHERE supplierid IN
			(SELECT supplierid
				FROM Production.Suppliers
				WHERE country = N'Japan'
			);	
	
	productid   productname     unitprice
	----------- --------------- ---------------------
	9           Product AOZBW   97,00
	10          Product YHXGE   31,00
	74          Product BKAZJ   10,00
	13          Product POXFU   6,00
	14          Product PWCJB   23,25
	15          Product KSZOI   15,50

	T-SQL suporta alguns predicados esotéricos que operam em subconsultas (ANY, ALL, SOME)
	São usados raramente porque existem alternativas mais simples e intuitivas, entretanto é importante conhecê-los porque podem cair no exame. 
	Sintaxe
	
	SELECT <select_list>
		FROM <table>
		WHERE <expression> <operator> {ALL | ANY | SOME} (<subquery>);
	
	Predicado ALL - retorna verdadeiro apenas quando aplicado à expressão de entrada, cujos valores retornam verdadeiro em todos os casos. 
	Exemplo: 
	-- Retorna os produtos onde o preço unitário é menor ou igual ao preço unitário de todos os produtos
	SELECT productid, productname, unitprice
		FROM Production.Products
		WHERE unitprice <= ALL (SELECT unitprice FROM Production.Products);
	
	productid   productname                              unitprice
	----------- ---------------------------------------- ---------------------
	33          Product ASTMN                            2,50

	A consulta acima equivale à consulta a seguir, porém esta segunda é mais performática segundo o plano de execução:
	
	SELECT productid, productname, unitprice 
		FROM Production.Products PRODUCTS
		INNER JOIN 
		(
			SELECT MIN (unitprice) unit_price FROM Production.Products
		) MENORPRECO 
		ON  PRODUCTS.unitprice = MENORPRECO.unit_price
		
	productid   productname                              unitprice
	----------- ---------------------------------------- ---------------------
	33          Product ASTMN                            2,50
	
	ANY e SOME - possuem significado idêntico. 
		Basta que seja retornado pelo menos um dos valores para que todo o predicado seja verdadeiro, como pode ser visto na consulta a seguir: 
	-- retorna todos os produtoc on o precço unitário é maior do que o preço unitário de qualquer outro produto. 
	SELECT productid, productname, unitprice
		FROM Production.Products
		WHERE unitprice > ANY (SELECT unitprice FROM Production.Products)
		ORDER BY unitprice;
	
	São retornados todos os produtos, exceto o de menor valor, por não ser maior do que nenhum outro. 
	
	SUBCONSULTAS CORRELACIONADAS
	São subconsultas cuja consulta interna faz referência às colunas da tabela da consulta externa. 
	São mais trabalhosas do que as subconsultas independentes, visto que você não pode executar o trecho da consulta interna isoladamente
	Exemplo:
		Suponha que você precise retornar os produtos com o menor preço unitário por categoria. 
		Você pode usar uma subconsulta correlacionada para retornar o preço mínimo unitário dos
		produtos cujo ID da categoria seja igual ao da linha externa (a correlação):

	SELECT categoryid, productid, productname, unitprice
		FROM Production.Products AS P1
		WHERE unitprice =
			(SELECT MIN(unitprice)
				FROM Production.Products AS P2
				WHERE P2.categoryid = P1.categoryid
			)
	-- cruza tabela interna e externa para calcular minimo na interna e filtrar na consulta externa 
	

	categoryid  productid   productname                              unitprice
	----------- ----------- ---------------------------------------- ---------------------
	1           24          Product QOGNU                            4,50
	2           3           Product IMEHJ                            10,00
	3           19          Product XKXDO                            9,20
	4           33          Product ASTMN                            2,50
	5           52          Product QSRXF                            7,00
	6           54          Product QAQRL                            7,45
	7           74          Product BKAZJ                            10,00
	8           13          Product POXFU                            6,00
	A subconsulta usa uma correlação a partir da chave categoryid, de forma a filtrar apenas os produtos cujo ID da categoria é igual ao da linha externa, para retornar o preço mínimo de cada categoria
	
	A consulta  acima é equivalente a consulta a seguir(com o mesmo custo no plano de execução):
	
	SELECT p1.categoryid, p1.productid, p1.productname, p1.unitprice 
	FROM Production.Products AS P1
	INNER JOIN 
	(
		SELECT MIN(unitprice)unitprice, categoryid from Production.Products
		GROUP BY categoryid 
	) MENOR_PRECO_CATEGORIA
	ON p1.categoryid = menor_preco_categoria.categoryid
	AND p1.unitprice = menor_preco_categoria.unitprice


	
	categoryid  productid   productname                              unitprice
	----------- ----------- ---------------------------------------- ---------------------
	1           24          Product QOGNU                            4,50
	2           3           Product IMEHJ                            10,00
	3           19          Product XKXDO                            9,20
	4           33          Product ASTMN                            2,50
	5           52          Product QSRXF                            7,00
	6           54          Product QAQRL                            7,45
	7           74          Product BKAZJ                            10,00
	8           13          Product POXFU                            6,00
	
	A consulta calcula o preço mínimo de cada categoria internamente, para cruzar com a tabela externa e aplicar o filtro de preço mínimo no join
	
	Outro exemplo de consulta correlacionada (retorna os clientes que fizeram pedidos no dia 12-02-2016:
	SELECT custid, companyname
		FROM Sales.Customers AS C
		WHERE EXISTS
		(SELECT *
			FROM Sales.Orders AS O
			WHERE O.custid = C.custid
			AND O.orderdate = '20160212');
	
	custid      companyname
	----------- ----------------------------------------
	45          Customer QXPPT
	48          Customer DVFMB
	76          Customer SFOGW
		
	O predicado EXISTS aceita uma subconsulta como entrada e retorna verdadeiro quando a subconsulta retorna pelo menos uma linha, retornando falso em caso negativo. 
	No exemplo, a subconsulta retorna os pedidos realizados pelo cliente cujo ID é igual ao da consulta externa no dia 12-02-2016. Já a consulta externa retorna os pedidos desde que tenham sido realizados neste mesmo dia. 
	
	Como predicado, EXISTS não necessita retornar um valor como resultado de uma subconsulta
	ao invés disso, retorna apenas verdadeiro ou falso, se a subconsulta retornar alguma linha.
	Por este motivo, o otimizador de consulta ignora a lista SELECT da subconsulta e, portanto, tudo o que você especificar não afetará as opções de otimização como o uso de algum índice. 
	
	NOT EXISTS 
		- funciona de forma contrária ao predicado EXISTS. 
	Exemplo: 
		
		-- retorna clientes que não realizaram pedidos no dia 12-02-2016
		SELECT custid, companyname
		FROM Sales.Customers AS C
		WHERE NOT EXISTS
		(
			SELECT *
				FROM Sales.Orders AS O
				WHERE O.custid = C.custid
				AND O.orderdate = '20160212'
		);
	
		custid      companyname
		----------- ----------------------------------------
		72          Customer AHPOP
		58          Customer AHXHT
		25          Customer AZJED
		18          Customer BSVAR
		91          Customer CCFIZ
		68          Customer CCKOT
		49          Customer CQRAA
		24          Customer CYZTN
	....
	
	OTIMIZAÇÃO DE SUBCONSULTAS VS JOINS 
	Ao comparar o desempenho entre subconsultas e joins, você descobrirá que nem sempre uma é melhor do que a outra. 
	Em alguns cados, as consultas resultarão no mesmo plano de Execução, em outros as subconsultas são mais performáticas e vice-versa. 
	Em casos críticos de performance, você precisa testar todas as alternativas. No entanto, existem aspectos específicos dessas ferramentas onde o SQL Server lida melhor de um jeito do que de outro, que você precisa ter em mente. 
	Se você tiver multiplas subconstas que precisam aplicar cálculos, como agregações sobre o mesmo conjunto de dados, o SQL Server realizará um acesso separado aos dados para cada subconsulta. Com um join, você pode aplicar cálculos baseados no mesmo acesso aos dados. 
	
	Exemplo
	Suponha que você precise consultar a tabela de pedidos e  calcular o percentual de frete, bem como a diferentça do ticket médio. Você pode realizar as consultas a seguir
	
	
	CREATE INDEX idx_cid_i_frt_oid
		ON Sales.Orders(custid) INCLUDE(freight, orderid); -- indice para auxiliar 

		-- custo da consulta (63%)
		SELECT orderid, custid, freight,
		freight / ( SELECT SUM(O2.freight)
		FROM Sales.Orders AS O2
		WHERE O2.custid = O1.custid ) AS pctcust,
		freight - ( SELECT AVG(O3.freight)
		FROM Sales.Orders AS O3
		WHERE O3.custid = O1.custid ) AS diffavgcust
		FROM Sales.Orders AS O1;

		orderid     custid      freight               pctcust               diffavgcust
		----------- ----------- --------------------- --------------------- ---------------------
		10643       1           29,46                 0,1031                5,6617
		10692       1           61,02                 0,2136                37,2217
		10702       1           23,94                 0,0838                0,1417
		10835       1           69,53                 0,2434                45,7317
		10952       1           40,42                 0,1415                16,6217
		11011       1           1,21                  0,0042                -22,5883
		11080       1           10,00                 0,035                 -13,7983
		11081       1           10,00                 0,035                 -13,7983
		11082       1           10,00                 0,035                 -13,7983

		-- custo da consulta (37%)
		SELECT O.orderid, O.custid, O.freight,
		freight / totalfreight AS pctcust,
		freight - avgfreight AS diffavgcust
		FROM Sales.Orders AS O
		INNER JOIN ( SELECT custid, SUM(freight) AS totalfreight, AVG(freight) AS avgfreight
		FROM Sales.Orders
		GROUP BY custid ) AS A
		ON O.custid = A.custid;
		
		orderid     custid      freight               pctcust               diffavgcust
		----------- ----------- --------------------- --------------------- ---------------------
		10643       1           29,46                 0,1031                5,6617
		10692       1           61,02                 0,2136                37,2217
		10702       1           23,94                 0,0838                0,1417
		10835       1           69,53                 0,2434                45,7317
		10952       1           40,42                 0,1415                16,6217
		11011       1           1,21                  0,0042                -22,5883
		11080       1           10,00                 0,035                 -13,7983
		11081       1           10,00                 0,035                 -13,7983
		11082       1           10,00                 0,035                 -13,7983
				
		O comparativo do plano de execução indica que a segunda consulta é mais performática (37% do custo)
			
		Na primeira consulta, o índice é acessado 3 vezes, enquanto na segunda o índice é acessado apenas uma vez. 
		
		2o exemplo
		Suponha que você precise retornar os remetentes que não atenderam nenhum pedido. 
		Consulta baseada em subquery
		-- custo (32%)
		SELECT S.shipperid
			FROM Sales.Shippers AS S
			WHERE NOT EXISTS
			(SELECT *
			FROM Sales.Orders AS O
			WHERE O.shipperid = S.shipperid);

		Consulta baseada em join 
		-- custo (68%)
		SELECT S.shipperid
			FROM Sales.Shippers AS S
			LEFT OUTER JOIN Sales.Orders AS O
			ON S.shipperid = O.shipperid
			WHERE O.orderid IS NULL;
		
		Neste caso, a consulta baseada em subquerie tem um custo menor (32%)
		
		Ambos os planos usam um algoritmo de Loops aninhados para processar a junção. 
		Neste algoritmo, a consulta externa do loop varre as linhas do remetente da tabela Sales.Shippers. 
		Para cada linha de remetente, entrada interna do loop procura por pedidos correspondentes no índice não clusterizado em Sales.Orders.
		A principal diferença entre os planos é que, com a solução baseada em subconsulta, o otimizador é capaz de usar uma otimização especializada chamada Anti Semi Join. 			Com esta otimização, assim que uma correspondência for encontrada, a execução causa um curto-circuito (observe o operador Top com o Top Propriedade de expressão definida como 1).
		Com a solução baseada em join, uma linha de remetente é combinada com todos os seus pedidos correspondentes e, posteriormente, o plano filtra apenas os remetentes que não tiveram correspondências. Observe o custo relativo de cada plano de consulta de todo o lote. O plano da execução baseada em subconsulta custa menos da metade do plano da solução baseada em join. 
		Até a edição deste artigo, o SQL Server não utilizava a otimização Anti Semi Join para consultas baseadas em uma junção real, mas sim para consultas baseadas em subconsultas e operadores de conjunto.
		
		Em resumo, ao otimizar suas soluções, é importante estar informado sobre os caos onde uma alternativa é melhor do que outra. Tenha em mente estas opções, teste diferentes soluções, compare os seus resultados e planos de execução, para escolher o que melhor de adequar. 
	
	Operador APPLY
	Operador muito poderoso, que permite aplicar determinada lógica a cada linha da tabela 
	Ele avalia o lado esquerdo primeiro, e para cada linha, aplica uma consulta derivada da tabela ou função do lado direito. 
	Em comparação com um join, a junção trata duas entradas como um conjunto (sem ordem)
	Se qualquer uma das entradas da junção for uma consulta, você não poderá fazer referência nessa consulta a elementos do outro lado (correlações não são permitidas)
	Por outro lado, o operador APPLY avalia primeiro o lado esquerdo e, para cada uma das linhas à esquerda, aplica a expressão de tabela que você fornece como a entrada direita. Como resultado, a consulta do lado direito pode ter referências a elementos do lado esquerdo. 
		As referências do lado direito aos elementos da esquerda são correlações.
	Com subconsultas normais, você geralmente está limitado a retornar apenas uma coluna, enquanto com uma expressão de tabela aplicada você pode retornar um resultado de tabela inteira com várias colunas e várias linhas. Isso significa que você pode substituir o uso de cursores em alguns casos pelo operador APPLY.
	Exemplo: 
		suponha que você tenha uma consulta que aplica determinada lógica a um fornecedor específico, e que você precisa aplicar o mesmo procedimento em todos os fornecedores da tabela. Você poderia utilizar um cursor para iterar cada fornecedor, consultando os dados do fornecedor atual. 
		Em vez disso, você pode aplicar o operador APPLY, utilizando a tabela de fornecedores no lado esquerdo e a expressão de cálculo desejada no lado direito. Você pode correlacionar a chave do fornecedor na consulta interna do lado direito com do lado esquerdo. 
		
	CROSS APPLY
	O operador CROSS APPLY opera nos inputs do lado esquerdo e direito. 
	A expressão do lado direito pode ter uma correlação com os elementos da tabela da esquerda. 
	A expressão de tabela do lado direito é aplicada a cada linha do lado esquerdo. 
	A principal diferença entre o operador CROSS APPLY e OUTER APPLY é o fato de se a expressão de tabela da direita retornar um cojunto vazio para uma linha da esquerda, esta mesma linha da esquerda não é retornada. 
	Este operador recebe este nome por se comportar como um join cruzado entre essa linha e o cojunto de dados retornados por entrada do lado direito. 
	CROSS APPLY é semelhante a ym INNER JOIN entre uma tabela e uma função, cuja função é aplicada para cada registro da tabela da esquerda. 
	
	Exemplo:
	
	SELECT TOP (2) productid, productname, unitprice
		FROM Production.Products
		WHERE supplierid = 1
		ORDER BY unitprice, productid;
	
	productid   productname                              unitprice
	----------- ---------------------------------------- ---------------------
	3           Product IMEHJ                            10,00
	1           Product HHYDP                            18,00


	SELECT S.supplierid, S.companyname AS supplier, A.*
	FROM Production.Suppliers AS S
		  CROSS APPLY (SELECT TOP (2) productid, productname, unitprice
        			       FROM Production.Products AS P
		               WHERE P.supplierid = S.supplierid
        			       ORDER BY unitprice, productid) AS A
		WHERE S.country = N'Japan';
		
	supplierid  supplier                                 productid   productname                              unitprice
	----------- ---------------------------------------- ----------- ---------------------------------------- ---------------------
	4           Supplier QOVFD                           74          Product BKAZJ                            10,00
	4           Supplier QOVFD                           10          Product YHXGE                            31,00
	6           Supplier QWUSF                           13          Product POXFU                            6,00
	6           Supplier QWUSF                           15          Product KSZOI                            15,50

		
	Exemplo 2: 
	
	CREATE TABLE DEPARTMENT
	(
		ID INT PRIMARY KEY,
		DEPARTMENTNAME NVARCHAR(50)
	)
	GO

	Insert into Department values (1, 'IT')
	Insert into Department values (2, 'HR')
	Insert into Department values (3, 'Payroll')
	Insert into Department values (4, 'Administration')
	Insert into Department values (5, 'Sales')
	Go
	
	CREATE TABLE EMPLOYEE
	(
		ID INT PRIMARY KEY,
		NAME NVARCHAR(50),
		GENDER NVARCHAR(10),
		SALARY INT,
		DEPARTMENTID INT FOREIGN KEY REFERENCES DEPARTMENT(ID)
	)
	GO

	Insert into Employee values (1, 'Mark', 'Male', 50000, 1)
	Insert into Employee values (2, 'Mary', 'Female', 60000, 3)
	Insert into Employee values (3, 'Steve', 'Male', 45000, 2)
	Insert into Employee values (4, 'John', 'Male', 56000, 1)
	Insert into Employee values (5, 'Sara', 'Female', 39000, 2)
	Go
	
	
	CREATE FUNCTION FN_GETEMPLOYEESBYDEPARTMENTID(@DEPARTMENTID INT)
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT ID, NAME, GENDER, SALARY, DEPARTMENTID
		FROM EMPLOYEE WHERE DEPARTMENTID = @DEPARTMENTID
	)
	GO
	
	-- testes
	SELECT * FROM FN_GETEMPLOYEESBYDEPARTMENTID(1)
	
	
		Id          Name                                               Gender     Salary      DepartmentId
	----------- -------------------------------------------------- ---------- ----------- ------------
	1           Mark                                               Male       50000       1
	4           John                                               Male       56000       1

	
	
	SELECT D.DEPARTMENTNAME, E.NAME, E.GENDER, E.SALARY
	FROM DEPARTMENT D
	INNER JOIN FN_GETEMPLOYEESBYDEPARTMENTID(D.ID) E
	ON D.ID = E.DEPARTMENTID
	
	Msg 4104, Level 16, State 1, Line 208
	The multi-part identifier "D.Id" could not be bound.
	
	DepartmentName                                     Name                                               Gender     Salary
	-------------------------------------------------- -------------------------------------------------- ---------- -----------
	IT                                                 Mark                                               Male       50000
	Payroll                                            Mary                                               Female     60000
	HR                                                 Steve                                              Male       45000
	IT                                                 John                                               Male       56000
	HR                                                 Sara                                               Female     39000
	
	Select D.DepartmentName, E.Name, E.Gender, E.Salary
	from Department D
	Cross Apply fn_GetEmployeesByDepartmentId(D.Id) E
	
	
	
	OUTER APPLY 
	É uma extensão do operador CROSS APPLY. 
	Além de retornar todas as linhas com correspondência do expressão de tabela do lado direito, retorna também os registros do lado esquerdo sem correspondencia com o lado direito, que aparece como nulo.  
	OUTER APPLY preserva os registros do lado esquerdo, enquanto CROSS APPLY retorna apenas as correspondencias de ambos os  lados. A diferença entre OUTER APPLY e CROSS APPLY é análoga à diferença entre LEFT JOIN e INNER JOIN. 
	
	Exemplo 
	
	Select D.DepartmentName, E.Name, E.Gender, E.Salary
	from Department D
	Outer Apply fn_GetEmployeesByDepartmentId(D.Id) E
	
	DepartmentName                                     Name                                               Gender     Salary
	-------------------------------------------------- -------------------------------------------------- ---------- -----------
	IT                                                 Mark                                               Male       50000
	IT                                                 John                                               Male       56000
	HR                                                 Steve                                              Male       45000
	HR                                                 Sara                                               Female     39000
	Payroll                                            Mary                                               Female     60000
	Administration                                     NULL                                               NULL       NULL
	Sales                                              NULL                                               NULL       NULL
	
	https://csharp-video-tutorials.blogspot.com/2015/09/cross-apply-and-outer-apply-in-sql.html
	
	
	Para mais informações sobre usos do operador APPLY, procure pelo seminário "Boost your T-SQL with the APPLY operator" disponível em:
	http://aka.ms/BoostTSQL
	https://channel9.msdn.com/Series/Boost-Your-T-SQL-With-the-APPLY-Operator
	
	-------------------------------------------------------------------------------------------------
	EXPRESSÕES DE TABELA 
	São consultas nomeadas. T-SQL suporta 4 formas de exoressões de tabela: 
	■ Tabelas derivadas
	■ CTEs (commom table expressions)
	■ Visões (views)
	■ Funções de tabelas valoradas em linha (inline table-valued functions)
	
	Tabelas derivadas e CTEs são visiveis nos seus comandos de definição. 
	A definição da expressão de tabela fica preservada como um objeto do banco. Assim é possível controlar as permissões de acesso ao objeto
	Devido ao fato de a expressão de tabela represetar uma relação, a consulta interna precisa ser relacional, ou seja, todas as colunas precisam estar nomeadas com nomes únicos e sem ordenação (um conjunto não é ordenado)
	A única exceção é o caso do comando TOP ou OFFSET-FETCH, já que a ordenação não é usada para ordenar a saída do dado, mas para a realização do comando. 
	Se a consulta externa não apresentar ordenação, não há garantia que de os dados estejam ordenados. 
	
	Expressões de table ou tabelas temporárias?
	Sob a perspectiva de performance, quando o SQL Server otimiza consultas envolvendo expressões de tabela, primeiro desaninha a lógica destas para depois interagir com as tabelas subjacentes. Os dados não são persistidos para realizar algum processamento. 
	Caso necessite persistir os dados, é necessário utilizar tabelas temporárias ou variáveis de tabela. 
	Em alguns casos, expressões de tabela são melhores do que tabelas temporárias. 
	A principal diferença entre tabelas temporárias e var tables, sob o ponto de vista de otimização, é que o SQL Server mantém estatísticas completas em tabelas temporárias e mínimas para variáveis de tabela.
	Estimativas de cardinalidade (quantidade de linhas) tendem a ser mais precisas com tabelas temporárias. 
	Ao lidar com quantidades muito pequenas de dados, normalmente é recomendado usar variáveis de tabela. Para tabelas maiores é recomendado o uso de tabelas temporárias, resultando em planos de execução melhores. 
	
	Tabelas derivadas
	Consistem em subconsultas nomeadas. Você define a tabela interna entre parenteses depois do comando FROM ou de algum tipo de JOIN. 
	Exemplo:
	Categorias com até dois produtos 
	SELECT categoryid, productid, productname, unitprice
	FROM (SELECT
    	    ROW_NUMBER() OVER(PARTITION BY categoryid
                          ORDER BY unitprice, productid) AS rownum,
	        categoryid, productid, productname, unitprice
    	  FROM Production.Products) AS D
	WHERE rownum <= 2;
	
	categoryid  productid   productname                              unitprice
	----------- ----------- ---------------------------------------- ---------------------
	1           24          Product QOGNU                            4,50
	1           75          Product BWRLG                            7,75
	2           3           Product IMEHJ                            10,00
	2           77          Product LUNZZ                            13,00
	3           19          Product XKXDO                            9,20
	3           47          Product EZZPR                            9,50
	4           33          Product ASTMN                            2,50
	4           31          Product XWOXC                            12,50
		
	
	Dica de exame
	Durante o exame, preste atenção às questões de multipla escolha com alternativas que apresentam código inválido (erro de sintaxe), por exemplo filtro de alias. Certifique-se de identificar a resposta com a sintaxe válida após eliminar as opções inválidas. 
	
	Se você definir uma tabela derivada como input do lado esquerdo do join, é a não é visível do lado direito, já que não é possível acessar multiplas instancias da mesma consulta sem recorrer ao uso de CTEs. 
	
	CTEs (Common table expressions)
	São similares às tabelas temporárias, mas são visíveis em todo o comando. 
	CTEs possuem 3 partes:
	■ nome da expressão 
	■ consulta interna
	■ consulta externa 
	sintaxe
	WITH <CTE_name>
	AS
	(
		  <inner_query>		
	)
		<outer_query>;
	A consulta externa não é obrigada a utilizar a expressão de tabela, porém seria um desperdício de recurso computacional.
	Exemplo: 
	WITH C AS
	(
		  SELECT
		    ROW_NUMBER() OVER(PARTITION BY categoryid
		                      ORDER BY unitprice, productid) AS rownum,
		    categoryid, productid, productname, unitprice
		  FROM Production.Products
	)
	SELECT categoryid, productid, productname, unitprice
	FROM C
	WHERE rownum <= 2;
	
	CTEs não são aninhadas como ocorre em tabelas derivadas. 
	Ao utilizar várias CTEs, basta separá-los por vírgula. 
	Cada uma pode se referir às CTEs previamente definidas (aninhamento). Após o termino da consulta externa, todas as CTEs são apagadas. 
	CTEs sem aninhamentos são mais fáceis de se construir do que as com aninhamento e possuem menores chances de erro. 
	Exemplo
	WITH C1 AS
	(
	  SELECT ...
	  FROM T1
	  WHERE ...
	),
	C2 AS
	(
	  SELECT
	  FROM  C1
	  WHERE ...
	)
	SELECT ...
	FROM C2
	WHERE ...;
		
	Devido ao fato de o nome de uma CTE ser definido no começo da consulta, é possível reutilizá-las, diferentemente das tabelas derivadas. 
	WITH C AS
	(
		  SELECT ...
		  FROM T1
	)
	SELECT ...
	FROM C AS C1
	  INNER JOIN C AS C2
	    ON ...;
			
	Dica de exame
	Se CTEs que reutilizam a mesma expressão for custosa e tiver baixo volume de dados, seu uso pode não ser a melhor escolha. Você deve considerar a opção de persistir o resultado da consulta interna em uma tabela temporária primeiro, para em seguida juntar as duas instâncias da mesma expressão de tabela. 

	Recursividade de CTEs
	CTEs suportam consultas recursivas
	O corpo de uma consulta recursiva possui duas ou mais consultas, separadas pelo operador UNION ALL. 
	Pelo menos uma das consultas é a âncora, executada apenas uma vez, que retorna um resultado relacional válido. Uma das consultas (membro recursivo) faz referência ao nome da CTE. 
	A consulta é invocada repetidamente até retornar um conjunto de dados vazio. 
	A cada iteração, a referência da CTE representa o conjunto de resultados anteriores (de forma semelhante ao comando append em outras linguagens). 
	Em seguida, para a consulta externa, a CTE recursiva possui os dados do membro âncora e de todas as invocações do membro recursivo.
	Exemplo: 
	Hierarquia de funcionarios em uma organização

	WITH EmpsCTE AS
	(
	  SELECT empid, mgrid, firstname, lastname, 0 AS distance
	  FROM HR.Employees
	  WHERE empid = 9
	  UNION ALL
	  SELECT M.empid, M.mgrid, M.firstname, M.lastname, S.distance + 1 AS distance
	  FROM EmpsCTE AS S
	    JOIN HR.Employees AS M
	      ON S.mgrid = M.empid
	)
	SELECT empid, mgrid, firstname, lastname, distance
	FROM EmpsCTE;
	
	empid       mgrid       firstname  lastname             distance
	----------- ----------- ---------- -------------------- -----------
	9           5           Patricia   Doyle                0
	5           2           Sven       Mortensen            1
	2           1           Don        Funk                 2
	1           NULL        Sara       Davis                3

	Como você pode ver, o membro âncora retorna a fila para o funcionário 9. Em seguida, o membro recursivo é invocado repetidamente, e em cada rodada junta-se ao resultado anterior definido com o com a tabela de funcionários para devolver o gerente direto do funcionário da rodada anterior. A consulta recursiva pára assim que retorna um conjunto vazio — neste caso, depois de não encontrar um gerente do CEO. Em seguida, a consulta externa retorna os resultados unificados da invocação do membro âncora (a fila para o empregado 9) e todas as invocações do membro recursivo (todos os gerentes acima do empregado 9).
	É possível realizar consultas recursivas de forma ascendente ou descendente.
	
	Visões e funções em linha de valor de tabela
	CTEs e tabelas derivadas não são reutilizáveis em outros objetos que as acessem. Como alternativa, existem as views e funções em linha de valor de tabela. 
	A maior diferença entre as views e funções em linha de valor de tabela é o fato de a primeira não aceitar parâmetros, enquanto a segunda aceita. 
	
	View: 
	Exemplo de view:
	DROP VIEW IF EXISTS Sales.RankedProducts;
	GO
	CREATE OR ALTER VIEW Sales.RankedProducts
	AS
	SELECT
	  ROW_NUMBER() OVER(PARTITION BY categoryid
	                    ORDER BY unitprice, productid) AS rownum,
	  categoryid, productid, productname, unitprice
	FROM Production.Products;
	GO
	Em uma view, é persistido no banco o comando a consulta desejada, e não os dados, tornando a consulta reutilizável, como no exemplo a seguir: 
	
	SELECT categoryid, productid, productname, unitprice
	FROM Sales.RankedProducts
	WHERE rownum <= 2;
	
	Funções em linha de valor de tabela
	São semelhantes às views, mas aceitam parâmetros de entrada:
	Exemplo: 
	
	DROP FUNCTION IF EXISTS HR.GetManagers;
	GO
	CREATE FUNCTION HR.GetManagers(@empid AS INT) RETURNS TABLE
	AS
	RETURN
	  WITH EmpsCTE AS
	  (
	    SELECT empid, mgrid, firstname, lastname, 0 AS distance
	    FROM HR.Employees
	    WHERE empid = @empid
	    UNION ALL
	    SELECT M.empid, M.mgrid, M.firstname, M.lastname, S.distance + 1 AS distance
	    FROM EmpsCTE AS S
	      JOIN HR.Employees AS M
	        ON S.mgrid = M.empid
	  )
	  SELECT empid, mgrid, firstname, lastname, distance
	  FROM EmpsCTE;
	GO
	
	SELECT *
	FROM HR.GetManagers(9) AS M;
	
	empid       mgrid       firstname  lastname             distance
	----------- ----------- ---------- -------------------- -----------
	9           5           Patricia   Doyle                0
	5           2           Sven       Mortensen            1
	2           1           Don        Funk                 2
	1           NULL        Sara       Davis                3

	Dica de exame:
	Você não está limitado a usar apenas comandos SELECT em expressões de tabela. 
	São aceitos também os comandos INSERT, UPDATE, DELETE e MERGE.
	Uma vez que a expressão de tabela é apenas um reflexo dos dados de uma tabela subjacente, a tabela subjacente pode ser modificada através de comandos de DML. 
	
	
	------------------------------------------------------------------------------------------
	
	Agrupamento e pivoteamento de consultas 
	
	Consultas agrupadas
	Você pode usar consultas agrupadas para definir grupos de dados e realizar análises por grupo. Consultas tradicionais define um único conjunto de dados, mas é possível criar vários conjuntos em uma consulta. 
	
	Agrupamebnto de um único conjunto de dados
	Uma consulta que invoca uma função de agrupamento sem especificar colunas específicas realizam a operação em um único grupo, como uma agregação escalar. 
	SELECT COUNT(*) AS numorders
		FROM Sales.Orders;
	
	Agrupamento particionado 
	Para realizar agrupamentos a partir de determinadas colunas, basta indicá-las na consulta e após o comando GROUP BY. 
	SELECT shipperid, COUNT(*) AS numorders
	FROM Sales.Orders
		GROUP BY shipperid;
	
	shipperid   numorders
	----------- -----------
	1           255
	2           326
	3           255
	
	Um conjunto agrupado por conter múltiplos elementos, como na consulta abaixo:
	
	shipperid   shippedyear numorders
	----------- ----------- -----------
	1           2014        36
	2           2015        143
	1           2017        6
	1           NULL        4
	3           2016        73
	3           NULL        6
	3           2014        51
	2           2016        116
	2           NULL        11
	1           2015        130
	3           2015        125
	1           2016        79
	2           2014        56
	
	Repare que cada grupo possui uma combinação diferente de ano e id, inclusive quando algum campo aparece como nulo. 
	Para filtrar grupos inteiros, é necessário utilizar o comando HAVING, que realiza filtro no agrupamento, e não nas linhas, como a cláusula WHERE. 
	
	SELECT shipperid, YEAR(shippeddate) AS shippedyear,
		COUNT(*) AS numorders
	FROM Sales.Orders
	WHERE shippeddate IS NOT NULL
	GROUP BY shipperid, YEAR(shippeddate)
	HAVING COUNT(*) < 100;
	
	
	shipperid   shippedyear numorders
	----------- ----------- -----------
	1           2014        36
	1           2017        6
	3           2016        73
	3           2014        51
	1           2016        79
	2           2014        56
		
	T-SQL suporta as funções de agregação a seguir: 
	■ COUNT
	■ MIN
	■ MAX
	■ SUM
	■ AVG
	Funções de agrupamento ignoram registros nulos. 
	
	
	SELECT shipperid,
		 COUNT(*) AS numorders,
		 COUNT(shippeddate) AS shippedorders,
		 MIN(shippeddate) AS firstshipdate,
		 MAX(shippeddate) AS lastshipdate,
		 SUM(val) AS totalvalue
	FROM Sales.OrderValues
	GROUP BY shipperid;
	shipperid   numorders   shippedorders firstshipdate lastshipdate totalvalue
	----------- ----------- ------------- ------------- ------------ ------------
	3           255         249           2014-07-15    2016-05-01   383405.53
	1           255         251           2014-07-10    2017-02-16   349020.00
	2           326         315           2014-07-11    2016-05-06   533547.69
	Warning: Null value is eliminated by an aggregate or other SET operation.
	
	Repare que existe diferença entre as agregações COUNT(*) e COUNT(shippeddate)
	COUNT(shippedorders) ignora registros nulos, enquanto COUNT(*), já que este último realiza a contagem de todas as colunas (quando todas as colunas estão nulas, a linha não existe)
	
	Também é possível realizar agregações distintas: 
	
	shipperid   numshippingdates
	----------- ----------------
	1           189
	2           215
	3           198
	Warning: Null value is eliminated by an aggregate or other SET operation.

	DISTINCT não está disponível apenas na função COUNT, mas também em outras funções. 
	É mais comum se ver aplicada à função COUNT. 
	Do ponto de vista do processamento de consultas lógicas, a cláusula GROUP BY é avaliada após as cláusulas FROM e WHERE e antes das cláusulas HAVING, SELECT e ORDER BY. Assim, as três últimas cláusulas já funcionam com uma tabela agrupada e, portanto, as expressões que eles apoiam são limitadas.
	Cada grupo é representado por apenas uma linha de resultado; portanto, todas as expressões que aparecem nessas cláusulas devem garantir um único valor de resultado por grupo.
	Não há problema em se referir diretamente a elementos que aparecem na cláusula GROUP BY porque cada um desses retorna apenas um valor distinto por grupo. Mas se você quiser se referir a elementos das tabelas subjacentes que não aparecem na lista GROUP BY, você deve aplicar uma função agregada a eles.
	Ex.: 
	SELECT S.shipperid, S.companyname, COUNT(*) AS numorders
		FROM Sales.Shippers AS S
		 INNER JOIN Sales.Orders AS O
		 ON S.shipperid = O.shipperid
		GROUP BY S.shipperid;
	Column 'Sales.Shippers.companyname' is invalid in the select list because it is not 
contained in either an aggregate function or the GROUP BY clause.

Uma forma de realizar consultas agrupadas com linhas repetidas é utilizar as funções MIN e MA
	SELECT S.shipperid,
	 MAX(S.companyname) AS companyname,
	 COUNT(*) AS numorders
	FROM Sales.Shippers AS S
	 INNER JOIN Sales.Orders AS O
	 ON S.shipperid = O.shipperid
	GROUP BY S.shipperid;

	shipperid   companyname                              numorders
	----------- ---------------------------------------- -----------
	1           Shipper GVSUA                            255
	2           Shipper ETYNR                            326
	3           Shipper ZHISN                            255
	
	Uma forma alternativa é agregar as linhas primeiro em uma consulta separada para depois realizar o cruzamento com outra tabela. 
	
	WITH C AS
	(
	 SELECT shipperid, COUNT(*) AS numorders
	 FROM Sales.Orders
	 GROUP BY shipperid
	)
	SELECT S.shipperid, S.companyname, numorders
	FROM Sales.Shippers AS S
	 INNER JOIN C
	 ON S.shipperid = C.shipperid;

	 shipperid   companyname                              numorders
	----------- ---------------------------------------- -----------
	1           Shipper GVSUA                            255
	2           Shipper ETYNR                            326
	3           Shipper ZHISN                            255
	 
	 A segunda opção é mais performática e mais limpa (remoção de duplicidade através de join)
	 
	 SELECT S.shipperid, S.companyname,
		COUNT(*) AS numorders
	FROM Sales.Shippers AS S
	 INNER JOIN Sales.Orders AS O
	 ON S.shipperid = O.shipperid
	GROUP BY S.shipperid, S.companyname;
	 
	shipperid   companyname                              numorders
	----------- ---------------------------------------- -----------
	1           Shipper GVSUA                            255
	2           Shipper ETYNR                            326
	3           Shipper ZHISN                            255
	
	
	Agregações definidas pelo usuário
	O SQL Server também permite criar agregações definidas pelo usuário (UDA - user defined aggregates) usando o código .NET com base no CLR (Common Language Runtime, tempo de execução da linguagem comum).
	Ele fornece alguns UDAs CLR incorporados para os tipos de dados espaciais GEOMETRY e GEOGRAPHY e também permite que você crie novos UDAs operando em tipos espaciais como entradas.
	Para maiores detalhes, consulte:
	https://msdn.microsoft.com/en-us/library/ms131057.aspx
	
	---------------------------------------------------------------------------
	
	Trabalhando com múltiplos conjuntos de agrupamento
	
	Com o T-SQL, você pode usar uma consulta para agrupar os dados de mais de uma maneira. 
	O T-SQL suporta três cláusulas que permitem conjuntos de agrupamento definidos: 
	GROUPING SETS, CUBE e ROLLUP, usados na cláusula GROUP BY.
	■ GROUPING SETS
	Lista todos os conjuntos de agrupamento que você deseja definir na consulta
	
	SELECT shipperid, YEAR(shippeddate) AS shipyear, COUNT(*) AS numorders
	FROM Sales.Orders
	WHERE shippeddate IS NOT NULL -- exclude unshipped orders
	GROUP BY GROUPING SETS
	(
	 ( shipperid, YEAR(shippeddate) ),
	 ( shipperid ),
	 ( YEAR(shippeddate) ),
	 ( )
	);
	
	
	SHIPPERID   SHIPYEAR    NUMORDERS
	----------- ----------- -----------
	1           2014        36
	2           2014        56
	3           2014        51
	NULL        2014        143
	1           2015        130
	2           2015        143
	3           2015        125
	NULL        2015        398
	1           2016        79
	2           2016        116
	3           2016        73
	NULL        2016        268
	1           2017        6
	NULL        2017        6
	NULL        NULL        815
	3           NULL        249
	1           NULL        251
	2           NULL        315

	A saída combina os resultados de agrupamento e agregação de 4 diferentes conjuntos 
	As colunas que não são usadas no agrupamento aparecem como nulo. 
	
	Você pode alcançar o mesmo resultado montando consultas com agrupamentos separados, cada uma definindo um agrupamento diferente. Entretanto, isso consumiria mais recursos e seria um código mais extenso. 
	
	SELECT SHIPPERID, YEAR(SHIPPEDDATE) AS SHIPYEAR, COUNT(*) AS NUMORDERS
		FROM SALES.ORDERS
		WHERE SHIPPEDDATE IS NOT NULL -- EXCLUDE UNSHIPPED ORDERS
		GROUP BY SHIPPERID, YEAR(SHIPPEDDATE) 
	UNION ALL
	SELECT  SHIPPERID , NULL AS SHIPYEAR, COUNT(*) AS NUMORDERS
		FROM SALES.ORDERS
		WHERE SHIPPEDDATE IS NOT NULL -- EXCLUDE UNSHIPPED ORDERS
		GROUP BY SHIPPERID 
	UNION ALL
	SELECT NULL AS SHIPPERID, YEAR(SHIPPEDDATE) AS SHIPYEAR, COUNT(*) AS NUMORDERS
		FROM SALES.ORDERS
		WHERE SHIPPEDDATE IS NOT NULL -- EXCLUDE UNSHIPPED ORDERS
		GROUP BY YEAR(SHIPPEDDATE) 
	UNION ALL
	SELECT NULL AS SHIPPERID, NULL AS SHIPYEAR, COUNT(*) AS NUMORDERS
		FROM SALES.ORDERS
		WHERE SHIPPEDDATE IS NOT NULL -- EXCLUDE UNSHIPPED ORDERS

	No comparativo do plano de execução das duas consultas, a 2a consulta corresponde a um custo de 60%, enquanto o mesmo comando com GROUPING SETS apresenta um custo de 40%. 
	
	CUBE e ROLLUP são abreviações da cláusula GROUPING SET. 

	■ CUBE: aceita uma lista de expressões como input e define todas as possibilidades de agrupamento que podem ser realizados com as entradas, inclusive agrupamentos com conjuntos vazios.
	O comando a seguir retorna o mesmo resultado que o comando GROUPING SET anterior. 
		SELECT shipperid, YEAR(shippeddate) AS shipyear, COUNT(*) AS numorders
		FROM Sales.Orders
		WHERE shippeddate IS NOT NULL 
		GROUP BY CUBE( shipperid, YEAR(shippeddate) );
	
		shipperid   shipyear    numorders
		----------- ----------- -----------
		1           2014        36
		2           2014        56
		3           2014        51
		NULL        2014        143
		1           2015        130
		2           2015        143
		3           2015        125
		NULL        2015        398
		1           2016        79
		2           2016        116
		3           2016        73
		NULL        2016        268
		1           2017        6
		NULL        2017        6
		NULL        NULL        815
		3           NULL        249
		1           NULL        251
		2           NULL        315
	A cláusula CUBE define todas as quatro possibilidades de agrupamento para os dois inputs:
	■ ( shipperid, YEAR(shippeddate) )
	■ ( shipperid )
	■ ( YEAR(shippeddate) )
	■ ( )
	
	■ ROLLUP
	Também é uma forma de abreviação da cláusula GROUPING SETS, mas é usada quando existe uma hierarquia natural formada entre os elementos de entrada. 
	No caso em questão somente um conjunto de agrupamentos possíveis é realmente interessante. 
	Considere, por exemplo, uma hierarquia de localização na ordem  shipcountry, shipregion, e shipcity.
	Só é interessante uma combinação de hierarquia em uma única direção, calculando agregações para os conjuntos a seguir:
	■ ( shipcountry, shipregion, shipcity )
	■ ( shipcountry, shipregion )
	■ ( shipcountry )
	■ ( )
	Qualquer outra combinação de agrupamento não é interessante em uma hierarquia. 
	Caso surja existam duas cidades com mesmo nome, não é interessante agrupar estes dados sem considerar os níveis mais altos da hierarquia (região e país)
	Quando os elementos formarem uma hierarquia, a cláusula ROLLUP permite agrupar os dados corretamente, evitando agregações desnecessárias. 
	
	Ex.:
	
	SELECT shipcountry, shipregion, shipcity, COUNT(*) AS numorders
		FROM Sales.Orders
		GROUP BY ROLLUP( shipcountry, shipregion, shipcity );

	
	shipcountry     shipregion      shipcity        numorders
	--------------- --------------- --------------- -----------
	Argentina       NULL            Buenos Aires    16
	Argentina       NULL            NULL            16
	Argentina       NULL            NULL            16
	Austria         NULL            Graz            30
	Austria         NULL            Salzburg        10
	Austria         NULL            NULL            40
	Austria         NULL            NULL            40
	Belgium         NULL            Bruxelles       7
	Belgium         NULL            Charleroi       12
	Belgium         NULL            NULL            19
	Belgium         NULL            NULL            19
	Brazil          RJ              Rio de Janeiro  34
	Brazil          RJ              NULL            34
	Brazil          SP              Campinas        9
	Brazil          SP              Resende         9
	Brazil          SP              Sao Paulo       31
	Brazil          SP              NULL            49
	Brazil          NULL            NULL            83
	Canada          BC              Tsawassen       14
	Canada          BC              Vancouver       3
	Canada          BC              NULL            17
	Canada          Québec          Montréal        13
	Canada          Québec          NULL            13
	Canada          NULL            NULL            30
	...
	/* verificar porque no comando ROLLUP o 1º nível da arquitetura aparece duplicado, como no caso da Argentina e da Bélgica (nível de país)*/
	
	Como mencionado, os campos que não fazem parte do agrupamento aparecem como nulo, sem ferir a estrutura da hierarquia. 
	Se todas as colunas agrupadas não permitirem NULLs na tabela subjacente, você poderá identificar as linhas que estão associadas a um único conjunto de agrupamento com base em uma combinação única de NULLs e não-NULLs nessas colunas.
	Se a coluna permitir registros nulos, fica difícil identificar as colunas que realmente estão nulas das que não fazem parte do agrupamento, como é o caso da coluna shipregion. 
	Como dizer se um registro nulo representa um placeholder (que significa "todas as regiões") ou um NULO original da tabela (que significa "região ausente")? 
	O T-SQL fornece duas funções para ajudar a resolver esse problema: GROUPING e GROUPING_ID.
	
	Função GROUPING 
	Aceita um único elemento como input.
	Retorna 0 quando o elemento faz parte de um agrupamento e retorna 1 quando não o fizer, ou seja, 1 indica um elemento e 1 define uma hiperagregação. 
	
	
	
		SELECT
			shipcountry, GROUPING(shipcountry) AS grpcountry,
			shipregion , GROUPING(shipregion) AS grpregion,
			shipcity , GROUPING(shipcity) AS grpcity,
			COUNT(*) AS numorders
		FROM Sales.Orders
		GROUP BY ROLLUP( shipcountry, shipregion, shipcity )
		
	shipcountry     grpcountry shipregion      grpregion shipcity        grpcity numorders
	--------------- ---------- --------------- --------- --------------- ------- -----------
	Argentina       0          NULL            0         Buenos Aires    0       16
	Argentina       0          NULL            0         NULL            1       16
	Argentina       0          NULL            1         NULL            1       16
	Austria         0          NULL            0         Graz            0       30
	Austria         0          NULL            0         Salzburg        0       10
	Austria         0          NULL            0         NULL            1       40
	Austria         0          NULL            1         NULL            1       40
	Belgium         0          NULL            0         Bruxelles       0       7
	Belgium         0          NULL            0         Charleroi       0       12
	Belgium         0          NULL            0         NULL            1       19
	Belgium         0          NULL            1         NULL            1       19
	Brazil          0          RJ              0         Rio de Janeiro  0       34
	Brazil          0          RJ              0         NULL            1       34
	Brazil          0          SP              0         Campinas        0       9
	Brazil          0          SP              0         Resende         0       9
	Brazil          0          SP              0         Sao Paulo       0       31
	Brazil          0          SP              0         NULL            1       49
	Brazil          0          NULL            1         NULL            1       83
	Canada          0          BC              0         Tsawassen       0       14
	Canada          0          BC              0         Vancouver       0       3
	Canada          0          BC              0         NULL            1       17
	Canada          0          Québec          0         Montréal        0       13
	Canada          0          Québec          0         NULL            1       13
	Canada          0          NULL            1         NULL            1       30
	Country AAA     0          NULL            0         City AAA        0       6
	Country AAA     0          NULL            0         NULL            1       6
	Country AAA     0          NULL            1         NULL            1       6
	Denmark         0          NULL            0         Århus           0       11
	Denmark         0          NULL            0         Kobenhavn       0       7
	Denmark         0          NULL            0         NULL            1       18
	Denmark         0          NULL            1         NULL            1       18
	...

	Agora é possível identificar um conjunto de agrupamentos olhando para os 0s nos elementos que fazem parte do conjunto de agrupamento (elementos de detalhe) e 1s(elementos de agregação). 

	GROUPING_ID
	Também identifica os conjuntos de agrupamento.
	Aceita a lista de colunas agrupadas como entradas e retorna um inteiro representando um bitmap.
	
	O bit mais à direita representa a entrada mais à direita.
	O bit é 0 quando o respectivo elemento faz parte do conjunto de agrupamento e 1 quando não é.
	Cada bit representa 2 ao valor do menos 1. A parte mais à direita representa 1, a da esquerda 2, depois 4, depois 8, e assim por diante.
	O resultado inteiro é a soma dos valores que representam elementos que não fazem parte do conjunto de agrupamentos porque seus bits estão ligados. 

		SELECT GROUPING_ID( shipcountry, shipregion, shipcity ) AS grp_id,
			shipcountry, shipregion, shipcity,
			COUNT(*) AS numorders
		FROM Sales.Orders
			GROUP BY ROLLUP( shipcountry, shipregion, shipcity );
		
	grp_id      shipcountry     shipregion      shipcity        numorders
	----------- --------------- --------------- --------------- -----------
	0           Argentina       NULL            Buenos Aires    16
	1           Argentina       NULL            NULL            16
	3           Argentina       NULL            NULL            16
	0           Austria         NULL            Graz            30
	0           Austria         NULL            Salzburg        10
	1           Austria         NULL            NULL            40
	3           Austria         NULL            NULL            40
	0           Belgium         NULL            Bruxelles       7
	0           Belgium         NULL            Charleroi       12
	1           Belgium         NULL            NULL            19
	3           Belgium         NULL            NULL            19
	0           Brazil          RJ              Rio de Janeiro  34
	1           Brazil          RJ              NULL            34
	0           Brazil          SP              Campinas        9
	0           Brazil          SP              Resende         9
	0           Brazil          SP              Sao Paulo       31
	1           Brazil          SP              NULL            49
	3           Brazil          NULL            NULL            83
	...
	0           Venezuela       DF              Caracas         2
	1           Venezuela       DF              NULL            2
	0           Venezuela       Lara            Barquisimeto    14
	1           Venezuela       Lara            NULL            14
	0           Venezuela       Nueva Esparta   I. de Margarita 12
	1           Venezuela       Nueva Esparta   NULL            12
	0           Venezuela       Táchira         San Cristóbal   18
	1           Venezuela       Táchira         NULL            18
	3           Venezuela       NULL            NULL            46
	7           NULL            NULL            NULL            836
	
	A última linha desta saída representa um conjunto de agrupamento vazio (não possui nenhum dos 3 elementos)
	Por causa disso, os bits da função GROUPING_ID estão ativados (1, 2 e 4), cuja soma resulta em 7. 
	
	Nota 
	Algebra de Agrupamento de conjuntos
	
	Você pode especificar várias cláusulas GROUPING SETS, CUBE e ROLLUP na cláusula GROUP BY separadas por vírgulas.
	Ao fazer isso, você consegue um efeito de multiplicação. 
	Por exemplo, a cláusula CUBE(a, b, c) define oito conjuntos de agrupamento e a cláusula ROLLUP(x, y, z) define quatro conjuntos de agrupamento.
	Ao especificar uma vírgula entre os dois, como em CUBE(a, b, c), ROLLUP(x, y, z), você multiplica-os e recebe 32 conjuntos de agrupamento.
	Se você colocar uma cláusula CUBE ou ROLLUP dentro de uma cláusula GROUPING SETS, você alcançará um efeito de adição.
	Por exemplo, a expressão 
		GROUPING SETS (x, y, z), (z), CUBE(a, b, c)
		adiciona os dois conjuntos de agrupamento definidos explicitamente pela cláusula GROUPING SETS e os oito definidos implicitamente pela cláusula CUBE e produz dez conjuntos de agrupamento no total.

	Para obter cobertura dos aspectos de processamento de consulta lógica do agrupamento, consulte "Processamento de  consulta lógica parte 7: GRUPO BY e HAVING" 
	em http://sqlmag.com/sql-server/logical-query-processing-part-7-group-and-having
	
	------------------------------------------------------------------------------------------------------------
	
	Pivot e unpivot de dados (transposição de matrizes)
	Pivoteamento / transposição de matrizes é uma técnica especializada de agrupamento e agregação de dados. 
	Unpivot é o processo inverso de pivot. 
	T-SQL suporta ambos nativamente. 
	
	Pivot de dados
	Consiste em transport linhas em colunas. 
	Para isso, é necessário identificar três elementos: 
	1. O que você quer ver nas linhas? Este elemento é conhecido como on rows, ou o elemento de agrupamento (grouping).
	2. O que você quer ver nas colunas? Este elemento é conhecido como on cols, ou elemento de propagação (spreding).
	3. O que você deseja ver na intersecção de cada linha distinta e valor da coluna? Este elemento é conhecido como o elemento de agregação ou dados (data /agregation).
	
	Exemplo:
	Você deseja retornar uma linha para cada ID de cliente distinto (o elemento de agrupamento), uma coluna para cada ID de envio distinto (o elemento de disseminação) e na intersecção de cada cliente e entregador você deseja ver a soma dos valores de frete (o elemento de agregação). 
	
	WITH PivotData AS
	(
		SELECT
		 <grouping_column>,
		 <spreading_column>,
		 <aggregation_column>
		 FROM <source_table>
	)
	SELECT <select_list>
	FROM PivotData
	 PIVOT( <aggregate_function>(<aggregation_column>)
		FOR <spreading_column> IN (<distinct_spreading_values>) ) AS P;
	
	Esta forma geral é composta pelos elementos: 
	■ expressão de tabela que retorna os três elementos envolvidos no processo de pivoteamento. Não é recomendado consultar a tabela de origem diretamente.
	■ Você aplica usa a consulta externa para aplicar o operador PIVOT à expressão de tabela. 
	O operador PIVOT retorna outro resultado de tabela, que precisa de ALIAS. 
	■ A especificação para o operador PIVOT se inicia ao indicar uma função de agregação (aplicada ao elemento de agregação)
	■ Os campos de propagação (spreading / tranformados em colunas) são especificados na cláusula FOR. 
	■ A cláusula IN é usada para especificar os elementos distintos do campo de propagação (que serão tranformados em colunas), sepados por vírgulas. A lista de itens deve ser expressa como uma lista de identificadores de colunas. Elementos com nome irregular devem estar delimitados por colchetes. 
	Recomenda-se que todos os valores sejam delimitados para facilitar a leitura do código. 
	
	
	Exemplo: 
	WITH PivotData AS
	(
		 SELECT
		 custid, -- grouping column
		 shipperid, -- spreading column
		 freight -- aggregation column
		 FROM Sales.Orders
	)
	SELECT custid, [1], [2], [3]
	FROM PivotData
	 PIVOT(SUM(freight) FOR shipperid IN ([1],[2],[3]) ) AS P;
	
	
	custid      1                     2                     3
	----------- --------------------- --------------------- ---------------------
	1           155,03                61,02                 69,53
	2           43,90                 NULL                  53,52
	3           63,09                 116,56                88,87
	4           41,95                 358,54                71,46
	5           189,44                1074,51               295,57
	6           0,15                  126,19                41,92
	7           217,96                215,70                190,00
	8           16,16                 175,01                NULL
	9           341,16                419,57                597,14
	10          129,42                162,17                502,36
	11          NULL                  129,26                152,05
	12          3,17                  17,22                 52,37
	13          NULL                  NULL                  3,25
	14          171,68                72,37                 123,19
	15          121,62                66,20                 NULL
	16          6,17                  47,45                 NULL
	17          79,25                 41,33                 185,46
	18          37,16                 1,85                  24,69
	19          348,37                278,96                205,01
	20          2004,74               2611,76               1588,89
	
	
	Conceitualmente, a consulta acima realiza o agrupamento da consulta abaixo, separando os valores da coluna freight em novas colunas a partir os valores da coluna shipperid:
	
	 SELECT
	 custid, 				-- coluna de agrupamento mantida
	 shipperid, 			-- coluna transposta
	 sum(freight)freight 	-- coluna com valores transpostos nas novas colunas pivoteadas
	 FROM Sales.Orders
	 group by custid, 
	 shipperid
	 order by custid
	 
	custid      shipperid   freight
	----------- ----------- ---------------------
	1           1           155,03
	1           2           61,02
	1           3           69,53
	2           1           43,90
	2           3           53,52
	3           1           63,09
	3           2           116,56
	3           3           88,87
	4           1           41,95
	4           2           358,54
	4           3           71,46
	5           1           189,44
	5           2           1074,51
	5           3           295,57
	...
	
	Dica de exame:
	
	Como é possível ver na saída da consulta pivoteada, caso a coluna pivoteada não possua correspondencia com a coluna agrupada, o resultado é Nulo. Se você precisa retornar algo em vez de nulo, é possível aplicar os comandos ISNULL ou COALESCE. 

	 WITH PivotData AS
	(
	 SELECT
	 custid, 
	 shipperid,
	 freight 
	 FROM Sales.Orders
	)
	SELECT custid,
	 ISNULL([1], 0.00) AS [1],
	 ISNULL([2], 0.00) AS [2],
	 ISNULL([3], 0.00) AS [3]
	FROM PivotData
	 PIVOT(SUM(freight) FOR shipperid IN ([1],[2],[3]) ) AS P;

	Certifique-se de pensar no tratamento de Nulos ao escrever códigos T-SQL. 
	Se você olhar atentamente para a especificação do operador PIVOT, verá que são indicados os elementos de agregação e de propagação, mas não de agrupamento. Os campos de agrupamento são identificados por eliminação - os campos que restarem na consulta, que não forem de agregação nem de propagação. 
	
	Se você realizar o pivoteamento a diretamente a partir da tabela, todas as colunas serão usadas implicitamente como elementos de agrupamento além do que for especificado na agregação e na propagação.  
	
	SELECT custid, [1], [2], [3]
	FROM Sales.Orders
	PIVOT(SUM(freight) FOR shipperid IN ([1],[2],[3]) ) AS P;
	
	custid      1                     2                     3
	----------- --------------------- --------------------- ---------------------
	85          NULL                  NULL                  32,38
	79          11,61                 NULL                  NULL
	34          NULL                  65,83                 NULL
	84          41,34                 NULL                  NULL
	76          NULL                  51,30                 NULL
	34          NULL                  58,17                 NULL
	14          NULL                  22,98                 NULL
	68          NULL                  NULL                  148,33
	88          NULL                  13,97                 NULL
	35          NULL                  NULL                  81,91
	20          140,51                NULL                  NULL
	13          NULL                  NULL                  3,25
	56          55,09                 NULL                  NULL
	...
	
	No exemplo, foram retornados 830 registros porque esta é a quantidade de linhas da tabela. 
	Por causa disso, é recomendado utilizar expressões de tabela para delimitar os campos e evitar agrupamentos indesejados. 
	Esteja ciente de algumas limitações do operador PIVOT:
	■ Os elementos de agregação e de propagação não podem ser resultados de expressões; em vez disso, precisam ser nomes de colunas de uma tabela consultada. Caso o dado seja obtido a partir de uma transformação, é possível contornar a restrição através de uma CTE no passo anterior, para que expressão de tabela acessada pelo comando PIVOT apresente as colunas com os dados prontos para a transposição. 
	■ A função COUNT(*) não é aceita como função de agregação pelo operador PIVOT. Se você precisar de uma contagem, será necessário especificar a coluna desejada para que seja realizada a contagem. 
	Uma forma de contornar é definir uma coluna de manequim com valor constante (ex. 1 AS COL_AGREG) na expressão de tabela, para que o operador PIVOT aplique a agregação sob esta coluna: COUNT(COL_AGREG) ou SUM(COL_AGREG).
	■ O operador PIVOT está limitado a utilizar apena suma função de agregação. 
	■ A cláusula IN do operador PIVOT aceita uma lista estática de valores de propagação; não suporta subconsultas como entrada. 
	Você precisa saber com antecedência quais são os valores distintos na coluna de propagação e especificá-los na cláusula IN. Quando a lista não é conhecida, você pode usar SQL dinâmico para construir e executar a consulta depois que construir a lista distinta. 
	Para maiores detalhes sobre a construição de consultas com pivoteamento dinâmico, consulte: 
	https://www.itprotoday.com/sql-server/logical-query-processing-part-5-clause-and-unpivot
	
	Unpivot de dados
	É o processo inverso do pivot, logo precisa partir de um conjunto de dados que foi pivoteado, ou que apresenta a mesma estrutura. 
	No UNPIVOT, os inputs de dados são transpostos de colunas para linhas
	O operador atua na tabela de entrada que é fornecida à sua esquerda, que pode ser resultado de outros operadores de tabela, como os JOINS. O resultado do operador UNPIVOT é um resultado de tabela que pode ser usado como entrada para outros operadores de tabela que parecem à sua direita.
	Exemplo
	-- criação de tabela com dados pivoteados
	DROP TABLE IF EXISTS Sales.FreightTotals;
	GO
	;WITH PivotData AS
	(
	 SELECT
	 custid, -- grouping column
	 shipperid, -- spreading column
	 freight -- aggregation column
	 FROM Sales.Orders
	)
	SELECT *
	INTO Sales.FreightTotals
		FROM PivotData
		 PIVOT( SUM(freight) FOR shipperid IN ([1],[2],[3]) ) AS P;

		
	custid      1                     2                     3
	----------- --------------------- --------------------- ---------------------
	1           155,03                61,02                 69,53
	2           43,90                 NULL                  53,52
	3           63,09                 116,56                88,87
	4           41,95                 358,54                71,46
	5           189,44                1074,51               295,57
	6           0,15                  126,19                41,92
	7           217,96                215,70                190,00
	8           16,16                 175,01                NULL
	9           341,16                419,57                597,14
	10          129,42                162,17                502,36
	....
	
	Unpivot de tabelas sempre utiliza colunas fonte as transpõe en linhas, gerando 2 colunas de destino, sendo uma para manter os valores da coluna e outra para manter os nomes das colunas
	Para realizar a operação, é necessário:
	1. Nome da coluna para armazenar os nomes das colunas pivoteadas. 
	2. Nome da coluna para armazenar os valores das colunas pivoteadas.
	3. Conjunto de dados que está sendo transposto 
	Depois de identificar estes 3 elementos, deve-se utilizar a sintaxe a seguir:
	SELECT <column_list>, <names_column>, <values_column>
		FROM <source_table>
	UNPIVOT( <values_column> FOR <names_column> IN( <source_columns> ) ) AS U;
	
	Exemplo: 
	
	SELECT custid, shipperid, freight
	FROM Sales.FreightTotals
		UNPIVOT( freight FOR shipperid IN([1],[2],[3]) ) AS U;
		
		
	
	custid      shipperid   freight
	----------- ----------- ---------------------
	1           1           155,03
	1           2           61,02
	1           3           69,53
	2           1           43,90
	2           3           53,52
	3           1           63,09
	3           2           116,56
	3           3           88,87
	4           1           41,95
	4           2           358,54
	4           3           71,46
	5           1           189,44
	5           2           1074,51
	5           3           295,57
	6           1           0,15
	6           2           126,19
	6           3           41,92
	7           1           217,96
	7           2           215,70
	7           3           190,00

	NOTA - UNPIVOT E NULOS
	Além de tranpor os dados, o operador UNPIVOT filtra linhas com NULLs na coluna de valor (freight no exemplo).
	A suposição é que esses registros nulos representam casos inaplicáveis.
	Não houve escapatória de manter nulls na fonte se a coluna fosse aplicável a pelo menos um outro cliente.
	Mas depois de fazer UNPIVOT dos dados, não há razão para manter uma linha assim. 
	No entanto, se você quiser retornar estas linhas nulas, você precisa preparar uma expressão de tabela que trate os registros nulos através de ISNULL ou COALESCE, para em seguida substituir esses dados de volta para nulo usando a função NULLIF. 
	
	WITH C AS
	(
	 SELECT custid,
	 ISNULL([1], 0.00) AS [1],
	 ISNULL([2], 0.00) AS [2],
	 ISNULL([3], 0.00) AS [3]
	 FROM Sales.FreightTotals
	)
	SELECT custid, shipperid, NULLIF(freight, 0.00) AS freight
	FROM C
	 UNPIVOT( freight FOR shipperid IN([1],[2],[3]) ) AS U;
	custid      shipperid   freight
	----------- ----------- ---------------------
	1           1           155,03
	1           2           61,02
	1           3           69,53
	2           1           43,90
	2           2           NULL
	2           3           53,52
	3           1           63,09
	3           2           116,56
	3           3           88,87
	4           1           41,95
	4           2           358,54
	4           3           71,46
	5           1           189,44
	5           2           1074,51

	O campo que armezena os nomes das colunas transpostas é tipo Unicode, NVARCHAR(128). 
	Já os valores de colunas conservam os tipos da coluna transposta, por isso precisam ser do mesmo tipo. 
	Assim como o operador PIVOT, a lista de colunas transpostas da cláusula IN é estática (hard code). 
	Para deixar o processo dinâmico, é possível consultar os nomes das colunas da view sys.columns, construir a consulta com UNPIVOT e executar uma consulta de SQL dinâmico. 
	UNPIVOT é limitido a apenas uma medida. 
	Para tranpor várias medidas, é necessário recorrer a soluções alternativas, como as que se baiseiam no operador APPLY. 
	
	Maiores detalhes - PIVOT e UNPIVOT
	Para mais informações sobre o processamento lógico de  consultas com os operadores PIVOT e UNPIVOT, veja o artigo "Logical Query Processing: The FROM Clause and PIVOT", disponível em 
	https://www.itprotoday.com/sql-server/logical-query-processing-clause-and-pivot
	
	
	------------------------------------------------------------------------------------------------------
	Funções de janela (window functions)
	Assim como as funções de grupo, as funções de janela também permitem que você execute cálculos de análise de dados.	A diferença entre os dois está na forma como você define o conjunto de linhas para a função trabalhar. Com as funções do grupo, você usa consultas agrupadas para organizar as linhas consultadas em grupos e, em seguida, as funções do grupo são aplicadas a cada grupo. Você recebe uma linha de resultado por grupo — não por linha subjacente. 
	Com as funções da janela, você define o conjunto de linhas por função — e, em seguida, retorna um valor de resultado por linha e função subjacentes. Você define o conjunto de linhas para a função trabalhar usando uma cláusula chamada OVER.	
	
	
	Funções de janela com agregação
	São as mesmas funções aplicadas em agrupamentos (SUM, COUNT, AVG, MIN, MAX), porém o agrupamento a uma janela de linhas definidas pela cláusula OVER. 
	Um dos benefícios do uso de funções de janela é que, ao contrário de consultas agrupadas, consultas com janelas não escondem os detalhes — elas retornam uma linha para cada linha de consulta subjacente. Isso significa que você pode misturar detalhes e elementos agregados na mesma consulta, e até mesmo na mesma expressão.
	Usando a cláusula OVER, você define um conjunto de linhas para a função trabalhar com por linha subjacente. Em outras palavras, uma consulta com janelas define uma janela de linhas por função e linha na consulta subjacente.
	Como mencionado, você usa uma cláusula OVER para definir uma janela de linhas para a função. A janela é definida em relação à linha atual. Ao usar parênteses vazios, a cláusula OVER representa todo o conjunto de resultados da consulta subjacente. 
	Por exemplo, a expressão SUM(val) OVER() representa o grande total (grand total) de todas as linhas na consulta subjacente. Você pode usar uma cláusula de partição da janela para restringir a janela.
	
	SELECT custid, orderid, val,
		SUM(val) OVER(PARTITION BY custid) AS custtotal,
		SUM(val) OVER() AS grandtotal
	FROM Sales.OrderValues;
	
	custid 	orderid 	val 	custtotal 	grandtotal
	------- -------- 	------- ---------- -----------
	1 		10643 		814.50 	4273.00 	1265793.22
	1 		10692 		878.00 	4273.00 	1265793.22
	1 		10702 		330.00 	4273.00 	1265793.22
	1 		10835 		845.80 	4273.00 	1265793.22
	1 		10952 		471.20 	4273.00 	1265793.22
	1 		11011 		933.50 	4273.00 	1265793.22
	2 		10926 		514.40 	1402.95 	1265793.22
	2 		10759 		320.00 	1402.95 	1265793.22
	2 		10625 		479.75 	1402.95 	1265793.22
	2 		10308 		88.80 	1402.95 	1265793.22
	
	Você pode combinar elementos de agregrações de janela na mesma expressão
	custid 	orderid 	val 		pctcust 	pcttotal
	------- -------- 	------- 	-------- 	---------
	1 		10643 		814.50 		19.06 		0.06
	1 		10692 		878.00 		20.55 		0.07
	1 		10702 		330.00 		7.72 		0.03
	1 		10835 		845.80 		19.79 		0.07
	1 		10952 		471.20 		11.03 		0.04
	1 		11011 		933.50 		21.85 		0.07
	2 		10926 		514.40 		36.67 		0.04
	2 		10759 		320.00 		22.81 		0.03
	2 		10625 		479.75 		34.20 		0.04
	2 		10308 		88.80 		6.33 		0.01
	
	