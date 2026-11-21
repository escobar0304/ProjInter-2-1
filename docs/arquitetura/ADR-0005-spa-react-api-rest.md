# ADR-0005: Frontend SPA em React e API REST em Flask, na mesma origem

| | |
|---|---|
| Estado | Proposta |
| Data | Sprint A (novembro de 2026) |
| Requisitos | RNF17, RNF18, RNF19 (e RNF06, RNF07) |

## Contexto

A especificação (§C, §E) impõe React no frontend e Python com Flask no backend, e pede que a apresentação, a lógica de negócio e os dados fiquem separados (RNF17). Falta decidir como as duas partes comunicam e como são servidas ao browser.

## Decisão

- O frontend é uma **SPA** (*single-page application*) em React. É compilado para ficheiros estáticos (HTML, JavaScript e CSS), servidos pelo Nginx.
- O backend expõe uma **API REST** em JSON, com os endereços em `/api/v1/...` (ex.: `GET /api/v1/training-resources`, `POST /api/v1/attempts`). A versão no endereço permite mudar a API sem partir o frontend.
- O Nginx serve o frontend e encaminha `/api` para o Flask, por isso o browser vê **uma só origem**: não é preciso CORS e os cookies da sessão funcionam sem configuração extra ([ADR-0003](ADR-0003-autenticacao-sessao-cookie.md)).
- Os erros da API têm um formato JSON comum (código, mensagem e campo em causa), que o frontend mostra ao utilizador (RNF06, RNF07). Os detalhes técnicos ficam só no log do servidor.

## Alternativas consideradas

| Alternativa | Vantagens | Porque não foi escolhida |
|---|---|---|
| Páginas geradas no servidor com Jinja (Flask) | Menos peças; sem API separada | Não cumpre o React imposto pela especificação (RNF18). |
| Frontend e API em origens diferentes (ex.: portas ou domínios diferentes) | Contentores independentes | Obriga a configurar CORS e cookies entre origens, o que complica a autenticação e a segurança. |
| API GraphQL | O frontend pede só os dados de que precisa | Mais complexa de aprender e de proteger; os ecrãs da plataforma correspondem bem a recursos REST. |

## Consequências

- O frontend e o backend podem ser desenvolvidos e testados em separado, com o contrato da API como ponto de encontro. A lista de endpoints é documentada na Sprint B.
- A lógica de negócio fica só no backend (RNF24): o frontend esconde opções, mas quem decide é a API.
- Um só servidor web à frente simplifica o HTTPS em produção (RNF25).
- Em desenvolvimento, o servidor de desenvolvimento do React precisa de um *proxy* para `/api`, para manter a mesma origem.
