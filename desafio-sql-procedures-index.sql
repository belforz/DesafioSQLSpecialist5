use company_constraints;
-- O que será levado em consideração para criação dos índices? 
-- Quais os dados mais acessados 
-- Quais os dados mais relevantes no contexto

-- Dentro do contexto compaan, é necessário que os dados amrzenados dentro de employee como SSN estejam alinhados
-- a um index geral para sua busca mais sucinta e otomizada. Entre os dados mais relavantes, são tuplas como salário, a tabela dependent
-- department.
ALTER TABLE employee ADD UNIQUE INDEX(SSN);
-- Aliar o SSN como valor unico e sendo um index para pesquisa ser automizada.

ALTER TABLE departament add index (dnumber);
-- FAZER o numero ser pesquisado mais rápido.


-- Qual o departamento com maior número de pessoas? 
SELECT d.Dnumber AS Dept_Number, d.Dname AS Department_Name, COUNT(e.Dno) AS Employee_Count
FROM departament d
INNER JOIN Employee e ON d.Dnumber = e.Dno
GROUP BY d.Dnumber, d.Dname
ORDER BY Employee_Count DESC
LIMIT 1;

-- Quais são os departamentos por cidade? 

SELECT d.Dname as Department_name, dd.Dlocation as name_location 
FROM departament d 
INNER JOIN dept_locations dd ON d.Dnumber = dd.Dnumber;


-- Relação de empregrados por departamento 

SELECT d.Dnumber AS Dept_Number, d.Dname AS Department_Name, COUNT(e.Dno) AS Employee_Count
FROM departament d
INNER JOIN Employee e ON d.Dnumber = e.Dno
GROUP BY d.Dnumber, d.Dname
ORDER BY Employee_Count DESC;

-- PARTE II

use ecommerce;

drop procedure CRUDProcedure;
DELIMITER //
CREATE PROCEDURE CRUDProcedure(IN action INT, IN new_Fname varchar(30), IN new_idClient int)
BEGIN
    -- Variável de controle para determinar a ação a ser executada
    DECLARE action_type VARCHAR(10);

    -- Definindo ação com base na variável de controle
    CASE action
        WHEN 1 THEN SET action_type = 'SELECT';
        WHEN 2 THEN SET action_type = 'UPDATE';
        WHEN 3 THEN SET action_type = 'DELETE';
        ELSE SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid action value. Please use 1 for SELECT, 2 for UPDATE, or 3 for DELETE.';
    END CASE;

    -- Executando a ação selecionada
    CASE action_type
        WHEN 'SELECT' THEN
            SELECT * FROM clients; 

        WHEN 'UPDATE' THEN
            UPDATE clients 
            SET Fname = new_Fname
            WHERE idClient = new_idClient;

        WHEN 'DELETE' THEN
            DELETE FROM clients 
            WHERE idClient = new_idClient;

        ELSE SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid action type. Please use SELECT, UPDATE, or DELETE.';
    END CASE;
END;
//

DELIMITER ;

CALL CRUDProcedure(1, NULL, NULL);
CALL CRUDProcedure(2,'Marcos',1);
CALL CRUDProcedure (2,'Juliana',2);
CALL CRUDProcedure (2,'Gustavo',3);
CALL CRUDProcedure(2,'Fabricio',4);
CALL CRUDProcedure (2,'Mariana',5);
CALL CRUDProcedure (2,'Juliano',6);
CALL CRUDProcedure (2,'Mariozinho',7);
CALL CRUDProcedure (2,'Gaia',8);
CALL CRUDProcedure(2,'Terra',9);
CALL CRUDProcedure(2,'Leandro',10);
CALL CRUDProcedure(2,'13 Management',11);
CALL CRUDProcedure(2,'Amazon S&a',12);
CALL CRUDProcedure(2,'Warner Bros',13);
CALL CRUDProcedure(2,'Disney',14);
CALL CRUDProcedure(2,'Oficina do Carlao',15);
CALL CRUDProcedure(2,'ETEC',16);
CALL CRUDProcedure(2,'FATEC',17);
CALL CRUDProcedure(2,'USP',18);
CALL CRUDProcedure(2,'Universidade',19);
CALL CRUDProcedure(2,'Maria Salgados',20);
CALL CRUDProcedure(3,'NULL',11);
-- Não irá excluir devido a FK_Constraint da tabela filha, não possui o DELETE CASCADE.









