# Siscan

Sistema para gerenciamento de compras "fiado" em cantina escolar.

![Tela de produtos](https://raw.githubusercontent.com/osantana/siscan/master/tela.png "Tela de produtos")

## História

Esse sistema foi desenvolvido em Clipper Summer'87 durante o tempo em que
estudei o Curso Técnico em Segundo Grau de Processamento de Dados na [ETE
"Philadelpho Gouvea Netto"](http://www.philadelpho.com.br/) em São José do Rio
Preto.

Tinha amizade com o dono da cantina do colégio e acabei desenvolvendo esse
sistema na base da permuta (consumindo algumas coisas na cantina) e na base de
troca de partes para meu computador.

Ele ia com frequência buscar coisas no Paraguai, que acabavam ficando
superdimensionadas para o equipamento de autoatendimento que ele montou na
cantina, e trocava comigo.

Esse terminal de autoatendimento era composto de um 286 em um mini-gabinete, um
monitor pequeno, um teclado convencional para tarefas administrativas, uma
impressora Epson LX-810 de 80 colunas e um teclado numérico com conector
serial.

![Teclado](https://raw.githubusercontent.com/osantana/siscan/master/teclado.jpg "Teclado Serial")


A impressora ficava numa caixa montada por ele e tinha uma serra (dessas usadas
em arco de serra) colada na saída do papel. Ele montava uma bobina de papel
carbonada nessa impressora e ela acabava funcionando como uma impressora de
fita como essas que vemos nos caixas de supermercado.

O teclado serial não funcionava com o Clipper então eu fiz um programa
residente (em Assembly) que lia a porta serial e inseria os caracteres
digitados no buffer circular de teclado. Implementei uma função para entrada de
dados desse teclado que permitia que cada um dos alunos da escola (com conta na
cantina) pudessem fazer seus pedidos. O código está em keytec.asm.

Esses pedidos eram impressos no papel e entregue para as funcionárias da
cantina buscarem os produtos.

Essa novidade saiu num jornal local (A Notícia) e isso despertou o interesse do
dono da cantina da FAMERP (faculdade de medicina da cidade).

Na FAMERP o sistema rodava em duas máquinas numa rede (cabo coaxial) com Novell
DOS 7. E tinha um modo de funcionamento para "balança" para o restaurante a
quilo.


## Free e Opensource Software

Uma coisa interessante dessa época é que eu não tinha a menor noção de que
existiam movimentos que pregavam a distribuição do código fonte juntamente com
os binários.

Apesar disso todo sistema que eu desenvolvia e vendia incluia o código fonte
para o cliente. Mesmo sistemas que não foram desenvolvido por encomenda de um
cliente.

Era algo estranho para uma época onde as empresas se orgulhavam dos mecanismos
anti-cópia de seus sistemas.

Graças à isso, hoje, eu consegui recuperar arquivos de código fonte que eu
havia perdido a muito tempo. Um cliente e amigo me enviou alguns fontes usados
nessa solução de Ponto de Venda. Arquivos que eu achei que nunca mais veria.

