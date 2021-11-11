create database db_1;

create table Department(
    Department int primary key
);

create table Task(
  Task_Code int primary key,
  Diff int,
  Task_Status varchar(30) not null,
  Department int references Department(Department) unique not null
);


create table Employer(
    Employer_Code int primary key,
    Employer_Name varchar(100) not null unique ,
    Department int references Department(Department) unique not null
);

create table Employer_Task(
    TaskCode int references Task(Task_Code),
    EmployerCode int references Employer(Employer_Code),
    primary key (EmployerCode, TaskCode)
);


create table Project(
    Project_Code int,
    Project_Name varchar(100) not null unique ,
    Project_Status varchar(30) not null,
    Department int references Department(Department) not null unique,
    Task int references Task(Task_Code) not null,
    primary key (Task, Project_Code)

);


create trigger Add_Task after insert on Task for each row execute procedure Fail_Add();
create or replace function Fail_Add() returns trigger as
    $func$
    begin
        if not exists(select * from Employer_Task where TaskCode = new.Task_Code)
            then delete from Task where Task_Code = new.Task_Code;
            return null;
        end if;
            return new;
    end;
    $func$ language plpgsql;
