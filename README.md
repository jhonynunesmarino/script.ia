# script.ia

Sistema moderno de interface para Roblox Studio, organizado em módulos para facilitar manutenção, evolução e reutilização.

## Estrutura

```text
script.ia/
├── .gitignore
├── README.md
├── default.project.json
└── src/
    ├── Config.lua
    ├── Theme.lua
    ├── Helpers.lua
    ├── UI/
    │   ├── Components.lua
    │   └── Pages/
    │       ├── Inicio.lua
    │       ├── Jogador.lua
    │       ├── Servidor.lua
    │       ├── Aparencia.lua
    │       └── Info.lua
    └── Main.client.lua
```

## Como usar

1. Abra o projeto no Roblox Studio.
2. Se quiser sincronizar com arquivos locais, use Rojo.
3. Coloque `src/Main.client.lua` em `StarterPlayer > StarterPlayerScripts`.
4. Ajuste `src/Config.lua` com seu nome e preferências.

## Configuração rápida

```lua
local Config = {
    CreatorName = "SeuNome",
    Version = "1.0.0",
    Credits = "Desenvolvido com Luau · Roblox Studio",
    Description = "Sistema de interface moderno, responsivo e totalmente personalizável.",
    ToggleKey = Enum.KeyCode.F2,
}

return Config
```

## O que foi organizado

- configuração
- tema
- helpers
- componentes de UI
- páginas separadas
- script principal

Essa estrutura deixa o projeto mais escalável e fácil de evoluir.

## Referências inspiradoras (estilo BeyRivals / Roblox Lua)

Esses repositórios públicos são bons exemplos de UI, mecânicas e estrutura para projetos de Roblox com visual moderno, menu de combate e sistemas de status:

- VaultUI — https://github.com/Xyraniz/VaultUI
  - Ótimo para interfaces modernas, janelas, botões e painéis de controle.

- WindUI — https://github.com/Footagesus/WindUI
  - UI moderna, mais limpa e boa para hubs e painéis de menu.

- UILibs — https://github.com/Eazvy/UILibs
  - Coleção grande de bibliotecas e exemplos de UI para Roblox.

- Roblox-Lua-Code — https://github.com/MoonTales/Roblox-Lua-Code
  - Ótimo para mecânicas de gameplay e scripts de funcionalidade.

- useful-roblox-resources — https://github.com/loominatrx/useful-roblox-resources
  - Lista de recursos úteis para Lua/Roblox, UI e arquitetura de projeto.

- roact — https://github.com/Roblox/roact
  - UI mais componentizada e organizada em React-style.

- Knit — https://github.com/Sleitnick/Knit
  - Estrutura modular para arquitetura do jogo.

- Fusion — https://github.com/Elttob/Fusion
  - Biblioteca moderna para UI reativa em Roblox.

## Como usar essas referências aqui

Para o seu projeto `script.ia`, a combinação ideal é:

- UI visual: `VaultUI` ou `WindUI`
- Gameplay e lógica: `Roblox-Lua-Code`
- Estrutura do projeto: `Knit` ou módulos locais como este repositório já usa

## Próximo passo recomendado

- separar páginas por módulo de sistema (inicio, jogador, servidor, aparência, batalhas)
- integrar painel de habilidades e status
- criar sistema de inventário / arena/combate em módulos independentes
- evoluir a UI para ficar ainda mais próxima do visual de um jogo de arena

