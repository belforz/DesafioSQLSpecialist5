use company_constraints;
-- Número de empregados por departamento e localidade 

CREATE VIEW employee_dept_v as 
SELECT d.Dnumber AS Dept_Number, d.Dname AS Department_Name, COUNT(e.Dno) AS Employee_Count, COUNT(dd.Dlocation) as Location_Counter,
dd.Dlocation as Dept_Location_name 
FROM departament d
INNER JOIN Employee e ON d.Dnumber = e.Dno
INNER JOIN dept_locations dd On d.Dnumber = dd.Dnumber
GROUP BY d.Dnumber, d.Dname, dd.Dlocation
ORDER BY Employee_Count DESC;

select * from employee_dept_v;

-- Lista de departamentos e seus gerentes 
CREATE VIEW employee_dept_managerv as 
SELECT COUNT(d.Dnumber) AS Dept_Count,d.Dname as Dept_Name, COUNT(d.Mgr_ssn) as Manager_Count,e.ssn as manager_id
FROM departament d
INNER JOIN Employee e ON d.Dnumber = e.Dno
GROUP BY d.Dnumber, d.Dname, e.ssn
ORDER BY Manager_Count ASC;

select * from employee_dept_managerv;

-- Projetos com maior número de empregados (ex: por ordenação desc) 
CREATE VIEW bigger_project_by_e_v as
SELECT p.Pname as Project_Name, COUNT(w.Pno) AS Employee_Count
FROM Project p
INNER JOIN works_on w ON p.Pnumber = w.Pno
GROUP BY p.Pnumber, w.Pno
ORDER BY Employee_Count DESC
LIMIT 1;

select * from bigger_project_by_e_v;

-- Lista de projetos, departamentos e gerentes 
drop view pdg_controller_v;
CREATE VIEW pdg_controller_v AS 
SELECT p.Pname AS Project_Name, COUNT(p.Pnumber) AS Project_Quantity, d.Dname AS Dept_Name,
       COUNT(d.Dnumber) AS Dept_Quantiy, MAX(m.Fname) AS Manager_Controller
FROM Project p
INNER JOIN Departament d ON p.Dnum = d.Dnumber
INNER JOIN Employee m ON d.Dnumber = m.Dno
GROUP BY p.Pnumber, p.Pname, d.Dname;

select * from pdg_controller_v;



-- Quais empregados possuem dependentes e se são gerentes 
CREATE VIEW check_clauses_v as
SELECT e.Fname AS Employee_Name, e.Ssn AS Employee_SSN, 
       CASE WHEN d.Dependent_name IS NOT NULL THEN 'Yes' ELSE 'No' END AS Has_Dependents,
       CASE WHEN m.Mgr_ssn IS NOT NULL THEN 'Yes' ELSE 'No' END AS Is_Manager
FROM Employee e
LEFT JOIN Dependent d ON e.Ssn = d.Essn
LEFT JOIN Departament m ON e.Ssn = m.Mgr_ssn;

select * from check_clauses_v;

-- Controlando acessos
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'senha_gerente';
CREATE USER 'employee'@'localhost' IDENTIFIED BY 'senha_employee';

GRANT SELECT ON company_constraints.employee_dept_v TO 'gerente'@'localhost';
REVOKE SELECT ON company_constraints.employee_dept_v FROM 'employee'@'localhost';
REVOKE SELECT ON company_constraints.employee_dept_managerv FROM 'employee'@'localhost';
REVOKE SELECT ON company_constraints.check_clauses_v FROM 'employee'@'localhost';
REVOKE SELECT ON company_constraints.check_clauses_v FROM 'employee'@'localhost';
REVOKE SELECT ON company_constraints.pdg_controller_v FROM 'employee'@'localhost';

use ecommerce;
DELIMITER //
CREATE TRIGGER prevent_clients_delete
BEFORE DELETE ON clients
FOR EACH ROW
BEGIN
    -- Se o usuário tentar excluir sua própria conta, lançar um erro
    IF OLD.idClient = @logged_in_user_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Você não pode excluir sua própria conta!';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_salary_base
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
    -- Se um novo colaborador for inserido, defina o salário base como um valor padrão
    IF NEW.employee_id IS NOT NULL AND NEW.salary_base IS NULL THEN
        SET NEW.salary_base = 2000; -- Defina o valor padrão do salário base aqui
    END IF;
END //
DELIMITER ;


