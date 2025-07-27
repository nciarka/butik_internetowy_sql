CREATE DATABASE [BUTIK_INTERNETOWY]

USE [BUTIK_INTERNETOWY]

-- Utworzenie tabel
CREATE TABLE Klienci (
Id_Klient INT NOT NULL IDENTITY PRIMARY KEY,
Imie VARCHAR(255) NOT NULL,
Nazwisko VARCHAR(255) NOT NULL,
Email VARCHAR (255) UNIQUE NOT NULL
);

CREATE TABLE Produkty(
Id_Produkt INT NOT NULL IDENTITY PRIMARY KEY,
Nazwa VARCHAR(255) NOT NULL,
Cena FLOAT(53) NOT NULL,
Id_Kategoria INT NOT NULL,
Opis VARCHAR(255) NOT NULL
);

CREATE TABLE Kategoria(
Id_Kategoria INT NOT NULL IDENTITY PRIMARY KEY,
Nazwa VARCHAR(255) NOT NULL
);
CREATE TABLE Zamowienia(
Id_Zamowienia INT NOT NULL IDENTITY PRIMARY KEY,
Data_Zamowienia DATETIME NOT NULL,
Id_Klient INT NOT NULL,
Status VARCHAR(255) NOT NULL
);

CREATE TABLE SzczegolyZamowienia(
Id_Szczegol INT NOT NULL IDENTITY PRIMARY KEY,
Id_Zamowienia INT NOT NULL,
Id_Produkt INT NOT NULL,
Ilosc FLOAT(53) NOT NULL
);

CREATE TABLE Platnosci(
Id_Platnosci INT NOT NULL IDENTITY PRIMARY KEY,
Id_Zamowienia INT NOT NULL,
Data_Platnosci DATETIME NOT NULL,
Kwota FLOAT(53) NOT NULL
);

CREATE TABLE Logi(
Id_Logi INT NOT NULL IDENTITY PRIMARY KEY,
Id_Zamowienia INT NOT NULL,
Data_Zmiany DATETIME NOT NULL,
Opis VARCHAR(255) NOT NULL
);

CREATE TABLE Adres(
Id_Adres INT NOT NULL IDENTITY  PRIMARY KEY,
Id_KlienT INT NOT NULL,
Adres_Dostawy VARCHAR(255) NOT NULL
);

-- Dodanie kluczy obcych do tabel
ALTER TABLE Logi 
ADD CONSTRAINT logi_id_zamowienia_foreign FOREIGN KEY(Id_Zamowienia) REFERENCES Zamowienia(Id_Zamowienia)

ALTER TABLE Adres 
ADD CONSTRAINT adres_id_klient_foreign FOREIGN KEY(Id_Klient) REFERENCES Klienci(Id_Klient)

ALTER TABLE SzczegolyZamowienia
ADD CONSTRAINT szczegolyzamowienia_id_zamowienia_foreign FOREIGN KEY(Id_Zamowienia) REFERENCES Zamowienia(Id_Zamowienia)

ALTER TABLE Platnosci
ADD CONSTRAINT platnosci_id_zamowienia_foreign FOREIGN KEY(Id_Zamowienia) REFERENCES Zamowienia(Id_Zamowienia)

ALTER TABLE Produkty
ADD CONSTRAINT produkty_id_kategoria_foreign FOREIGN KEY(Id_Kategoria) REFERENCES Kategoria(Id_Kategoria)
ALTER TABLE Zamowienia
ADD CONSTRAINT zamowienia_id_klient_foreign FOREIGN KEY(Id_Klient) REFERENCES Klienci(Id_Klient)

ALTER TABLE SzczegolyZamowienia
ADD CONSTRAINT szczegolyzamowienia_id_produkt_foreign FOREIGN KEY(Id_Produkt) REFERENCES Produkty(Id_Produkt);

-- Procedura dodaj¹ca nowego klienta 
CREATE PROCEDURE DodajKlienta
@Imie VARCHAR(255),
@Nazwisko VARCHAR(255),
@Email VARCHAR(255)
AS
BEGIN
IF NOT EXISTS (SELECT 1 FROM Klienci WHERE Email = @Email)
BEGIN
INSERT INTO Klienci (Imie, Nazwisko, Email)
VALUES (@Imie, @Nazwisko, @Email)
END
END

EXEC DodajKlienta @Imie = 'Kasia', @Nazwisko = 'Kowalska', @Email = 'kasia.kowalska@example.com'

-- Procedura aktualizuj¹ca produkt
CREATE PROCEDURE AktualizujProdukt
@Id_Produkt INT,
@Nazwa VARCHAR(255),
@Cena FLOAT,
@Id_Kategoria INT,
@Opis VARCHAR(255)
AS
BEGIN
IF EXISTS (SELECT 1 FROM Produkty WHERE Id_Produkt = @Id_Produkt)
BEGIN
UPDATE Produkty
SET Nazwa = @Nazwa, Cena = @Cena, Id_Kategoria = @Id_Kategoria, Opis = @Opis
WHERE Id_Produkt = @Id_Produkt
END
END

EXEC AktualizujProdukt @Id_Produkt = 5, @Nazwa = 'Mikser',@Cena = 277.99, @Id_Kategoria = 5, @Opis = 'Mikser kuchenny'


-- Procedura usuwaj¹ca zamówienie
CREATE PROCEDURE UsunZamowienie
@Id_Zamowienia INT
AS
BEGIN
IF EXISTS (SELECT 1 FROM Zamowienia WHERE Id_Zamowienia = @Id_Zamowienia)
BEGIN
DELETE FROM Logi
WHERE Id_Zamowienia = @Id_Zamowienia
DELETE FROM Platnosci
WHERE Id_Zamowienia = @Id_Zamowienia;
DELETE FROM SzczegolyZamowienia
WHERE Id_Zamowienia = @Id_Zamowienia
DELETE FROM Zamowienia
WHERE Id_Zamowienia = @Id_Zamowienia
END
END

EXEC UsunZamowienie @Id_Zamowienia = 2

-- Trigger dodaj¹c nowe zamówienie do tabeli Logi 
CREATE TRIGGER DodajNoweZamowienieDoLogi
ON Zamowienia
AFTER INSERT
AS
BEGIN
INSERT INTO Logi (Id_Zamowienia, Data_Zmiany, Opis)
SELECT Id_Zamowienia, GETDATE(), 'Nowe zamówienie utworzone'
FROM Inserted
END

INSERT INTO Zamowienia (Data_Zamowienia, Id_Klient, Status)
VALUES ('2025-01-22 12:00', 1, 'Nowe')

-- Tworzenie widoku z danymi o zamowieniach
CREATE VIEW DaneZamowien AS
SELECT 
Klienci.Id_Klient,
Klienci.Imie,
Klienci.Nazwisko,
Zamowienia.Id_Zamowienia,
Zamowienia.Data_Zamowienia,
Zamowienia.Status,
Platnosci.Kwota AS KwotaPlatnosci
FROM Klienci, Zamowienia, Platnosci
WHERE Klienci.Id_Klient = Zamowienia.Id_Klient
AND Zamowienia.Id_Zamowienia = Platnosci.Id_Zamowienia;

SELECT*FROM DaneZamowien


-- Dodanie danych do tabel
INSERT INTO Klienci (Imie, Nazwisko, Email) VALUES
('Anna', 'Kowalska', 'anna.kowalska@example.com'),
('Jan', 'Nowak', 'jan.nowak@example.com'),
('Kasia', 'Wiœniewska', 'kasia.wisniewska@example.com'),
('Piotr', 'Zieliñski', 'piotr.zielinski@example.com'),
('Maria', 'Jankowska', 'maria.jankowska@example.com'),
('Tomasz', 'Kowalczyk', 'tomasz.kowalczyk@example.com'),
('Joanna', 'Lewandowska', 'joanna.lewandowska@example.com'),
('Micha³', 'W³odarczyk', 'michal.wlodarczyk@example.com'),
('Magda', 'Wêglarz', 'magda.weglarz@example.com'),
('Adam', 'Nowicki', 'adam.nowicki@example.com'),
('Ewa', 'Domañska', 'ewa.domanska@example.com'),
('Kamil', 'Szymczak', 'kamil.szymczak@example.com')

INSERT INTO Kategoria (Nazwa) VALUES
('Odzie¿'),
('Elektronika'),
('Ksi¹¿ki'),
('Sport'),
('AGD'),
('Zabawki'),
('Meble'),
('Kosmetyki'),
('Jedzenie'),
('Obuwie'),
('Bi¿uteria'),
('Ogród')

INSERT INTO Produkty (Nazwa, Cena, Id_Kategoria, Opis) VALUES
('Koszulka', 49.99, 1, 'Koszulka z nadrukiem'),
('Laptop', 2499.99, 2, 'Laptop gamingowy'),
('Ksi¹¿ka', 19.99, 3, 'Ksi¹¿ka fantasy'),
('Pi³ka no¿na', 79.99, 4, 'Pi³ka do gry na trawie'),
('Mikser', 299.99, 5, 'Mikser kuchenny'),
('Lalka', 59.99, 6, 'Lalka Barbie'),
('Krzes³o', 199.99, 7, 'Krzes³o biurowe'),
('Szampon', 29.99, 8, 'Szampon do w³osów suchych'),
('Czekolada', 4.99, 9, 'Czekolada mleczna'),
('Buty sportowe', 249.99, 10, 'Buty do biegania'),
('Naszyjnik', 149.99, 11, 'Naszyjnik srebrny'),
('Grabie', 49.99, 12, 'Grabie do ogrodu')

INSERT INTO Zamowienia (Data_Zamowienia, Id_Klient, Status) VALUES
('2025-01-10 10:30', 1, 'Nowe'),
('2025-01-11 14:00', 2, 'W realizacji'),
('2025-01-12 12:15', 3, 'Zrealizowane'),
('2025-01-13 08:45', 4, 'Nowe'),
('2025-01-14 09:50', 5, 'Nowe'),
('2025-01-15 16:30', 6, 'W realizacji'),
('2025-01-16 10:00', 7, 'Zrealizowane'),
('2025-01-17 11:00', 8, 'Nowe'),
('2025-01-18 15:20', 9, 'Zrealizowane'),
('2025-01-19 14:10', 10, 'W realizacji'),
('2025-01-20 10:25', 11, 'Nowe'),
('2025-01-21 13:40', 12, 'Zrealizowane')

INSERT INTO SzczegolyZamowienia (Id_Zamowienia, Id_Produkt, Ilosc) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 1),
(2, 4, 3),
(3, 5, 1),
(3, 6, 2),
(4, 7, 1),
(5, 8, 4),
(6, 9, 10),
(7, 10, 1),
(8, 11, 2),
(9, 12, 3)

INSERT INTO Platnosci (Id_Zamowienia, Data_Platnosci, Kwota) VALUES
(1, '2025-01-10 11:00', 149.97),
(2, '2025-01-11 14:30', 259.97),
(3, '2025-01-12 13:00', 359.97),
(4, '2025-01-13 09:00', 199.99),
(5, '2025-01-14 10:00', 119.96),
(6, '2025-01-15 17:00', 499.90),
(7, '2025-01-16 11:00', 249.99),
(8, '2025-01-17 12:00', 299.98),
(9, '2025-01-18 16:00', 149.97),
(10, '2025-01-19 15:00', 749.97),
(11, '2025-01-20 11:00', 89.96),
(12, '2025-01-21 14:00', 599.97)

INSERT INTO Logi (Id_Zamowienia, Data_Zmiany, Opis) VALUES
(1, '2025-01-10 11:00', 'Zamówienie utworzone'),
(1, '2025-01-10 11:10:', 'P³atnoœæ zrealizowana'),
(2, '2025-01-11 14:30', 'Zamówienie w realizacji'),
(3, '2025-01-12 13:00', 'Zamówienie zrealizowane'),
(4, '2025-01-13 09:00', 'Zamówienie utworzone'),
(5, '2025-01-14 10:00', 'P³atnoœæ zrealizowana'),
(6, '2025-01-15 17:00', 'Zamówienie w realizacji'),
(7, '2025-01-16 11:00', 'Zamówienie zrealizowane'),
(8, '2025-01-17 12:00', 'Zamówienie utworzone'),
(9, '2025-01-18 16:00', 'Zamówienie zrealizowane'),
(10, '2025-01-19 15:00', 'Zamówienie w realizacji'),
(11, '2025-01-20 11:00', 'Zamówienie utworzone')

INSERT INTO Adres (Id_Klient, Adres_Dostawy) VALUES
(1, 'ul. Polna 1, Warszawa'),
(2, 'ul. Zielona 2, Kraków'),
(3, 'ul. Szeroka 3, Poznañ'),
(4, 'ul. D³uga 4, Wroc³aw'),
(5, 'ul. Krótka 5, Gdañsk'),
(6, 'ul. Mi³a 6, Szczecin'),
(7, 'ul. Jasna 7, Bydgoszcz'),
(8, 'ul. Nowa 8, Lublin'),
(9, 'ul. Stara 9, Katowice'),
(10, 'ul. W¹ska 10, £ódŸ'),
(11, 'ul. Rynek 11, Toruñ'),
(12, 'ul. Kamienna 12, Rzeszów')

