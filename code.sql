USE hospital_db;

-- 1. Farmácia: Relatório completo de prescrições
SELECT 
    p.nome_paciente,
    m.nome_medico,
    c.data_consulta,
    pr.medicamento,
    pr.quantidade
FROM prescricoes pr
JOIN consultas c ON pr.id_consulta = c.id_consulta
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico;

-- 2. Auditoria: Histórico de internações com quarto, andar e diária
SELECT 
    p.nome_paciente,
    q.numero_quarto,
    q.andar,
    i.data_entrada,
    i.valor_diaria
FROM internacoes i
JOIN pacientes p ON i.id_paciente = p.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto;

-- 3. Recepção: Listagem de pacientes, convênios, médicos e especialidades
SELECT 
    p.nome_paciente,
    p.convenio,
    m.nome_medico,
    m.especialidade
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico;

-- 4. Coordenação Médica: Prescrições emitidas por médico, paciente e remédio (CORRIGIDO: adicionado JOIN pacientes)
SELECT 
    m.nome_medico,
    m.especialidade,
    p.nome_paciente,
    pr.medicamento
FROM prescricoes pr
JOIN consultas c ON pr.id_consulta = c.id_consulta
JOIN medicos m ON c.id_medico = m.id_medico
JOIN pacientes p ON c.id_paciente = p.id_paciente;

-- 5. Diretoria Médica: Pacientes que já foram internados e também consultaram (Sem duplicidades)
SELECT DISTINCT
    p.nome_paciente,
    q.numero_quarto,
    m.nome_medico,
    c.data_consulta
FROM pacientes p
JOIN internacoes i ON p.id_paciente = i.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto
JOIN consultas c ON p.id_paciente = c.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico;

-- 6. Atendimentos ordenados do mais recente para o mais antigo
SELECT 
    p.nome_paciente,
    m.nome_medico,
    c.data_consulta
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico
ORDER BY c.data_consulta DESC;

-- 7. Setor Financeiro: Diárias de internação ordenadas do menor para o maior valor
SELECT 
    p.nome_paciente,
    q.numero_quarto,
    i.valor_diaria
FROM internacoes i
JOIN pacientes p ON i.id_paciente = p.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto
ORDER BY i.valor_diaria ASC;

-- 8. Valor médio praticado nas consultas médicas
SELECT 
    AVG(valor_consulta) AS valor_medio_consultas
FROM consultas;

-- 9. Faturamento total acumulado exclusivamente com consultas
SELECT 
    SUM(valor_consulta) AS total_arrecadado_consultas
FROM consultas;

-- 10. Consultas realizadas por pacientes da família "Silva" (CORRIGIDO: adicionado JOIN pacientes)
SELECT 
    p.nome_paciente,
    m.nome_medico,
    c.data_consulta
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico
WHERE p.nome_paciente LIKE '%Silva%';

-- 11. Consultas com médicos da área de Cardiologia
SELECT 
    p.nome_paciente,
    m.nome_medico,
    m.especialidade
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade LIKE '%Cardio%';

-- 12. Internações ocorridas no 1º semestre de 2026 (01/01/2026 a 30/06/2026)
SELECT 
    p.nome_paciente,
    q.numero_quarto,
    i.data_entrada
FROM internacoes i
JOIN pacientes p ON i.id_paciente = p.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto
WHERE i.data_entrada BETWEEN '2026-01-01' AND '2026-06-30';

-- 13. Receita total em consultas agrupada por pacientes do plano "Unimed"
SELECT 
    p.nome_paciente,
    p.convenio,
    SUM(c.valor_consulta) AS total_investido
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE p.convenio LIKE '%Unimed%'
GROUP BY p.id_paciente, p.nome_paciente, p.convenio
ORDER BY total_investido DESC;

-- 14. Custo total de diárias agrupado por andar para pacientes com sobrenome "Oliveira"
SELECT 
    q.andar,
    SUM(i.valor_diaria) AS custo_total_diarias
FROM internacoes i
JOIN pacientes p ON i.id_paciente = p.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto
WHERE p.nome_paciente LIKE '%Oliveira%'
GROUP BY q.andar
ORDER BY q.andar ASC;

-- 15. Faturamento total em consultas por especialidades do departamento de Cirurgia
SELECT 
    m.especialidade,
    SUM(c.valor_consulta) AS faturamento_total
FROM consultas c
JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade LIKE '%Cirurgia%'
GROUP BY m.especialidade
ORDER BY faturamento_total DESC;
