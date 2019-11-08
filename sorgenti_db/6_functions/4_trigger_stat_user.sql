--ricalcola il numero di giochi desiderati e posseduti/provati per un certo utente dopo l'inserimento/la cancellazione
CREATE TRIGGER stat_user_users_t AFTER INSERT ON Users FOR EACH ROW EXECUTE PROCEDURE stat_user_update();
--ricalcola il numero di giochi desiderati e posseduti/provati dopo l'inserimento/la cancellazione di un gioco dalla lista dei desiderati
CREATE TRIGGER stat_user_des_t AFTER INSERT OR DELETE ON Desired FOR EACH ROW EXECUTE PROCEDURE stat_user_update();
--ricalcola il numero di giochi desiderati e posseduti/provati dopo l'inserimento/la cancellazione di un gioco dalla lista dei poss/provati
CREATE TRIGGER stat_user_poss_t AFTER INSERT OR DELETE ON HadTried FOR EACH ROW EXECUTE PROCEDURE stat_user_update();

-- N.B.: notare che la DELETE ON User è superflua, in quanto questa scatenerà la DELETE ON DESIRED or HadTried

--ricalcola il numero medio di giochi desiderati e posseduti/provati da tutti gli utenti dopo l'inserimento/la cancellazione di un utente, gioco desiderato o posseduto/provato
CREATE TRIGGER stat_user_avg_users_t AFTER INSERT OR DELETE ON Users FOR EACH ROW EXECUTE PROCEDURE stat_user_avg_update();
CREATE TRIGGER stat_user_avg_des_t AFTER INSERT OR DELETE ON Desired FOR EACH ROW EXECUTE PROCEDURE stat_user_avg_update();
CREATE TRIGGER stat_user_avg_poss_t AFTER INSERT OR DELETE ON HadTried FOR EACH ROW EXECUTE PROCEDURE stat_user_avg_update();

-- N.B.: qui DELETE ON User non è superflua, in quanto un Utente che non ha desiderato nè provato giochi, influisce comunque sul numero medio di giochi des/poss
