![TV Tudo Banner](/android/app/src/main/res/drawable-xhdpi/tv_banner.png)

# TV Tudo

Um player simples de um site de streaming de canais de televisão brasileiros
para Android TV feito em Flutter.

## Motivação

Minha avó tem muita dificuldade com tecnologia, e este projeto foi feito
com velocidade e facilidade de uso em mente, se diferenciando de outros apps
criados com a mesma finalidade, com a qual ela tem dificuldade de usar.

A ideia é que tenha um fácil acesso aos canais favoritos do usuário, com uma
funcionalidade simplicada de configuração, e mais simples ainda de uso, como
uma demonstração de uma boa experiência de usuário a apps desta categoria de
reprodutores de streaming de TV.

## Informações técnicas

O aplicativo foi criado de forma experimental e sem o propósito de ser algo
oficialmente publicado, portanto, *here be dragons*...

Um pequeno script em Dart localizado em `bin/gerador_de_canais.dart` processa
uma requisição do site agregador de canais, transformando no arquivo
`lib\data\data\canais.dart`, com uma lista das informações dos canais
processados.

Essa lista é usada para mostrar e customizar a disposição dos canais no app, e
informa a URL onde o canal é apresentado, que é mostrado em uma WebView, após
alguns procedimentos de engenharia reversa pré-programados.

## Isenção de responsabilidade

O código fonte deste aplicativo foi desenvolvido exclusivamente para fins
educacionais.
Todos os direitos autorais e marcas registradas mencionadas ou utilizadas de
qualquer forma neste aplicativo pertencem aos seus respectivos proprietários.

Declaro que não tenho qualquer afiliação ou associação com os detentores dos
direitos autorais das marcas citadas. A utilização do código fonte
disponibilizado é de responsabilidade exclusiva do usuário, e eu, o criador do
aplicativo, me isento de  qualquer responsabilidade por eventuais má
utilizações, danos ou consequências que possam surgir a partir do uso deste
código.

Recomendo que os usuários respeitem as leis de direitos autorais e as diretrizes
de uso das marcas registradas, e que utilizem o código fonte de maneira ética e
responsável.
