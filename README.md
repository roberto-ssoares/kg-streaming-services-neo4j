# Knowledge Graph – Serviço de Streaming (Neo4j)

## Modelagem de Dados em Grafos | Projeto de Portfólio

- Este repositório contém a modelagem completa de um Grafo de Conhecimento (Knowledge Graph) para um serviço de streaming, aplicado no contexto do curso Modelagem de Dados em Grafos de um Serviço de Streaming.

- A solução foi construída utilizando Neo4j e representa relações entre usuários, filmes, séries, gêneros, atores e diretores, permitindo análises avançadas de recomendação, navegação semântica e estudos de padrões de consumo.

### 📚 Objetivo do Projeto

- Modelar um grafo funcional que represente:
- Usuários e seu histórico de visualização
- Filmes e séries com suas propriedades
- Atores e diretores, com relacionamentos semânticos
- Gêneros e classificação de conteúdo
- Estrutura navegável para recomendações e consultas analíticas

O projeto demonstra domínio prático de:

- Modelagem de grafos
- Modelagem de domínio
- Relacionamentos semânticos
- Criação de constraints
- Cypher Query Language (CQL)
- Boas práticas de organização em KG

### 📁 Conteúdo do Repositório


```
├── cypher/
│   └── streaming_kg_full.cql        # Script Cypher completo
│
├── img/
│   └── schema-kg-streaming.png      # Print do schema do Neo4j
│
└── README.md                        # Documentação do projeto
```

### 🧠 Conceitos Aplicados

#### 1. Entidades Modeladas
  - User
  - Movie
  - Serie
  - Actor
  - Director
  - Genre

#### 2. Relacionamentos

  - WATCHED – usuário consumiu um conteúdo
  - IN_GENRE – filmes/séries pertencem a gêneros
  - ACTED_IN – ator participou de filme/série
  - DIRECTED – diretor dirigiu o conteúdo

Cada relacionamento foi enriquecido com propriedades quando necessário, por exemplo:

``` cypher
 (:Actor)-[:ACTED_IN {character: "...", protagonist: true}]->(:Movie)
``` 

##### ⚙️ Como Executar o Projeto

  - 1. Abra o Neo4j Browser ou Neo4j Desktop
  - 2. Crie um banco de dados vazio
  - 3. Copie o conteúdo do arquivo:

``` cypher
cypher/streaming_kg_full.cql
``` 

#### 4. Cole e execute no Neo4j Browser

O script irá:
- Criar todos os constraints
- Inserir gêneros, usuários, filmes, séries
- Criar atores e diretores reais
- Construir relacionamentos semânticos
- Popular histórico de visualizações com regras dinâmicas

### 🔍 Consultas de Exemplo

- Filmes assistidos pelo usuário 1 (Roberto)
``` cypher
MATCH (u:User {userId:1})-[:WATCHED]->(c)
RETURN u.name, labels(c), c.name;
```

- Protagonistas de séries de ficção científica
``` cypher
MATCH (a:Actor)-[r:ACTED_IN {protagonist:true}]->(s:Serie)-[:IN_GENRE]->(g:Genre {name:'Science Fiction'})
RETURN a.name, s.name, r.character;
```

- Schema do grafo
``` cypher
CALL db.schema.visualization();
```

### 🏆 Resultados

O grafo final criado demonstra:
- Um modelo robusto
- Navegação clara e intuitiva
- Potencial real para sistemas de recomendação
- Estrutura excelente para portfólio e entrevistas

### 📌 Tecnologias Utilizadas

- Neo4j Aura / Desktop / Browser
- Cypher Query Language
- Desenho de modelo conceitual (Excalidraw / DIO)

## 👤 Autor

- Projeto desenvolvido por Roberto dos Santos Soares como parte do módulo de Modelagem em Grafos de Streaming.

### 📎 Licença

- Este repositório está disponível para fins educacionais e de portfólio.
