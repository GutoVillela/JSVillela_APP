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