# DR2 TP2 — Linux

Este repositório reúne os comandos e as evidências que produzi nos exercícios de shell, pipelines, dispositivos e armazenamento.

Usei o `/dev/sda` nos exercícios de análise porque ele é o disco principal da máquina e tem duas partições visíveis (`sda5` e `sda6`). Não fiz nenhuma alteração no disco: os comandos usados são apenas de consulta.

## Organização

- `executar_exercicios.sh`: comandos usados para refazer as evidências.
- `expansoes.txt` até `filesystems.txt`: resultados dos exercícios 1 a 11.
- `etapa_a_dev.txt`, `etapa_b_kernel.txt` e `etapa_c_hierarquia.txt`: etapas separadas do exercício 12.
- `analise_final.txt`: resumo e conclusão do exercício 12.
- `screenshots/`: prints dos exercícios.

Para executar novamente:

```bash
chmod +x executar_exercicios.sh
./executar_exercicios.sh
```

Algumas saídas dependem da máquina. Por isso, nomes de discos, tamanhos, pontos de montagem e mensagens do kernel podem ser diferentes em outro computador.
