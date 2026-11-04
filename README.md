# Boas_Pr-ticas_em_DDL.sql

# 🏥 Sistema de Gestão Hospitalar "Vida & Saúde"

> **Projeto Prático de Banco de Dados Relacional** — Solução centralizada desenvolvida para substituir sistemas legados em planilhas e registros físicos, mitigando falhas operacionais, perdas de históricos clínicos e sobreposição de agendas.

---

## 📋 Sumário
- [1. Contextualização e Desafio](#1-contextualização-e-desafio)
- [2. Arquitetura do Banco de Dados](#2-arquitetura-do-banco-de-dados)
- [3. Estrutura do Repositório](#3-estrutura-do-repositório)
- [4. Instruções de Instalação e Execução](#4-instruções-de-instalação-e-execução)
- [5. Dicionário de Dados](#5-dicionário-de-dados)
- [6. Relatório de Queries Estratégicas (DQL)](#6-relatório-de-queries-estratégicas-dql)
- [7. Regras de Integridade e Regra de Negócio](#7-regras-de-integridade-e-regra-de-negócio)

---

## 1. Contextualização e Desafio

O **Hospital Geral Vida & Saúde** enfrentou um colapso operacional no último trimestre devido ao uso de planilhas isoladas e controle em papel:
* 📉 **15% dos atendimentos** geraram cobranças incorretas.
* 📂 **Perda de 8%** do histórico clínico de pacientes crônicos.
* 📅 **45 consultas canceladas** em uma semana por sobreposição de agenda médica.

### Objetivo
Projetar, normalizar (até a **3ª Forma Normal - 3FN**) e implementar o Banco de Dados Relacional em ambiente MySQL Workbench para garantir integridade referencial, consultas em tempo real e prevenção de falhas operacionais.

---

## 2. Arquitetura do Banco de Dados

O modelo relacional foi desenhado para eliminar redundâncias e garantir dependência funcional total das chaves primárias:
