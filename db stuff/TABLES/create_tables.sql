DROP TABLE IF EXISTS Utente,Birra,Consumazione;

-- Creazione tabella Utente
CREATE TABLE Utente (
	id VARCHAR(8) PRIMARY KEY,
	nome VARCHAR(20) NOT NULL,
	cognome VARCHAR(20) NOT NULL,
	email VARCHAR(45) NOT NULL,
	psw VARCHAR(30) NOT NULL,
	saldo DECIMAL(10,2),
	data_reg DATETIME
);
-- Creazione tabella Birra
CREATE TABLE Birra (
	id INT PRIMARY KEY,
	nome VARCHAR(20) NOT NULL,
	prezzo_litro DECIMAL(5,2) NOT NULL,
	disp ENUM('DISP','NON_DISP') NOT NULL,
	gradi DECIMAL(4,2),
	tipo VARCHAR(15)
);

-- Creazione tabella Consumazione
CREATE TABLE Consumazione(
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id VARCHAR(8) NOT NULL,
	beer_id INT NOT NULL,
	quantita INT NOT NULL,
	importo DECIMAL(6,2) , -- ottenibile come prodotto quantità*birra.prezzo_litro
	data_consumazione DATETIME, 
	FOREIGN KEY (user_id) REFERENCES Utente(id), 
	FOREIGN KEY (beer_id) REFERENCES Birra(id)
);

-- Creazione trigger updateImporto
CREATE TRIGGER updateImporto BEFORE INSERT ON consumazione
FOR EACH ROW
BEGIN
	DECLARE prezzo DECIMAL(6,2);
-- Inserisco il costo della consumazione nella query
	SELECT prezzo_litro INTO prezzo FROM birra WHERE birra.id=NEW.beer_id;
	SET NEW.importo = NEW.quantita*prezzo/1000;
-- Aggiorno il valore saldo nella tabella Utente sommando
-- il prezzo della consumazione
	UPDATE utente SET saldo = saldo + NEW.importo WHERE id = NEW.user_id;
END;
