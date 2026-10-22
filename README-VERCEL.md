# 🚀 Guia de Deploy na Vercel — Portfólio Leonardo Boury

## 🔍 Diagnóstico do problema (confirmado olhando o seu repositório)

Seu repositório `github.com/Leloo0/portfolio1` está **apenas com arquivos
soltos** (package.json, configs...) e **sem nenhuma pasta**. Faltam:

- `src/` — todo o código do site (por isso "Não foi possível encontrar
  nenhum diretório `pages` ou `app`")
- `prisma/schema.prisma` — o schema do banco (por isso "Não foi possível
  carregar o esquema de `prisma/schema.prisma`" no postinstall)
- `public/` — as fotos e o CV

**Causa:** o arrastar-e-soltar do site do GitHub está subindo só os
arquivos e descartando as pastas — aconteceu em todas as tentativas.
Nada de errado com o pacote ou com a Vercel: o problema é só o método
de upload.

> 💡 O aviso sobre `package.json#prisma` obsoleto já foi resolvido neste
> pacote (a chave foi removida — o Prisma encontra o schema sozinho).

---

## ✅ SOLUÇÃO — escolha UM dos dois métodos

### Método 1 (recomendado): rode o script incluído no pacote

O pacote agora vem com um script que envia **tudo** (pastas incluídas)
e **substitui o conteúdo antigo** do repositório de uma vez:

1. Extraia o `portfolio-vercel.zip` no seu computador;
2. **Windows:** dê dois cliques em `SUBIR-PARA-GITHUB.bat`
   **Mac/Linux:** abra o Terminal nessa pasta e rode
   `bash subir-para-github.sh`;
3. Se ele avisar que o Git não está instalado, instale em
   [git-scm.com](https://git-scm.com/downloads) e rode de novo;
4. Quando uma janela do navegador pedir login, entre com sua conta
   GitHub (é o login normal do site);
5. Espere aparecer **PRONTO!**.

O script faz: `git init → git add . → commit → push --force` no repo
`Leloo0/portfolio1`. O `--force` limpa o conteúdo incompleto antigo —
o repositório fica **idêntico** ao pacote. E a Vercel detecta o push
e **publica sozinha** (não precisa mexer na Vercel).

### Método 2: GitHub Desktop (app gráfico, sem comandos)

1. Instale o [GitHub Desktop](https://desktop.github.com) e faça login;
2. **File → Add Local Repository...** → aponte para a pasta extraída;
   se ele disser que não é um repositório, clique em
   **Create a Repository Here** (nome: `portfolio1`, deixe o resto padrão);
3. Escreva um resumo qualquer (ex.: `deploy`) e clique em **Commit**;
4. **Repository → Push** / **Repository → Force Push** (se pedir);
   se o botão disser "Fetch origin", clique em **Fetch origin** e depois
   em **Pull → Force Push** para sobrescrever o conteúdo antigo.

---

## 🔎 Antes de olhar a Vercel, confira o repositório (30 segundos)

Abra `github.com/Leloo0/portfolio1` e verifique:

| O que ver                  | Onde                             |
|----------------------------|----------------------------------|
| 3 pastas: `src`, `public`, `prisma` | na raiz do repo         |
| `page.tsx`                 | dentro de `src/app`              |
| `schema.prisma`            | dentro de `prisma`               |
| ~42 itens no total         | contagem da home do repo         |

**Só depois de ver as pastas no GitHub** é que o deploy funciona.

## ▲ Na Vercel

1. [vercel.com/new](https://vercel.com/new) → selecione `portfolio1`
   (se o projeto já existe no dashboard, o push novo dispara o deploy
   automaticamente — acompanhe em vercel.com/dashboard);
2. **Root Directory:** deixe **VAZIO**;
3. Build Command e Install Command: padrões da Vercel (nada para mudar).

Fluxo validado localmente em ambiente limpo:

```
bun install   → 827 pacotes + prisma generate (postinstall)  ✓
bun run build → next build, 5 páginas estáticas               ✓
```

### Variáveis de ambiente (opcional)

| Variável               | Valor                            |
|------------------------|----------------------------------|
| `NEXT_PUBLIC_SITE_URL` | `https://portfolio1.vercel.app`  |

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
bun install          # instala dependências e roda prisma generate sozinho
bun run dev          # servidor de desenvolvimento em localhost:3000
bun run build        # build de produção (mesmo comando da Vercel)
bun run start        # serve o build de produção
```

> O `.env` é opcional localmente: sem ele, o site usa `db/custom.db`
> (a pasta `db/` é criada automaticamente na primeira execução).
> Use o `.env.example` como modelo se quiser definir `DATABASE_URL`.
