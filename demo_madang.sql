/* 이름: demo_madang.sql */
/* 설명 */
 
/* root 계정으로 접속, madang 데이터베이스 생성, madang 계정 생성 */
/* MySQL Workbench에서 초기화면에서 +를 눌러 root connection을 만들어 접속한다. */
DROP DATABASE IF EXISTS  madang;
DROP USER IF EXISTS  madang@localhost;
create user madang@localhost identified WITH mysql_native_password  by 'madang1234!!';
create database madang;
grant all privileges on madang.* to madang@localhost with grant option;
commit;

/* madang DB 자료 생성 */
/* 이후 실습은 MySQL Workbench에서 초기화면에서 +를 눌러 madang connection을 만들어 접속하여 사용한다. */
 
USE madang;

CREATE TABLE Book (
  bookid      INTEGER PRIMARY KEY,
  bookname    VARCHAR(40),
  publisher   VARCHAR(40),
  price       INTEGER 
);

CREATE TABLE  Customer (
  custid      INTEGER PRIMARY KEY,  
  name        VARCHAR(40),
  address     VARCHAR(50),
  phone       VARCHAR(20)
);

CREATE TABLE Orders (
  orderid INTEGER PRIMARY KEY,
  custid  INTEGER ,
  bookid  INTEGER ,
  saleprice INTEGER ,
  orderdate DATE,
  FOREIGN KEY (custid) REFERENCES Customer(custid),
  FOREIGN KEY (bookid) REFERENCES Book(bookid)
);

INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000);
INSERT INTO Book VALUES(2, '축구아는 여자', '나무수', 13000);
INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000);
INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000);
INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000);
INSERT INTO Book VALUES(6, '역도 단계별기술', '굿스포츠', 6000);
INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000);
INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000);
INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500);
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '000-5000-0001');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '000-6000-0001');  
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '000-7000-0001');
INSERT INTO Customer VALUES (4, '추신수', '미국 클리블랜드', '000-8000-0001');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전',  NULL);

INSERT INTO Orders VALUES (1, 1, 1, 6000, STR_TO_DATE('2014-07-01','%Y-%m-%d')); 
INSERT INTOOrders  VALUES (2, 1, 3, 21000, STR_TO_DATE('2014-07-03','%Y-%m-%d'));
INSERT INTO Orders VALUES (3, 2, 5, 8000, STR_TO_DATE('2014-07-03','%Y-%m-%d')); 
INSERT INTO Orders VALUES (4, 3, 6, 6000, STR_TO_DATE('2014-07-04','%Y-%m-%d')); 
INSERT INTO Orders VALUES (5, 4, 7, 20000, STR_TO_DATE('2014-07-05','%Y-%m-%d'));
INSERT INTO Orders VALUES (6, 1, 2, 12000, STR_TO_DATE('2014-07-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (7, 4, 8, 13000, STR_TO_DATE( '2014-07-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (8, 3, 10, 12000, STR_TO_DATE('2014-07-08','%Y-%m-%d')); 
INSERT INTO Orders VALUES (9, 2, 10, 7000, STR_TO_DATE('2014-07-09','%Y-%m-%d')); 
INSERT INTO Orders VALUES (10, 3, 8, 13000, STR_TO_DATE('2014-07-10','%Y-%m-%d'));

-- 여기는 3장에서 사용되는 Imported_book 테이블
CREATE TABLE Imported_Book(Orders
  bookid      INTEGER,
  bookname    VARCHAR(40),
  publisher   VARCHAR(40),
  price       INTEGER 
);

INSERT INTO Imported_Book VALUES(21, 'Zen Golf', 'Pearson', 12000);
INSERT INTO Imported_Book VALUES(22, 'Soccer Skills', 'Human Kinetics', 15000);
commit;

SELECT phone
FROM Customer
WHERE name='김연아';

select bookname, publisher
from Book
where price >= 10000;

select bookname, price
from Book;

select bookid, bookname, publisher, price
from Book;

select *
from Book;

select publisher
from Book;

select distinct publisher
from Book;

select *
from Book
where price < 20000;

SELECT 
    *
FROM
    Book
WHERE
    price BETWEEN 10000 AND 20000;

select *
from Book
where publisher not in ('굿스포츠','대한미디어');

select bookname, publisher
from Book
where bookname like '축구의 역사';

select bookname, publisher
from Book
where bookname like'%축구%';

select *
from Book
order by bookname;

select sum(saleprice)
from Orders;

select sum(saleprice) as 총매출
from Orders;

select count(*)
from Orders;

select custid, count(*) as 도서수량, sum(saleprice) as 총액
from Orders
Group by custid;

select custid, count(*) as 도서수량
from Orders
where saleprice >= 8000
group by custid
having count(*) >=2;

select *
from Customer, Orders;

select *
from Customer, Orders
where Customer.custid = Orders.custid;

SELECT name, sum(saleprice)
from Customer, Orders
where Customer.custid = Orders.custid
group by Customer.name
order by Customer.name;

select Customer.name, saleprice
From Customer left outer join Orders
on Customer.custid = Orders.custid;

select bookname
from Book
where price = (select max(price) from Book);

select name 
from Customer
where custid in (select custid from Orders where bookid in (select bookid from Book where publisher = '대한미디어'));

select version();

update Orders
set bookname = ( select bookname
from Book
where Book.bookid=Orders.bookid );

select bookid, replace(bookname, '야구','농구') bookname, publisher, price
from Book;

select bookname '제목', char_length(bookname)'문자수', length(bookname)'바이트수'
from Book
where publisher ='굿스포츠';

select substr(name,1,1) '성', count(*) '인원'
from Customer
group by substr(name, 1,1);

select str_to_date('20190214','%Y%m%d');

select orderid '주문번호', orderdate'주문일', adddate(orderdate, interval 10 day) '확정'
from Orders;

select name '이름',ifnull(phone, '연락처없음') '전화번호'
from Customer;

set @seq:=0;
select (@seq:=@seq+1)'순번', custid, name, phone
from Customer
where @seq < 2;

select (select name from Customer cs where cs.custid=od.custid) 'name', sum(saleprice) 'total'
from Orders od
group by od.custid;

update Orders
set bookname = (select bookname 
from Book Orders
where Book.bookid=Orders.bookid);

select cs.name, sum(od.saleprice) 'total'
from (select custid, name
from Customer
where custid <= 2) cs,
Orders od
where cs.custid = od.custid
Group by cs.name;

create view Vorders
as select orderid, O.custid, name, O.bookid, bookname, saleprice, orderdate
from Customer C, Orders O, Book B
where C.suctid=O.suctid and B.bookid=bookid;

create view vw_Book
as select *
from Book
where bookname like '%축구%';

create view vw_Customer
as select *
from Customer
where address like '%대한민국%';

select *
from vw_Customer;

select *
from Vorders;

create view vw_Orders (orderid, custid, name, bookid, bookname, saleprice, orderdate)
as select od.orderid, od.custid, cs.name,
od.bookid, bk.bookname, od.saleprice, od.orderdate
from Orders od, Customer cs, Book bk
where od.custid = cs.custid and od.bookid = bk.bookid;

select orderid, bookname, saleprice
from vw_Orders
where name='김연아';

create or replace view vw_Customer(custid, name, address)
as select custid, name, address
from Customer
where address like '%영국%';

select *
from vw_Customer;

drop view vw_Customer;
select*
from vw_Customer;

create index ix_Book on Book (bookname);

create index ix_Book2 on Book(publisher, price);

select * from Book where publisher='대한미디어' and price >=30000;

alter table Book;

drop index ix_Book on Book;