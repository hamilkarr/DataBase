3. 데이터 조작어
(DML : data manipulation Language)
기본 검색
// book 테이블 검색
select * from book;
비교 검색
// book테이블에 price가 20000미만 검색
select *
from book
where price < 20000;
범위 검색
// book테이블에 price가 만원 이상 이만원 이하 검색
select *
from book
where price >= 10000 and price <= 20000;
집합 - 포함
// book테이블에 publisher가 굿스포츠,대한미디어 검색
select *
from book
where publisher in('굿스포츠','대한미디어');
집합 - 불포함
// book테이블에 publisher가 굿스포츠,대한미디어 검색
select *
from book
where publisher in('굿스포츠','대한미디어');
패턴
// 책이름이 축구의 역사인거 검색
select bookname,publisher
from book
where bookname like '축구의 역사';
패턴 - 포함 문자
// 책이름에 축구가 포함된 데이터 검색
select bookname, publisher
from book
where bookname like '%축구%';
패턴 - 특정 위치
//도서이름의 왼쪽 두 번째 위치에 '구'라는 문자열을 갖는 도서 검색
select *
from book
where bookname like '_구%';
복합 조건
// 책이름에 축구가 포함되며 가격이 2만원 이상인 도서
select *
from book
where bookname like '%축구%' and price >= 20000;
정렬 - 오름 차순
select *
from book
order by bookname;
정렬 - 내림 차순
select *
from book
order by bookname desc;
정렬 - 복합
select *
from book
order by price desc, publisher asc;
집계 함수
select sum(saleprice)
from orders;
집계 함수 - custom name
select sum(salepirce) as 총매출
select sum(salepirce) 총매출
select sum(salepirce) "총 매출"

from orders;
집계 함수 - where
select sum(salepirce) as 총매출
from orders
where custid=2;
집계 함수 - sum, avg, min, max
SELECT 
    SUM(saleprice) AS total,
    AVG(saleprice) AS average,
    MIN(saleprice) AS minimum,
    MAX(saleprice) AS maximum
FROM
    orders;
집계 함수 - count
SELECT 
    COUNT(*)
FROM
    orders;
Group by
// custid로 검색한 결과를 묶어서 검색
select custid, count(*) as 도서수량, sum(saleprice) as 총액
from orders
group by custid;

// group by를 사용할 경우 select 문에 group by에서 사용 되지 않은
// 튜플은 들어갈 수 없다.
// 집계함수와 사용한 튜플만 사용 가능.
Having
// having은 group by 절의 결과 나타나는 그룹을 제한하는 역할
// 주문 결과가 두 권 이상일 경우만 검색
select custid, count(*) 도서수량
from orders
where saleprice >= 8000
group by custid
having count(*) >= 2;

조인 - inner join (내부 조인 / 교집합)
// customer와 orders를 조인하고
// custid와 비교하여 검색
select *
from customer, orders
where custeomr.custid = orders.custid;

select *
from customer join orders
on customer.custid = orders.custid;
조인 - left join (외부 조인 / 합집합)
// 포함하지 않은 데이터를 포함하여 특정 부분을 조인할 경우 사용
// 왼쪽 외부조인은 left join / on(조인조건)
// 오른쪽 외부조인은 right join / on(조인조건)
// 전체 외부조인은 full join / on(조인조건)

select customer.name, orders.saleprice
from customer left join orders
on customer.custid = orders.custid;
부속 질의
// where의 부속질의를 먼저 처리후 전체 질의를 처리한다.
select bookname
from book
where price = (select max(price) from book);

// 대한미디어 에서 출판한 도서를 구매한 고객의 이름
SELECT name
FROM customer
WHERE custid IN (SELECT custid
				FROM orders
                WHERE bookid IN (SELECT bookid
                FROM   book
                WHERE   publisher = '대한미디어')
);
상관 부속 질의
SELECT 
    b1.bookname
FROM
    book b1
WHERE
    b1.price > (SELECT 
            AVG(b2.price)
        FROM
            book b2
        WHERE
            b2.publisher = b1.publisher);

// 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.

집합 연산 - 합집합
// 대한민국에서 거주하는 고객의 이름과 도서를 주문한 고객의 이름을 보이시오
select name
from customer
where address like ("%대한민국%")
UNION
select name
from customer
where custid in (select custid from orders);

// 위 결과중 중복된 데이터 포함하여 출력
select name
from customer
where address like ("대한민국%")
union all
select name
from customer
where custid in (select custid from orders);
상관 부속질의 - Exists : 조건에 맞는 투플이 존재하면 포함
// 주문이 있는 고객의이름과 주소를 보이시오
SELECT 
    name, address
FROM
    customer cs
WHERE
    EXISTS( SELECT 
            *
        FROM
            orders od
        WHERE
            cs.custid = od.custid);
4. 데이터 정의어
( DDL : Data Definition Language)
Create 문
// 기본 생성
create table NewCustomer(
	custid integer primary key,
    name varchar(40),
    address varchar(40),
    phone varchar(30)
);

// 외례키 설정 (newCustomer의 행이 지워지면 NewOrders의 행도 연쇄로 지워짐)
create table NewOrders (
	orderid integer primary key,
    custid integer not null,
    bookid integer not null,
    saleprice integer,
    orderdate date,
    foreign key(custid) references newCustomer(custid) on delete cascade
);
Alter
// NewBook 테이블에 varchar(13)의 자료형을 가진 isbn 속성으 추가
alter table newbook add isbn varchar(13);

// NewBook 테이블의 isbn 속성의 데이터 타입을 integer형을 변경하시오.
alter table newbook modify isbn integer;

// NewBook 테이블의 isbn 속성을 삭제하시오.
alter table newbook drop isbn;

// NewBook 테이블의 bookid 속성에 not null 제약조건을 적용하시오.
alter table newbook modify bookid integer not null;

// NewBook 테이블의 bookid 속성을 기본키로 변경하시오.
alter table newbook add primary key(bookid);
Drop
// newbook 테이블 삭제
drop table newbook;

// 삭제할 때 테이블의 기본키를 다른 테이블에서 참조하고 있다면
// 삭제가 거절된다.
5. 데이터 조작어 - 삭입,수정,삭제
insert 문
insert into book(bookid, bookname, publisher, price) 
	values(11,'스포츠 의학', '한솔의학서적',90000);
insert 문 - select
// 수입 도서 목록(imported_book)을 book 테이블에 모두 삽입하시오.
insert into book(bookid, bookname, price, publisher)
select bookid, bookname, price, publisher
from imported_book;

update 문
// 기본적으로 safe updates 옵션일 경우
// 아래 sql 로직은 오류.
// update의 경우 기본키를 이용해서만 조작할 수 있음.
update customer
set address='대한민국 부산'
where name='박세리';

// 하지만 일시적으로 safe제안을 해제하면 가능.
set sql_safe_updates = 0;
update 문 - 다른 테이블 값

// imported_book의 bookid 21번 데이터를 book에 bookid가 1번 째에 업데이트
UPDATE book 
SET 
    publisher = (SELECT 
            publisher
        FROM
            imported_book
        WHERE
            bookid = '21')
WHERE
    bookid = '1';
delete 문
// book에 bookid가 9인 행 삭제
delete from book
where bookid = '9';