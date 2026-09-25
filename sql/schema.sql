CREATE TABLE clientes (
    id_cliente          VARCHAR2(50)    NOT NULL,
    id_cliente_unico    VARCHAR2(50)    NOT NULL,
    cep_prefixo         VARCHAR2(10),
    cidade              VARCHAR2(100),
    estado              VARCHAR2(2),
    CONSTRAINT pk_clientes PRIMARY KEY (id_cliente)
);

CREATE TABLE vendedores (
    id_vendedor         VARCHAR2(50)    NOT NULL,
    cep_prefixo         VARCHAR2(10),
    cidade              VARCHAR2(100),
    estado              VARCHAR2(2),
    CONSTRAINT pk_vendedores PRIMARY KEY (id_vendedor)
);

CREATE TABLE produtos (
    id_produto          VARCHAR2(50)    NOT NULL,
    categoria           VARCHAR2(100),
    peso_gramas         NUMBER(10,2),
    comprimento_cm      NUMBER(10,2),
    altura_cm           NUMBER(10,2),
    largura_cm          NUMBER(10,2),
    CONSTRAINT pk_produtos PRIMARY KEY (id_produto)
);

CREATE TABLE pedidos (
    id_pedido                      VARCHAR2(50)    NOT NULL,
    id_cliente                     VARCHAR2(50)    NOT NULL,
    status_pedido                  VARCHAR2(30)    NOT NULL,
    data_compra                    DATE            NOT NULL,
    data_aprovacao                 DATE,
    data_entrega_transportadora    DATE,
    data_entrega_cliente           DATE,
    data_estimada_entrega          DATE,
    CONSTRAINT pk_pedidos PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedidos_cliente FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente),
    CONSTRAINT ck_pedidos_status CHECK (status_pedido IN (
        'criado', 'aprovado', 'faturado', 'enviado',
        'entregue', 'indisponivel', 'cancelado'
    ))
);

CREATE TABLE itens_pedido (
    id_pedido           VARCHAR2(50)    NOT NULL,
    numero_item         NUMBER(4)       NOT NULL,
    id_produto          VARCHAR2(50)    NOT NULL,
    id_vendedor         VARCHAR2(50)    NOT NULL,
    data_limite_envio   DATE,
    preco               NUMBER(10,2)    NOT NULL,
    valor_frete         NUMBER(10,2)    NOT NULL,
    CONSTRAINT pk_itens_pedido PRIMARY KEY (id_pedido, numero_item),
    CONSTRAINT fk_itens_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedidos (id_pedido),
    CONSTRAINT fk_itens_produto FOREIGN KEY (id_produto)
        REFERENCES produtos (id_produto),
    CONSTRAINT fk_itens_vendedor FOREIGN KEY (id_vendedor)
        REFERENCES vendedores (id_vendedor),
    CONSTRAINT ck_itens_preco CHECK (preco >= 0),
    CONSTRAINT ck_itens_frete CHECK (valor_frete >= 0)
);

CREATE TABLE pagamentos (
    id_pedido           VARCHAR2(50)    NOT NULL,
    sequencial          NUMBER(4)       NOT NULL,
    tipo_pagamento      VARCHAR2(30)    NOT NULL,
    parcelas            NUMBER(3)       DEFAULT 1,
    valor               NUMBER(10,2)    NOT NULL,
    CONSTRAINT pk_pagamentos PRIMARY KEY (id_pedido, sequencial),
    CONSTRAINT fk_pagamentos_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedidos (id_pedido),
    CONSTRAINT ck_pagamentos_valor CHECK (valor >= 0),
    CONSTRAINT ck_pagamentos_parcelas CHECK (parcelas >= 1)
);

CREATE TABLE avaliacoes (
    id_avaliacao        VARCHAR2(50)    NOT NULL,
    id_pedido           VARCHAR2(50)    NOT NULL,
    nota                NUMBER(1)       NOT NULL,
    comentario_titulo   VARCHAR2(200),
    comentario_texto    VARCHAR2(2000),
    data_criacao        DATE            NOT NULL,
    data_resposta       DATE,
    CONSTRAINT pk_avaliacoes PRIMARY KEY (id_avaliacao),
    CONSTRAINT fk_avaliacoes_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedidos (id_pedido),
    CONSTRAINT ck_avaliacoes_nota CHECK (nota BETWEEN 1 AND 5)
);

CREATE INDEX idx_pedidos_data_compra ON pedidos (data_compra);
CREATE INDEX idx_clientes_estado ON clientes (estado);
CREATE INDEX idx_produtos_categoria ON produtos (categoria);
CREATE INDEX idx_avaliacoes_nota ON avaliacoes (nota);
