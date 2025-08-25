-- ================================
-- Criação do Banco de Dados
-- ================================
CREATE DATABASE trainwise;
\c trainwise;

-- ================================
-- Tabela: Usuarios
-- ================================
CREATE TABLE Usuarios (
    UsuarioID SERIAL PRIMARY KEY,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Senha VARCHAR(255) NOT NULL,
    Tipo VARCHAR(20) CHECK (Tipo IN ('Aluno', 'Personal')) NOT NULL,
    DataNascimento DATE NOT NULL,
    Ativo BOOLEAN DEFAULT TRUE
);

-- ================================
-- Tabela: Planos
-- ================================
CREATE TABLE Planos (
    PlanoID SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    Ativo BOOLEAN DEFAULT TRUE
);

-- ================================
-- Tabela: Alunos
-- ================================
CREATE TABLE Alunos (
    AlunoID SERIAL PRIMARY KEY,
    UsuarioID INT NOT NULL,
    Nome VARCHAR(150) NOT NULL,
    CodigoAleatorio VARCHAR(50) UNIQUE NOT NULL,
    PlanoID INT,
    Ativo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_aluno_usuario FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    CONSTRAINT fk_aluno_plano FOREIGN KEY (PlanoID) REFERENCES Planos(PlanoID)
);

-- ================================
-- Tabela: PersonalTrainers
-- ================================
CREATE TABLE PersonalTrainers (
    PersonalID SERIAL PRIMARY KEY,
    UsuarioID INT NOT NULL,
    Nome VARCHAR(150) NOT NULL,
    Ativo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_personal_usuario FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

-- ================================
-- Tabela: Alunos_Personal (N:N)
-- ================================
CREATE TABLE Alunos_Personal (
    AlunoID INT NOT NULL,
    PersonalID INT NOT NULL,
    Ativo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (AlunoID, PersonalID),
    CONSTRAINT fk_ap_aluno FOREIGN KEY (AlunoID) REFERENCES Alunos(AlunoID),
    CONSTRAINT fk_ap_personal FOREIGN KEY (PersonalID) REFERENCES PersonalTrainers(PersonalID)
);

-- ================================
-- Tabela: GruposMusculares
-- ================================
CREATE TABLE GruposMusculares (
    GrupoID SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Ativo BOOLEAN DEFAULT TRUE
);

-- ================================
-- Tabela: Treinos
-- ================================
CREATE TABLE Treinos (
    TreinoID SERIAL PRIMARY KEY,
    AlunoID INT NOT NULL,
    PersonalID INT NOT NULL,
    DataHoraInicio TIMESTAMP NOT NULL,
    DataHoraFim TIMESTAMP NOT NULL,
    Desempenho INT CHECK (Desempenho BETWEEN 1 AND 10),
    Observacoes TEXT,
    Ativo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_treino_aluno FOREIGN KEY (AlunoID) REFERENCES Alunos(AlunoID),
    CONSTRAINT fk_treino_personal FOREIGN KEY (PersonalID) REFERENCES PersonalTrainers(PersonalID) 
);

-- ================================
-- Tabela: TreinoGrupos (N:N)
-- ================================
CREATE TABLE TreinoGrupos (
    TreinoID INT NOT NULL,
    GrupoID INT NOT NULL,
    Ativo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (TreinoID, GrupoID),
    CONSTRAINT fk_tg_treino FOREIGN KEY (TreinoID) REFERENCES Treinos(TreinoID),
    CONSTRAINT fk_tg_grupo FOREIGN KEY (GrupoID) REFERENCES GruposMusculares(GrupoID)
);
