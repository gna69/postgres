-- Найти все коды задач, по крайней мере один работник, выполняющий которые, находится в другом отделе
select distinct Task.Task_Code from (Employer_Task inner join Employer on Employer_Task.EmployerCode = Employer.Employer_Code) 
inner join Task on Employer_Task.TaskCode = Task.Task_Code where Task.Department != Employer.Department;

-- Найти все существующие сочетания отдела и статуса проекта
--Примечание: количество отделов – 10, нумерация по порядку; возможные статусы: “done”/”not done”
select distinct t1.Department, t2.Project_Status from (Project as t1 inner join Project as t2 on t1.Department != t2.Department);

-- Найти все номера проектов, для которых работниками департамента D1 не выполняется ни одна работа статуса S1.
-- Примечание: были выбраны D1 = 1, S1 = “done”

select Project_Code from Project where Task in (select TaskCode from Employer_Task where EmployerCode in (select e.Employer_Code from Employer e where 0 != (select count(TaskCode) from Employer_Task where EmployerCode = e.Employer_Code and TaskCode in (select Task_Code from Task) group by EmployerCode having count(*) =
(select count(TaskCode) from Employer_Task where  EmployerCode = e.Employer_Code and TaskCode in (select Task_Code from Task where Task_Status != 'done')))
and e.Department = 1));


-- Определить департаменты, выполняющие задачи для всех проектов (одновременно).
-- Примечание: в таблицу Project(пустую) были добавлены три проекта, каждому из которых соответствует задача № 3. В результате работы программы получаем номер отдела, к которому относится задача №3. Если в таблицу Project добавить еще один проект, номер задачи для которого не равняется 3, в выводе запроса будет пусто, так как теперь выполняются задачи не для всех проектов.
select Department from Task where Task.Task_Code in ((select distinct Task from Project inner join Task T on Project.Task = T.Task_Code group by Task having count(Task) >= (select count(Project_Code) from Project)));

-- Определить все номера задач, сложность которых не превышает среднюю
select count(Task_Code) from Task where Diff <= (select avg(Diff) from Task);