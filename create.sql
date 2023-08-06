CREATE TABLE Utente (
	ID VARCHAR(8),
	nome VARCHAR(20) NOT NULL,
	cognome VARCHAR(20),
	email VARCHAR(45),
	saldo INT,
	PRIMARY KEY (ID)
	
);

CREATE TABLE Consumazione(
	ID INT AUTO_INCREMENT PRIMARY KEY,
	beerType ENUM('Lager','Pils','IPA','Stout','Porter','Blanche','Red'),
	quantity INT,
	price INT,
	orderDate TIMESTAMP,
	userID VARCHAR(8),
	FOREIGN KEY (userID) REFERENCES Utente(ID)
);

