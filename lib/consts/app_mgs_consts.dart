class AppMgsConsts {
  static const String title = 'Getting Things Done App';
  static const String titleColetaPage = 'Coleta';
  static const String labelCampoNovo = 'Adicione um novo item';
  static const String hintCampoNovo = 'Ex. limpar o quarto';
  static const String msgDescriaoObrigatoria = 'A descrição não pode ser vazia!';
  static const String labelBotaoCancelar = 'Cancelar';
  static const String labelBotaoLimparTudo = 'Limpar tudo';
  static const String titleLimpaTudo = 'Limpar tudo?';
  static const String msgLimpaTudo = 'Você tem certeza que deseja apagar a listagem?';
  static const String labelBotaoDeletar = 'Deletar';
  static const String labelBotaoConfirmar = 'Confirmar';
  static const String labelBotaoDesfazer = 'Desfazer';

  static String msgRemocao(qtdItens) => 'Item $qtdItens foi removido com sucesso!';

  static String msgQtdItensPendentes(qtdItens) => 'Você possui $qtdItens itens pedentes';
}
