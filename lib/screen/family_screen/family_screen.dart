import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/service/auth_service.dart';
import '../../domain/service/firestore_service.dart';
import '../../widgets/text_button_style.dart';
import '../loading_screen/loading_screen.dart';
import 'bloc/family_bloc.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FamilyBloc(
        firestoreService: context.read<FirestoreService>(),
        authService: context.read<AuthService>(),
      )..add(FamilyLoadingEvent()),
      child: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {
          if (state is FamilyCurrentState) {
            if (state.members.isNotEmpty) {
              return FamilyColumn(
                state: state,
              );
            } else {
              return const FamilyIsNotCreate();
            }
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}

class FamilyColumn extends StatelessWidget {
  final FamilyCurrentState state;
  const FamilyColumn({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMember(context, state),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(state.family.name),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: state.members.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        state.members[index].name,
                      ),
                      Text(' (${state.members[index].email})'),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.read<FamilyBloc>().add(
                        DeleteMemberEvent(
                          userId: state.members[index].id,
                          familiesId: state.members[index].family!.id,
                        ),
                      ),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FamilyIsNotCreate extends StatelessWidget {
  const FamilyIsNotCreate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Вас не добавили ни в одну семью. Дождитесь приглашения или создайте ее самостоятельно.',
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextButtonStyle(
                text: 'Создать семью', function: () => _createFamily(context)),
          ],
        ),
      ),
    );
  }
}

void _createFamily(
  BuildContext context,
) async {
  const inputDecoration = InputDecoration(
    hintText: 'Введите название семьи',
    border: OutlineInputBorder(),
  );
  final nameController = TextEditingController();
  final bloc = context.read<FamilyBloc>();
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Center(child: Text('Создать семью')),
      content: TextField(
        controller: nameController,
        decoration: inputDecoration,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                bloc.add(
                  CreateFamilyEvent(name: nameController.text),
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    ),
  );
}

void _addMember(
  BuildContext context,
  FamilyCurrentState state,
) async {
  const inputDecoration = InputDecoration(
    hintText: 'Введите почту члена семьи',
    border: OutlineInputBorder(),
  );
  final emailController = TextEditingController();
  final bloc = context.read<FamilyBloc>();
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Center(child: Text('Добавить члена семьи')),
      content: TextField(
        controller: emailController,
        decoration: inputDecoration,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                bloc.add(
                  AddMemberEvent(
                    email: emailController.text,
                    familiesId: state.family.id,
                  ),
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    ),
  );
}
