-- =======================================================================
-- PROJEKT: Northwind Sales Analysis
-- AUTOR: Oliwia
-- OPIS: Kompleksowy raport sprzedażowy zawierający 10 kluczowych pytań biznesowych.
-- =======================================================================

-- 💡 Przypominajka techniczna:
-- 1. Prawdziwy przychód po rabacie: UnitPrice * Quantity * (1 - Discount)



-- 📌 PYTANIE 1: Top 5 najlepiej sprzedających się produktów pod względem łącznego przychodu (po uwzględnieniu rabatów).
-- Cel: Identyfikacja kluczowych motorów napędowych sprzedaży (tzw. bestsellerów).
-- Tabele: [Order Details], Products
SELECT d.productID AS ID , p.ProductName AS Nazwa, Round(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) As Przychód_po_rabacie
FROM 'Order Details' d  
INNER JOIN Products p on d.productid=p.ProductID
GROUP by d.productID ,p.ProductName
ORDER BY  Przychód_po_rabacie DESC
Limit 5;



-- 📌 PYTANIE 2: Top 5 najlepszych klientów pod względem łącznej wartości złożonych zamówień.
-- Cel: Wytypowanie grupy klientów VIP do programów lojalnościowych.
-- Tabele: Orders, [Order Details], Customers
SELECT o.customerid as ID_Klienta, c.CompanyName As Nazwa_Klienta,  Round(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2)  As Wartość_zamówień
FROM Orders o
INNER JOIN Customers c on o.customerid =c.CustomerID
INNER JOIN 'Order Details' d on o.OrderID= d.OrderID
GROUP by ID_Klienta, Nazwa_Klienta
ORDER BY Wartość_zamówień DESC
Limit 5;


-- 📌 PYTANIE 3: Łączna wartość sprzedaży (przychód) w rozbiciu na kraje dostawy (ShipCountry).
-- Cel: Analiza geograficzna rynków i identyfikacja krajów o najwyższym potencjale zakupowym.
-- Tabele: Orders, [Order Details]
SELECT o.ShipCountry as Kraj_Dostawy, Round(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2)  As Wartość_zamówień
FROM Orders o
INNER JOIN 'Order Details' d on o.OrderID= d.OrderID
GROUP by Kraj_Dostawy
ORDER BY Wartość_zamówień DESC;


-- 📌 PYTANIE 4: Trendy miesięczne sprzedaży – zestawienie przychodów miesiąc po miesiącu (użyj strftime('%Y-%m', OrderDate)).
-- Cel: Obserwacja trendów, sezonowości sprzedaży oraz kondycji finansowej firmy w czasie.
-- Tabele: Orders, [Order Details]
SELECT strftime('%Y-%m', o.OrderDate) as Miesiąc,  Round(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) As Wartość_zamówień
FROM Orders o
INNER JOIN 'Order Details' d on o.OrderID= d.OrderID
GROUP by Miesiąc
ORDER BY Miesiąc;




-- 📌 PYTANIE 5: Najlepszy pracownik (Employee) pod względem łącznej wartości obsłużonych zamówień.
-- Cel: Ocena efektywności zespołu sprzedaży i wyłonienie lidera.
-- Tabele: Orders, [Order Details], Employees
SELECT (e.firstname || ' ' || e.LastName) as Pracownik, Round(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) As Wartość_zamówień
FROM Orders o
INNER JOIN 'Order Details' d on o.OrderID= d.OrderID
INNER JOIN Employees e on o.EmployeeID=e.EmployeeID
GROUP by Pracownik 
ORDER BY Wartość_zamówień DESC
Limit 1




-- 📌 PYTANIE 6: Średnia wartość pojedynczego zamówienia (AOV - Average Order Value) dla każdego kraju (ShipCountry).
-- Podpowiedź: Łączny przychód podzielony przez liczbę unikalnych zamówień (COUNT(DISTINCT o.OrderID)).
-- Cel: Zrozumienie, w których krajach klienci robią "największe" jednorazowe zakupy.
-- Tabele: Orders, [Order Details]
SELECT o.ShipCountry AS Kraj_Dostawy, Round((SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)))/COUNT(DISTINCT o.OrderID),2) As AOV
From Orders O
INNER JOIN 'Order Details' d on o.OrderID= d.OrderID
GROUP by Kraj_Dostawy
ORDER BY AOV DESC;




-- 📌 PYTANIE 7: Zestawienie popularności kategorii produktowych (liczba sprzedanych sztuk oraz łączny przychód).
-- Cel: Analiza struktury asortymentu – które kategorie dominują na rynku.
-- Tabele: [Order Details], Products, Categories
SELECT c.CategoryName as Kategoria, sum(d.quantity) AS Sprzedana_Ilość, Round(SUM(d.UnitPrice * d.Quantity * (1 - d.Discount)),2) As Wartość_zamówień
FROM 'Order Details' d 
INNER JOIN Products p on d.Productid=p.ProductID
INNER JOIN Categories c on p.CategoryID=c.CategoryID
GROUP by Kategoria
ORDER BY Wartość_zamówień DESC;
 



-- 📌 PYTANIE 8: Efektywność spedytorów – średni czas realizacji dostawy (w dniach) dla każdej firmy kurierskiej.
-- Podpowiedź: Oblicz różnicę między ShippedDate a OrderDate. Odfiltruj zamówienia, które jeszcze nie zostały wysłane (IS NOT NULL).
-- Cel: Monitorowanie jakości logistyki.
-- Tabele: Orders, Shippers

SELECT s.CompanyName as Spedytor, ROUND(AVG(julianday(o.ShippedDate) - julianday(o.OrderDate)), 1) AS Realizacja 
FROM Orders o
INNER JOIN Shippers s on o.ShipVia=s.ShipperID
WHERE o.ShippedDate is not NULL
GROUP by Spedytor
ORDER BY Realizacja DESC;


-- 📌 PYTANIE 9: Analiza kosztów rabatów – ile firma "straciła" na rzecz upustów cenowych dla każdego produktu.
-- Podpowiedź: Wartość rabatu to UnitPrice * Quantity * Discount
-- Cel: Weryfikacja polityki rabatowej – które produkty są najmocniej przeceniane.
-- Tabele: [Order Details], Products
SELECT p.ProductName as Produkt, Round(sum(d.UnitPrice * d.Quantity * d.Discount),2) as Rabat
FROM 'Order Details' d
INNER JOIN Products p on p.ProductID=d.ProductID
GROUP by Produkt
ORDER BY Rabat DESC
 



-- 📌 PYTANIE 10: Ryzyko braków magazynowych (Inventory Risk) – produkty o krytycznym stanie magazynowym (UnitsInStock <= ReorderLevel), które cieszą się największą popularnością (często pojawiają się w zamówieniach).
-- Warunek dodatkowy: weź pod uwagę tylko produkty, które nie zostały wycofane ze sprzedaży (Discontinued = 0).
-- Cel: Zapobieganie utracie przychodów – wytypowanie towarów do natychmiastowego zamówienia u dostawców.
-- Tabele: Products, [Order Details]
SELECTp.ProductName AS Produkt, p.UnitsInStock AS Stan_Magazynowy, p.ReorderLevel AS Poziom_Zamówienia, COUNT(DISTINCT d.OrderID) AS Liczba_Zamówień
FROM Products p
INNER join 'Order Details' d  on p.ProductID=d.ProductID
WHERE p.Discontinued = 0 AND p.UnitsInStock <= p.ReorderLevel
GROUP by p.ProductName, p.UnitsInStock, p.ReorderLevel
ORDER BY Liczba_Zamówień desc;