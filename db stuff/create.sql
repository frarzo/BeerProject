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
	SELECT prezzo_litro INTO prezzo FROM birra WHERE birra.id=NEW.beer_id;
	SET NEW.importo = NEW.quantita*prezzo/1000;
END;


INSERT INTO Utente(id,nome, cognome, email, psw, saldo, data_reg) VALUES ('fh9347h0','Francesco', 'Arzon', 'franz9700@gmail.com', 'password123', 100.00, '2010-02-06 10:00:00');
INSERT INTO Birra (id,nome,prezzo_litro,disp,gradi,tipo) VALUES(00123,'Heineken',7.00,'DISP',3.4,'Lager');
INSERT INTO consumazione (id,user_id,beer_id,quantita,importo,data_consumazione)VALUES(12,'fh9347h0',00123,500,NULL,NOW());
updateConto