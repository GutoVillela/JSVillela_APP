import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jsvillela_app/dml/grupo_de_redeiros_dmo.dart';
import 'package:jsvillela_app/infra/enums.dart';
import 'package:jsvillela_app/infra/infraestrutura.dart';
import 'package:jsvillela_app/models/grupo_de_redeiros_model.dart';
import 'package:jsvillela_app/stores/cadastrar_grupo_de_redeiros_store.dart';
import 'package:scoped_model/scoped_model.dart';

class TelaCadastrarNovoGrupoDeRedeiros extends StatefulWidget {
  //#region Atributos

  /// Tipo de manutenção desta tela (inclusão ou alteração)
  final TipoDeManutencao tipoDeManutencao;

  /// Grupo de Redeiros a ser editado.
  final GrupoDeRedeirosDmo? grupoASerEditado;

  /// Store utilizado para manipular a tela.
  late CadastrarGrupoDeRedeirosStore grupoDeRedeirosStore;
  //#endregion Atributos

  //#region Construtor(es)
  TelaCadastrarNovoGrupoDeRedeiros(
      {required this.tipoDeManutencao, this.grupoASerEditado}){
    grupoDeRedeirosStore = CadastrarGrupoDeRedeirosStore(tipoDeManutencao: tipoDeManutencao);
  }
  //#endregion Construtor(es)

  @override
  _TelaCadastrarNovoGrupoDeRedeirosState createState() =>
      _TelaCadastrarNovoGrupoDeRedeirosState();
}

class _TelaCadastrarNovoGrupoDeRedeirosState
    extends State<TelaCadastrarNovoGrupoDeRedeiros> {

  /// Chave global para o formulário de cadastro.
  final _formKey = GlobalKey<FormState>();

  ///Controller utilizado no campo de texto "Nome do Grupo".
  final _nomeGrupoDeRedeirosController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.tipoDeManutencao ==
        TipoDeManutencao.alteracao)
      _nomeGrupoDeRedeirosController.text = widget.grupoASerEditado!.nomeGrupo;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Observer(
              builder: (_){
                return Text(
                    widget.grupoDeRedeirosStore.tipoDeManutencao ==
                        TipoDeManutencao.cadastro
                        ? "CADASTRAR GRUPO"
                        : "EDITAR GRUPO"
                );
              },
            ),
            centerTitle: true),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _nomeGrupoDeRedeirosController,
                onChanged: widget.grupoDeRedeirosStore.setNomeGrupo,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.grid_on),
                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                    isDense: true,
                    border: OutlineInputBorder(),
                    hintText: "Nome do Grupo"
                ),
                validator: (text) {
                  if (text!.isEmpty) return "Nome obrigatório!";
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: Observer(
                  builder: (_){
                    return ElevatedButton(
                        child: !widget.grupoDeRedeirosStore.processando ?
                        Text(
                          widget.grupoDeRedeirosStore.tipoDeManutencao ==
                              TipoDeManutencao.cadastro
                              ? "Cadastrar Grupo"
                              : "Editar grupo",
                          style: TextStyle(fontSize: 20),
                        ) :
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                              return Theme.of(context).primaryColor;
                            })
                        ),
                        onPressed: !widget.grupoDeRedeirosStore.habilitaBotaoDeCadastro ? null : () async {

                          if (_formKey.currentState!.validate()) {

                            if (widget.grupoDeRedeirosStore.tipoDeManutencao  ==
                                TipoDeManutencao.cadastro){
                              // CADASTRO DO GRUPO
                              if(await widget.grupoDeRedeirosStore.cadastrarGrupoDeRedeiros() != null){
                                _finalizarCadastroDoGrupoDeRedeiros();
                              }
                              else{
                                _informarErroDeCadastro();
                              }
                            }
                            else{
                              // EDIÇÃO DO GRUPO
                              GrupoDeRedeirosDmo grupo = GrupoDeRedeirosDmo(
                                  nomeGrupo: _nomeGrupoDeRedeirosController.text,
                                  idGrupo: widget.grupoASerEditado == null
                                      ? ""
                                      : widget.grupoASerEditado!.idGrupo);
                              if(await widget.grupoDeRedeirosStore.editarGrupoDeRedeiros(grupo) != null){
                                _finalizarCadastroDoGrupoDeRedeiros();
                              }
                              else{
                                _informarErroDeCadastro();
                              }
                            }
                          }
                        }
                      );
                  },
                ),
              )
            ],
          ),
        )
    );
  }

  /// Callback chamado quando o cadastro ou edição for realizado com sucesso.
  void _finalizarCadastroDoGrupoDeRedeiros() {
    Infraestrutura.mostrarMensagemDeSucesso(
        context,
        widget.tipoDeManutencao  ==
                TipoDeManutencao.cadastro
            ? "Grupo cadastrado com sucesso!"
            : "Grupo editado com sucesso!");

    Navigator.of(context).pop();
  }

  /// Callback chamado quando ocorer um erro no cadastro ou edição.
  void _informarErroDeCadastro() {
    Infraestrutura.mostrarMensagemDeErro(
        context,
        widget.tipoDeManutencao ==
            TipoDeManutencao.cadastro
            ? (widget.grupoDeRedeirosStore.erro ?? "Falha ao cadastrar grupo!")
            : (widget.grupoDeRedeirosStore.erro ?? "Falha ao editar grupo!"));
  }
}
