SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ricovero` (IN `id_reparto1` INTEGER, OUT `msg` VARCHAR(255))  begin
declare liberi integer;
DECLARE MSG1 varchar(255);
declare totali integer;
select num_posti_liberi into liberi from reparto where id_reparto= id_reparto1;
Case liberi  
When 0 then
set msg="posti nel reparto esauriti";
signal sqlstate "45000" set message_text =msg;
when 1 then
update  reparto 
set num_posti_liberi= num_posti_liberi-1,
 num_posti_OCCUPATI= num_posti_occupati+1 where id_reparto= id_reparto1;
 set msg1="posti in esaurimento";
set msg=msg1;
when 2 then
update  reparto 
set num_posti_liberi= num_posti_liberi-1,
 num_posti_OCCUPATI= num_posti_occupati+1 where id_reparto= id_reparto1;
 set msg="posti in esaurimento";
when 3 then
update  reparto 
set num_posti_liberi= num_posti_liberi-1,
 num_posti_OCCUPATI= num_posti_occupati+1 where id_reparto= id_reparto1;
 set msg="posti in esaurimento";
else 
update  reparto 
set num_posti_liberi= num_posti_liberi-1,
 num_posti_OCCUPATI= num_posti_occupati+1 where id_reparto= id_reparto1;
set msg="nessun messaggio ancora piu di tre posti liberi";
end case;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `terapia` (IN `reparto` INTEGER)  begin
select p.nome,p.cognome,nome_farmaco,quantita_giornaliera from farmaci_cartella as f join cartella_Clinica as c on (c.id_cartella=f.id_cartella) join persona as p on (p.cf=c.cf)
where c.id_cartella in
    (select id_cartella from cartella_clinica 
    where id_reparto=reparto and data_fine_ricovero is null);
end$$

DELIMITER ;

CREATE TABLE `cartella_clinica` (
  `id_cartella` int(11) NOT NULL,
  `cf` varchar(16) NOT NULL,
  `data_inizio_ricovero` date NOT NULL,
  `data_fine_ricovero` date DEFAULT NULL,
  `diagnosi` varchar(255) DEFAULT NULL,
  `ananmesi` varchar(255) DEFAULT NULL,
  `id_reparto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `cartella_clinica` (`id_cartella`, `cf`, `data_inizio_ricovero`, `data_fine_ricovero`, `diagnosi`, `ananmesi`, `id_reparto`) VALUES
(1, 'ZYI19RNB3CMIC302', '2019-12-19', '2020-12-04', 'gastrite', 'mal di pancia', 8),
(2, 'ZYI19RNB3CMIC302', '2019-12-01', '2020-12-08', 'gastrite', 'mal di pancia', 1),
(3, 'WJK63COI3ELGD269', '2019-12-25', '2020-12-18', 'gastrite', 'mal di pancia', 9),
(4, 'VRL43VYY0LOBT791', '2020-12-09', NULL, 'rottura dei legamenti', 'mal di ginocchio', 9),
(5, 'XUF72HJJ7CBDC452', '2020-12-10', NULL, '? incinta', 'mal di pancia', 3),
(6, 'LJU13DLM9MYQN884', '2019-12-09', NULL, 'gastrite', 'mal di pancia', 6),
(7, 'FJO19RUJ9PISL500', '2020-12-09', NULL, 'infiammazione della pleula', 'mal di petto', 8),
(8, 'NDG70EKY7XJUL199', '2019-12-06', '2020-12-25', 'infiammazione della pleula', 'mal di petto', 8),
(9, 'CJO10ETV6BPFC863', '2019-12-28', NULL, '? incinta', 'mal di pancia', 3),
(10, 'YWZ78DBB7MVKP305', '2019-12-01', '2020-12-31', 'rottura del menisco', 'mal di ginocchio', 9),
(11, 'LJU13DLM9MYQN884', '2019-12-18', '2020-12-11', 'diabete', 'tanta sete', 1),
(12, 'VZU47NJY5QLZB548', '2019-12-07', '2020-12-20', 'diabete', 'tanta sete', 1),
(21, 'dnrdnl98m11d423b', '2021-06-06', NULL, NULL, 'mal di pancia', 1),
(22, 'albdnl98m11d423b', '2021-06-06', NULL, NULL, 'mal di pancia', 1);
DELIMITER $$
CREATE TRIGGER `trigger_ricovero` BEFORE INSERT ON `cartella_clinica` FOR EACH ROW Begin 
        if(new.data_fine_ricovero is null) then
call ricovero(new.id_reparto,@msg);
        end if;
end
$$
DELIMITER ;

CREATE TABLE `cartella_clinica_farmaco` (
  `id_cartella` int(11) NOT NULL,
  `nome_farmaco` varchar(16) NOT NULL,
  `quantita_giornaliera` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `cartella_clinica_farmaco` (`id_cartella`, `nome_farmaco`, `quantita_giornaliera`) VALUES
(1, 'azactam', 2),
(1, 'elferelgan', 1),
(2, 'azactam', 2),
(3, 'nimesulide', 1),
(3, 'oki', 2),
(4, 'okitask', 1),
(5, 'oki', 1),
(5, 'toradol', 1),
(8, 'tachipirina', 1),
(8, 'toradol', 1),
(12, 'toradol', 1);

CREATE TABLE `esame` (
  `id_esame` int(11) NOT NULL,
  `cf` varchar(16) NOT NULL,
  `tipo_esame` varchar(255) DEFAULT NULL,
  `referto` varchar(255) DEFAULT NULL,
  `data_esame` date DEFAULT NULL,
  `id_medico` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `esame` (`id_esame`, `cf`, `tipo_esame`, `referto`, `data_esame`, `id_medico`) VALUES
(1, 'ZYI19RNB3CMIC302', 'esame del sangue', 'presenta valori alti nel colesterolo', '2020-10-03', 15),
(2, 'ZYI19RNB3CMIC302', 'esame del sangue', 'presenta valori alti nel colesterolo', '2020-10-03', 15),
(3, 'LJU13DLM9MYQN884', 'esame del sangue', 'presenta valori alti nella glicemia', '2020-01-03', 15),
(4, 'NDG70EKY7XJUL199', 'eco doppler al petto', 'presenta un infiammazione alla pleula', '2020-01-03', 16),
(5, 'VRL43VYY0LOBT791', 'raggi x alla gamba', 'presenta la rottura ai legamenti', '2020-12-10', 18),
(6, 'VRL43VYY0LOBT791', 'esami al sangue', 'tutto nella norma', '2018-12-10', 18);

CREATE TABLE `esame_cartella` (
  `id_cartella` int(11) NOT NULL,
  `id_esame` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `esame_cartella` (`id_cartella`, `id_esame`) VALUES
(1, 1),
(2, 2),
(4, 5),
(8, 4);

CREATE TABLE `farmaco` (
  `nome` varchar(16) NOT NULL,
  `bugiardino` varchar(255) DEFAULT NULL,
  `casa_produttrice` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `farmaco` (`nome`, `bugiardino`, `casa_produttrice`) VALUES
('azactam', 'attenzione alle controindicazione', 'frm'),
('biochetasi', 'prendere dopo i pasti', 'meditek'),
('elferelgan', 'analgesico', 'meditek'),
('insulina', 'dopo i pasti', 'bigfarm'),
('nimesulide', 'prendere dopo i pasti', 'bigfarma'),
('oki', 'anti dolorific', 'meditek'),
('okitask', 'azione rapida', 'meditek'),
('tachipirina', 'anlgesico', 'bigfarm'),
('toradol', 'anti dolorifico', 'farma');

CREATE TABLE `impiegato` (
  `ID` int(11) NOT NULL,
  `STIPENDIO` float(10,2) DEFAULT NULL,
  `Anno_inizio` int(11) DEFAULT NULL,
  `cf` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `impiegato` (`ID`, `STIPENDIO`, `Anno_inizio`, `cf`) VALUES
(1, 1400.00, 2019, 'dnrdnl98m11d423b'),
(2, 1400.00, 2000, 'rssmro70m11d423b'),
(3, 1300.00, 2002, 'caippp83m06d423b'),
(4, 1600.00, 2019, 'pltppp99m10d423b'),
(5, 1600.00, 1996, 'mrtppp83m06d423b'),
(6, 1400.00, 1998, 'crsclm83m06d423b'),
(7, 1400.00, 1980, 'admsmt83m55d423b'),
(8, 1300.00, 1985, 'hrrptt83m80d423b'),
(9, 1600.00, 1996, 'wslron83m55d423b'),
(10, 1600.00, 1999, 'jycjms83m41d423b'),
(11, 1400.00, 2010, 'gvnvrg83m55d423b'),
(12, 3000.00, 1999, 'lvrtws83m55d423b'),
(13, 1800.00, 1998, 'dnrfrc83m55d423b'),
(14, 1600.00, 2000, 'HDD44VZA4BUWJ800'),
(15, 1600.00, 1996, 'XSG01CTX1AKDU015'),
(16, 1400.00, 2010, 'ATX73DAE8RNFE344'),
(17, 1400.00, 1980, 'MBE50IIW9RLWA431'),
(18, 1300.00, 1985, 'ERN87TZK4IPXK324'),
(19, 1600.00, 1996, 'PSL64PVD3OAZK600'),
(20, 1400.00, 2019, 'KMA38AXI9GDFM423'),
(21, 1400.00, 2019, 'YTK10ENB7BQUO531'),
(22, 1400.00, 2000, 'RPF56CFQ2QINA932'),
(23, 1300.00, 2002, 'SQT37AQH4QWQV769'),
(24, 1600.00, 2019, 'QKI73ALL4DAAA360'),
(25, 1600.00, 1996, 'EGH55DCZ8PDVS053');

CREATE TABLE `infermiere` (
  `ID_impiegato` int(11) NOT NULL,
  `ID_reparto` int(11) NOT NULL,
  `DATA_AFFERENZA_REPARTO` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `infermiere` (`ID_impiegato`, `ID_reparto`, `DATA_AFFERENZA_REPARTO`) VALUES
(1, 1, '2020-01-08'),
(2, 1, '2006-03-09'),
(3, 2, '2007-05-06'),
(4, 6, '2019-01-08'),
(5, 9, '2015-03-02'),
(6, 8, '1998-08-22');

CREATE TABLE `medico` (
  `ID_impiegato` int(11) NOT NULL,
  `ID_reparto` int(11) NOT NULL,
  `DATA_AFFERENZA_REPARTO` date DEFAULT NULL,
  `specializzazione` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `medico` (`ID_impiegato`, `ID_reparto`, `DATA_AFFERENZA_REPARTO`, `specializzazione`) VALUES
(13, 1, '2020-01-08', 'endocrinologo'),
(14, 3, '2006-03-09', 'ginecologo'),
(15, 2, '2007-05-06', 'generico'),
(16, 8, '2019-01-08', 'cardiologo'),
(17, 9, '2015-03-02', 'endocrinologo'),
(18, 8, '2000-08-30', 'cardiologo'),
(19, 8, '2000-07-18', 'cardiologo');

CREATE TABLE `oss` (
  `ID_impiegato` int(11) NOT NULL,
  `ID_reparto` int(11) NOT NULL,
  `DATA_AFFERENZA_REPARTO` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `oss` (`ID_impiegato`, `ID_reparto`, `DATA_AFFERENZA_REPARTO`) VALUES
(7, 2, '2020-01-08'),
(8, 3, '2006-03-09'),
(9, 7, '2007-05-06'),
(10, 8, '2019-01-08'),
(11, 9, '2015-03-02'),
(12, 8, '2019-01-08');

CREATE TABLE `parcheggio` (
  `num_parcheggio` int(11) NOT NULL,
  `sede` varchar(50) NOT NULL,
  `id_impiegato` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `parcheggio` (`num_parcheggio`, `sede`, `id_impiegato`) VALUES
(1, 'GARIBALDI NESIMA', NULL),
(2, 'GARIBALDI centro', NULL),
(2, 'GARIBALDI NESIMA', NULL),
(3, 'GARIBALDI centro', NULL),
(3, 'GARIBALDI NESIMA', NULL),
(4, 'GARIBALDI centro', NULL),
(4, 'GARIBALDI librino', NULL),
(4, 'GARIBALDI NESIMA', NULL),
(5, 'GARIBALDI centro', NULL),
(5, 'GARIBALDI NESIMA', NULL),
(6, 'GARIBALDI centro', NULL),
(6, 'GARIBALDI librino', NULL),
(7, 'GARIBALDI centro', NULL),
(7, 'GARIBALDI librino', NULL),
(7, 'GARIBALDI NESIMA', NULL),
(8, 'GARIBALDI centro', NULL),
(8, 'GARIBALDI librino', NULL),
(8, 'GARIBALDI NESIMA', NULL),
(9, 'GARIBALDI centro', NULL),
(9, 'GARIBALDI librino', NULL),
(9, 'GARIBALDI NESIMA', NULL),
(10, 'GARIBALDI centro', NULL),
(10, 'GARIBALDI librino', NULL),
(10, 'GARIBALDI NESIMA', NULL),
(11, 'GARIBALDI centro', NULL),
(11, 'GARIBALDI librino', NULL),
(11, 'GARIBALDI NESIMA', NULL),
(12, 'GARIBALDI centro', NULL),
(12, 'GARIBALDI librino', NULL),
(12, 'GARIBALDI NESIMA', NULL),
(13, 'GARIBALDI centro', NULL),
(13, 'GARIBALDI librino', NULL),
(13, 'GARIBALDI NESIMA', NULL),
(14, 'GARIBALDI centro', NULL),
(14, 'GARIBALDI librino', NULL),
(15, 'GARIBALDI centro', NULL),
(15, 'GARIBALDI librino', NULL),
(15, 'GARIBALDI NESIMA', NULL),
(16, 'GARIBALDI centro', NULL),
(16, 'GARIBALDI librino', NULL),
(16, 'GARIBALDI NESIMA', NULL),
(17, 'GARIBALDI centro', NULL),
(17, 'GARIBALDI librino', NULL),
(17, 'GARIBALDI NESIMA', NULL),
(18, 'GARIBALDI centro', NULL),
(18, 'GARIBALDI librino', NULL),
(18, 'GARIBALDI NESIMA', NULL),
(19, 'GARIBALDI centro', NULL),
(19, 'GARIBALDI librino', NULL),
(19, 'GARIBALDI NESIMA', NULL),
(20, 'GARIBALDI centro', NULL),
(20, 'GARIBALDI librino', NULL),
(20, 'GARIBALDI NESIMA', NULL),
(2, 'GARIBALDI librino', 1),
(5, 'GARIBALDI librino', 2),
(1, 'GARIBALDI librino', 4),
(1, 'GARIBALDI centro', 5),
(3, 'GARIBALDI librino', 6),
(14, 'GARIBALDI NESIMA', 8),
(6, 'GARIBALDI NESIMA', 22);

CREATE TABLE `persona` (
  `cf` varchar(16) NOT NULL,
  `nome` varchar(20) NOT NULL,
  `psw` varchar(100) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `img` varchar(60) DEFAULT NULL,
  `cognome` varchar(20) NOT NULL,
  `Data_Di_Nascita` date DEFAULT NULL,
  `citta` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `persona` (`cf`, `nome`, `psw`, `email`, `img`, `cognome`, `Data_Di_Nascita`, `citta`) VALUES
(' rssmro70m11d423', 'mario', 'Danilu98', 'danix9876@gmail.com', 'NULL', 'rossi', '1970-06-06', 'milan'),
('admsmt83m55d423b', 'adam', NULL, NULL, NULL, 'smith', '1955-07-15', 'new york'),
('AKF02NOE1ONQR962', 'Ethan', NULL, NULL, NULL, 'Myers', '1960-11-15', 'Mineo'),
('albdnl98m11d423b', 'alberto', NULL, 'danix9876@gmail.com', NULL, 'sava', '1994-08-12', 'Caltagirone'),
('anddnl98m11d423b', 'Andrea', 'Danilu98', 'danix9876@gmail.com', 'NULL', 'Di Nora', '1998-08-11', 'Calta'),
('ATX73DAE8RNFE344', 'Jasper', NULL, NULL, NULL, 'Gross', '1989-07-04', 'caltagirone'),
('caippp83m06d423b', 'pippo', NULL, NULL, NULL, 'caio', '1983-06-06', 'catania'),
('CJO10ETV6BPFC863', 'Cairo', NULL, NULL, NULL, 'Drake', '2002-11-26', 'catania'),
('crsclm83m06d423b', 'cristoforo', NULL, NULL, NULL, 'colombo', '1940-08-13', 'acireale'),
('dnenmi98m11d423b', 'Noemi', 'Danilu98', 'danix9876@gmail.com', 'NULL', 'Di Nora', '1998-08-11', 'Calta'),
('dnrdnl98m11d423b', 'daniel', '123', 'danix9876@gmail.com', '/hw2/storage/app/imageProfile/dnrdnl98m11d423b.jpg', 'di nora', '1998-08-11', 'caltagirone'),
('dnrfrc83m55d423b', 'francesco', NULL, NULL, NULL, 'di nora', '1966-03-15', 'caltagirone'),
('EGH55DCZ8PDVS053', 'Ralph', NULL, NULL, NULL, 'Stafford', '1964-07-09', 'agrigento'),
('ERN87TZK4IPXK324', 'Teegan', NULL, NULL, NULL, 'Mccullough', '1967-03-02', 'palermo'),
('FJO19RUJ9PISL500', 'Pascale', NULL, NULL, NULL, 'Bonner', '1997-02-23', 'catania'),
('gvnvrg83m55d423b', 'giovanni', NULL, NULL, NULL, 'verga', '1990-09-01', 'vizzini'),
('HDD44VZA4BUWJ800', 'Naida', NULL, NULL, NULL, 'Wade', '1957-01-08', 'Catanzaro'),
('hrrptt83m80d423b', 'harry', 'Harrypotter98', 'harry@gmail.com', '/hw2/storage/app/imageProfile/hrrptt83m80d423b.jpg', 'potter', '1980-12-31', 'catania'),
('jycjms83m41d423b', 'james', NULL, NULL, NULL, 'joyce', '1941-01-13', 'dublino'),
('KMA38AXI9GDFM423', 'Audra', NULL, NULL, NULL, 'Rowland', '1982-09-16', 'palermo'),
('KOG38NWG7JCVM221', 'Colton', NULL, NULL, NULL, 'Knox', '1960-10-29', 'catania'),
('LJU13DLM9MYQN884', 'Blake', NULL, NULL, NULL, 'Merrill', '1978-11-13', 'Isnes'),
('lvrtws83m55d423b', 'oliver', NULL, NULL, NULL, 'twist', '1965-07-15', 'new york'),
('MBE50IIW9RLWA431', 'Alan', NULL, NULL, NULL, 'Lynn', '1975-06-06', 'caltagirone'),
('mrtppp83m06d423b', 'marta', NULL, NULL, NULL, 'caio', '1955-12-18', 'catania'),
('NDG70EKY7XJUL199', 'Chadwick', NULL, NULL, NULL, 'Le', '1971-03-18', 'catania'),
('pltppp99m10d423b', 'pluto', NULL, NULL, NULL, 'caio', '1999-04-10', 'palermo'),
('PSL64PVD3OAZK600', 'Isabelle', NULL, NULL, NULL, 'Daniel', '1993-04-06', 'palermo'),
('QKI73ALL4DAAA360', 'Donovan', NULL, NULL, NULL, 'Roman', '2005-02-08', 'bari'),
('RPF56CFQ2QINA932', 'Chelsea', '123', NULL, '/hw2/storage/app/imageProfile/RPF56CFQ2QINA932.jpg', 'Kerr', '1997-06-24', 'agrigento'),
('rssmro70m11d423b', 'mario', 'Danilu98', 'danix9876@gmail.com', '/hw2/storage/app/imageProfile/rssmro70m11d423b.jpg', 'rossi', '1970-06-06', 'milano'),
('rssmro70m11d456h', 'marione', 'Danilu98', 'danix9876@gmail.com', NULL, 'verde', '1970-03-05', 'milano'),
('sclmrt99c60b428a', 'marta', 'martaS99', 'scollomarta869@gmail.com', 'NULL', 'scollo', '1999-03-20', 'Caltagirone'),
('SQT37AQH4QWQV769', 'Brielle', NULL, NULL, NULL, 'Osborn', '1975-03-15', 'agrigento'),
('VRL43VYY0LOBT791', 'Ronan', NULL, NULL, NULL, 'Lamb', '1997-01-08', 'Mineo'),
('VZU47NJY5QLZB548', 'Addison', NULL, NULL, NULL, 'Kemp', '1959-05-16', 'Mineo'),
('WJK63COI3ELGD269', 'Holmes', NULL, NULL, NULL, 'Riddle', '1968-04-12', 'Mineo'),
('wslron83m55d423b', 'ron', NULL, NULL, NULL, 'weasly', '1980-12-07', 'napoli'),
('XSG01CTX1AKDU015', 'Shana', NULL, NULL, NULL, 'Bernard', '1955-03-02', 'caltagirone'),
('XUF72HJJ7CBDC452', 'Dakota', NULL, NULL, NULL, 'Hughes', '1999-03-12', 'Mineo'),
('YTK10ENB7BQUO531', 'Barrett', NULL, NULL, NULL, 'Charles', '1983-03-29', 'agrigento'),
('YWZ78DBB7MVKP305', 'Leigh', NULL, NULL, NULL, 'Mason', '1953-02-02', 'catania'),
('ZYI19RNB3CMIC302', 'Fitzgerald', '123', NULL, NULL, 'Frazier', '1969-12-05', 'Mineo');

CREATE TABLE `posizione` (
  `stanza` int(11) NOT NULL,
  `piano` int(11) NOT NULL,
  `sede` varchar(50) NOT NULL,
  `id_reparto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `posizione` (`stanza`, `piano`, `sede`, `id_reparto`) VALUES
(1, 2, 'GARIBALDI NESIMA', 1),
(3, 3, 'GARIBALDI NESIMA', 2),
(4, 2, 'GARIBALDI NESIMA', 3),
(4, 2, 'GARIBALDI centro', 4),
(5, 2, 'GARIBALDI centro', 5),
(5, 2, 'GARIBALDI librino', 6),
(6, 2, 'GARIBALDI librino', 7),
(7, 1, 'GARIBALDI librino', 8);

CREATE TABLE `reparto` (
  `id_reparto` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `sede` varchar(50) NOT NULL,
  `num_imp` int(11) DEFAULT NULL,
  `num_posti_liberi` int(11) DEFAULT NULL,
  `num_posti_tot` int(11) DEFAULT NULL,
  `num_posti_occupati` int(11) DEFAULT NULL,
  `caposala` int(11) NOT NULL,
  `primario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `reparto` (`id_reparto`, `nome`, `sede`, `num_imp`, `num_posti_liberi`, `num_posti_tot`, `num_posti_occupati`, `caposala`, `primario`) VALUES
(1, 'endocrinologia', 'GARIBALDI NESIMA', 4, 27, 30, 3, 1, 7),
(2, 'ortopedia', 'GARIBALDI NESIMA', 2, 10, 10, 0, 3, 8),
(3, 'ginecologia', 'GARIBALDI NESIMA', 3, 38, 40, 2, 4, 9),
(4, 'utic', 'GARIBALDI centro', 1, 20, 20, 0, 5, 10),
(5, 'ortopedia', 'GARIBALDI centro', 1, 10, 10, 0, 6, 11),
(6, 'endocnologia', 'GARIBALDI librino', 2, 19, 20, 1, 6, 12),
(7, 'terapia intensiva', 'GARIBALDI librino', 4, 20, 20, 0, 1, 11),
(8, 'cardiologia', 'GARIBALDI librino', 8, 19, 20, 1, 2, 11),
(9, 'Neurochirurgia', 'GARIBALDI centro', 4, 19, 20, 1, 3, 11);

CREATE TABLE `scatola_del_farmaco` (
  `id_scatola` int(11) NOT NULL,
  `farmaco` varchar(16) NOT NULL,
  `quantita_rim` int(11) DEFAULT NULL,
  `id_reparto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `scatola_del_farmaco` (`id_scatola`, `farmaco`, `quantita_rim`, `id_reparto`) VALUES
(1, 'elferelgan', 8, 1),
(2, 'oki', 10, 2),
(3, 'biochetasi', 9, 3),
(4, 'toradol', 7, 4),
(5, 'nimesulide', 6, 5),
(6, 'okitask', 6, 6),
(7, 'azactam', 5, 7),
(8, 'tachipirina', 5, 8),
(9, 'azactam', 5, 9),
(10, 'insulina', 5, 1),
(11, 'toradol', 7, 3);

CREATE TABLE `sede` (
  `nome` varchar(50) NOT NULL,
  `via` varchar(50) DEFAULT NULL,
  `citta` varchar(20) DEFAULT NULL,
  `anno_apertura` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `sede` (`nome`, `via`, `citta`, `anno_apertura`) VALUES
('GARIBALDI CENTRO', 'PIAZZA SANTA MARIA DI GESU 5', 'Catania', 1990),
('GARIBALDI LIBRINO', 'LIBRINO', 'Catania', 1995),
('GARIBALDI NESIMA', 'VIA NESIMA 10', 'Catania', 2005);

CREATE TABLE `servizi` (
  `Nome` varchar(50) NOT NULL,
  `reparto` int(11) NOT NULL,
  `image` varchar(50) DEFAULT NULL,
  `Descrizione` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `servizi` (`Nome`, `reparto`, `image`, `Descrizione`) VALUES
('Bypass aortocoronarico', 8, 'image/Bypass.jpg ', 'L intervento di bypass crea una strada alternativa'),
('Chirurgia conservativa del ginocchio', 2, 'image/ginocchio.jpg', 'Riparazione dei legamenti collaterali'),
('Chirurgia della mano', 2, 'image/Mano.jpg', 'Liberazione del Tunnel Carpale'),
('Chirurgia protesica del ginocchio', 2, 'image/ginocchio2.jpg', 'Sostituzione totale del ginocchio'),
('Controllo dell insulina', 1, 'image/insulina.jpg', 'L insulina regola la quantit? di glucosio nel sangue'),
('Elettrocardiogramma', 8, 'image/ecg.jpg', 'Permette al cardiologo di rilevare aritmie cardiache'),
('Esame alla tiroide', 1, 'image/EsameTiroide.jpg', 'Eseguito con macchine all avanguardia'),
('Interventi di cranioplastica', 9, 'image/cranioPlastica.jpg', 'Eseguito con macchine all avanguardia'),
('Neoplasie', 9, 'image/neoplasiaCerebrale.jpg', 'Microchirurgia in urgenza ed in elezione delle neoplasie benigne e maligne'),
('Patologia degenerativa', 9, 'image/neuroSchiena.jpg', 'Microchirurgia delle ernie discali lombari, dorsali e cervicali'),
('Rimozione tiroide', 1, 'image/RimozioneTiroide.jpg', 'L asportazione della tiroide pu? essere parziale'),
('Sostituzione della valvola mitrale', 8, 'image/ValvolaMitrale.jpg', 'La valvola mitrale,si trova tra l atrio e il ventricolo sinistri');

CREATE TABLE `storico_infermiere` (
  `ID_infermiere` int(11) NOT NULL,
  `ID_reparto` int(11) NOT NULL,
  `DATA_INIZIO` date NOT NULL,
  `DATA_FINE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `storico_infermiere` (`ID_infermiere`, `ID_reparto`, `DATA_INIZIO`, `DATA_FINE`) VALUES
(2, 1, '2005-03-09', '2006-03-09'),
(2, 3, '2000-03-09', '2005-03-09'),
(3, 3, '2002-05-06', '2007-05-06'),
(5, 2, '1996-03-02', '2002-03-02'),
(5, 3, '2002-03-02', '2015-03-02');

CREATE TABLE `storico_medico` (
  `ID_medico` int(11) NOT NULL,
  `ID_reparto` int(11) NOT NULL,
  `DATA_INIZIO` date DEFAULT NULL,
  `DATA_FINE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `storico_medico` (`ID_medico`, `ID_reparto`, `DATA_INIZIO`, `DATA_FINE`) VALUES
(13, 2, '2010-01-08', '2020-01-08'),
(13, 9, '1998-01-08', '2010-01-08'),
(14, 4, '2000-03-09', '2006-03-09'),
(15, 3, '1996-03-09', '2002-03-09'),
(15, 8, '1996-03-09', '2002-03-09'),
(16, 3, '2010-03-09', '2019-01-08'),
(17, 4, '2004-05-06', '2015-03-02'),
(17, 5, '1980-05-06', '2004-05-06'),
(18, 6, '1985-05-06', '2000-08-29'),
(19, 2, '1996-03-02', '2000-07-17');

CREATE TABLE `storico_oss` (
  `ID_oss` int(11) NOT NULL,
  `ID_reparto` int(11) NOT NULL,
  `DATA_INIZIO` date DEFAULT NULL,
  `DATA_FINE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `storico_oss` (`ID_oss`, `ID_reparto`, `DATA_INIZIO`, `DATA_FINE`) VALUES
(7, 4, '1980-01-08', '2020-01-08'),
(8, 7, '1985-01-08', '2006-03-08'),
(9, 4, '1996-03-09', '2007-05-06'),
(10, 3, '1999-03-09', '2002-03-09'),
(11, 6, '2010-03-09', '2015-03-01'),
(12, 3, '1999-03-09', '2019-01-08');

CREATE TABLE `tecnico` (
  `ID_impiegato` int(11) NOT NULL,
  `specializzazione` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `tecnico` (`ID_impiegato`, `specializzazione`) VALUES
(20, 'informatico'),
(21, 'elettricista'),
(22, 'ascensorista'),
(23, 'informatico'),
(24, 'ascensorista'),
(25, 'elettricista');

CREATE TABLE `tecnico_reparti` (
  `ID_tecnico` int(11) NOT NULL,
  `ID_reparto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `tecnico_reparti` (`ID_tecnico`, `ID_reparto`) VALUES
(20, 1),
(20, 3),
(21, 4),
(21, 5),
(22, 6),
(22, 7),
(23, 8),
(23, 9),
(24, 8),
(25, 7);


ALTER TABLE `cartella_clinica`
  ADD PRIMARY KEY (`id_cartella`),
  ADD KEY `cartella_clinica_ibfk_1` (`id_reparto`),
  ADD KEY `cartella_clinica_ibfk_2` (`cf`);

ALTER TABLE `cartella_clinica_farmaco`
  ADD PRIMARY KEY (`id_cartella`,`nome_farmaco`),
  ADD KEY `idx_cartella` (`id_cartella`),
  ADD KEY `idx_nome_farmaco` (`nome_farmaco`);

ALTER TABLE `esame`
  ADD PRIMARY KEY (`id_esame`),
  ADD KEY `idx_medico` (`id_medico`),
  ADD KEY `idx_cf` (`cf`);

ALTER TABLE `esame_cartella`
  ADD PRIMARY KEY (`id_cartella`,`id_esame`),
  ADD KEY `idx_cartella` (`id_cartella`),
  ADD KEY `idx_id_esame` (`id_esame`);

ALTER TABLE `farmaco`
  ADD PRIMARY KEY (`nome`);

ALTER TABLE `impiegato`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `idx_cf` (`cf`);

ALTER TABLE `infermiere`
  ADD PRIMARY KEY (`ID_impiegato`),
  ADD KEY `idx_reparto` (`ID_reparto`),
  ADD KEY `idx_id_impiegato` (`ID_impiegato`);

ALTER TABLE `medico`
  ADD PRIMARY KEY (`ID_impiegato`),
  ADD KEY `idx_id_impiegato` (`ID_impiegato`),
  ADD KEY `idx_reparto` (`ID_reparto`);

ALTER TABLE `oss`
  ADD PRIMARY KEY (`ID_impiegato`),
  ADD KEY `idx_id_impiegato` (`ID_impiegato`),
  ADD KEY `idx_reparto` (`ID_reparto`);

ALTER TABLE `parcheggio`
  ADD PRIMARY KEY (`num_parcheggio`,`sede`),
  ADD KEY `idx_sede` (`sede`),
  ADD KEY `idx_impiegato` (`id_impiegato`);

ALTER TABLE `persona`
  ADD PRIMARY KEY (`cf`);

ALTER TABLE `posizione`
  ADD PRIMARY KEY (`sede`,`stanza`,`piano`),
  ADD KEY `idx_reparto` (`id_reparto`),
  ADD KEY `idx_sede` (`sede`);

ALTER TABLE `reparto`
  ADD PRIMARY KEY (`id_reparto`),
  ADD KEY `idx_sede` (`sede`);

ALTER TABLE `scatola_del_farmaco`
  ADD PRIMARY KEY (`id_scatola`),
  ADD KEY `idx_farmaco` (`farmaco`),
  ADD KEY `idx_reparto` (`id_reparto`);

ALTER TABLE `sede`
  ADD PRIMARY KEY (`nome`);

ALTER TABLE `servizi`
  ADD PRIMARY KEY (`Nome`,`reparto`),
  ADD KEY `idx_reparto` (`reparto`),
  ADD KEY `idx_nome` (`Nome`);

ALTER TABLE `storico_infermiere`
  ADD PRIMARY KEY (`ID_infermiere`,`ID_reparto`,`DATA_INIZIO`),
  ADD KEY `idx_id_infermiere` (`ID_infermiere`),
  ADD KEY `idx_reparto` (`ID_reparto`);

ALTER TABLE `storico_medico`
  ADD PRIMARY KEY (`ID_medico`,`ID_reparto`),
  ADD KEY `idx_id_medico` (`ID_medico`),
  ADD KEY `idx_reparto` (`ID_reparto`);

ALTER TABLE `storico_oss`
  ADD PRIMARY KEY (`ID_oss`,`ID_reparto`),
  ADD KEY `idx_id_oss` (`ID_oss`),
  ADD KEY `idx_reparto` (`ID_reparto`);

ALTER TABLE `tecnico`
  ADD PRIMARY KEY (`ID_impiegato`),
  ADD KEY `idx_id_impiegato` (`ID_impiegato`);

ALTER TABLE `tecnico_reparti`
  ADD PRIMARY KEY (`ID_tecnico`,`ID_reparto`),
  ADD KEY `idx_id_tecnico` (`ID_tecnico`),
  ADD KEY `idx_reparto` (`ID_reparto`);


ALTER TABLE `cartella_clinica`
  MODIFY `id_cartella` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;


ALTER TABLE `cartella_clinica`
  ADD CONSTRAINT `cartella_clinica_ibfk_1` FOREIGN KEY (`id_reparto`) REFERENCES `reparto` (`id_reparto`),
  ADD CONSTRAINT `cartella_clinica_ibfk_2` FOREIGN KEY (`cf`) REFERENCES `persona` (`cf`);

ALTER TABLE `cartella_clinica_farmaco`
  ADD CONSTRAINT `cartella_clinica_farmaco_ibfk_1` FOREIGN KEY (`id_cartella`) REFERENCES `cartella_clinica` (`id_cartella`),
  ADD CONSTRAINT `cartella_clinica_farmaco_ibfk_2` FOREIGN KEY (`nome_farmaco`) REFERENCES `farmaco` (`nome`);

ALTER TABLE `esame`
  ADD CONSTRAINT `esame_ibfk_1` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`ID_impiegato`),
  ADD CONSTRAINT `esame_ibfk_2` FOREIGN KEY (`cf`) REFERENCES `persona` (`cf`);

ALTER TABLE `esame_cartella`
  ADD CONSTRAINT `esame_cartella_ibfk_1` FOREIGN KEY (`id_cartella`) REFERENCES `cartella_clinica` (`id_cartella`),
  ADD CONSTRAINT `esame_cartella_ibfk_2` FOREIGN KEY (`id_esame`) REFERENCES `esame` (`id_esame`);

ALTER TABLE `impiegato`
  ADD CONSTRAINT `impiegato_ibfk_1` FOREIGN KEY (`cf`) REFERENCES `persona` (`cf`);

ALTER TABLE `infermiere`
  ADD CONSTRAINT `infermiere_ibfk_1` FOREIGN KEY (`ID_impiegato`) REFERENCES `impiegato` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `infermiere_ibfk_2` FOREIGN KEY (`ID_reparto`) REFERENCES `reparto` (`id_reparto`);

ALTER TABLE `medico`
  ADD CONSTRAINT `medico_ibfk_1` FOREIGN KEY (`ID_impiegato`) REFERENCES `impiegato` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `medico_ibfk_2` FOREIGN KEY (`ID_reparto`) REFERENCES `reparto` (`id_reparto`);

ALTER TABLE `oss`
  ADD CONSTRAINT `oss_ibfk_1` FOREIGN KEY (`ID_impiegato`) REFERENCES `impiegato` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `oss_ibfk_2` FOREIGN KEY (`ID_reparto`) REFERENCES `reparto` (`id_reparto`);

ALTER TABLE `parcheggio`
  ADD CONSTRAINT `parcheggio_ibfk_1` FOREIGN KEY (`sede`) REFERENCES `sede` (`nome`),
  ADD CONSTRAINT `parcheggio_ibfk_2` FOREIGN KEY (`id_impiegato`) REFERENCES `impiegato` (`ID`) ON DELETE SET NULL;

ALTER TABLE `posizione`
  ADD CONSTRAINT `posizione_ibfk_1` FOREIGN KEY (`sede`) REFERENCES `sede` (`nome`),
  ADD CONSTRAINT `posizione_ibfk_2` FOREIGN KEY (`id_reparto`) REFERENCES `reparto` (`id_reparto`);

ALTER TABLE `reparto`
  ADD CONSTRAINT `reparto_ibfk_1` FOREIGN KEY (`sede`) REFERENCES `sede` (`nome`);

ALTER TABLE `scatola_del_farmaco`
  ADD CONSTRAINT `scatola_del_farmaco_ibfk_1` FOREIGN KEY (`farmaco`) REFERENCES `farmaco` (`nome`),
  ADD CONSTRAINT `scatola_del_farmaco_ibfk_2` FOREIGN KEY (`id_reparto`) REFERENCES `reparto` (`id_reparto`);

ALTER TABLE `servizi`
  ADD CONSTRAINT `servizi_ibfk_1` FOREIGN KEY (`reparto`) REFERENCES `reparto` (`id_reparto`);

ALTER TABLE `storico_infermiere`
  ADD CONSTRAINT `storico_infermiere_ibfk_1` FOREIGN KEY (`ID_infermiere`) REFERENCES `impiegato` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `storico_infermiere_ibfk_2` FOREIGN KEY (`ID_reparto`) REFERENCES `reparto` (`id_reparto`);

ALTER TABLE `storico_medico`
  ADD CONSTRAINT `storico_medico_ibfk_1` FOREIGN KEY (`ID_medico`) REFERENCES `medico` (`ID_impiegato`) ON DELETE CASCADE,
  ADD CONSTRAINT `storico_medico_ibfk_2` FOREIGN KEY (`ID_reparto`) REFERENCES `reparto` (`id_reparto`);

ALTER TABLE `storico_oss`
  ADD CONSTRAINT `storico_oss_ibfk_1` FOREIGN KEY (`ID_oss`) REFERENCES `oss` (`ID_impiegato`) ON DELETE CASCADE,
  ADD CONSTRAINT `storico_oss_ibfk_2` FOREIGN KEY (`ID_reparto`) REFERENCES `reparto` (`id_reparto`);

ALTER TABLE `tecnico`
  ADD CONSTRAINT `tecnico_ibfk_1` FOREIGN KEY (`ID_impiegato`) REFERENCES `impiegato` (`ID`) ON DELETE CASCADE;

ALTER TABLE `tecnico_reparti`
  ADD CONSTRAINT `tecnico_reparti_ibfk_1` FOREIGN KEY (`ID_tecnico`) REFERENCES `tecnico` (`ID_impiegato`) ON DELETE CASCADE,
  ADD CONSTRAINT `tecnico_reparti_ibfk_2` FOREIGN KEY (`ID_reparto`) REFERENCES `reparto` (`id_reparto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
