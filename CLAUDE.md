# CLAUDE.md - Guia de Adaptação do open-erp para Empresa de Celulares

Este documento orienta o **Claude Code** para adaptar o ERP **Purple-Stock/open-erp** (Ruby on Rails) ao ramo de **venda e assistência técnica de celulares e acessórios**.

## Visão Geral do Projeto

- **Stack:** Ruby on Rails (Ruby 3.3.4), PostgreSQL, Bootstrap, Hotwire/Turbo.
- **Origem:** fork de `Purple-Stock/open-erp`.
- **Objetivo:** transformar o ERP genérico em um ERP especializado para lojas de celulares, com controle por IMEI/número de série, ordens de serviço (OS) e gestão de garantias.

## Como Iniciar

```bash
bundle install
yarn install
bin/rails db:create db:migrate db:seed
bin/rails server
```

## Padrões do Projeto

- Siga o estilo de código Ruby/Rails (RuboCop) e crie specs (RSpec) para cada nova feature.
- Use migrations para mudanças no banco. Nunca edite migrations antigas.
- Mantenha a localização em **pt-BR** (`config/locales`).
- Componentes de UI usam Bootstrap; mantenha consistência visual.
- Antes de finalizar, rode `bundle exec rspec` e `bundle exec rubocop`.

## Roadmap de Adaptações (Issues no GitHub)

As tarefas estão detalhadas como Issues no repositório. Execute na ordem:

1. **#1 Rebranding** - Substituir nome "Purple Stock" / "open-erp" pelo nome da nova empresa, atualizar logos, cores e textos institucionais.
2. **#2 Cadastro de Produtos para Celulares** - Adicionar campos: IMEI1, IMEI2, número de série, marca, modelo, capacidade de armazenamento (GB), memória RAM, cor, condição (novo / seminovo / usado / vitrine), bateria (%).
3. **#3 Categorias e NCM padrão** - Seeds com categorias: Smartphones, Capas, Películas, Carregadores, Cabos, Fones, Power Banks, Peças. NCMs corretos (8517.13.00 para celulares, etc.).
4. **#4 Controle de Estoque por IMEI/Série** - Cada unidade física de celular com rastreio individual. Validar IMEI único.
5. **#5 Módulo de Garantias** - Garantia de fábrica e garantia da loja. Alertas de vencimento. Histórico por IMEI.
6. **#6 Ordem de Serviço (Assistência Técnica)** - Novo módulo OS: cliente, aparelho, defeito, diagnóstico, peças, mão de obra, status, termo de responsabilidade.
7. **#7 Avaliação de Aparelhos Usados (Trade-in)** - Fluxo para avaliar aparelho do cliente, calcular valor de entrada, gerar contrato.
8. **#8 NFe específica para celulares** - Templates fiscais com IMEI no campo de informações adicionais.
9. **#9 Relatórios e BI** - Dashboards: vendas por modelo, margem por marca, OS abertas, garantias a vencer, giro de estoque por IMEI.
10. **#10 Integração com Marketplaces** - Adaptar conectores (Mercado Livre, Shopee) para listar smartphones com atributos específicos.

## Convenções para o Claude Code

- Crie um branch por Issue: `feature/01-rebranding`, `feature/02-produtos-celulares`, etc.
- Commits em português, no padrão conventional: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`.
- Sempre adicione testes RSpec para novos models/controllers.
- Documente novas rotas/endpoints no `README.md`.
- Não quebre features existentes - rode a suite completa antes do PR.

## Modelos Principais a Estender

- `Product` - adicionar campos específicos de celular.
- `Stock` / `StockMovement` - rastreio por IMEI.
- Novo: `ServiceOrder`, `Warranty`, `DeviceInspection`, `TradeIn`.

## Referências Úteis

- Repositório original (upstream): https://github.com/Purple-Stock/open-erp
- NCM oficial: https://www.gov.br/receitafederal
- Documentação NFe: https://www.nfe.fazenda.gov.br
