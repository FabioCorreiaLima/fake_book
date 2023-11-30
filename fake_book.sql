create database fake_book;
use fake_book;

CREATE TABLE Usuarios (
    id INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE Postagens (
    id INT PRIMARY KEY,
    texto TEXT NOT NULL,
    usuario_id INT,
    data_postagem DATE,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

CREATE TABLE Comentarios (
    id INT PRIMARY KEY,
    texto TEXT NOT NULL,
    usuario_id INT,
    postagem_id INT,
    data_comentario DATE,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (postagem_id) REFERENCES Postagens(id)
);

CREATE TABLE Amizades (
    usuario1_id INT,
    usuario2_id INT,
    data_amizade DATE,
    PRIMARY KEY (usuario1_id, usuario2_id),
    FOREIGN KEY (usuario1_id) REFERENCES Usuarios(id),
    FOREIGN KEY (usuario2_id) REFERENCES Usuarios(id)
);
-- Inserir usuários relacionados a animes
INSERT INTO Usuarios (id, nome) VALUES
(5, 'OtakuMaster'),
(6, 'AnimeLover'),
(7, 'MangaFan'),
(8, 'CosplayQueen'),
(9, 'joao'),
(10, 'Maria');

-- Inserir postagens sobre animes
INSERT INTO Postagens (id, texto, usuario_id, data_postagem) VALUES
(5, 'Acabei de assistir a um novo episódio de Attack on Titan! Incrível!', 5, '2023-11-28'),
(6, 'Recomendo o anime My Hero Academia para todos os fãs de super-heróis.', 6, '2023-11-27'),
(7, 'Qual é o seu anime favorito? O meu é Naruto!', 7, '2023-11-26'),
(8, 'Consegui finalmente terminar de ler o manga de One Piece. É épico!', 5, '2023-11-25'),
(9, 'Bom dia, mundo!', 9, '2023-11-24');

-- Inserir comentários sobre animes
INSERT INTO Comentarios (id, texto, usuario_id, postagem_id, data_comentario) VALUES
(5, 'Sim, Attack on Titan está ficando cada vez melhor!', 6, 5, '2023-11-28'),
(6, 'My Hero Academia é realmente empolgante. Adoro!', 7, 6, '2023-11-27'),
(7, 'Naruto é um clássico! Também adoro.', 8, 7, '2023-11-26'),
(8, 'One Piece é incrível, não é? Quem é o seu personagem favorito?', 6, 8, '2023-11-25'),
(9, 'Ótima postagem!', 10, 9, '2023-11-24'),
(10, 'Bom dia, João!', 9, 9, '2023-11-24'),
(11, 'Concordo! Bom dia para todos!', 5, 9, '2023-11-24'),
(12, 'Que animação maravilhosa para começar o dia!', 6, 9, '2023-11-24');

-- Inserir amizades entre fãs de animes
INSERT INTO Amizades (usuario1_id, usuario2_id, data_amizade) VALUES
(5, 6, '2023-11-20'),
(5, 7, '2023-11-21'),
(6, 8, '2023-11-22'),
(9, 5, '2023-11-23'),
(10, 6, '2023-11-23');


-- Liste todas as postagens feitas por um usuário chamado 'João'.
SELECT
    p.id AS postagem_id,
    p.texto AS postagem_texto,
    p.data_postagem,
    u.nome AS autor
FROM Postagens p
JOIN Usuarios u ON p.usuario_id = u.id
WHERE u.nome = 'João';

-- Mostre todos os comentários feitos em uma postagem com o texto 'Bom dia, mundo!'.
SELECT * FROM Comentarios
WHERE postagem_id = (SELECT id FROM Postagens WHERE texto = 'Bom dia, mundo!');


-- Apresente a contagem total de postagens e comentários feitos por cada usuário.
SELECT
    u.nome,
    COUNT(DISTINCT p.id) AS total_postagens,
    COUNT(DISTINCT c.id) AS total_comentarios
FROM Usuarios u
LEFT JOIN Postagens p ON u.id = p.usuario_id
LEFT JOIN Comentarios c ON u.id = c.usuario_id
GROUP BY u.nome;


-- Liste todas as novas amizades formadas nos últimos 30 dias.
SELECT *
FROM Amizades
WHERE data_amizade >= CURDATE() - INTERVAL 30 DAY;


-- Forneça informações detalhadas sobre um usuário chamado 'Maria', incluindo suas postagens e amizades.
SELECT
    u.nome,
    p.texto AS postagem,
    a2.nome AS amigo
FROM Usuarios u
LEFT JOIN Postagens p ON u.id = p.usuario_id
LEFT JOIN Amizades a ON u.id = a.usuario1_id OR u.id = a.usuario2_id
LEFT JOIN Usuarios a2 ON (a.usuario1_id = u.id AND a.usuario2_id = a2.id) OR (a.usuario2_id = u.id AND a.usuario1_id = a2.id)
WHERE u.nome = 'Maria';




