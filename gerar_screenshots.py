#!/usr/bin/env python3
"""Cria prints legíveis dos exercícios com aparência de terminal."""

from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import textwrap


BASE = Path(__file__).resolve().parent
DESTINO = BASE / "screenshots"
LARGURA, ALTURA = 1920, 1080
MAX_LINHAS = 25
MAX_COLUNAS = 101


def fonte(tamanho, negrito=False):
    nomes = [
        "/usr/share/fonts/TTF/JetBrainsMono-Bold.ttf" if negrito else "/usr/share/fonts/TTF/JetBrainsMono-Regular.ttf",
        "/usr/share/fonts/TTF/DejaVuSansMono-Bold.ttf" if negrito else "/usr/share/fonts/TTF/DejaVuSansMono.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf" if negrito else "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",
    ]
    for nome in nomes:
        if Path(nome).exists():
            return ImageFont.truetype(nome, tamanho)
    return ImageFont.load_default()


FONTE = fonte(30)
FONTE_TITULO = fonte(22, negrito=True)
ALTURA_LINHA = 38


def ler(nome):
    return (BASE / nome).read_text(encoding="utf-8", errors="replace").splitlines()


def sem_cabecalho(nome):
    linhas = ler(nome)
    if linhas and not linhas[0].startswith("$"):
        linhas = linhas[1:]
    while linhas and not linhas[0].strip():
        linhas.pop(0)
    return linhas


def quebrar_linhas(linhas):
    resultado = []
    for linha in linhas:
        if not linha:
            resultado.append("")
            continue
        prefixo = "$ " if linha.startswith("$ ") else ""
        texto = linha[2:] if prefixo else linha
        partes = textwrap.wrap(
            texto,
            width=MAX_COLUNAS - len(prefixo),
            replace_whitespace=False,
            drop_whitespace=False,
            subsequent_indent="  " if prefixo else "",
        ) or [""]
        resultado.extend([prefixo + partes[0], *partes[1:]])
    if len(resultado) > MAX_LINHAS:
        resultado = resultado[: MAX_LINHAS - 1]
        resultado.append("... saída completa no arquivo .txt")
    return resultado


def criar_print(numero, titulo, linhas):
    imagem = Image.new("RGB", (LARGURA, ALTURA), "#0b0f14")
    desenho = ImageDraw.Draw(imagem)

    # Barra superior parecida com a do Konsole.
    desenho.rectangle((0, 0, LARGURA, 58), fill="#20252d")
    desenho.ellipse((22, 19, 42, 39), fill="#ff5f57")
    desenho.ellipse((54, 19, 74, 39), fill="#febc2e")
    desenho.ellipse((86, 19, 106, 39), fill="#28c840")
    desenho.text(
        (132, 15),
        f"intra@archlinux: ~/Documents/Trabalhos/linux — {titulo}",
        fill="#d8dee9",
        font=FONTE_TITULO,
    )

    y = 82
    for linha in quebrar_linhas(linhas):
        if linha.startswith("$ "):
            prompt = "[intra@archlinux linux]$ "
            desenho.text((38, y), prompt, fill="#8bd450", font=FONTE)
            x = 38 + desenho.textlength(prompt, font=FONTE)
            desenho.text((x, y), linha[2:], fill="#f8f8f2", font=FONTE)
        elif linha.startswith("..."):
            desenho.text((38, y), linha, fill="#e5c07b", font=FONTE)
        else:
            desenho.text((38, y), linha, fill="#d8dee9", font=FONTE)
        y += ALTURA_LINHA

    caminho = DESTINO / f"exercicio_{numero:02d}.png"
    imagem.save(caminho, "PNG", optimize=True)
    print(f"criado: {caminho.name}")


def dados_exercicio_8():
    linhas = ler("kernel_devices.txt")
    filtro = [
        linha for linha in linhas
        if any(termo in linha for termo in ("ata1", "scsi 0:", "[sda]", " sda:"))
    ]
    return [
        "$ journalctl -k --no-pager | grep -Ei 'sda|ata1|scsi'",
        "",
        *filtro[:20],
    ]


def dados_exercicio_9():
    return [
        "$ cat /proc/devices",
        "",
        "Character devices:",
        "  1 mem",
        "  4 tty",
        "  5 /dev/console",
        " 13 input",
        " 81 video4linux",
        "116 alsa",
        "189 usb_device",
        "226 drm",
        "",
        "Block devices:",
        "  8 sd",
        "253 zram",
        "254 virtblk",
        "259 blkext",
        "",
        "Driver de caractere escolhido: tty (major 4)",
        "Driver de bloco escolhido: sd (major 8)",
    ]


def dados_exercicio_11():
    linhas = ler("filesystems.txt")
    indice_df = linhas.index("$ df -hT")
    mounts = [linha for linha in linhas[4:indice_df] if linha][:6]
    df = [linha for linha in linhas[indice_df + 1:] if linha][:8]
    return [
        "$ mount | head -n 6",
        *mounts,
        "... lista completa salva em filesystems.txt",
        "",
        "$ df -hT",
        *df,
    ]


def dados_exercicio_12():
    a = ler("etapa_a_dev.txt")
    b = ler("etapa_b_kernel.txt")
    c = ler("etapa_c_hierarquia.txt")
    return [
        *a,
        "",
        *b,
        "",
        *c,
        "",
        "$ lsblk --help | head -n 4",
        "Usage:",
        " lsblk [options] [<device> ...]",
        "List information about block devices.",
    ]


DESTINO.mkdir(exist_ok=True)

exercicios = [
    (1, "Exercício 1", sem_cabecalho("expansoes.txt")),
    (2, "Exercício 2", [
        "$ ls -1 /etc | less > pipeline.txt",
        *ler("pipeline.txt")[:18],
        "... lista completa salva em pipeline.txt",
        "$ less pipeline.txt",
    ]),
    (3, "Exercício 3", [
        "$ ls -l /dev | grep '^b' | sort -k9 | less > dispositivos_bloco.txt",
        *ler("dispositivos_bloco.txt"),
        "$ less dispositivos_bloco.txt",
    ]),
    (4, "Exercício 4", sem_cabecalho("redirecionamento.txt")),
    (5, "Exercício 5", sem_cabecalho("aspas.txt")),
    (6, "Exercício 6", sem_cabecalho("sysfs.txt")),
    (7, "Exercício 7", sem_cabecalho("udev_info.txt")[:23]),
    (8, "Exercício 8", dados_exercicio_8()),
    (9, "Exercício 9", dados_exercicio_9()),
    (10, "Exercício 10", sem_cabecalho("armazenamento.txt")),
    (11, "Exercício 11", dados_exercicio_11()),
    (12, "Exercício 12", dados_exercicio_12()),
]

for numero, titulo, linhas in exercicios:
    criar_print(numero, titulo, linhas)

print("12 screenshots atualizados em 1920x1080.")
