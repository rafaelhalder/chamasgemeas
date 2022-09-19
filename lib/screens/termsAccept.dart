import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAccept extends StatefulWidget {
  @override
  _TermsAcceptState createState() => _TermsAcceptState();
}

class _TermsAcceptState extends State<TermsAccept> {
  String selectedIndex = '';
  User? user = FirebaseAuth.instance.currentUser;
  int age = 0;
  String height = '';
  String weight = '';
  String occupation = '';
  String city = '';
  String country = '';
  String whatsapp = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const TextStyle textstyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    const InputDecoration decoration = InputDecoration(
      border: OutlineInputBorder(),
    );

    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/interfacesigno.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 238, 238, 238),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Termos \n',
                            style: GoogleFonts.quicksand(
                                fontSize: 27,
                                color: Color.fromARGB(255, 147, 132, 100),
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width * 0.9,
                  height: size.height * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white)),
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.quicksand(
                            fontSize: 13,
                            color: Color.fromARGB(255, 168, 164, 151),
                            fontWeight: FontWeight.w400),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'TERMOS DE USO \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  '1. Aceitação dos Termos de uso Ao criar uma conta no Chamas Gêmeas, seja através de dispositivo móvel, aplicativo móvel ou computador você concorda em vincular-se (i) aos presentes Termos de Uso, (ii) à nossa Regras da Comunidade, nossa  Política de Privacidade e  nossas Dicas de Segurança, cada qual será incorporado a este Contrato por referência, bem como (iii) quaisquer termos divulgados e assinados por você ao adquirir recursos adicionais, produtos ou serviços que oferecemos no Serviço (coletivamente, este “Contrato”). Se você não aceita e não concorda em vincular-se aos termos deste Contrato, não utilize o nosso Serviço. Periodicamente, o Contrato e o Serviço podem ser alterados. Podemos fazê-lo por diversas razões, inclusive para refletir as alterações ou exigências legais, novos recursos ou mudanças nas práticas comerciais. A versão mais recente deste Contrato será publicada no aplicativo Chamas Gêmeas. A versão mais recente é a que se aplica. Se as alterações incluírem emendas significativas a seus direitos ou obrigações, você será notificado das alterações com pelo menos 30 dias de antecedência (salvo se não for possível fazer isso nos termos da lei aplicável), por meios razoáveis, o que pode incluir notificação por meio do Serviço ou por e-mail. Se você continuar a utilizar o Serviço após as alterações entrarem em vigor, isso significa que você concorda com o Contrato revisado. 2. Requisistos Você não tem autorização para criar uma conta, acessar ou usar o Serviço ou sistemas em que eles residem, a não ser que uma das opções abaixo seja verdadeira: • você tem pelo menos 18 anos de idade, • você pode firmar um contrato vinculativo com o Chamas Gêmeas, • cumprirá este Contrato e todas as leis, normas e regulamentos municipais, estaduais, nacionais e internacionais aplicáveis e • você nunca foi condenado por crime ou ofensa grave (ou qualquer crime de mesma gravidade), crime de assédio sexual, ou qualquer crime que envolva violência, e que você não é obrigado a se registrar no cadastro de criminosos sexuais de qualquer estado, federação ou local.'),
                          TextSpan(
                              text:
                                  '3. Sua conta Você pode acessar o Tinder de várias maneiras, incluindo as suas credenciais do Facebook. Se escolher usar suas credenciais do Facebook, você nos autoriza a acessar e utilizar determinadas informações da sua conta do Facebook, inclusive, entre outras, o seu perfil público no Facebook. Para saber mais sobre as informações que coletamos de você e como as utilizamos, consulte a nossa Política de Privacidade. Você é responsável por manter a confidencialidade de suas credenciais de login que utiliza para se conectar ao Chamas Gêmeas, além de ser o único responsável por todas as atividades associadas ao uso dessas credenciais. Se você acredita que alguém obteve acesso à sua conta, entre em contato conosco imediatamente. 4. Alteração do Serviço e Rescisão O Chamas Gêmeas pode oferecer funcionalidades adicionais que possam ser úteis e interessantes para você. Isso significa que podemos incluir novos recursos ou aprimorar produtos ao longo do tempo, bem como remover alguns recursos e, se essas ações não afetarem os seus direitos e obrigações significativamente, talvez não forneceremos aviso prévio antes de removê-los. Podemos até mesmo suspender totalmente o Serviço, caso em que você será notificado com antecedência, a menos que circunstâncias atenuantes, como questões de segurança, impeçam-nos de fazê-lo. Você pode encerrar a sua conta a qualquer momento, por qualquer motivo, na opção de cancelamento de conta dentro do aplicativo. No entanto, se você usar uma conta de pagamento de terceiros, como a App Store ou a iTunes Store da Apple, conforme o caso (“App Store”) ou a Google Play Store, você precisará gerenciar suas compras no aplicativo por meio dessa conta para evitar cobranças adicionais. O Chamas Gêmeas poderá cancelar a sua conta a qualquer momento, sem aviso prévio, se acreditar que você violou este Contrato. Após o referido cancelamento, você não terá direito a nenhum reembolso pelas compras. Após o cancelamento de sua conta, este Contrato será rescindido, considerando que as seguintes disposições continuarão em vigor entre você e o Chamas Gêmeas: seção 4, seção 5 e seções 11 a 18.'),
                          TextSpan(
                              text:
                                  '5. Segurança; suas interações com outros membros. O Chamas Gêmeas se esforça para incentivar uma experiência de membro com respeito. Para isso, usamos recursos como a dupla aceitação, que permite aos membros se comunicarem apenas se ambos tiverem interesse um pelo outro. Porém, o Chamas Gêmeas não é responsável pela conduta do membro dentro ou fora do Serviço. Você concorda em agir com cautela em todas as interações com outros membros, especialmente ao decidir se comunicar fora do Serviço ou pessoalmente. Além disso, você concorda em revisar e seguir as Dicas de Segurança do Chamas Gêmeas antes de utilizar o Serviço. Você concorda que não fornecerá suas informações financeiras (p. ex., cartão de crédito ou informações de conta bancária) e que não transferirá ou enviará dinheiro por outros meios a outros membros. VOCÊ TEM RESPONSABILIDADE EXCLUSIVA POR SUAS INTERAÇÕES COM OUTROS MEMBROS. VOCÊ COMPREENDE QUE O CHAMAS GÊMEAS NÃO INVESTIGA OS ANTECEDENTES CRIMINAIS DOS MEMBROS, NEM VERIFICA O HISTÓRICO DOS MEMBROS. O CHAMAS GÊMEAS NÃO MANIFESTA DECLARAÇÕES OU GARANTIAS EM RELAÇÃO À CONDUTA OU À COMPATIBILIDADE DOS MEMBROS. 6. Direitos concedidos a você pelo Chamas Gêmeas O Chamas Gêmeas concede a você uma licença pessoal, universal, isenta de royalties, intransferível, não exclusiva, revogável e não sublicenciável para acessar e utilizar o Serviço. Essa licença é para o propósito exclusivo de permitir que você use e desfrute dos benefícios do Serviço, conforme a intenção do Chamas Gêmeas e autorização prevista neste Contrato. Essa licença e qualquer autorização para acessar o Serviço será automaticamente revogada caso você faça alguma das ações abaixo: • usar o Serviço, ou qualquer conteúdo contido no Serviço, para fins comerciais sem a nossa autorização por escrito; • copiar, modificar, transmitir, criar trabalhos derivados, fazer uso ou reproduzir em qualquer formato materiais protegidos por direitos autorais, imagens, marcas comerciais, nomes comerciais, marcas de serviço ou outros direitos de propriedade intelectual, conteúdo ou informações de propriedade exclusiva acessíveis através do Serviço, sem a autorização prévia por escrito do Chamas Gêmeas; • expressar ou sugerir que suas declarações sejam endossadas pelo Chamas Gêmeas; • utilizar robô, bot, spider, rastreador, scraper, aplicativo de busca/recuperação de site, proxy ou outro dispositivo, método ou processo manual ou automático para acessar, recuperar, indexar, realizar “data mine” ou, de outra forma, reproduzir ou contornar a estrutura de navegação ou apresentação do Serviço ou conteúdos; • utilizar o Serviço de forma que possa interferir, interromper ou afetar negativamente o Serviço, os servidores ou redes conectadas ao Serviço; • enviar vírus ou outro código malicioso ou, de outra forma, comprometer a segurança do Serviço; • forjar cabeçalhos ou manipular outros identificadores para disfarçar a origem das informações transmitidas para ou através do Serviço;'),
                          TextSpan(
                              text:
                                  '• “enquadrar” ou “espelhar” qualquer parte do Serviço sem autorização prévia por escrito do Chamas Gêmeas; • utilizar meta-tags, códigos ou outros dispositivos que contenham referências ao Chamas Gêmeas ou ao Serviço (ou marca comercial, marca registrada, marca de serviço, logotipo ou slogan do Chamas Gêmeas) para direcionar pessoas para outro site, para qualquer fim; • modificar, adaptar, sublicenciar, traduzir, vender, promover engenharia reversa, decifrar, descompilar ou desmontar qualquer parte do Serviço ou fazer com que outras pessoas o façam; • utilizar ou desenvolver aplicativos de terceiros que interajam com o Serviço, o conteúdo ou informações de outros membros sem a nossa autorização por escrito; • utilizar, acessar ou publicar a interface de programação do aplicativo Chamas Gêmeas sem a nossa autorização por escrito; • verificar, analisar ou testar a vulnerabilidade de nosso Serviço ou de qualquer sistema ou rede; • incentivar ou promover qualquer atividade que viole este Contrato. O Chamas Gêmeas pode investigar e tomar todas as medidas legalmente disponíveis em resposta a usos ilegais e/ou não autorizados do Serviço, inclusive o cancelamento da sua conta. Qualquer software que fornecemos a você pode automaticamente baixar e instalar atualizações, melhorias ou outros novos recursos. Você poderá ajustar downloads automáticos através das configurações do seu dispositivo.'),
                          TextSpan(
                              text:
                                  '\n 7. Direitos concedidos ao Chamas Gêmeas por você \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Ao criar uma conta, você concede ao Chamas Gêmeas uma licença universal, transferível, sublicenciável e isenta de royalties e o direito de hospedar, armazenar, utilizar, copiar, exibir, reproduzir, adaptar, editar, publicar, modificar e distribuir informações que você nos autoriza a acessar de terceiros, como o Facebook, bem como outras informações que você publicar, fizer upload, exibir ou, de outra forma, disponibilizar (coletivamente, “publicar”) no Serviço ou transmitir a outros membros (coletivamente, “Conteúdo”). Referente ao seu Conteúdo, a licença do Chamas Gêmeas não será exclusiva, considerando que a licença do Chamas Gêmeas será exclusiva com relação aos trabalhos derivados criados por meio da utilização do Serviço. Por exemplo, o Chamas Gêmeas pode ter uma licença exclusiva às capturas de tela do Serviço que incluam o seu Conteúdo. Além disso, para que o Chamas Gêmeas possa evitar o uso de seu Conteúdo fora do Serviço, você autoriza o Chamas Gêmeas a agir em seu nome com relação a usos ilícitos de seu Conteúdo retirados do Serviço por outros membros ou terceiros. Isso inclui expressamente a autorização, mas não a obrigação, de enviar avisos em seu nome caso o Conteúdo seja retirado e utilizado por terceiros fora do Serviço. Nossa licença referente ao seu Conteúdo está sujeita a seus direitos de acordo com a lei aplicável (por ex., leis referentes à proteção de dados pessoais, na medida em que qualquer Conteúdo contenha informações pessoais, conforme definido por tais leis) e para fins exclusivos de operação, desenvolvimento, fornecimento e melhoria do Serviço, bem como pesquisas e desenvolvimentos de novos serviços. Você concorda que qualquer Conteúdo que você colocar ou nos autorizar a colocar no Serviço poderá ser visto por outros membros e por qualquer outra pessoa que esteja acessando ou participando do Serviço (como pessoas que podem receber Conteúdo compartilhado por outros membros do Chamas Gêmeas).'),
                          TextSpan(
                              text:
                                  'Você concorda que todas as informações apresentadas após a criação da sua conta, inclusive informações enviadas da sua conta do Facebook, são corretas e verdadeiras, e você tem o direito de publicar o Conteúdo no Serviço e conceder a licença acima descrita ao Chamas Gêmeas. Você compreende e concorda que podemos monitorar ou revisar qualquer Conteúdo que você publicar como parte do Serviço. Podemos excluir qualquer Conteúdo, no todo ou em parte, que, a nosso critério exclusivo, viole este Contrato ou possa prejudicar a reputação do Serviço. Ao se comunicar com os nossos representantes de atendimento ao cliente, você concorda em agir com respeito e gentileza. Se considerarmos que o seu comportamento em relação a qualquer de nossos representantes de atendimento ao cliente ou outros funcionários revele-se, em qualquer momento, ameaçador, perturbador ou ofensivo, reservamo-nos o direito de cancelar a sua conta imediatamente. Em consideração ao Chamas Gêmeas, o qual permite que você utilize o Serviço, você concorda que poderá haver publicidade no Serviço veiculada por nós, nossas afiliadas e parceiros terceirizados. Ao enviar sugestões ou comentários ao Chamas Gêmeas sobre o nosso Serviço, você concorda que o Chamas Gêmeas poderá utilizar e compartilhar as sugestões para qualquer finalidade, sem compensação.'),
                          TextSpan(
                              text:
                                  'Você está ciente de que o Chamas Gêmeas poderá acessar, armazenar e divulgar as informações da sua conta e Conteúdo se exigido por lei ou se acreditar, de boa-fé, que o acesso, armazenamento ou divulgação satisfaçam um interesse legítimo, incluindo: (i) cumprir com um processo judicial; (ii) fazer cumprir o Contrato; (iii) responder a reivindicações de qualquer Conteúdo que viole os direitos de terceiros; (iv) responder às suas solicitações de atendimento ao cliente; ou (v) proteger os direitos, bens ou segurança pessoal da Empresa ou de qualquer outra pessoa.'),
                          TextSpan(
                              text: '\n 8. Regras da comunidade \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Ao utilizar o Serviço, você concorda em não: • utilizar o Serviço para qualquer finalidade que seja ilegal ou proibida por este Contrato; • usar o Serviço para qualquer fim prejudicial ou desonesto; • usar o Serviço com o propósito de prejudicar o Chamas Gêmeas; • violar as nossas Regras da Comunidade, atualizadas periodicamente; • fazer spam, solicitar dinheiro ou fraudar qualquer membro; • personificar qualquer pessoa ou entidade, ou publicar imagens de outra pessoa sem a permissão dela; • ameaçar, perseguir, intimidar, agredir, assediar, maltratar ou difamar qualquer pessoa; • publicar qualquer Conteúdo que viole ou infrinja os direitos de outra pessoa, inclusive direitos de publicidade, privacidade, direitos autorais, marca comercial ou outra propriedade intelectual ou direito contratual; • publicar qualquer Conteúdo de ódio, ameaçador, sexualmente explícito ou pornográfico. • publicar qualquer Conteúdo que incite a violência, contenha nudez, violência gráfica ou gratuita. • publicar qualquer Conteúdo que promova racismo, fanatismo, ódio ou danos físicos de qualquer natureza contra qualquer grupo ou indivíduo; • solicitar senhas e informações de identificação pessoal de outros membros, para qualquer propósito, para fins comerciais ou ilegais, ou divulgar informações pessoais de outra pessoa sem a permissão dela; • usar a conta de outro membro, compartilhar uma conta com outro membro ou manter mais de uma conta; • criar outra conta se já tivermos cancelado a sua conta, a menos que você tenha a nossa permissão. O Chamas Gêmeas reserva-se o direito de investigar e/ou cancelar a sua conta, sem o reembolso de qualquer compra, se você violar este Contrato, utilizar o Serviço de forma inadequada ou se comportar de uma forma que considere inadequada ou ilegal, incluindo ações ou comunicações que ocorram dentro ou fora do Serviço.  Caso você viole essas regras ou as nossas Regras da Comunidade, sua autorização para usar o Serviço será automaticamente revogada.'),
                          TextSpan(
                              text: '\n 9. Conteúdo de outros membros \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Embora o Chamas Gêmeas reserve-se no direito de revisar e remover o Conteúdo que viola este Contrato, o referido Conteúdo é de exclusiva responsabilidade do membro que o publica, e o Chamas Gêmeas não pode garantir que todo o Conteúdo cumprirá com este Contrato. Se você se deparar com algum Conteúdo no Serviço que implique na violação deste Contrato, informe o problema diretamente pelo Serviço ou pelo nosso contato.'),
                          TextSpan(
                              text: '\n 10. Compras. \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Geral. Ao longo do tempo, o Chamas Gêmeas poderá oferecer produtos e serviços para compra (“compras no aplicativo”) por meio da App Store, da Google Play Store, da operadora, por cobrança direta do Chamas Gêmeas ou outras plataformas de pagamento autorizadas pelo Chamas Gêmeas. Se você optar por fazer uma compra no aplicativo, terá que confirmar a sua compra com o provedor de pagamento aplicável e receberá uma cobrança conforme o seu método de pagamento (cartão ou um meio pertencente a terceiros, como a Google Play Store ou a App Store (o seu “Método de Pagamento”) nos preços atribuídos ao(s) serviço(s) que você selecionou, bem como quaisquer vendas ou impostos similares que possam ser aplicáveis aos seus pagamentos. Dessa forma, você autoriza o Chamas Gêmeas ou a conta de terceiros a realizar uma cobrança. Renovação automática; Pagamento automático com cartão Se você adquirir uma assinatura periódica de renovação automática por meio de uma compra no aplicativo, seu Método de Pagamento será cobrado continuamente pela assinatura até que você a cancele. Após o período do compromisso de assinatura inicial, e novamente após qualquer período de assinatura subsequente, sua assinatura continuará automaticamente por um período adicional equivalente, pelo preço que você concordou ao assinar. As informações de pagamento do seu cartão serão armazenadas e posteriormente usadas para os pagamentos automáticos de cartão, de acordo com o Contrato. As objeções a um pagamento já efetuado devem ser direcionadas ao atendimento ao cliente se você tiver sido cobrado diretamente pelo Chamas Gêmeas ou por uma conta relevante de terceiros, como a App Store ou Play Store. Você também pode fazer uma objeção entrando em contato com seu banco ou provedor de pagamento, que pode fornecer mais informações sobre seus direitos, bem como os prazos aplicáveis. Você pode, de maneira incondicional, retirar o seu consentimento em relação aos pagamentos automáticos com cartão a qualquer momento ao acessar as Configurações do Chamas Gêmeas ou da conta de terceiros correspondente, mas saiba que você ainda é obrigado a pagar quaisquer quantias pendentes. Se deseja alterar ou encerrar a sua assinatura, você deverá fazer o login na sua conta de terceiros  e seguir as instruções para cancelar a sua assinatura, mesmo que tenha excluído a sua conta conosco ou o aplicativo Chamas Gêmeas do seu dispositivo. Excluir a sua conta ou o aplicativo do Chamas Gêmeas do seu dispositivo não faz com que a sua assinatura seja encerrada ou cancelada; o Chamas Gêmeas reterá todos os fundos debitados do Método de Pagamento selecionado até que você encerre ou cancele a sua assinatura pelo Chamas Gêmeas e pela conta de terceiros, conforme aplicável. Se você encerrar ou cancelar sua assinatura, você poderá usá-la até o final de seu prazo atual, e ela não será renovada após esse período. Há alguns termos adicionais aplicáveis caso você realize o pagamento utilizando o seu Método de Pagamento escolhido. Se você realizar o pagamento diretamente no aplicativo, o Chamas Gêmeas poderá corrigir quaisquer erros de cobrança mesmo que já tenha solicitado ou recebido o pagamento. Se você der início a um pedido de reembolso ou reverter um pagamento feito pelo seu Método de Pagamento, o Chamas Gêmeas poderá encerrar sua conta imediatamente, a seu exclusivo critério.'),
                          TextSpan(
                              text:
                                  'Se um pagamento não for liquidado com êxito devido à validade, à insuficiência de fundos ou a outros motivos, ou cancelar sua assinatura, você continuará sendo responsável por quaisquer montantes não cobrados e nos autorizará a continuar cobrando seu Método de Pagamento, pois este poderá ser atualizado. Isso pode resultar na alteração de suas datas de pagamento e faturamento. Além disso, você nos autoriza a obter uma atualização ou substituição das datas de validade e dos números de seu cartão de débito ou crédito, conforme fornecido pelo emissor do cartão. As condições de pagamento serão baseadas em seu Método de Pagamento e poderão ser determinadas por acordos feitos entre você e a instituição financeira, o emissor do cartão de crédito ou outro provedor de seu Método de Pagamento escolhido. Itens Virtuais. Ao longo do tempo, você poderá adquirir ou ganhar uma licença limitada, pessoal, intransferível, não sublicenciável e revogável para utilizar "itens virtuais", que podem incluir produtos ou “moedas” virtuais, ou outras unidades que podem ser trocadas, dentro do Serviço, por produtos virtuais (coletivamente, "Itens Virtuais"). Qualquer saldo de Item Virtual exibido em sua conta não constitui um saldo do mundo real nem reflete qualquer valor armazenado, mas constitui uma medida da extensão de sua licença. Os Itens Virtuais não incorrem em taxas por não utilização, no entanto, a licença concedida a você em Itens Virtuais será rescindida em acordo com os termos deste Contrato, quando o Chamas Gêmeas deixar de fornecer o Serviço ou a sua conta for encerrada ou rescindida. O Chamas Gêmeas, a seu critério exclusivo, reserva-se o direito de cobrar taxas pelo direito de acessar ou utilizar Itens Virtuais e poderá distribuir Itens Virtuais com ou sem custo. O Chamas Gêmeas poderá gerenciar, regulamentar, controlar, modificar ou eliminar Itens Virtuais a qualquer momento. O Chamas Gêmeas não terá qualquer responsabilidade perante você ou qualquer terceiro, caso o Chamas Gêmeas exerça esses direitos. Itens Virtuais só podem ser resgatados por meio do Serviço. TODAS AS COMPRAS E RESGATES DE ITENS VIRTUAIS FEITOS POR MEIO DO SERVIÇO SÃO DECISIVOS E NÃO REEMBOLSÁVEIS. O fornecimento de Itens Virtuais para uso no Serviço é um serviço que inicia imediatamente após a aceitação da sua compra dos Itens Virtuais. VOCÊ RECONHECE QUE O CHAMAS GÊMEAS NÃO É OBRIGADO A OFERECER REEMBOLSO POR ITENS VIRTUAIS, INDEPENDENTEMENTE DO MOTIVO, E QUE VOCÊ NÃO RECEBERÁ DINHEIRO OU OUTRAS COMPENSAÇÕES POR ITENS VIRTUAIS NÃO UTILIZADOS QUANDO UMA CONTA FOR ENCERRADA, SEJA ESTE ENCERRAMENTO VOLUNTÁRIO OU INVOLUNTÁRIO. Reembolsos. As cobranças por compras não são reembolsáveis, e não existem reembolsos ou créditos para períodos parcialmente utilizados.'),
                          TextSpan(
                              text: '\n 11. Isenção de responsabilidade \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'O CHAMAS GÊMEAS OFERECE O SERVIÇO “NO ESTADO EM QUE SE ENCONTRA”, “CONFORME DISPONÍVEL” E NA EXTENSÃO PERMITIDA PELA LEI APLICÁVEL, NÃO CONCEDE GARANTIAS DE QUALQUER TIPO, EXPRESSAS, IMPLÍCITAS, ESTATUTÁRIAS OU DE OUTRA FORMA COM RELAÇÃO AO SERVIÇO (INCLUINDO TODO O CONTEÚDO CONTIDO NO MESMO) INCLUSIVE, ENTRE OUTRAS, GARANTIAS IMPLÍCITAS DE QUALIDADE SATISFATÓRIA, COMERCIALIZAÇÃO, ADEQUAÇÃO A UM DETERMINADO FIM OU NÃO VIOLAÇÃO. O CHAMAS GÊMEAS NÃO DECLARA OU GARANTE QUE (A) O SERVIÇO SERÁ ININTERRUPTO, SEGURO OU LIVRE DE ERROS, (B) QUAISQUER DEFEITOS OU ERROS NO SERVIÇO SERÃO CORRIGIDOS, OU (C) QUE QUALQUER CONTEÚDO OU INFORMAÇÃO QUE VOCÊ OBTENHA NO OU ATRAVÉS DO SERVIÇO SERÃO PRECISAS. O CHAMAS GÊMEAS NÃO ASSUME NENHUMA RESPONSABILIDADE POR QUALQUER CONTEÚDO QUE VOCÊ, OUTROS MEMBROS OU TERCEIROS PUBLICAM, ENVIAM OU RECEBEM ATRAVÉS DO SERVIÇO. QUALQUER MATERIAL BAIXADO OU, DE OUTRA FORMA, OBTIDO ATRAVÉS DO USO DO SERVIÇO, É ACESSADO POR SUA PRÓPRIA CONTA E RISCO.'),
                          TextSpan(
                              text: '\n 12. Serviços terceirizados \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'O Serviço pode conter anúncios e promoções oferecidas por terceiros, bem como links para outros sites ou recursos. O Chamas Gêmeas não é responsável pela disponibilidade (ou falta de disponibilidade) desses sites ou recursos externos. Se optar por interagir com terceiros disponibilizados através do nosso Serviço, os termos desse terceiro controlarão a relação deles com você. O Chamas Gêmeas não é responsável pelos termos ou ações de terceiros.'),
                          TextSpan(
                              text: '\n 13. Limitação de responsabilidade \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'EM TODA A EXTENSÃO PERMITIDA PELA LEI APLICÁVEL, EM NENHUMA CIRCUNSTÂNCIA, O CHAMAS GÊMEAS, SUAS AFILIADAS, FUNCIONÁRIOS, LICENCIADORES OU PRESTADORES DE SERVIÇOS SERÃO RESPONSÁVEIS POR QUAISQUER DANOS INDIRETOS, CONSEQUENTES, EXEMPLARES, INCIDENTAIS, ESPECIAIS, PUNITIVOS OU INCREMENTADOS, INCLUSIVE, ENTRE OUTROS, PERDA DE LUCROS, INCORRIDA DIRETA OU INDIRETAMENTE, OU PERDA DE DADOS, USO, CLIENTELA E OUTRAS PERDAS INTANGÍVEIS, RESULTANTES DO SEGUINTE: (I) O SEU ACESSO, UTILIZAÇÃO OU INCAPACIDADE DE ACESSO OU UTILIZAÇÃO DOS SERVIÇOS, (II) A CONDUTA OU CONTEÚDO DE OUTROS MEMBROS OU TERCEIROS NA UTILIZAÇÃO DOS SERVIÇOS; OU (III) ACESSO, USO OU ALTERAÇÃO NÃO AUTORIZADA DO SEU CONTEÚDO, AINDA QUE O CHAMAS GÊMEAS TENHA SIDO AVISADO DA POSSIBILIDADE DOS REFERIDOS DANOS. EM NENHUMA CIRCUNSTÂNCIA, A RESPONSABILIDADE AGREGADA DO CHAMAS GÊMEAS EM RELAÇÃO A VOCÊ POR TODAS AS REIVINDICAÇÕES RELACIONADAS AO SERVIÇO EXCEDERÁ O VALOR PAGO PELO SERVIÇO.'),
                          TextSpan(
                              text: '\n 14. Indenização por Você.\n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Você concorda, na extensão permitida pela lei aplicável, em indenizar, defender e isentar o Chamas Gêmeas, nossas afiliadas e seus respectivos executivos, diretores, agentes e funcionários de e contra quaisquer e todas as reclamações, demandas, reivindicações, danos, perdas, custos, responsabilidades e despesas, inclusive honorários advocatícios decorrentes, resultantes ou relacionados, de qualquer forma, com o seu acesso ou uso do Serviço, seu Conteúdo ou a sua violação deste Contrato.'),
                          TextSpan(
                              text: '\n 15. Contrato integral. \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Este Contrato, que inclui as Regras da Comunidade,  Política de Privacidade e as Dicas de Segurança e quaisquer termos divulgados e acordados por você, se adquirir recursos, produtos ou serviços adicionais que oferecemos no Serviço, constitui o contrato integral entre você e o Chamas Gêmeas sobre a utilização do Serviço. Se qualquer disposição deste Contrato for considerada inválida, as demais disposições deste Contrato permanecerão em pleno vigor e efeito. A incapacidade da Empresa em exercer ou exigir qualquer direito ou disposição deste Contrato não constituirá uma renúncia a este direito ou disposição. Você concorda que a sua conta do Chamas Gêmeas é intransferível e todos os seus direitos sob a sua conta e seu conteúdo terminam após a sua morte. Nenhuma agência, parceria, joint venture, fiduciária ou outra relação ou contratação especial é criada como resultado deste Contrato, e você não poderá, de maneira alguma, fazer quaisquer declarações ou vincular ao Chamas Gêmeas..'),
                          TextSpan(
                              text: '\n 16. Foro competente. \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'As partes elegem o foro da Comarca de Curitiba, estado do Paraná, para dirimir questões decorrentes desse Contrato, com exclusão de qualquer outro por mais privilegiado que seja.'),
                          TextSpan(
                              text: '\n Regras da comunidade \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                            text:
                                'Bem-vindo à comunidade Chamas Gêmeas. Você não chegou aqui por acaso. Tenha sempre em mente de que tudo o que fazemos nessa vida ecoará pela eternidade. Nossa comunidade é orientada por caráter e valores. ',
                          ),
                          TextSpan(
                              text:
                                  'Esperamos daqueles que fazem parte dessa comunidade o respeito mútuo, honestidade nas atitudes, educação na comunicação e veracidade nas informações. Atitudes anti-sociais'),
                          TextSpan(
                              text:
                                  'preconceitos de qualquer tipo, ofensas, assédio ou qualquer comportamento que viole as leis, dentro e fora do aplicativo (sim, fora do aplicativo também!), pode levar ao cancelamento da conta. Lembre-se da regra de ouro “faça aos outros apenas aquilo que gostaria que fizessem a você”. Não estamos nos relacionando apenas com corpos e avatares na internet. Estamos nos relacionando com almas! Almas em uma jornada de evolução, com sonhos, aspirações e sentimentos. Desejamos que todos tenham maturidade e responsabilidade emocional. O objetivo do aplicativo é construir relações reais. De superficialidade o mundo está cheio. Permita-se ter uma relação profunda, fazer algo diferente e trazer luz e amor verdadeiro ao mundo.'),
                          TextSpan(
                              text:
                                  'Veremos a seguir as nossas políticas de comunidade. Se você violar qualquer uma dessas políticas, poderá ser banido do Chamas Gêmeas.  Recomendamos que você denuncie qualquer comportamento que viole as nossas políticas, além de estar atento às nossas Dicas de Segurança.'),
                          TextSpan(
                              text: '\n \n O Chama Gêmea não permite \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'a Nudez e Conteúdo Sexual Pedimos que não seja incluído no aplicativo nudez e conteúdo sexual explícito, seja por imagens ou seja por textos no aplicativo. Assédio Não será tolerado o envio de conteúdos sexuais não solicitados. Não será tolerada qualquer atitude que envolva ameaça, perseguição, coação ou intimidação. Prostituição e tráfico'),
                          TextSpan(
                              text:
                                  'A conta será banida se constatado o uso do aplicativo para prostituição, serviços sexuais comerciais, tráfico humano e atos sexuais não consensuais. Violência e agressão física Não será tolerado atitudes violentas ou de incitação à violência, seja por textos ou imagens. Também é proibido qualquer material relacionado a violência a si mesmo, como conteúdos que promovam o suicídio ou auto-mutilação. Atividades Ilegais Será banido do aplicativo o uso do mesmo para atividades ilegais no país. Discurso de ódio Não será tolerado qualquer conteúdo que promova, defenda ou incentive o ódio ou a violência contra indivíduos ou grupos com base em fatores como a orientação sexual, identidade de gênero, raça, etnia, religião, deficiência, sexo, idade e nacionalidade. Divulgação de informações privadas Proteja a sua privacidade de golpes. Não publique informações privadas, suas ou de terceiros. Não divulgue números de RG, CPF, previdência, cartões de débito/crédito, passaportes, senhas, informações financeiras ou informações de contato não listadas, tais como números de telefone, endereços de e-mail ou endereço residencial e comercial. Publicidade não autorizada Não toleraremos perfis falsos que estão no aplicativo com o objetivo de propaganda e direcionamento a páginas, redes sociais ou links externos. Perfis com outras intenções Não use o aplicativo para objetivos aos quais não se destina. Não toleraremos perfis que usam a plataforma para campanhas políticas, publicidade de organizações com ou sem fim lucrativos, pesquisas de opinião pública ou para propaganda de produtos e serviços. Golpistas A conta será banida de qualquer um que tente obter informações privadas de outros usuários por meio de atividades fraudulentas ou ilegais. Não é permitido também aos usuários do aplicativo compartilhamento de suas próprias informações de contas financeiras (Conta Corrente, Pix, PayPal, etc) com a finalidade de receber dinheiro de outros usuários.'),
                          TextSpan(
                              text:
                                  'Falsificação de identidade Não é permitido o uso de identidades falsas e fotos de terceiros como se fossem as suas, mesmo que com fins humorísticos. Menores de 18 anos Você deve ter no mínimo 18 anos de idade para usar o Chamas Gêmeas. Não é permitido imagens de menores desacompanhados. Se você quiser postar fotos dos seus filhos, certifique-se de aparecer na foto também. Se você vir um perfil com fotos de um menor desacompanhado, que promova atos de violência contra menores ou que os apresente de maneira sexual ou sugestiva, denuncie imediatamente. Violações de direitos autorais e marcas comerciais Não é permitido incluir qualquer imagem protegida por direitos autorais. Não a publique, a menos que tenha permissão para fazê-lo. Isso inclui qualquer material protegido por direitos autorais. Compartilhamento de contas As contas são pessoais. Não são permitidas contas com vários donos, como contas de casais, familiares ou de parceiros. Aplicativos de terceiros O uso de quaisquer aplicativos criados por terceiros que prometem oferecer os nossos serviços ou desbloquear recursos especiais do Chamas Gêmeas não é permitido. Inatividade de conta Mantenha sua conta ativa. Se sua conta não for utilizada por 2 (dois) anos, poderemos excluí-la.'),
                          TextSpan(
                              text: '\n \n DENUNCIAS \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'No Chamas Gêmeas Comportamentos que firam nossos termos de uso podem ser denunciados AQUI.'),
                          TextSpan(
                              text:
                                  'Fora do Chamas Gêmeas: Se necessário, entre em contato com a polícia local e, em seguida, entre em contato conosco AQUI.. CLIQUE AQUI PARA OBTER DICAS SOBRE ENCONTROS SEGUROS.'),
                          TextSpan(
                              text: '\n \n ENCONTROS SEGUROS \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Na jornada em busca da Chama Gêmea, como em qualquer jornada, o planejamento e a segurança são muito importantes. Como em qualquer jornada, conheceremos pessoas extremamente interessantes, mas é necessário tomar certo cuidado com quem ainda não conhecemos perfeitamente. 1. Não tenha pressa para um encontro. É comum conversas on-line evoluírem para um encontro real e o encontro real é o objetivo. Entretanto, se dê tempo para conhecer antes a pessoa com quem você vai se encontrar. Poucas semanas de conversa não são suficientes. Quanto mais tempo de conversa melhor. Na conversa criam-se vínculos, entendem-se gostos e a personalidade e é mais fácil descobrir se a pessoa é quem realmente diz ser. 2. Ouça a sua intuição. Se algo parecer errado provavelmente está errado. Se você não se sentir confortável em um encontro, não continue o encontro. Mesmo que a pessoa pareça encantadora ou que você tenha receio de ferir os sentimentos de alguém, preste atenção aos alertas que a sua intuição fornece. 3. Locais públicos. Marque sempre os primeiros encontros em locais públicos e seguros.'),
                          TextSpan(
                              text:
                                  '4. Conte com a ajuda de alguém de confiança. Avise alguém de confiança onde estará e com quem estará. Compartilhe a localização com a pessoa de confiança se possível. Informe essas precauções com cordialidade à pessoa com quem você está se encontrando. Vivemos em um mundo complicado. Ela irá compreender. 5. Tenha uma "palavra senha" com alguém de confiança para pedir ajuda. Seja para encerrar o encontro através de um telefonema ou seja para informar uma emergência. 6. Esteja sempre no controle do seu meio de transporte. Não peça ou aceite caronas da pessoa com quem se encontra sem conhece-la ainda. 7. Nunca envie dinheiro, seja por pix ou transferência. Mesmo que a pessoa alegue estar em dificuldades ou emergência. Desconfie de pedidos de dinheiro ou doações. 8. Denuncie atitudes inconvenientes como: pedido de dinheiro, usuários menores de idade, comportamento agressivo, mensagens ofensivas e perfis falsos.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Flexible zodiac(String image, String sign, String date, String number) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = number;
          });
        },
        child: Column(
          children: [
            selectedIndex == number
                ? SimpleShadow(
                    opacity: 1, // Default: 0.5
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Default: Black
                    offset: const Offset(0.5, 1), // Default: Offset(2, 2)
                    sigma: 6,
                    child: Image.asset(
                      image,
                      width: MediaQuery.of(context).size.width * 0.46,
                    ),
                  )
                : Image.asset(
                    image,
                    width: MediaQuery.of(context).size.width * 0.46,
                  ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Color activeButton() {
    if (age != 0 &&
        height != '' &&
        weight != '' &&
        country != '' &&
        city != '' &&
        occupation != '' &&
        whatsapp != '') {
      return Colors.white;
    } else {
      return Colors.white24;
    }
  }

  Color activeButtonColor() {
    if (selectedIndex != '') {
      return const Color(0xFFECB461);
    } else {
      return Colors.black26;
    }
  }

  Container headerInput(
    String texto,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Padding inputField(
    String texto,
    dynamic name,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.purple.shade900,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        height: 40.0,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            hintText: texto,
            hintStyle: const TextStyle(
              color: Colors.white54,
              fontFamily: 'OpenSans',
            ),
          ),
          validator: (name) {
            if (name == null || name.isEmpty) {
              return 'Obrigatório';
            }
            return null;
          },
          onChanged: (value) => setState(() {
            name = value;
          }),
        ),
      ),
    );
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var maskHeight = MaskTextInputFormatter(
      mask: '#.##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}
