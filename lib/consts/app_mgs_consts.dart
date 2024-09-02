class AppMgsConsts {
  static const String title = 'Getting Things Done App';
  static const String titleColetaPage = 'Coleta';
  static const String labelCampoNovo = 'Adicione um novo item';
  static const String hintCampoNovo = 'Ex. limpar o quarto';
  static const String msgDescriaoObrigatoria = 'Descrição não pode ser vazia!';
  static const String labelBotaoCancelar = 'Cancelar';
  static const String labelBotaoLimparTudo = 'Limpar tudo';
  static const String titleLimpaTudo = 'Limpar tudo?';
  static const String msgLimpaTudo = 'Você tem certeza que deseja apagar a listagem?';
  static const String labelBotaoDeletar = 'Deletar';
  static const String labelBotaoConfirmar = 'Confirmar';
  static const String labelBotaoDesfazer = 'Desfazer';

  static String msgRemocao(qtdItens) => 'Item $qtdItens foi removido com sucesso!';

  static String msgQtdItensPendentes(qtdItens) => 'Você possui $qtdItens itens pedentes';

  static const String titleListasPage = 'Listas';
  static const String titleProcessar = 'Processar';
  static const String titleMoverPara = 'Mover para...';
  static const String labelBotaoMover = 'Mover';
  static const String titleProximas = 'Próximas';
  static const String titleEspera = 'Espera';
  static const String titleTalvez = 'Talvez';
  static const String titleFinalizados = 'Finalizados';
  static const String titleAgendados = 'Agendados';
  static const String labelNenhumItem = 'Nenhum item';

  static String msgErroCarregamentoLista(erro) => 'Erro ao carregar listas: $erro';

  static const String labelListas = 'Listas';
  static const String labelProcessar = 'Processar';
  static const String labelMoverTalvez = 'Talvez/Um dia';
  static const String titleProcessamento = 'Etapa de processamento';
  static const String labelFinalizar = 'Finalizar/Fazer agora';
  static const String labelEmEspera = 'Ações em espera';
  static const String titleProximaAcao = 'Próximas ações';
  static const String labelProjetos = 'Projetos';
  static const String labelAgendar = 'Agendar/Calendário';
  static const String labelDescricaoOperacao = 'Escolher destino para o tópico abaixo:';
  static const String labelPrimeiroPasso = 'Qual é o primeiro passo?';
  static const String hintPrimeiroPasso = 'Ex. Anotar preço';
  static const String labelEhProjeto = 'Projeto';
  static const String titleMovendoItem = 'Selecione a lista a quase deseja mover o item:';
}
