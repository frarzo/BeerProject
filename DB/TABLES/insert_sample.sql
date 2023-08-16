USE beer;
--Inserisco Utenti
INSERT INTO Utente(id,nome, cognome, email, psw, saldo, data_reg) VALUES ('fh9347h0','Francesco', 'Arzon', 'franz9700@gmail.com', 'password123', 100.00, '2010-02-06 10:00:00');
INSERT INTO Utente(id,nome, cognome, email, psw, saldo, data_reg) VALUES ('fh9347h0','Mario', 'Rossi', 'mariorossi@mail.com', 'passbella', 123.00, '2012-01-06 10:58:22');
--Inserisco birre tristi
INSERT INTO Birra (id,nome,prezzo_litro,disp,gradi,tipo) VALUES(9999,'Corona',8.00,'DISP',4.5,'Pale Lager');
INSERT INTO Birra (id,nome,prezzo_litro,disp,gradi,tipo) VALUES(00127,'Heineken',7.00,'NON_DISP',3.4,'Lager');
--Inserisco Consumazioni
INSERT INTO consumazione (id,user_id,beer_id,quantita,importo,data_consumazione)VALUES(12,'fh9347h0',00127,500,NULL,NOW());