


-- 2 Script contendo o código SQL da criação do modelo físico
create database ProjetoIntegrador4;
use ProjetoIntegrador4;
-- drop database projetointegrador4;


-- 3 Acrescentar as restriçoes de integridade do modelo definindo campos 
--   unique, not null, valores defaut e restriçoes de integridade referencial
-- -----------------------------------------------------
CREATE TABLE Usuario (
  idUsuario INT  primary key auto_increment NULL,
  nome VARCHAR(45) NOT NULL,
  perfil_usuario VARCHAR(45) NULL,
  senha VARCHAR(45) NOT NULL unique,
  cpf VARCHAR(45) NOT NULL unique,
  email VARCHAR(45) NOT NULL unique,
  login VARCHAR(45) NOT NULL unique);  
 -- -----------------------------------------------------

CREATE TABLE Fazenda (
  idFazenda INT primary key auto_increment NOT NULL,
  nome VARCHAR(45) NOT NULL,
  longitude VARCHAR(45) NOT NULL,
  latitude VARCHAR(45) NOT NULL,
  Usuario_idUsuario INT NOT NULL,
  foreign key (Usuario_idUsuario) references Usuario(idUsuario)
  );
  
-- -----------------------------------------------------
CREATE TABLE Pagamento (
  idPagamento INT primary key auto_increment NULL,
  numeroPrestacao VARCHAR(45) not NULL);
-- -----------------------------------------------------

CREATE TABLE Orcamento (
  idOrcamento INT primary key auto_increment NULL,
  preco NUMERIC(7,2) NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  dataOrcamento DATE NOT NULL,
  Proposta_idProposta INT
  );
  
-- --------------------------------------------------- --

CREATE TABLE Proposta (
  idProposta INT primary key auto_increment NULL,
  nome VARCHAR(45) NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  prazo VARCHAR(45) NOT NULL,
  coordenadaFazenda VARCHAR(45) NOT NULL,
  Orcamento_idOrcamento INT NOT NULL, 
  Fazenda_IdFazenda INT NOT NULL,
  foreign key (Fazenda_IdFazenda) references Fazenda (idFazenda),
  Pagamento_idPagamento INT NOT NULL,
  foreign key (Pagamento_idPagamento) references pagamento(idPagamento)
  );
  
-- --------------------------------------------------------

-- 4 Efetuar a carga de dados nas tabelas simulando dados reais de 5 a 10 registros por tabela

insert into Usuario (nome, perfil_usuario, senha, cpf, email, login)
	values     ('Breno', 'Prestador', '001', '000000000-01', 'breno@gmail.com', 'breno'),
               ('Andre', 'Cliente', '002', '000000000-02', 'andre@gmail.com', 'andre'),
               ('Roberto', 'Cliente','003', '000000000-03', 'roberto@gmail.com', 'roberto'),
               ('Eloah', 'Prestador', '004', '000000000-04', 'eloah@gmail.com', 'eloah'),
               ('Crícia', 'Prestador', '005', '000000000-05', 'cricia@gmail.com', 'cricia');
               
insert into Fazenda (nome, longitude, latitude, Usuario_idUsuario)
	values     ('Brenopolis', '22º 55 S', '22º 54 N', '1'),
               ('andrepolis', '12º 36 N', '18º 98 L', '2'),
               ('robertopolis', '8º 98 L', '77º 07 N', '3'),
               ('eloahpolis', '35º 91 S', '58º 81 L', '4'),
               ('criciapolis', '11º 90 O', '88º 38 S', '5');                             
               
insert into Pagamento (numeroPrestacao)
	values     ('10'),
               ('5'),
               ('6'),
               ('1'),
               ('2');              
               
insert into Orcamento (preco, descricao, dataOrcamento, Proposta_idProposta)
	values     ('2.000.00', 'plantio milho', '2017-05-13', '001'),
               ('5.000,00', 'gradear terra', '2018-07-18', '002'),
               ('3,500,00', 'colheita arroz', '2018-09-25', '003'),
               ('2,500,00', 'plantio feijão', '2018-03-05', '004'),
               ('3,500,00', 'colheita soja', '2018-09-01', '005');
  
insert into  Proposta(nome, descricao, prazo, coordenadaFazenda, Orcamento_idOrcamento,Fazenda_IdFazenda, Pagamento_idPagamento )
	values     ('milho', 'plantio milho', '90 dias', '95° 25 S', '1', '1', '1'),
               ('preparo terra', 'gradear terra', '10 dias', '15° 15 L', '2', '2', '2'),
               ('arroz ', 'colheita arroz', '120 dias', '05° 15 N', '3', '3', '3'),
               ('feijao', 'plantio feijão', '80 dias', '48° 28 S', '4', '4', '4'),
               ('soja', 'colheita soja', '150 dias', '72° 42 O', '5', '5', '5');              
         
Alter table Proposta add foreign key (Orcamento_idOrcamento) references Orcamento(idOrcamento);
ALTER TABLE Orcamento ADD FOREIGN KEY(Proposta_idProposta) references Proposta(idProposta);

select * from usuario;
select * from fazenda ;
select * from pagamento;
select * from proposta;
select * from orcamento;
-- 5 Dê exemplos de relátorios sobre dados ao menos 5 Utilize junção de tabelas, 
-- funcões agregadas, cláusulas group by, etc.alter

  -- 001  Listar os nomes dos usuários, fazenda  em ordem alfabetica 
  select u.nome, u.cpf, u.email, f.nome nomeFazenda
  from fazenda f 
  inner join usuario u
  on u.idUsuario=f.Usuario_idUsuario
  group by u.nome;
  select * from fazenda;
  select * from usuario;
  
  
  -- 002  Listar os nomes dos usuario que forem prestador com o nome da fazenda e a descrição da proposta  ordenando pela descrição
  select u. idUsuario, u.nome, u.cpf, u.perfil_usuario perfil, f.nome, p.descricao Descriçao_da_Proposta
  from orcamento o 
  inner join proposta p 
  on o.idOrcamento = p.orcamento_idOrcamento
  inner join fazenda f 
  on f.idFazenda = p.fazenda_idFazenda
  inner join usuario u 
  on u.idUsuario = f.Usuario_idUsuario
  where u.perfil_usuario = 'Prestador'
  order by p.descricao;

-- 003 Lista o menor preco, maior valor 
	select u.nome, u.email,  min(o.preco) MenorPreco, max(o.preco) MaiorValor
    from usuario u 
    inner join fazenda f 
    on u.IdUsuario= f.Usuario_IdUsuario
    inner join proposta p 
    on f.idFazenda = p.Fazenda_idFazenda
    inner join orcamento o 
    on o.idOrcamento=p.Orcamento_idOrcamento;
 
 -- 004  Listar o nome valor e o id de cada usuario maior que 1 
	select u. idUsuario, u.nome, u.perfil_usuario, f.nome, p.descricao, o.preco, pg.numeroPrestacao, o.dataOrcamento, p.prazo
	from usuario u 
    inner join fazenda f 
    on u.IdUsuario= f.Usuario_IdUsuario
    inner join proposta p 
    on f.idFazenda = p.Fazenda_idFazenda
    inner join orcamento o 
    on o.idOrcamento=p.Orcamento_idOrcamento
    inner join pagamento pg
    on pg.idPagamento= p.Pagamento_idPagamento
    where u.idUsuario > 1;
    
  -- 005 Listar a descricao da proposta que tem o menor prazo
    select f.nome NomeFazenda , p.descricao, min(p.prazo) MenorPrazo, f.nome NomeFazenda, p.coordenadaFazenda
    from  proposta p 
    inner join fazenda f 
    on p.Fazenda_idFazenda = f.idFazenda;
    
-- 6 Dê exemplos de consultas usando operador UNIONN ano menos  3
  -- 001 Listar os dois maiores valores de e os dois menores valores sem duplicatas
	(select u.nome, o.preco preço
    from usuario u 
    inner join fazenda f 
    on u.IdUsuario= f.Usuario_IdUsuario
    inner join proposta p 
    on f.idFazenda = p.Fazenda_idFazenda
    inner join orcamento o 
    on o.idOrcamento=p.Orcamento_idOrcamento
    order by o.preco desc
    limit 2
	)
	UNION 
    (select u.nome, o.preco Preco
    from usuario u 
    inner join fazenda f 
    on u.IdUsuario= f.Usuario_IdUsuario
    inner join proposta p 
    on f.idFazenda = p.Fazenda_idFazenda
    inner join orcamento o 
    on o.idOrcamento=p.Orcamento_idOrcamento
    order by o.preco asc
    limit 2
	);	


	-- 002 Listar os dois maiores valores de e os dois menores valores com duplicatas
	(select u.nome, o.preco preço
    from usuario u 
    inner join fazenda f 
    on u.IdUsuario= f.Usuario_IdUsuario
    inner join proposta p 
    on f.idFazenda = p.Fazenda_idFazenda
    inner join orcamento o 
    on o.idOrcamento=p.Orcamento_idOrcamento
    order by o.preco desc
    limit 3
	)
	UNION all 
    (select u.nome, o.preco Preco
    from usuario u 
    inner join fazenda f 
    on u.IdUsuario= f.Usuario_IdUsuario
    inner join proposta p 
    on f.idFazenda = p.Fazenda_idFazenda
    inner join orcamento o 
    on o.idOrcamento=p.Orcamento_idOrcamento
    order by o.preco asc
    limit 3
	);	
	-- 003  listar a nome da proposta,  descricao data mais antiga e a data mais recente usando o union,
	(select p.nome, p.descricao,o.dataOrcamento
    from proposta p 
    inner join orcamento o 
    on p.idProposta = o.Proposta_idProposta
    order by o.dataOrcamento desc
    limit 3
    ) 
    union
    (select p.nome, p.descricao,o.dataOrcamento
    from proposta p 
    inner join orcamento o 
    on p.idProposta = o.Proposta_idProposta
    order by o.dataOrcamento 
    limit 3
	);

-- 7 Dê exemplos de consultas usando subconsultas ao menos 5 
	-- 001 Listar o nome da proposta e todas propostas das datas de 2018
	
    select p.nome Nome_Servico
    from proposta p  
    where 
    p.idProposta in 
    (Select o.Proposta_idProposta 
      from Orcamento o 
      where 
      year(o.dataOrcamento)= 2018);      
	
    
    select * FROM ORCAMENTO;
   -- 002 Listar o nome do orcamento que nao teve no mes 7
   select p.nome
    from proposta p  
    where 
    p.idProposta  NOT IN (
    Select o.Proposta_idProposta 
      from Orcamento o 
      where 
      month(o.dataOrcamento)='7'
    ); 
    -- 003 relatorio do orcamento retirando informaçoes do orcamento e a media
    select o.preco
    from orcamento o 
    where o.preco != (select avg(preco) from orcamento) ;
    
    -- 004 listar os dados do usuario e da fazenda id maior igual a dois 
    select u.nome 
    from usuario u 
    inner join fazenda f 
    on u.idUsuario = f.usuario_idUsuario
    where f.idFazenda in (select idUsuario from fazenda);
    
    --  005 listar os dados da proposta com o maior id; 
    select * 
    from proposta 
    where Fazenda_idFazenda =(
    select max(Fazenda_idFazenda) 
    from proposta);
    
-- 8 Dê exemplo de uma sessão com controle de transação contendo os comandos rollback, 
-- commit e savepoint .

set autocommit=0;
begin work;
savepoint inserindo_novoUsuario;
insert into usuario 
			values ('Chico Bento', 'Cliente', '006', '000.000.000-6, chicobento@gmail.com', '1234567'),
					('Geoconda', 'Cliente', '006', '000.000.000-6, geoconda@gmail.com', '99999');
select * from usuario;
commit;
rollback to inserindo_novoUsuario;                    




 


