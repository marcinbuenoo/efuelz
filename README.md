# e-Fuelz — controle de gastos com combustível

Aplicativo Flutter para cadastrar um veículo e registrar abastecimentos. O painel calcula gasto total, consumo em km/L e custo em R$/km, além de mostrar gráficos de evolução. Os dados ficam salvos no dispositivo usando SharedPreferences.

## Funcionalidades

- Cadastro de um veículo por vez, com marca e modelo consultados na API FIPE da BrasilAPI.
- Exclusão do veículo com confirmação, removendo também seu histórico.
- Registro de combustível, preço por litro, hodômetro, litros e data/horário.
- Cálculo do valor total, consumo entre abastecimentos e custo por quilômetro.
- Dashboard com gráficos de consumo e custo e histórico de abastecimentos.
- Temas claro e escuro com identidade roxa e preferência salva no dispositivo.

## Executar

Requisitos: Flutter SDK compatível com Dart 3.14 ou superior e Android Studio/Xcode para emulador ou dispositivo.

```sh
flutter pub get
flutter run
```

Marcas e modelos precisam de conexão com a internet para consultar a BrasilAPI.

## API e bibliotecas

- [BrasilAPI — FIPE](https://brasilapi.com.br/docs#tag/FIPE): consulta marcas e modelos de veículos (`/fipe/marcas/v1/carros` e `/fipe/veiculos/v1/carros/{codigoDaMarca}`).
- `http`: requisições HTTP.
- `shared_preferences`: persistência local.
- `fl_chart`: gráficos de linha no dashboard.

## Organização do código

- `lib/models/`: modelos de veículo e abastecimento.
- `lib/screens/`: tela principal, painel, histórico e formulários.
- `lib/services/`: consulta da BrasilAPI e armazenamento local.
- `lib/theme/`: cores e estilo visual compartilhado.
- `lib/widgets/`: cartões de métricas, gráficos e itens do histórico.

## Ícone do aplicativo

O desenho vetorial fica em `tooling/icon/efuelz-icon.svg` e a versão PNG usada pelo app em `assets/branding/efuelz-icon.png`. Para regenerar os ícones Android, iOS, macOS, Windows e Web, execute `./tooling/icon/build_icon.ps1` no PowerShell.

## Capturas de tela

### Início e cadastro do veículo

<p align="center">
  <img src="assets/WhatsApp%20Image%202026-11-12%20at%2019.53.26.jpeg" alt="Tela inicial no tema claro" width="220">
  <img src="assets/WhatsApp%20Image%202026-11-12%20at%2019.53.26%20%281%29.jpeg" alt="Tela inicial no tema escuro" width="220">
  <img src="assets/WhatsApp%20Image%202026-11-12%20at%2019.53.26%20%282%29.jpeg" alt="Formulário de cadastro do veículo" width="220">
</p>

### Painel, abastecimento e histórico

<p align="center">
  <img src="assets/WhatsApp%20Image%202026-11-12%20at%2019.53.27.jpeg" alt="Dashboard do e-Fuelz" width="220">
  <img src="assets/WhatsApp%20Image%202026-11-12%20at%2019.53.27%20%281%29.jpeg" alt="Formulário de novo abastecimento" width="220">
  <img src="assets/WhatsApp%20Image%202026-11-12%20at%2019.53.27%20%282%29.jpeg" alt="Histórico de abastecimentos" width="220">
</p>
