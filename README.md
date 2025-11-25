# 📋 Gerenciador de Atendimentos

Aplicação em **Flutter** construída para gerenciar atendimentos, com funcionalidades de criação, edição, acompanhamento de status e finalização de atendimentos, incluindo registro de fotos e relatórios.

## 🚀 Funcionalidades

* Criar novos atendimentos (status inicial: **pendente**)
* Editar atendimentos apenas quando estiverem **pendentes**
* Visualizar detalhes completos
* Iniciar atendimento (status muda para **em andamento**)
* Finalizar atendimento com:

  * Upload de imagem do atendimento (ImagePicker)
  * Campo de relatório
  * Status atualizado para **finalizado**
* Ativar / desativar atendimentos
* Filtros de listagem:

  * Por status (pendente, em andamento, finalizado)
  * Mostrar apenas ativos
* Exclusão de atendimentos (bloqueada quando em andamento)

---

## 🏗️ Arquitetura do Projeto

O projeto segue uma estrutura simples, organizada por módulos e camadas.

```
module/
 └── dashboard/
      ├── data/
      │    └── datasources/
      │         └── atendimento_local_datasource.dart
      ├── domain/
      │    └── models/
      │         └── atendimento_model.dart
      ├── state/
      │    └── atendimento_cubit.dart
      └── view/
           ├── dashboard_page.dart
           ├── atendimento_form_page.dart
           ├── atendimento_detalhes_page.dart
           └── finalizar_atendimento_page.dart
```

### **📌 Explicação rápida de cada camada:**

#### **📂 data → datasources**

Contém o `AtendimentoLocalDataSource`, responsável pelo CRUD usando **SharedPreferences** (simulação de banco local).

#### **📂 domain → models**

Contém o `AtendimentoModel`, que representa a estrutura dos dados.

#### **📂 state (Cubit)**

O `AtendimentoCubit` controla o estado da aplicação:

* carrega atendimentos
* adiciona
* atualiza
* exclui
* finaliza
* alterna ativo/inativo

Usa **flutter_bloc**.

#### **📂 view**

As telas (UI):

* `dashboard_page.dart` → lista, filtros, navegação
* `atendimento_form_page.dart` → criar/editar
* `atendimento_detalhes_page.dart` → iniciar atendimento
* `finalizar_atendimento_page.dart` → finalizar atendimento com foto e relatório

---

## 📸 Uso do ImagePicker

O `image_picker` é utilizado na tela de finalização.

Ele permite:

* abrir a galeria
* selecionar uma imagem
* salvar localmente no modelo `AtendimentoModel`

Exemplo utilizado:

```dart
final ImagePicker picker = ImagePicker();
final XFile? file = await picker.pickImage(source: ImageSource.gallery);
```

---

## 🧠 Como funciona o fluxo do atendimento

1️⃣ **Criar Atendimento**
→ Status: `pendente`

2️⃣ **Ao clicar no card**

* Se está pendente → abre tela de detalhes com botão **Iniciar Atendimento**
* Se está em andamento → abre tela de **Finalização**
* Se está finalizado → mostra informações finais

3️⃣ **Finalizar Atendimento**

* inserir relatório
* adicionar foto
* salvar

→ Status vira `finalizado`

---

## ▶️ Execução do Projeto

```
flutter pub get
flutter run
```

---

## 🧪 Tecnologias Utilizadas

* Flutter
* Dart
* flutter_bloc
* SharedPreferences
* ImagePicker

---

## 📄 Licença

Uso livre para fins acadêmicos e demonstrativos.
