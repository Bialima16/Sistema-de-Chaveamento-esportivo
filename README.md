# JUSA — Chaveamentos Oficiais

Aplicação React responsiva para consulta e administração local das competições dos Jogos Universitários de Areia.

## Executar

```bash
npm install
npm run dev
```

Para gerar a versão de produção: `npm run build`.

## Funcionalidades

- Quatro modalidades com grupos, equipes, atletas e partidas iniciais.
- Classificação automática a partir de partidas finalizadas.
- Chaveamentos de quartas, semifinais e final.
- Geração automática dos confrontos do mata-mata após a finalização de todas as partidas da fase de grupos.
- Edição dos resultados eliminatórios, definição de vencedor, avanço automático e campeão; o administrador pode substituir participantes manualmente.
- Busca e filtro de partidas, placares, status, datas e quadras.
- Modo de edição local, painel, importação/exportação JSON e restauração.
- Persistência compartilhada no Supabase, autenticação real e sincronização em tempo real. O `localStorage` mantém apenas a última cópia carregada como contingência de leitura.
- Interface responsiva e acessível para celular, tablet e desktop.

## Modo de edição

Senha de demonstração para todos os acessos: `jusa2026`.

Logins disponíveis:

- `admin`
- `arbitro-v2m` — Vôlei 2x2 Masculino
- `arbitro-v4x` — Vôlei 4x4 Misto
- `arbitro-v2f` — Vôlei 2x2 Feminino
- `arbitro-fvm` — Futvôlei 2x2 Masculino

Cada árbitro edita apenas as partidas da própria modalidade e consulta o respectivo checklist em modo somente leitura. Apenas o administrador pode marcar “Chegou”, desmarcar e editar a observação opcional.

Essa senha está apenas no frontend e **não oferece segurança real**. Em produção, deverá ser substituída por autenticação e autorização no backend.

## Estrutura

Dados iniciais ficam em `src/data`; persistência em `src/services`; regras de classificação em `src/utils`; estado global em `src/context`; páginas e componentes visuais estão separados por domínio.

## Próximos passos: Laravel e MySQL

Substituir o `storageService` por um cliente HTTP, preservando a interface da camada de serviço. Criar no Laravel recursos para modalidades, equipes, atletas, grupos, partidas e classificações; persistir no MySQL; adicionar autenticação, perfis de acesso, validação no servidor, histórico de alterações e atualização em tempo real.
