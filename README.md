# 🛍️ Projeto de Vendas 2023–2025  
**Análise de Dados, SQL, Power BI e Ciência de Dados**

Este repositório apresenta um pipeline completo de **análise e modelagem de dados de vendas**.  
Abrange desde consultas SQL e análises exploratórias em Python, até dashboards interativos em Power BI e modelos de Ciência de Dados para **segmentação de clientes** e **previsão de faturamento**.

---

## 📑 Sumário
- [Visão Geral](#-visão-geral)
- [Arquitetura do Projeto](#-arquitetura-do-projeto)
- [Conjunto de Dados](#-conjunto-de-dados)
- [Principais Insights](#-principais-insights)
- [Pipeline](#-pipeline)
- [Resultados de Ciência de Dados](#-resultados-de-ciência-de-dados)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Como Reproduzir](#-como-reproduzir)
- [Próximos Passos](#-próximos-passos)
- [Autor](#-autor)

---

## 💡 Visão Geral
Empresas que trabalham com grandes volumes de vendas precisam de **inteligência baseada em dados**  
para direcionar estratégias comerciais, otimizar estoques e personalizar campanhas.  
Este projeto demonstra como aplicar **Data Analytics e Data Science** para:
- **Analisar** padrões de vendas e comportamento de clientes.
- **Visualizar** indicadores críticos em dashboards interativos.
- **Prever** demanda futura para planejamento de estoque e marketing.
- **Segmentar** clientes em grupos para ações personalizadas.

---

## 🏗 Arquitetura do Projeto

```
projeto-vendas/
│
├─ data/
│   ├─ clientes.csv
│   ├─ itens_venda.csv
│   ├─ produtos.csv
│   ├─ vendas_2023_2025.csv
│   ├─ clientes_clusters.csv       # Resultado do clustering RFM
│   └─ previsao_vendas.csv         # Previsão de vendas (6 meses)
│
├─ notebooks/│              
│   └─ Analises_Python.ipynb      # EDA e visualizações iniciais
│
├─ models/
│   └─ ciencia_dados_insights.ipynb # Segmentação, previsão e anomalias
│
├─ sql/
│   ├─ consultas_analise.sql       # Queries para KPIs e views
│   ├─ salvando_dados.sql          # Exportação de tabelas
│   └─ verificacao_tabelas.sql     # Checagem de estrutura e views
│
├─ powerbi/
│   └─ vendas_2.pbix               # Dashboard interativo completo
│
├─ README.md
└─ requirements.txt
```

---

## 📂 Conjunto de Dados
Dados contendo:
- **Clientes**: informações demográficas e de cadastro.
- **Produtos**: categorias, preço e custo.
- **Vendas**: histórico 2023–2025, incluindo itens de cada venda.

---

## 🔎 Principais Insights

### Vendas e Sazonalidade
- Evolução mensal e trimestral com picos em datas festivas.
- Ticket médio e variação percentual mês a mês.

### Top Produtos e Clientes
- Ranking de produtos e clientes mais rentáveis.
- Relação volume x faturamento.

### Margens e Rentabilidade
- Margem de lucro por produto e por categoria.
- Identificação de produtos com maior e menor rentabilidade.

### Geografia e Comportamento
- Distribuição de vendas por estado e cidade.
- Frequência de compra, clientes inativos e valor de ciclo de vida (LTV).

---

## 🔬 Pipeline

1. **SQL**  
   - Criação de tabelas e views otimizadas.
   - Métricas de vendas, margens e comportamento.

2. **Python**  
   - **Exploração e Visualização**: notebooks em `notebooks/` com pandas, seaborn, matplotlib e plotly.
   - **Ciência de Dados**: notebook `models/ciencia_dados_insights.ipynb`:
     - Segmentação de clientes (RFM + K-Means).
     - Previsão de vendas (Holt-Winters).
     - Detecção de anomalias (IsolationForest).

3. **Power BI**  
   - Dashboard com páginas de Resumo, Vendas, Geografia, Top Produtos/Clientes, Segmentação RFM e Previsão de Vendas.

---

## 📈 Resultados de Ciência de Dados

| Cluster    | Descrição                        | % Clientes |
|------------|----------------------------------|------------|
| VIP        | Alta frequência e alto gasto     | 20%        |
| Loyal      | Fiéis, ticket médio consistente  | 35%        |
| Occasional | Compram esporadicamente          | 30%        |
| At Risk    | Em risco de churn                | 15%        |

**Previsão de Vendas (Próximos 6 meses):**
- Crescimento esperado de aproximadamente **12%**, considerando sazonalidade histórica.

---

## 🛠 Tecnologias Utilizadas
- **Python 3.x**  
  `pandas`, `numpy`, `matplotlib`, `seaborn`, `plotly`,  
  `scikit-learn`, `statsmodels`, `jupyter`
- **Banco de Dados**: PostgreSQL
- **Visualização**: Power BI

---

## ⚙️ Como Reproduzir
1. Clone este repositório:
   ```bash
   git clone https://github.com/sidneysantosdatascientist/analise_de_vendas
   cd projeto-vendas
   ```

2. Crie um ambiente virtual e instale as dependências:
   ```bash
   python -m venv venv
   source venv/bin/activate   # Linux/Mac
   venv\Scriptsctivate      # Windows
   pip install -r requirements.txt
   ```

3. Configure o banco de dados PostgreSQL e rode as queries SQL da pasta `sql/`.

4. Explore os notebooks em `notebooks/` e `models/`.

5. Abra o dashboard em `powerbi/vendas.pbix`.

---

##  Próximos Passos
- Implementar API para disponibilizar previsões em tempo real.  
- Testar modelos adicionais de previsão (XGBoost, Prophet).  
- Expandir análise para outros canais de vendas (e-commerce, marketplace).  

---

## 👤 Autor
**Sidney Pereira Santos**  
 Rio de Janeiro, RJ  
 [sidneysantosdatascientist@gmail.com](mailto:sidneysantosdatascientist@gmail.com)  
 [LinkedIn](https://www.linkedin.com/in/sidney-santos-analista-de-dados/)  
