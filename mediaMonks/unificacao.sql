-- Renomeando as colunas pois foram exportadas sem seus nomes corretos
ALTER TABLE fixed_database_1
	RENAME COLUMN c1 TO data;
ALTER TABLE fixed_database_1
	RENAME COLUMN c2 TO id_marca;
ALTER TABLE fixed_database_1
	RENAME COLUMN c3 TO vendas;
ALTER TABLE fixed_database_1
	RENAME COLUMN c4 TO valor_veiculo;
ALTER TABLE fixed_database_1
	RENAME COLUMN c5 TO nome;
	
ALTER TABLE fixed_database_2
	RENAME COLUMN c1 to id_marca;
ALTER TABLE fixed_database_2
	RENAME column c2 to marca;
	
-- Criando uma tabela relatório com a junção das duas tabelas e adcionando uma coluna 'receita'
CREATE TABLE tabela_unificada AS
	SELECT m.id_marca, m.marca, v.data, v.vendas, v.valor_do_veiculo, v.nome
	FROM fixed_database_2 AS m
	RIGHT JOIN fixed_database_1 AS v ON v.id_marca = m.id_marca;
	
ALTER TABLE tabela_unificada
ADD COLUMN receita REAL;

UPDATE tabela_unificada
SET receita = valor_do_veiculo * vendas;

-- Querys para ajudar no relatório
-- 1. Qual marca teve o maior volume de vendas?
SELECT marca, SUM(vendas) AS total_vendas 
	FROM tabela_unificada
	GROUP BY marca
    ORDER BY total_vendas DESC
	LIMIT 5; -- Resultado: 1-Fiat, 433 vendas
	

	
-- 2. Qual veículo gerou a maior e menor receita?
SELECT CONCAT(marca,' ',nome) AS modelo, SUM(receita) AS receita_total
    FROM tabela_unificada
    GROUP BY nome
    ORDER BY receita_total DESC
    LIMIT 10; -- Maior
	
SELECT CONCAT(marca,' ',nome) AS modelo, SUM(receita) AS receita_total
    FROM tabela_unificada
    GROUP BY nome
    ORDER BY receita_total ASC
    LIMIT 10;-- Menor
        
-- 3. Qual a média de vendas do ano por marca?
SELECT marca, SUBSTR(data, 1, 4) AS ano, ROUND(AVG(vendas),2) AS media_vendas_por_marca_e_ano
  	FROM tabela_unificada
  	GROUP BY marca, ano;
	
-- 4. Quais marcas geraram uma receita maior com número menor de vendas?
SELECT marca, SUM(vendas) AS total_de_vendas, SUM(receita) AS total_de_receita
    FROM tabela_unificada
    GROUP BY marca
    ORDER BY total_de_receita / total_de_vendas DESC; -- Divisao para ser em proporcao

-- 5. Existe alguma relação entre os veículos mais vendidos?
SELECT CONCAT(marca,' ',nome) AS modelo, SUM(vendas) AS total_de_vendas, ROUND(AVG(valor_do_veiculo),2) as media_preco
	FROM tabela_unificada
	GROUP BY nome
	ORDER BY total_de_vendas DESC
	LIMIT 5;
