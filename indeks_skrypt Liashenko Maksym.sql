-- Tabela U�ytkownik
CREATE TABLE Uzytkownik (
    UzytkownikID INT PRIMARY KEY IDENTITY(1,1),
    NazwaUzytkownika NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Haslo NVARCHAR(100) NOT NULL
);

-- Tabela Profil
CREATE TABLE Profil (
    ProfilID INT PRIMARY KEY IDENTITY(1,1),
    UzytkownikID INT NOT NULL FOREIGN KEY REFERENCES Uzytkownik(UzytkownikID),
    Imie NVARCHAR(50),
    Nazwisko NVARCHAR(50),
    DataUrodzenia DATE
);

-- Tabela Miejsce
CREATE TABLE Biejsce (
    BiejsceID INT PRIMARY KEY IDENTITY(1,1),
    NazwaBiejsca NVARCHAR(100) NOT NULL,
    Adres NVARCHAR(255) NOT NULL,
    LiczbaBiejsc INT NOT NULL
);

-- Tabela Kategoria Wydarzenia
CREATE TABLE KategoriaWydarzenia (
    KategoriaID INT PRIMARY KEY IDENTITY(1,1),
    NazwaKategorii NVARCHAR(50) NOT NULL
);
-- Tabela Wydarzenie
CREATE TABLE Wydarzenie (
    WydarzenieID INT PRIMARY KEY IDENTITY(1,1),
    NazwaWydarzenia NVARCHAR(100) NOT NULL,
    DataWydarzenia DATETIME NOT NULL,
    BiejsceID INT,
    KategoriaID INT,
    FOREIGN KEY (BiejsceID) REFERENCES Biejsce(BiejsceID),
    FOREIGN KEY (KategoriaID) REFERENCES KategoriaWydarzenia(KategoriaID)
);
-- Tabela Bilet
CREATE TABLE Bilet (
    BiletID INT PRIMARY KEY IDENTITY(1,1),
    WydarzenieID INT NOT NULL FOREIGN KEY REFERENCES Wydarzenie(WydarzenieID),
    UzytkownikID INT NOT NULL FOREIGN KEY REFERENCES Uzytkownik(UzytkownikID),
    Cena DECIMAL(10, 2) NOT NULL,
    DataZakupu DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tabela Transakcja
CREATE TABLE Transakcja (
    TransakcjaID INT PRIMARY KEY IDENTITY(1,1),
    BiletID INT NOT NULL FOREIGN KEY REFERENCES Bilet(BiletID),
    Kwota DECIMAL(10, 2) NOT NULL,
    DataTransakcji DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tabela Recenzja
CREATE TABLE Recenzja (
    RecenzjaID INT PRIMARY KEY IDENTITY(1,1),
    WydarzenieID INT NOT NULL FOREIGN KEY REFERENCES Wydarzenie(WydarzenieID),
    UzytkownikID INT NOT NULL FOREIGN KEY REFERENCES Uzytkownik(UzytkownikID),
    Tytul NVARCHAR(100) NOT NULL,
    Tresc NVARCHAR(MAX) NOT NULL,
    DataRecenzji DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tabela Ocena
CREATE TABLE Ocena (
    OcenaID INT PRIMARY KEY IDENTITY(1,1),
    RecenzjaID INT NOT NULL FOREIGN KEY REFERENCES Recenzja(RecenzjaID),
    UzytkownikID INT NOT NULL FOREIGN KEY REFERENCES Uzytkownik(UzytkownikID),
    Wartosc INT CHECK (Wartosc BETWEEN 1 AND 5)
);

-- Tabela Organizator
CREATE TABLE Organizator (
    OrganizatorID INT PRIMARY KEY IDENTITY(1,1),
    Nazwa NVARCHAR(100) NOT NULL,
    KontaktEmail NVARCHAR(100) NOT NULL
);

-- Tabela Zarz�dzanie Wydarzeniem
CREATE TABLE ZarzadzanieWydarzeniem (
    ZarzadzanieID INT PRIMARY KEY IDENTITY(1,1),
    WydarzenieID INT NOT NULL FOREIGN KEY REFERENCES Wydarzenie(WydarzenieID),
    OrganizatorID INT NOT NULL FOREIGN KEY REFERENCES Organizator(OrganizatorID),
    Status NVARCHAR(50) NOT NULL,
    Uwagi NVARCHAR(MAX)
);

-- Tabela Raport Sprzeda�y
CREATE TABLE RaportSprzedazy (
    RaportID INT PRIMARY KEY IDENTITY(1,1),
    WydarzenieID INT NOT NULL FOREIGN KEY REFERENCES Wydarzenie(WydarzenieID),
    LacznaKwotaSprzedazy DECIMAL(10, 2) NOT NULL,
    DataRaportu DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tabela Powiadomienie
CREATE TABLE Powiadomienie (
    PowiadomienieID INT PRIMARY KEY IDENTITY(1,1),
    UzytkownikID INT NOT NULL FOREIGN KEY REFERENCES Uzytkownik(UzytkownikID),
    Tresc NVARCHAR(MAX) NOT NULL,
    DataWyslania DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tabela Zapytanie Wsparcia
CREATE TABLE ZapytanieWsparcia (
    ZapytanieID INT PRIMARY KEY IDENTITY(1,1),
    UzytkownikID INT NOT NULL FOREIGN KEY REFERENCES Uzytkownik(UzytkownikID),
    TrescZapytania NVARCHAR(MAX) NOT NULL,
    DataZapytania DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tabela Administrator
CREATE TABLE Administrator (
    AdministratorID INT PRIMARY KEY IDENTITY(1,1),
    NazwaUzytkownika NVARCHAR(50) NOT NULL,
    Haslo NVARCHAR(100) NOT NULL
);
-- Wstawianie rekord�w do tabeli Uzytkownik
INSERT INTO Uzytkownik (NazwaUzytkownika, Email, Haslo) VALUES
('user1', 'user1@example.com', 'pass1'),
('user2', 'user2@example.com', 'pass2'),
('user3', 'user3@example.com', 'pass3'),
('user4', 'user4@example.com', 'pass4'),
('user5', 'user5@example.com', 'pass5');

-- Wstawianie rekord�w do tabeli Profil
INSERT INTO Profil (UzytkownikID, Imie, Nazwisko, DataUrodzenia) VALUES
(1, 'Jan', 'Kowalski', '1990-01-01'),
(2, 'Anna', 'Nowak', '1992-02-02'),
(3, 'Pawe�', 'Wi�niewski', '1988-03-03'),
(4, 'Katarzyna', 'Zaj�c', '1995-04-04'),
(5, 'Micha�', 'Jab�o�ski', '1991-05-05');

-- Wstawianie rekord�w do tabeli Miejsce
INSERT INTO Biejsce (NazwaBiejsca, Adres, LiczbaBiejsc) VALUES
('Teatr Wielki', 'Warszawa, Plac Teatralny 1', 500),
('Sala Koncertowa Filharmonii', 'Krak�w, ul. Basztowa 10', 300),
('Kino Luna', 'Pozna�, ul. D�browskiego 15', 250),
('Galeria Sztuki Nowoczesnej', 'Wroc�aw, ul. �widnicka 20', 100),
('Centrum Kongresowe', 'Gda�sk, ul. Pokole� Lechii Gda�sk 1', 1000);
-- Wstawianie rekord�w do tabeli Kategoria Wydarzenia
INSERT INTO KategoriaWydarzenia (NazwaKategorii) VALUES
('Koncert'),
('Teatr'),
('Wystawa'),
('Festiwal Filmowy'),
('Konferencja');

-- Wstawianie rekord�w do tabeli Wydarzenie
INSERT INTO Wydarzenie (NazwaWydarzenia, DataWydarzenia, BiejsceID, KategoriaID) VALUES
('Koncert Rockowy', '2023-06-15 20:00', 1, 1),
('Przedstawienie Teatralne', '2023-07-20 19:00', 2, 2),
('Wernisa� Wystawy Fotografii', '2023-08-05 18:00', 3, 3),
('Mi�dzynarodowy Festiwal Filmowy', '2023-09-10 17:00', 4, 4),
('Konferencja Naukowa', '2023-10-25 09:00', 5, 5);

-- Wstawianie rekord�w do tabeli Bilet
INSERT INTO Bilet (WydarzenieID, UzytkownikID, Cena) VALUES
(1, 1, 150.00),
(2, 2, 80.00),
(3, 3, 50.00),
(4, 4, 120.00),
(5, 5, 200.00);

-- Wstawianie rekord�w do tabeli Transakcja
INSERT INTO Transakcja (BiletID, Kwota) VALUES
(1, 150.00),
(2, 80.00),
(3, 50.00),
(4, 120.00),
(5, 200.00);

-- Wstawianie rekord�w do tabeli Recenzja
INSERT INTO Recenzja (WydarzenieID, UzytkownikID, Tytul, Tresc) VALUES
(1, 1, 'Fantastyczny koncert!', 'Niesamowite wra�enia i doskona�a muzyka.'),
(2, 2, 'Wspania�e przedstawienie', 'Aktorzy grali znakomicie.'),
(3, 3, 'Pi�kne zdj�cia', 'Wystawa by�a bardzo inspiruj�ca.'),
(4, 4, 'Niezapomniany festiwal', 'Filmy by�y naprawd� wyj�tkowe.'),
(5, 5, 'Odkrywcza konferencja', 'Wiele interesuj�cych temat�w i dyskusji.');

-- Wstawianie rekord�w do tabeli Ocena
INSERT INTO Ocena (RecenzjaID, UzytkownikID, Wartosc) VALUES
(1, 1, 5),
(2, 2, 4),
(3, 3, 4),
(4, 4, 5),
(5, 5, 5);

-- Wstawianie rekord�w do tabeli Organizator
INSERT INTO Organizator (Nazwa, KontaktEmail) VALUES
('Organizator 1', 'kontakt@org1.com'),
('Organizator 2', 'kontakt@org2.com'),
('Organizator 3', 'kontakt@org3.com'),
('Organizator 4', 'kontakt@org4.com'),
('Organizator 5', 'kontakt@org5.com');

-- Wstawianie rekord�w do tabeli Zarz�dzanie Wydarzeniem
INSERT INTO ZarzadzanieWydarzeniem (WydarzenieID, OrganizatorID, Status) VALUES
(1, 1, 'Zaplanowane'),
(2, 2, 'Zaplanowane'),
(3, 3, 'Zaplanowane'),
(4, 4, 'Zaplanowane'),
(5, 5, 'Zaplanowane');

-- Wstawianie rekord�w do tabeli Raport Sprzeda�y
INSERT INTO RaportSprzedazy (WydarzenieID, LacznaKwotaSprzedazy) VALUES
(1, 150.00),
(2, 80.00),
(3, 50.00),
(4, 120.00),
(5, 200.00);

-- Wstawianie rekord�w do tabeli Powiadomienie
INSERT INTO Powiadomienie (UzytkownikID, Tresc) VALUES
(1, 'Przypomnienie o wydarzeniu: Koncert Rockowy'),
(2, 'Przypomnienie o wydarzeniu: Przedstawienie Teatralne'),
(3, 'Przypomnienie o wydarzeniu: Wernisa� Wystawy Fotografii'),
(4, 'Przypomnienie o wydarzeniu: Mi�dzynarodowy Festiwal Filmowy'),
(5, 'Przypomnienie o wydarzeniu: Konferencja Naukowa');

-- Wstawianie rekord�w do tabeli Zapytanie Wsparcia
INSERT INTO ZapytanieWsparcia (UzytkownikID, TrescZapytania) VALUES
(1, 'Mam problem z zakupem biletu.'),
(2, 'Jak mog� zmieni� dat� rezerwacji?'),
(3, 'Nie otrzyma�em biletu na email.'),
(4, 'Jak mog� uzyska� zwrot za anulowane wydarzenie?'),
(5, 'Czy mog� zarezerwowa� miejsca dla grupy?');

-- Wstawianie rekord�w do tabeli Administrator
INSERT INTO Administrator (NazwaUzytkownika, Haslo) VALUES
('admin1', 'adminpass1'),
('admin2', 'adminpass2'),
('admin3', 'adminpass3'),
('admin4', 'adminpass4'),
('admin5', 'adminpass5');