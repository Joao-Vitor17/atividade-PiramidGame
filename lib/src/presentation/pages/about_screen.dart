import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o App'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.info,
                    size: 60,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(height: 12),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppConstants.campus,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Objetivo
            Text(
              'Objetivo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'O Ranking de Popularidade dos Alunos é um aplicativo desenvolvido em Flutter para fins didáticos. Ele permite cadastrar alunos do IFPR – Campus Paranaguá e avaliá-los em critérios descontraídos de convivência, destaque e participação na turma.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),

            // Contexto
            Text(
              'Contexto',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Este app é um resultado da colaboração entre alunos e professores do IFPR. Nasceu da ideia criativa de aplicar conceitos de engenharia de software em um projeto lúdico que celebra a comunidade escolar e promove a interação entre alunos de forma descontraída e educativa.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),

            // Sistema de Notas
            Text(
              'Sistema de Notas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cada aluno recebe notas de 1 a 5 estrelas em 15 categorias diferentes. Essas categorias incluem aspectos como Resenha, Aura, Carisma, Humor, Talento, Estudos e muito mais.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),

            // Nível Lenda
            Text(
              'Nível Lenda',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A soma das notas forma o "Nível Lenda", que varia de 15 pontos (mínimo: 1 estrela em cada critério) até 75 pontos (máximo: 5 estrelas em cada critério). Este valor é usado para organizar o ranking geral.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),

            // Armazenamento
            Text(
              'Armazenamento de Dados',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Todos os dados são armazenados localmente no seu dispositivo utilizando SharedPreferences. Isso significa que suas informações permanecem privadas e não são enviadas para servidores externos.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),

            // Tema
            Text(
              'Tema Claro e Escuro',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'O aplicativo permite alternar entre tema claro e tema escuro em tempo de execução. Acesse as configurações na tela inicial para mudar o tema de sua preferência.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 40),

            // Footer
            Center(
              child: Text(
                'Desenvolvido com ❤️ em Flutter',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
