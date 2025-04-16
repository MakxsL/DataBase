
CREATE VIEW ViewWydarzeniaISprzedaz AS
SELECT 
    W.WydarzenieID,
    W.NazwaWydarzenia,
    W.DataWydarzenia,
    COUNT(B.BiletID) AS LiczbaSprzedanychBiletow,
    SUM(T.Kwota) AS Zarobek
FROM Wydarzenie W
JOIN Bilet B ON W.WydarzenieID = B.WydarzenieID
JOIN Transakcja T ON B.BiletID = T.BiletID
GROUP BY W.WydarzenieID, W.NazwaWydarzenia, W.DataWydarzenia;

GO

CREATE VIEW ViewSredniaOcenaWydarzen AS
SELECT 
    W.WydarzenieID,
    W.NazwaWydarzenia,
    AVG(O.Wartosc) AS SredniaOcena
FROM Wydarzenie W
JOIN Recenzja R ON W.WydarzenieID = R.WydarzenieID
JOIN Ocena O ON R.RecenzjaID = O.RecenzjaID
GROUP BY W.WydarzenieID, W.NazwaWydarzenia;

GO

CREATE FUNCTION FnLiczbaEventowOrganizatora(@OrganizatorID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM ZarzadzanieWydarzeniem WHERE OrganizatorID = @OrganizatorID);
END;

GO

CREATE FUNCTION FnCaloscDochoduZEventu(@WydarzenieID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Dochod DECIMAL(10,2);
    SELECT @Dochod = SUM(Kwota) FROM Transakcja
    WHERE BiletID IN (SELECT BiletID FROM Bilet WHERE WydarzenieID = @WydarzenieID);
    RETURN @Dochod;
END;

GO

CREATE PROCEDURE ProcDodanieWydarzenia
@NazwaWydarzenia NVARCHAR(100),
@DataWydarzenia DATETIME,
@BiejsceID INT,
@KategoriaID INT,
@OrganizatorID INT,
@Status NVARCHAR(50)
AS
BEGIN
    INSERT INTO Wydarzenie (NazwaWydarzenia, DataWydarzenia, BiejsceID, KategoriaID)
    VALUES (@NazwaWydarzenia, @DataWydarzenia, @BiejsceID, @KategoriaID);

    DECLARE @WydarzenieID INT = SCOPE_IDENTITY();

    INSERT INTO ZarzadzanieWydarzeniem (WydarzenieID, OrganizatorID, Status)
    VALUES (@WydarzenieID, @OrganizatorID, @Status);
END;

GO

CREATE PROCEDURE ProcAktualizacjaStatusuWydarzenia
@WydarzenieID INT,
@NowyStatus NVARCHAR(50)
AS
BEGIN
    UPDATE ZarzadzanieWydarzeniem
    SET Status = @NowyStatus
    WHERE WydarzenieID = @WydarzenieID;
END;


GO

CREATE TRIGGER TriggerAktualizacjaDochoduTransakcji
ON Transakcja
AFTER INSERT
AS
BEGIN
    DECLARE @WydarzenieID INT;
    SELECT @WydarzenieID = B.WydarzenieID FROM inserted I
    JOIN Bilet B ON I.BiletID = B.BiletID;

    UPDATE RaportSprzedazy
    SET LacznaKwotaSprzedazy = LacznaKwotaSprzedazy + (SELECT Kwota FROM inserted)
    WHERE WydarzenieID = @WydarzenieID;
END;

GO

CREATE TRIGGER TriggerAutomatyczneTworzenieProfilu
ON Uzytkownik
AFTER INSERT
AS
BEGIN
    INSERT INTO Profil (UzytkownikID)
    SELECT UzytkownikID FROM inserted;
END;

GO

CREATE TRIGGER TriggerWeryfikacjaEmaila
ON Uzytkownik
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT * FROM inserted I
        INNER JOIN Uzytkownik U ON U.Email = I.Email AND U.UzytkownikID <> I.UzytkownikID
    )
    BEGIN
        RAISERROR ('Email musi byæ unikalny dla ka¿dego u¿ytkownika.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

GO

CREATE TRIGGER TriggerUsuwanieBiletowPoEvent
ON Wydarzenie
AFTER DELETE
AS
BEGIN
    DELETE FROM Bilet
    WHERE WydarzenieID IN (SELECT WydarzenieID FROM deleted);
END;