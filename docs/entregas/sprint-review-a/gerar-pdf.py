"""Exporta os slides renderizados pelo gerador JS para o PDF de apresentação.

Uso: python gerar-pdf.py <pasta-build> <destino.pdf>
Dependência: reportlab. O PPTX conserva texto e tabelas editáveis; o PDF de
segurança usa as imagens renderizadas para preservar o aspeto dos slides.
"""
from pathlib import Path
import sys

from reportlab.pdfgen import canvas

build_dir = Path(sys.argv[1])
destination = Path(sys.argv[2])
slides = sorted(build_dir.glob('slide-*.png'))
if len(slides) != 12:
    raise SystemExit('São esperados exatamente 12 slides renderizados.')
destination.parent.mkdir(parents=True, exist_ok=True)
pdf = canvas.Canvas(str(destination), pagesize=(960, 540))
pdf.setTitle('Sprint Review A - Plataforma de Literacia em Saúde para Jovens')
pdf.setAuthor('Diogo Escobar, João Crasto e Pedro Vale')
for slide in slides:
    pdf.drawImage(str(slide), 0, 0, width=960, height=540)
    pdf.showPage()
pdf.save()
print(f'PDF criado: {len(slides)} páginas.')
