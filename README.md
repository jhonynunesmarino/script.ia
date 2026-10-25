# BeyStyle Menu

Script de interface moderna para Roblox Studio, com visual inspirado em BeyRivals, mas sem virar jogo.

## O que é este projeto?

Este repositório contém um LocalScript de menu com:
- janela arrastável
- sidebar navegável
- páginas internas
- dados de jogador e servidor
- tema personalizável
- animações leves e design moderno
- botão de atalho com a tecla configurável

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
    │       ├── Info.lua
    │       └── Aparencia.lua
    └── Main.client.lua
```

## Como usar no Roblox Studio

1. Abra um lugar do Roblox Studio.
2. Crie um Script Local dentro de `StarterPlayer > StarterPlayerScripts`.
3. Copie o conteúdo de `src/Main.client.lua` para esse Script Local.
4. Ajuste `src/Config.lua` para seu nome e tecla de ativação.
5. Opcionalmente, use Rojo para sincronizar a pasta `src` diretamente.

## Configuração rápida

```lua
local Config = {
    CreatorName = "SeuNome",
    Version = "1.0.0",
    Credits = "Desenvolvido com Luau · Roblox Studio",
    Description = "Menu moderno e responsivo para Roblox.",
    ToggleKey = Enum.KeyCode.F2,
}

return Config
```

## Recursos

- menu lateral
- páginas de navegação
- janela minimizável/maximizável
- tema customizável por paleta
- foco em UI, não em gameplay

## Observação

Este projeto é um script de interface, não um mini-jogo. Ele foi pensado para mostrar dados, opções visuais e navegação de menu sem lógica de batalha ou inventário funcional.

