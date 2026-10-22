# 🚀 Guia de Deploy na Vercel — Portfólio Leonardo Boury

## Por que deu o erro "Não foi possível encontrar nenhum diretório `pages` ou `app`"?

A Vercel roda `next build` na raiz do repositório. Esse erro aparece quando a
pasta **`src/app`** (onde ficam as páginas do site) **não foi enviada** para o
repositório — normalmente porque o upload para o GitHub ficou incompleto
(faltou a pasta `src/` inteira ou parte dela).

**Solução:** suba TODOS os arquivos deste pacote para a RAIZ do repositório,
garantindo que existam as pastas `src/app`, `src/components`, `src/lib`,
`public`, `prisma` e `db`, além de `package.json` e `next.config.ts`.

---

## Passo a passo completo

### 1. Suba o projeto para o GitHub

Na raiz do repositório devem ficar (exatamente nesta disposição):

```
seu-repositorio/
├── src/                 ← OBRIGATÓRIA (contém app/, components/, lib/)
├── public/              ← fotos, CV em PDF e prints dos projetos
├── prisma/              ← schema do banco
├── db/                  ← banco SQLite local
├── package.json
├── next.config.ts
├── tsconfig.json
├── postcss.config.mjs
├── tailwind.config.ts
├── components.json
├── eslint.config.mjs
├── bun.lock
├── .gitignore
└── .env.example
```

Não suba as pastas `node_modules` e `.next` (o `.gitignore` já cuida disso).

Pelo site do GitHub: **Add file → Upload files** e arraste TUDO de uma vez
(o GitHub aceita até 100 arquivos por vez — se precisar, envie em lotes).

### 2. Importe na Vercel

1. Acesse [vercel.com/new](https://vercel.com/new) e conecte sua conta GitHub;
2. Selecione o repositório do portfólio;
3. A Vercel detecta **Next.js** automaticamente — não precisa mudar nada:
   - Build Command: `bun run build` (padrão detectado, já funciona)
   - Output Directory: padrão
   - Install Command: padrão
4. **Root Directory:** deixe vazio (a raiz do repo é a raiz do projeto);
5. Clique em **Deploy**.

### 3. (Opcional) Variáveis de ambiente

Nenhuma variável é obrigatória — o código resolve o banco sozinho.
Se quiser definir a URL do site (melhora o preview do Open Graph):

| Variável              | Valor                          |
|-----------------------|--------------------------------|
| `NEXT_PUBLIC_SITE_URL`| `https://seu-dominio.vercel.app` |

---

## ⚠️ Importante sobre o formulário de contato

A Vercel é **serverless**: o disco é somente-leitura (exceto `/tmp`) e cada
instância é efêmera. Com SQLite, as mensagens do formulário são salvas em
`/tmp` e **podem ser perdidas** quando a instância reinicia (o formulário
continua funcionando e respondendo sucesso).

Para guardar as mensagens de forma permanente, migre para um banco gratuito:

1. Crie um banco em [turso.tech](https://turso.tech) (SQLite na nuvem) ou
   [neon.tech](https://neon.tech) (Postgres);
2. No `prisma/schema.prisma`, troque `provider = "sqlite"` por `"postgres"`
   (Neon) ou use o Turso com `@libsql/client`;
3. Na Vercel, defina a variável `DATABASE_URL` com a string de conexão;
4. Faça um novo deploy.

---

## Rodando localmente (para testes)

```bash
bun install          # instala dependências (roda prisma generate sozinho)
bun run dev          # servidor de desenvolvimento em localhost:3000
bun run build        # build de produção (mesmo comando da Vercel)
bun run start        # serve o build de produção
```

> O `.env` é opcional localmente: sem ele, o site usa `db/custom.db`.
> Use o `.env.example` como modelo se quiser definir `DATABASE_URL`.
