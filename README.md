[readme_md.md](https://github.com/user-attachments/files/34374665/readme_md.md)
# 🏥 Sistema de Gestão Hospitalar — Vida & Saúde

![MySQL](https://img.shields.io/badge/Database-MySQL%208.0-blue?style=for-the-badge&logo=mysql)
![License](https://img.shields.io/badge/Status-Homologated-brightgreen?style=for-the-badge)
![Normalization](https://img.shields.io/badge/Architecture-3FN-orange?style=for-the-badge)

> **Solução de Banco de Dados Relacional** projetada para centralizar a infraestrutura digital do Hospital Geral Vida & Saúde, eliminando erros de cobrança, perdas de prontuários clínicos e conflitos de agendamento.

---

## 📌 Sumário
- [1. Visão Geral e Problema de Negócio](#1-visão-geral-e-problema-de-negócio)
- [2. Arquitetura do Banco & Modelagem (3FN)](#2-arquitetura-do-banco--modelagem-3fn)
- [3. Dicionário de Dados](#3-dicionário-de-dados)
- [4. Estrutura do Projeto](#4-estrutura-do-projeto)
- [5. Como Executar o Projeto](#5-como-executar-o-projeto)
- [6. Mapeamento das Queries Estratégicas (DQL)](#6-mapeamento-das-queries-estratégicas-dql)
- [7. Políticas de Integridade Referencial](#7-políticas-de-integridade-referencial)

---

## 1. Visão Geral e Problema de Negócio

No último trimestre, a operação legada via planilhas e papel gerou impactos críticos no hospital:
* 🔴 **15% de cobranças incorretas** identificadas pela auditoria.
* 🔴 **8% de perda de históricos clínicos** de pacientes crônicos.
* 🔴 **45 consultas canceladas** em uma semana por sobreposição de agenda médica.

### 🎯 Objetivo do Projeto
Estruturar o banco de dados relacional em **MySQL Workbench** até a **3ª Forma Normal (3FN)** para assegurar controle de leitos/agendas, integridade de dados e tomada de decisão gerencial em tempo real.

---

## 2. Arquitetura do Banco & Modelagem (3FN)

O esquema foi projetado garantindo que cada atributo não-chave dependa única e exclusivamente da chave primária de sua respectiva tabela.

```text
  ┌─────────────┐            ┌─────────────┐            ┌─────────────┐
  │  pacientes  │───(1:N)───<│  consultas  │>───(N:1)───│   medicos   │
  └─────────────┘            └─────────────┘            └─────────────┘
         │                          │
       (1:N)                      (1:N)
         │                          │
         ▼                          ▼
  ┌─────────────┐            ┌─────────────┐
  │ internacoes │            │ prescricoes │
  └─────────────┘            └─────────────┘
         │
       (N:1)
         ▼
  ┌─────────────┐
  │   quartos   │
  └─────────────┘
```

---

## 3. Dicionário de Dados

| Tabela | Coluna | Tipo | Restrições | Descrição |
| :--- | :--- | :--- | :--- | :--- |
| **`pacientes`** | `id_paciente` | `INT` | `PK, AUTO_INCREMENT` | Identificador único do paciente |
| | `cpf` | `VARCHAR(14)` | `UNIQUE, NOT NULL` | CPF formatado |
| | `convenio` | `VARCHAR(50)` | `NOT NULL` | Plano de saúde contratado |
| **`medicos`** | `id_medico` | `INT` | `PK, AUTO_INCREMENT` | Identificador único do médico |
| | `crm` | `VARCHAR(20)` | `UNIQUE, NOT NULL` | Inscrição no conselho profissional |
| **`quartos`** | `numero_quarto` | `INT` | `UNIQUE, NOT NULL` | Número físico do leito/quarto |
| | `status_quarto` | `VARCHAR(20)` | `DEFAULT 'Livre'` | Situação ocupacional do quarto |
| **`internacoes`** | `id_paciente` | `INT` | `FK (pacientes)` | Relacionamento com o paciente |
| | `id_quarto` | `INT` | `FK (quartos)` | Leito reservado para a internação |
| **`consultas`** | `data_consulta` | `DATETIME` | `NOT NULL` | Data e horário do atendimento |
| **`prescricoes`**| `id_consulta` | `INT` | `FK (consultas)` | Consulta à qual a receita pertence |

---

## 4. Estrutura do Projeto

```text
hospital-vida-e-saude/
├── README.md                  # Documentação do projeto
├── database/
│   ├── 01_ddl_schema.sql      # Criação do banco, tabelas e constraints
│   ├── 02_dml_inserts.sql     # Carga de teste (mínimo 10 registros por tabela)
│   └── 03_dql_queries.sql     # As 15 consultas de negócio
└── docs/
    └── mer_diagram.png        # Modelo ER gerado via Reverse Engineer
```

---

## 5. Como Executar o Projeto

### Pré-requisitos
* [MySQL Community Server 8.0+](https://dev.mysql.com/downloads/mysql/)
* [MySQL Workbench](https://dev.mysql.com/downloads/workbench/)

### Execução Sequencial

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/hospital-vida-e-saude.git
   cd hospital-vida-e-saude
   ```

2. **Execute os scripts no MySQL Workbench (nesta ordem):**
   * **Passo 1:** `database/01_ddl_schema.sql` (Cria a base `hospital_db` e as 6 tabelas).
   * **Passo 2:** `database/02_dml_inserts.sql` (Insere a massa de dados inicial).
   * **Passo 3:** `database/03_dql_queries.sql` (Executa os relatórios estratégicos).

---

## 6. Mapeamento das Queries Estratégicas (DQL)

As 15 perguntas operacionais solicitadas pela diretoria e auditores foram respondidas utilizando técnicas avançadas de SQL (`JOIN`, `GROUP BY`, `HAVING`, `LIKE` e `AGGREGATE FUNCTIONS`).

<details>
<summary>🔍 Clique para ver o resumo das 15 consultas de negócio</summary>

1. **Farmácia:** Emissão de receitas por paciente, médico, data e quantidade medicada.
2. **Auditoria:** Histórico de internações com número do quarto, andar e diária.
3. **Recepção:** Relação de pacientes, convênios, médicos atendedores e especialidades.
4. **Coordenação Médica:** Prescrições emitidas filtradas por médico e paciente.
5. **Diretoria Médica:** Pacientes que consultaram e também estiveram internados (`DISTINCT`).
6. **Agendamentos:** Histórico de consultas por ordem cronológica decrescente.
7. **Financeiro (Diárias):** Mapeamento do custo de internações ordenado do menor ao maior.
8. **Média de Consultas:** Cálculo do valor médio praticado (`AVG`).
9. **Faturamento Total:** Soma da receita bruta de consultas (`SUM`).
10. **Filtro Família Silva:** Identificação de atendimentos da família "Silva" (`LIKE`).
11. **Especialidade Cardiologia:** Consultas conduzidas por cardiologistas (`LIKE`).
12. **Relatório Semestral:** Internações ocorridas no 1º Semestre de 2026 (`BETWEEN`).
13. **Receita Unimed:** Faturamento total por paciente do convênio Unimed (`GROUP BY`).
14. **Custo por Andar:** Soma das diárias por andar para pacientes com sobrenome "Oliveira".
15. **Faturamento Cirúrgico:** Total arrecadado agrupado por especialidades da ala de Cirurgia.

</details>

---

## 7. Políticas de Integridade Referencial

* **`ON DELETE RESTRICT` (Segurança Primária):** Aplicado nas tabelas `pacientes`, `medicos` e `quartos`. Impede que registros mestres sejam deletados caso possuam histórico de consultas ou internações associadas.
* **`ON DELETE CASCADE` (Manutenção Operacional):** Aplicado à tabela `prescricoes`, garantindo que, se uma consulta for cancelada, suas prescrições correspondentes sejam limpas automaticamente.
