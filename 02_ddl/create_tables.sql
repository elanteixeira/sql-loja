CREATE TABLE paises (
id_pais INT AUTO_INCREMENT PRIMARY KEY,
nome_pais VARCHAR(100) NOT NULL
);
CREATE TABLE clientes (
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(150) NOT NULL,
email VARCHAR(150) UNIQUE,
id_pais INT,
data_cadastro DATE,
FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
);
CREATE TABLE produtos (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
nome_produto VARCHAR(150),
categoria VARCHAR(100),
preco DECIMAL(10,2)
);
CREATE TABLE pedidos (
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
id_cliente INT,
data_pedido DATE,
status VARCHAR(50),
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
CREATE TABLE itens_pedido (
id_item INT AUTO_INCREMENT PRIMARY KEY,
id_pedido INT,
id_produto INT,
quantidade INT,
preco_unitario DECIMAL(10,2),
FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

SELECT pa.nome_pais,
SUM(ip.quantidade * ip.preco_unitario) AS faturamento
FROM paises pa
JOIN clientes c ON c.id_pais = pa.id_pais
JOIN pedidos p ON p.id_cliente = c.id_cliente
JOIN itens_pedido ip ON ip.id_pedido = p.id_pedido
GROUP BY pa.nome_pais
ORDER BY faturamento DESC;

WITH vendas_mensais AS (
SELECT DATE_FORMAT(p.data_pedido,'%Y-%m') AS mes,
SUM(ip.quantidade * ip.preco_unitario) AS total_mes
FROM pedidos p
JOIN itens_pedido ip ON ip.id_pedido = p.id_pedido
GROUP BY mes
)
SELECT mes,
total_mes,
SUM(total_mes) OVER (ORDER BY mes) AS acumulado
FROM vendas_mensais;
