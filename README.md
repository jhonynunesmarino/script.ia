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
    │   └── Components.lua
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
- script principal

Essa estrutura deixa o projeto mais escalável e fácil de evoluir.
