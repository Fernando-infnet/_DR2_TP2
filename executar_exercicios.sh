#!/bin/bash

# Comandos que usei para fazer o TP2 de Linux.
# Escolhi o sda para os exercicios de armazenamento porque ele tem
# particoes e esta sendo usado pelo sistema.

cd "$(dirname "$0")" || exit 1

# Exercicio 1
mkdir -p arquivos_ex1
touch arquivos_ex1/aula_{01..03}.log arquivos_ex1/notas.txt
touch arquivos_ex1/relatorio_{A..C}_{1..2}.txt

{
    echo "Exercício 1 - Shell expansions"
    echo
    echo '$ touch arquivos_ex1/aula_{01..03}.log arquivos_ex1/notas.txt'
    echo '$ ls -1 arquivos_ex1/*.log'
    ls -1 arquivos_ex1/*.log
    echo
    echo '$ touch arquivos_ex1/relatorio_{A..C}_{1..2}.txt'
    echo '$ ls -1 arquivos_ex1/relatorio_{A..C}_{1..2}.txt'
    ls -1 arquivos_ex1/relatorio_{A..C}_{1..2}.txt
    echo
    echo "As chaves criaram vários nomes de uma vez e o *.log mostrou só os arquivos de log."
} > expansoes.txt

# Exercicio 2
ls -1 /etc | less > pipeline.txt
less -FX pipeline.txt > /dev/null

# Exercicio 3
ls -l /dev | grep '^b' | sort -k9 | less > dispositivos_bloco.txt
less -FX dispositivos_bloco.txt > /dev/null

# Exercicio 4
{
    echo "Exercício 4 - Redirecionamento para /dev/null"
    echo
    echo '$ echo "Esta mensagem vai ser descartada" > /dev/null'
    echo "Esta mensagem vai ser descartada" > /dev/null
    echo "Não apareceu nada na tela."
    echo
    echo '$ echo "Agora a mensagem aparece"'
    echo "Agora a mensagem aparece"
    echo
    echo "O /dev/null funciona como um descarte: ele recebe a saída, mas não guarda nem mostra o texto."
} > redirecionamento.txt

# Exercicio 5
nome="${USER:-aluno}"
{
    echo "Exercício 5 - Aspas simples e duplas"
    echo
    echo '$ echo '\''Meu usuário é $nome'\'''
    echo 'Meu usuário é $nome'
    echo
    echo '$ echo "Meu usuário é $nome"'
    echo "Meu usuário é $nome"
    echo
    echo 'Com aspas simples, $nome ficou como texto. Com aspas duplas, o shell trocou a variável pelo valor.'
} > aspas.txt

# Exercicio 6
{
    echo "Exercício 6 - Sysfs"
    echo
    echo '$ ls -1 /sys/block'
    ls -1 /sys/block
    echo
    echo "Escolhi o sda. Estes foram os atributos que consultei:"
    echo
    echo '$ cat /sys/block/sda/device/vendor'
    sed 's/[[:space:]]*$//' /sys/block/sda/device/vendor
    echo '$ cat /sys/block/sda/device/model'
    cat /sys/block/sda/device/model
    echo '$ cat /sys/block/sda/size'
    cat /sys/block/sda/size
    echo '$ cat /sys/block/sda/queue/rotational'
    cat /sys/block/sda/queue/rotational
    echo
    echo "O size é informado em setores de 512 bytes. O valor 1 em rotational mostra que é um HD mecânico."
} > sysfs.txt

# Exercicio 7
{
    echo "Exercício 7 - Informações do udev para /dev/sda"
    echo
    echo "Informações que achei mais importantes:"
    echo "- Tipo: $(udevadm info -q property -n /dev/sda | awk -F= '$1 == "DEVTYPE" {print $2; exit}')"
    echo "- Fabricante/vendor: $(tr -d ' ' < /sys/block/sda/device/vendor)"
    echo "- Modelo: $(udevadm info -q property -n /dev/sda | awk -F= '$1 == "ID_MODEL" {print $2; exit}')"
    echo
    echo '$ udevadm info --query=property --name=/dev/sda'
    udevadm info --query=property --name=/dev/sda
} > udev_info.txt 2>&1

# Exercicio 8
{
    echo "Exercício 8 - Mensagens do kernel sobre armazenamento"
    echo
    echo '$ journalctl -k --no-pager | grep -Ei '\''sda|sdb|sdc|ata[0-9]|scsi|storage|disk'\'''
    echo
    journalctl -k --no-pager 2>&1 | grep -Ei 'sda|sdb|sdc|ata[0-9]|scsi|storage|disk' || true
} > kernel_devices.txt

# Exercicio 9
{
    echo "Exercício 9 - Drivers registrados"
    echo
    echo '$ cat /proc/devices'
    echo
    cat /proc/devices
    echo
    echo "Exemplos que encontrei:"
    echo "- Driver de caractere: tty, major 4"
    echo "- Driver de bloco: sd, major 8"
} > drivers.txt

# Exercicio 10
{
    echo "Exercício 10 - Discos e partições"
    echo
    echo '$ lsblk -o NAME,KNAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS,MODEL,VENDOR'
    echo
    lsblk -o NAME,KNAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS,MODEL,VENDOR | sed 's/[[:space:]]*$//'
} > armazenamento.txt

# Exercicio 11
{
    echo "Exercício 11 - Filesystems montados"
    echo
    echo '$ mount'
    echo
    mount
    echo
    echo '$ df -hT'
    echo
    df -hT
} > filesystems.txt

# Exercicio 12 - cada parte fica em um arquivo separado
{
    echo '$ ls -l /dev | grep '\''sda'\'''
    echo
    ls -l /dev | grep 'sda'
} > etapa_a_dev.txt

{
    echo '$ cat /proc/partitions | grep -E '\''name|sda'\'''
    echo
    cat /proc/partitions | grep -E 'name|sda'
} > etapa_b_kernel.txt

{
    echo '$ lsblk -o NAME,KNAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS | sed -n '\''1p;/sda/p'\'''
    echo
    lsblk -o NAME,KNAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS | sed -n '1p;/sda/p' | sed 's/[[:space:]]*$//'
} > etapa_c_hierarquia.txt

{
    echo "Análise final do /dev/sda"
    echo "=========================="
    echo
    echo "Escolhi o sda porque ele é o disco principal desta máquina e possui duas partições em uso."
    echo
    echo "1. Como o disco aparece em /dev"
    echo
    echo "Comando usado: ls -l /dev | grep 'sda' > etapa_a_dev.txt"
    echo "Para que usei: procurar os arquivos especiais do disco e das partições."
    echo "O que encontrei: sda é um dispositivo de bloco. Abaixo dele aparecem sda5 e sda6."
    echo
    cat etapa_a_dev.txt
    echo
    echo "2. O que o kernel reconheceu"
    echo
    echo "Comando usado: cat /proc/partitions | grep -E 'name|sda' > etapa_b_kernel.txt"
    echo "Para que usei: conferir se o kernel reconheceu o disco e suas partições."
    echo "O que encontrei: o kernel mostra sda, sda5 e sda6 com seus números major, minor e quantidade de blocos."
    echo
    cat etapa_b_kernel.txt
    echo
    echo "3. Hierarquia mostrada pelo lsblk"
    echo
    echo "Comando usado: lsblk -o NAME,KNAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS | sed -n '1p;/sda/p' > etapa_c_hierarquia.txt"
    echo "Para que usei: enxergar melhor a relação entre o disco e as partições."
    echo "O que encontrei: sda5 usa vfat e está em /boot/efi; sda6 usa ext4 e está montada em /."
    echo
    cat etapa_c_hierarquia.txt
    echo
    echo "4. Comando auxiliar"
    echo
    echo "Usei lsblk --help | head -n 18 para consultar a ajuda do comando e entender as opções."
    echo
    lsblk --help | head -n 18
    echo
    echo "Conclusão"
    echo
    echo "Os três comandos mostram partes diferentes da mesma informação. O /dev mostra os arquivos que os programas usam,"
    echo "o /proc/partitions confirma o que o kernel reconheceu e o lsblk deixa a relação entre disco e partições mais clara."
} > analise_final.txt

echo "Arquivos de evidência atualizados."
