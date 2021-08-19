-- (1) 도서번호가 1인 도서의 이름
select bookname
from book
where bookid = 1;

-- (2) 가격이 20,00원 이상인 도서의 이름
select bookname
from book
where price >= 20000;

-- (3) 박지성의 총 구매액
select sum(saleprice)
from orders
where custid = (select custid
from customer
where name = "박지성");

-- (4) 박지성이 구매한 도서의 수
select count(*)
from orders
where custid = 1;

-- (5) 박지성이 구매한 도서의 출판사 수
select count(distinct publisher) as "출판사 수"
from book
where bookid in (select bookid
from orders
where custid = (select custid
from customer
where name = "박지성"));

-- (6) 박지성이 구매한 도서의 이름, 가격, 정가와 판매가격의 차이
select bookname as 책이름, price as 가격, price - saleprice as "정가 차이"
from orders join book
on orders.bookid = book.bookid
where custid = (select custid
from customer
where name = "박지성");

-- (7) 박지성이 구매하지 않은 도서의 이름
select *
from book
where not exists(
	select bookname
    from orders
    where orders.bookid = book.bookid and orders.custid = 
		(select custid
	     from customer
	     where name = "박지성")
);


02. 마당서점의 운영자와 경영자가 요구하는 다음 질문에 대해 SQL 문을 작성하시오.
    -- (1) 마당서점 도서의 총 개수
    select count(*)
    from book;

    -- (2) 마당서점에 도서를 출고하는 출판사의 총 개수
    select count(distinct publisher)
    from book;

    -- (3) 모든 고객의 이름, 주소
    select name, address
    from customer;

    -- (4) 2014년 7월 4일~7월7일 사이에 주문받은 도서의 주문번호
    select bookid
    from orders
    where orderdate between date_format("2014-07-04","%Y-%m-%d") and date_format("2014-07-07","%Y-%m-%d");

    -- (5) 2014년 7월 4일~7월7일 사이에 주문받은 도서를 제외한 도서의 주문번호
    select bookid
    from orders
    where orderdate not between date_format("2014-07-04","%Y-%m-%d") and date_format("2014-07-07","%Y-%m-%d");
                
    -- (6) 성이 '김' 씨인 고객의 이름과 주소
    select name, address
    from customer
    where name like '김%';

    -- (7) 성이 '김' 씨이고 이름이 '아'로 끝나는 고객의 이름과 주소
    select name, address
    from customer
    where name like '김%아';

    -- (8) 주문하지 않은 고객의 이름(부속질의 사용)
    select name
    from customer
    where not exists(
      select custid
        from orders
        where customer.custid = orders.custid    
    );

    -- (9) 주문 금액의 총액과 주문의 평균 금액
    select sum(orders.saleprice) as "총액", round(avg(orders.saleprice)) as "평균 금액"
    from orders;

    -- (10) 고객의 이름과 고객별 구매액
    select customer.name, sum(orders.saleprice)
    from orders join customer
    on orders.custid = customer.custid
    group by orders.custid;

    -- (11) 고객의 이름과 고객이 구매한 도서 목록
    select customer.name, book.bookname
    from orders left join customer on orders.custid = customer.custid
          left join book 	   on orders.bookid = book.bookid;

    -- (12) 도서의 가격(Book 테이블)과 판매가격(Orders 테이블)의 차이가 가장 많은 주문
    select *
    from book join orders on book.bookid = orders.bookid
    where price - saleprice like (
      select MAX(price - saleprice)
        from book join orders on book.bookid = orders.bookid
    );

    -- (13) 도서의 판매액 평균보다 자신의 구매액 평균이 더 높은 고객의 이름
    select round(avg(saleprice))
    from orders join customer
    on orders.custid = customer.custid
    group by orders.custid
    having avg(saleprice) > (select avg(saleprice) from orders);


03. 마당서점에서 다음의 심화된 질문에 대해 SQL 문을 작성하시오.
    -- 1. 박지성이 구매한 도서의 출판사와 같은 출판사에서 도서를 구매한 고객의 이름
    select distinct name
    from customer join orders
    on customer.custid = orders.custid
    where bookid in (select bookid
    from book
    where customer.name not like "박지성" and
    publisher in (
        select publisher
        from orders join book
        on orders.bookid = book.bookid
            where orders.custid = (
          select custid
                from customer
                where name like "박지성"
            )
    ));

    -- 2. 두 개 이상의 서로 다른 출판사에서 도서를 구매한 고객의 이름
    select name
    from customer c1
    where 2 >= (
      select count(distinct publisher)
      from orders join book on orders.bookid = book.bookid
            join customer on orders.custid = customer.custid
      where name like c1.name
      );

    -- 3. 전체 고객의 30% 이상이 구매한 도서
    select bookname
    from book b1
    where (
      select count(book.bookid)
        from book join orders
        on book.bookid = orders.bookid
        where book.bookid = b1.bookid
    ) >= 0.3 * (select count(*) from customer);


04. 다음 질의에 대해 DDL 문과 DML 문을 작성하시오.
    -- (1) 새로운 도서 ('스포츠 세계', '대한미디어', 10000원)이 마당서점에 입고되었다. 삽입이 안 될 경우 필요한 데이터가 더 있는지 찾아보시오.
    -- 답 : 북 아이디가 필요하다.
    insert into book(bookid, bookname, publisher, price) values('북 아이디가 필요하다.','스포츠 세계', '대한미디어', 10000);

    -- (2) '삼성당'에서 출판한 도서를 삭제하시오. (safe 옵션 해제)
    delete from book
    where publisher = "삼성당";

    -- (3) '이상미디어'에서 출판한 도서를 삭제하시오. 삭제가 안 되면 원인을 생각해보시오.
    -- 답 : orders에 공유 된 키가 있기 때문에 지워지지 않는다. orders에 bookid가 7,8인 경우가 없어야 삭제 가능
    delete from book
    where publisher = "이상미디어";

    -- (4) 출판사 '대한미디어'를 '대한출판사'로 이름을 바꾸시오.
    update book
    set publisher = '대한출판사'
    where publisher = '대한미디어';

    -- (5) (테이블 생성) 출판사에 대한 정보를 저장하는 테이블 Bookcompany(name, address, begin)을 생성하고자 한다.
    -- name은 기본키며 VARCHAR(20), address는 VARCHAR(20), begin는 DATE 타입으로 선언하여 생성하시오.
    create table Bookcompany(
      name varchar(20) primary key,
        address varchar(20),
        begin date
    );

    -- (6) (테이블 수정) Bookcompany 테이블에 인터넷 주소를 저장하는 webaddress 속성을 varchar(30)으로 추가하시오.
    alter table bookcompany add webaddress varchar(30);

    -- (7) Bookcompany 테이블에 임의의 투플 name = 한빛아카데미, address = 서울시 마포구, begin=1993-01-01, webaddress=http://hanbit.co.kr을 삽입하시오.
    insert into bookcompany(name, address, begin, webaddress) values('한빛아카데미','서울시 마포구','1993-01-01','http://hanbit.co.kr');


05. 다음 Exists 질의의 결과를 보이시오.
    -- (1) 질의의 결과는 무엇인가?
    -- 답 : 책 구매를 하지 않은 고객
    select *
    from customer c1
    where not exists(
      select *
        from orders c2
        where c1.custid = c2.custid
    );

    -- (2) not을 지우면 질의의 결과는 무엇인가?
    -- 답 : 책을 구매한 고객
    select *
    from customer c1
    where exists(
      select *
        from orders c2
        where c1.custid = c2.custid
    );