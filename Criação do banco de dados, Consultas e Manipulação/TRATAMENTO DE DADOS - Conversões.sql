-- TIPOS DE CONVERSÃO ##############################################################
-- Operador ::
-- CAST

-- EXEMPLOS ########################################################################

-- (Exemplo 1) Conversão de texto em data
-- Corrija a query abaixo utilizando o operador ::
select '2021-10-01' - '2021-02-01'; -- essas datas estão no formato texto e serão tranformadas
								   -- em datas para efetuar o calculo.

select '2021-10-01'::date - '2021-02-01'::date; -- O "::date" transforma a data que está no formato de texto
												-- para o formato de data.
select '100'::numeric - '10'::numeric;						

-- (Exemplo 2) Conversão de texto em número
-- Corrija a query abaixo utilizando o operador ::
select '100' - '10'; -- os numeros estão em formato de texto

select '100'::int - '10'::int; -- com o operador os numeros que estão no formato de texto
								-- são tranformados em formato de numeros.

-- (Exemplo 3) Conversão de número em texto
-- Corrija a query abaixo utilizando o operador ::
select replace(112122,'1','A');

select replace(112122::text,'1','A');

-- (Exemplo 4) Conversão de texto em data
-- Corrija a query abaixo utilizando a função CAST
select '2021-10-01' - '2021-02-01';

select cast('2021-10-01' as date) - cast('2021-02-01'as date);

-- RESUMO ##########################################################################
-- (1) O operador :: e o CAST() são funções utilizadas para converter um dado para 
-- a unidade desejada. 
-- (2) O operador :: é mais "clean", porém, em algumas ocasiões não funciona, sendo
-- necessário utilizar a função CAST()
-- (3) Use o Guia de comandos para consultar a lista de unidades mais utilizadas

