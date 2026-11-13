# Maré — Escola de Surf

> **Projecto em pausa (novembro de 2026).** Parei o desenvolvimento por falta de tempo e volto a ele assim que puder. O estado actual e os próximos passos estão descritos abaixo.

Site de reservas para a Maré, uma escola de surf fictícia na Costa da Caparica. É um projecto de portefólio: a ideia é construir de raiz uma aplicação com regras de negócio reais (vagas limitadas por aula, pagamento, cancelamentos por mau tempo) e conseguir explicar cada decisão.

O cliente escolhe a aula e o horário, indica quantas pessoas vão e paga através do Stripe Checkout (em modo de teste, sem pagamentos reais).

## Estado

**Feito**

- Projecto Vite + React + TypeScript com ESLint
- Schema inicial em Postgres (Supabase): `lessons`, `lesson_slots` e `bookings`, com chaves estrangeiras, `CHECK`s e índices
- Row Level Security activado nas três tabelas
- Ligação ao Supabase e listagem das aulas (página de teste)

**Próximos passos**

1. Policies de RLS: leitura pública de `lessons` e `lesson_slots`; `bookings` sem leitura pública, porque guarda dados de clientes
2. Nova migration com:
   - estado de cada horário (aberto / cancelado), para cancelar aulas quando o mar está mau
   - campos em falta na reserva: telefone, nível do cliente e confirmação da idade mínima
   - limite máximo de pessoas por reserva
   - vagas calculadas a partir das reservas, numa função do Postgres que recusa a reserva quando a aula está cheia (em vez de um contador guardado na tabela)
3. Prettier e deploy na Vercel
4. Interface a sério com CSS Modules, formulário de reserva com React Hook Form + Zod
5. Pagamento com Stripe Checkout através de uma Edge Function do Supabase
6. Testes com Vitest + Testing Library e CI com GitHub Actions

## Stack

| | Em uso | Planeado |
|---|---|---|
| Front-end | React, TypeScript, Vite | CSS Modules, React Hook Form, Zod |
| Back-end | Supabase (Postgres) | Supabase Auth, Edge Functions |
| Pagamentos | | Stripe Checkout (modo de teste) |
| Qualidade | ESLint | Prettier, Vitest, Testing Library, GitHub Actions |
| Deploy | | Vercel |

## Decisões técnicas

- **Preços em cêntimos (`INTEGER`)** em vez de decimais, para evitar erros de arredondamento.
- **`ON DELETE RESTRICT`** nas chaves estrangeiras: não se pode apagar uma aula que tem horários, nem um horário que tem reservas.
- **Estado da reserva com `CHECK`** (`pending`, `paid`, `cancelled`, `refunded`), para a base de dados recusar valores inválidos.
- **Regras de negócio na base de dados.** A validação no formulário serve para dar feedback ao utilizador; quem garante as regras é o Postgres.
- **Segredos fora do repositório.** As variáveis ficam em `.env.local`, que o Git ignora; o `.env.example` mostra quais são precisas.

## Correr localmente

Requisitos: Node.js 20 ou mais recente e um projecto Supabase.

```bash
git clone https://github.com/Rui-Passos/mare-surf-school.git
cd mare-surf-school
npm install
cp .env.example .env.local   # preencher com o URL e a anon key do Supabase
npm run dev
```

O schema está em `supabase/migrations/`. Para o aplicar com a CLI do Supabase: `supabase link` e depois `supabase db push`.

## Autor

Rui Passos · [LinkedIn](https://www.linkedin.com/in/rui-passos/) · [GitHub](https://github.com/Rui-Passos)
