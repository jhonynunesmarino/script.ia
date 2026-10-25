# script.ia

Sistema moderno de interface para Roblox Studio, organizado em módulos para facilitar manutenção, atualização e reutilização.

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
2. Instale o Rojo (opcional), se quiser sincronizar com arquivos locais.
3. Coloque `src/Main.client.lua` em `StarterPlayer > StarterPlayerScripts`.
4. Ajuste `src/Config.lua` com o seu nome e preferências.

## Configuração rápida

Arquivo de configuração:

```lua
local Config = {
    CreatorName = "SeuNome",
    Version = "1.0.0",
    Credits = "Desenvolvido com Luau · Roblox Studio",
    ToggleKey = Enum.KeyCode.F2,
}

return Config
```

## Tema

O tema está em `src/Theme.lua` e pode ser customizado por paleta.

## Observação

Esse repositório foi reorganizado para separar:
- configuração
- tema
- helpers
- componentes de interface
- script principal

Mantém o mesmo conceito de UI moderna, mas com uma estrutura que escala melhor.
