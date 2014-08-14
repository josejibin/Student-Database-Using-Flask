drop table if exists student;
create table student(
  id integer primary key autoincrement,
  name text not null,
  mark text not null
);
