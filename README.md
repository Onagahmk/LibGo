# LibGo - Biblioteca Pessoal de Livros 📚

O **LibGo** é um aplicativo moderno desenvolvido em Flutter para gestão de bibliotecas pessoais. Ele permite o cadastro de livros, gerenciamento de arquivos digitais, consulta à API do Google Books e uma experiência de usuário personalizada com troca dinâmica de temas.

---

## 🎥 Vídeo Demonstrativo
https://youtu.be/dpwG-yZ2Bgc
*(O vídeo apresenta as funcionalidades do app e a explicação técnica de cada requisito abaixo)*

---

## 🛠 Requisitos do Projeto e Implementação

Este projeto foi construído seguindo rigorosos padrões de engenharia de software:

### 1. Clean Code (Código Limpo)
- **Autoexplicativo:** Remoção de comentários redundantes; o código utiliza nomes de variáveis e funções que descrevem sua própria intenção.
- **DRY (Don't Repeat Yourself):** Centralização de estilos e temas no `ThemeData` para evitar repetição de cores nos widgets.
- **Single Responsibility:** Cada classe e ViewModel possui uma única responsabilidade clara.

### 2. Arquitetura de Software (MVVM)
Utilizamos o padrão **MVVM** com o auxílio do `Provider` para gerenciar o estado:
- **Models (`lib/models/`):** Estruturas de dados puras.
- **ViewModels (`lib/viewmodels/`):** 
    - `BookViewModel`: Gerencia a lógica de negócio dos livros e persistência.
    - `ThemeViewModel`: Gerencia o estado do tema global (Claro/Escuro).
- **Views (`lib/views/`):** Interface reativa que observa as mudanças nas ViewModels.

### 3. Injeção de Dependência
Implementada com o pacote **GetIt** para garantir desacoplamento total:
- **Onde encontrar:** `lib/di/service_locator.dart`.
- As dependências de banco de dados (`DatabaseHelper`) e serviços externos (`GoogleBooksService`) são injetadas nas ViewModels, facilitando a manutenção e a criação de testes.

### 4. Testes Unitários
O projeto contém testes unitários robustos que validam a lógica de negócio principal:
- **Onde encontrar:** `test/unit_test.dart`.
- **Casos de Teste:**
    1. Validação e conversão de dados do modelo `Book`.
    2. Lógica de ordenação alfabética de títulos.
    3. Lógica de ordenação por autor.
    4. Funcionalidade de filtragem/pesquisa em tempo real.
    5. Gerenciamento de estados de carregamento (Loading) na ViewModel.

### 5. Design Patterns (Padrões de Projeto)
- **Repository Pattern:** Abstração da camada de dados para o SQLite.
- **Service Locator:** Centralização de instâncias globais via GetIt.
- **Observer Pattern:** Implementado através do `ChangeNotifier` e `Consumer`, onde a UI é notificada automaticamente sobre mudanças de estado.
- **MultiProvider:** Gerenciamento de múltiplos estados globais de forma escalável.

### 6. Interface (3+ Telas e Funcionalidades Modernas)
- **Contexto:** Biblioteca pessoal com busca integrada e gerenciamento de arquivos.
- **Telas:** Galeria (Principal), Adição de Livros e Edição/Detalhes.
- **Interatividade "Premium":** 
    - **Interruptor de Luz (Lâmpada):** Um botão interativo na AppBar que altera o tema do app em tempo real.
    - **Visual Midnight Blue:** Tema escuro sofisticado em tons de azul marinho, reduzindo a fadiga ocular.
    - **Logo Customizado:** AppBar com identidade visual própria e ícones modernos.

---

## 🚀 Como Executar
1. `flutter pub get`
2. `flutter run`

---

## 👤 Aluno
- Rodrigo de Castro Pietrowski

---

