-- TIPOS ###########################################################################
-- INTERVAL
-- DATE_TRUNC
-- EXTRACT
-- DATEDIFF


-- EXEMPLOS ########################################################################

-- (Exemplo 1) Soma de datas utilizando INTERVAL
-- Calcule a data de hoje mais 10 unidades (dias, semanas, meses, horas)
select current_date; -- data atual

select current_date + 10; -- data atual mais a soma p/ 10 dias

select current_date + interval '10 weeks';-- data atual para a soma de 10 semanas.Data e hora

select (current_date + interval '10 weeks')::date; -- Só data.

select (current_date + interval '10 months')::date;

select current_date + interval '10 hours';

select ('10-03-2025'::date + interval '10 months')::date;

-- (Exemplo 2) Truncagem de datas utilizando DATE_TRUNC
-- Calcule quantas visitas ocorreram por mês no site da empresa

select visit_page_date, count(*)
from sales.funnel
group by visit_page_date
order by visit_page_date desc;

select visit_page_date,
date_trunc('month', visit_page_date)::date
from sales.funnel;

SELECT date_trunc('month', visit_page_date)::date as mes,
count(*)
FROM sales.funnel
group by mes
order by mes;

-- (Exemplo 3) Extração de unidades de uma data utilizando EXTRACT
-- Calcule qual é o dia da semana que mais recebe visitas ao site

select
	'2022-01-30'::date;

select
	extract('dow' from visit_page_date) as dia_da_semana,
	count(*)
from sales.funnel
group by dia_da_semana
order by dia_da_semana; -- 'dow' é para extrair o dia da semana. O nº 0 representa o domingo.



-- (Exemplo 4) Diferença entre datas com operador de subtração (-) 
-- Calcule a diferença entre hoje e '2018-06-01', em dias, semanas, meses e anos.
select (current_date - '2018-06-01');--Dias
select (current_date - '2018-06-01')/7;--Semanas
select (current_date - '2018-06-01')/30;--Mês
select (current_date - '2018-06-01')/365;--Anos

-- RESUMO --------------------------------------------------------------------------
-- (1) O comando INTERVAL é utilizado para somar datas na unidade desejada. Caso a 
-- unidade não seja informada, o SQL irá entender que a soma foi feita em dias.
-- (2) O comando DATE_TRUNC é utilizado para truncar uma data no início do período
-- (3) O comando EXTRACT é utilizado para extrair unidades de uma data/timestamp
-- (4) O cálculo da diferença entre datas com o operador de subtração (-) retorna  
-- valores em dias. Para calcular a diferença entre datas em outra unidade é necessário
-- fazer uma transformação de unidades (ou criar uma função para isso)
-- (5) Utilize o Guia de comandos para consultar as unidades de data e hora utilizadas 
-- no SQL

