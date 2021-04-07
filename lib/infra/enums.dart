/// Enum que define as páginas da aplicação.
enum AppPages{
    login,
    inicio,
    agendarRecolhimento,
    consultarRecolhimentos,
    notificacoes,
    cadastroDeRedeiros,
    gruposDeRedeiros,
    solicitacoesDosRedeiros,
    cadastroDeMateriaPrima,
    cadastroDeRedes,
    relatorios,
    preferencias
}

/// Enum que define os aplicativos da mapas instalados pelo usuário.
enum AplicativosDeMapa{
    googleMaps,
    waze
}

/// Enum que define quais são as preferências passíveis de configurações do usuário.
enum PreferenciasDoApp{

    /// Preferência que define se a sessão do usuário será mantida no aplicativo.
    manterUsuarioLogado,

    /// Preferência de aplicativo padrão para abrir mapas.
    appPadraoMapas
}

/// Enum que define o tipo de manutenção a ser realizado em um registro CRUD.
enum TipoDeManutencao{

    /// Define que será realizado um cadastro de novo registro.
    cadastro,

    /// Define que será realizada alteração em um registro já existente.
    alteracao
}