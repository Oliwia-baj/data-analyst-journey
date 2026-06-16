--📋 Lista zadań: Podstawy SELECT & Filtrowanie--
--📊 Unikalne wartości (DISTINCT)--
--Wyświetl listę wszystkich unikalnych krajów (Country), z których pochodzą klienci w tabeli Customers.--
SELECT DISTINCT(country)
FROM Customers;

--Sprawdź, jakie unikalne stanowiska/tytuły (Title) zajmują pracownicy w tabeli Employees.--
SELECT DISTINCT(title)
FROM Employees;

--🏷️ Aliasy i obliczenia (AS)--
--Wybierz nazwę firmy (CompanyName) oraz osobę kontaktową (ContactName) z tabeli Customers, nadając kolumnom polskie aliasy: Nazwa Firmy oraz OsobaKontaktowa.--
SELECT companyname as NazwaFirmy , contactname as OsobaKontaktowa
FROM Customers;

--Wylicz wartość zapasów dla każdego produktu (cena UnitPrice pomnożona przez stan magazynowy UnitsInStock) z tabeli Products. Wynik wyświetl w nowej kolumnie o nazwie WartoscMagazynu obok nazwy produktu.
SELECT productname AS Produkt , unitprice*unitsinstock as WartośćMagazynu
FROM Products;


--🔍 Filtrowanie tekstu (LIKE)
--Znajdź klientów (Customers), których osoba kontaktowa (ContactName) ma imię lub nazwisko zaczynające się na literę "M".
SELECT companyname, contactname
FROM Customers
WHERE contactname like 'M%'  OR contactname LIKE '% M%';

--Wyświetl wszystkie produkty (Products), które mają w swojej nazwie słowo "Chai" lub "Chef".
SELECT productname
FROM Products
WHERE productname like '%Chai%' OR productname like '%Chef%';


--Wyszukaj pracowników (Employees), których nazwisko (LastName) kończy się na litery "on".
SELECT lastname, firstname
FROM Employees
WHERE lastname like '%on';

--🔢 Przedziały i daty (BETWEEN)
--Wyświetl produkty, których cena jednostkowa (UnitPrice) mieści się w przedziale od 10 do 20 dolarów (włącznie).
SELECT productname, unitprice
FROM Products
WHERE unitprice BETWEEN 10 and 20;

--Wyszukaj wszystkie zamówienia (Orders), które zostały złożone w okresie od 1 do 31 stycznia 1997 roku (użyj kolumny OrderDate).
SELECT orderid, orderdate
FROM Orders
WHERE orderdate BETWEEN '1997-01-01' and '1997-01-31';

--📦 Zbiory wartości (IN)
--Wybierz klientów z tabeli Customers, którzy mieszkają w jednym z trzech krajów: Niemcy (Germany), Francja (France) lub Wielka Brytania (UK).
SELECT companyname, country
FROM Customers
WHERE country IN ('Germany','France','UK');

--Wyświetl produkty, które należą do kategorii (CategoryID) o numerach 1, 3 lub 5.
SELECT productname, categoryid
FROM Products
WHERE categoryid in (1,3,5);

--🕳️ Braki w danych (IS NULL / IS NOT NULL)
--Znajdź klientów, którzy w swoich danych nie mają uzupełnionego regionu (kolumna Region ma wartość NULL).
SELECT companyname, region
FROM Customers
WHERE region is NULL;

--Wybierz zamówienia z tabeli Orders, które zostały już fizycznie wysłane do klientów (kolumna ShippedDate nie jest pusta).
SELECT orderid, shippeddate
FROM Orders
WHERE shippeddate is NOT NULL;

--🔀 Sortowanie (ORDER BY)
--Wyświetl listę produktów posortowaną najpierw po ID kategorii (CategoryID) rosnąco, a w ramach tej samej kategorii – od najdroższego do najtańszego produktu (cena malejąco).
SELECT productname, categoryid, unitprice
FROM Products
Order by categoryid, unitprice DESC;

--Wyświetl klientów posortowanych alfabetycznie najpierw według kraju (Country), a następnie według miast (City) w tych krajach.
SELECT companyname, country, city
FROM Customers
Order by country, city;

--🎯 Wielkie combo (Miks różnych technik)
--Wyświetl listę unikalnych miast (City), w których firma ma swoich dostawców (Suppliers), posortowaną alfabetycznie.
SELECT DISTINCT(city)
FROM Suppliers
Order by city;

--Wyszukaj pracowników, którzy pracują na stanowisku 'Sales Representative' i których nazwisko (LastName) zaczyna się na jedną z liter: A, B, C lub D.
SELECT firstname, lastname 
FROM Employees
WHERE title LIKE 'Sales Representative' AND (LastName LIKE 'A%' OR LastName LIKE 'B%' OR LastName LIKE 'C%' OR LastName LIKE 'D%');

--Wybierz 5 zamówień o najwyższym koszcie frachtu (Freight), ale tylko takich, gdzie koszt ten mieści się w granicach 50 - 150 dolarów.
SELECT orderid, freight
FROM Orders
WHERE freight BETWEEN 50 and 150
ORDER BY freight
limit 5;

--Wyświetl imiona (FirstName jako Imie) i nazwiska (LastName jako Nazwisko) pracowników, którzy mają przypisanego jakiegoś przełożonego (kolumna ReportsTo nie jest pusta).
SELECT firstname as 'Imie', lastname AS 'Nazwisko', reportsto as ID_Przelozonego
FROM Employees
WHERE runieportsto is not NULL;

--Wybierz unikalne ID kategorii (CategoryID) dla produktów, których cena jest wyższa niż 20 dolarów, ale aktualnie nie ma ani jednej sztuki na magazynie (UnitsInStock = 0). Wynik posortuj od najwyższego ID kategorii do najniższego.
SELECT productname, categoryid, unitprice, unitsinstock
FROM Products
WHERE unitprice > 20 and unitsinstock =0
ORDER BY categoryid DESC ;